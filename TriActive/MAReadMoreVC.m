//
//  MAReadMoreVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 23/02/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MAReadMoreVC.h"
#import "SVPullToRefresh.h"
#import "MAVideoPlay.h"
#import "MAPostCommentsVC.h"
#import "MAHashVC.h"
#import "MAUsersVC.h"
@interface MAReadMoreVC ()

@end

@implementation MAReadMoreVC


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
    arrQuestionData = [[NSMutableArray alloc]init];
    MALog(@"%@", _Arr_readMore);
    if([_Arr_readMore count]>0){
        [arrQuestionData  removeAllObjects];
    }
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Post"];

    self.navigationController.navigationBar.translucent = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"activityIcons" ofType:@"plist"];
    NSDictionary *dict =  [NSDictionary dictionaryWithContentsOfFile:path];
    imgActivity = [dict objectForKey:@"ActivityImages"];
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
    
    //    [tblVw_Question triggerPullToRefresh];
}
-(void)viewWillAppear:(BOOL)animated
{
    if([_Arr_readMore count]>0){
       [arrQuestionData  addObject:_Arr_readMore];
    }
    else{
         [self callQuestionAPI];
    }
   
 }

-(void)callQuestionAPI
{
    
        [arrQuestionData  removeAllObjects];
    
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"page_number":@"1",
                               @"no_of_post":@"1"
                               };
    [ApplicationDelegate show_LoadingIndicator];
    [API userQuestionWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
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
        [tblVw_Question reloadData];
        [tblVw_Question.infiniteScrollingView stopAnimating];
        [tblVw_Question.pullToRefreshView stopAnimating];
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([[[arrQuestionData  objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"image"] ||[[[arrQuestionData  objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"video"]) && [[[arrQuestionData  objectAtIndex:0] valueForKey:@"post_type"] isEqualToString:@"post"]) {
        return 514.0;
    }
    else if ([[[arrQuestionData  objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrQuestionData  objectAtIndex:0] valueForKey:@"post_type"] isEqualToString:@"dashboard"]){
        return 367.0;
    }
    else
    {
        return 192.0;
    };
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
    
    if([arrQuestionData   count]){
        if ([[[arrQuestionData  objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrQuestionData  objectAtIndex:0] valueForKey:@"post_type"] isEqualToString:@"dashboard"])
        {
            static NSString *identifier = @"imgDashCell";
            UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
            UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list;
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
            UIView *Vw_readMore;
           
           
            if(cellImageDash ==nil)
            {
                [[NSBundle mainBundle]loadNibNamed:@"MAImgDashCell" owner:self options:nil];
              }
             Vw_readMore=(UIView *)[cellImageDash.contentView viewWithTag:9997];
                STTweetLabel *tweetLabel1 = [[STTweetLabel alloc]
                                             initWithFrame:CGRectMake(9.0, 240.0, 299.0, 53.0)];
                
                tweetLabel1.tag=99999;
                [tweetLabel1 setText:[[arrQuestionData objectAtIndex:0] valueForKey:@"share_text"]];
                tweetLabel1.textAlignment = NSTextAlignmentLeft;
              CGSize maxSize = CGSizeMake(tweetLabel1.bounds.size.width, CGFLOAT_MAX);
            
            CGSize labelSize = [tweetLabel1.text sizeWithFont:tweetLabel1.font
                                            constrainedToSize:maxSize
                                                lineBreakMode:NSLineBreakByWordWrapping];
            
            
            
            CGFloat labelHeight = labelSize.height;
            int lines = labelHeight/14;
            if(lines>3){
                tweetLabel1.frame =CGRectMake(9.0, 240.0, 299.0,labelSize.height);
                Vw_readMore.frame=CGRectMake(9.0,229.0+labelSize.height, 320.0,72);
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
                [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:0]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            imgVw_Post=(UIImageView *)[cellImageDash.contentView viewWithTag:211];
            if(imgVw_Post){
                [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:0]valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            lbl_Caption = (UILabel *)[cellImageDash.contentView viewWithTag:207];
            if(lbl_Caption){}
            lbl_like = (UILabel *)[cellImageDash.contentView viewWithTag:201];
            if(lbl_like){
                lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"]];
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
                lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrQuestionData  objectAtIndex:0] valueForKey:@"Back Slap"]];
            }
            btnBackSlap = (UIButton *)[cellImageDash.contentView viewWithTag:102];
            if (btnBackSlap) {
                [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
            }
            btnBackSlap_list = (UIButton *)[cellImage.contentView viewWithTag:220];
            if (btnBackSlap_list) {
                [btnBackSlap_list addTarget:self action:@selector(btnPressed_backSlap_list:) forControlEvents:UIControlEventTouchUpInside];
            }
            lbl_bumSlap = (UILabel *)[cellImageDash.contentView viewWithTag:203];
            if(lbl_bumSlap){
                lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrQuestionData  objectAtIndex:0] valueForKey:@"Bump Slap"]];
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
                lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrQuestionData objectAtIndex:0] valueForKey:@"comments"]];
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
                lbl_name.text=[[arrQuestionData objectAtIndex:0] valueForKey:@"user_first_name"];
            }
            lbl_time = (UILabel *)[cellImageDash.contentView viewWithTag:209];
            if(lbl_time){
                lbl_time.text=[[arrQuestionData objectAtIndex:0] valueForKey:@"date"];
            }
            
            return cellImageDash;
        }
        else if ([[[arrQuestionData  objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"image"] && [[[arrQuestionData  objectAtIndex:0] valueForKey:@"post_type"] isEqualToString:@"post"]) {
            
            static NSString *identifier = @"imageCell";
            
            UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
            UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list;
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
            UIView *Vw_readMore;
            Vw_readMore=(UIView *)[cellImage.contentView viewWithTag:9997];
            STTweetLabel *tweetLabel3 = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 380.0, 299.0, 50.0)];
            tweetLabel3.tag=88888;
            [tweetLabel3 setText:[[arrQuestionData objectAtIndex:0] valueForKey:@"message"]];
            CGSize maxSize = CGSizeMake(tweetLabel3.bounds.size.width, CGFLOAT_MAX);
            
            CGSize labelSize = [tweetLabel3.text sizeWithFont:tweetLabel3.font
                                            constrainedToSize:maxSize
                                                lineBreakMode:NSLineBreakByWordWrapping];
            
            
            
            CGFloat labelHeight = labelSize.height;
            int lines = labelHeight/14;
            if(lines>3){
                tweetLabel3.frame =CGRectMake(9.0, 380.0, 299.0,labelSize.height);
                Vw_readMore.frame=CGRectMake(9.0,tweetLabel3.frame.size.height+370, 320.0,72);
              
            }

          //  [tweetLabel3 setLineBreakMode:NSLineBreakByTruncatingTail];
            tweetLabel3.textAlignment = NSTextAlignmentLeft;
            
            
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
                [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:0]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            imgVw_Activity=(UIImageView *)[cellImage.contentView viewWithTag:210];
            
            if(imgVw_Activity){
                if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrQuestionData objectAtIndex:0] valueForKey:@"activity_name"]]) {
                    
                    NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[arrQuestionData objectAtIndex:0] valueForKey:@"activity_name"]];
                    if (index != NSNotFound) {
                        imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:index ] valueForKey:@"img"]];
                    }
                    
                }
            }
            imgVw_Post=(UIImageView *)[cellImage.contentView viewWithTag:211];
            if(imgVw_Post){
                [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:0]valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            lbl_Caption = (UILabel *)[cellImage.contentView viewWithTag:207];
            if(lbl_Caption){
                
            }
            lbl_like = (UILabel *)[cellImage.contentView viewWithTag:201];
            if(lbl_like){
                cellImage.lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"]];
            }
            btnLike = (UIButton *)[cellImage.contentView viewWithTag:101];
            if (btnLike) {
                [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
            }
            btn_like_user = (UIButton *)[cellImage.contentView viewWithTag:110];
            if (btn_like_user) {
                [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
            }
            lbl_backSlap = (UILabel *)[cellImage.contentView viewWithTag:202];
            if(lbl_backSlap){
                cellImage.lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrQuestionData objectAtIndex:0] valueForKey:@"Back Slap"]];
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
                lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrQuestionData objectAtIndex:0] valueForKey:@"Bump Slap"]];
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
                lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrQuestionData objectAtIndex:0] valueForKey:@"comments"]];
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
                lbl_name.text=[[arrQuestionData objectAtIndex:0] valueForKey:@"user_first_name"];
            }
            lbl_time = (UILabel *)[cellImage.contentView viewWithTag:209];
            if(lbl_time){
                lbl_time.text=[[arrQuestionData objectAtIndex:0] valueForKey:@"date"];
            }
            
            return cellImage;
        }
        else if ([[[arrQuestionData  objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"video"] && [[[arrQuestionData  objectAtIndex:0] valueForKey:@"post_type"] isEqualToString:@"post"])
        {
            static NSString *identifier = @"MAVideoCell";
            UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btnPlay, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list;
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
            UIView *Vw_readMore;
            Vw_readMore=(UIView *)[cellVideo.contentView viewWithTag:9997];
            STTweetLabel *tweetLabel4 = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 360.0, 299.0, 53.0)];
            tweetLabel4.tag = 77777;
            [tweetLabel4 setText:[[arrQuestionData objectAtIndex:0] valueForKey:@"message"]];
            tweetLabel4.textAlignment = NSTextAlignmentLeft;
            CGSize maxSize = CGSizeMake(tweetLabel4.bounds.size.width, CGFLOAT_MAX);
            
            CGSize labelSize = [tweetLabel4.text sizeWithFont:tweetLabel4.font
                                            constrainedToSize:maxSize
                                                lineBreakMode:NSLineBreakByWordWrapping];
            
            
            
            CGFloat labelHeight = labelSize.height;
            int lines = labelHeight/14;
            if(lines>3){
                tweetLabel4.frame =CGRectMake(9.0, 360.0, 299.0,labelSize.height);
                Vw_readMore.frame=CGRectMake(9.0,tweetLabel4.frame.size.height+370, 320.0,72);
                
              
            }
            [cellVideo addSubview:tweetLabel4];
            [tweetLabel4 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                new.hashTitle=[NSString stringWithFormat:@"%@", string];
                [self.navigationController pushViewController:new animated:YES];
            }];
            
            imgVwThumb=(UIImageView *)[cellVideo.contentView viewWithTag:1502];
            if(imgVwThumb){
                [imgVwThumb sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:0]valueForKey:@"thumbnails"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            imgVw_Activity=(UIImageView *)[cellVideo.contentView viewWithTag:210];
            if(imgVw_Activity){
                if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrQuestionData objectAtIndex:0] valueForKey:@"activity_name"]]) {
                    imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:0 ] valueForKey:@"img"]];
                }
            }
            imgVw_Uploaded=(UIImageView *)[cellVideo.contentView viewWithTag:205];
            [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
            imgVw_Uploaded.layer.borderWidth = 1.0;
            imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
            imgVw_Uploaded.layer.masksToBounds = YES;
            [imgVw_Uploaded.layer setBorderWidth: 3.0];
            if(imgVw_Uploaded){
                [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:0]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            lbl_Caption = (UILabel *)[cellVideo.contentView viewWithTag:207];
            if(lbl_Caption){}
            lbl_like = (UILabel *)[cellVideo.contentView viewWithTag:201];
            if(lbl_like){
                lbl_like.text=[NSString stringWithFormat:@"%@  Likes",[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"]];
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
                cellImage.lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrQuestionData objectAtIndex:0] valueForKey:@"Back Slap"]];
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
                lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrQuestionData objectAtIndex:0] valueForKey:@"Bump Slap"]];
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
                lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrQuestionData objectAtIndex:0] valueForKey:@"comments"]];
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
                lbl_name.text=[[arrQuestionData objectAtIndex:0] valueForKey:@"user_first_name"];
            }
            lbl_time = (UILabel *)[cellVideo.contentView viewWithTag:209];
            if(lbl_time){
                lbl_time.text=[[arrQuestionData objectAtIndex:0] valueForKey:@"date"];
            }
            return cellVideo;
        }
        else
        {
            static NSString *identifier = @"MAStatusCell";
            UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore, *btn_name,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list;
            UIView *Vw_readMore;
            UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
            UIImageView *imgVw_Uploaded;
            UIImageView *imgVw_Activity;
           
            cellStatus = (MAStatusCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            for(STTweetLabel *tweetLabel5 in [cellStatus subviews])
            {
                if(tweetLabel5.tag == 66666)
                {
                    [tweetLabel5 removeFromSuperview];
                   // [Vw_readMore removeFromSuperview];
                }
                
            }
            if(cellStatus ==nil)
            {
                [[NSBundle mainBundle]loadNibNamed:@"MAStatusCell" owner:self options:nil];
                
            }
            Vw_readMore=(UIView *)[cellStatus.contentView viewWithTag:9997];
            int lines;
            STTweetLabel *tweetLabel5 = [[STTweetLabel alloc] initWithFrame:CGRectMake(9.0, 60.0, 299.0, 63.0)];
            tweetLabel5.tag = 66666;
            [tweetLabel5 setText:[[arrQuestionData objectAtIndex:0] valueForKey:@"message"]];
            tweetLabel5.textAlignment = NSTextAlignmentLeft;
            CGSize maxSize = CGSizeMake(tweetLabel5.bounds.size.width, CGFLOAT_MAX);
            
            CGSize labelSize = [tweetLabel5.text sizeWithFont:tweetLabel5.font
                                            constrainedToSize:maxSize
                                                lineBreakMode:NSLineBreakByWordWrapping];
            
            
            
            CGFloat labelHeight = labelSize.height;
            lines = labelHeight/14;
            if(lines>3){
                tweetLabel5.frame =CGRectMake(9.0, 60.0, 299.0,labelSize.height);
                
              Vw_readMore.frame=CGRectMake(9.0,tweetLabel5.frame.size.height+50 , 320.0,72);

            }
            [cellStatus addSubview:tweetLabel5];
            [tweetLabel5 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                MAHashVC * new = VCWithIdentifier(@"MAHashVC");
                new.hashTitle=[NSString stringWithFormat:@"%@", string];
                [self.navigationController pushViewController:new animated:YES];
                
            }];
            imgVw_Activity=(UIImageView *)[cellStatus.contentView viewWithTag:210];
            if(imgVw_Activity){
                if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrQuestionData objectAtIndex:0] valueForKey:@"activity_name"]]) {
                    NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[arrQuestionData objectAtIndex:0] valueForKey:@"activity_name"]];
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
                [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrQuestionData  objectAtIndex:0]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            lbl_Caption = (UILabel *)[cellStatus.contentView viewWithTag:207];
            if(lbl_Caption){}
            lbl_like = (UILabel *)[cellStatus.contentView viewWithTag:201];
            if(lbl_like){
                               if([[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"] isEqualToString:@"0"]||[[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"] isEqualToString:@"1"]){
                    lbl_like.text=[NSString stringWithFormat:@"%@  Like",[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"]];
                }
                else{
                    lbl_like.text=[NSString stringWithFormat:@"%@  Like",[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"]];
                    
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
                lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrQuestionData objectAtIndex:0] valueForKey:@"Back Slap"]];
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
                lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrQuestionData objectAtIndex:0] valueForKey:@"Bump Slap"]];
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
                lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrQuestionData objectAtIndex:0] valueForKey:@"comments"]];
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
                lbl_name.text=[NSString stringWithFormat:@"%@ ",[[arrQuestionData objectAtIndex:0] valueForKey:@"user_first_name"]];
            }
            lbl_time = (UILabel *)[cellStatus.contentView viewWithTag:209];
            if(lbl_time){
                lbl_time.text=[NSString stringWithFormat:@"%@ ",[[arrQuestionData objectAtIndex:0] valueForKey:@"date"]];
            }
            return cellStatus;
        }
        
    }
    else{
        static NSString *identifier = @"imgDashCell";
        
        cellImageDash = (MAImgDashCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cellImageDash ==nil)
        {
            [[NSBundle mainBundle]loadNibNamed:@"MAImgDashCell" owner:self options:nil];
        }
        return cellImageDash;
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_Question];
    NSIndexPath *indexPath = [tblVw_Question indexPathForRowAtPoint:buttonPosition];
    MALog(@"like-indexPath--%ld",(long)0);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[arrQuestionData objectAtIndex:0] valueForKey:@"id"],
                               @"type":@"Like"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tblVw_Question cellForRowAtIndexPath:indexPath];
            
            UILabel *lbl_like = (UILabel *)[cell viewWithTag:201];
            NSString *like=[NSString stringWithFormat:@"%d",[[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"] intValue] + 1];
            if([[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"] isEqualToString:@"0"]||[[[arrQuestionData objectAtIndex:0] valueForKey:@"Like"] isEqualToString:@"1"]){
                lbl_like.text= [NSString stringWithFormat:@"%@  Like",like];
                NSLog(@"%@",lbl_like.text);
                
            }
            else{
                lbl_like.text=[NSString stringWithFormat:@"%@  Likes",like];
            }
            
            
            //[tblVw_Question reloadData];
            
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_Question];
    NSIndexPath *indexPath = [tblVw_Question indexPathForRowAtPoint:buttonPosition];
    MALog(@"backSlap-indexPath--%ld",(long)0);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[arrQuestionData objectAtIndex:0] valueForKey:@"id"],
                               @"type":@"Back Slap"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tblVw_Question cellForRowAtIndexPath:indexPath];
            UILabel *lbl_backSlap = (UILabel *)[cell viewWithTag:202];
            NSString *backSlap=[NSString stringWithFormat:@"%d",[[[arrQuestionData objectAtIndex:0] valueForKey:@"Back Slap"] intValue] + 1];
            if([[[arrQuestionData objectAtIndex:0] valueForKey:@"Back Slap"] isEqualToString:@"0"]||[[[arrQuestionData objectAtIndex:0] valueForKey:@"Back Slap"] isEqualToString:@"1"]){
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_Question];
    NSIndexPath *indexPath = [tblVw_Question indexPathForRowAtPoint:buttonPosition];
    MALog(@"bumSlap-indexPath--%ld",(long)0);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"post_id":[[arrQuestionData objectAtIndex:0] valueForKey:@"id"],
                               @"type":@"Bump Slap"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API HomeLikeWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tblVw_Question cellForRowAtIndexPath:indexPath];
            UILabel *lbl_bumSlap = (UILabel *)[cell viewWithTag:203];
            NSString *bumSlap=[NSString stringWithFormat:@"%d",[[[arrQuestionData objectAtIndex:0] valueForKey:@"Bump Slap"] intValue] + 1];
            if([[[arrQuestionData objectAtIndex:0] valueForKey:@"Bump Slap"] isEqualToString:@"0"]||[[[arrQuestionData objectAtIndex:0] valueForKey:@"Bump Slap"] isEqualToString:@"1"]){
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
   
    MALog(@"Comments-indexPath--%ld",(long)0);
    MAPostCommentsVC *objPComments=VCWithIdentifier(@"MAPostCommentsVC");
    objPComments.post_id=[[arrQuestionData  objectAtIndex:0] valueForKey:@"id"];
    objPComments.type=@"";
    [self.navigationController pushViewController:objPComments animated:YES];
}
-(void)btnPressed_More:(id)sender
{
    
    if([[[arrQuestionData  objectAtIndex:0] valueForKey:@"post_type"] isEqualToString:@"dashboard"]){
        _postMessage=[NSString stringWithFormat:@"%@ : %@",[[arrQuestionData objectAtIndex:0] valueForKey:@"message"],[[arrQuestionData objectAtIndex:0] valueForKey:@"share_text"]];
    }
    else{
        _postMessage= [[arrQuestionData objectAtIndex:0] valueForKey:@"message"];
    }
    _imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: [[arrQuestionData  objectAtIndex:0] valueForKey:@"post_image"]]];
    MALog(@"%@",_imageData);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AppName
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Facebook Share"];
    [actionSheet addButtonWithTitle:@"Twitter Share"];
    if([[[arrQuestionData objectAtIndex:0] valueForKey:@"user_id"] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]]]){
        _postId=[[arrQuestionData objectAtIndex:0] valueForKey:@"id"];
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
                    [self callQuestionAPI];
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
    
    MAVideoPlay * new = VCWithIdentifier(@"MAVideoPlay");
    [self.navigationController pushViewController:new animated:YES];
}

#pragma mark - open User Profile


-(IBAction)openUserProfile:(id)sender event:(id)event
{
//    NSSet *touches = [event allTouches];
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouchPosition = [touch locationInView:tblVw_Question];
    
    NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
    NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[arrQuestionData objectAtIndex:0] valueForKey:@"user_id"]];
    
    if([tmp_str_id isEqualToString:str]){
        MAProfileVC *obj_MAprofileVC = VCWithIdentifier(@"MAProfileVC");
        obj_MAprofileVC.check_push_or_tab=@"push";
        [self.navigationController pushViewController:obj_MAprofileVC animated:YES];
        
    }
    else{
        OtherUserProfileVC *obj_OtherUser = VCWithIdentifier(@"OtherUserProfileVC");
        obj_OtherUser.other_user_ID =[[arrQuestionData objectAtIndex:0] valueForKey:@"user_id"];
        [self.navigationController pushViewController:obj_OtherUser animated:YES];
    }
}

#pragma mark
#pragma mark TableView Button Action
#pragma mark
-(void)btnPressed_like_list:(id)sender
{
       MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Like";
    objList.post_id=[[arrQuestionData objectAtIndex:0] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}
-(void)btnPressed_backSlap_list:(id)sender
{
   
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Back Slap";
    objList.post_id=[[arrQuestionData objectAtIndex:0] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}

-(void)btnPressed_bumSlap_list:(id)sender
{
    
    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
    objList.listType=@"Bum Slap";
    objList.post_id=[[arrQuestionData objectAtIndex:0] valueForKey:@"id"],
    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
    [self.navigationController pushViewController:objList animated:YES];
}

@end
