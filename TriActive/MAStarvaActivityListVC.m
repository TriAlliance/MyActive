//
//  MAStarvaActivityListVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 17/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MAStarvaActivityListVC.h"
#import "FRDStravaClientImports.h"
#import "ActivityHelper.h"
#import "IconHelper.h"
#import "UIImageView+WebCache.h"
#import "ActivitiesMapViewController.h"
@interface MAStarvaActivityListVC ()

@end

@implementation MAStarvaActivityListVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activities = @[];
    self.pageIndex = 1;
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Strava Activites"];
    [self fetchNextPage];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"smileys" ofType:@"plist"];
    NSDictionary *dict =  [NSDictionary dictionaryWithContentsOfFile:path];
    arrActivity = [dict objectForKey:@"StravaActivity"];
    NSLog(@"get array%@", [dict objectForKey:@"StravaActivity"]);
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDateFormatter *) dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return _dateFormatter;
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"more"
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


-(void) fetchNextPage
{
    [self showSpinner];
    
    void(^successBlock)(NSArray *activities) = ^(NSArray *activities) {
      
        self.pageIndex++;
        self.activities = [self.activities arrayByAddingObjectsFromArray:activities];
        [tbl_StravaActList reloadData];
        NSInteger lastRow = self.activities.count-1;
        if (lastRow > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            [tbl_StravaActList scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:YES];
        }
        [self showMoreButton];
    };
    
    void(^failureBlock)(NSError *error) = ^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Miserable failure (not you, the call)"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self showMoreButton];
    };
    
    if (self.mode == ActivitiesListModeCurrentAthlete) {
        [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentAthleteWithPageSize:5
                                                                             pageIndex:self.pageIndex
                                                                               success:successBlock
                                                                               failure:failureBlock];
    } else if (self.mode == ActivitiesListModeFeed) {
        [[FRDStravaClient sharedInstance] fetchFriendActivitiesWithPageSize:5
                                                                  pageIndex:self.pageIndex
                                                                    success:successBlock
                                                                    failure:failureBlock];
    } else if (self.mode == ActivitiesListModeClub) {
        [[FRDStravaClient sharedInstance] fetchActivitiesOfClub:self.clubId
                                                       pageSize:5
                                                      pageIndex:self.pageIndex
                                                        success:successBlock
                                                        failure:failureBlock];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    CellIdentifier = @"ActivityCell";
    
    UITableViewCell *cell = [tbl_StravaActList dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    StravaActivity *activity = self.activities[indexPath.row];
    MALog(@"StravaActivity==%@",activity);
    
    //UIImageView* userImageView=(UIImageView*)[cell viewWithTag:105];
    UILabel* dateLabel=(UILabel*)[cell  viewWithTag:101];
    UILabel* nameLabel=(UILabel*)[cell viewWithTag:102];
    UILabel* typeLabel=(UILabel*)[cell  viewWithTag:103];
    UILabel* distanceLabel=(UILabel*)[cell  viewWithTag:106];
    UILabel* durationLabel=(UILabel*)[cell viewWithTag:104];
  
    if(dateLabel)
    {
        dateLabel.text=[self.dateFormatter stringFromDate:activity.startDate];
    }
    if(nameLabel)
    {
        nameLabel.text=activity.name;
    }
    if(distanceLabel)
    {
      
        distanceLabel.text = [NSString stringWithFormat:@"%.1f Km", activity.distance/ 1000.00];
    }
    if(durationLabel)
    {
        
        NSMutableString *durationStr= [NSMutableString new];
        int hours = (int)floorf(activity.movingTime / 3600);
        int minutes = (activity.movingTime - hours * 3600)/60.0f;
        [durationStr appendFormat:@"%dh %02d", hours, minutes];
        durationLabel.text = durationStr;
      
    }
    if(typeLabel)
    {
        if ([[arrActivity valueForKey:@"key"] containsObject:[NSString stringWithFormat:@"%li",activity.type]]) {
            
            NSUInteger index = [[arrActivity valueForKey:@"key"] indexOfObject:[NSString stringWithFormat:@"%li",activity.type]];
            if (index != NSNotFound) {
              
                typeLabel.text=[[arrActivity objectAtIndex:index ] valueForKey:@"value"];
               
            }
        }
      // typeLabel.text=[NSString stringWithFormat:@"%li", activity.type];
    }
   return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  78.0f;
}


- (IBAction)moreAction:(id)sender
{
    [self fetchNextPage];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
      StravaActivity *activity = self.activities[indexPath.row];
    UITableViewCell *cell = [tbl_StravaActList cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:127.0/255.0 green:179.0/255.0 blue:226.0/255.0 alpha:1.0f];
  MALog(@"StravaActivity==%@",activity);
    ActivitiesMapViewController *objMap=VCWithIdentifier(@"ActivitiesMapViewController");
   
    objMap.activityID=  [NSString stringWithFormat:@"%li",activity.id] ;
    [self.navigationController pushViewController:objMap animated:YES];
    NSLog(@"%@activity", activity);
}
@end

