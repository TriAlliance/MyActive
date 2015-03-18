//
//  MAActivityMenuVC.h
//  MyActive
//
//  Created by Ketan on 31/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HealthKit;
#import "HKManager.h"
#import "HKHealthStore+AAPLExtensions.h"
@interface MyDashActivityVC : UIViewController
{
    __weak IBOutlet UIImageView *imgVw_Graph;
    __weak IBOutlet UIScrollView *scrollVw_Container;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UIPickerView *picker_Activity;
    NSMutableArray * arrActivity;
    NSString * pickerType;
    __weak IBOutlet UITextField *txtFld_ActiveCal;
    __weak IBOutlet UITextField *txtFld_RestingCal;
    __weak IBOutlet UITextField *txtFld_TotalCal;
    __weak IBOutlet UITextField *txtFld_Weight;
    __weak IBOutlet UITextField *txtFld_ActLevel;

    HKHealthStore *store;
}
- (IBAction)btnPressed_Save:(id)sender;
- (IBAction)btnPressed_Cancel:(id)sender;

- (IBAction)btnPressed_ActLevel:(id)sender;
@property (retain,nonatomic) HKHealthStore *healthStore;
@property(nonatomic, strong) NSMutableDictionary * dict_MyDashData;
@end
