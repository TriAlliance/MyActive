//
//  MAShareCommentsCell.h
//  MyActive
//
//  Created by Preeti Malhotra on 29/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAShareCommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UIImageView;
@property (weak, nonatomic) IBOutlet UILabel * locNameLbls;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;
@property (weak, nonatomic) IBOutlet UILabel * lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btn_name;

@end
