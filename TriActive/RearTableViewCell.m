//
//  RearTableViewCell.m

//  Copyright (c) 2014 Trigma. All rights reserved.
//

#import "RearTableViewCell.h"

@implementation RearTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [_RearcellLabloult setFont:ROBOTO_LIGHT(16)];
}

@end
