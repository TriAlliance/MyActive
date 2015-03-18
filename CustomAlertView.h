//
//  CustomAlertView.h
//  MyActive
//
//  Created by Raman Kant on 3/12/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView <AVAudioPlayerDelegate , AVAudioSessionDelegate, AVAssetResourceLoaderDelegate>{
    
    UIImageView     * backImageView;
    
   
}
@property (nonatomic, retain) UIButton      * infoButton;

@property (nonatomic, strong) NSString      * audioFileUrlString;
@property (nonatomic, strong) NSString      * trackUrlString;

@property (nonatomic, retain) UIImageView   * albumImageView;
@property (nonatomic, retain) UILabel       * artistLabel;
@property (nonatomic, retain) UILabel       * songName;


@property (nonatomic, retain) AVPlayerItem    * playerItem;
@property (nonatomic, retain) AVPlayer        * player ;

-(id)init;
-(void)removeView;

@end
