//
//  MyDashRecoveryVC.h
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDashRecoveryVC : UIViewController
{
    __weak IBOutlet UIImageView *imgVw_Graph;
    __weak IBOutlet UIScrollView *scrollVw_Container;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UIToolbar *toolBarKeyboard;
    __weak IBOutlet UIPickerView *picker_Recovery;
    __weak IBOutlet UITextField *txtFld_SleepHr;
     __weak IBOutlet UIDatePicker *datePicker1;
     __weak IBOutlet UIDatePicker *datePicker2;
    NSMutableArray * arrActivity;
    NSMutableArray * arrQualitySleep;
    NSString * pickerType;
    
    __weak IBOutlet UITextField *txtFld_SleepHrEnd;


        __weak IBOutlet UITextField *txtFld_sleepQuality;
}
- (IBAction)btnPressed_Save:(id)sender;
- (IBAction)btnPressed_Cancel:(id)sender;
- (IBAction)btnPressed_SleepHrs:(id)sender;
- (IBAction)btnPressed_SleepHrsEnd:(id)sender;
- (IBAction)btnPressed_SleepQuality:(id)sender;
@property(nonatomic, strong) NSMutableDictionary * dict_MyDashData;
@property(nonatomic, strong) NSString * sQuality;
@end
