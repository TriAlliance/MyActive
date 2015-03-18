//
//  MATrendingGrpEvtVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 20/12/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MATrendingGrpEvtVC.h"
#import "SVPullToRefresh.h"
#import "MAPostCommentsVC.h"
#import "MAUsersVC.h"
@interface MATrendingGrpEvtVC ()

@end

@implementation MATrendingGrpEvtVC


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
    paging=1;
    insert=NO;
    arrGrpEvntData = [[NSMutableArray alloc]init];
    [tblVw_GrpEvnt setAllowsSelection:YES];
    // Do any additional setup after loading the view.
    if ([_keyword isEqualToString:@"Popular Events"]) {
        _keywordSend=@"popular_events";
        _postType=@"event";
    }
    else if( [_keyword isEqualToString:@"New"]){
        _keywordSend=@"New";
        _postType=@"new";
    }
    else{
        _keywordSend=@"popular_groups";
        _postType=@"group";
    }
    self.navigationItem.titleView = [Utility lblTitleNavBar:_keyword];
    self.navigationController.navigationBar.translucent = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"activityIcons" ofType:@"plist"];
    NSDictionary *dict =  [NSDictionary dictionaryWithContentsOfFile:path];
    imgActivity = [dict objectForKey:@"ActivityImages"];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    typeof(self) weakSelf = self;
    
    // setup pull-to-refresh
    [tblVw_GrpEvnt addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [tblVw_GrpEvnt addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self callTrendingEvntGrpPostAPI];
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
    //       [tblVw_GrpEvnt triggerPullToRefresh];
}


- (void)insertRowAtTop {
    insert=NO;
    paging=1;
    [self callTrendingEvntGrpPostAPI];

}
- (void)insertRowAtBottom {
    insert=YES;
    [self callTrendingEvntGrpPostAPI];

}
-(void)callTrendingEvntGrpPostAPI
{
    if(insert == YES){
        paging++;
    }
    else
    {
        [arrGrpEvntData  removeAllObjects];
    }
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"keyword":_keywordSend,
                               @"page_number":[NSString stringWithFormat:@"%i",paging],
                               @"no_of_post":@"10"
                               };
    [ApplicationDelegate show_LoadingIndicator];
    [API userTrendingEvntGrpWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            NSMutableArray * arrPagData = [[NSMutableArray alloc]init];
            [arrPagData addObject:[responseDict valueForKey:@"data"]];
            
            for (int i = 0; i < [[responseDict valueForKey:@"data"] count];i++) {
                [arrGrpEvntData  addObject:[[arrPagData objectAtIndex:0] objectAtIndex:i]];
            }
            
            [tblVw_GrpEvnt reloadData];
        }
        else
        {
            if ([_keyword isEqualToString:@"Popular Events"]) {
                //               [ApplicationDelegate showAlert:@"You have no Events"];
            }
            else if( [_keyword isEqualToString:@"New"]){
                //                [ApplicationDelegate showAlert:@"You have no new Posts"];
            }
            else{
                //               [ApplicationDelegate showAlert:@"You have no Groups"];
            }
            
        }
        [tblVw_GrpEvnt.pullToRefreshView stopAnimating];
        [tblVw_GrpEvnt.infiniteScrollingView stopAnimating];
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark TableView DataSource/Delegate
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([arrGrpEvntData count]){
        return [arrGrpEvntData count];
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrGrpEvntData.count > 0) {
   
    if (([[[arrGrpEvntData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Public"]) && [[[arrGrpEvntData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"image"]) {
        return 367.0;
    }
    else
    {
        return 190.0;
    }
    }else
    {
        return 0;
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
    
    if([arrGrpEvntData   count] > 0){
        if ([[[arrGrpEvntData  objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Public"] && [[[arrGrpEvntData  objectAtIndex:indexPath.row] valueForKey:@"post_type"] isEqualToString:@"image"]) {
            
            static NSString *identifier = @"imgDashCell";
            
            UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
            UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list;
            cellImageDash = (MAImgDashCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            UIImageView *imgVw_Uploaded;
            UIImageView *imgVw_Activity;
            UIImageView *imgVw_Post;
            
            if(cellImageDash ==nil)
            {
                [[NSBundle mainBundle]loadNibNamed:@"MAImgDashCell" owner:self options:nil];
            }
            imgVw_Activity=(UIImageView *)[cellImageDash.contentView viewWithTag:210];
            if([_keywordSend isEqualToString:@"popular_groups"]){
                [imgVw_Activity setHidden:YES];
            }
            else if([_keywordSend isEqualToString:@"New"] &&[[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"po_type"] isEqualToString:@"group"] ){
                [imgVw_Activity setHidden:YES];
            }
            else{
                [imgVw_Activity setHidden:NO];
                if(imgVw_Activity){
                    if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
                        NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]];
                        if (index != NSNotFound) {
                            imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:index ] valueForKey:@"img"]];
                        }
                        
                    }
                }
            }
            imgVw_Uploaded=(UIImageView *)[cellImageDash.contentView viewWithTag:205];
            [imgVw_Uploaded.layer setBorderColor: [[UIColor whiteColor] CGColor]];
            imgVw_Uploaded.layer.borderWidth = 1.0;
            imgVw_Uploaded.layer.cornerRadius =  20;//half of the width and height
            imgVw_Uploaded.layer.masksToBounds = YES;
            [imgVw_Uploaded.layer setBorderWidth: 3.0];
            if(imgVw_Uploaded){
                [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            imgVw_Post=(UIImageView *)[cellImageDash.contentView viewWithTag:211];
            if(imgVw_Post){
                [imgVw_Post sd_setImageWithURL:[NSURL URLWithString:[[arrGrpEvntData  objectAtIndex:indexPath.row] valueForKey:@"post_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            lbl_Caption = (UILabel *)[cellImageDash.contentView viewWithTag:207];
            if(lbl_Caption){
                lbl_Caption.text=[NSString stringWithFormat:@"%@ : %@",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"name"],[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"description"]];
            }
            lbl_like = (UILabel *)[cellImageDash.contentView viewWithTag:201];
            if(lbl_like){
                if([[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follow"] isEqualToString:@"0"]){
                    lbl_like.text= [NSString stringWithFormat:@"%@  Follower",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follow"]];
                }
                else{
                    lbl_like.text= [NSString stringWithFormat:@"%@  Followers",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follow"]];
                }
            }
            btnLike = (UIButton *)[cellImageDash.contentView viewWithTag:101];
            if (btnLike) {
                [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
            }
            btn_like_user = (UIButton *)[cellImageDash.contentView viewWithTag:110];
//            if (btn_like_user) {
//                [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
//            }
            lbl_backSlap = (UILabel *)[cellImageDash.contentView viewWithTag:202];
            if(lbl_backSlap){
                lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
            }
            btnBackSlap_list = (UIButton *)[cellImageDash.contentView viewWithTag:220];
//            if (btnBackSlap_list) {
//                [btnBackSlap_list addTarget:self action:@selector(btnPressed_backSlap_list:) forControlEvents:UIControlEventTouchUpInside];
//            }
            btnBackSlap = (UIButton *)[cellImageDash.contentView viewWithTag:102];
            if (btnBackSlap) {
                [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
            }
            btnBumSlap = (UIButton *)[cellImageDash.contentView viewWithTag:103];
            if (btnBumSlap) {
                [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
            }
            btnBumSlap_list = (UIButton *)[cellImageDash.contentView viewWithTag:330];
//            if (btnBumSlap_list) {
//                [btnBumSlap_list addTarget:self action:@selector(btnPressed_bumSlap_list:) forControlEvents:UIControlEventTouchUpInside];
//            }
            lbl_bumSlap = (UILabel *)[cellImageDash.contentView viewWithTag:203];
            if(lbl_bumSlap){
                lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
            }
            btnBumSlap = (UIButton *)[cellImageDash.contentView viewWithTag:103];
            if (btnBumSlap) {
                [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
            }
            lbl_Comments = (UILabel *)[cellImageDash.contentView viewWithTag:204];
            if(lbl_Comments){
                lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Comments"]];
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
                lbl_name.text=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"user_first_name"];
            }
            lbl_time = (UILabel *)[cellImageDash.contentView viewWithTag:209];
            if(lbl_time){
                lbl_time.text=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"date"];
            }
            
            return cellImageDash;
        }
        else
        {
            static NSString *identifier = @"MAStatusCell";
            UIButton *btnLike, *btnBackSlap, *btnBumSlap, *btnComments, *btnMore;
        //    ,*btn_like_user,*btnBackSlap_list,*btnBumSlap_list
            UILabel *lbl_like, *lbl_backSlap, *lbl_bumSlap, *lbl_Comments,*lbl_Caption,*lbl_name,*lbl_time;
            UIImageView *imgVw_Uploaded;
            UIImageView *imgVw_Activity;
            cellStatus = (MAStatusCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            
            if(cellStatus ==nil)
            {
                [[NSBundle mainBundle]loadNibNamed:@"MAStatusCell" owner:self options:nil];
            }
            imgVw_Activity=(UIImageView *)[cellStatus.contentView viewWithTag:210];
            if([[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"po_type"] isEqualToString:@"user"]){
                [imgVw_Activity setHidden:YES];
            }
            else{
                if(imgVw_Activity){
                    if ([[imgActivity valueForKey:@"txt"] containsObject: [[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
                        
                        NSUInteger index = [[imgActivity valueForKey:@"txt"] indexOfObject:[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"activity_name"]];
                        if (index != NSNotFound) {
                            imgVw_Activity.image =   [UIImage imageNamed:[[imgActivity objectAtIndex:index ] valueForKey:@"img"]];
                        }
                        
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
                [imgVw_Uploaded sd_setImageWithURL:[NSURL URLWithString:[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"user_profile_image"]] placeholderImage:HomePlaceholder options:SDWebImageRetryFailed];
            }
            lbl_Caption = (UILabel *)[cellStatus.contentView viewWithTag:207];
            if(lbl_Caption){
                if([[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"po_type"] isEqualToString:@"user"]){
                    lbl_Caption.text=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"description"];
                    
                }
                else{
                    lbl_Caption.text=[NSString stringWithFormat:@"%@ : %@",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"name"],[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"description"]];
                }
            }
            lbl_like = (UILabel *)[cellStatus.contentView viewWithTag:201];
            if(lbl_like){
                if([[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follow"] isEqualToString:@"0"]){
                    lbl_like.text= [NSString stringWithFormat:@"%@  Follower",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follow"]];
                }
                else{
                    lbl_like.text= [NSString stringWithFormat:@"%@  Followers",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follow"]];
                }        }
            btnLike = (UIButton *)[cellStatus.contentView viewWithTag:101];
            if (btnLike) {
                [btnLike addTarget:self action:@selector(btnPressed_like:) forControlEvents:UIControlEventTouchUpInside];
            }
//            btn_like_user = (UIButton *)[cellStatus.contentView viewWithTag:110];
//            if (btn_like_user) {
//                [btn_like_user addTarget:self action:@selector(btnPressed_like_list:) forControlEvents:UIControlEventTouchUpInside];
//            }
            lbl_backSlap = (UILabel *)[cellStatus.contentView viewWithTag:202];
            if(lbl_backSlap){
                lbl_backSlap.text=[NSString stringWithFormat:@"%@  Back Slap",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"]];
            }
            btnBackSlap = (UIButton *)[cellStatus.contentView viewWithTag:102];
            if (btnBackSlap) {
                [btnBackSlap addTarget:self action:@selector(btnPressed_backSlap:) forControlEvents:UIControlEventTouchUpInside];
            }
         //   btnBackSlap_list = (UIButton *)[cellStatus.contentView viewWithTag:220];
//            if (btnBackSlap_list) {
//                [btnBackSlap_list addTarget:self action:@selector(btnPressed_backSlap_list:) forControlEvents:UIControlEventTouchUpInside];
//            }
            lbl_bumSlap = (UILabel *)[cellStatus.contentView viewWithTag:203];
            if(lbl_bumSlap){
                lbl_bumSlap.text=[NSString stringWithFormat:@"%@  Bum Slap",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"]];
            }
            btnBumSlap = (UIButton *)[cellStatus.contentView viewWithTag:103];
            if (btnBumSlap) {
                [btnBumSlap addTarget:self action:@selector(btnPressed_bumSlap:) forControlEvents:UIControlEventTouchUpInside];
            }
//            btnBumSlap_list = (UIButton *)[cellStatus.contentView viewWithTag:330];
//            if (btnBumSlap_list) {
//                [btnBumSlap_list addTarget:self action:@selector(btnPressed_bumSlap_list:) forControlEvents:UIControlEventTouchUpInside];
//            }
            lbl_Comments = (UILabel *)[cellStatus.contentView viewWithTag:204];
            if(lbl_Comments){
                lbl_Comments.text=[NSString stringWithFormat:@"%@  Comments",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Comments"]];
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
                lbl_name.text=[NSString stringWithFormat:@"%@ ",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"user_first_name"]];
            }
            lbl_time = (UILabel *)[cellStatus.contentView viewWithTag:209];
            if(lbl_time){
                lbl_time.text=[NSString stringWithFormat:@"%@ ",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"date"]];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
   
    if ([_postType isEqualToString:@"event"]) {
        MAEventDescVC * objEventDescVC=VCWithIdentifier(@"MAEventDescVC");
        objEventDescVC.eventId=[[arrGrpEvntData objectAtIndex:indexPath.row ]valueForKey:@"id"];
        [self.navigationController pushViewController:objEventDescVC animated:YES];
    }
    else  if ([_postType isEqualToString:@"group"]) {
    MAGroupDescVC * objgrpDescVC=VCWithIdentifier(@"MAGroupDescVC");
    objgrpDescVC.groupId=[[arrGrpEvntData objectAtIndex:indexPath.row ]valueForKey:@"id"];
    [self.navigationController pushViewController:objgrpDescVC animated:YES];
    }
    else{
        
    }
 
    
}
#pragma mark
#pragma mark TableView Button Action
#pragma mark
-(void)btnPressed_like:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_GrpEvnt];
    NSIndexPath *indexPath = [tblVw_GrpEvnt indexPathForRowAtPoint:buttonPosition];
    MALog(@"like-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo;
    if([_postType isEqualToString:@"new"]){
        if([[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"po_type"] isEqualToString:@"user"]){
            userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                         @"id":[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
                         @"type":@"",
                         @"post_type":[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"po_type"]                         };
            
        }
        else{
            userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                         @"id":[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
                         @"type":@"follow",
                         @"post_type":[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"po_type"]
                         };
        }
    }
    else{
        userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                     @"id":[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
                     @"type":@"follow",
                     @"post_type":_postType
                     };
    }
    [ApplicationDelegate show_LoadingIndicator];
    [API EventGroupFollowWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tblVw_GrpEvnt cellForRowAtIndexPath:indexPath];
            
            UILabel *lbl_like = (UILabel *)[cell viewWithTag:201];
            NSString *like=[NSString stringWithFormat:@"%d",[[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follow"] intValue] + 1];
            if([[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follow"] isEqualToString:@"0"]||[[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Follower"] isEqualToString:@"1"]){
                lbl_like.text= [NSString stringWithFormat:@"%@  Follower",like];
                NSLog(@"%@",lbl_like.text);
                
            }
            else{
                lbl_like.text=[NSString stringWithFormat:@"%@  Followers",like];
            }
            
            //[tblVw_GrpEvnt reloadData];
            
        }
        else if([[responseDict valueForKey:@"result"] intValue] == 0)
        {
            if([_postType isEqualToString:@"event"]){
                [ApplicationDelegate showAlert:@"You have already follow this event"];
            }
              else if([_postType isEqualToString:@"group"]){
            [ApplicationDelegate showAlert:@"You have already follow this group"];
              }
            else
                  {
                   [ApplicationDelegate showAlert:@"You have already follow this user"];
                  }
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_GrpEvnt];
    NSIndexPath *indexPath = [tblVw_GrpEvnt indexPathForRowAtPoint:buttonPosition];
    MALog(@"backSlap-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo;
    if([_postType isEqualToString:@"new"]){
        userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                     @"id":[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
                     @"type":@"Back Slap",
                     @"post_type":[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"po_type"]
                     };
    }
    else{
        userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                     @"id":[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
                     @"type":@"Back Slap",
                     @"post_type":_postType
                     };
        
    }
    [ApplicationDelegate show_LoadingIndicator];
    [API EventGroupFollowWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tblVw_GrpEvnt cellForRowAtIndexPath:indexPath];
            UILabel *lbl_backSlap = (UILabel *)[cell viewWithTag:202];
            NSString *backSlap=[NSString stringWithFormat:@"%d",[[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] intValue] + 1];
            if([[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] isEqualToString:@"0"]||[[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Back Slap"] isEqualToString:@"1"]){
                lbl_backSlap.text= [NSString stringWithFormat:@"%@ Back Slap",backSlap];
                NSLog(@"%@",lbl_backSlap.text);
            }
            else{
                lbl_backSlap.text=[NSString stringWithFormat:@"%@ Back Slap",backSlap];
            }
        }
        else if([[responseDict valueForKey:@"result"] intValue] == 0)
        {
            
            if([_postType isEqualToString:@"event"]){
                [ApplicationDelegate showAlert:@"You have already Back slap this event"];
            }
            else if([_postType isEqualToString:@"group"]){
                [ApplicationDelegate showAlert:@"You have already Back slap this group"];
            }
            else
            {
                [ApplicationDelegate showAlert:@"You have already Back slap this user"];
            }
            
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_GrpEvnt];
    NSIndexPath *indexPath = [tblVw_GrpEvnt indexPathForRowAtPoint:buttonPosition];
    MALog(@"bumSlap-indexPath--%ld",(long)indexPath.row);
    NSDictionary* userInfo;
    if([_postType isEqualToString:@"new"]){
        userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                     @"id":[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
                     @"type":@"Bump Slap",                   @"post_type":[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"po_type"]
                     };
    }
    else{
        userInfo = @{@"follower_id":[UserDefaults valueForKey:@"user_id"],
                     @"id":[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
                     @"type":@"Bump Slap",
                     @"post_type":_postType
                     };
    }
    [ApplicationDelegate show_LoadingIndicator];
    [API EventGroupFollowWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            UITableViewCell *cell = [tblVw_GrpEvnt cellForRowAtIndexPath:indexPath];
            UILabel *lbl_bumSlap = (UILabel *)[cell viewWithTag:203];
            NSString *bumSlap=[NSString stringWithFormat:@"%d",[[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] intValue] + 1];
            if([[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] isEqualToString:@"0"]||[[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"Bump Slap"] isEqualToString:@"1"]){
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
           
            if([_postType isEqualToString:@"event"]){
                [ApplicationDelegate showAlert:@"You have already Bum Slap this event"];
            }
            else if([_postType isEqualToString:@"group"]){
                [ApplicationDelegate showAlert:@"You have already Bum Slap this group"];
            }
            else
            {
                [ApplicationDelegate showAlert:@"You have already Bum Slap this user"];
            }
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_GrpEvnt];
    NSIndexPath *indexPath = [tblVw_GrpEvnt indexPathForRowAtPoint:buttonPosition];
    MALog(@"Comments-indexPath--%ld",(long)indexPath.row);
    MAPostCommentsVC *objPComments=VCWithIdentifier(@"MAPostCommentsVC");
    objPComments.post_id=[[arrGrpEvntData  objectAtIndex:indexPath.row] valueForKey:@"id"];
    if( [_keyword isEqualToString:@"New"]){
        objPComments.type=[[arrGrpEvntData  objectAtIndex:indexPath.row] valueForKey:@"po_type"];
    }
    else{
        objPComments.type=_postType;
    }
    [self.navigationController pushViewController:objPComments animated:YES];
}
-(void)btnPressed_More:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_GrpEvnt];
    NSIndexPath *indexPath = [tblVw_GrpEvnt indexPathForRowAtPoint:buttonPosition];
    MALog(@"More-indexPath--%ld",(long)indexPath.row);
    if([[[arrGrpEvntData  objectAtIndex:indexPath.row]valueForKey:@"po_type"] isEqualToString:@"user"]){
        _postMessage=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"description"];
        
    }
    else{
        _postMessage=[NSString stringWithFormat:@"%@ : %@",[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"name"],[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"description"]];
    }
    
    
    _imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: [[arrGrpEvntData  objectAtIndex:indexPath.row] valueForKey:@"post_image"]]];
    MALog(@"%@",_imageData);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AppName delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Facebook Share"];
    [actionSheet addButtonWithTitle:@"Twitter Share"];
    if([[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"evnt_creator_id"] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]]]){
        _postId=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"];
        MALog(@"_postId=%@",_postId);
        [actionSheet addButtonWithTitle:@"Delete Post"];
    }
    else if([[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"grp_creator_id"] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]]]){
        _postId=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"];
        MALog(@"_postId=%@",_postId);
        [actionSheet addButtonWithTitle:@"Delete Post"];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
}
#pragma mark
#pragma mark UIActionSheet Methods
#pragma mark
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
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
                        //[ApplicationDelegate showAlert:@"Posted successfully on twitter"];
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
            if(_postId){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Are you sure you want to delete this." delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
            [alert show];
            }
            
        }
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        if([_postType isEqualToString:@"group"]){
        {
            NSDictionary* userInfo = @{
                                       @"group_id":_postId,
                                       };
            [ApplicationDelegate show_LoadingIndicator];
            [API DeleteGroupWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                NSLog(@"responseDict--%@",responseDict);
                if([[responseDict valueForKey:@"result"] intValue] == 1)
                {
                    [self callTrendingEvntGrpPostAPI];
                    [ApplicationDelegate showAlert:@"Group deleted successfully."];
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
        else  if([_postType isEqualToString:@"event"]){
            NSDictionary* userInfo = @{
                                       @"event_id":_postId,
                                       };
            [ApplicationDelegate show_LoadingIndicator];
            [API DeleteEventWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                NSLog(@"responseDict--%@",responseDict);
                if([[responseDict valueForKey:@"result"] intValue] == 1)
                {
                    [self callTrendingEvntGrpPostAPI];
                    [ApplicationDelegate showAlert:@"Event deleted successfully."];
                }else
                {
                    [ApplicationDelegate showAlert:ErrorStr];
                }
                if ([ApplicationDelegate isHudShown]) {
                    [ApplicationDelegate hide_LoadingIndicator];
                }
            }];
        }
        else
            {
                
            }
    }
}
#pragma mark
#pragma mark TableView Button Action
#pragma mark
//-(void)btnPressed_like_list:(id)sender
//{
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_GrpEvnt];
//    NSIndexPath *indexPath = [tblVw_GrpEvnt indexPathForRowAtPoint:buttonPosition];
//    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
//    objList.listType=@"Follow";
//    objList.trendingType=_postType;
//    objList.post_id=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
//    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
//    [self.navigationController pushViewController:objList animated:YES];
//}
//-(void)btnPressed_backSlap_list:(id)sender
//{
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_GrpEvnt];
//    NSIndexPath *indexPath = [tblVw_GrpEvnt indexPathForRowAtPoint:buttonPosition];
//    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
//    objList.listType=@"Back Slap";
//    objList.trendingType=_postType;
//    objList.post_id=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
//    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
//    [self.navigationController pushViewController:objList animated:YES];
//}
//
//-(void)btnPressed_bumSlap_list:(id)sender
//{
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblVw_GrpEvnt];
//    NSIndexPath *indexPath = [tblVw_GrpEvnt indexPathForRowAtPoint:buttonPosition];
//    MAUsersVC *objList=VCWithIdentifier(@"MAUsersVC");
//    objList.listType=@"Bum Slap";
//    objList.trendingType=_postType;
//    objList.post_id=[[arrGrpEvntData objectAtIndex:indexPath.row] valueForKey:@"id"],
//    objList.my_user_id = [UserDefaults valueForKey:@"user_id"];
//    [self.navigationController pushViewController:objList animated:YES];
//}

@end
