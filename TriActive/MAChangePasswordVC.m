//
//  MAChangePasswordVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 15/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAChangePasswordVC.h"
#import "MAPostVC.h"
@interface MAChangePasswordVC ()

@end

@implementation MAChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Change Password"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(changePassword)];
    self.navigationController.navigationBar.translucent = NO;

}
-(void)changePassword{

    [self.view endEditing:YES];
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        
        NSLog(@"response :%@", errorMessage);
        
    }
    else{
         NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:encodeToPercentEscapeString(txtfld_oldPwd.text) forKey:@"old_password"];
        [userInfo setValue:encodeToPercentEscapeString(txtfld_newPwd.text) forKey:@"new_password"];
        [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id" ];
       [ApplicationDelegate show_LoadingIndicator];
        [API changePasswordWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            
           if([[responseDict valueForKey:@"result"] intValue] == 1)          {
               [[[UIAlertView alloc] initWithTitle:AppName message:@"Password changed sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
               
             }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0){
      [self.navigationController popViewControllerAnimated:YES];
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
//    if(iOSVersion<8.0)
//    {
//        if (textField == txtfld_oldPwd) {
//            [Utility slideVwUp:-215 :self];
//        }
//        
//        if (!IS_IPHONE_5) {
//            if (textField == txtfld_newPwd || textField == txtfld_confirmPwd) {
//                [Utility slideVwUp:-115 :self];
//            }
//        }
//    }
//    
//    if(iOSVersion==8.0)
//    {
//        if (textField == txtFld_Uname) {
//            [Utility slideVwUp:-250 :self];
//        }
//        
//    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(iOSVersion<8.0)
    {
//        if (textField == txtFld_Uname) {
//            [Utility slideVwUp:215 :self];
//        }
//        
//        if (!IS_IPHONE_5) {
//            if (textField == txtFld_Lname) {
//                [Utility slideVwUp:115 :self];
//            }
//        }
//        
    }
    if(iOSVersion==8.0)
    {
//        if (textField == txtFld_Uname) {
//            [Utility slideVwUp:250 :self];
//        }
//        
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)validateForm {
    NSString *errorMessage;
    if((txtfld_newPwd.text.length >= 1) && (txtfld_confirmPwd.text.length >=1)){
        if([txtfld_newPwd.text isEqualToString:txtfld_confirmPwd.text]){
            errorMessage = nil;
        }
        else{
            errorMessage = @"Password do not match";
        }
    }
    else{
        errorMessage = @"Please enter password";
    }
    
    
    return errorMessage;
}
@end
