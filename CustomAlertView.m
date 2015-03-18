//
//  CustomAlertView.m
//  MyActive
//
//  Created by Raman Kant on 3/12/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "CustomAlertView.h"
#import "Constant.h"
#import "DetailsViewController.h"


@implementation CustomAlertView
@synthesize albumImageView,
            artistLabel,
            songName,
            trackUrlString,
            audioFileUrlString,
            infoButton;

@synthesize playerItem, player;

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

-(id)init{
    
    self = [super init];
    
    backImageView                       = [[UIImageView alloc]initWithFrame:CGRectMake(0,-600,SCREEN_SIZE.width, SCREEN_SIZE.height+1200)];
    backImageView.backgroundColor       = [UIColor blackColor];
    backImageView.alpha                 = 0;
    [self addSubview:backImageView];
    
    // ADD VIEW //
    UIView * view                       = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_SIZE.width-240)/2, (SCREEN_SIZE.height-244)/2, 240, 200)];
    self.frame                          =  CGRectMake(0,-300,SCREEN_SIZE.width , SCREEN_SIZE.height);
    view.layer.cornerRadius             = 6.0f;
    view.backgroundColor                = [UIColor whiteColor];
    [self addSubview:view];
    
    // ADD ALBUM IMAGE VIEW //
    self.albumImageView                 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [view addSubview:self.albumImageView];
    
    // ADD SONG NAME LABEL //
    self.songName                       = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 150, 60)];
    self.songName.font                  =[UIFont systemFontOfSize:15.0f];
    self.songName.numberOfLines         = 3;
    [view addSubview:self.songName];
    
    // ADD BUY SONG LABEL //
    UILabel * buyLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 175, 18)];
    buyLabel.text                       = @"Buy Song";
    buyLabel.font                       =  [UIFont systemFontOfSize:13.0f];
    [view addSubview:buyLabel];
    
    // ADD BUY BUTTON //
    UIButton * musicButton                = [UIButton buttonWithType:UIButtonTypeCustom];
    [musicButton setImage:[UIImage imageNamed:@"music2.png"] forState:UIControlStateNormal];
    [musicButton addTarget:self action:@selector(musicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [musicButton setFrame:CGRectMake(200, 110, 20, 20)];
    [view addSubview:musicButton];
    
    // ADD TRACK LABEL //
    self.artistLabel                    = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 175, 18)];
    self.artistLabel.font               = [UIFont systemFontOfSize:13.0f];
    [view addSubview:self.artistLabel];
    
    // ADD INFO BUTTON //
    infoButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton setImage:[UIImage imageNamed:@"info12.png"] forState:UIControlStateNormal];
    [infoButton setFrame:CGRectMake(200, 160, 20, 20)];
    [view addSubview:infoButton];
    
    
    audioFileUrlString              = @"http://a1574.phobos.apple.com/us/r30/Music/v4/b2/2e/9f/b22e9f58-3a96-1575-706f-4a9bb32af6e3/mzaf_1557800517627873448.aac.m4a";
    AVURLAsset * asset              = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:audioFileUrlString] options:nil];
    [asset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.player     = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    
    [self downAnimation];
    return self;
}


-(void)musicButtonAction:(id)sender{
    NSString * iTunesLinkFinal = [trackUrlString stringByReplacingOccurrencesOfString:@"https" withString:@"itms"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLinkFinal]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == player && [keyPath isEqualToString:@"status"]) {
        if (player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [player play];
        } else if (player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}
 

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    //  code here to play next sound file
}


-(void)downAnimation{
    
    [UIView animateWithDuration:0.35 animations:^{
        backImageView.alpha = 0.4f;
        self.frame =  CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height);
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)removeView{
    [self.player pause];
    [self.player removeObserver:self forKeyPath:@"status" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    self.playerItem = nil;
    self.player     = nil;
    
    [UIView animateWithDuration:0.35 animations:^{
        backImageView.alpha = 0.0f;
        self.frame =  CGRectMake(0,[[UIScreen mainScreen] bounds].size.height+300,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];

}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    NSLog(@"%@",[touch view]);
    if ([touch view] == self){
        [self removeView];
    }
}

@end
