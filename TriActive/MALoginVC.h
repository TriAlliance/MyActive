//
//  TALoginVC.h
//  TriActive
//
//  Created by Ketan on 05/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevealController.h"
#import "SlideInnerViewController.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
@interface MALoginVC : UIViewController
{
    __weak IBOutlet UIImageView *imgVw_Background;
    __weak IBOutlet UILabel *lbl_AppName;
    __weak IBOutlet UITextField *txtFld_Username;
    __weak IBOutlet UITextField *txtFldPassword;
    
}
- (IBAction)btnPressed_Facebook:(id)sender;
- (IBAction)btnPressed_Twitter:(id)sender;
- (IBAction)btnPressed_Signin:(id)sender;
@property (strong, nonatomic) RevealController *revealViewController;

@end
