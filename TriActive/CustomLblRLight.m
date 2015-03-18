//
//  CustomLblRLight.m
//  MyActive
//
//  Created by Preeti Malhotra on 19/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "CustomLblRLight.h"

@implementation CustomLblRLight


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
       self.font = [UIFont fontWithName:@"Roboto-Light" size:self.font.pointSize];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
