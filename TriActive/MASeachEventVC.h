//
//  MASeachEventVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 17/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"
#import "MAEventDescVC.h"
@interface MASeachEventVC : UIViewController<UISearchBarDelegate,MKMapViewDelegate>
{
     NSMutableArray *searchResults;
     NSMutableArray *Results;
    NSMutableArray *infoArray;
    __weak IBOutlet UISearchBar *SearchBarEvnt;
    __weak IBOutlet UITableView *tblEvnt;
    BOOL isSearching;
    BOOL selectAll;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet NSString *keyword;

@end
