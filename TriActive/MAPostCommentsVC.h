//
//  MAPostCommentsVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 20/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTweetLabel.h"
#import "MAShareCommentsCell.h"
@interface MAPostCommentsVC : UIViewController<UITextFieldDelegate>
{
    NSMutableArray *Results;
    __weak IBOutlet UITableView *tblPostComments;
    IBOutlet MAShareCommentsCell *cellShareComments;
    __weak IBOutlet UIView *viewPost;
    __weak IBOutlet UITextField *txtFld_comments;
    __weak IBOutlet UIView *viewPostTable;
   }
@property (retain, nonatomic) NSString *post_id;
@property (retain, nonatomic) NSString *type;
- (IBAction)btnPressed_sendPost:(id)sender;
- (IBAction)btnPressed_cancel:(id)sender;
@end
