//
//  MASearhGroupVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 18/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MAGroupDescVC.h"
@interface MASearchGroupVC : UIViewController<UISearchBarDelegate,MKMapViewDelegate>
{
    NSMutableArray *searchResults;
    NSMutableArray *Results;
     NSMutableArray *infoArray;
    __weak IBOutlet UISearchBar *SearchBarGrp;
    __weak IBOutlet UITableView *tblGrp;
    BOOL isSearching;
    BOOL selectAll;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet NSString *keyword;
@end
