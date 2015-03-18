//
//  MyDashWellBeingVC.h
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDashWellBeingVC : UIViewController
{
    __weak IBOutlet UIImageView *imgVw_Graph;
    __weak IBOutlet UIScrollView *scrollVw_Container;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UITextField *txtFld_Mood;
    
    __weak IBOutlet UITextField *txtFld_Energy;
    __weak IBOutlet UIPickerView *picker_WellBeing;
    NSMutableArray * arrActivity;
    NSString * pickerType;
}
- (IBAction)btnPressed_Save:(id)sender;
- (IBAction)btnPressed_Cancel:(id)sender;
- (IBAction)btnPressed_Mood:(id)sender;
- (IBAction)btnPressed_Energy:(id)sender;
@property(nonatomic, strong) NSMutableDictionary * dict_MyDashData;
@property(nonatomic, strong) NSString * energyPercentage;
@property(nonatomic, strong) NSString * moodPercentage;
@end
