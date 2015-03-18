//
//  MAEventDescVC.h
//  MyActive
//
//  Created by Jimcy Goyal on 22/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MAAddEventVC.h"
@interface MAEventDescVC : UIViewController<MKMapViewDelegate>
{
    
    __weak IBOutlet UITableView *tblEvtDetail;
    NSMutableArray *ArrEvtData;
}

- (IBAction)btnPressed_editEvent:(id)sender;
@property (retain, nonatomic) NSString *eventId;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)btnPressed_followed:(id)sender;

@end
