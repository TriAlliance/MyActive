//
//  MAUsersVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 17/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAUsersVC.h"

@interface MAUsersVC ()

@end

@implementation MAUsersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Utility lblTitleNavBar:_listType];
    NSLog(@"%@",_listType);
     arrList=[[NSMutableArray alloc]init];
    if([_trendingType isEqualToString:@"event"]||[_trendingType isEqualToString:@"new"]||
       [_trendingType isEqualToString:@"group"]){
       
        [self callTrendingUserListAPI];
        
    }
    else if([_listType isEqualToString:@"Like"] || [_listType isEqualToString:@"Back Slap"]|| [_listType isEqualToString:@"Bum Slap"]){
         [self callListAPI];
    }
    else{
          [self callUserListAPI];
        }
   
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)callTrendingUserListAPI{
   
   NSDictionary* userInfo = @{
                               @"id":_post_id,
                               @"type":_listType,
                               @"info_type":_trendingType
                               };
    [ApplicationDelegate show_LoadingIndicator];
    [API TendingListForAllWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            if([[responseDict valueForKey:@"data"] valueForKey:_listType]  != nil){
                arrList=[responseDict valueForKey:@"data"] ;
                NSLog(@"arrlist----%@",arrList);
                [_tblView_list reloadData];
            }
        }
        
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}
-(void)callListAPI{
NSDictionary* userInfo = @{
                           @"post_id":_post_id,
                           @"type":_listType,
                           @"user_id":[UserDefaults valueForKey:@"user_id"]
                           };
[ApplicationDelegate show_LoadingIndicator];
[API HomeListForUserWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
    NSLog(@"responseDict--%@",responseDict);
    if([[responseDict valueForKey:@"result"] intValue] == 1)
    {
        if([[responseDict valueForKey:@"data"] valueForKey:_listType]  != nil){
            arrList=[responseDict valueForKey:@"data"] ;
            NSLog(@"arrlist----%@",arrList);
            [_tblView_list reloadData];
        }
    }
    
    if ([ApplicationDelegate isHudShown]) {
        [ApplicationDelegate hide_LoadingIndicator];
    }
}];
}
-(void)callUserListAPI{
    
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setValue:_listType forKey:@"type"];
    if([self.my_Profile_or_other isEqualToString:@"myOwnProfile"]){
        [userInfo setValue:@"" forKey:@"users_friend_id"];
        
    }else{
        [userInfo setValue:self.my_user_id forKey:@"users_friend_id"];
    }
        [ApplicationDelegate show_LoadingIndicator];
        [API listUsersWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            if([[responseDict valueForKey:@"result"] intValue] == 1)
            {
                if([[responseDict valueForKey:@"data"] valueForKey:_listType]  != nil){
                    arrList=[[responseDict valueForKey:@"data"] valueForKey:_listType];
                    NSLog(@"arrlist----%@",arrList);
                    [_tblView_list reloadData];
                }
            }
            
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
}
#pragma mark Table View DataSource/Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [arrList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellUsersProfile";

    UILabel* txtUser;
    UILabel* txtCity;
    UIButton *btn_follow_unfollow;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
     UIImageView *profileImageVw = (UIImageView *)[cell.contentView  viewWithTag:301];
    
    txtUser = (UILabel *)[cell.contentView viewWithTag:302];
    txtCity = (UILabel *)[cell.contentView viewWithTag:303];
    btn_follow_unfollow = (UIButton *)[cell.contentView viewWithTag:304];
    [btn_follow_unfollow addTarget:self action:@selector(follow_ME:event:) forControlEvents:UIControlEventTouchUpInside];
    //[btn_follow_unfollow setHidden:YES];
    

    
    if([_listType isEqualToString:@"Events"]){

        [profileImageVw sd_setImageWithURL:[NSURL URLWithString:[[arrList objectAtIndex:indexPath.row] valueForKey:@"image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];
       
        profileImageVw.layer.cornerRadius =  20;//half of the width and height
        profileImageVw.layer.masksToBounds = YES;
        [btn_follow_unfollow setHidden:YES];
        if(txtUser)
        {
            txtUser.text=[[arrList objectAtIndex:indexPath.row] valueForKey:@"event_name"];
        }
        if(txtCity)
        {
            txtCity.text=[[arrList objectAtIndex:indexPath.row] valueForKey:@"activity_name"];
        }
 }
  else  if([_listType isEqualToString:@"Groups"]){

        [profileImageVw sd_setImageWithURL:[NSURL URLWithString:[[arrList objectAtIndex:indexPath.row] valueForKey:@"image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];
        
        profileImageVw.layer.cornerRadius =  20;//half of the width and height
        profileImageVw.layer.masksToBounds = YES;
      //[btn_follow_unfollow setHidden:YES];
        if(txtUser)
        {
            txtUser.text=[[arrList objectAtIndex:indexPath.row] valueForKey:@"name"];
        }
        if(txtCity)
        {
            txtCity.text=[[arrList objectAtIndex:indexPath.row] valueForKey:@"location"];
        }
    }
  
  else {

      [profileImageVw sd_setImageWithURL:[NSURL URLWithString:[[arrList objectAtIndex:indexPath.row] valueForKey:@"profile_image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];
        profileImageVw.layer.cornerRadius =  20;//half of the width and height
        profileImageVw.layer.masksToBounds = YES;
    if(txtUser)
    {
       txtUser.text=[[arrList objectAtIndex:indexPath.row] valueForKey:@"first_name"];
    }
   if(txtCity)
    {
        txtCity.text=[[arrList objectAtIndex:indexPath.row] valueForKey:@"city"];
    }
      
      NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
      NSString *tmp_str_id;
      if([_listType isEqualToString:@"Like"] || [_listType isEqualToString:@"Back Slap"]|| [_listType isEqualToString:@"Bum Slap"]){
          tmp_str_id =[NSString stringWithFormat:@"%@",[[arrList objectAtIndex:indexPath.row] valueForKey:@"user_id"]];
       }
      else{
          tmp_str_id =[NSString stringWithFormat:@"%@",[[arrList objectAtIndex:indexPath.row] valueForKey:@"id"]];
      }
     
      if([tmp_str_id isEqualToString:str] ){
          [btn_follow_unfollow setHidden:YES];
          
      }
      else if([[[arrList objectAtIndex:indexPath.row] valueForKey:@"mutual_friend"] intValue]==1 ){
          [btn_follow_unfollow setBackgroundImage:[UIImage imageNamed:@"check_blue.png"] forState:UIControlStateNormal];
      }
      else{
          [btn_follow_unfollow setBackgroundImage:[UIImage imageNamed:@"follow-btns.png"] forState:UIControlStateNormal];
      }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([_listType isEqualToString:@"Groups"]){
        MAGroupDescVC *objGrp=VCWithIdentifier(@"MAGroupDescVC");
        objGrp.groupId=[[arrList objectAtIndex:indexPath.row] valueForKey:@"id"];
        NSLog(@"objGrp.groupId%@",objGrp.groupId);
       [self.navigationController pushViewController:objGrp animated:YES];
    }
    else  if([_listType isEqualToString:@"Events"]){
        MAEventDescVC *objEvent=VCWithIdentifier(@"MAEventDescVC");
        objEvent.eventId=[[arrList objectAtIndex:indexPath.row] valueForKey:@"id"];
        [self.navigationController pushViewController:objEvent animated:YES];
    }
    else if([_trendingType isEqualToString:@"event"]||[_trendingType isEqualToString:@"new"]||
            [_trendingType isEqualToString:@"group"]){
        
        NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
        NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[arrList objectAtIndex:indexPath.row] valueForKey:@"user_id"]];
        if([tmp_str_id isEqualToString:str]){
            MAProfileVC *obj_MAprofileVC = VCWithIdentifier(@"MAProfileVC");
            obj_MAprofileVC.check_push_or_tab=@"push";
            [self.navigationController pushViewController:obj_MAprofileVC animated:YES];
            
        }
        else{
            OtherUserProfileVC *obj_OtherUser = VCWithIdentifier(@"OtherUserProfileVC");
            obj_OtherUser.other_user_ID =[[arrList objectAtIndex:indexPath.row] valueForKey:@"user_id"];
            [self.navigationController pushViewController:obj_OtherUser animated:YES];
        }
    }
        else  if([_listType isEqualToString:@"Like"] || [_listType isEqualToString:@"Back Slap"]|| [_listType isEqualToString:@"Bum Slap"]| [_listType isEqualToString:@"Follow"]){
        
        NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
        NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[arrList objectAtIndex:indexPath.row] valueForKey:@"user_id"]];
        if([tmp_str_id isEqualToString:str]){
            MAProfileVC *obj_MAprofileVC = VCWithIdentifier(@"MAProfileVC");
            obj_MAprofileVC.check_push_or_tab=@"push";
            [self.navigationController pushViewController:obj_MAprofileVC animated:YES];
            
        }
        else{
            OtherUserProfileVC *obj_OtherUser = VCWithIdentifier(@"OtherUserProfileVC");
            obj_OtherUser.other_user_ID =[[arrList objectAtIndex:indexPath.row] valueForKey:@"user_id"];
            [self.navigationController pushViewController:obj_OtherUser animated:YES];
        }
      }
    else{
       
            NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
                    NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[arrList objectAtIndex:indexPath.row] valueForKey:@"id"]];
             if([tmp_str_id isEqualToString:str]){
                MAProfileVC *obj_MAprofileVC = VCWithIdentifier(@"MAProfileVC");
                obj_MAprofileVC.check_push_or_tab=@"push";
                [self.navigationController pushViewController:obj_MAprofileVC animated:YES];
                
            }
            else{
                OtherUserProfileVC *obj_OtherUser = VCWithIdentifier(@"OtherUserProfileVC");
                obj_OtherUser.other_user_ID =[[arrList objectAtIndex:indexPath.row] valueForKey:@"id"];
                obj_OtherUser.str_follow_or_unfollow = [NSString stringWithFormat:@"%@",[[arrList objectAtIndex:indexPath.row] valueForKey:@"mutual_friend"]];

                [self.navigationController pushViewController:obj_OtherUser animated:YES];
            }
        }
    }

-(IBAction)follow_ME:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tblView_list];
    NSIndexPath *indexPath = [_tblView_list indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"%ld",(long)indexPath.row);
    NSString *getId;
    if(![[arrList objectAtIndex:indexPath.row] valueForKey:@"user_id"]){
        getId= [[arrList objectAtIndex:indexPath.row] valueForKey:@"id"];
    }
    else
    {
        getId= [[arrList objectAtIndex:indexPath.row] valueForKey:@"user_id"];

    }
    NSString *mutual_friend=[NSString stringWithFormat:@"%@",[[arrList objectAtIndex:indexPath.row] valueForKey:@"mutual_friend"]];
    
    if([mutual_friend isEqualToString:@"0"] ||  [_mutual isEqualToString:@"follow"])
    {
        [self callFollowAPI:getId index:indexPath];
    }
    else
    {
        
        [self callUnFollowAPI:getId index:indexPath];
    }

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
            UITableViewCell *cell = [_tblView_list cellForRowAtIndexPath:myIndex];
            UIButton *btn_follow_unfollow = (UIButton*)[cell.contentView viewWithTag:304];
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

            UITableViewCell *cell = [_tblView_list cellForRowAtIndexPath:myIndex];
            UIButton *btn_follow_unfollow = (UIButton*)[cell.contentView viewWithTag:304];
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


@end
