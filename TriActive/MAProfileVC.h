//
//  TAProfileVC.h
//  TriActive
//
//  Created by Ketan on 05/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "MAProfileSettingVC.h"
#import "MAImageCell.h"
#import "MAVideoCell.h"
#import "MAStatusCell.h"
#import "MAImgDashCell.h"
#import "SVPullToRefresh.h"
#import "STTweetLabel.h"
@interface MAProfileVC : UIViewController <UIActionSheetDelegate>
{
    IBOutlet MAImageCell *cellImage;
    IBOutlet MAVideoCell *cellVideo;
    IBOutlet MAStatusCell *cellStatus;
    IBOutlet MAImgDashCell *cellImageDash;
    __weak IBOutlet UITableView *tbl_Profile;
    NSMutableArray * arrProfileData;
     NSMutableArray * arrProfileHomeData;
    NSArray *imgActivity;
   
    int paging;
    BOOL insert;
}
- (IBAction)btnPressed_EditProfile:(id)sender;
- (IBAction)btnPressed_UserList:(id)sender;
@property (retain, nonatomic) NSString *postId;
@property (retain, nonatomic) NSString *postMessage;
@property (retain, nonatomic) NSData *imageData;

//**********ELIZA**********//

@property (retain, nonatomic) NSString *check_push_or_tab;
@end
