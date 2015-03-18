//
//  MAAddMusicVC.h
//  MyActive
//
//  Created by Jimcy Goyal on 22/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "DTAlertView.h"
@interface MAAddMusicVC : UIViewController<DTAlertViewDelegate, AVAudioPlayerDelegate, AVAudioSessionDelegate, AVAssetResourceLoaderDelegate>
{
     __weak IBOutlet UISearchBar *searchBar;
    NSMutableDictionary* iTunesDict;
    NSMutableArray* resultArr;
    __weak IBOutlet UITableView *tbl_itunes;
}
@property(strong,nonatomic)AVPlayerItem * playerItem;
@property(strong,nonatomic)AVPlayer     * player;

- (IBAction)categoriesBtnPressed:(UIButton*)sender;

@end
