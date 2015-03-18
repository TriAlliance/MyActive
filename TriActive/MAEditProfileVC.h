//
//  MAEditProfileVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 15/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"
#import "Base64.h"
#import "RevealController.h"
#import "SlideInnerViewController.h"

@interface MAEditProfileVC : UIViewController<GKImagePickerDelegate,UIAlertViewDelegate>

{
    GKImagePicker *picker;
    __weak IBOutlet UIImageView *imgCoverPhoto;
    __weak IBOutlet UITextField *txtFld_Fname;
    __weak IBOutlet UIImageView *imgProfilePhoto;
    __weak IBOutlet UITextField *txtFld_Lname;
    NSString * base64;
    NSString * base_64;
     NSData *imageData;
     NSData *imageCoverData;
     NSArray *pickerCityData;
     NSArray *pickermarital_sts;
    BOOL isCoverPic;
    BOOL isprofilePic;
    __weak IBOutlet UIScrollView *scrollProfile;
    __weak IBOutlet UIPickerView *pickerCity;
    __weak IBOutlet UIPickerView *pickerMarital_status;
    __weak IBOutlet UITextField *txtFld_City;
    __weak IBOutlet UITextField *txtFld_MaritalSts;
    __weak IBOutlet UIToolbar *toolbar_done;
    __weak IBOutlet UILabel *lblFld_Uname;

    __weak IBOutlet UILabel *lblFld_Email;
    __weak IBOutlet UITextView *txtView_description;
    __weak IBOutlet UIButton *btn_PwdChange;
}
@property (retain, nonatomic) NSDictionary *getUserData;
- (IBAction)btnPressed_changeCoverPic:(id)sender;
- (IBAction)btnPressed_changeProfilePic:(id)sender;
- (IBAction)btnPressed_changePassword:(id)sender;

- (IBAction)btnPressed_addCity:(id)sender;
- (IBAction)btnPressed_addMaritalSts:(id)sender;
- (IBAction)btnPressed_done:(id)sender;

@property (strong, nonatomic) RevealController *revealViewController;
@property (weak, nonatomic) IBOutlet NSString *settingPg;
@end
