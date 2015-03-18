//
//  MAInviteFriendVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 06/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MAInviteFriendVC.h"

@interface MAInviteFriendVC ()

@end

@implementation MAInviteFriendVC

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
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Invite Friends"];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(sendInvite)];
    self.navigationController.navigationBar.translucent = NO;
    arrInvite =[[NSMutableArray alloc]init];
    arraySuggestPeople =[[NSMutableArray alloc]init];
    arrTwitter=[[NSMutableArray alloc]init];
    phoneNum=[[NSMutableArray alloc] init];
    if([_keyword isEqualToString:@"Facebook"]){
        [arrInvite removeAllObjects];
        [self callFacebook];
        }
    else  if([_keyword isEqualToString:@"Contacts"]){
         [arrInvite removeAllObjects];
          arrInvite = [Utility fetchContacts];
        [tblVW_invitations reloadData];
          NSLog(@" userInfo: %@", arrInvite );
    }
    else{
        
           [arrInvite removeAllObjects];
            [self callTwitter];
        }
    
    [Utility swipeSideMenu:self];
}
#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)leftBtn
{
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
        
        [self.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil afterDelay:0.0];
    }
}
-(void)callFacebook{
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
-(void)sendInvite
{
    
    if([_keyword isEqualToString:@"Contacts"]){
        [self sendSMS:@"Please like MyActive app" recipientList:phoneNum];
    }
    if([_keyword isEqualToString:@"Twitter"]){
        [self sendTwitterDM];
    }
   
    if([_keyword isEqualToString:@"Facebook"]){
        
        NSString * stringOfFriends = [arraySuggestPeople componentsJoinedByString:@","];
        
         NSMutableDictionary* params =
        [NSMutableDictionary dictionaryWithObject:stringOfFriends forKey:@"to"];
        
        NSString *message = @"Please join MyActive app";
        NSString *title = @"MyActive";
        
        [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                      message:message
                                                        title:title
                                                   parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                       if (error)
                                                       {
                                                           // Case A: Error launching the dialog or sending request.
                                                           NSLog(@"Error sending request.");
                                                       }
                                                       else
                                                       {
                                                           if (result == FBWebDialogResultDialogNotCompleted)
                                                           {
                                                               // Case B: User clicked the "x" icon
                                                               NSLog(@"User canceled request.");
                                                           }
                                                           else
                                                           {
                                            //[arrInvite removeAllObjects];
                                                        //[self callFacebook];
                                                                           NSLog(@"Request Sent. %@", params);
                                                           }
                                                           [tblVW_invitations reloadData];
                                                       }}];            //[arraySuggestPeople }addObject:arrAdd];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendTwitterDM{
   
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
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
       [ApplicationDelegate showAlert:@"There are no Twitter accounts configured. You can add or create a Twitter account in the main Settings section of your phone device"];
    }
    
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
                 for(int i=0;i<[arrTwitter count];i++){
                 //create this request
                
                 SLRequest *twitterRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                          requestMethod:SLRequestMethodPOST
                                                                    URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"]
                                                  parameters:[arrTwitter objectAtIndex:i ]];
                 [twitterRequest setAccount:acct];
                 [twitterRequest performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
                     
                     NSMutableArray *response=[[NSMutableArray alloc]init];
                     response=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    NSLog(@" responseData: %@", response );
                    
                     if (!error) {
                         
                        
                     }
          
                    [tblVW_invitations reloadData];
                     if ([ApplicationDelegate isHudShown]) {
                         [ApplicationDelegate hide_LoadingIndicator];
                     }
                     else {
                         if ([ApplicationDelegate isHudShown]) {
                             [ApplicationDelegate hide_LoadingIndicator];
                         }
                         
                     }
                     
                 }];
              }
             [ arrTwitter removeAllObjects];
            }
         }
     }];

    }
-(void)callTwitter{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
    NSString * userName;
     [ApplicationDelegate show_LoadingIndicator];
    if ([arrayOfAccounts count] > 0)
    {
       
        ACAccount *twitterAccount = [arrayOfAccounts objectAtIndex:0];
        userName = twitterAccount.username;
        NSLog(@"twitterAccount%@",twitterAccount);
        NSLog(@"%@",twitterAccount.accountType);
    }
    else
    {
        
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
          [ApplicationDelegate showAlert:@"There are no Twitter accounts configured. You can add or create a Twitter account in the main Settings section of your phone device"];
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
                                                  URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"]
                                              parameters:params];
                 [twitterRequest setAccount:acct];
                 [twitterRequest performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
                     
                     NSMutableArray *response=[[NSMutableArray alloc]init];
                     response=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    NSLog(@" responseData: %@", [response valueForKey:@"users"] );
                   NSMutableDictionary *arrAdd = [[NSMutableDictionary alloc] init];
                     if (!error) {
                         [arrAdd setValue:[[response valueForKey:@"users"]valueForKey:@"name"] forKey:@"name"];
                         [arrAdd setValue:[[response valueForKey:@"users"]valueForKey:@"profile_image_url"] forKey:@"profile_image"];
                         [arrAdd setValue:[[response valueForKey:@"users"]valueForKey:@"screen_name"] forKey:@"screen_name"];
                         [arrAdd setValue:[[response valueForKey:@"users"]valueForKey:@"id"] forKey:@"twitter_id"];
                         [arrInvite addObject:arrAdd];
                         NSLog(@" arrInvite: %@", arrInvite );
                        [tblVW_invitations reloadData];
                      }
                    
                     if ([ApplicationDelegate isHudShown]) {
                         [ApplicationDelegate hide_LoadingIndicator];
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
#pragma mark
#pragma mark Table View DataSource/Delegates
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_keyword isEqualToString:@"Contacts"]){
        if([arrInvite count]){
            return [arrInvite  count];
        }
        else{
            return 0;
        }
    }
    else {
       if([arrInvite count]){
           MALog(@"%li",[[arrInvite  valueForKey:@"name" ] count]);
           return [[[arrInvite  objectAtIndex:0] valueForKey:@"name" ] count];
        }
       else{
        return 0;
       }
     }
   }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cellinvite";
    UIImageView* profileImageVw;
    UIButton* btnInvite;
    UILabel* lblDesc;
    UILabel* lblMsg;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if([arrInvite  count]){
        profileImageVw = (UIImageView *)[cell.contentView viewWithTag:101];
        if(profileImageVw)
        {
            if([_keyword isEqualToString:@"Contacts"]){
              if([UIImage imageWithData:[[arrInvite valueForKey:@"profile_image"]  objectAtIndex:indexPath.row]] == nil){
                [profileImageVw setImage:[UIImage imageNamed:@"PicPlaceholder.png"]];
              }
              else{
              [profileImageVw setImage:[UIImage imageWithData:[[arrInvite valueForKey:@"profile_image"]  objectAtIndex:indexPath.row]]];
              }
            }
            else{
                [profileImageVw sd_setImageWithURL:[NSURL URLWithString:[[[arrInvite objectAtIndex:0] valueForKey:@"profile_image"]  objectAtIndex:indexPath.row]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                
            }
            profileImageVw.layer.cornerRadius=20.0;
            profileImageVw.layer.masksToBounds = YES;
        }
        lblDesc = (UILabel *)[cell.contentView viewWithTag:102];
        if(lblDesc)
        {
             if([_keyword isEqualToString:@"Contacts"]){
              lblDesc.text=[NSString stringWithFormat:@"%@  %@",[[arrInvite objectAtIndex:indexPath.row] valueForKey:@"firstName"],[[arrInvite objectAtIndex:indexPath.row] valueForKey:@"lastName"]];
            }
            else{
            lblDesc.text=[NSString stringWithFormat:@"%@",[[[arrInvite objectAtIndex:0]  valueForKey:@"name"] objectAtIndex:indexPath.row] ];
            }
        }
        lblMsg = (UILabel *)[cell.contentView viewWithTag:111];
        if(lblMsg)
        {
             if([_keyword isEqualToString:@"Contacts"]){
               lblMsg.text=@"Invitation will  be sent via SMS" ;
             }
            else if([_keyword isEqualToString:@"Facebook"]){
                lblMsg.text=@"Invitation will  be sent via Facebook" ;
            }
            else{
                lblMsg.text=@"Invitation will  be sent via Twitter DM" ;
            }
        }
        btnInvite=(UIButton *)[cell viewWithTag:103];
        if(btnInvite){
        [btnInvite setSelected:NO];
        [btnInvite setBackgroundImage:[UIImage imageNamed:@"box_uncheck.png"] forState:UIControlStateSelected];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
             { NSDictionary *dictfb=[[NSMutableDictionary alloc]init];
                 dictfb=user;
                 NSLog(@"The fb dict is---%@",dictfb );
                 [FBRequestConnection startWithGraphPath:@"/me/invitable_friends" parameters:nil
                                              HTTPMethod:@"GET"
                                       completionHandler:^(
                                                           FBRequestConnection *connection,
                                                           id result,
                                                           NSError *error
                                                           ) {
                                           //handle the result
                                           NSLog(@"RESULT : %@",[result valueForKey:@"data"]);
                                          
                                           
                                           NSDictionary* userInfo = @{
                                                                    @"name":[[result valueForKey:@"data"] valueForKey:@"name"],
                                              @"facebook_id":[[result valueForKey:@"data"] valueForKey:@"id"],
                                             @"profile_image":[[[[result valueForKey:@"data"] valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"]
                                            };
                                           [arrInvite addObject:userInfo];
                                           MALog(@"%@userInfo",userInfo);
                                            [tblVW_invitations reloadData];
                                       }];
                 
             }
         }];
      
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        [ApplicationDelegate hide_LoadingIndicator];
        
        return ;
    }
}

- (IBAction)btnPressed_invite:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVW_invitations];
        NSIndexPath *indexPath = [tblVW_invitations indexPathForRowAtPoint:buttonPosition];
        MALog(@"follow-indexPath--%ld",(long)indexPath.row);
      if(btn.isSelected){
            [btn setBackgroundImage:[UIImage imageNamed:@"box_uncheck.png"] forState:UIControlStateNormal];
            [btn setSelected:NO];
            if([_keyword isEqualToString:@"Facebook"]){
            [arraySuggestPeople removeObject:[[[arrInvite objectAtIndex:0]  valueForKey:@"facebook_id"] objectAtIndex:indexPath.row]];
                
            }
            if([_keyword isEqualToString:@"Contacts"]){
                [phoneNum removeObject: [[arrInvite objectAtIndex:indexPath.row] valueForKey:@"phoneNumber"]];
            }
            if([_keyword isEqualToString:@"Twitter"]){
              NSDictionary *tempDict=@{@"screen_name":[[[arrInvite      objectAtIndex:0]  valueForKey:@"screen_name"] objectAtIndex:indexPath.row],
                                       @"user_id":[[[arrInvite objectAtIndex:0]  valueForKey:@"twitter_id"] objectAtIndex:indexPath.row],
                                       @"text":@"Please download MyActive form App Store"
                                       
                                       };

             [arrTwitter removeObject:tempDict];
           }
        }
        else{
                if([_keyword isEqualToString:@"Facebook"]){
                 [arraySuggestPeople addObject:[[[arrInvite objectAtIndex:0]  valueForKey:@"facebook_id"] objectAtIndex:indexPath.row]];
                }
                if([_keyword isEqualToString:@"Contacts"]){
                    [phoneNum addObject: [[arrInvite objectAtIndex:indexPath.row] valueForKey:@"phoneNumber"]];
                }
                if([_keyword isEqualToString:@"Twitter"]){
                NSDictionary *tempDict=@{@"screen_name":[[[arrInvite      objectAtIndex:0]  valueForKey:@"screen_name"] objectAtIndex:indexPath.row],
                                         @"user_id":[[[arrInvite objectAtIndex:0]  valueForKey:@"twitter_id"] objectAtIndex:indexPath.row],
                                         @"text":@"Please download MyActive form App Store"
                                         
                                         };
                  [arrTwitter addObject:tempDict];
            }
             [btn setBackgroundImage:[UIImage imageNamed:@"box_checked.png"] forState:UIControlStateSelected];
             [btn setSelected:YES];
   }
     MALog(@"arraySuggestPeople--%@",arraySuggestPeople);
     MALog(@"phone--%@",phoneNum);
     MALog(@"arrTwitter--%@",arrTwitter);
}
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
       [self presentViewController:controller animated:NO completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
   [self dismissViewControllerAnimated:NO completion:nil];
        if (result == MessageComposeResultCancelled)
            NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
        else 
            NSLog(@"Message failed");
    [tblVW_invitations reloadData];
}
@end
