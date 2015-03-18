//
//  MAPostVC.h
//  MyActive
//
//  Created by Jimcy Goyal on 22/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAAddLocationVC.h"
#import "GKImagePicker.h"
#import "MAPostMusicVC.h"
#import "MAActivityVC.h"
#import "MAAddLocationVC.h"
#import "Base64.h"
#import "CustomPickerController.h"//eshan
#import "ActivitiesMapViewController.h"


@interface MAPostVC : UIViewController<GKImagePickerDelegate,musicDelegate,activityDelegate,locationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    GKImagePicker *picker;
    NSArray *smiles;
    NSArray *smilesTxt;
    __weak IBOutlet UITextView *txtMsg;
    NSData *imageData;
    NSString *txtSmile;
    NSString *txtMusic;
    NSString *txtActivity;
    NSString *txtLocation;
    NSString *txtStravaActivity;
    __weak IBOutlet UIButton *btn_ImgPrvw;
    
    NSString * base64;
    UIPopoverController *popover;// check for its need..?
    
    CustomPickerController *cusmagePickerController;//eshan
    
    NSString *bit;//eshan
}
@property (weak, nonatomic) IBOutlet UIPageControl *pagePost;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewSmiles;
@property (assign) BOOL openHome;
@property (weak, nonatomic)  NSString *txtPostMusic;
@property (weak, nonatomic)  NSString *titlePost;

@property (weak, nonatomic) IBOutlet UIButton *authorizeButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic)  NSString *NoStrava;
@property (weak, nonatomic)  NSString *PostID;
 @property (weak, nonatomic) NSString *tokenfromparse;
- (IBAction)smileBtnPressed:(id)sender;
- (IBAction)locationBtnPressed:(id)sender;
- (IBAction)cameraBtnPressed:(id)sender;
- (IBAction)musicBtnPressed:(id)sender;
- (IBAction)starBtnPressed:(id)sender;
- (IBAction)btnPressed_addActivity:(id)sender;
@end
