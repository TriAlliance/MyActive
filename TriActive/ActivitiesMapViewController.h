//
//  ActivitiesMapViewController.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/1/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base64.h"

@interface ActivitiesMapViewController : UIViewController
{
  NSString * base64;
 
}
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) NSString *stravaID;
@property (strong, nonatomic) NSData *image;
@end




