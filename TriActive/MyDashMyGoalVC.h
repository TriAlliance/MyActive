//
//  MyDashMyGoalVC.h
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"
#import "ELCImagePickerController.h"
#import "Base64.h"
@interface MyDashMyGoalVC : UIViewController<activityDelegate,ELCImagePickerControllerDelegate>
{
    GKImagePicker *picker;    __weak IBOutlet UIImageView *imgVw_Graph;
    __weak IBOutlet UIScrollView *scrollVw_Container;
    NSString *txtActivity;
     NSString *type;
    NSMutableArray * arrEventList;
    NSMutableArray * arrGroupList;

    __weak IBOutlet UITextField *txtFld_goalName;
    __weak IBOutlet UITextField *txtFld_Activity;
__weak IBOutlet UITextField *txtFld_Event;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UIPickerView *pickerEvent;
    __weak IBOutlet UIDatePicker *datePicker1;
    __weak IBOutlet UIDatePicker *datePicker2;
    __weak IBOutlet UITextField *txtFld_startDate;

    __weak IBOutlet UITextField *txtFld_endTime;

    __weak IBOutlet UIImageView *imgView_before;

    __weak IBOutlet UIImageView *imgView_after;
    NSData *imageData ;
    NSString * base64;
    NSData *imageData_b ;
    NSString * base64_b;
}
@property (nonatomic, copy) NSArray *chosenImages;
- (IBAction)btnPressed_Save:(id)sender;
- (IBAction)btnPressed_Cancel:(id)sender;
@property(nonatomic, strong) NSMutableDictionary * dict_MyDashData;

- (IBAction)btnPressed_goal:(id)sender;
- (IBAction)btnPressed_Activity:(id)sender;
- (IBAction)btnPressed_event:(id)sender;
- (IBAction)btnPressed_startDate:(id)sender;
- (IBAction)btnPressed_endDate:(id)sender;
- (IBAction)btnPressed_beforeAfterImage:(id)sender;
@end
