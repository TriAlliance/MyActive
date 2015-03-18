//
//  TALoginVC.m
//  TriActive
//
//  Created by Ketan on 05/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MALoginVC.h"
#import "MAHomeVC.h"
#import "CustomTabBarController.h"
@interface MALoginVC ()

@end

@implementation MALoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view
    [Utility backGestureDisable:self];
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Sign In"];
    PlaceholderTextColor(txtFld_Username);
    PlaceholderTextColor(txtFldPassword);
    lbl_AppName.font = SIGNIKA_REGULAR(30);
    UIImage * backImg;
    if (IS_IPHONE_5) {
        backImg = [UIImage imageNamed:@"SIgn-in-bg.png"];
    }else
    {
        backImg = [UIImage imageNamed:@"SIgn-in-bg-4s.png"];
    }
    imgVw_Background.image = backImg;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self callSignInAPI];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

//The following code will allow you to only input numbers as well as limit the amount of characters that can be used.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
#pragma mark
#pragma mark UITouch Methods
#pragma mark
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)btnPressed_Facebook:(id)sender {
    [self.view endEditing:YES];
    [ApplicationDelegate show_LoadingIndicator];
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_friends",@"email"]
                        allowLoginUI:YES
                        completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error)
     {
         
         [self sessionStateChanged:session state:state error:error];
         
     }];
}
#pragma mark
#pragma mark <Change facebook session state>
#pragma mark
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state==FBSessionStateOpen)
    {
        
        
        NSLog(@"Session opened");
        
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
         {
             
             if (error)
             {
                 [ApplicationDelegate hide_LoadingIndicator];
                 NSLog(@"error:%@",error);
             }
             else
             {
                
                 NSDictionary *dictfb=[[NSMutableDictionary alloc]init];
                 dictfb=user;
                 
//                 [FBRequestConnection startWithGraphPath:@"me/picture?redirect=0&height=200&type=normal&width=200"
//                                              parameters:nil
//                                              HTTPMethod:@"GET"
//                                       completionHandler:^(
//                                                           FBRequestConnection *connection,
//                                                           id result,
//                                                           NSError *error
//                                                           ) {
//                                           NSLog(@"RESULT : %@",[[result valueForKey:@"data"] valueForKey:@"url"]);
//                                       }];
                                           //handle the result
                                           //                                           NSLog(@"RESULT : %@",[[result valueForKey:@"data"] valueForKey:@"url"]);}
                                           

                NSLog(@"The fb dict is---%@",dictfb );
                
                NSString * token;
                  NSString * email;
                 if([UserDefaults valueForKey:@"DToken"]){
                     token = [UserDefaults valueForKey:@"DToken"];
                 }
                 else{
                token=@"e0a90ca70a8bc926e99b2e00fe076e5beb160bc88157baa65bab409a49faafbc";
                 }
                 if([dictfb valueForKey:@"email"]){
                     email = [dictfb valueForKey:@"email"];
                 }
                 else{
                     email=@"";
                 }
                 [UserDefaults setObject:[NSString stringWithFormat:@"%@",[dictfb valueForKey:@"name"]] forKey:@"fbname"];
                 [UserDefaults synchronize];
                NSDictionary* userInfo = @{
                                            @"username":[dictfb valueForKey:@"name"],
                                            @"first_name":[dictfb valueForKey:@"first_name"],
                                            @"facebook_id":[dictfb valueForKey:@"id"],
                                            @"last_name":[dictfb valueForKey:@"last_name"],
                                            @"email":email,
                                            @"lat":ApplicationDelegate.latitude,
                                            @"lng":ApplicationDelegate.longitude,
                                            @"device_token":token,
                                            @"profile_image":[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [dictfb valueForKey:@"id"]]],
                                             @"login_type":@"facebook"};
                  
                
                 [API LoginUserWithFacebookInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                     if([[responseDict valueForKey:@"result"] intValue] == 1)
                     {
                          [ApplicationDelegate hide_LoadingIndicator];
                         CustomTabBarController *Obj_Home = VCWithIdentifier(@"CustomTabBarController");
                         MALog(@"responseDict---%@",responseDict);
                         NSMutableDictionary * userDetails = [[NSMutableDictionary alloc]init];
                         
                         [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"city"] forKey:@"city"];
                         [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"description"] forKey:@"description"];
                         [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"email"] forKey:@"email"];
                         [userDetails setValue:[NSString stringWithFormat:@"%@ %@",[[responseDict valueForKey:@"data"]valueForKey:@"first_name"],[[responseDict valueForKey:@"data"]valueForKey:@"last_name"]] forKey:@"name"];
                         [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"email"] forKey:@"emailid"];
                         [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"profile_image"] forKey:@"profile_image"];
                         [UserDefaults setObject:userDetails forKey:@"userDetails"];
                         [UserDefaults setValue:[[responseDict valueForKey:@"data"]valueForKey:@"id"] forKey:@"user_id"];
                         [UserDefaults setValue:[[responseDict valueForKey:@"data"]valueForKey:@"username"] forKey:@"username"];
                         
                         [UserDefaults synchronize];
                          // MALog(@"userDetails--%@",userDetails);
                         SlideInnerViewController *sliderVcObj=VCWithIdentifier(@"SlideInnerViewController");
                         
                         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:Obj_Home];
                         
                         RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:sliderVcObj];
                         
                         self.revealViewController = revealController;
                         ApplicationDelegate.window.rootViewController = self.revealViewController;
                         
                     }
                     else if ([[responseDict valueForKey:@"message"] isEqualToString:@"Invalid login details"])
                     {
                         [ApplicationDelegate showAlert:@"Invalid login details"];
                     }
                     else
                     {
                         [ApplicationDelegate showAlert:@"If you donot redirect to home for 30 sec then click Facebook again"];
                     }
                     if ([ApplicationDelegate isHudShown]) {
                         [ApplicationDelegate hide_LoadingIndicator];
                     }
                 }];
           
            
                 }
             
         }];
    }
    
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        [ApplicationDelegate hide_LoadingIndicator];
        
        return ;
    }
    
}
///Close of session method
//    NSLog(@"%@",[FBSession activeSession].accessTokenData.accessToken);
//    accessToken=[FBSession activeSession].accessTokenData.accessToken;
//    if (!FBSession.activeSession.isOpen)
//    {
//        // [AppDelegate setFacebookTap:@"Facebook"];
//        // if the session is closed, then we open it here, and establish a handler for state changes
//        [FBSession openActiveSessionWithReadPermissions: @[@"public_profile", @"user_birthday", @"user_photos"] allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState state,NSError *error)
//        {
//
//    if (session.state == FBSessionStateOpen)
//    {
//   [[FBRequest requestForMe] startWithCompletionHandler:
//                 ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
//    {
//    if (!error)
//
//    {
//        NSLog(@"accesstoken %@",[NSString stringWithFormat:@"%@",session.accessTokenData]);
//                 NSLog(@"user id %@",user.objectID);
//                 NSLog(@"Email %@",[user objectForKey:@"email"]);
//                 NSLog(@"User Name %@",user.username);
//                 }
//
//                 else
//                     {
//                kCustomAlertWithParam(error.localizedDescription);
//                     }
//                 }];
//       }
//
//        }];
//        
//        }
//}
- (IBAction)btnPressed_Twitter:(id)sender {
    [self.view endEditing:YES];
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
    NSString * userName;
    if ([arrayOfAccounts count] > 0)
    {
        [ApplicationDelegate show_LoadingIndicator];
        ACAccount *twitterAccount = [arrayOfAccounts objectAtIndex:0];
        userName = twitterAccount.username;
        NSLog(@"twitterAccount%@",twitterAccount);
        NSLog(@"%@",twitterAccount.accountType);
    }
    else
    {
        MALog(@"There are no Twitter accounts configured. You can add or create a Twitter account in the main Settings section of your phone device");
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"screen_name", nil];
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
     {
         // Did user allow us access?
         if (granted == YES)
         {
             // Populate array with all available Twitter accounts
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             if ([arrayOfAccounts count] > 0)
             {
                 // Keep it simple, use the first account available
                 ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                 //create this request
                 SLRequest* twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                requestMethod:SLRequestMethodGET
                                                                          URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"]
                                                                   parameters:params];
                 
                 
                 [twitterRequest setAccount:acct];
                 [twitterRequest performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
               
                     NSMutableArray *response=[[NSMutableArray alloc]init];
                     response=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                      NSLog(@" responseData: %@", response );
                     //                     if ([ApplicationDelegate isHudShown]) {
                     //                         [ApplicationDelegate hide_LoadingIndicator];
                     //                     }
                     if (!error) {
                         NSString * token;
                         if([UserDefaults valueForKey:@"DToken"]){
                             token = [UserDefaults valueForKey:@"DToken"];
                         }
                         else{
                            token=@"e0a90ca70a8bc926e99b2e00fe076e5beb160bc88157baa65bab409a49faafbc";
                         }
             NSString * twitterDesc;
                         if([params valueForKey:@"description"] != nil){
                          twitterDesc=[params valueForKey:@"description"];
                         }
                         else
                           twitterDesc=@" ";
                         twitterDesc=[params valueForKey:@"description"];
                         [UserDefaults setObject:[NSString stringWithFormat:@"%@",[response valueForKey:@"screen_name"]] forKey:@"twitterName"];
                         
                         [UserDefaults synchronize];
            NSDictionary* userInfo = @{
                                        @"username":[response valueForKey:@"screen_name"],
                                         @"full_name":[response valueForKey:@"name"],
                                        @"lat":ApplicationDelegate.latitude,
                                        @"lng":ApplicationDelegate.longitude,
                                        @"device_token":token,
                                        @"twitter_id":[response valueForKey:@"id"],
                                        @"location":[response valueForKey:@"location"],
                                        @"profile_image":[response valueForKey:@"profile_image_url"],
                                        @"login_type":@"twitter"};
                         
                         [ApplicationDelegate show_LoadingIndicator];
                         [API LoginUserWithTwitterInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                             if([[responseDict valueForKey:@"result"] intValue] == 1)
                             {
                                 CustomTabBarController *Obj_Home = VCWithIdentifier(@"CustomTabBarController");
                                 
                                 NSMutableDictionary * userDetails = [[NSMutableDictionary alloc]init];
                                 
                                 [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"city"] forKey:@"city"];
                                 [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"description"] forKey:@"description"];
                                 [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"email"] forKey:@"email"];
                                 [userDetails setValue:[NSString stringWithFormat:@"%@ %@",[[responseDict valueForKey:@"data"]valueForKey:@"first_name"],[[responseDict valueForKey:@"data"]valueForKey:@"last_name"]] forKey:@"name"];
                                 [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"email"] forKey:@"emailid"];
                                 [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"profile_image"] forKey:@"profile_image"];
                                 [UserDefaults setObject:userDetails forKey:@"userDetails"];
                                 [UserDefaults setValue:[[responseDict valueForKey:@"data"]valueForKey:@"id"] forKey:@"user_id"];
                                 [UserDefaults setValue:[[responseDict valueForKey:@"data"]valueForKey:@"username"] forKey:@"username"];
                                 
                                 [UserDefaults synchronize];
                                 
                                 // MALog(@"userDetails--%@",userDetails);
                                 SlideInnerViewController *sliderVcObj=VCWithIdentifier(@"SlideInnerViewController");
                                 
                                 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:Obj_Home];
                                 
                                 RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:sliderVcObj];
                                 
                                 self.revealViewController = revealController;
                                 ApplicationDelegate.window.rootViewController = self.revealViewController;
                                 
                             }else if ([[responseDict valueForKey:@"message"] isEqualToString:@"Invalid login details"])
                             {
                                 [ApplicationDelegate showAlert:@"Invalid login details"];
                             }else
                             {
                                 [ApplicationDelegate showAlert:ErrorStr];
                             }
                             if ([ApplicationDelegate isHudShown]) {
                                 [ApplicationDelegate hide_LoadingIndicator];
                             }
                         }];
                     }
                     else {
                         if ([ApplicationDelegate isHudShown]) {
                             [ApplicationDelegate hide_LoadingIndicator];
                         }
                         
                     }
                     
                 }];
                 
             }
         }
     }];
}


- (IBAction)btnPressed_Signin:(id)sender {
    [self.view endEditing:YES];
    [self callSignInAPI];
}

-(void)callSignInAPI
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        
        NSLog(@"response :%@", errorMessage);
        
    }
    else{
        NSString * token;
        if([UserDefaults valueForKey:@"DToken"]){
            token = [UserDefaults valueForKey:@"DToken"];
        }
        else{
            token=@"e0a90ca70a8bc926e99b2e00fe076e5beb160bc88157baa65bab409a49faafbc";
        }
        
        NSDictionary* userInfo = @{
                                   @"username":encodeToPercentEscapeString(txtFld_Username.text),
                                   @"password":txtFldPassword.text,
                                   @"lat":ApplicationDelegate.latitude,
                                   @"lng":ApplicationDelegate.longitude,
                                   @"device_token":token
                                   };
        
        [ApplicationDelegate show_LoadingIndicator];
        [API LoginUserWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            
            if([[responseDict valueForKey:@"result"] intValue] == 1)
            {
                CustomTabBarController *Obj_Home = VCWithIdentifier(@"CustomTabBarController");
                
                NSMutableDictionary * userDetails = [[NSMutableDictionary alloc]init];
                
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"city"] forKey:@"city"];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"description"] forKey:@"description"];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"email"] forKey:@"email"];
                [userDetails setValue:[NSString stringWithFormat:@"%@ %@",[[responseDict valueForKey:@"data"]valueForKey:@"first_name"],[[responseDict valueForKey:@"data"]valueForKey:@"last_name"]] forKey:@"name"];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"email"] forKey:@"emailid"];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"profile_image"] forKey:@"profile_image"];
                [UserDefaults setObject:userDetails forKey:@"userDetails"];
                [UserDefaults setValue:[[responseDict valueForKey:@"data"]valueForKey:@"id"] forKey:@"user_id"];
                [UserDefaults setValue:[[responseDict valueForKey:@"data"]valueForKey:@"username"] forKey:@"username"];
                
                [UserDefaults synchronize];
                
                // MALog(@"userDetails--%@",userDetails);
                SlideInnerViewController *sliderVcObj=VCWithIdentifier(@"SlideInnerViewController");
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:Obj_Home];
                
                RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:sliderVcObj];
                
                self.revealViewController = revealController;
                ApplicationDelegate.window.rootViewController = self.revealViewController;
                
            }else if ([[responseDict valueForKey:@"message"] isEqualToString:@"Invalid login details"])
            {
                [ApplicationDelegate showAlert:@"Invalid login details"];
            }else
            {
                [ApplicationDelegate showAlert:ErrorStr];
            }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
    if (!(txtFld_Username.text.length >= 1)){
        errorMessage = @"Please enter username";
    }
    else if (!(txtFldPassword.text.length >= 1)){
        errorMessage = @"Please enter password";
    }
    return errorMessage;
}
@end
