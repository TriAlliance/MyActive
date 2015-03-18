//
//  MATrendingGrpEvtVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 20/12/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAImgDashCell.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "MAStatusCell.h"
#import "MAGroupDescVC.h"
#import "MAEventDescVC.h"
@interface MATrendingGrpEvtVC : UIViewController<UIActionSheetDelegate>
{
    
    __weak IBOutlet UITableView *tblVw_GrpEvnt;
    IBOutlet MAImgDashCell *cellImageDash;
    IBOutlet MAStatusCell *cellStatus;
    NSMutableArray *arrGrpEvntData;
    NSMutableArray *arrdata;
    NSArray *imgActivity;
    int paging;
    BOOL insert;
}
@property (retain, nonatomic) NSString *postId;
@property (retain, nonatomic) NSString *keyword;
@property (retain, nonatomic) NSString *keywordSend;
@property (retain, nonatomic) NSString *postType;
@property (retain, nonatomic) NSString *postMessage;
@property (retain, nonatomic) NSData *imageData;
@end

