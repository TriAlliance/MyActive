//
//  MAAddLocationVC.m
//  MyActive
//
//  Created by Jimcy Goyal on 22/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAAddLocationVC.h"

@interface MAAddLocationVC ()

@end

@implementation MAAddLocationVC

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
    
    NSLog(@"%@",ApplicationDelegate.latitude);
    NSLog(@"%@",ApplicationDelegate.longitude);
    searchResults=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Location"];
    arrLocationImages=[[NSMutableArray alloc]initWithObjects:@"post-image.png", nil];
    arrLocationName=[[NSMutableArray alloc]initWithObjects:@"John Doe International Airport", nil];
    arrLocationType=[[NSMutableArray alloc]initWithObjects:@"Airport", nil];
    
    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=500&types=establishment&key=AIzaSyBbmiSemQkmbl_KgXGW1qoexCCFj65fBPo",ApplicationDelegate.latitude,ApplicationDelegate.longitude];//ApplicationDelegate.latitude,ApplicationDelegate.longitude
    [ApplicationDelegate show_LoadingIndicator];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                   {
                       // Background work
                       
                       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
                       NSError *e = nil;
                       NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
                       _results=[[NSMutableArray alloc]init];
                       _results=[json valueForKey:@"results"];
                       
                       NSLog(@"%@",[json valueForKey:@"results"]);
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                          
                                          // Main thread work (UI usually)
                                          [tblLocation reloadData];
                                          if ([ApplicationDelegate isHudShown]) {
                                              [ApplicationDelegate hide_LoadingIndicator];
                                          }
                                      });
                   });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    selectAll = YES;
    //[_results removeAllObjects];
    [searchResults removeAllObjects];
    [self searchBarCancelButtonClicked:SearchBar];
    
    
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
        [tblLocation reloadData];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    [searchBar setShowsCancelButton:YES animated:YES];
    isSearching = NO;
    [tblLocation reloadData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterContentForSearchText:searchBar.text];
   
    [searchBar resignFirstResponder];
    
}


-(void)filterContentForSearchText:(NSString*)searchText
{
    [searchResults removeAllObjects];
    
    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&sensor=false&key=AIzaSyBbmiSemQkmbl_KgXGW1qoexCCFj65fBPo",searchText];//
    NSString* encodedUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
  //  ApplicationDelegate.latitude,ApplicationDelegate.longitude
    [ApplicationDelegate show_LoadingIndicator];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                   {
                       // Background work
                       
                       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedUrl]];
                       NSError *e = nil;
                        NSLog(@"%@data",data);
                       if(data != nil){
                       NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
                       searchResults=[[NSMutableArray alloc]init];
                       MALog(@"result%@",[json valueForKey:@"results"]);
                       searchResults=[json valueForKey:@"results"];
                       if (searchResults.count == 0) {
                          
                           [ApplicationDelegate showAlert:@"No Result Found"];
                       }
                       
                       NSLog(@"%@searchResults",[json valueForKey:@"results"]);
                           }
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                          
                                          // Main thread work (UI usually)
                                          isSearching=TRUE;
                                          [tblLocation reloadData];
                                          if ([ApplicationDelegate isHudShown]) {
                                              [ApplicationDelegate hide_LoadingIndicator];
                                          }
                                      });
                   });
    


   
    isSearching=TRUE;
   // [tblLocation reloadData];
}

#pragma mark Table View DataSource/Delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isSearching) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:244.0/255.0 alpha:1.0f];
        return [searchResults count];
        
    }
    else
    {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:244.0/255.0 alpha:1.0f];
        return _results.count;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50.0f;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier;
    
    CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tblLocation dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(isSearching){
        if (searchResults.count){
        UIImageView* locImgVws=(UIImageView*)[cell
                                              viewWithTag:1];
        UILabel* locTypeLbls=(UILabel*)[cell viewWithTag:3];
        UILabel* locNameLbls=(UILabel*)[cell viewWithTag:2];
        NSLog(@"%@",CellIdentifier);
        NSLog(@"%@",[[searchResults objectAtIndex:0] valueForKey:@"name"]);
        
        if(locImgVws)
        {
            [locImgVws sd_setImageWithURL:[NSURL URLWithString:[[searchResults objectAtIndex:indexPath.row] valueForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
            
        }
        if(locTypeLbls)
        {    locTypeLbls.text=[[searchResults objectAtIndex:indexPath.row] valueForKey:@"formatted_address"];
            
        }
        if(locNameLbls)
        {
            locNameLbls.text=[[searchResults objectAtIndex:indexPath.row] valueForKey:@"name"];
        }
       }
    }
    else if (_results.count){
        UIImageView* locImgVw=(UIImageView*)[cell viewWithTag:1];
        UILabel* locTypeLbl=(UILabel*)[cell  viewWithTag:3];
        UILabel* locNameLbl=(UILabel*)[cell viewWithTag:2];
        if(locImgVw)
        {
            [locImgVw sd_setImageWithURL:[NSURL URLWithString:[[_results objectAtIndex:indexPath.row] valueForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
            
        }
        if(locTypeLbl)
        {    locTypeLbl.text=[[_results objectAtIndex:indexPath.row] valueForKey:@"vicinity"];
            //locTypeLbl.text=[arrLocationType objectAtIndex:indexPath.row];
        }
        if(locNameLbl)
        {
            locNameLbl.text=[[_results objectAtIndex:indexPath.row] valueForKey:@"name"];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:127.0/255.0 green:179.0/255.0 blue:226.0/255.0 alpha:1.0f];
    
    UILabel *custLabel = (UILabel*)[cell viewWithTag:2];
    NSDictionary *tempDict;
    if(isSearching){
    tempDict=@{@"lng":[[[[searchResults objectAtIndex:indexPath.row] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"],
                                 @"lat":[[[[searchResults objectAtIndex:indexPath.row] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"],
                                 @"location":custLabel.text
                                 };
}
    else{
       tempDict=@{@"lng":[[[[_results objectAtIndex:indexPath.row] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"],
                                 @"lat":[[[[_results objectAtIndex:indexPath.row] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"],
                                 @"location":custLabel.text
                                 };
    }


    id<locationDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(locationData:)]) {
        
        [strongDelegate locationData:tempDict];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
