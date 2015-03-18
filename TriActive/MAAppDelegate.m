//
//  TAAppDelegate.m
//  TriActive
//
//  Created by Ketan on 03/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//
@import HealthKit;

#import "MAAppDelegate.h"
#import "MAStarvaActivityListVC.h"
#import "FRDStravaClient+Access.h"
#import "MARegisterVC.h"
#import "CustomTabBarController.h"
#import "RevealController.h"
#import "MyDashActivityVC.h"


@implementation MAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//     for(NSString *fontfamilyname in [UIFont familyNames])
//     {
//     NSLog(@"family:'%@'",fontfamilyname);
//     for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//     {
//     NSLog(@"\tfont:'%@'",fontName);
//     }
//     }
 
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.mainNavigationController = (UINavigationController *)self.window.rootViewController;
    ApplicationDelegate.mainNavigationController.navigationBarHidden = YES;
    
    /***** Start HealthKit Permission *****/
    [[HKManager sharedManager] authorizeWithCompletion:^(NSError *error) {
        UIAlertView *av =
        [[UIAlertView alloc] initWithTitle:@"HealthKit" message:error.hkManagerErrorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
    }];
   /***** End HealthKit Permission *****/

    //Notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    if (iOSVersion>=7.0) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headerIOS7.png"]forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headerIOS6.png"]forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:25.0f/255.0f green:74.0f/255.0f blue:138.0f/255.0f alpha:1.0f]];
    }
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.mainNavigationController.navigationBar.translucent = NO;
    // UIToolBar Button title color
    [[UIBarButtonItem appearance]
     setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
      UITextAttributeTextColor,nil]
     forState:UIControlStateNormal];
    
    [self CurrentLocationIdentifier];
    if ([UserDefaults objectForKey:@"user_id"] != nil) {
        [self homeVC];
    }else
    {
        [self mainVC];
    }
    
    //Notification
    if ([launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        
        NSDictionary *dictPush = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        [self performSelector:@selector(pushActionWithDict:) withObject:dictPush afterDelay:1.0];
    }
     
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
     return YES;
}

-(void)mainVC
{
  NSArray * arrImgName = [[NSArray alloc]init];
    if (IS_IPHONE_5) {
        arrImgName = @[@"Background5s.png",@"Background5s2.png",@"Background5s3.png"];
    }else
    {
        arrImgName = @[@"Background4s.png",@"Background5s2.png",@"Background5s3.png"];
    }
    
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"MyActive"
                                                            subTitle:@"Champs-Elysées by night"
                                                         pictureName:[arrImgName objectAtIndex:0]
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"MyActive"
                                                            subTitle:@"The Eiffel Tower with\n zcloudy weather"
                                                         pictureName:[arrImgName objectAtIndex:1]
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"MyActive"
                                                            subTitle:@"An other famous street of Paris"
                                                         pictureName:[arrImgName objectAtIndex:2]
                                                            duration:3.0];
    
    NSArray *tutorialLayers = @[layer1,layer2,layer3];
    
    // Set the common style for the title.
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Roboto-Medium" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    self.objMainVC = [[ICETutorialController alloc] initWithPages:tutorialLayers
                                                         delegate:self];
    // Run it.
    [self.objMainVC startScrolling];
    
//    SlideInnerViewController *sliderVcObj=VCWithIdentifier(@"SlideInnerViewController");
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_objMainVC];
    
//    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:sliderVcObj];
    
//    self.revealViewController = revealController;
    self.window.rootViewController = navigationController;
    
}
-(void)homeVC
{
    _mainTabBar = VCWithIdentifier(@"CustomTabBarController");
    SlideInnerViewController *sliderVcObj=VCWithIdentifier(@"SlideInnerViewController");
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_mainTabBar];
    
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:sliderVcObj];
    
    self.revealViewController = revealController;
    self.window.rootViewController = self.revealViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    /***** Start HealthKit Permission *****/
    [[HKManager sharedManager] authorizeWithCompletion:^(NSError *error) {
        UIAlertView *av =
        [[UIAlertView alloc] initWithTitle:@"HealthKit" message:error.hkManagerErrorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
    }];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication

         annotation:(id)annotation
{
    MALog(@"%@url",url);
    MALog(@"%@url",url.scheme);
    if([url.scheme  isEqualToString:@"myactivestravaclient"]){
     [UserDefaults removeObjectForKey:@"Strava_token"];
        [[FRDStravaClient sharedInstance] parseStravaAuthCallback:url
                                                      withSuccess:^(NSString *stateInfo, NSString *code) {
                                                          [self exchangeToken:code];
                                                      }
                                                          failure:^(NSString *stateInfo, NSString *error) {
                                                              [self showAuthFailedWithError:error];
                                                          }];
        
        return YES;
    }
    else{
//        [FBSession.activeSession setStateChangeHandler:
//         ^(FBSession *session, FBSessionState state, NSError *error) {
//             
//             // Retrieve the app delegate
//             MAAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
//             [appDelegate sessionStateChanged:session state:state error:error];
//         }];
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      [FBSession.activeSession close];
}
#pragma mark
#pragma mark Show UIAlert View
#pragma mark
-(void)showAlert:(NSString *)str
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppName message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark
#pragma mark Notification
#pragma mark
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    _DToken = dt;
    MALog(@"My token is: %@", _DToken);
    [UserDefaults setValue:_DToken forKey:@"DToken"];
    [UserDefaults synchronize];
      MALog(@"UserDefaults token is: %@", [UserDefaults valueForKey:@"DToken"]);
      MALog(@"My token is: %@", dt);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
      MALog(@"Failed to get token, error: %@", error);
}


-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
      MALog(@"My userInfo is: %@", userInfo);
    [self pushActionWithDict:userInfo];
}

-(void)pushActionWithDict:(NSDictionary *)dictPush {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSString * msg = [[dictPush valueForKey:@"aps"] valueForKey:@"alert"];
    
    [TSMessage showNotificationInViewController:self.window.rootViewController
                                          title:AppName
                                       subtitle:msg
                                          image:nil
                                           type:TSMessageNotificationTypeMessage
                                       duration:8.0f
                                       callback:^{}
                                    buttonTitle:@"View"
                                 buttonCallback:^
     {
         MALog(@"View tapped.");
     }
     
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
    
}

#pragma mark
#pragma mark - Loading indicator
#pragma mark

- (void)show_LoadingIndicator
{
    if(!HUD)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Processing. . .";
    }
    
    [HUD show:YES];
    [self.window performSelector:@selector(bringSubviewToFront:) withObject:HUD afterDelay:0.1];
    
}

- (void)hide_LoadingIndicator
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    
}

-(BOOL) isHudShown {
    
    if ([HUD superview]) {
        return YES;
    }
    return NO;
    
}
#pragma mark
#pragma mark - For getting current gps location
#pragma mark
-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    locationManager = [CLLocationManager new];
        locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    if(iOSVersion>=8.0){
       if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [locationManager requestWhenInUseAuthorization];
       }
    }

   CLLocation *location = [locationManager location];
    // Configure the new event with information from the location
  CLLocationCoordinate2D coordinate = [location coordinate];
   _longitude = [NSString stringWithFormat:@"%.8f", coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%.8f", coordinate.latitude];
  
    
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    _longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}
-(void) exchangeToken:(NSString *)code
{
    [[FRDStravaClient sharedInstance] exchangeTokenForCode:code
                                                   success:^(StravaAccessTokenResponse *response) {
                                                       [UserDefaults setObject:response.accessToken forKey:@"Strava_token"];
                                                [UserDefaults setObject:[NSString stringWithFormat:@"%ld",response.athlete.id] forKey:@"AthleteId"];
                                                       [UserDefaults setObject:[NSString stringWithFormat:@"%@",response.athlete.firstName] forKey:@"stravaName"];
                                                       
                                                        [UserDefaults synchronize];
                                                      
                                                       MALog(@"%@response callback",response.athlete);

                                                   }
                                                   failure:^(NSError *error) {
                                                       [self showAuthFailedWithError:error.localizedDescription];
                                                   }];
}

-(void) showAuthFailedWithError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
