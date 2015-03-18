//
//  MABlockedUserListVC.m
//  MyActive
//
//  Created by Eliza Dhamija on 03/02/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MABlockedUserListVC.h"

@interface MABlockedUserListVC ()

@end

@implementation MABlockedUserListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark Table View DataSource/Delegates
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr_blocked_user count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"blockedUserCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UIImageView *img_User = (UIImageView*)[cell.contentView viewWithTag:100];
    UILabel *lbl_Name_User = (UILabel*)[cell.contentView viewWithTag:200];
    UIButton *btn_Unblock = (UIButton*)[cell.contentView viewWithTag:300];
    [btn_Unblock addTarget:self action:@selector(unblockME:event:) forControlEvents:UIControlEventTouchUpInside];
   lbl_Name_User.text = [NSString stringWithFormat:@"%@",[self.arr_blocked_user[indexPath.row]objectForKey:@"first_name"]];
    [img_User sd_setImageWithURL:[NSURL URLWithString:[[self.arr_blocked_user objectAtIndex:indexPath.row] valueForKey:@"profile_image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];
    img_User.layer.cornerRadius =  20;//half of the width and height
    img_User.layer.masksToBounds = YES;return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(IBAction)unblockME:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbl_blocked_user];
    NSIndexPath *indexPath = [tbl_blocked_user indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"%ld",(long)indexPath.row);
    
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:[[self.arr_blocked_user objectAtIndex:indexPath.row]valueForKey:@"id"] forKey:@"block_user_id"];
    
    //**********ELIZA**********//
    
    [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"userid"];
    
    [ApplicationDelegate show_LoadingIndicator];
    [API unBlock_This_user:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            [self.arr_blocked_user removeObjectAtIndex:indexPath.row];
            
            [tbl_blocked_user deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tbl_blocked_user reloadData];
        }
    }];
}
@end
