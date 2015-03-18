//
//  MAAddGroupsVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 16/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"
#import "MAAddLocationVC.h"
#import "MAUserGrpEventVC.h"
#import "MAHomeVC.h"
#import "Base64.h"
@interface MAAddGroupsVC : UIViewController<GKImagePickerDelegate,locationDelegate,userListDelegate>
{
    GKImagePicker *picker;
     NSData *imageData;
     NSString *strPeople;
     NSString *strLoc;
     NSString *strLocLat;
     NSString *strLocLong;
     NSString * base64;
    __weak IBOutlet UITextField *txtGrpName;
    __weak IBOutlet UITextView *txtDescView;
    __weak IBOutlet UIImageView *imgGrpPhoto;
    __weak IBOutlet UIButton *txtBtn_addPeople;
      __weak IBOutlet UILabel *lblAddPeople;
    __weak IBOutlet UIScrollView *scrollVw_Container;
    __weak IBOutlet UIButton *btnType;
    __weak IBOutlet UITextField *txtFld_Type;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UIPickerView *picker_Type;
    NSArray * arrType;
    __weak IBOutlet UIButton *btnAddGrp;
    __weak IBOutlet UIButton *btnEditcover;
 
}
- (IBAction)btnPressed_Type:(id)sender;
- (IBAction)btnAddGrp:(id)sender;
- (IBAction)btnPressed_addPeople:(id)sender;
- (IBAction)btnSelectLoc:(id)sender;
- (IBAction)btnPressed_AddCoverPic:(id)sender;

@property(nonatomic, strong) NSMutableArray * arrEditData;
@end
