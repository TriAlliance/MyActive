//
//  MAStravaMapDetailVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 12/02/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MAStravaMapDetailVC.h"
#import "FRDStravaClientImports.h"
#import <MapKit/MapKit.h>
#import "ActivityHelper.h"
@interface MAStravaMapDetailVC ()<MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) int pageIndex;
@property (nonatomic, strong) NSMutableDictionary *activityTypeForOverlay;
@property (weak, nonatomic) IBOutlet UILabel *iconListLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblcalories;
@property (weak, nonatomic) IBOutlet UILabel *lblavgHeartrate;
@property (weak, nonatomic) IBOutlet UILabel *lblavgCadence;
@property (nonatomic, strong) NSMutableSet *activityTypes;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

@end

@implementation MAStravaMapDetailVC
{
    CLLocationDegrees minLat;
    CLLocationDegrees maxLat;
    CLLocationDegrees minLon;
    CLLocationDegrees maxLon;
}
#define UNSET_DEGREES 1000.0f;
- (void)viewDidLoad {
    [super viewDidLoad];
    minLat = UNSET_DEGREES;
    maxLat = -UNSET_DEGREES;
    minLon = UNSET_DEGREES;
    maxLon = -UNSET_DEGREES;
    self.mapView.delegate=self;
    self.activityTypeForOverlay = [NSMutableDictionary new];
    self.pageIndex = 1;
    
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Strava Path"];
    [self fetchNextPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableSet *) activityTypes
{
    if (_activityTypes == nil) {
        _activityTypes = [[NSMutableSet alloc] init];
    }
    return _activityTypes;
}
-(void)viewWillAppear:(BOOL)animated
{
   
}
-(void) fetchNextPage
{
    [ApplicationDelegate show_LoadingIndicator];
   [[FRDStravaClient sharedInstance]fetchActivityWithId:[_activityID intValue]
                                      includeAllEfforts:TRUE success: ^  ( StravaActivity *activity ) {
                                          
                                          if ([ApplicationDelegate isHudShown]) {
                                              [ApplicationDelegate hide_LoadingIndicator];
                                          }
                                                                               self.pageIndex++;
                                                                               
                                          MALog(@"%@activity",activity);                           [self addPolylineForActivities:activity];
                                                                               
                                                                           }
                                                                           failure:^(NSError *error) {
                                                                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Miserable failure"
                                                                                                                                   message:error.localizedDescription
                                                                                                                                  delegate:nil
                                                                                                                         cancelButtonTitle:@"Close"
                                                                                                                         otherButtonTitles:nil];
                                                                               [alertView show];
                                                                               
                                                                           }];
}


-(void) addPolylineForActivities:(StravaActivity *)activity
{
    //id = 248388053;
             MALog(@"%@",activity);
        NSArray *arr = [StravaMap decodePolyline:activity.map.summaryPolyline];
        MALog(@"%li",[arr count]);
        CLLocationCoordinate2D coordinates[[arr count]];
        if ([arr count] >0 && (activity.id == [ _activityID intValue])) {
            _iconListLabel.text=[NSString stringWithFormat:@"%.1f Km", activity.distance/ 1000.00];
            _lblcalories.text=[NSString stringWithFormat:@"%.1f",activity.calories];
            _lblavgCadence.text=[NSString stringWithFormat:@"%.1f",roundf(activity.averageCadence)];
            _lblavgHeartrate.text=[NSString stringWithFormat:@"%.1fbpm",roundf(activity.averageHeartrate)];
            NSMutableString *durationStr= [NSMutableString new];
            int hours = (int)floorf(activity.movingTime / 3600);
            int minutes = (activity.movingTime - hours * 3600)/60.0f;
            [durationStr appendFormat:@"%dh %02d", hours, minutes];
            _lblDuration.text = durationStr;
            CLLocationDegrees activityMinLat = UNSET_DEGREES;
            CLLocationDegrees activityMaxLat = -UNSET_DEGREES;
            CLLocationDegrees activityMinLon = UNSET_DEGREES;
            CLLocationDegrees activityMaxLon = -UNSET_DEGREES;
            int i=0;
            for (NSValue *val in arr) {
                MALog(@"%@",val);
                coordinates[i] = [val MKCoordinateValue];
                activityMinLat = MIN(activityMinLat, coordinates[i].latitude);
                activityMinLon = MIN(activityMinLon, coordinates[i].longitude);
                activityMaxLat = MAX(activityMaxLat, coordinates[i].latitude);
                activityMaxLon = MAX(activityMaxLon, coordinates[i].longitude);
                i++;
            }
                     minLat = MIN(activityMinLat, minLat);
            minLon = MIN(activityMinLon, minLon);
            maxLat = MAX(activityMaxLat, maxLat);
            maxLon = MAX(activityMaxLon, maxLon);
        }
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:arr.count];
        [self.mapView addOverlay:polyline];
        [self.activityTypes addObject:@(activity.type)];
        MALog(@"%@",self.activityTypes);
  
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0f, (minLon+maxLon)/2.0f);
    MKCoordinateSpan span = MKCoordinateSpanMake(1.5*(maxLat-minLat), 1.5*(maxLon-minLon));
    self.mapView.region = MKCoordinateRegionMake(center, span);
    
   
}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id <MKOverlay>)overlay
{
    
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:206/255. green:0/255. blue:0/255. alpha:1.0];
    polylineView.lineWidth = 5.0;
    
    return polylineView;
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}
@end