//
//  OtherUserProfileVC.h
//  MyActive
//
//  Created by Eliza Dhamija on 31/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
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
@interface OtherUserProfileVC : UIViewController<UIActionSheetDelegate>{
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
@property (retain, nonatomic) NSString *mutual;
@property (retain, nonatomic) NSString *other_user_ID;

@property (retain, nonatomic) NSString *postMessage;
@property (retain, nonatomic) NSData *imageData;
@property (retain, nonatomic) NSString *str_follow_or_unfollow;
@end
