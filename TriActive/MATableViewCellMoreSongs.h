//
//  MATableViewCellMoreSongs.h
//  MyActive
//
//  Created by Raman Kant on 3/16/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MATableViewCellMoreSongs : UITableViewCell{
    
}

@property(nonatomic ,weak) IBOutlet UIImageView * artworkImageView;
@property(nonatomic ,weak) IBOutlet UILabel     * trackLabel;
@property(nonatomic ,weak) IBOutlet UILabel     * artistLabel;
@property(nonatomic, weak) IBOutlet UIButton    * buyButton;

@end
