//
//  MAAddMusicVC.m
//  MyActive
//
//  Created by Jimcy Goyal on 22/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAAddMusicVC.h"
#import "CustomAlertView.h"
#import "AFHTTPRequestOperationManager.h"
#import "DetailsViewController.h"

#define iTunesSearchApi @"http://itunes.apple.com/search?term=%@&limit=25&country=au&media=music&entity=%@"

@interface MAAddMusicVC ()
{
    NSString* category;
    NSMutableArray* imgURLArr;
    NSMutableArray *previewURLArr;
}
@end

@implementation MAAddMusicVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initia`lization
    }
    return self;
}

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
    
    [self loadTopSongs];
}

-(void)loadTopSongs{
   
    UIButton * buttonTopSongs = (UIButton*)[self.view viewWithTag:101];
    [buttonTopSongs setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [ApplicationDelegate show_LoadingIndicator];
    category=@"song";
    NSString * url=[NSString stringWithFormat:iTunesSearchApi,@"song",@"song"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        iTunesDict = [self urlToDictionaryOnBackground:[NSURL URLWithString:url]];
        resultArr=[iTunesDict valueForKey:@"results"];
        for(NSDictionary *dict in resultArr)
        {
            [imgURLArr addObject:[dict valueForKey:@"artworkUrl100"]];
            [previewURLArr addObject:[dict valueForKey:@"previewUrl"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [ApplicationDelegate hide_LoadingIndicator];
            [tbl_itunes reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (NSMutableDictionary*) getDictionaryFromJson:(NSData*)jsonData
{
    NSError *error;
    NSMutableDictionary * jsonDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    return jsonDict;
}

- (NSMutableDictionary*)urlToDictionaryOnBackground:(NSURL*)url
{
    NSError             * error;
    NSString            * string        = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&error];
    NSData              * jsonData      = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * dictionary    = [[NSMutableDictionary alloc]init];
    if (jsonData == nil)
        [self failedToLoad];
    else {
        dictionary = [self getDictionaryFromJson:jsonData];
        if (dictionary == nil){
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
    if([resultArr count]==0){
    return 0;
    }

    else{
        return [resultArr count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([category isEqualToString:@"song"])
        return 50;
    else
        return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = nil;
    if([category isEqualToString:@"song"])
        CellIdentifier = @"CellNew";
    else
        CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIImageView * imageVw  = (UIImageView*)[cell.contentView viewWithTag:101];
    UILabel     * label    = (UILabel*)[cell.contentView viewWithTag:102];
    
    if([category isEqualToString:@"song"]){
        
        label.text=[[resultArr objectAtIndex:indexPath.row]valueForKey:@"trackName"];
        [imageVw sd_setImageWithURL:[NSURL URLWithString:[imgURLArr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
        
        UILabel     * label1   = (UILabel*)[cell.contentView viewWithTag:103];
        label1.text            = [[resultArr objectAtIndex:indexPath.row]valueForKey:@"artistName"];
    }
    
    else if ([category isEqualToString:@"artist"]){
        
        label.text = [[resultArr objectAtIndex:indexPath.row]valueForKey:@"artistName"];
        [imageVw sd_setImageWithURL:[NSURL URLWithString:[imgURLArr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
    }
    else{
        
        label.text = [[resultArr objectAtIndex:indexPath.row]valueForKey:@"primaryGenreName"];
        [imageVw sd_setImageWithURL:[NSURL URLWithString:[imgURLArr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([category isEqualToString:@"song"]){
        
        [self.view endEditing:YES];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        CustomAlertView * alertView     = [[CustomAlertView alloc]init];
        alertView.tag                   = 666;
        [alertView.albumImageView sd_setImageWithURL:[NSURL URLWithString:[imgURLArr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
        alertView.artistLabel.text      = [[resultArr objectAtIndex:indexPath.row]valueForKey:@"trackName"];
        alertView.songName.text         = [[resultArr objectAtIndex:indexPath.row]valueForKey:@"artistName"];
        alertView.trackUrlString        = [[resultArr objectAtIndex:indexPath.row]valueForKey:@"trackViewUrl"];
        alertView.infoButton.tag        = [indexPath row];
        [alertView.infoButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [ApplicationDelegate.window addSubview:alertView];
    }
    else {//if ([category isEqualToString:@"artist"])
       
        DetailsViewController * detailsViewController = VCWithIdentifier(@"DetailsViewController");
        NSString * trackName      = [[resultArr objectAtIndex:[indexPath row]]valueForKey:@"trackName"];
        NSString * artistName     = [[resultArr objectAtIndex:[indexPath row]]valueForKey:@"artistName"];
        NSString * artistID       = [[[resultArr objectAtIndex:[indexPath row]]valueForKey:@"artistId"] stringValue];
        NSString * artworkUrl     = [[resultArr objectAtIndex:[indexPath row]]valueForKey:@"artworkUrl100"];
        NSString * trackViewkUrl  = [[resultArr objectAtIndex:[indexPath row]]valueForKey:@"trackViewUrl"];
        
        detailsViewController.trackName         = trackName;
        detailsViewController.artistName        = artistName;
        detailsViewController.artistID          = artistID;
        detailsViewController.artworkUrl        = artworkUrl;
        detailsViewController.trackViewkUrl     = trackViewkUrl;
        
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
}

-(void)musicButtonAction:(id)sender{
    
    NSString  * iTunesLink      = [[resultArr objectAtIndex:[sender tag]]valueForKey:@"trackViewUrl"];
     NSString * iTunesLinkFinal = [iTunesLink stringByReplacingOccurrencesOfString:@"https" withString:@"itms"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLinkFinal]];
}

-(void)infoButtonAction:(id)sender{
   
    CustomAlertView * alertView =  (CustomAlertView*)[ApplicationDelegate.window viewWithTag:666];
    [alertView removeView];
    
    DetailsViewController * detailsViewController = VCWithIdentifier(@"DetailsViewController");
    
    
    NSString * trackName      = [[resultArr objectAtIndex:[sender tag]]valueForKey:@"trackName"];
    NSString * artistName     = [[resultArr objectAtIndex:[sender tag]]valueForKey:@"artistName"];
    NSString * artistID       = [[[resultArr objectAtIndex:[sender tag]]valueForKey:@"artistId"] stringValue];
    NSString * artworkUrl     = [[resultArr objectAtIndex:[sender tag]]valueForKey:@"artworkUrl100"];
    NSString * trackViewkUrl  = [[resultArr objectAtIndex:[sender tag]]valueForKey:@"trackViewUrl"];
    
    detailsViewController.trackName         = trackName;
    detailsViewController.artistName        = artistName;
    detailsViewController.artistID          = artistID;
    detailsViewController.artworkUrl        = artworkUrl;
    detailsViewController.trackViewkUrl     = trackViewkUrl;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==200){
        if(buttonIndex == alertView.firstOtherButtonIndex){
            [_player pause];
        }
    }
}

#pragma mark
#pragma mark UIButton Methods
#pragma mark

- (IBAction)categoriesBtnPressed:(UIButton*)sender
{
    [ApplicationDelegate show_LoadingIndicator];
    
    NSString * url = nil;
    if(sender.tag==101)
    {
        
        UIButton * buttonTopSongs  = (UIButton*)[self.view viewWithTag:101];
        [buttonTopSongs setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIButton * buttonTopArtist = (UIButton*)[self.view viewWithTag:102];
        [buttonTopArtist setTitleColor:[UIColor colorWithRed:3/255.0 green:103/255.0 blue:198/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        UIButton * buttonGenere    = (UIButton*)[self.view viewWithTag:103];
        [buttonGenere setTitleColor:[UIColor colorWithRed:3/255.0 green:103/255.0 blue:198/255.0 alpha:1.0] forState:UIControlStateNormal];

        
        category=@"song";
        url=[NSString stringWithFormat:iTunesSearchApi,@"song",@"song"];
    }
    else if (sender.tag==102)
    {
        
        UIButton * buttonTopSongs  = (UIButton*)[self.view viewWithTag:101];
        [buttonTopSongs setTitleColor:[UIColor colorWithRed:3/255.0 green:103/255.0 blue:198/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        UIButton * buttonTopArtist = (UIButton*)[self.view viewWithTag:102];
        [buttonTopArtist setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIButton * buttonGenere    = (UIButton*)[self.view viewWithTag:103];
        [buttonGenere setTitleColor:[UIColor colorWithRed:3/255.0 green:103/255.0 blue:198/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        category=@"artist";
         url=[NSString stringWithFormat:iTunesSearchApi,@"artist",@"song"];
    }
    else if (sender.tag==103)
    {
        UIButton * buttonTopSongs  = (UIButton*)[self.view viewWithTag:101];
        [buttonTopSongs setTitleColor:[UIColor colorWithRed:3/255.0 green:103/255.0 blue:198/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        UIButton * buttonTopArtist = (UIButton*)[self.view viewWithTag:102];
        [buttonTopArtist setTitleColor:[UIColor colorWithRed:3/255.0 green:103/255.0 blue:198/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        UIButton * buttonGenere    = (UIButton*)[self.view viewWithTag:103];
        [buttonGenere setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        category=@"genre";
         url=[NSString stringWithFormat:iTunesSearchApi,@"genre",@"song"];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        iTunesDict = [self urlToDictionaryOnBackground:[NSURL URLWithString:url]];
        resultArr=[iTunesDict valueForKey:@"results"];
        for(NSDictionary *dict in resultArr)
        {
            [imgURLArr addObject:[dict valueForKey:@"artworkUrl100"]];
            [previewURLArr addObject:[dict valueForKey:@"previewUrl"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [ApplicationDelegate hide_LoadingIndicator];
           [tbl_itunes reloadData];
        });
    });
    

    
    
}


@end
