//
//  MAAddFriendVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 11/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAAddFriendVC.h"
#import "MAInviteFriendVC.h"

@interface MAAddFriendVC ()

@end

@implementation MAAddFriendVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // Do any additional setup after loading the view, typically from a nib.
    isSearching=false;
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Friends"];
    self.navigationItem.title = @"";
    if([_settingPg isEqualToString:@"settingPage"]){
        
        
    }
    else{
        self.navigationItem.leftBarButtonItem = [Utility leftbar:[UIImage imageNamed:@"sideMenu.png"] :self];
    }
    
    
    [Utility swipeSideMenu:self];
    
    dataArray = [[NSMutableArray alloc] init];
   searchResults=[[NSMutableArray alloc]init];
    //Initialize the dataArray
    NSDictionary *tempDict=@{@"name":@"Contacts",
                             @"imageFile":@"icon-contacts.png",
                             @"detail":@"New York"
                             };
    NSDictionary *tempDict1=@{@"name":@"Facebook",
                              @"imageFile":@"icon-facebook.png",
                              @"detail":@"New York"
                              };
    NSDictionary *tempDict2=@{@"name":@"Twitter",
                              @"imageFile":@"icon-twitter.png",
                              @"detail":@"New York"
                              };
   //NSDictionary *tempDict3=@{@"name":@"Instagram",
                           // @"imageFile":@"icon-instagram.png",
                            // @"detail":@"New York"
                           // };
    [dataArray addObject:tempDict];
    [dataArray addObject:tempDict1];
    [dataArray addObject:tempDict2];
    //[dataArray addObject:tempDict3];
    
    [self callSuggestionAPI];
    
}

-(void)callSuggestionAPI
{
    NSDictionary* userInfo = @{@"userid":[UserDefaults valueForKey:@"user_id"]};

    [ApplicationDelegate show_LoadingIndicator];
    [API suggestionsFollowWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            arrSugestion = [[NSMutableArray alloc] init];
            [arrSugestion addObject:[responseDict valueForKey:@"data"]];
            
        }else
        {
            [arrSugestion removeAllObjects];
            [ApplicationDelegate showAlert:@"No  suggestion"];
        }
        [friendTable reloadData];
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}
-(void)callFollowAPI:(NSString *)followId
{
    NSDictionary* userInfo = @{@"userid":[UserDefaults valueForKey:@"user_id"],
                               @"followerid":followId};
    
    [ApplicationDelegate show_LoadingIndicator];
    [API followUsersWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            [ApplicationDelegate showAlert:@"You have successfully follow user"];
            [self callSuggestionAPI];
        }
        else if([[responseDict valueForKey:@"result"] intValue] == 0)

        {
            [arrSugestion removeAllObjects];
//            [ApplicationDelegate showAlert:@"No suggestion"];
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


#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)leftBtn
{
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
        
        [self.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil afterDelay:0.0];
    }
}


#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isSearching){
        return 1;
    }
    else {
        return 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(isSearching){
        
        if ([searchResults count]){
            MALog(@"%lu", (unsigned long)[searchResults count]);
            return [searchResults count];
        }else
        {
            return 0;
        }
    }
    else{
        if(section== 0)
        {
            return [dataArray count];
            
        }
        else if(section == 1)
        {
            if([arrSugestion  count]){
                return [[arrSugestion objectAtIndex:0] count];
            }
            else
            {
                return 0;
            }
           
        }
        else
        {
            return 0;
        }
        
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customTitleView = [[UIView alloc] init];
    [customTitleView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:244.0/255.0 alpha:1.0f]];
    if(section == 1){
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 300, 44)];
        titleLabel.text = @"Suggestions";
        titleLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:103.0/255.0 blue:198.0/255.0 alpha:1.0f];
        titleLabel.font = ROBOTO_LIGHT(17.0);
        [customTitleView addSubview:titleLabel];
        [customTitleView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:244.0/255.0 alpha:1.0f]];
    }
    return customTitleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
     if(isSearching){
          return 0.0f;
     }
     else{
         if (section == 0 )
            return 0.0f;
   
         else if (section == 1 ){
             return 50.0f;
         }
            else
            return 0.0f;
     }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSearching){
        return 58.0f;
    }
    else
    {
        if (indexPath.section==0 ){
            
            return 45.0f;
        }
        else
            return 58.0f;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dictionary1 = nil;
    
    static NSString *CellIdentifier;
    if(isSearching){
        CellIdentifier = @"resultCell";
        
    }
    else{
        if(indexPath.section==0){
            CellIdentifier = @"addFriendCell";
            
        }
        else if(indexPath.section==1)
        {
            CellIdentifier = @"sugesstionCell";
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(isSearching){
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        {
                        if([searchResults count]){
                            MALog(@"%lu",(long)indexPath.row);

                NSDictionary *dictionary =  [searchResults  objectAtIndex:indexPath.row];
               
                NSString *cellValue = [dictionary objectForKey:@"profile_image"];
                UIImageView *ImageView = (UIImageView *)[cell viewWithTag:501];
                
                ImageView.layer.cornerRadius =  20;//half of the width and height
                ImageView.layer.masksToBounds = YES;
                
                [ImageView sd_setImageWithURL:[NSURL URLWithString:cellValue] placeholderImage:[UIImage imageNamed:@"PicPlaceholderqw.png"] options:SDWebImageRetryFailed];
                
                UILabel *NameLabel = (UILabel *)[cell viewWithTag:502];
                NameLabel.text = [NSString stringWithFormat:@"%@ %@",[dictionary objectForKey:@"first_name"],[dictionary objectForKey:@"last_name"]];
                NameLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
                NameLabel.font = ROBOTO_MEDIUM(14.0);
                            
                UILabel *countryNameLabel = (UILabel *)[cell viewWithTag:503];
                countryNameLabel.text = [dictionary objectForKey:@"city"];
                countryNameLabel.textColor = [UIColor colorWithRed:164.0/255.0 green:165.0/255.0 blue:167.0/255.0 alpha:1.0f];
                countryNameLabel.font = ROBOTO_MEDIUM(11.0);
            }
                     }
    }
    else
    {
        if(indexPath.section==0 && (!isSearching))
        {
            
            dictionary1=[dataArray objectAtIndex:indexPath.row];
            NSString *imgValue = [dictionary1 objectForKey:@"imageFile"];
            UIImageView *ImageView = (UIImageView *)[cell viewWithTag:100];
            ImageView.image = [UIImage imageNamed:imgValue];
            UILabel *NameLabel = (UILabel *)[cell viewWithTag:101];
            NameLabel.text = [dictionary1 objectForKey:@"name"];
            NameLabel.font = ROBOTO_LIGHT(16.0);
            
            
        }
        else if(indexPath.section==1 && (!isSearching)){
            if([[arrSugestion objectAtIndex:0] count]){
                
                NSDictionary *dictionary =  [[arrSugestion objectAtIndex:0] objectAtIndex:indexPath.row];
                
                NSString *cellValue = [dictionary objectForKey:@"profile_image"];
                UIImageView *ImageView = (UIImageView *)[cell viewWithTag:103];
                
                ImageView.layer.cornerRadius =  20;//half of the width and height
                ImageView.layer.masksToBounds = YES;
                
                [ImageView sd_setImageWithURL:[NSURL URLWithString:cellValue] placeholderImage:[UIImage imageNamed:@"PicPlaceholderqw.png"] options:SDWebImageRetryFailed];
                
                UILabel *NameLabel = (UILabel *)[cell viewWithTag:104];
                NameLabel.text = [NSString stringWithFormat:@"%@ %@",[dictionary objectForKey:@"first_name"],[dictionary objectForKey:@"last_name"]];
                NameLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
                NameLabel.font = ROBOTO_MEDIUM(14.0);
                UILabel *countryNameLabel = (UILabel *)[cell viewWithTag:105];
                countryNameLabel.text = [dictionary objectForKey:@"city"];
                countryNameLabel.textColor = [UIColor colorWithRed:164.0/255.0 green:165.0/255.0 blue:167.0/255.0 alpha:1.0f];
                countryNameLabel.font = ROBOTO_MEDIUM(11.0);
            }
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
       NSString *selectedCell = nil;
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.row];
        selectedCell = [dictionary objectForKey:@"name"];
         NSLog(@"%@", selectedCell);
        MAInviteFriendVC *objList=VCWithIdentifier(@"MAInviteFriendVC");
        if([selectedCell isEqualToString:@"Contacts"]){
            objList.keyword=@"Contacts";
        }
        else if([selectedCell isEqualToString:@"Facebook"]){
            objList.keyword=@"Facebook";
        }
        else{
               objList.keyword=@"Twitter";
        }
   
    [self.navigationController pushViewController:objList animated:YES];
    }
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
        [friendTable reloadData];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    [searchBar setShowsCancelButton:YES animated:YES];
    isSearching= NO;
    [friendTable reloadData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchResults removeAllObjects];
    [self filterContentForSearchText:searchBar.text];
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    }


-(void)filterContentForSearchText:(NSString*)searchText
{
   
    for (NSMutableArray *dict in [arrSugestion objectAtIndex:0])
    {
        
        NSString *string =[dict valueForKey:@"first_name"];
        
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
    [friendTable reloadData];
    
}- (IBAction)btnPressed_Follow:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:friendTable];
    NSIndexPath *indexPath = [friendTable indexPathForRowAtPoint:buttonPosition];
    //MALog(@"follow-indexPath--%ld",(long)indexPath.row);
    NSString *getId=  [[[arrSugestion objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"id"];
    MALog(@"follow-ID--%@",getId);
    [self callFollowAPI:getId];
    
}

@end
