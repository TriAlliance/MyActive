//
//  MAHashVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 28/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MAHashVC.h"
#import "SVPullToRefresh.h"
#import "MAVideoPlay.h"
#import "MAPostCommentsVC.h"
@interface MAHashVC ()

@end

@implementation MAHashVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrQuestionData = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:_hashTitle];
    
    self.navigationController.navigationBar.translucent = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"activityIcons" ofType:@"plist"];
    NSDictionary *dict =  [NSDictionary dictionaryWithContentsOfFile:path];
    imgActivity = [dict objectForKey:@"ActivityImages"];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    typeof(self) weakSelf = self;
    
    // setup pull-to-refresh
    [tbl_Hash addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [tbl_Hash addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    [tbl_Hash registerNib:[UINib nibWithNibName:@"MAImageCell" bundle:nil]forCellReuseIdentifier:@"imageCell"];

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

- (void)viewDidAppear:(BOOL)animated {
    
    //    [tbl_Hash triggerPullToRefresh];
}
-(void)viewWillAppear:(BOOL)animated
{
    paging=1;
    insert=NO;
    [self callHashAPI];
}

- (void)insertRowAtTop {
    insert=NO;
    paging=1;
    [self callHashAPI];
}
- (void)insertRowAtBottom {
    insert=YES;
    [self callHashAPI];
}
-(void)callHashAPI
{
    if(insert == YES){
        paging++;
    }
    else
    {
        [arrQuestionData  removeAllObjects];
    }
    NSDictionary* userInfo = @{@"keyword":_hashTitle,
                               @"page_number":[NSString stringWithFormat:@"%i",paging],
                               @"no_of_post":@"10"
                               };
    [ApplicationDelegate show_LoadingIndicator];
    [API userHashWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            NSMutableArray * arrPagData = [[NSMutableArray alloc]init];
            [arrPagData addObject:[responseDict valueForKey:@"data"]];
            
            for (int i = 0; i < [[responseDict valueForKey:@"data"] count];i++) {
                [arrQuestionData  addObject:[[arrPagData objectAtIndex:0] objectAtIndex:i]];
            }
            
        }
        else
        {
            //            [ApplicationDelegate showAlert:@"You have no Post on home"];
        }
        [tbl_Hash reloadData];
        [tbl_Hash.infiniteScrollingView stopAnimating];
        [tbl_Hash.pullToRefreshView stopAnimating];
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}


#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark
#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return arrdata.count;
    return [arrQuestionData  count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"image"] ||[[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"video"]) && [[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"post"]) {
        return 506.0;
    }
    else if ([[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"dashboard"]){
        return 367.0;
    }
    else
    {
        return 190.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 3)];
    view.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:225.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"dashboard"])
    {
        
        static NSString *identifier = @"imgDashCell";
        
        UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
        UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore;
        cellImageDash = (MAImgDashCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        UIImageView *imgVw_Uploaded;
        
        UIImageView *imgVw_Post;
        
        if(cellImageDash ==nil)
        {
            [[NSBundle mainBundle]loadNibNamed:@"MAImgDashCell" owner:self options:nil];
        }
        imgVw_Uploaded=(UIImageView *)[cellImageDash.contentView viewWithTag:205];
        [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        imgVw_Uploaded.layer.borderWidth = 1.0;
        imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
        imgVw_Uploaded.layer.masksToBounds = YES;
        [imgVw_Uploaded.layer setBorderWidth: 3.0];
        if(imgVw_Uploaded){
            [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:indexPath.row]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
        }
        imgVw_Post=(UIImageView *)[cellImageDash.contentView viewWithTag:211];
        if(imgVw_Post){
            [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:indexPath.row]valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
        }
        lbl_Caption = (UILabel *)[cellImageDash.contentView viewWithTag:207];
        if(lbl_Caption){
            
            //  lbl_Caption.text=[NSString stringWithFormat:@"%@ : %@",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"],[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"share_text"]];
            STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 240.0, 299.0, 63.0)];
            [tweetLabel setText:[NSString stringWithFormat:@"%@ : %@",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"],[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"share_text"]]];
            tweetLabel.textAlignment = NSTextAlignmentLeft;
            
            [cellImageDash addSubview:tweetLabel];
            [tweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                //   NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
                
                
                MALog(@"%@hashtag", [NSString stringWithFormat:@"%u", hotWord]);
                MALog(@"%@string", [NSString stringWithFormat:@"%@", string]);
                MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                new.hashTitle=[NSString stringWithFormat:@"%@", string];
                [self.navigationController pushViewController:new animated:YES];
                
            }];
            
            
        }
        lbl_like = (UILabel *)[cellImageDash.contentView viewWithTag:201];
        if(lbl_like){
            lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"]];
            
        }
        btnLike = (UIButton *)[cellImageDash.contentView viewWithTag:101];
        if (btnLike) {
            [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_backSlap = (UILabel *)[cellImageDash.contentView viewWithTag:202];
        if(lbl_backSlap){
            lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
        }
        btnBackSlap = (UIButton *)[cellImageDash.contentView viewWithTag:102];
        if (btnBackSlap) {
            [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_bumSlap = (UILabel *)[cellImageDash.contentView viewWithTag:203];
        if(lbl_bumSlap){
            lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
        }
        btnBumSlap = (UIButton *)[cellImageDash.contentView viewWithTag:103];
        if (btnBumSlap) {
            [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_Comments = (UILabel *)[cellImageDash.contentView viewWithTag:204];
        if(lbl_Comments){
            lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"comments"]];
        }
        btnComments = (UIButton *)[cellImageDash.contentView viewWithTag:104];
        if (btnComments) {
            [btnComments addTarget:self action:@selector(btnPressed_Comments:) forControlEvents:UIControlEventTouchUpInside];
        }
        btnMore = (UIButton *)[cellImageDash.contentView viewWithTag:105];
        if (btnMore) {
            [btnMore addTarget:self action:@selector(btnPressed_More:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_name = (UILabel *)[cellImageDash.contentView viewWithTag:208];
        if(lbl_name){
            lbl_name.text=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"user_first_name"];
        }
        lbl_time = (UILabel *)[cellImageDash.contentView viewWithTag:209];
        if(lbl_time){
            lbl_time.text=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"date"];
        }
        
        return cellImageDash;
    }
    else if ([[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"post"]) {
        
        static NSString *identifier = @"imageCell";
        
        UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
        UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore;
        cellImage = (MAImageCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        UIImageView *imgVw_Uploaded;
        UIImageView *imgVw_Activity;
        UIImageView *imgVw_Post;
        
        if(cellImage ==nil)
        {
            [[NSBundle mainBundle]loadNibNamed:@"MAImageCell" owner:self options:nil];
        }
        imgVw_Uploaded=(UIImageView *)[cellImage.contentView viewWithTag:205];
        [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        imgVw_Uploaded.layer.borderWidth = 1.0;
        imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
        imgVw_Uploaded.layer.masksToBounds = YES;
        [imgVw_Uploaded.layer setBorderWidth: 3.0];
        if(imgVw_Uploaded){
            [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:indexPath.row]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
        }
        imgVw_Activity=(UIImageView *)[cellImage.contentView viewWithTag:210];
        
        if(imgVw_Activity){
            if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
                
                NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]];
                if (index != NSNotFound) {
                    imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:index ] valueForKey:@"img"]];
                }
                
            }
        }
        imgVw_Post=(UIImageView *)[cellImage.contentView viewWithTag:211];
        if(imgVw_Post){
            [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:indexPath.row]valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
        }
        lbl_Caption = (UILabel *)[cellImage.contentView viewWithTag:207];
        if(lbl_Caption){
            NSString *caption;
            if ([[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"dashboard"] )
            {
                caption=[NSString stringWithFormat:@"%@ : %@",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"],[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"share_text"]];
            }
            else{
                caption=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"];
            }
            STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 380.0, 299.0, 63.0)];
            [tweetLabel setText:caption];
            tweetLabel.textAlignment = NSTextAlignmentLeft;
            
            [cellImage addSubview:tweetLabel];
            [tweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
               
                MALog(@"%@hashtag", [NSString stringWithFormat:@"%u", hotWord]);
                MALog(@"%@string", [NSString stringWithFormat:@"%@", string]);
                MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                new.hashTitle=[NSString stringWithFormat:@"%@", string];
                [self.navigationController pushViewController:new animated:YES];
                
            }];
            
        }
        lbl_like = (UILabel *)[cellImage.contentView viewWithTag:201];
        if(lbl_like){
            cellImage.lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"]];
            
        }
        btnLike = (UIButton *)[cellImage.contentView viewWithTag:101];
        if (btnLike) {
            [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_backSlap = (UILabel *)[cellImage.contentView viewWithTag:202];
        if(lbl_backSlap){
            cellImage.lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
        }
        btnBackSlap = (UIButton *)[cellImage.contentView viewWithTag:102];
        if (btnBackSlap) {
            [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_bumSlap = (UILabel *)[cellImage.contentView viewWithTag:203];
        if(lbl_bumSlap){
            lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
        }
        btnBumSlap = (UIButton *)[cellImage.contentView viewWithTag:103];
        if (btnBumSlap) {
            [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_Comments = (UILabel *)[cellImage.contentView viewWithTag:204];
        if(lbl_Comments){
            lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"comments"]];
        }
        btnComments = (UIButton *)[cellImage.contentView viewWithTag:104];
        if (btnComments) {
            [btnComments addTarget:self action:@selector(btnPressed_Comments:) forControlEvents:UIControlEventTouchUpInside];
        }
        btnMore = (UIButton *)[cellImage.contentView viewWithTag:105];
        if (btnMore) {
            [btnMore addTarget:self action:@selector(btnPressed_More:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_name = (UILabel *)[cellImage.contentView viewWithTag:208];
        if(lbl_name){
            lbl_name.text=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"user_first_name"];
        }
        lbl_time = (UILabel *)[cellImage.contentView viewWithTag:209];
        if(lbl_time){
            lbl_time.text=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"date"];
        }
        
        return cellImage;
    }
    else if ([[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"video"] && [[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"post"])
    {
        static NSString *identifier = @"MAVideoCell";
        UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btnPlay;
        UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
        UIImageView *imgVw_Uploaded;
        UIImageView *imgVw_Activity;
        cellVideo = (MAVideoCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if(cellVideo ==nil)
        {
            [[NSBundle mainBundle]loadNibNamed:@"MAVideoCell" owner:self options:nil];
        }
        imgVw_Activity=(UIImageView *)[cellVideo.contentView viewWithTag:210];
        if(imgVw_Activity){
            if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
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
            [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:indexPath.row]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
        }
        lbl_Caption = (UILabel *)[cellVideo.contentView viewWithTag:207];
        if(lbl_Caption){
            //lbl_Caption.text=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"];
            STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 380.0, 299.0, 63.0)];
            [tweetLabel setText:[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"]];
            tweetLabel.textAlignment = NSTextAlignmentLeft;
            [cellVideo addSubview:tweetLabel];
            [tweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
                lbl_Caption.text=[NSString stringWithFormat:@"%@ [%d,%d]: %@%@", hotWords[hotWord], (int)range.location, (int)range.length, string, (protocol != nil) ? [NSString stringWithFormat:@" *%@*", protocol] : @""];
                
                MALog(@"%@hashtag", [NSString stringWithFormat:@"%u", hotWord]);
                MALog(@"%@string", [NSString stringWithFormat:@"%@", string]);
                MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                new.hashTitle=[NSString stringWithFormat:@"%@", string];
                [self.navigationController pushViewController:new animated:YES];
                
            }];
            
        }
        lbl_like = (UILabel *)[cellVideo.contentView viewWithTag:201];
        if(lbl_like){
            lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"]];
            
        }
        btnLike = (UIButton *)[cellVideo.contentView viewWithTag:101];
        if (btnLike) {
            [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_backSlap = (UILabel *)[cellVideo.contentView viewWithTag:202];
        if(lbl_backSlap){
            cellImage.lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
        }
        btnBackSlap = (UIButton *)[cellVideo.contentView viewWithTag:102];
        if (btnBackSlap) {
            [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_bumSlap = (UILabel *)[cellVideo.contentView viewWithTag:203];
        if(lbl_bumSlap){
            lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
        }
        
        btnBumSlap = (UIButton *)[cellVideo.contentView viewWithTag:103];
        if (btnBumSlap) {
            [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_Comments = (UILabel *)[cellVideo.contentView viewWithTag:204];
        if(lbl_Comments){
            lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"comments"]];
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
        
        lbl_name = (UILabel *)[cellVideo.contentView viewWithTag:208];
        if(lbl_name){
            lbl_name.text=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"user_first_name"];
        }
        lbl_time = (UILabel *)[cellVideo.contentView viewWithTag:209];
        if(lbl_time){
            lbl_time.text=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"date"];
        }
        
        
        return cellVideo;
    }
    else
    {
        static NSString *identifier = @"MAStatusCell";
        UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore;
        
        UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
        UIImageView *imgVw_Uploaded;
        UIImageView *imgVw_Activity;
        cellStatus = (MAStatusCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if(cellStatus ==nil)
        {
            [[NSBundle mainBundle]loadNibNamed:@"MAStatusCell" owner:self options:nil];
        }
        imgVw_Activity=(UIImageView *)[cellStatus.contentView viewWithTag:210];
        if(imgVw_Activity){
            if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
                NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]];
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
            [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:indexPath.row]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
        }
        lbl_Caption = (UILabel *)[cellStatus.contentView viewWithTag:207];
        if(lbl_Caption){
            
            STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(10.0, 60.0, 299.0, 63.0)];
            [tweetLabel setText:[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"]];
            tweetLabel.textAlignment = NSTextAlignmentLeft;
            
            [cellStatus addSubview:tweetLabel];
            [tweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                MALog(@"%@hashtag", [NSString stringWithFormat:@"%u", hotWord]);
                MALog(@"%@string", [NSString stringWithFormat:@"%@", string]);
                MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                new.hashTitle=[NSString stringWithFormat:@"%@", string];
                [self.navigationController pushViewController:new animated:YES];
                
            }];
            
            
        }
        lbl_like = (UILabel *)[cellStatus.contentView viewWithTag:201];
        if(lbl_like){
            if([[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"] isEqualToString:@"0"]||[[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"] isEqualToString:@"1"]){
                lbl_like.text=[NSString stringWithFormat:@"%@  Like",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"]];
            }
            else{
                lbl_like.text=[NSString stringWithFormat:@"%@  Like",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"]];
                
            }
        }
        
        btnLike = (UIButton *)[cellStatus.contentView viewWithTag:101];
        if (btnLike) {
            [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_backSlap = (UILabel *)[cellStatus.contentView viewWithTag:202];
        if(lbl_backSlap){
            lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
        }
        btnBackSlap = (UIButton *)[cellStatus.contentView viewWithTag:102];
        if (btnBackSlap) {
            [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_bumSlap = (UILabel *)[cellStatus.contentView viewWithTag:203];
        if(lbl_bumSlap){
            lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
        }
        
        btnBumSlap = (UIButton *)[cellStatus.contentView viewWithTag:103];
        if (btnBumSlap) {
            [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
        }
        lbl_Comments = (UILabel *)[cellStatus.contentView viewWithTag:204];
        if(lbl_Comments){
            lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"comments"]];
        }
        btnComments = (UIButton *)[cellStatus.contentView viewWithTag:104];
        if (btnComments) {
            [btnComments addTarget:self action:@selector(btnPressed_Comments:) forControlEvents:UIControlEventTouchUpInside];
        }
        btnMore = (UIButton *)[cellStatus.contentView viewWithTag:105];
        if (btnMore) {
            [btnMore addTarget:self action:@selector(btnPressed_More:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        lbl_name = (UILabel *)[cellStatus.contentView viewWithTag:208];
        if(lbl_name){
            lbl_name.text=[NSString stringWithFormat:@"%@ ",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"user_first_name"]];
        }
        lbl_time = (UILabel *)[cellStatus.contentView viewWithTag:209];
        if(lbl_time){
            lbl_time.text=[NSString stringWithFormat:@"%@ ",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"date"]];
        }
        return cellStatus;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark TableView Button Action
#pragma mark
-(void)btnPressed_like:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Hash];
    NSIndexPath *indexPath = [tbl_Hash indexPathForRowAtPoint:buttonPosition];
    MALog(@"like-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"id"],
                               @"type":@"Like"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tbl_Hash cellForRowAtIndexPath:indexPath];
            
            UILabel *lbl_like = (UILabel *)[cell viewWithTag:201];
            NSString *like=[NSString stringWithFormat:@"%d",[[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"] intValue] + 1];
            if([[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"] isEqualToString:@"0"]||[[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Like"] isEqualToString:@"1"]){
                lbl_like.text= [NSString stringWithFormat:@"%@  Like",like];
                NSLog(@"%@",lbl_like.text);
                
            }
            else{
                lbl_like.text=[NSString stringWithFormat:@"%@  Likes",like];
            }
            
            
            //[tbl_Hash reloadData];
            
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Hash];
    NSIndexPath *indexPath = [tbl_Hash indexPathForRowAtPoint:buttonPosition];
    MALog(@"backSlap-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"id"],
                               @"type":@"Back Slap"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tbl_Hash cellForRowAtIndexPath:indexPath];
            UILabel *lbl_backSlap = (UILabel *)[cell viewWithTag:202];
            NSString *backSlap=[NSString stringWithFormat:@"%d",[[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] intValue] + 1];
            if([[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] isEqualToString:@"0"]||[[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] isEqualToString:@"1"]){
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Hash];
    NSIndexPath *indexPath = [tbl_Hash indexPathForRowAtPoint:buttonPosition];
    MALog(@"bumSlap-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"id"],
                               @"type":@"Bump Slap"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tbl_Hash cellForRowAtIndexPath:indexPath];
            UILabel *lbl_bumSlap = (UILabel *)[cell viewWithTag:203];
            NSString *bumSlap=[NSString stringWithFormat:@"%d",[[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] intValue] + 1];
            if([[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] isEqualToString:@"0"]||[[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] isEqualToString:@"1"]){
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
-(void)btnPressed_Comments:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Hash];
    NSIndexPath *indexPath = [tbl_Hash indexPathForRowAtPoint:buttonPosition];
    MALog(@"Comments-indexPath--%ld",(long)indexPath.row);
    MAPostCommentsVC *objPComments=VCWithIdentifier(@"MAPostCommentsVC");
    objPComments.post_id=[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"id"];
    objPComments.type=@"";
    [self.navigationController pushViewController:objPComments animated:YES];
}
-(void)btnPressed_More:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Hash];
    NSIndexPath *indexPath = [tbl_Hash indexPathForRowAtPoint:buttonPosition];
    MALog(@"More-indexPath--%ld",(long)indexPath.row);
    if([[[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"dashboard"]){
        _postMessage=[NSString stringWithFormat:@"%@ : %@",[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"],[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"share_text"]];
    }
    else{
        _postMessage= [[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"message"];
    }
    _imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: [[arrQuestionData  objectAtIndex:indexPath.row] valueForKey:@"post_image"]]];
    MALog(@"%@",_imageData);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AppName
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Facebook Share"];
    [actionSheet addButtonWithTitle:@"Twitter Share"];
    if([[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"user_id"] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]]]){
        _postId=[[arrQuestionData objectAtIndex:indexPath.row] valueForKey:@"id"];
        [actionSheet addButtonWithTitle:@"Delete Post"];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
    
    
}
#pragma mark
#pragma mark UIActionSheet Methods
#pragma mark
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
            if([title isEqual: @"Delete Post"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Are you sure you want to delete this." delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
                [alert show];
                MALog(@" %@_postId ",_postId);
            }
        }
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        if(_postId){
            NSDictionary* userInfo = @{
                                       @"post_id":_postId,
                                       };
            
            [ApplicationDelegate show_LoadingIndicator];
            [API DeletePostWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                NSLog(@"responseDict--%@",responseDict);
                
                if([[responseDict valueForKey:@"result"] intValue] == 1)
                {
                    paging=1;
                    insert=NO;
                    [self callHashAPI];
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
}
-(void)btnPressed_Play:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_Hash];
    NSIndexPath *indexPath = [tbl_Hash indexPathForRowAtPoint:buttonPosition];
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

@end

