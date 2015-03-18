//
//  MASeachEventVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 17/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//
#define METERS_PER_MILE 1609.344
#import "MASeachEventVC.h"

@interface MASeachEventVC ()

@end

@implementation MASeachEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    infoArray =[[NSMutableArray alloc]init];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
   
    Results=[[NSMutableArray alloc]init];
    searchResults=[[NSMutableArray alloc]init];
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Find Events"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [Utility leftbar:[UIImage imageNamed:@"sideMenu.png"] :self];
    [Utility swipeSideMenu:self];
    
    MALog(@"result=======%lu",(unsigned long)[Results count]);
    

    [SearchBarEvnt setShowsCancelButton:NO animated:YES];
    
}
//mapview delegate methods

#pragma mark
#pragma mark MKMapView Methods
// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
    region.span.longitudeDelta = 1.005f;
    region.span.longitudeDelta = 1.005f;
    [mv setRegion:region animated:YES];
   // [mv selectAnnotation:mp animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
     selectAll = YES;
    [self callEventAPI];
   // [searchResults removeAllObjects];
  //  [self searchBarCancelButtonClicked:SearchBarEvnt];
    
    }
#pragma mark
#pragma mark Map View Delegate  Method
#pragma mark
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
  
    UIImageView *houseIconView = [[UIImageView alloc] init];
    if([infoArray count]>0){
        for (int i=0; i < [infoArray  count]; i++)
        {

    NSMutableDictionary *dict  = [infoArray objectAtIndex:i];
    NSURL *ImageURL = [NSURL URLWithString:[dict valueForKey:@"image_url"]];
    [houseIconView setFrame:CGRectMake(0, 0, 30, 30)];
   [houseIconView sd_setImageWithURL:ImageURL placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
    pinAnnotationView.leftCalloutAccessoryView = houseIconView;
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            int value = [[dict valueForKey:@"id"] intValue];
            rightButton.tag=value;
            [rightButton addTarget:self action:@selector(calloutSubMenu:) forControlEvents:UIControlEventTouchUpInside];
            
            [rightButton setTitle:annotation.title forState:UIControlStateNormal];
            
            pinAnnotationView.rightCalloutAccessoryView = rightButton;
            
        }
    }
    pinAnnotationView.canShowCallout = YES;

    return pinAnnotationView;
}
-(void)calloutSubMenu:(UIButton *)btn{
    MALog(@"%ld",btn.tag);
    if(isSearching && [[searchResults objectAtIndex:0]count]){
        MAEventDescVC * objEventDescVC=VCWithIdentifier(@"MAEventDescVC");
        objEventDescVC.eventId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
        [self.navigationController pushViewController:objEventDescVC animated:YES];
    }}
#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)leftBtn
{
    
    [self.view endEditing:YES];
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
        
        [self.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil afterDelay:0.0];
    }
}


-(void)callEventAPI{
    NSLog(@"%@",ApplicationDelegate.latitude);
    NSLog(@"%@",ApplicationDelegate.longitude);
   
    NSDictionary* userInfo = @{@"lat":ApplicationDelegate.latitude,
                               @"lng":ApplicationDelegate.longitude,
                               @"user_id":[UserDefaults valueForKey:@"user_id"]
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API EventsWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
           
            [Results addObject:[responseDict valueForKey:@"data"]];
             MALog(@"result=======%lu",(unsigned long)[[Results objectAtIndex:0] count]);
            for (int i=0; i < [[Results objectAtIndex:0]  count]; i++)
            {
                NSDictionary *annotationDictionary = [[Results objectAtIndex:0] objectAtIndex:i];
               CLLocationCoordinate2D zoomLocation;
                zoomLocation.latitude
                = [[annotationDictionary objectForKey:@"lat"] doubleValue];
                
                zoomLocation.longitude
                = [[annotationDictionary objectForKey:@"lng"] doubleValue];
             
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
                [_mapView setRegion:viewRegion animated:YES];
                
                MALog(@"%@",[annotationDictionary objectForKey:@"name"]);
                MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
                annotationPoint.coordinate = zoomLocation;
                annotationPoint.title = [annotationDictionary objectForKey:@"name"];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[annotationDictionary objectForKey:@"image"],@"image_url",[annotationDictionary objectForKey:@"id"],@"id" ,nil];
                [infoArray addObject:dict];
                MALog(@"%@",infoArray);

                [_mapView addAnnotation:annotationPoint];

            }

        }
        else
        {
            //[ApplicationDelegate showAlert:@"No Event Found"];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isSearching = NO;
        [tblEvnt reloadData];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    isSearching = NO;
    [tblEvnt reloadData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterContentForSearchText:searchBar.text];
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    
}


-(void)filterContentForSearchText:(NSString*)searchText
{
    [searchResults removeAllObjects];
    _keyword=searchText;
    [self callSearchEventAPI];
      isSearching=TRUE;
    
}
-(void)callSearchEventAPI{
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"keyword":_keyword};
    
    [ApplicationDelegate show_LoadingIndicator];
    [API SearchEventsWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            
            [searchResults addObject:[responseDict valueForKey:@"data"]];
            [infoArray removeAllObjects];
            for (int i=0; i < [[searchResults objectAtIndex:0]  count]; i++)
            {
                
                NSDictionary *annotationDictionary = [[searchResults objectAtIndex:0] objectAtIndex:i];
                CLLocationCoordinate2D zoomLocation;
                zoomLocation.latitude
                = [[annotationDictionary objectForKey:@"lat"] doubleValue];
                zoomLocation.longitude
                = [[annotationDictionary objectForKey:@"lng"] doubleValue];
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
                [_mapView setRegion:viewRegion animated:YES];
                
                MALog(@"%@",[annotationDictionary objectForKey:@"name"]);
                MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
                annotationPoint.coordinate = zoomLocation;
                annotationPoint.title = [annotationDictionary objectForKey:@"name"];
               NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[annotationDictionary objectForKey:@"image"],@"image_url",[annotationDictionary objectForKey:@"id"],@"id" ,nil];
                [infoArray addObject:dict];
                MALog(@"%@",infoArray);
                
                [_mapView addAnnotation:annotationPoint];
                
            }

            
        }
        else
        {
            [ApplicationDelegate showAlert:@"No Match Found"];
        }
        [tblEvnt reloadData];
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}

#pragma mark Table View DataSource/Delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:244.0/255.0 alpha:1.0f];
    if (([searchResults count]>0) && isSearching ) {
       
        return [[searchResults objectAtIndex:0]count];
     }
    else
    {
       return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier;
    
    CellIdentifier = @"cellsearchEvt";
    
    UITableViewCell *cell = [tblEvnt dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(isSearching && [[searchResults objectAtIndex:0]count]){
        UIImageView* locImgVws=(UIImageView*)[cell
                                              viewWithTag:301];
        UILabel* locTypeLbls=(UILabel*)[cell viewWithTag:303];
        UILabel* locNameLbls=(UILabel*)[cell viewWithTag:302];
        NSLog(@"%lu",(unsigned long)[[searchResults objectAtIndex:0]count]);
        NSLog(@"%@",[[[searchResults objectAtIndex:0] objectAtIndex:indexPath.row ]valueForKey:@"name"]);
        
        if(locImgVws)
        {
            
            [locImgVws sd_setImageWithURL:[NSURL URLWithString:[[[searchResults objectAtIndex:0] objectAtIndex:indexPath.row ] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
            locImgVws.layer.cornerRadius =  20;//half of the width and height
            locImgVws.layer.masksToBounds = YES;
            
        }
        if(locTypeLbls)
        {    locTypeLbls.text=[[[searchResults objectAtIndex:0] objectAtIndex:indexPath.row ]valueForKey:@"location"];
            
        }
        if(locNameLbls)
        {
            locNameLbls.text=[[[searchResults objectAtIndex:0] objectAtIndex:indexPath.row ] valueForKey:@"name"];
        }
    }
        return cell;
}
/**
 *  Little helper for generating plain white image used as a placeholder
 *  in UITableViewCell's while loading icon images
 */
- (UIImage *)placeholderImage
{
    static UIImage *PlaceholderImage;
    
    if (!PlaceholderImage)
    {
        CGRect rect = CGRectMake(0, 0, 50.0f, 50.0f);
        UIGraphicsBeginImageContext(rect.size);
        [[UIColor whiteColor] setFill];
        [[UIBezierPath bezierPathWithRect:rect] fill];
        PlaceholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return PlaceholderImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if(isSearching && [[searchResults objectAtIndex:0]count]){
      MAEventDescVC * objEventDescVC=VCWithIdentifier(@"MAEventDescVC");
    objEventDescVC.eventId=[[[searchResults objectAtIndex:0] objectAtIndex:indexPath.row ]valueForKey:@"id"];
    [self.navigationController pushViewController:objEventDescVC animated:YES];
     }

}
@end

