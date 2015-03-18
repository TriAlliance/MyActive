//
//  MATrendingPostVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 19/12/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "MAImageCell.h"
#import "MAVideoCell.h"
#import "MAStatusCell.h"
#import "MAImgDashCell.h"
#import "STTweetLabel.h"
#import "MAHashVC.h"
@interface MATrendingPostVC : UIViewController<UIActionSheetDelegate>
{
    
    __weak IBOutlet UITableView *tblVW_trendingPost;
    IBOutlet MAImageCell *cellImage;
    IBOutlet MAVideoCell *cellVideo;
    IBOutlet MAStatusCell *cellStatus;
    IBOutlet MAImgDashCell *cellImageDash;
    NSMutableArray *arrQuestionData;
    NSMutableArray *arrdata;
    int paging;
    BOOL insert;
    NSArray *imgActivity;
}
@property (retain, nonatomic) NSString *postId;
@property (retain, nonatomic) NSString *keyword;
@property (retain, nonatomic) NSString *postMessage;
@property (retain, nonatomic) NSData *imageData;
@end
