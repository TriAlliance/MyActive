//
//  MAActivityVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 10/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAActivityVC.h"
#import "MAPostVC.h"
@interface MAActivityVC ()

@end

@implementation MAActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    imgActivity=[[NSArray alloc]init];
    txtActivity=[[NSArray alloc]init];
    searchResults=[[NSMutableArray alloc]init];
    if([_myGoal isEqualToString:@"yes"]){
     
        searchBarActivity.frame = CGRectMake(0, 64, 320, 44);
        cvActivity.frame = CGRectMake(0, 108, 320, 524);
    }
    else{
        self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Activity"];
        self.navigationController.navigationBar.translucent = NO;
    }
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"activityIcons" ofType:@"plist"];
    NSDictionary *dict =  [NSDictionary dictionaryWithContentsOfFile:path];
    imgActivity = [dict objectForKey:@"ActivityImages"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    selectAll = YES;
    //[_results removeAllObjects];
    [searchResults removeAllObjects];
    [self searchBarCancelButtonClicked:searchBarActivity];
    
    
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
        [cvActivity reloadData];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    [searchBar setShowsCancelButton:YES animated:YES];
    isSearching = NO;
    [cvActivity reloadData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterContentForSearchText:searchBar.text];
    [searchBar resignFirstResponder];
    
}


-(void)filterContentForSearchText:(NSString*)searchText
{
    [searchResults removeAllObjects];
   for (NSMutableArray *dict in imgActivity)
    {
        
        NSString *string =[dict valueForKey:@"txt"];
    
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange searchRange = NSMakeRange(0, string.length);
        NSRange foundRange = [string rangeOfString:searchText options:searchOptions range:searchRange];
        if (foundRange.length > 0)
        {
            [searchResults addObject:dict];
            NSLog(@"got search%@", searchResults);
        }
    }
    isSearching=TRUE;
    [cvActivity reloadData];
}


#pragma mark Collection View Datasource/Delegates


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if(isSearching){
        return searchResults.count;
    }
    else
    return imgActivity.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cvActivity dequeueReusableCellWithReuseIdentifier:@"cellActivity" forIndexPath:indexPath];
    UIImageView *activityImageView = (UIImageView *)[cell viewWithTag:7000];
    cell.layer.cornerRadius = 5.0f;
    if(isSearching){
      activityImageView.image = [UIImage imageNamed:[[searchResults objectAtIndex:indexPath.row ] valueForKey:@"img"]];
  
    }
    else{
      activityImageView.image = [UIImage imageNamed:[[imgActivity objectAtIndex:indexPath.row ] valueForKey:@"img"]];
    }
    activityImageView.layer.cornerRadius =  10;//half of the width and height
   activityImageView.layer.masksToBounds = YES;
    UILabel* lblsmile=(UILabel*)[cell
                                 viewWithTag:7001];
    if(isSearching){
    lblsmile.text=[[searchResults objectAtIndex:indexPath.row ] valueForKey:@"txt"];
    }
    else
    lblsmile.text=[[imgActivity objectAtIndex:indexPath.row ] valueForKey:@"txt"];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *custLabel = (UILabel*)[cell viewWithTag:7001];
   // NSString *getText=custLabel.text;
    id<activityDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(activityData:)]) {
        [strongDelegate activityData:custLabel.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnPressed_Cancel:(id)sender {
    id<activityDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(activityData:)]) {
        [strongDelegate activityData:@""];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnPressed_Save:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
