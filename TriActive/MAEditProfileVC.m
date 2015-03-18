//
//  MAEditProfileVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 15/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAEditProfileVC.h"
#import "MAChangePasswordVC.h"
@interface MAEditProfileVC ()

@end

@implementation MAEditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Edit Profile"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveProfile)];
    self.navigationController.navigationBar.translucent = NO;
    scrollProfile.contentSize =CGSizeMake(320,600);
    NSLog(@"data===%@", _getUserData);
    if (_getUserData != nil) {
        txtFld_Fname.text=[_getUserData valueForKey:@"first_name"];
        txtFld_Lname.text=[_getUserData valueForKey:@"last_name"];
        lblFld_Uname.text=[_getUserData valueForKey:@"username"];
        lblFld_Email.text=[_getUserData valueForKey:@"email"];
        txtFld_City.text=[_getUserData valueForKey:@"city"];
        if([[_getUserData valueForKey:@"social_id"] isEqualToString:@"Nil"]){
            [btn_PwdChange setHidden:NO];
       }
        else{
            [btn_PwdChange setHidden:YES];
        }
     if (![[_getUserData valueForKey:@"description"] isEqualToString:@""]) {
            txtView_description.text=[_getUserData valueForKey:@"description"];
            txtView_description.layer.borderColor = [UIColor blackColor].CGColor;
            txtView_description.layer.borderWidth = 1.0f;
        }
        txtFld_MaritalSts.text=[_getUserData valueForKey:@"marital_status"];
        [imgCoverPhoto sd_setImageWithURL:[NSURL URLWithString:[_getUserData valueForKey:@"cover_image"]] placeholderImage:CoverPlaceholder options:SDWebImageRetryFailed];
        [imgProfilePhoto sd_setImageWithURL:[NSURL URLWithString:[_getUserData valueForKey:@"profile_image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];
        
    }
    imgProfilePhoto.layer.cornerRadius = 43.0;
    imgProfilePhoto.layer.borderWidth = 3.0;
    imgProfilePhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    imgProfilePhoto.clipsToBounds = YES;
    pickerCity.backgroundColor = [UIColor lightGrayColor];
    pickerMarital_status.backgroundColor = [UIColor lightGrayColor];
    pickerCity.Hidden=YES;
    pickerMarital_status.hidden=YES;
    toolbar_done.hidden=YES;
    pickerCityData = @[@"Alaska", @"America", @"India", @"London", @"Paris"];
    pickermarital_sts = @[@"Single",@"In a relationship",@"Engaged",@"Married",@"In a civil partnership",@"In a domestic partnership",@"In an open realtionship",@"Is's complicated",@"Seprated",@"Divorce",@"Widowed"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) saveProfile{
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
            token=@"ed38256bbb339aed997652672c77d90e78c637b2914fbbe18daf0765caf2caf9";
        }
        
        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Fname.text) forKey:@"first_name"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Lname.text) forKey:@"last_name"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_City.text) forKey:@"city"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_MaritalSts.text) forKey:@"marital_status"];
        [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"userid" ];
        [userInfo setValue:encodeToPercentEscapeString(txtView_description.text) forKey:@"description"];
        if (imageData == nil) {
            [userInfo setValue:@"" forKey:@"profile_image"];
            NSLog(@"imageData--%@",imageData);
        }else
        {
            [userInfo setValue:base64 forKey:@"profile_image"];
        }
        if (imageCoverData == nil) {
            [userInfo setValue:@"" forKey:@"cover_image"];
            NSLog(@"imageData--%@",imageCoverData);
        }else
        {
            [userInfo setValue:base_64 forKey:@"cover_image"];
        }
        [userInfo setValue:token forKey:@"device_token"];
        
        
        [ApplicationDelegate show_LoadingIndicator];
        [API editUserProfileWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            
            if([[responseDict valueForKey:@"result"] intValue] == 1)
            {
                [UserDefaults removeObjectForKey:@"userDetails"];
                NSMutableDictionary * userDetails = [[NSMutableDictionary alloc]init];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"city"] forKey:@"city"];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"description"] forKey:@"description"];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"email"] forKey:@"email"];
                [userDetails setValue:[NSString stringWithFormat:@"%@ %@",[[responseDict valueForKey:@"data"]valueForKey:@"first_name"],[[responseDict valueForKey:@"data"]valueForKey:@"last_name"]] forKey:@"name"];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"email"] forKey:@"emailid"];
                [userDetails setValue:[[responseDict valueForKey:@"data"]valueForKey:@"profile_image"] forKey:@"profile_image"];
                
                [UserDefaults setObject:userDetails forKey:@"userDetails"];
                [UserDefaults synchronize];
                
                [[[UIAlertView alloc] initWithTitle:AppName message:@"Profile updated sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        
        CustomTabBarController *Obj_Home = VCWithIdentifier(@"CustomTabBarController");
        Obj_Home.selectedIndex = 4;
        SlideInnerViewController *sliderVcObj=VCWithIdentifier(@"SlideInnerViewController");
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:Obj_Home];
        
        RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:sliderVcObj];
        navigationController.navigationBarHidden = YES;
        
        self.revealViewController = revealController;
        ApplicationDelegate.window.rootViewController = self.revealViewController;
//        [self.navigationController popViewControllerAnimated:YES];
    }
}
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

#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(iOSVersion<8.0)
    {
        //        if (textField == txtFld_Uname) {
        //            [Utility slideVwUp:-215 :self];
        //        }
        //
        if (!IS_IPHONE_5) {
            if (textField == txtFld_Lname) {
                [Utility slideVwUp:-115 :self];
            }
        }
    }
    
    if(iOSVersion==8.0)
    {
        //        if (textField == txtFld_Uname) {
        //            [Utility slideVwUp:-250 :self];
        //        }
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(iOSVersion<8.0)
    {
        //        if (textField == txtFld_Uname) {
        //            [Utility slideVwUp:215 :self];
        //        }
        
        if (!IS_IPHONE_5) {
            if (textField == txtFld_Lname) {
                [Utility slideVwUp:115 :self];
            }
        }
        
    }
    if(iOSVersion==8.0)
    {
        //        if (textField == txtFld_Uname) {
        //            [Utility slideVwUp:250 :self];
        //        }
        
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
#pragma mark
#pragma mark TextView Methods
#pragma mark

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    [Utility slideVwUp:-240 :self];
    
    
    if ([textView.text isEqualToString:@"Add description here......"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
    
    [Utility slideVwUp:240 :self];
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add description here......";
        textView.textColor = [UIColor darkGrayColor];
    }
    [textView resignFirstResponder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}


- (NSString *)validateForm {
    NSString *errorMessage;
    
    
    if (!(txtFld_Fname.text.length >= 1)){
        errorMessage = @"Please enter a first name";
    }
    else if (!(txtFld_Lname.text.length >= 1)){
        errorMessage = @"Please enter a last name";
    }
    
    //    else if (!(txtFld_Uname.text.length >= 1)){
    //        errorMessage = @"Please enter username";
    //    }
    //
    
    return errorMessage;
}

- (IBAction)btnPressed_changeCoverPic:(id)sender
{
    isprofilePic=NO;
    isCoverPic=YES;
    picker = [[GKImagePicker alloc] init];
    picker.delegate = self;
    picker.cropper.cropSize = CGSizeMake(320.0,160.0);
    picker.cropper.rescaleFactor = 2.0;
    [picker presentPicker];
}

- (IBAction)btnPressed_changeProfilePic:(id)sender {
    isprofilePic=YES;
    isCoverPic=NO;
    picker = [[GKImagePicker alloc] init];
    picker.delegate = self;
    picker.cropper.cropSize = CGSizeMake(160.0,160.0);
    [picker presentPicker];
}
#pragma mark - GKImagePicker delegate methods

- (void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image
{
    
    if(isprofilePic){
        imageData = UIImageJPEGRepresentation(image, 0.1);
        base64 = [[NSString alloc] initWithString:[Base64 encode:imageData]];
        [imgProfilePhoto setImage:image];
    }
    else if(isCoverPic){
        imageCoverData = UIImageJPEGRepresentation(image, 0.1);
        base_64 = [[NSString alloc] initWithString:[Base64 encode:imageCoverData]];
        [imgCoverPhoto setImage:image];
        
    }
}
-(void)removeImage
{
    MALog(@"RemoveImg");
    if(isprofilePic){
        imageData = nil;
        [imgProfilePhoto setImage:[UIImage imageNamed:@"PicPlaceholder.png"]];
    }
    else if(isCoverPic){
        imageCoverData = nil;
        [imgCoverPhoto setImage:[UIImage imageNamed:@"no_cover.png"]];
        
    }
}


- (IBAction)btnPressed_changePassword:(id)sender
{
    MAChangePasswordVC *objChangePwd=VCWithIdentifier(@"MAChangePasswordVC");
    [self.navigationController pushViewController:objChangePwd animated:YES];
}

- (IBAction)btnPressed_addCity:(id)sender {
    pickerCity.Hidden=NO;
    toolbar_done.hidden=NO;
    pickerMarital_status.Hidden=YES;
}
- (IBAction)btnPressed_addMaritalSts:(id)sender {
    pickerMarital_status.Hidden=NO;
    toolbar_done.hidden=NO;
    pickerCity.Hidden=YES;
}

- (IBAction)btnPressed_done:(id)sender {
    toolbar_done.hidden=YES;
    pickerMarital_status.Hidden=YES;
    pickerCity.Hidden=YES;
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView ==pickerCity){
        return (int)[pickerCityData count];
    }
    else
        return (int)[pickermarital_sts count];
}

#pragma mark- Picker View Delegate


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView ==pickerCity){
        [txtFld_City setText:[pickerCityData objectAtIndex:row]];
    }
    else
        [txtFld_MaritalSts setText:[pickermarital_sts objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView ==pickerCity){
        return pickerCityData[row];
    }
    else
        return pickermarital_sts[row];
}
@end
