//
//  MAPostMusicVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 13/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAPostMusicVC.h"
#import "MAPostVC.h"
#define iTunesSearchApi @"http://itunes.apple.com/search?term=%@&entity=%@"
@interface MAPostMusicVC ()
{
    NSString* category;
    NSMutableArray* imgURLArr;
    NSMutableArray *previewURLArr;
}
@end

@implementation MAPostMusicVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Music"];
    iTunesDict=[[NSMutableDictionary alloc]init];
    //NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:iTunesSearchApi,]]
    category=nil;
    resultArr=[[NSMutableArray alloc]init];
    imgURLArr=[[NSMutableArray alloc]init];
    previewURLArr=[[NSMutableArray alloc]init];
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark
#pragma mark API methods
#pragma mark

- (void)failedToLoad
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [ApplicationDelegate hide_LoadingIndicator];
        ShowAlertWithTitleNMessage(@"Message", @"Error occured, please try again later.");
        
    });
}

- (NSDictionary*) getDictionaryFromJson:(NSData*)jsonData
{
    NSError *error;
    
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    return jsonDict;
}

- (NSDictionary*)urlToDictionaryOnBackground:(NSURL*)url
{
    NSError *error;
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&error];
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dictionary=[[NSDictionary alloc]init];
    if (jsonData == nil)
        [self failedToLoad];
    
    else {
        dictionary = [self getDictionaryFromJson:jsonData];
        if (dictionary == nil) {
            [ApplicationDelegate hide_LoadingIndicator];
            [self failedToLoad];
        }
    }
    return dictionary;
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
    if([resultArr count]==0)
    {
        return 0;
    }
    
    else
    {
        return [resultArr count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellPostMusic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel* trackName=(UILabel*)[cell.contentView viewWithTag:8001];
    UILabel* lblDetail=(UILabel*)[cell.contentView viewWithTag:8002];
    UIImageView* imageVw=(UIImageView*)[cell.contentView viewWithTag:8000];
   
   
   if([category isEqualToString:@"song"])
    {
        trackName.text=[[resultArr objectAtIndex:indexPath.row]valueForKey:@"trackName"];
        [imageVw sd_setImageWithURL:[NSURL URLWithString:[[resultArr objectAtIndex:indexPath.row] valueForKey:@"artworkUrl60"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
        lblDetail.text=[NSString stringWithFormat:@"by %@ on %@", [[resultArr objectAtIndex:indexPath.row] valueForKey:@"artistName"], [[resultArr objectAtIndex:indexPath.row] valueForKey:@"collectionCensoredName"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([category isEqualToString:@"song"])
    {
       
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *custLabel = (UILabel*)[cell viewWithTag:8001];
        id<musicDelegate> strongDelegate = self.delegate;
        if ([strongDelegate respondsToSelector:@selector(musicData:)]) {
                [strongDelegate musicData:custLabel.text];
        }
        
         [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBarPostMusic setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    [searchBarPostMusic setShowsCancelButton:NO animated:YES];
    [searchBarPostMusic resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isSearching = NO;
        [tbl_itunes_music reloadData];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBarPostMusic resignFirstResponder];
    searchBarPostMusic.text=@"";
    [searchBarPostMusic setShowsCancelButton:YES animated:YES];
    isSearching = NO;
    [tbl_itunes_music reloadData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [ApplicationDelegate show_LoadingIndicator];
    category=@"song";
    iTunesUrl=[NSURL URLWithString:[NSString stringWithFormat:iTunesSearchApi,searchBar.text,@"song"]];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        iTunesDict=[self performSelector:@selector(urlToDictionaryOnBackground:) withObject:iTunesUrl];
//         NSLog(@"%@",iTunesDict );
        resultArr=[iTunesDict valueForKey:@"results"];
//        NSLog(@"%@",resultArr );
        dispatch_async(dispatch_get_main_queue(), ^{
            [ApplicationDelegate hide_LoadingIndicator];
            [tbl_itunes_music reloadData];
        });
    });
    
    

    //[self filterContentForSearchText:searchBar.text];
    //TPLog(@"filteredArray--%@",searchResults);
    [searchBar resignFirstResponder];
    
}


-(void)filterContentForSearchText:(NSString*)searchText
{
    [searchResults removeAllObjects];
    for (NSMutableArray *dict in resultArr)
    {
        NSString *string =[dict valueForKey:@"name"];
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange searchRange = NSMakeRange(0, string.length);
        NSRange foundRange = [string rangeOfString:searchText options:searchOptions range:searchRange];
        if (foundRange.length > 0)
        {
            [searchResults addObject:dict];
        }
    }
    isSearching=TRUE;
    [tbl_itunes_music reloadData];
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


@end
