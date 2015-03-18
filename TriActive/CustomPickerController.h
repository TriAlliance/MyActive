//
//  CustomPickerController.h
//  UVuume
//
//  Created by Rajender Sharma on 13/07/11.
//  Copyright 2011 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomPickerController : UIImagePickerController {
    
    NSTimer * _updateTimer;
    BOOL _recording;
    NSString * _tempFileName;
    UIControl * captureButton;
    NSDate * startDate;
}
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) NSUInteger secondsPassed;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain) NSTimer * updateTimer;
@property (retain) NSString * tempFileName;
@property (assign) BOOL isVideo;

- (BOOL)startVideoCapture;
- (void)stopVideoCapture;

@end
