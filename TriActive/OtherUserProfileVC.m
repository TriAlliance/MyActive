//
//  OtherUserProfileVC.m
//  MyActive
//
//  Created by Eliza Dhamija on 31/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "OtherUserProfileVC.h"
#import "MAVideoPlay.h"
#import "MAEditProfileVC.h"
#import "MAUsersVC.h"
#import "MAPostCommentsVC.h"
#import "MAHashVC.h"
#import "MAStravaMapDetailVC.h"
#import "MAReadMoreVC.h"
@interface OtherUserProfileVC ()

@end

@implementation OtherUserProfileVC
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
    
    MALog(@"%@self.other_user_ID",self.other_user_ID);
    [super viewDidLoad];
    paging=1;
    insert=NO;
    arrProfileHomeData   = [[NSMutableArray alloc]init];
    arrProfileData = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Profile"];
    
    UIButton *btnRight = [[UIButton alloc]init];
    btnRight.frame=CGRectMake(0, 0, 24, 24);
    [btnRight setImage:[UIImage imageNamed:@"icon-profile-settings.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightBtnToBlock) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=right;
    self.navigationController.navigationBar.translucent = NO;
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"activityIcons" ofType:@"plist"];
    NSDictionary *dict =  [NSDictionary dictionaryWithContentsOfFile:path];
    imgActivity = [dict objectForKey:@"ActivityImages"];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    typeof(self) weakSelf = self;
    
    // setup pull-to-refresh
    [tbl_Profile addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [tbl_Profile addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
   //  [tbl_Profile registerNib:[UINib nibWithNibName:@"MAImageCell" bundle:nil]forCellReuseIdentifier:@"imageCell"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self callProfileAPI];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)insertRowAtTop {
    insert=NO;
    paging=1;
    [self callProfileAPI ];
    
}
- (void)insertRowAtBottom {
    insert=YES;
    [self callProfileAPI];
    
}

-(void)callProfileAPI
{
    if(insert == YES){
        paging++;
    }
    else
    {
        [arrProfileData removeAllObjects];
        [arrProfileHomeData  removeAllObjects];
    }
    NSDictionary* userInfo = @{@"user_id":self.other_user_ID,
                               @"login_user_id":[UserDefaults valueForKey:@"user_id"],
                               @"page_number":[NSString stringWithFormat:@"%i",paging],
                               @"no_of_post":@"10"
                               };
    [ApplicationDelegate show_LoadingIndicator];
    [API otherProfileWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            
            [arrProfileData addObject:[responseDict valueForKey:@"data"]];
            NSMutableArray * arrPagData = [[NSMutableArray alloc]init];
            [arrPagData addObject:[[responseDict valueForKey:@"data"] valueForKey:@"post_data"]];
            
            for (int i = 0; i < [[[responseDict valueForKey:@"data"] valueForKey:@"post_data"] count];i++) {
                [arrProfileHomeData  addObject:[[arrPagData objectAtIndex:0] objectAtIndex:i]];
            }
            NSLog(@"arrProfileHomeData  count--%li",(unsigned long)[arrProfileHomeData  count]);
            [tbl_Profile reloadData];
            
        }else
        {
            [ApplicationDelegate showAlert:ErrorStr];
        }
        [tbl_Profile.pullToRefreshView stopAnimating];
        [tbl_Profile.infiniteScrollingView stopAnimating];
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
    if ([self.tabBarController.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.tabBarController.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
        
        [self.tabBarController.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil afterDelay:0.0];
        
    }
}

-(void)rightBtn
{
    MAProfileSettingVC *objSetting=VCWithIdentifier(@"MAProfileSettingVC");
    [self.navigationController pushViewController:objSetting animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Table View DataSource/Delegates
#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else
    {
        if([arrProfileHomeData  count]){
            MALog(@"%lu",(unsigned long)[arrProfileHomeData  count]);
            return [arrProfileHomeData  count];
        }
        else
        {
            return 0;
        }
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:244.0/255.0 alpha:1.0f]];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
        return 0.0f;
    else
        return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 363.0f;
    }
    else if (indexPath.section == 1)
    {
        if (([arrProfileHomeData count] > 0 && ([[[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"image"] ||[[[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"video"] || (![[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_image"] isEqualToString:@""])) && [[[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"post"])) {
            return 514.0;
        }
        else if ([arrProfileHomeData count] > 0 && [[[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"dashboard"]){
            return 367.0;
        }
        else
        {
            return 193.0;
        }
    }else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellProfile";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0 && [arrProfileData count]) {
        
        UIImageView *imgVw_Profile = (UIImageView *)[cell viewWithTag:103];
        UIImageView *imgVw_Cover = (UIImageView *)[cell viewWithTag:101];
        UILabel *lbl_name, *lbl_city, *lbl_marital, *lbl_follower,*lbl_event, *lbl_following, *lbl_groups,*lbl_desc;
        UIButton *btn_follow_unfollow = (UIButton*)[cell viewWithTag:102];
        
        [btn_follow_unfollow addTarget:self action:@selector(follow_ME:event:) forControlEvents:UIControlEventTouchUpInside];
        [imgVw_Profile.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        imgVw_Profile.layer.borderWidth = 1.0;
        imgVw_Profile.layer.cornerRadius =  40;//half of the width and height
        imgVw_Profile.layer.masksToBounds = YES;
        [imgVw_Profile.layer setBorderWidth: 3.0];
        if (imgVw_Profile) {
            
            [imgVw_Profile sd_setImageWithURL:[NSURL URLWithString:[[arrProfileData objectAtIndex:0]valueForKey:@"profile_image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];
        }
        if (imgVw_Cover) {
            [imgVw_Cover sd_setImageWithURL:[NSURL URLWithString:[[arrProfileData objectAtIndex:0]valueForKey:@"cover_image"]] placeholderImage:CoverPlaceholder options:SDWebImageRetryFailed];
        }
        NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
        
        NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:0]  valueForKey:@"id"]];
        NSString *tmp_mutual_id =[NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:0]  valueForKey:@"mutual_friend"]];
        if([tmp_str_id isEqualToString:str] ){
            [btn_follow_unfollow setHidden:YES];
           
        }
        else
            if([self.str_follow_or_unfollow isEqualToString:@"1"]||[tmp_str_id isEqualToString:str] ||[tmp_mutual_id isEqualToString:@"1"] ){
         
                [btn_follow_unfollow setBackgroundImage:[UIImage imageNamed:@"check_blue.png"] forState:UIControlStateNormal];
        }
        else{
            [btn_follow_unfollow setBackgroundImage:[UIImage imageNamed:@"follow-btns.png"] forState:UIControlStateNormal];
        }
        
        lbl_name = (UILabel *)[cell viewWithTag:104];
        if (lbl_name && arrProfileData != nil) {
            lbl_name.text = [NSString stringWithFormat:@"%@ %@",[[arrProfileData objectAtIndex:0]valueForKey:@"first_name"],[[arrProfileData objectAtIndex:0]valueForKey:@"last_name"]];
        }
        lbl_city = (UILabel *)[cell viewWithTag:105];
        if (lbl_city) {
            lbl_city.text = [[arrProfileData objectAtIndex:0]valueForKey:@"city"];
        }
        lbl_marital = (UILabel *)[cell viewWithTag:106];
        if (lbl_marital) {
            lbl_marital.text = [[arrProfileData objectAtIndex:0]valueForKey:@"marital_status"];
        }
        lbl_follower = (UILabel *)[cell viewWithTag:109];
        if (lbl_follower) {
            
            lbl_follower.text = [NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:0]valueForKey:@"followers"]];
        }
        lbl_event = (UILabel *)[cell viewWithTag:108];
        if (lbl_event) {
            lbl_event.text = [NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:0]valueForKey:@"EVENTS"]];
        }
        lbl_following = (UILabel *)[cell viewWithTag:110];
        if (lbl_following) {
            lbl_following.text = [NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:0]valueForKey:@"following"]];
        }
        lbl_groups = (UILabel *)[cell viewWithTag:502];
        if (lbl_groups) {
            lbl_groups.text = [NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:0]valueForKey:@"Groups"]];
        }
        lbl_desc = (UILabel *)[cell viewWithTag:111];
        if (lbl_desc) {
            
            lbl_desc.text = [NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:0]valueForKey:@"description"]];
        }
        return cell;
    }
    
    else
    {
        if([arrProfileHomeData count] > 0)
        {
            MALog(@"%@ inside cell",arrProfileHomeData );
            MALog(@"%ld indexPath.row",(long)indexPath.row);
            
            if ([[[arrProfileHomeData   objectAtIndex:indexPath.row  ] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"dashboard"])
            {
                static NSString *identifier = @"imgDashCell";
                
                UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
                UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore,  *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list,*btn_readMore;
                cellImageDash = (MAImgDashCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
                UIImageView *imgVw_Uploaded;
                
                UIImageView *imgVw_Post;
                for(STTweetLabel *tweetLabel1 in [cellImageDash subviews])
                {
                    if(tweetLabel1.tag == 99999)
                    {
                        [tweetLabel1 removeFromSuperview];
                    }
                    
                }
                if(cellImageDash ==nil)
                {
                    [[NSBundle mainBundle]loadNibNamed:@"MAImgDashCell" owner:self options:nil];
                    
                }
                STTweetLabel *tweetLabel1 = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 230.0, 299.0, 50.0)];
                tweetLabel1.tag = 99999;
                tweetLabel1.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
                [tweetLabel1 setText:[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"share_text"]];
                tweetLabel1.textAlignment = NSTextAlignmentLeft;
                CGSize maxSize = CGSizeMake(tweetLabel1.bounds.size.width, CGFLOAT_MAX);
                
                CGSize labelSize = [tweetLabel1.text sizeWithFont:tweetLabel1.font
                                                constrainedToSize:maxSize
                                                    lineBreakMode:NSLineBreakByWordWrapping];
                
                
                
                CGFloat labelHeight = labelSize.height;
                int lines = labelHeight/14;
                btn_readMore = (UIButton *)[cellImageDash.contentView viewWithTag:9996];
                if(lines > 3){
                    [btn_readMore setHidden:NO];
                    [btn_readMore addTarget:self action:@selector(btnPressed_readMore:) forControlEvents:UIControlEventTouchUpInside];
                }
                [cellImageDash addSubview:tweetLabel1];
                [tweetLabel1 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                    MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                    new.hashTitle=[NSString stringWithFormat:@"%@", string];
                    [self.navigationController pushViewController:new animated:YES];
                    
                }];
                imgVw_Uploaded=(UIImageView *)[cellImageDash.contentView viewWithTag:205];
                [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                imgVw_Uploaded.layer.borderWidth = 1.0;
                imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
                imgVw_Uploaded.layer.masksToBounds = YES;
                [imgVw_Uploaded.layer setBorderWidth: 3.0];
                if(imgVw_Uploaded){
                    [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrProfileData objectAtIndex:0]valueForKey:@"profile_image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];;
                }
                imgVw_Post=(UIImageView *)[cellImageDash.contentView viewWithTag:211];
                if(imgVw_Post){
                    [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[arrProfileHomeData   objectAtIndex:indexPath.row]valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                lbl_Caption = (UILabel *)[cellImageDash.contentView viewWithTag:207];
                if(lbl_Caption){}
                lbl_like = (UILabel *)[cellImageDash.contentView viewWithTag:201];
                if(lbl_like){
                    lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"]];
                    
                }
                btnLike = (UIButton *)[cellImageDash.contentView viewWithTag:101];
                if (btnLike) {
                    [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_like_user = (UIButton *)[cellImageDash.contentView viewWithTag:110];
                if (btn_like_user) {
                    [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                lbl_backSlap = (UILabel *)[cellImageDash.contentView viewWithTag:202];
                if(lbl_backSlap){
                    lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
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
                    lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
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
                    lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"comments"]];
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
                    lbl_name.text=[NSString stringWithFormat:@"%@ %@",[[arrProfileData objectAtIndex:0]valueForKey:@"first_name"],[[arrProfileData objectAtIndex:0]valueForKey:@"last_name"]];
                }
                lbl_time = (UILabel *)[cellImageDash.contentView viewWithTag:209];
                if(lbl_time){
                    lbl_time.text=[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"date"];
                }
                
                return cellImageDash;
            }
           else if (([[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"post"]) || ((![[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_image"] isEqualToString:@""]) && [[[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"text"])){
                static NSString *identifier = @"imageCell";
                
               UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time,*lbl_dist,*lbl_dist_val,*lbl_duratn,*lbl_duratn_val,*lbl_calorie,*lbl_calorie_val;
               
               UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list,*btn_strava;
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
                [tweetLabel3 setText:[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"message"]];
                [tweetLabel3 setLineBreakMode:NSLineBreakByTruncatingTail];
                tweetLabel3.textAlignment = NSTextAlignmentLeft;
                UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
                CGSize size = [[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"message"] sizeWithFont:font
                                                                                                    constrainedToSize:tweetLabel3.frame.size
                                                                                                        lineBreakMode:NSLineBreakByWordWrapping]; // default mode
                float numberOfLines = size.height/ font.lineHeight;
                MALog(@"%f",numberOfLines);
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
                    [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrProfileData objectAtIndex:0]valueForKey:@"profile_image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];;
                }
                imgVw_Activity=(UIImageView *)[cellImage.contentView viewWithTag:210];
                
                if(imgVw_Activity){
                    if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
                        
                        NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]];
                        if (index != NSNotFound) {
                            imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:index ] valueForKey:@"img"]];
                        }
                        
                    }
                }
                imgVw_Post=(UIImageView *)[cellImage.contentView viewWithTag:211];
               if(imgVw_Post){
                   if([[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_image"] isEqualToString:@""]){
                       [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[arrProfileHomeData  objectAtIndex:indexPath.row]valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                   }
                   else{
                       [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[arrProfileHomeData  objectAtIndex:indexPath.row]valueForKey:@"strava_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                   }
               }
                lbl_Caption = (UILabel *)[cellImage.contentView viewWithTag:207];
                if(lbl_Caption){
                    
                }lbl_dist = (UILabel *)[cellImage.contentView viewWithTag:1001];
               lbl_dist_val = (UILabel *)[cellImage.contentView viewWithTag:1002];
               
               btn_strava = (UIButton *)[cellImage.contentView viewWithTag:656];
               if([[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_image"] isEqualToString:@""]){
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
                   if([[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_distance"]isEqualToString:@""]){
                       [lbl_dist_val setHidden:YES];
                       [lbl_dist setHidden:YES];
                       
                   }
                   else{
                       [lbl_dist setHidden:NO];
                       if(lbl_dist_val){
                           [lbl_dist_val setHidden:NO];
                           lbl_dist_val.text=[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_distance"];
                       }
                   }
                   
                   lbl_duratn = (UILabel *)[cellImage.contentView viewWithTag:1003];
                   lbl_duratn_val= (UILabel *)[cellImage.contentView viewWithTag:1004];
                   if([[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_duration"] isEqualToString:@""]){
                       [lbl_duratn setHidden:YES];
                       [lbl_duratn_val setHidden:YES];
                       
                   }
                   else{
                       
                       [lbl_duratn setHidden:NO];
                       if(lbl_duratn_val){
                           [lbl_duratn_val setHidden:NO];
                           lbl_duratn_val.text=[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_duration"];
                       }
                   }
                   lbl_calorie = (UILabel *)[cellImage.contentView viewWithTag:1005];
                   lbl_calorie_val = (UILabel *)[cellImage.contentView viewWithTag:1006];
                   if([[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_calories"] isEqualToString:@""]){
                       [lbl_calorie setHidden:YES];
                       [lbl_calorie_val setHidden:YES];
                   }
                   else{
                       
                       [lbl_calorie setHidden:NO];
                       [lbl_calorie_val setHidden:NO];
                       lbl_calorie_val.text=[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_calories"];
                       
                   }
               }
               

                lbl_like = (UILabel *)[cellImage.contentView viewWithTag:201];
                if(lbl_like){
                    cellImage.lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"Like"]];
                }
                btnLike = (UIButton *)[cellImage.contentView viewWithTag:101];
                if (btnLike) {
                    [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_like_user = (UIButton *)[cellImage.contentView viewWithTag:1110];
                if (btn_like_user) {
                    
                    
                    [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
                }
                btn_strava = (UIButton *)[cellImage.contentView viewWithTag:656];
                if (btn_strava) {
                    [btn_strava addTarget:self action:@selector(btnPressed_strava:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                lbl_backSlap = (UILabel *)[cellImage.contentView viewWithTag:202];
                if(lbl_backSlap){
                    cellImage.lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
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
                    lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
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
                    lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"comments"]];
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
                    lbl_name.text=[NSString stringWithFormat:@"%@ %@",[[arrProfileData objectAtIndex:0]valueForKey:@"first_name"],[[arrProfileData objectAtIndex:0]valueForKey:@"last_name"]];
                }
                lbl_time = (UILabel *)[cellImage.contentView viewWithTag:209];
                if(lbl_time){
                    lbl_time.text=[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"date"];
                }
                
                return cellImage;
            }
            else if ([[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"video"] && [[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"post"])
            {
                static NSString *identifier = @"MAVideoCell";
                UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btnPlay,  *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list;
                
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
                }
                STTweetLabel *tweetLabel4 = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 360.0, 299.0, 50.0)];
                tweetLabel4.tag = 77777;
                [tweetLabel4 setText:[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"message"]];
                tweetLabel4.textAlignment = NSTextAlignmentLeft;
                [cellVideo addSubview:tweetLabel4];
                [tweetLabel4 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                    
                    MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                    new.hashTitle=[NSString stringWithFormat:@"%@", string];
                    [self.navigationController pushViewController:new animated:YES];
                    
                }];

                imgVwThumb=(UIImageView *)[cellVideo.contentView viewWithTag:1502];
                if(imgVwThumb){
                    [imgVwThumb sd_setImageWithURL:[NSURL URLWithString:[[arrProfileHomeData  objectAtIndex:indexPath.row]valueForKey:@"thumbnails"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                imgVw_Activity=(UIImageView *)[cellVideo.contentView viewWithTag:210];
                if(imgVw_Activity){
                    if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
                        imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:indexPath.row ] valueForKey:@"img"]];
                    }
                }
                imgVw_Uploaded=(UIImageView *)[cellVideo.contentView viewWithTag:205];
                [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                imgVw_Uploaded.layer.borderWidth = 1.0;
                imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
                imgVw_Uploaded.layer.masksToBounds = YES;
                [imgVw_Uploaded.layer setBorderWidth: 3.0];
                if(imgVw_Uploaded){
                    [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrProfileHomeData   objectAtIndex:indexPath.row]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                lbl_Caption = (UILabel *)[cellVideo.contentView viewWithTag:207];
                if(lbl_Caption){
                    
                }
                lbl_like = (UILabel *)[cellVideo.contentView viewWithTag:201];
                if(lbl_like){
                    lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"]];
                    
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
                    cellImage.lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
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
                    lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
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
                    lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"comments"]];
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
                    lbl_name.text=[NSString stringWithFormat:@"%@ %@",[[arrProfileData objectAtIndex:0]valueForKey:@"first_name"],[[arrProfileData objectAtIndex:0]valueForKey:@"last_name"]];
                }
                lbl_time = (UILabel *)[cellVideo.contentView viewWithTag:209];
                if(lbl_time){
                    lbl_time.text=[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"date"];
                }
                
                
                return cellVideo;
            }
            else
            {
                
                static NSString *identifier = @"MAStatusCell";
                UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore,  *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list;
                
                UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
                UIImageView *imgVw_Uploaded;
                UIImageView *imgVw_Activity;
                for(STTweetLabel *tweetLabel5 in [cellStatus subviews])
                {
                    if(tweetLabel5.tag == 66666)
                    {
                        [tweetLabel5 removeFromSuperview];
                    }
                    
                }
                cellStatus = (MAStatusCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
                
                if(cellStatus ==nil)
                {
                    [[NSBundle mainBundle]loadNibNamed:@"MAStatusCell" owner:self options:nil];
                    
                }
                STTweetLabel *tweetLabel5 = [[STTweetLabel alloc] initWithFrame:CGRectMake(10.0, 60.0, 299.0, 50.0)];
                tweetLabel5.tag = 66666;
                [tweetLabel5 setText:[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"message"]];
                tweetLabel5.textAlignment = NSTextAlignmentLeft;
                
                [cellStatus addSubview:tweetLabel5];
                [tweetLabel5 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                    MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                    new.hashTitle=[NSString stringWithFormat:@"%@", string];
                    [self.navigationController pushViewController:new animated:YES];
                }];

                imgVw_Activity=(UIImageView *)[cellStatus.contentView viewWithTag:210];
                if(imgVw_Activity){
                    if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
                        NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"activity_name"]];
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
                    [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrProfileHomeData   objectAtIndex:indexPath.row]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
                }
                lbl_Caption = (UILabel *)[cellStatus.contentView viewWithTag:207];
                if(lbl_Caption){}
                lbl_like = (UILabel *)[cellStatus.contentView viewWithTag:201];
                if(lbl_like){
                    if([[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"] isEqualToString:@"0"]||[[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"] isEqualToString:@"1"]){
                        lbl_like.text=[NSString stringWithFormat:@"%@  Like",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"]];
                    }
                    else{
                        lbl_like.text=[NSString stringWithFormat:@"%@  Like",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"]];
                        
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
                    lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
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
                    lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
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
                    lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"comments"]];
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
                    lbl_name.text=[NSString stringWithFormat:@"%@ %@",[[arrProfileData objectAtIndex:0]valueForKey:@"first_name"],[[arrProfileData objectAtIndex:0]valueForKey:@"last_name"]];
                }
                lbl_time = (UILabel *)[cellStatus.contentView viewWithTag:209];
                if(lbl_time){
                    lbl_time.text=[NSString stringWithFormat:@"%@ ",[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"date"]];
                }
                return cellStatus;
            }
            
        }
        else{
            return cell;
        }
    }
}
#pragma mark
#pragma mark RightBar Button Item
#pragma mark

-(void)rightBtnToBlock{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AppName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Block Me", nil];
    actionSheet.tag=2000;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    
}

#pragma mark
#pragma mark TableView Button Action
#pragma mark
-(void)btnPressed_like:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MALog(@"like-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo = @{@"user_id":self.other_user_ID,
                               @"post_id":[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"id"],
                               @"type":@"Like"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tbl_Profile cellForRowAtIndexPath:indexPath];
            
            UILabel *lbl_like = (UILabel *)[cell viewWithTag:201];
            NSString *like=[NSString stringWithFormat:@"%d",[[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"] intValue] + 1];
            if([[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"] isEqualToString:@"0"]||[[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Like"] isEqualToString:@"1"]){
                lbl_like.text= [NSString stringWithFormat:@"%@  Like",like];
                NSLog(@"%@",lbl_like.text);
                
            }
            else{
                lbl_like.text=[NSString stringWithFormat:@"%@  Likes",like];
            }
            
            
            //[tbl_Profile reloadData];
            
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MALog(@"backSlap-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo = @{@"user_id":self.other_user_ID,
                               @"post_id":[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"id"],
                               @"type":@"Back Slap"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tbl_Profile cellForRowAtIndexPath:indexPath];
            UILabel *lbl_backSlap = (UILabel *)[cell viewWithTag:202];
            NSString *backSlap=[NSString stringWithFormat:@"%d",[[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] intValue] + 1];
            if([[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] isEqualToString:@"0"]||[[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] isEqualToString:@"1"]){
                lbl_backSlap.text= [NSString stringWithFormat:@"%@ Back Slap",backSlap];
                NSLog(@"%@",lbl_backSlap.text);
                
            }
            else{
                lbl_backSlap.text=[NSString stringWithFormat:@"%@ Back Slap",backSlap];
            }
            // [tbl_Profile reloadData];
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MALog(@"bumSlap-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo = @{@"user_id":self.other_user_ID,
                               @"post_id":[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"id"],
                               @"type":@"Bump Slap"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tbl_Profile cellForRowAtIndexPath:indexPath];
            UILabel *lbl_bumSlap = (UILabel *)[cell viewWithTag:203];
            NSString *bumSlap=[NSString stringWithFormat:@"%d",[[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] intValue] + 1];
            if([[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] isEqualToString:@"0"]||[[[arrProfileHomeData   objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] isEqualToString:@"1"]){
                lbl_bumSlap.text= [NSString stringWithFormat:@"%@ Bum Slap",bumSlap];
                NSLog(@"%@",lbl_bumSlap.text);
            }
            else
            {
                lbl_bumSlap.text=[NSString stringWithFormat:@"%@ Bum Slap",bumSlap];
            }
            //  [tbl_Profile reloadData];
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
-(void)btnPressed_Comments:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MALog(@"Comments-indexPath--%ld",(long)indexPath.row);
    MAPostCommentsVC *objPComments=VCWithIdentifier(@"MAPostCommentsVC");
    objPComments.post_id=[[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"id"];
    objPComments.type=@"";
    [self.navigationController pushViewController:objPComments animated:YES];
    
}
-(void)btnPressed_More:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MALog(@"More-indexPath--%ld",(long)indexPath.row);
    if([[[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"dashboard"]){
        _postMessage=[NSString stringWithFormat:@"%@ : %@",[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"message"],[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"share_text"]];
    }
    else{
        _postMessage= [[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"message"];
    }
    _imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: [[arrProfileHomeData  objectAtIndex:indexPath.row] valueForKey:@"post_image"]]];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AppName
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    actionSheet.tag=1000;
    [actionSheet addButtonWithTitle:@"Facebook Share"];
    [actionSheet addButtonWithTitle:@"Twitter Share"];
    if([[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"user_id"] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]]]){
        _postId=[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"id"];
        [actionSheet addButtonWithTitle:@"Delete Post"];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
    
    
}
#pragma mark
#pragma mark UIActionSheet Methods
#pragma mark
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag==1000){
    switch (buttonIndex) {
        case 0:
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *mySocialComposer= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                mySocialComposer = [SLComposeViewController
                                    composeViewControllerForServiceType:SLServiceTypeFacebook];
                [ApplicationDelegate show_LoadingIndicator];
                
                [mySocialComposer setInitialText:_postMessage];
                [mySocialComposer addImage:[UIImage imageWithData:_imageData]];
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
                
                [mySocialComposer setInitialText:_postMessage];
                [mySocialComposer addImage:[UIImage imageWithData:_imageData]];
                [mySocialComposer setCompletionHandler:^(SLComposeViewControllerResult result){
                    
                    
                    if (result==SLComposeViewControllerResultCancelled)
                    {
                        
                        [ApplicationDelegate showAlert:@"The post have been cancelled"];
                    }
                    else if (result==SLComposeViewControllerResultDone)
                        
                    {
                        [ApplicationDelegate showAlert:@"Posted successfully on twitter"];
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
            MALog(@" %@_postId ",_postId);
            if(_postId){
                NSDictionary* userInfo = @{
                                           @"post_id":_postId,
                                           };
                
                [ApplicationDelegate show_LoadingIndicator];
                [API DeletePostWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                    NSLog(@"responseDict--%@",responseDict);
                    
                    if([[responseDict valueForKey:@"result"] intValue] == 1)
                    {
                        insert=NO;
                        paging=1;
                        [self callProfileAPI ];
                        [ApplicationDelegate showAlert:@"Post deleted successfully."];
                        
                    }else
                    {
                        [ApplicationDelegate showAlert:ErrorStr];
                    }
                    
                    if ([ApplicationDelegate isHudShown]) {
                        [ApplicationDelegate hide_LoadingIndicator];
                    }
                }];
                
            }
        }
        default:
            break;
    }}
    else{
        switch (buttonIndex)
        {
            case 0:{
                ShowAlertWithTitleMess_YES_NO_Delegate(AppName,@"Are you sure, You want to block this user?", self);
            }
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
    }
    else{
        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        if(!([arrProfileData count]==0))
            [userInfo setValue:[[arrProfileData objectAtIndex:0]valueForKey:@"id"] forKey:@"block_user_id"];
        
        //**********ELIZA**********//
        
        [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"userid"];
        
        [ApplicationDelegate show_LoadingIndicator];
        [API block_This_user:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            if([[responseDict valueForKey:@"result"] intValue] == 1)
            {
                ShowAlertWithTitleNMessage(AppName, @"User Blocked Successfully");
            }
            
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
}

-(void)btnPressed_Play:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MALog(@"Play-indexPath--%ld",(long)indexPath.row);
    MAVideoPlay * new = VCWithIdentifier(@"MAVideoPlay");
    [self.navigationController pushViewController:new animated:YES];
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

- (IBAction)btnPressed_EditProfile:(id)sender {
    [self.view endEditing:YES];
    MAEditProfileVC *objEditProfile=VCWithIdentifier(@"MAEditProfileVC");
    objEditProfile.getUserData = [[NSDictionary alloc]init];
    NSString *socialID;
    if (arrProfileData != nil) {
        if([[arrProfileData objectAtIndex:0]valueForKey:@"social_id"]!=nil)
        {
            socialID=[[arrProfileData objectAtIndex:0]valueForKey:@"social_id"];
        }
        else{
            socialID=@"nil";
        }
        
        objEditProfile.getUserData = @{@"first_name":[[arrProfileData objectAtIndex:0]valueForKey:@"first_name"],@"last_name":[[arrProfileData objectAtIndex:0]valueForKey:@"last_name"],@"city":[[arrProfileData objectAtIndex:0]valueForKey:@"city"],@"marital_status":[[arrProfileData objectAtIndex:0]valueForKey:@"marital_status"],@"email":[[arrProfileData objectAtIndex:0]valueForKey:@"email"],@"username":[[arrProfileData objectAtIndex:0]valueForKey:@"username"],
                                       @"cover_image":[[arrProfileData objectAtIndex:0]valueForKey:@"cover_image"],
                                       @"profile_image":[[arrProfileData objectAtIndex:0]valueForKey:@"profile_image"],
                                       @"description":[[arrProfileData objectAtIndex:0]valueForKey:@"description"],
                                       @"social_id":socialID
                                       };
    }
    [self.navigationController pushViewController:objEditProfile animated:YES];
}

- (IBAction)btnPressed_UserList:(id)sender {
    NSLog(@"%@", sender);
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    
    if ([sender tag] == 333) {
        objList.listType=@"Events";
    }
    else if ([sender tag] == 334) {
        objList.listType=@"Followers";
    }
    else if([sender tag] == 335) {
        objList.listType=@"Following";
    }
    else if([sender tag] == 336) {
        objList.listType=@"Groups";
    }
    objList.my_user_id = [[arrProfileData objectAtIndex:0]valueForKey:@"id"];

    [self.navigationController pushViewController:objList animated:YES];
}


-(IBAction)openUserProfile:(id)sender event:(id)event
{
  /*  NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"%ld",(long)indexPath.row);
    
    NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
    NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:0] valueForKey:@"id"]];
    
    if([tmp_str_id isEqualToString:str]){
        MAProfileVC *obj_MAprofileVC = VCWithIdentifier(@"MAProfileVC");
        obj_MAprofileVC.check_push_or_tab=@"push";
        [self.navigationController pushViewController:obj_MAprofileVC animated:YES];
        
    }
    else{
        OtherUserProfileVC *obj_OtherUser = VCWithIdentifier(@"OtherUserProfileVC");
        obj_OtherUser.other_user_ID =[[arrProfileData objectAtIndex:0] valueForKey:@"id"];
        [self.navigationController pushViewController:obj_OtherUser animated:YES];
    }*/
}
#pragma mark
#pragma mark TableView Button Action
#pragma mark
-(void)btnPressed_like_list:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Like";
    objList.post_id=[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}
-(void)btnPressed_backSlap_list:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Back Slap";
    objList.post_id=[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}

-(void)btnPressed_bumSlap_list:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Bum Slap";
    objList.post_id=[[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}

-(IBAction)follow_ME:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"%ld",(long)indexPath.row);
    
    NSString *getId= [[arrProfileData objectAtIndex:indexPath.row] valueForKey:@"id"];
    NSString *mutual_friend=[NSString stringWithFormat:@"%@",[[arrProfileData objectAtIndex:indexPath.row] valueForKey:@"mutual_friend"]];
   
    if([mutual_friend isEqualToString:@"0"] ||  [_mutual isEqualToString:@"follow"])
    {
        [self callFollowAPI:getId index:indexPath];
    }
    else
    {
        
      [self callUnFollowAPI:getId index:indexPath];
    }
    MALog(@"follow-ID--%@",getId);
    
}

-(void)callFollowAPI:(NSString *)followId index:(NSIndexPath*)myIndex
{
    NSDictionary* userInfo = @{@"userid":[UserDefaults valueForKey:@"user_id"],
                               @"followerid":followId};
    
    [ApplicationDelegate show_LoadingIndicator];
    [API followUsersWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            _mutual =@"unfollow";
            UITableViewCell *cell = [tbl_Profile cellForRowAtIndexPath:myIndex];
            UIButton *btn_follow_unfollow = (UIButton*)[cell.contentView viewWithTag:102];
            [btn_follow_unfollow setBackgroundImage:[UIImage imageNamed:@"check_blue.png"] forState:UIControlStateNormal];
            
            [ApplicationDelegate showAlert:@"You have successfully follow user"];
                      }
        else if([[responseDict valueForKey:@"result"] intValue] == 0){
            
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
-(void)callUnFollowAPI:(NSString *)followId index:(NSIndexPath*)myIndex
{
    NSDictionary* userInfo = @{@"userid":[UserDefaults valueForKey:@"user_id"],
                               @"followerid":followId};
    
    [ApplicationDelegate show_LoadingIndicator];
    [API UnfollowUsersWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            _mutual =@"follow";
            UITableViewCell *cell = [tbl_Profile cellForRowAtIndexPath:myIndex];
            UIButton *btn_follow_unfollow = (UIButton*)[cell.contentView viewWithTag:102];
            [btn_follow_unfollow setBackgroundImage:[UIImage imageNamed:@"follow-btns.png"] forState:UIControlStateNormal];
            
            }
        else if([[responseDict valueForKey:@"result"] intValue] == 0){
            
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
-(void)btnPressed_strava:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MAStravaMapDetailVC * strava = VCWithIdentifier(@"MAStravaMapDetailVC");
    strava.activityID=[NSString stringWithFormat:@"%@", [[arrProfileHomeData objectAtIndex:indexPath.row] valueForKey:@"strava_id"]];
    [self.navigationController pushViewController:strava animated:YES];
}
-(void)btnPressed_readMore:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Profile];
    NSIndexPath *indexPath = [tbl_Profile indexPathForRowAtPoint:buttonPosition];
    MAReadMoreVC * readMore = VCWithIdentifier(@"MAReadMoreVC");
    readMore.Arr_readMore=[arrProfileHomeData objectAtIndex:indexPath.row] ;
    [self.navigationController pushViewController:readMore animated:YES];
}
@end
