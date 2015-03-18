//
//  MACommentsVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 19/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MACommentsVC : UIViewController<UITextFieldDelegate>

{
     __weak IBOutlet UITextView *txtViewcomments;
    __weak IBOutlet UIImageView *imgViewDash;
    __weak IBOutlet UIView *viewPostCmt;
    __weak IBOutlet UILabel *lblDashType;
    __weak IBOutlet UIView *viewComments;
}
- (IBAction)btnPressed_postComments:(id)sender;
@property (retain, nonatomic) NSData *dataImg;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *baseData;
- (IBAction)btnPressed_cancel:(id)sender;
@end
