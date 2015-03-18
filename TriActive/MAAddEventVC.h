//
//  MAAddEventVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 16/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"
#import "MAAddLocationVC.h"
#import "MAUserGrpEventVC.h"
#import "Base64.h"
#import "MAEventDescVC.h"
//@protocol eventDelegate;
@interface MAAddEventVC : UIViewController<GKImagePickerDelegate,locationDelegate,activityDelegate,userListDelegate>
{
    GKImagePicker *picker;
    NSString *strPeople;
    NSString *strGroup;
    NSString *strLoc;
    NSString *strLocLat;
    NSString *strLocLong;
    NSString * base64;
    __weak IBOutlet UITextField *txtFld_activityName;
    __weak IBOutlet UITextField *txtFld_eventName;
    NSData *imageData;
    __weak IBOutlet UIImageView *imgEventPhoto;
    
    __weak IBOutlet UITextView *txtView_addDesc;
    __weak IBOutlet UITextField *txtFld_Type;
    __weak IBOutlet UIButton *btn_Type;
    __weak IBOutlet UIButton *btn_date;
    __weak IBOutlet UIScrollView *scrollVw_Container;
    __weak IBOutlet UILabel *lblAddGroup;
    __weak IBOutlet UILabel *lblAddPeople;
    __weak IBOutlet UISwitch *switchSelect;
    NSString * switchOn;
    
    NSString * selectDate;
    __weak IBOutlet UIPickerView *picker_Type;
    __weak IBOutlet UIToolbar *toolBar;
    NSArray * arrType;
    __weak IBOutlet UIButton *btnAddEvnt;
    
    __weak IBOutlet UIButton *btnEditcover;
    __weak IBOutlet UIButton *txtBtn_addLocation;
    __weak IBOutlet UIDatePicker *datePicker1;
    __weak IBOutlet UIView *viewDate;
}
-(IBAction)btnPressed_Date:(id)sender;
- (IBAction)btnPressed_Type:(id)sender;
- (IBAction)btnPressed_activityList:(id)sender;
- (IBAction)btnPressed_addPeople:(id)sender;
- (IBAction)btnPressed_coverPic:(id)sender;
- (IBAction)btnPressed_addGroup:(id)sender;
- (IBAction)btnPressed_addEvent:(id)sender;
- (IBAction)btnSelectLoc:(id)sender;
@property(nonatomic, strong) NSMutableArray * arrEditData;
@property(nonatomic, strong) NSArray * arrSelPople;
@end
