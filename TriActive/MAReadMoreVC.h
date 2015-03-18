//
//  MAReadMoreVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 23/02/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "MAImageCell.h"
#import "MAVideoCell.h"
#import "MAStatusCell.h"
#import "MAImgDashCell.h"
#import "MAPostVC.h"
#import "STTweetLabel.h"

@interface MAReadMoreVC :  UIViewController<UIActionSheetDelegate>
{
    __weak IBOutlet UITableView *tblVw_Question;
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


@property (retain, nonatomic) NSString *postMessage;
@property (retain, nonatomic) NSData *imageData;
@property (retain, nonatomic) NSMutableArray *Arr_readMore;
@end
