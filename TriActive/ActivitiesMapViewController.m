//
//  ActivitiesMapViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/1/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivitiesMapViewController.h"
#import "FRDStravaClientImports.h"
#import <MapKit/MapKit.h>
#import "ActivityHelper.h"


@interface ActivitiesMapViewController ()<MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) int pageIndex;
@property (nonatomic, strong) NSMutableDictionary *activityTypeForOverlay;
@property (weak, nonatomic) IBOutlet UILabel *iconListLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbltype;
@property (nonatomic, strong) NSMutableSet *activityTypes;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

@end

@implementation ActivitiesMapViewController
{
    CLLocationDegrees minLat;
    CLLocationDegrees maxLat;
    CLLocationDegrees minLon;
    CLLocationDegrees maxLon;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#define UNSET_DEGREES 1000.0f;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    minLat = UNSET_DEGREES;
    maxLat = -UNSET_DEGREES;
    minLon = UNSET_DEGREES;
    maxLon = -UNSET_DEGREES;
    self.mapView.delegate=self;
    self.activityTypeForOverlay = [NSMutableDictionary new];
    self.pageIndex = 1;
   
     self.navigationItem.titleView = [Utility lblTitleNavBar:@"Strava Path"];
    //self.iconListLabel.font = [UIFont fontWithName:@"icomoon" size:14.0f];
    [self fetchNextPage];
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(moreAction:)];
}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)didReceiveMemoryWarning
{
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

-(void) fetchNextPage
{
  [ApplicationDelegate show_LoadingIndicator];
    [[FRDStravaClient sharedInstance]fetchActivityWithId:[_activityID intValue]
                                       includeAllEfforts:TRUE success: ^  ( StravaActivity *activity ) {
                                          
                                           
                                           if ([ApplicationDelegate isHudShown]) {
                                               [ApplicationDelegate hide_LoadingIndicator];
                                           }                           [self addPolylineForActivities:activity];
                                            [self showMoreButton];
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
      MALog(@"%@",activity);
        NSArray *arr = [StravaMap decodePolyline:activity.map.summaryPolyline];
        MALog(@"%li",[arr count]);
            CLLocationCoordinate2D coordinates[[arr count]];
        if ([arr count] >0 && (activity.id == [ _activityID intValue])) {
        
             _iconListLabel.text=[NSString stringWithFormat:@"%.1f Km", activity.distance/ 1000.00];
            _lbltype.text=[NSString stringWithFormat:@"%.1f",activity.calories];
            _stravaID=[NSString stringWithFormat:@"%ld",(long)activity.id];
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

- (IBAction)moreAction:(id)sender
{
   [UserDefaults removeObjectForKey:@"StravaPostData"];
     CGFloat compression =0.9f;
    // CGSize size =  [[UIScreen mainScreen] bounds].size;
    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
 
    // Create the screenshot
    UIGraphicsBeginImageContextWithOptions(size,YES, 0.0);
    // Put everything in the current view into the screenshot
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    // Save the current image context info into a UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _image = UIImageJPEGRepresentation(newImage, compression);
    base64 = [[NSString alloc] initWithString:[Base64 encode:_image]];
     NSMutableDictionary * Details = [[NSMutableDictionary alloc]init];
     [Details setValue:_lblDuration.text forKey:@"duration"];
     [Details setValue:_stravaID forKey:@"strava_id"];
     [Details setValue:_iconListLabel.text forKey:@"distance"];
     [Details setValue:base64 forKey:@"imageMap"];
     [Details setValue:_lbltype.text forKey:@"calories"];
     [UserDefaults setObject:Details forKey:@"StravaPostData"];
     [UserDefaults synchronize];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    // Save the screenshot to the device's photo album
    UIImageWriteToSavedPhotosAlbum(newImage, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
    // callback for UIImageWriteToSavedPhotosAlbum
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
        if (error) {
            // Handle if the image could not be saved to the photo album
        }
        else {
            // The save was successful and all is well
        }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}

@end
