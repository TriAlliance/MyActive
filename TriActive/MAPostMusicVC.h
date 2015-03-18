//
//  MAPostMusicVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 13/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol musicDelegate;

@interface MAPostMusicVC : UIViewController
{
  __weak IBOutlet UISearchBar *searchBarPostMusic;
  NSMutableDictionary* iTunesDict;
  NSURL* iTunesUrl;
  NSMutableArray* resultArr;
  NSMutableArray* searchResults;
  __weak IBOutlet UITableView *tbl_itunes_music;
  BOOL isSearching;
    BOOL selectAll;

}
@property (nonatomic, weak) id<musicDelegate> delegate;


@property(strong,nonatomic)AVPlayerItem* playerItem;
@property(strong,nonatomic)AVPlayer* player;
@end

@protocol musicDelegate <NSObject>
-(void)musicData:(NSString *)value;
@end
