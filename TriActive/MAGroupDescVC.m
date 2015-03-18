//
//  MAGroupDescVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 31/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAGroupDescVC.h"
#define METERS_PER_MILE 1609.344
@interface MAGroupDescVC ()

@end

@implementation MAGroupDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Group Detail"];
    ArrGrpData=[[NSMutableArray alloc] init];
    NSLog(@"responseDict--%@",_groupId);

     [self callGrpDetailAPI ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self callGrpDetailAPI ];
    
}
-(void)callGrpDetailAPI
{
    [ArrGrpData removeAllObjects];
    NSDictionary* userInfo = @{
                                @"grpid":_groupId
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API GrpDetailWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            [ArrGrpData addObject:[responseDict valueForKey:@"data"]];
           
        }else
        {
            [ApplicationDelegate showAlert:ErrorStr];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
         [tblGrpDetail reloadData];
    }];
}
#pragma mark
#pragma mark Map View Delegate  Method
#pragma mark
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"current"];
    UIImageView *houseIconView = [[UIImageView alloc] init];
    NSURL *ImageURL = [NSURL URLWithString:[[ArrGrpData objectAtIndex:0] valueForKey:@"image"]];
    [houseIconView setFrame:CGRectMake(0, 0, 30, 30)];
    [houseIconView sd_setImageWithURL:ImageURL placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
    pinAnnotationView.leftCalloutAccessoryView = houseIconView;
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    pinAnnotationView.canShowCallout = YES;
    return pinAnnotationView;
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
    
    static NSString *CellIdentifier = @"Cellgrpdesc";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UILabel* txtName;
    UILabel* txtType;
    UILabel* txtfollower;
    UITextView * lblDesc=(UITextView *)[cell.contentView viewWithTag:1031];
 
    UIImageView *profileImageVw = (UIImageView *)[cell.contentView  viewWithTag:906];
    
    txtName = (UILabel *)[cell.contentView viewWithTag:901];
    txtType = (UILabel *)[cell.contentView viewWithTag:902];
    txtfollower = (UILabel *)[cell.contentView viewWithTag:903];
    UIButton* btnFollow;
    UIButton* btnEdit;
    btnFollow = (UIButton *)[cell.contentView viewWithTag:904];
    btnEdit = (UIButton *)[cell.contentView viewWithTag:905];
   
    if([ArrGrpData count]>0){
         [profileImageVw sd_setImageWithURL:[NSURL URLWithString:[[ArrGrpData objectAtIndex:indexPath.row] valueForKey:@"image"]] placeholderImage:CoverPlaceholder options:SDWebImageRetryFailed];
        
        if(txtName)
        {
            txtName.text=[[ArrGrpData objectAtIndex:indexPath.row]  valueForKey:@"name"];
        }
        if(txtType)
        {
            txtType.text=[[ArrGrpData objectAtIndex:indexPath.row] valueForKey:@"type"];
        }
        if(txtfollower)
        {
            txtfollower.text=[[ArrGrpData objectAtIndex:indexPath.row] valueForKey:@"followers"];
        }
        if(lblDesc){
            lblDesc.text=[[ArrGrpData objectAtIndex:0] valueForKey:@"description"];
            lblDesc.layer.borderColor = [UIColor blackColor].CGColor;
            lblDesc.layer.borderWidth = 1.0f;
        }
        if(btnFollow && btnEdit)
        {
          if ([[NSString stringWithFormat:@"%@",[[ArrGrpData objectAtIndex:indexPath.row] valueForKey:@"grp_creator_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]]])
          
            {
                btnFollow.hidden=YES;
                btnEdit.hidden=NO;
            }
            else
            {
                btnFollow.hidden=NO;
                btnFollow = (UIButton *)[cell.contentView viewWithTag:904];
                [btnFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                NSUInteger index = [[[[ArrGrpData objectAtIndex:0] valueForKey:@"followers_arr"] valueForKey:@"id"] indexOfObject:[UserDefaults valueForKey:@"user_id"]];
                if (index != NSNotFound) {
                    
                    [btnFollow setTitle:@"Following" forState:UIControlStateNormal];
                    [btnFollow  setUserInteractionEnabled:NO];
                }
                else{
                    [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                    [btnFollow  setUserInteractionEnabled:YES];
                }
                if (btnFollow) {
                    [btnFollow addTarget:self action:@selector(btnPressed_followed:) forControlEvents:UIControlEventTouchUpInside];
                }

                btnEdit.hidden=YES;
            }
        }
        if ([[ArrGrpData objectAtIndex:0] valueForKey:@"lat"] != nil || [[ArrGrpData objectAtIndex:0] valueForKey:@"lng"] != nil) {
       
        MKMapView *mapView=(MKMapView *)[cell.contentView viewWithTag:1021];
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude
        = [[[ArrGrpData objectAtIndex:0] valueForKey:@"lat"] doubleValue];
        
        zoomLocation.longitude
        = [[[ArrGrpData objectAtIndex:0] valueForKey:@"lng"] doubleValue];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [mapView setRegion:viewRegion animated:YES];
        
        MALog(@"%@",[[ArrGrpData objectAtIndex:0] valueForKey:@"name"]);
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = zoomLocation;
        annotationPoint.title = [[ArrGrpData objectAtIndex:0] valueForKey:@"name"];
        [mapView addAnnotation:annotationPoint];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (IBAction)btnPressed_editGroup:(id)sender {
    MAAddGroupsVC *objEvent=VCWithIdentifier(@"MAAddGroupsVC");
    objEvent.arrEditData=ArrGrpData;
    [self.navigationController pushViewController:objEvent animated:YES];
}
- (IBAction)btnPressed_followed:(id)sender {
    
    NSDictionary* userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                               @"id":_groupId,
                               @"post_type":@"group",
                               @"type":@"follow"
                               };
      [ApplicationDelegate show_LoadingIndicator];
      [API followGroupWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            [self callGrpDetailAPI ];
            [ApplicationDelegate showAlert:@"You have successfully follow Group"];
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