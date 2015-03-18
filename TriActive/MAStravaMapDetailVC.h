//
//  MAStravaMapDetailVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 12/02/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAStravaMapDetailVC : UIViewController{
    
    __weak IBOutlet UIView *VW_first;
}
@property (nonatomic, strong) NSString *activityID;
@end
