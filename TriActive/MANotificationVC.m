//
//  TANotificationVC.m
//  TriActive
//
//  Created by Ketan on 05/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MANotificationVC.h"
#import "OtherUserProfileVC.h"
#import "MAProfileVC.h"
@interface MANotificationVC ()

@end

@implementation MANotificationVC

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
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Notifications"];
    self.navigationItem.leftBarButtonItem = [Utility leftbar:[UIImage imageNamed:@"sideMenu.png"] :self];
    self.navigationController.navigationBar.translucent = NO;
    arrProfileImages=[[NSMutableArray alloc]init];
     [self callNotificationAPI];
    [Utility swipeSideMenu:self];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)callNotificationAPI{
    NSLog(@"%@",ApplicationDelegate.latitude);
    NSLog(@"%@",ApplicationDelegate.longitude);
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"]
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API NotificationWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
         if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            arrProfileImages=[responseDict valueForKey:@"data"] ;
            MALog(@"result=======%lu",(unsigned long)[arrProfileImages  count]);
            MALog(@"result=======%lu",(unsigned long)[arrProfileImages  count]);
            [tblVW_notifications reloadData];
        }
        else
        {
            // [ApplicationDelegate showAlert:@"No Group Found"];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
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
    if([arrProfileImages count]){
     return [arrProfileImages  count];
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UIImageView* profileImageVw;
    //UIButton* followButton;
    UILabel* lblDesc;
    UILabel* lbltime;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if([arrProfileImages  count]){
    profileImageVw = (UIImageView *)[cell.contentView viewWithTag:101];
    if(profileImageVw)
    {
       [profileImageVw sd_setImageWithURL:[NSURL URLWithString:[[arrProfileImages  objectAtIndex:indexPath.row] valueForKey:@"profile_image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];
        profileImageVw.layer.cornerRadius=20.0;
        profileImageVw.layer.masksToBounds = YES;
    }
    
//    followButton = (UIButton *)[cell.contentView viewWithTag:103];
//    if(followButton)
//    {
//        [followButton setBackgroundImage:[UIImage imageNamed:@"follow-btn.png"] forState:UIControlStateNormal];
//    }
    
    lblDesc = (UILabel *)[cell.contentView viewWithTag:102];
    if(lblDesc)
    {
        lblDesc.text=[[arrProfileImages  objectAtIndex:indexPath.row] valueForKey:@"notification"];
    }
    lbltime = (UILabel *)[cell.contentView viewWithTag:104];
    if(lbltime)
     {
        lbltime.text=[[arrProfileImages  objectAtIndex:indexPath.row] valueForKey:@"time"];
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
    NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
    NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[arrProfileImages objectAtIndex:indexPath.row] valueForKey:@"user_id"]];
    if([tmp_str_id isEqualToString:str]){
        MAProfileVC *obj_MAprofileVC = VCWithIdentifier(@"MAProfileVC");
        obj_MAprofileVC.check_push_or_tab=@"push";
        [self.navigationController pushViewController:obj_MAprofileVC animated:YES];
        
    }
    else{
        OtherUserProfileVC *obj_OtherUser = VCWithIdentifier(@"OtherUserProfileVC");
        obj_OtherUser.other_user_ID =[[arrProfileImages objectAtIndex:indexPath.row] valueForKey:@"user_id"];
        [self.navigationController pushViewController:obj_OtherUser animated:YES];
    }
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
