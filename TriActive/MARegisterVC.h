//
//  TAViewController.h
//  TriActive
//
//  Created by Ketan on 03/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"
#import "RevealController.h"
#import "SlideInnerViewController.h"
#import "Base64.h"
@interface MARegisterVC : UIViewController<GKImagePickerDelegate>
{
    GKImagePicker *picker;
    __weak IBOutlet UIImageView *imgVw_Background;
    __weak IBOutlet UITextField *txtFld_Fname;
    __weak IBOutlet UITextField *txtFld_Lname;
    __weak IBOutlet UITextField *txtFld_Email;
    __weak IBOutlet UITextField *txtFld_Uname;
    __weak IBOutlet UITextField *txtFld_Password;
    __weak IBOutlet UITextField *txtFld_ConfirmPass;
    __weak IBOutlet UIButton *btn_ProfilePic;
    NSData *imageData ;
    NSString * base64;

}
- (IBAction)btnPressed_Register:(id)sender;
- (IBAction)btnAddPic:(id)sender;
@property (strong, nonatomic) RevealController *revealViewController;
@end
