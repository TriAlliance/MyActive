//
//  MyDashNutritionVC.h
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKManager.h"
@interface MyDashNutritionVC : UIViewController
{
    __weak IBOutlet UIImageView *imgVw_Graph;
    __weak IBOutlet UITextField *txtFld_Weight;
    __weak IBOutlet UITextField *txtFld_DietaryCal;
     __weak IBOutlet UITextField *txtFld_BMR;
    NSMutableArray * arrActivity;
    NSString * pickerType;
}
- (IBAction)btnPressed_Save:(id)sender;
- (IBAction)btnPressed_Cancel:(id)sender;
@property(nonatomic, strong) NSMutableDictionary * dict_MyDashData;
@end
