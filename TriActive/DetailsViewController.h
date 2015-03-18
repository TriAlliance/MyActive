//
//  DetailsViewController.h
//  MyActive
//
//  Created by Raman Kant on 3/16/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAImgDashCell.h"

@interface DetailsViewController : UIViewController <UIActionSheetDelegate>{

    NSArray                 * imgActivity;
    
    IBOutlet MAImageCell    * cellImage;
    IBOutlet MAVideoCell    * cellVideo;
    IBOutlet MAStatusCell   * cellStatus;
    IBOutlet MAImgDashCell  * cellImageDash;
}

@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * artistID;
@property (nonatomic, retain) NSString * artworkUrl;
@property (nonatomic, retain) NSString * trackViewkUrl;

@property (retain, nonatomic) NSString * postId;
@property (retain, nonatomic) NSString * postMessage;
@property (retain, nonatomic) NSData   * imageData;

@end
