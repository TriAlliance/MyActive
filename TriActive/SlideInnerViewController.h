//
//  SlideInnerViewController.h

//  Copyright (c) 2014 Trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RearTableViewCell.h"
#import "RevealController.h"
#import "ZUUIRevealController.h"
#import "CustomTabBarController.h"
#import "MAHomeVC.h"

@interface SlideInnerViewController : UIViewController<ZUUIRevealControllerDelegate>
{
    NSMutableArray *SliderOptionImgArray;
    NSMutableArray *SliderOptionstringArray;
    
    IBOutlet RearTableViewCell *cell;
    __weak IBOutlet UILabel *lbl_Location;
    __weak IBOutlet UILabel *lbl_Name;
    __strong IBOutlet UIImageView *imgVw_Profile;
    __weak IBOutlet UITableView *Tableoult;
    __weak IBOutlet UIButton *btn_Signout;
    __weak IBOutlet UIView * view_ContainerTbl;
    UIImageView *img;

}
+(void)sideMenuOpen;
- (IBAction)btnPressed_Signout:(id)sender;
@property (strong, nonatomic) NSDictionary * dictProfile;

@end
