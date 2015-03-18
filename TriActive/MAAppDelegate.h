//
//  TAAppDelegate.h
//  TriActive
//
//  Created by Ketan on 03/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideInnerViewController.h"
#import "RevealController.h"
#import "ICETutorialController.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "HKManager.h"
#import "MyDashActivityVC.h"
#import<FacebookSDK/FacebookSDK.h>
#import "TSMessage.h"
#import "FRDStravaClientImports.h"
#import "MAStarvaActivityListVC.h"

@class MAMainVC;
@class CustomTabBarController;

@interface MAAppDelegate : UIResponder <UIApplicationDelegate,ICETutorialControllerDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>
{
    MBProgressHUD *HUD;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) CustomTabBarController * mainTabBar;
@property (strong, nonatomic) NSString *DToken;
@property (strong, nonatomic) NSString *HealthPermission;
@property (strong, nonatomic) ICETutorialController *objMainVC;
@property (strong, nonatomic) RevealController *revealViewController;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (nonatomic, strong) HKHealthStore *healthStore;
@property (strong, nonatomic) NSString *connect;
-(void)mainVC;
-(void)homeVC;

// Show AlertView
-(void)showAlert:(NSString *)str;
// Loading Indicator
- (void)show_LoadingIndicator;
- (void)hide_LoadingIndicator;
- (BOOL) isHudShown ;
@end
