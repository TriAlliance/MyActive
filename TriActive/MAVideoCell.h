//
//  MAVideoCell.h
//  MyActive
//
//  Created by Ketan on 15/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_Activity;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_ProfilePic;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_Uploaded;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Caption;
@property (weak, nonatomic) IBOutlet UILabel *lbl_like;
@property (weak, nonatomic) IBOutlet UILabel *lbl_backSlap;
@property (weak, nonatomic) IBOutlet UILabel *lbl_bumSlap;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Comments;
@property (weak, nonatomic) IBOutlet UIButton *btn_name;


@end
