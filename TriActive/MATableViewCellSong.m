//
//  MATableViewCellSong.m
//  MyActive
//
//  Created by Raman Kant on 3/16/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MATableViewCellSong.h"

@implementation MATableViewCellSong
@synthesize artworkImageView,
            trackLabel,
            artistLabel,
            buyButton;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
