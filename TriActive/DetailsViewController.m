//
//  DetailsViewController.m
//  MyActive
//
//  Created by Raman Kant on 3/16/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "DetailsViewController.h"
#import "MATableViewCellSong.h"
#import "MATableViewCellMoreSongs.h"
#import "AFHTTPRequestOperationManager.h"


#import "MAReadMoreVC.h"
#import "MAHashVC.h"
#import "MAUsersVC.h"
#import "MAPostCommentsVC.h"
#import "MAImgDashCell.h"
#import "MAVideoPlay.h"
#import "MAStravaMapDetailVC.h"
#import "CustomAlertView.h"

@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate>{
   
    IBOutlet UITableView    * tableViewDetails;
    NSMutableArray          * arrayMoreByArtist;
    NSMutableArray          * feedsData;
}

@end

@implementation DetailsViewController
@synthesize trackName,
            artistName,
            artistID,
            artworkUrl,
            trackViewkUrl;

@synthesize postId,
            postMessage,
            imageData;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imgActivity             = [[NSArray alloc]init];
    NSString        * path  = [[NSBundle mainBundle] pathForResource:@"activityIcons" ofType:@"plist"];
    NSDictionary    * dict  =  [NSDictionary dictionaryWithContentsOfFile:path];
    imgActivity             = [dict objectForKey:@"ActivityImages"];
    
    [tableViewDetails setHidden:YES];
    [self getMoreSongsByArtist];
}

-(void)getMoreSongsByArtist{
    
    [ApplicationDelegate show_LoadingIndicator];
    
    AFHTTPRequestOperationManager   * manager   = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer                   = [AFJSONRequestSerializer serializer];
    
    NSString * url = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&limit=12&entity=song",artistID];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray * responseArray = [[responseObject valueForKey:@"results"] mutableCopy];
        if([responseArray count])
            [responseArray removeObjectAtIndex:0];
        arrayMoreByArtist = [[NSMutableArray alloc]initWithArray:responseArray];
        [self loadFeedsOfSong];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@",[error description]);
        [ApplicationDelegate hide_LoadingIndicator];
    }];
}


-(void)loadFeedsOfSong{
    
    NSDictionary* userInfo = @{@"music_name":[NSString stringWithFormat:@"%@",trackName],
                               @"page_number":[NSString stringWithFormat:@"%i",1],
                               @"no_of_post":@"10"};
    
    AFHTTPRequestOperationManager   * manager   = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer                   = [AFJSONRequestSerializer serializer];
    NSString                        * url       =  @"http://208.109.176.111/get_post_by_music/";
    
    [manager POST:url parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tableViewDetails setHidden:NO];
        NSMutableArray * responseArray = [[responseObject valueForKey:@"data"] mutableCopy];
        feedsData = [[NSMutableArray alloc]initWithArray:responseArray];
        [tableViewDetails reloadData];
        [ApplicationDelegate hide_LoadingIndicator];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@",[error description]);
        [tableViewDetails setHidden:NO];
        [tableViewDetails reloadData];
        [ApplicationDelegate hide_LoadingIndicator];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegates & Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayMoreByArtist count]+[feedsData count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row] == 0)
        return 134.0f;
    else if([indexPath row] <= [arrayMoreByArtist count])
        return 44.0f;
    else{
        
         NSInteger correctIndex = [arrayMoreByArtist count]+1;
        if (([[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"type"] isEqualToString:@"image"] || [[[feedsData  objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"type"] isEqualToString:@"video"] || (![[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_image"] isEqualToString:@""])) && [[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"post_type"] isEqualToString:@"post"]) {
            return 514.0;
        }
        else if ([[[feedsData  objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"type"] isEqualToString:@"image"] && [[[feedsData  objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"post_type"] isEqualToString:@"dashboard"]){
            return 367.0;
        }
        else
        {
            return 193.0;
        }

    }
}

-(void)buyButtonMethod:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    NSLog(@"Row Number = %ld",(long)[indexPath row]);
    
    NSString * iTunesLink = nil;
    if([indexPath row] == 0){
        iTunesLink = trackViewkUrl;
    }else{
        iTunesLink = [[arrayMoreByArtist objectAtIndex:[indexPath row]-1]valueForKey:@"trackViewUrl"];
    }
    NSString * iTunesLinkFinal = [iTunesLink stringByReplacingOccurrencesOfString:@"https" withString:@"itms"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLinkFinal]];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    if([indexPath row] == 0){
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        CustomAlertView * alertView     = [[CustomAlertView alloc]init];
        alertView.tag                   = 666;
        [alertView.albumImageView sd_setImageWithURL:[NSURL URLWithString:artworkUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
        alertView.artistLabel.text      = trackName;
        alertView.songName.text         = artistName;
        alertView.trackUrlString        = trackViewkUrl;
        [ApplicationDelegate.window addSubview:alertView];

    }
    else{
        
        if([indexPath row] <= [arrayMoreByArtist count]){
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            CustomAlertView * alertView     = [[CustomAlertView alloc]init];
            alertView.tag                   = 666;
            [alertView.albumImageView sd_setImageWithURL:[NSURL URLWithString:[[arrayMoreByArtist objectAtIndex:indexPath.row-1] valueForKey:@"artworkUrl100"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
            alertView.artistLabel.text      = [[arrayMoreByArtist objectAtIndex:indexPath.row-1]valueForKey:@"trackName"];
            alertView.songName.text         = [[arrayMoreByArtist objectAtIndex:indexPath.row-1]valueForKey:@"artistName"];
            alertView.trackUrlString        = [[arrayMoreByArtist objectAtIndex:indexPath.row-1]valueForKey:@"trackViewUrl"];
            [ApplicationDelegate.window addSubview:alertView];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row] == 0){
        static NSString *identifier = @"MATableViewCellSong";
        MATableViewCellSong * cell = (MATableViewCellSong*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell ==nil){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MATableViewCellSong" owner:self options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.artworkImageView sd_setImageWithURL:[NSURL URLWithString:artworkUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
            cell.trackLabel.text  = trackName;
            cell.artistLabel.text = artistName;
            [cell.buyButton addTarget:self action:@selector(buyButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    else{
        
        if([indexPath row] <= [arrayMoreByArtist count]){
            static NSString *identifier = @"MATableViewCellSong";
            MATableViewCellMoreSongs * cell = (MATableViewCellMoreSongs*)[tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell ==nil){
                cell =  [[[NSBundle mainBundle]loadNibNamed:@"MATableViewCellMoreSongs" owner:self options:nil]objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.artworkImageView sd_setImageWithURL:[NSURL URLWithString:[[arrayMoreByArtist objectAtIndex:[indexPath row]-1]valueForKey:@"artworkUrl100"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
                cell.trackLabel.text = [[arrayMoreByArtist objectAtIndex:[indexPath row]-1]valueForKey:@"trackName"];
                cell.artistLabel.text = [[arrayMoreByArtist objectAtIndex:[indexPath row]-1]valueForKey:@"artistName"];
                [cell.buyButton addTarget:self action:@selector(buyButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }
        else{
            
            NSInteger correctIndex = [arrayMoreByArtist count]+1;
            
            if ([[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"type"] isEqualToString:@"image"] && [[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"post_type"] isEqualToString:@"dashboard"])
            {
                static NSString *identifier = @"imgDashCell";
                UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
                UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list,*btn_readMore;
                cellImageDash = (MAImgDashCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
                UIImageView *imgVw_Uploaded;
                UIImageView *imgVw_Post;
                
                for(STTweetLabel *tweetLabel1 in [cellImageDash subviews]){
                    if(tweetLabel1.tag == 99999)
                        [tweetLabel1 removeFromSuperview];
                }
                
                if(cellImageDash == nil){
                   [[NSBundle mainBundle]loadNibNamed:@"MAImgDashCell" owner:self options:nil];
                    cellImageDash.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                STTweetLabel *tweetLabel1   = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 230.0, 299.0, 50.0)];
                tweetLabel1.tag             =99999;
                tweetLabel1.font            = [UIFont fontWithName:@"HelveticaNeue" size:14];
                [tweetLabel1 setText:[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"share_text"]];
                tweetLabel1.textAlignment = NSTextAlignmentLeft;
                CGSize maxSize      = CGSizeMake(tweetLabel1.bounds.size.width, CGFLOAT_MAX);
                CGSize labelSize    = [tweetLabel1.text sizeWithFont:tweetLabel1.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat labelHeight = labelSize.height;
                int lines           = labelHeight/14;
                btn_readMore        = (UIButton *)[cellImageDash.contentView viewWithTag:9996];
                if(lines > 3){
                    [btn_readMore setHidden:NO];
                    [btn_readMore addTarget:self action:@selector(btnPressed_readMore:) forControlEvents:UIControlEventTouchUpInside];
                }
                [cellImageDash addSubview:tweetLabel1];
                [tweetLabel1 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                    MAHashVC * new  = VCWithIdentifier(@"MAHashVC");
                    new.hashTitle   =[NSString stringWithFormat:@"%@", string];
                    [self.navigationController pushViewController:new animated:YES];
                }];
                imgVw_Uploaded                      =(UIImageView *)[cellImageDash.contentView viewWithTag:205];
                [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                imgVw_Uploaded.layer.borderWidth    = 1.0;
                imgVw_Uploaded.layer.cornerRadius   =  20;//half of the width and height
                imgVw_Uploaded.layer.masksToBounds  = YES;
                [imgVw_Uploaded.layer setBorderWidth: 3.0];
                if(imgVw_Uploaded){
                    [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[feedsData  objectAtIndex:indexPath.row - correctIndex]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                imgVw_Post=(UIImageView *)[cellImageDash.contentView viewWithTag:211];
                if(imgVw_Post){
                    [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[feedsData  objectAtIndex:indexPath.row  - correctIndex]valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                lbl_Caption = (UILabel *)[cellImageDash.contentView viewWithTag:207];
                if(lbl_Caption){}
                lbl_like = (UILabel *)[cellImageDash.contentView viewWithTag:201];
                if(lbl_like){
                    lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"]];
                }
                btnLike = (UIButton *)[cellImageDash.contentView viewWithTag:101];
                if(btnLike) {
                    [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_like_user = (UIButton *)[cellImageDash.contentView viewWithTag:110];
                if (btn_like_user) {
                    [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_backSlap = (UILabel *)[cellImageDash.contentView viewWithTag:202];
                if(lbl_backSlap){
                    lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Back Slap"]];
                }
                btnBackSlap = (UIButton *)[cellImageDash.contentView viewWithTag:102];
                if (btnBackSlap) {
                    [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnBackSlap_list = (UIButton *)[cellImageDash.contentView viewWithTag:220];
                if (btnBackSlap_list) {
                    [btnBackSlap_list addTarget:self action:@selector(btnPressed_backSlap_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_bumSlap = (UILabel *)[cellImageDash.contentView viewWithTag:203];
                if(lbl_bumSlap){
                    lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[feedsData  objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"Bump Slap"]];
                }
                btnBumSlap = (UIButton *)[cellImageDash.contentView viewWithTag:103];
                if (btnBumSlap) {
                    [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnBumSlap_list = (UIButton *)[cellImageDash.contentView viewWithTag:330];
                if (btnBumSlap_list) {
                    [btnBumSlap_list addTarget:self action:@selector(btnPressed_bumSlap_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                lbl_Comments = (UILabel *)[cellImageDash.contentView viewWithTag:204];
                if(lbl_Comments){
                    lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[feedsData objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"comments"]];
                }
                btnComments = (UIButton *)[cellImageDash.contentView viewWithTag:104];
                if (btnComments) {
                    [btnComments addTarget:self action:@selector(btnPressed_Comments:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnMore = (UIButton *)[cellImageDash.contentView viewWithTag:105];
                if (btnMore) {
                    [btnMore addTarget:self action:@selector(btnPressed_More:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_name = (UIButton *)[cellImageDash.contentView viewWithTag:108];
                [btn_name addTarget:self action:@selector(openUserProfile:event:) forControlEvents:UIControlEventTouchUpInside];
                
                lbl_name = (UILabel *)[cellImageDash.contentView viewWithTag:208];
                if(lbl_name){
                    lbl_name.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"user_first_name"];
                }
                lbl_time = (UILabel *)[cellImageDash.contentView viewWithTag:209];
                if(lbl_time){
                    lbl_time.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"date"];
                }
                
                return cellImageDash;
            }
            else if (([[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"type"] isEqualToString:@"image"] && [[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"post_type"] isEqualToString:@"post"]) || ((![[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_image"] isEqualToString:@""]) && [[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"type"] isEqualToString:@"text"])){
                
                static NSString *identifier = @"imageCell";
                
                UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time,*lbl_dist,*lbl_dist_val,*lbl_duratn,*lbl_duratn_val,*lbl_calorie,*lbl_calorie_val;
                UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list,*btn_strava,*btn_readMore;
                cellImage = (MAImageCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
                UIImageView *imgVw_Uploaded;
                UIImageView *imgVw_Activity;
                UIImageView *imgVw_Post;
                for(STTweetLabel *tweetLabel3 in [cellImage subviews])
                {
                    if(tweetLabel3.tag == 88888)
                    {
                        [tweetLabel3 removeFromSuperview];
                    }
                    
                }
                if(cellImage == nil)
                {
                    NSArray *topLevelObjects =  [[NSBundle mainBundle]loadNibNamed:@"MAImageCell" owner:self options:nil];
                    cellImage = [topLevelObjects objectAtIndex:0];
                    
                    
                    
                }
                STTweetLabel *tweetLabel3 = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 380.0, 299.0, 50.0)];
                tweetLabel3.tag=88888;
                tweetLabel3.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
                [tweetLabel3 setText:[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"message"]];
                tweetLabel3.textAlignment = NSTextAlignmentLeft;
                CGSize maxSize = CGSizeMake(tweetLabel3.bounds.size.width, CGFLOAT_MAX);
                
                CGSize labelSize = [tweetLabel3.text sizeWithFont:tweetLabel3.font
                                                constrainedToSize:maxSize
                                                    lineBreakMode:NSLineBreakByWordWrapping];
                
                
                
                CGFloat labelHeight = labelSize.height;
                int lines = labelHeight/14;
                btn_readMore = (UIButton *)[cellImage.contentView viewWithTag:9996];
                if(lines > 3){
                    [btn_readMore setHidden:NO];
                    [btn_readMore addTarget:self action:@selector(btnPressed_readMore:) forControlEvents:UIControlEventTouchUpInside];
                }
                NSLog(@"height :%f",labelSize.height);
                NSLog(@"lines count : %i \n\n",lines);
                
                [cellImage addSubview:tweetLabel3];
                [tweetLabel3 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                    
                    MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                    new.hashTitle=[NSString stringWithFormat:@"%@", string];
                    [self.navigationController pushViewController:new animated:YES];
                }];
                imgVw_Uploaded=(UIImageView *)[cellImage.contentView viewWithTag:205];
                [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                imgVw_Uploaded.layer.borderWidth = 1.0;
                imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
                imgVw_Uploaded.layer.masksToBounds = YES;
                [imgVw_Uploaded.layer setBorderWidth: 3.0];
                if(imgVw_Uploaded){
                    [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[feedsData  objectAtIndex:indexPath.row - correctIndex]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                imgVw_Activity=(UIImageView *)[cellImage.contentView viewWithTag:210];
                
                if(imgVw_Activity){
                    if ([[imgActivity valueForKey:@"txt"] containsObject: [[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"activity_name"]]) {
                        
                        NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"activity_name"]];
                        if (index != NSNotFound) {
                            imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:index ] valueForKey:@"img"]];
                        }
                        
                    }
                }
                imgVw_Post=(UIImageView *)[cellImage.contentView viewWithTag:211];
                if(imgVw_Post){
                    if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_image"] isEqualToString:@""]){
                        [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[feedsData  objectAtIndex:indexPath.row - correctIndex]valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                    }
                    else{[imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[feedsData  objectAtIndex:indexPath.row - correctIndex]valueForKey:@"strava_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];}
                }
                
                lbl_like = (UILabel *)[cellImage.contentView viewWithTag:201];
                if(lbl_like){
                    cellImage.lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"]];
                }
                btnLike = (UIButton *)[cellImage.contentView viewWithTag:101];
                if (btnLike) {
                    [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_Caption = (UILabel *)[cellImage.contentView viewWithTag:207];
                if(lbl_Caption){
                    
                }
                lbl_dist = (UILabel *)[cellImage.contentView viewWithTag:1001];
                lbl_dist_val = (UILabel *)[cellImage.contentView viewWithTag:1002];
                
                btn_strava = (UIButton *)[cellImage.contentView viewWithTag:656];
                if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_image"] isEqualToString:@""]){
                    [btn_strava setHidden:YES];
                    [lbl_dist_val setHidden:YES];
                    [lbl_dist setHidden:YES];
                    [lbl_duratn setHidden:YES];
                    [lbl_duratn_val setHidden:YES];
                    [lbl_calorie setHidden:YES];
                    [lbl_calorie_val setHidden:YES];
                }
                else
                {
                    [btn_strava setHidden:NO];
                    if (btn_strava) {
                        [btn_strava addTarget:self action:@selector(btnPressed_strava:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_distance"]isEqualToString:@""]){
                        [lbl_dist_val setHidden:YES];
                        [lbl_dist setHidden:YES];
                        
                    }
                    else{
                        [lbl_dist setHidden:NO];
                        if(lbl_dist_val){
                            [lbl_dist_val setHidden:NO];
                            lbl_dist_val.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_distance"];
                        }
                    }
                    
                    lbl_duratn = (UILabel *)[cellImage.contentView viewWithTag:1003];
                    lbl_duratn_val= (UILabel *)[cellImage.contentView viewWithTag:1004];
                    if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_duration"] isEqualToString:@""]){
                        [lbl_duratn setHidden:YES];
                        [lbl_duratn_val setHidden:YES];
                        
                    }
                    else{
                        
                        [lbl_duratn setHidden:NO];
                        if(lbl_duratn_val){
                            [lbl_duratn_val setHidden:NO];
                            lbl_duratn_val.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_duration"];
                        }
                    }
                    lbl_calorie = (UILabel *)[cellImage.contentView viewWithTag:1005];
                    lbl_calorie_val = (UILabel *)[cellImage.contentView viewWithTag:1006];
                    if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_calories"] isEqualToString:@""]){
                        [lbl_calorie setHidden:YES];
                        [lbl_calorie_val setHidden:YES];
                    }
                    else{
                        
                        [lbl_calorie setHidden:NO];
                        [lbl_calorie_val setHidden:NO];
                        lbl_calorie_val.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_calories"];
                        
                    }
                }
                btn_like_user = (UIButton *)[cellImage.contentView viewWithTag:110];
                if (btn_like_user) {
                    [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_backSlap = (UILabel *)[cellImage.contentView viewWithTag:202];
                if(lbl_backSlap){
                    lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Back Slap"]];
                }
                btnBackSlap = (UIButton *)[cellImage.contentView viewWithTag:102];
                if (btnBackSlap) {
                    [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnBackSlap_list = (UIButton *)[cellImage.contentView viewWithTag:220];
                if (btnBackSlap_list) {
                    [btnBackSlap_list addTarget:self action:@selector(btnPressed_backSlap_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_bumSlap = (UILabel *)[cellImage.contentView viewWithTag:203];
                if(lbl_bumSlap){
                    lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Bump Slap"]];
                }
                btnBumSlap = (UIButton *)[cellImage.contentView viewWithTag:103];
                if (btnBumSlap) {
                    [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnBumSlap_list = (UIButton *)[cellImage.contentView viewWithTag:330];
                if (btnBumSlap_list) {
                    [btnBumSlap_list addTarget:self action:@selector(btnPressed_bumSlap_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_Comments = (UILabel *)[cellImage.contentView viewWithTag:204];
                if(lbl_Comments){
                    lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"comments"]];
                }
                btnComments = (UIButton *)[cellImage.contentView viewWithTag:104];
                if (btnComments) {
                    [btnComments addTarget:self action:@selector(btnPressed_Comments:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnMore = (UIButton *)[cellImage.contentView viewWithTag:105];
                if (btnMore) {
                    [btnMore addTarget:self action:@selector(btnPressed_More:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_name = (UIButton *)[cellImage.contentView viewWithTag:108];
                [btn_name addTarget:self action:@selector(openUserProfile:event:) forControlEvents:UIControlEventTouchUpInside];
                
                lbl_name = (UILabel *)[cellImage.contentView viewWithTag:208];
                if(lbl_name){
                    lbl_name.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"user_first_name"];
                }
                lbl_time = (UILabel *)[cellImage.contentView viewWithTag:209];
                if(lbl_time){
                    lbl_time.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"date"];
                }
                
                return cellImage;
            }
            else if ([[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"type"] isEqualToString:@"video"] && [[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"post_type"] isEqualToString:@"post"])
            {
                static NSString *identifier = @"MAVideoCell";
                UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btnPlay, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list,*btn_readMore;
                UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
                UIImageView *imgVw_Uploaded;
                UIImageView *imgVw_Activity,*imgVwThumb;
                cellVideo = (MAVideoCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
                for(STTweetLabel *tweetLabel4 in [cellVideo subviews])
                {
                    if(tweetLabel4.tag == 77777)
                    {
                        [tweetLabel4 removeFromSuperview];
                    }
                    
                }
                if(cellVideo ==nil)
                {
                    [[NSBundle mainBundle]loadNibNamed:@"MAVideoCell" owner:self options:nil];
                    {
                        
                    }
                }
                
                STTweetLabel *tweetLabel4 = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 360.0, 299.0, 50.0)];
                tweetLabel4.tag = 77777;
                tweetLabel4.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
                [tweetLabel4 setText:[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"message"]];
                tweetLabel4.textAlignment = NSTextAlignmentLeft;
                CGSize maxSize = CGSizeMake(tweetLabel4.bounds.size.width, CGFLOAT_MAX);
                
                CGSize labelSize = [tweetLabel4.text sizeWithFont:tweetLabel4.font
                                                constrainedToSize:maxSize
                                                    lineBreakMode:NSLineBreakByWordWrapping];
                
                
                
                CGFloat labelHeight = labelSize.height;
                int lines = labelHeight/14;
                btn_readMore = (UIButton *)[cellVideo.contentView viewWithTag:9996];
                if(lines > 3){
                    [btn_readMore setHidden:NO];
                    [btn_readMore addTarget:self action:@selector(btnPressed_readMore:) forControlEvents:UIControlEventTouchUpInside];
                }
                NSLog(@"height :%f",labelSize.height);
                NSLog(@"lines count : %i \n\n",lines);
                
                [cellVideo addSubview:tweetLabel4];
                [tweetLabel4 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                    MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                    new.hashTitle=[NSString stringWithFormat:@"%@", string];
                    [self.navigationController pushViewController:new animated:YES];
                }];
                imgVwThumb=(UIImageView *)[cellVideo.contentView viewWithTag:1502];
                if(imgVwThumb){
                    [imgVwThumb sd_setImageWithURL:[NSURL URLWithString:[[feedsData  objectAtIndex:indexPath.row - correctIndex]valueForKey:@"thumbnails"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                imgVw_Activity=(UIImageView *)[cellVideo.contentView viewWithTag:210];
                if(imgVw_Activity){
                    if ([[imgActivity valueForKey:@"txt"] containsObject: [[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"activity_name"]]) {
                        imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:indexPath.row - correctIndex] valueForKey:@"img"]];
                    }
                }
                imgVw_Uploaded=(UIImageView *)[cellVideo.contentView viewWithTag:205];
                [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                imgVw_Uploaded.layer.borderWidth = 1.0;
                imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
                imgVw_Uploaded.layer.masksToBounds = YES;
                [imgVw_Uploaded.layer setBorderWidth: 3.0];
                if(imgVw_Uploaded){
                    [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[feedsData  objectAtIndex:indexPath.row - correctIndex]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                lbl_Caption = (UILabel *)[cellVideo.contentView viewWithTag:207];
                if(lbl_Caption){}
                lbl_like = (UILabel *)[cellVideo.contentView viewWithTag:201];
                if(lbl_like){
                    lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"]];
                }
                btnLike = (UIButton *)[cellVideo.contentView viewWithTag:101];
                if (btnLike) {
                    [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_like_user = (UIButton *)[cellVideo.contentView viewWithTag:110];
                if (btn_like_user) {
                    [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_backSlap = (UILabel *)[cellVideo.contentView viewWithTag:202];
                if(lbl_backSlap){
                    lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Back Slap"]];
                }
                btnBackSlap = (UIButton *)[cellVideo.contentView viewWithTag:102];
                if (btnBackSlap) {
                    [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnBackSlap_list = (UIButton *)[cellVideo.contentView viewWithTag:220];
                if (btnBackSlap_list) {
                    [btnBackSlap_list addTarget:self action:@selector(btnPressed_backSlap_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_bumSlap = (UILabel *)[cellVideo.contentView viewWithTag:203];
                if(lbl_bumSlap){
                    lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Bump Slap"]];
                }
                btnBumSlap = (UIButton *)[cellVideo.contentView viewWithTag:103];
                if (btnBumSlap) {
                    [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnBumSlap_list = (UIButton *)[cellVideo.contentView viewWithTag:330];
                if (btnBumSlap_list) {
                    [btnBumSlap_list addTarget:self action:@selector(btnPressed_bumSlap_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_Comments = (UILabel *)[cellVideo.contentView viewWithTag:204];
                if(lbl_Comments){
                    lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"comments"]];
                }
                btnComments = (UIButton *)[cellVideo.contentView viewWithTag:104];
                if (btnComments) {
                    [btnComments addTarget:self action:@selector(btnPressed_Comments:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnMore = (UIButton *)[cellVideo.contentView viewWithTag:105];
                if (btnMore) {
                    [btnMore addTarget:self action:@selector(btnPressed_More:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnPlay = (UIButton *)[cellVideo.contentView viewWithTag:106];
                if (btnPlay) {
                    [btnPlay addTarget:self action:@selector(btnPressed_Play:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_name = (UIButton *)[cellVideo.contentView viewWithTag:108];
                [btn_name addTarget:self action:@selector(openUserProfile:event:) forControlEvents:UIControlEventTouchUpInside];
                lbl_name = (UILabel *)[cellVideo.contentView viewWithTag:208];
                if(lbl_name){
                    lbl_name.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"user_first_name"];
                }
                lbl_time = (UILabel *)[cellVideo.contentView viewWithTag:209];
                if(lbl_time){
                    lbl_time.text=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"date"];
                }
                return cellVideo;
            }
            else
            {
                static NSString *identifier = @"MAStatusCell";
                UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list,*btn_readMore;
                
                UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
                UIImageView *imgVw_Uploaded;
                UIImageView *imgVw_Activity;
                cellStatus = (MAStatusCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
                for(STTweetLabel *tweetLabel5 in [cellStatus subviews])
                {
                    if(tweetLabel5.tag == 66666)
                    {
                        [tweetLabel5 removeFromSuperview];
                    }
                    
                }
                
                if(cellStatus ==nil)
                {
                    [[NSBundle mainBundle]loadNibNamed:@"MAStatusCell" owner:self options:nil];
                    
                    
                }
                STTweetLabel *tweetLabel5 = [[STTweetLabel alloc] initWithFrame:CGRectMake(10.0, 56.0, 299.0, 50.0)];
                tweetLabel5.tag = 66666;
                tweetLabel5.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
                [tweetLabel5 setText:[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"message"]];
                tweetLabel5.textAlignment = NSTextAlignmentLeft;
                CGSize maxSize = CGSizeMake(tweetLabel5.bounds.size.width, CGFLOAT_MAX);
                
                CGSize labelSize = [tweetLabel5.text sizeWithFont:tweetLabel5.font
                                                constrainedToSize:maxSize
                                                    lineBreakMode:NSLineBreakByWordWrapping];
                
                
                
                CGFloat labelHeight = labelSize.height;
                int lines = labelHeight/14;
                btn_readMore = (UIButton *)[cellStatus.contentView viewWithTag:9996];
                if(lines > 3){
                    [btn_readMore setHidden:NO];
                    [btn_readMore addTarget:self action:@selector(btnPressed_readMore:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                [cellStatus addSubview:tweetLabel5];
                [tweetLabel5 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                    MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                    new.hashTitle=[NSString stringWithFormat:@"%@", string];
                    [self.navigationController pushViewController:new animated:YES];
                    
                }];
                imgVw_Activity=(UIImageView *)[cellStatus.contentView viewWithTag:210];
                if(imgVw_Activity){
                    if ([[imgActivity valueForKey:@"txt"] containsObject: [[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"activity_name"]]) {
                        NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"activity_name"]];
                        if (index != NSNotFound) {
                            imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:index ] valueForKey:@"img"]];
                        }
                        
                    }
                }
                imgVw_Uploaded=(UIImageView *)[cellStatus.contentView viewWithTag:205];
                [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                imgVw_Uploaded.layer.borderWidth = 1.0;
                imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
                imgVw_Uploaded.layer.masksToBounds = YES;
                [imgVw_Uploaded.layer setBorderWidth: 3.0];
                if(imgVw_Uploaded){
                    [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[feedsData  objectAtIndex:indexPath.row - correctIndex]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                lbl_Caption = (UILabel *)[cellStatus.contentView viewWithTag:207];
                if(lbl_Caption){}
                lbl_like = (UILabel *)[cellStatus.contentView viewWithTag:201];
                if(lbl_like){
                    if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"] isEqualToString:@"0"]||[[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"] isEqualToString:@"1"]){
                        lbl_like.text=[NSString stringWithFormat:@"%@  Like",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"]];
                    }
                    else{
                        lbl_like.text=[NSString stringWithFormat:@"%@  Like",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"]];
                        
                    }
                }
                btnLike = (UIButton *)[cellStatus.contentView viewWithTag:101];
                if (btnLike) {
                    [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_like_user = (UIButton *)[cellStatus.contentView viewWithTag:110];
                if (btn_like_user) {
                    [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_backSlap = (UILabel *)[cellStatus.contentView viewWithTag:202];
                if(lbl_backSlap){
                    lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Back Slap"]];
                }
                btnBackSlap = (UIButton *)[cellStatus.contentView viewWithTag:102];
                if (btnBackSlap) {
                    [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnBackSlap_list = (UIButton *)[cellStatus.contentView viewWithTag:220];
                if (btnBackSlap_list) {
                    [btnBackSlap_list addTarget:self action:@selector(btnPressed_backSlap_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_bumSlap = (UILabel *)[cellStatus.contentView viewWithTag:203];
                if(lbl_bumSlap){
                    lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Bump Slap"]];
                }
                
                btnBumSlap = (UIButton *)[cellStatus.contentView viewWithTag:103];
                if (btnBumSlap) {
                    [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnBumSlap_list = (UIButton *)[cellStatus.contentView viewWithTag:330];
                if (btnBumSlap_list) {
                    [btnBumSlap_list addTarget:self action:@selector(btnPressed_bumSlap_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_Comments = (UILabel *)[cellStatus.contentView viewWithTag:204];
                if(lbl_Comments){
                    lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"comments"]];
                }
                btnComments = (UIButton *)[cellStatus.contentView viewWithTag:104];
                if (btnComments) {
                    [btnComments addTarget:self action:@selector(btnPressed_Comments:) forControlEvents:UIControlEventTouchUpInside];
                }
                btnMore = (UIButton *)[cellStatus.contentView viewWithTag:105];
                if (btnMore) {
                    [btnMore addTarget:self action:@selector(btnPressed_More:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_name = (UIButton *)[cellStatus.contentView viewWithTag:108];
                [btn_name addTarget:self action:@selector(openUserProfile:event:) forControlEvents:UIControlEventTouchUpInside];
                lbl_name = (UILabel *)[cellStatus.contentView viewWithTag:208];
                if(lbl_name){
                    lbl_name.text=[NSString stringWithFormat:@"%@ ",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"user_first_name"]];
                }
                lbl_time = (UILabel *)[cellStatus.contentView viewWithTag:209];
                if(lbl_time){
                    lbl_time.text=[NSString stringWithFormat:@"%@ ",[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"date"]];
                }
                return cellStatus;
            }

        }
    }
}

-(IBAction)openUserProfile:(id)sender event:(id)event
{
    
    NSInteger correctIndex = [arrayMoreByArtist count]+1;
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"%ld",(long)indexPath.row - correctIndex);
    
    NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
    NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[feedsData objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"user_id"]];
    
    if([tmp_str_id isEqualToString:str]){
        MAProfileVC *obj_MAprofileVC = VCWithIdentifier(@"MAProfileVC");
        obj_MAprofileVC.check_push_or_tab=@"push";
        [self.navigationController pushViewController:obj_MAprofileVC animated:YES];
    }
    else{
        OtherUserProfileVC *obj_OtherUserhome = VCWithIdentifier(@"OtherUserProfileVC");
        obj_OtherUserhome.other_user_ID =[[feedsData objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"user_id"];
        [self.navigationController pushViewController:obj_OtherUserhome animated:YES];
    }
}

-(void)btnPressed_More:(id)sender
{
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MALog(@"More-indexPath--%ld",(long)indexPath.row  - correctIndex);
    if([[[feedsData  objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"post_type"] isEqualToString:@"dashboard"]){
        postMessage=[NSString stringWithFormat:@"%@ : %@",[[feedsData objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"message"],[[feedsData objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"share_text"]];
    }
    else{
        postMessage= [[feedsData objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"message"];
    }
    imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: [[feedsData  objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"post_image"]]];
    //    MALog(@"%@",_imageData);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AppName
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Facebook Share"];
    [actionSheet addButtonWithTitle:@"Twitter Share"];
    if([[[feedsData objectAtIndex:indexPath.row  - correctIndex] valueForKey:@"user_id"] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]]]){
        postId=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"id"];
        [actionSheet addButtonWithTitle:@"Delete Post"];
        //[actionSheet addButtonWithTitle:@"Edit Post"];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
    
    
}



-(void)btnPressed_Comments:(id)sender
{
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MALog(@"Comments-indexPath--%ld",(long)indexPath.row - correctIndex);
    MAPostCommentsVC * objPComments=VCWithIdentifier(@"MAPostCommentsVC");
    objPComments.post_id=[[feedsData  objectAtIndex:indexPath.row - correctIndex] valueForKey:@"id"];
    objPComments.type=@"";
    [self.navigationController pushViewController:objPComments animated:YES];
    // [self presentViewController:objPComments animated:YES completion:nil];
}

-(void)btnPressed_bumSlap_list:(id)sender
{
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Bum Slap";
    objList.post_id=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}

-(void)btnPressed_readMore:(id)sender{
  
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint         buttonPosition  = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath     * indexPath     = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MAReadMoreVC    * readMore      = VCWithIdentifier(@"MAReadMoreVC");
    readMore.Arr_readMore=[feedsData objectAtIndex:indexPath.row - correctIndex] ;
    [self.navigationController pushViewController:readMore animated:YES];
}

-(void)btnPressed_like_list:(id)sender
{
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Like";
    objList.post_id=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}

-(void)btnPressed_backSlap_list:(id)sender
{
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Back Slap";
    objList.post_id=[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}

-(void)btnPressed_like:(id)sender
{
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MALog(@"like-indexPath--%ld",(long)indexPath.row - correctIndex);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"id"],
                               @"type":@"Like"
                               };
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tableViewDetails cellForRowAtIndexPath:indexPath];
            
            UILabel *lbl_like = (UILabel *)[cell viewWithTag:201];
            NSString *like=[NSString stringWithFormat:@"%d",[[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"] intValue] + 1];
            if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"] isEqualToString:@"0"]||[[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Like"] isEqualToString:@"1"]){
                lbl_like.text= [NSString stringWithFormat:@"%@  Like",like];
                NSLog(@"%@",lbl_like.text);
                
            }
            else{
                lbl_like.text=[NSString stringWithFormat:@"%@  Likes",like];
            }
        }
        else if([[responseDict valueForKey:@"result"] intValue] == 0)
        {
            [ApplicationDelegate showAlert:@"You have already like this post"];
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

-(void)btnPressed_backSlap:(id)sender
{
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MALog(@"backSlap-indexPath--%ld",(long)indexPath.row - correctIndex);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"id"],
                               @"type":@"Back Slap"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tableViewDetails cellForRowAtIndexPath:indexPath];
            UILabel *lbl_backSlap = (UILabel *)[cell viewWithTag:202];
            NSString *backSlap=[NSString stringWithFormat:@"%d",[[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Back Slap"] intValue] + 1];
            if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Back Slap"] isEqualToString:@"0"]||[[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Back Slap"] isEqualToString:@"1"]){
                lbl_backSlap.text= [NSString stringWithFormat:@"%@ Back Slap",backSlap];
                NSLog(@"%@",lbl_backSlap.text);
                
            }
            else{
                lbl_backSlap.text=[NSString stringWithFormat:@"%@ Back Slap",backSlap];
            }
        }
        else if([[responseDict valueForKey:@"result"] intValue] == 0)
        {
            [ApplicationDelegate showAlert:@"You have already Back slap this post"];
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

-(void)btnPressed_bumSlap:(id)sender
{
    NSInteger correctIndex = [arrayMoreByArtist count]+1;

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MALog(@"bumSlap-indexPath--%ld",(long)indexPath.row - correctIndex);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"id"],
                               @"type":@"Bump Slap"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tableViewDetails cellForRowAtIndexPath:indexPath];
            UILabel *lbl_bumSlap = (UILabel *)[cell viewWithTag:203];
            NSString *bumSlap=[NSString stringWithFormat:@"%d",[[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Bump Slap"] intValue] + 1];
            if([[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Bump Slap"] isEqualToString:@"0"]||[[[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"Bump Slap"] isEqualToString:@"1"]){
                lbl_bumSlap.text= [NSString stringWithFormat:@"%@ Bum Slap",bumSlap];
                NSLog(@"%@",lbl_bumSlap.text);
            }
            else
            {
                lbl_bumSlap.text=[NSString stringWithFormat:@"%@ Bum Slap",bumSlap];
            }
        }
        else if([[responseDict valueForKey:@"result"] intValue] == 0)
        {
            [ApplicationDelegate showAlert:@"You have already Bum Slap this post"];
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


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    switch (buttonIndex) {
        case 0:
        {
            
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *mySocialComposer= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                mySocialComposer = [SLComposeViewController
                                    composeViewControllerForServiceType:SLServiceTypeFacebook];
                [ApplicationDelegate show_LoadingIndicator];
                
                [mySocialComposer setInitialText:postMessage];
                [mySocialComposer addImage:[UIImage imageWithData:imageData]];
                [mySocialComposer setCompletionHandler:^(SLComposeViewControllerResult result)
                 
                 {
                     
                     if (result==SLComposeViewControllerResultCancelled)
                     {
                         [ApplicationDelegate showAlert:@"The request has been cancelled"];
                         
                     }
                     
                     else if (result==SLComposeViewControllerResultDone)
                     {
                         
                         [ApplicationDelegate showAlert:@"Posted successfully on facebook"];
                         
                     }
                     
                     
                 }];
                if ([ApplicationDelegate isHudShown])
                    
                {
                    [ApplicationDelegate hide_LoadingIndicator];
                }
                [self presentViewController:mySocialComposer animated:YES completion:nil];
            }
            else
            {
                
                [ApplicationDelegate showAlert:@"There are no Facebook accounts configured. You can add or create a Facebook account in the main Settings section of your phone device"];
                
            }
        }
            break;
        case 1:
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *mySocialComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [mySocialComposer setInitialText:postMessage];
                [mySocialComposer addImage:[UIImage imageWithData:imageData]];
                [mySocialComposer setCompletionHandler:^(SLComposeViewControllerResult result){
                    
                    if (result==SLComposeViewControllerResultCancelled)
                    {
                        
                        [ApplicationDelegate showAlert:@"The post have been cancelled"];
                    }
                    else if (result==SLComposeViewControllerResultDone)
                        
                    {
                        // [ApplicationDelegate showAlert:@"Posted successfully on twitter"];
                    }
                    
                }];
                if ([ApplicationDelegate isHudShown]) {
                    [ApplicationDelegate hide_LoadingIndicator];
                }
                [self presentViewController:mySocialComposer animated:YES completion:nil];
                //viewShare.frame=CGRectMake(132, -140, 150, 138);
                //isShown=false;
            }
            else
            {
                [ApplicationDelegate showAlert:@"There are no Twitter accounts configured. You can add or create a Twitter account in the main Settings section of your phone device"];
            }
            
        }
            break;
        case 2:
        {
            if([title isEqual: @"Delete Post"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Are you sure you want to delete this." delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
                [alert show];
                MALog(@" %@_postId ",postId);
            }
        }
        case 3:
        {
            if([title isEqual: @"Edit Post"]){
                if(postId){
                    MAPostVC *objPost=VCWithIdentifier(@"MAPostVC");
                    objPost.NoStrava=@"home";
                    objPost.PostID=postId;
                    [self.navigationController pushViewController:objPost animated:YES];
                    
                }
            }
        }
        default:
            break;
    }
}

-(void)btnPressed_Play:(id)sender
{
    NSInteger      correctIndex   = [arrayMoreByArtist count]+1;
    
    CGPoint        buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath  * indexPath      = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MAVideoPlay  * new = VCWithIdentifier(@"MAVideoPlay");
    new.url                       = [[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"video"];
    [self.navigationController pushViewController:new animated:YES];
}

-(void)btnPressed_strava:(id)sender{
    
    NSInteger      correctIndex   = [arrayMoreByArtist count]+1;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewDetails];
    NSIndexPath *indexPath = [tableViewDetails indexPathForRowAtPoint:buttonPosition];
    MAStravaMapDetailVC * strava = VCWithIdentifier(@"MAStravaMapDetailVC");
    strava.activityID=[NSString stringWithFormat:@"%@", [[feedsData objectAtIndex:indexPath.row - correctIndex] valueForKey:@"strava_id"]];
    [self.navigationController pushViewController:strava animated:YES];
}



/*
#pragma mark - Navigation

// Insdfasdfsafdasfasfdasfd a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
