//
//  MANew.m
//  MyActive
//
//  Created by Ketan on 05/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAVideoPlay.h"

@interface MAVideoPlay ()

@end

@implementation MAVideoPlay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self playMovie];
}
-(void)viewDidDisappear:(BOOL)animated
{
//    [_moviePlayer stop];
}
-(void)playMovie
{
   // NSString *filepath = [[NSBundle mainBundle] pathForResource:@"SetWarmUp" ofType:@"mov"];
    //NSURL  * url  = [NSURL fileURLWithPath:filepath];
    NSURL *url = [NSURL URLWithString:_url];
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
     _moviePlayer.view.frame=CGRectMake(0,64,320,450);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.5f];
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
