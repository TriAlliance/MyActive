//
//  MAStarvaActivityListVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 17/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ActivitiesListModes) {
    ActivitiesListModeCurrentAthlete,
    ActivitiesListModeFeed,
    ActivitiesListModeClub
    
};
@protocol stravaActivityDelegate;
@interface MAStarvaActivityListVC : UIViewController{
    
        NSArray * arrActivity;
   
    __weak IBOutlet UITableView *tbl_StravaActList;
}
@property (nonatomic) NSInteger clubId;
@property (nonatomic) ActivitiesListModes mode;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic) int pageIndex;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) NSInteger athleteId;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, weak) id<stravaActivityDelegate> delegate;
@end

@protocol stravaActivityDelegate <NSObject>
-(void)stravaActivityData:(NSDictionary *)value;
@end
