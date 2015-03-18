//
//  MAEventDescVC.m
//  MyActive
//
//  Created by Jimcy Goyal on 22/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAEventDescVC.h"
#define METERS_PER_MILE 1609.344
@interface MAEventDescVC ()

@end

@implementation MAEventDescVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Event detail"];
    
    ArrEvtData=[[NSMutableArray alloc] init];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [self callEventDetailAPI];
}

-(void)locationData:(NSString *)value
{
    NSLog(@"eventId%@",value);
    _eventId =value;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)leftBtn
{
    if ([self.tabBarController.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.tabBarController.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
        
        [self.tabBarController.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil afterDelay:0.0];
        
    }
}
-(void)callEventDetailAPI
{
    
    [ArrEvtData removeAllObjects];
    NSDictionary* userInfo = @{
                               @"eventId":_eventId
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API EventDetailWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            
            [ArrEvtData addObject:[responseDict valueForKey:@"data"]];
            MALog(@"ArrGrpData--%@",ArrEvtData);
           
        }else
        {
            [ApplicationDelegate showAlert:ErrorStr];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
         [tblEvtDetail reloadData];
    }];
}

#pragma mark
#pragma mark Map View Delegate  Method
#pragma mark
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"current"];
    UIImageView *houseIconView = [[UIImageView alloc] init];
    NSURL *ImageURL = [NSURL URLWithString:[[ArrEvtData objectAtIndex:0] valueForKey:@"image"]];
    [houseIconView setFrame:CGRectMake(0, 0, 30, 30)];
    [houseIconView sd_setImageWithURL:ImageURL placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
    pinAnnotationView.leftCalloutAccessoryView = houseIconView;
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    pinAnnotationView.canShowCallout = YES;
    return pinAnnotationView;
}
#pragma mark
#pragma mark Table View DataSource/Delegates
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(section ==1)
        return 7.0f;
    else
        return 0.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 512.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Celleventdesc";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UILabel* txtName;
    UILabel* txtType;
    UILabel* txtDate;
    UILabel* txtfollower;
    UIButton* btnFollow;
    UIButton* btnEdit;
    btnFollow = (UIButton *)[cell.contentView viewWithTag:904];
    btnEdit = (UIButton *)[cell.contentView viewWithTag:905];
    
    UITextView * lblDesc=(UITextView *)[cell.contentView viewWithTag:1031];
    UIImageView *profileImageVw = (UIImageView *)[cell.contentView  viewWithTag:906];
    txtName = (UILabel *)[cell.contentView viewWithTag:901];
    txtDate = (UILabel *)[cell.contentView viewWithTag:1041];
    txtType = (UILabel *)[cell.contentView viewWithTag:902];
    txtfollower = (UILabel *)[cell.contentView viewWithTag:903];
    
    if([ArrEvtData count]>0){
        
        [profileImageVw sd_setImageWithURL:[NSURL URLWithString:[[ArrEvtData objectAtIndex:0] valueForKey:@"image"]] placeholderImage:CoverPlaceholder options:SDWebImageRetryFailed];
        
        if(txtName)
        {
            txtName.text=[[ArrEvtData objectAtIndex:0]  valueForKey:@"name"];
        }
        if(txtType)
        {
            txtType.text=[[ArrEvtData objectAtIndex:0] valueForKey:@"type"];
        }
        if(txtDate)
        {
            txtDate.text=[[ArrEvtData objectAtIndex:0] valueForKey:@"date"];
        }
        if(txtfollower)
        {
            txtfollower.text=[[ArrEvtData objectAtIndex:indexPath.row] valueForKey:@"followers"];
        }
        if(lblDesc){
            lblDesc.text=[[ArrEvtData objectAtIndex:0] valueForKey:@"description"];
            lblDesc.layer.borderColor = [UIColor blackColor].CGColor;
            lblDesc.layer.borderWidth = 1.0f;
        }
        if(btnFollow && btnEdit)
        {
            if ([[NSString stringWithFormat:@"%@",[[ArrEvtData objectAtIndex:indexPath.row] valueForKey:@"evnt_creator_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]]])
                
            {
                btnFollow.hidden=YES;
                btnEdit.hidden=NO;
            }
            else
            {
                btnFollow.hidden=NO;
                btnFollow = (UIButton *)[cell.contentView viewWithTag:904];
                 [btnFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                NSUInteger index = [[[[ArrEvtData objectAtIndex:0] valueForKey:@"followers_arr"] valueForKey:@"id"] indexOfObject:[UserDefaults valueForKey:@"user_id"]];
                if (index != NSNotFound) {
                  
                    [btnFollow setTitle:@"Following" forState:UIControlStateNormal];
                    [btnFollow  setUserInteractionEnabled:NO];
                }
                else{
                    [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                    [btnFollow  setUserInteractionEnabled:YES];
                }

//
                if (btnFollow) {
                    [btnFollow addTarget:self action:@selector(btnPressed_followed:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                btnEdit.hidden=YES;
            }
            
        }
        MKMapView *mapView=(MKMapView *)[cell.contentView viewWithTag:1021];
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude
        = [[[ArrEvtData objectAtIndex:0] valueForKey:@"lat"] doubleValue];
        
        zoomLocation.longitude
        = [[[ArrEvtData objectAtIndex:0] valueForKey:@"lng"] doubleValue];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [mapView setRegion:viewRegion animated:YES];
        
        MALog(@"%@",[[ArrEvtData objectAtIndex:0] valueForKey:@"name"]);
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = zoomLocation;
        annotationPoint.title = [[ArrEvtData objectAtIndex:0] valueForKey:@"name"];
        [mapView addAnnotation:annotationPoint];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (IBAction)btnPressed_editEvent:(id)sender {
    MAAddEventVC *objEvent=VCWithIdentifier(@"MAAddEventVC");
    objEvent.arrEditData=ArrEvtData;
    [self.navigationController pushViewController:objEvent animated:YES];
}
// ACCEPTED PARMS: event_id,follower_id,type

- (IBAction)btnPressed_followed:(id)sender {
    
    NSDictionary* userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                               @"id":_eventId,
                               @"type":@"follow",
                               @"post_type":@"event"
                               };
     [ApplicationDelegate show_LoadingIndicator];
        [API followEventWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)
            {
                [self callEventDetailAPI];
                [ApplicationDelegate showAlert:@"You have successfully follow Event"];
            }
            else
            {
                [ApplicationDelegate showAlert:ErrorStr];
            }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
}
@end
