//
//  TAViewController.m
//  TriActive
//
//  Created by Ketan on 03/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MARegisterVC.h"
#import "MAHomeVC.h"
#import "CustomTabBarController.h"

@interface MARegisterVC ()

@end

@implementation MARegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [Utility backGestureDisable:self];
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Register"];
    PlaceholderTextColor(txtFld_ConfirmPass);
    PlaceholderTextColor(txtFld_Email);
    PlaceholderTextColor(txtFld_Fname);
    PlaceholderTextColor(txtFld_Lname);
    PlaceholderTextColor(txtFld_Password);
    PlaceholderTextColor(txtFld_Uname);
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

#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(IS_IPHONE_5 ||IS_IPHONE_6 || IS_IPHONE_6_PLUS)
    {
        if (textField == txtFld_Uname || textField == txtFld_Password || textField == txtFld_ConfirmPass) {
            [Utility slideVwUp:-215 :self];
        }
        else if (textField == txtFld_Lname || textField == txtFld_Email) {
            [Utility slideVwUp:-115 :self];
        }
        
    }
    if (IS_IPHONE_4) {
        
        if (textField == txtFld_Uname || textField == txtFld_Password || textField == txtFld_ConfirmPass) {
            [Utility slideVwUp:-215 :self];
        }
        else if (textField == txtFld_Lname || textField == txtFld_Email) {
            [Utility slideVwUp:-115 :self];
        }
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(IS_IPHONE_5 ||IS_IPHONE_6 || IS_IPHONE_6_PLUS)
    {
        if (textField == txtFld_Uname || textField == txtFld_Password || textField == txtFld_ConfirmPass) {
            [Utility slideVwUp:215 :self];
        }
        else if (textField == txtFld_Lname || textField == txtFld_Email) {
            [Utility slideVwUp:115 :self];
        }
        
    }
    if (IS_IPHONE_4) {
        
        if (textField == txtFld_Uname || textField == txtFld_Password || textField == txtFld_ConfirmPass) {
            [Utility slideVwUp:215 :self];
        }
        else if (textField == txtFld_Lname || textField == txtFld_Email) {
            [Utility slideVwUp:115 :self];
        }
    }
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed_Register:(id)sender {
    [self.view endEditing:YES];
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
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
        
        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        NSLog(@"%@",ApplicationDelegate.latitude);
        NSLog(@"%@",ApplicationDelegate.longitude);
        
        [userInfo setValue:ApplicationDelegate.latitude forKey:@"lat"];
        [userInfo setValue:ApplicationDelegate.longitude forKey:@"lng"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Fname.text) forKey:@"first_name"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Lname.text) forKey:@"last_name"];
        [userInfo setValue:txtFld_Email.text forKey:@"email"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Uname.text) forKey:@"username"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Password.text) forKey:@"password"];
        if (base64 == nil) {
            [userInfo setValue:nil forKey:@"profile_image"];
            NSLog(@"imageData--%@",base64);
        }else
        {
            [userInfo setValue:base64 forKey:@"profile_image"];
        }
        [userInfo setValue:token forKey:@"device_token"];
        [ApplicationDelegate show_LoadingIndicator];
        [API registerUserWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            
            if([responseDict valueForKey:@"data"])
            {
                
                NSLog(@"created_at:%@", [[responseDict valueForKey:@"data"]valueForKey:@"created_at"]);
                
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
                
                MALog(@"userDetails--%@",userDetails);
                
                
                SlideInnerViewController *sliderVcObj=VCWithIdentifier(@"SlideInnerViewController");
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:Obj_Home];
                
                RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:sliderVcObj];
                
                self.revealViewController = revealController;
                ApplicationDelegate.window.rootViewController = self.revealViewController;
                //            [self.navigationController pushViewController:Obj_Home animated:YES];
            }
            else if([[responseDict valueForKey:@"result"] intValue] == 0)
            {
                [ApplicationDelegate showAlert:@"Email already exists"];
            }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
}

- (IBAction)btnAddPic:(id)sender
{
    picker = [[GKImagePicker alloc] init];
    picker.delegate = self;
    picker.cropper.cropSize = CGSizeMake(320.0,320.0);
    [picker presentPicker];
}
#pragma mark - GKImagePicker delegate methods

- (void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image
{
    imageData = UIImageJPEGRepresentation(image, 0.1);
    base64 = [[NSString alloc] initWithString:[Base64 encode:imageData]];
    [btn_ProfilePic setBackgroundImage:image  forState:UIControlStateNormal];
    btn_ProfilePic.layer.cornerRadius = 39; // this value vary as per your desire
    btn_ProfilePic.clipsToBounds = YES;
}

-(void)removeImage
{
    MALog(@"RemoveImg");
    imageData = nil;
    [btn_ProfilePic setBackgroundImage:[UIImage imageNamed:@"add-profile-icon.png"] forState:UIControlStateNormal];
    
}

- (NSString *)validateForm {
    NSString *errorMessage;
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (imageData == nil){
        errorMessage = @"Please add profile image";
    }
    else if (!(txtFld_Fname.text.length >= 1)){
        errorMessage = @"Please enter a first name";
    }
    else if (!(txtFld_Lname.text.length >= 1)){
        errorMessage = @"Please enter a last name";
    }
    else if (!(txtFld_Email.text.length >= 1)){
        errorMessage = @"Please enter email address";
    }
    else if (![emailPredicate evaluateWithObject:txtFld_Email.text]){
        errorMessage = @"Please enter valid email address";
    }
    else if (!(txtFld_Uname.text.length >= 1)){
        errorMessage = @"Please enter username";
    }
    
    else if(!(txtFld_Password.text.length >=1)){
        errorMessage = @"Please enter password";
    }
    else if((txtFld_Password.text.length < 6) ){
        errorMessage = @"Minimum password length should be six character";
    }
    else if(!(txtFld_ConfirmPass.text.length >= 1)){
        errorMessage = @"Please enter confirm password";
    }
    else{
        
        if([txtFld_Password.text isEqualToString:txtFld_ConfirmPass.text]){
            errorMessage = nil;
        }
        else{
            errorMessage = @"Password do not match";
        }
    }
    
    
    return errorMessage;
}

@end
