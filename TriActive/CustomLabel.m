//
//  CustomLabel.m
//  ImageProcessing
//

#import "CustomLabel.h"

@implementation CustomLabel


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.font = [UIFont fontWithName:@"Roboto-Regular" size:self.font.pointSize];
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
