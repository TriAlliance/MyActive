//
//  MAProfileSettingVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 19/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAProfileSettingVC.h"
#import "Constant.h"
#import "MAAddFriendVC.h"
#import "MAEditProfileVC.h"
#import "MAPushSettingsVC.h"
#import "MABlockedUserListVC.h"
#import "MAShareSettingVC.h"

@interface MAProfileSettingVC ()

@end

@implementation MAProfileSettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark
#pragma mark View lifecycle
#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Profile Settings"];
    self.navigationController.navigationBar.translucent = NO;
   
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Signout" style:UIBarButtonItemStyleBordered target:self action:@selector(signOut)];
    [Utility swipeSideMenu:self];
    //Initialize the dataArray
    dataArray = [[NSMutableArray alloc] init];
    
    //First section data
    NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Invite Friends", @"Share Settings", nil];
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
    [dataArray addObject:firstItemsArrayDict];
    
    //Second section data
    NSArray *secondItemsArray = [[NSArray alloc] initWithObjects:@"Push Notifications", @"Email Notifications", nil];
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:secondItemsArray forKey:@"data"];
    [dataArray addObject:secondItemsArrayDict];

    
    //fourth section data
//    NSArray *fourthItemsArray = [[NSArray alloc] initWithObjects:@"Clear Video Cache,",@"Auto Play Videos", nil];
//    NSDictionary *fourthItemsArrayDict = [NSDictionary dictionaryWithObject:fourthItemsArray forKey:@"data"];
//    [dataArray addObject:fourthItemsArrayDict];
    
    //fifth section data
    NSArray *fifthItemsArray = [[NSArray alloc] initWithObjects:@"Block User",@"Edit Profile info" ,nil];
    NSDictionary *fifthItemsArrayDict = [NSDictionary dictionaryWithObject:fifthItemsArray forKey:@"data"];
    [dataArray addObject:fifthItemsArrayDict];
    NSArray *sixthItemsArray = [[NSArray alloc] initWithObjects:@"Help", @"Term of Use", @"Privacy Policy", nil];
    NSDictionary *sixthItemsArrayDict = [NSDictionary dictionaryWithObject:sixthItemsArray forKey:@"data"];
    [dataArray addObject:sixthItemsArrayDict];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
}


-(void)signOut
{
    [self callLogoutAPI];
}

-(void)callLogoutAPI
{
    NSDictionary* userInfo = @{
                               @"userid":[UserDefaults valueForKey:@"user_id"]
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API logoutWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
            
            [revealController revealToggle:self];
            
            [UserDefaults removeObjectForKey:@"user_id"];
            [UserDefaults removeObjectForKey:@"userDetails"];
            
            self.tabBarController.hidesBottomBarWhenPushed = YES;
            [ApplicationDelegate mainVC];
            
        }else
        {
            [ApplicationDelegate showAlert:ErrorStr];
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
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:244.0/255.0 alpha:1.0f]];
    
    return headerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"profileSettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
   // NSLog(@"%@", cellValue);
    cell.textLabel.text = cellValue;
    if([cellValue isEqualToString:@"Auto Play Videos"]){
        UISwitch *toggleSwitch = [[UISwitch alloc] init];
        cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
        [cell.accessoryView addSubview:toggleSwitch];
        [toggleSwitch setOnTintColor:[UIColor colorWithRed:0.0/255.0 green:97.0/255.0 blue:185.0/255.0 alpha:1.0f]];
        
    }
    
    cell.textLabel.font = ROBOTO_REGULAR(17.0);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedCell = nil;
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    selectedCell = [array objectAtIndex:indexPath.row];
    
    NSLog(@"%@", selectedCell);
    if([selectedCell isEqualToString:@"Invite Friends"])
    {
        MAAddFriendVC *objList=VCWithIdentifier(@"MAAddFriendVC");
        objList.settingPg=@"settingPage";
        [self.navigationController pushViewController:objList animated:YES];
    }
    if([selectedCell isEqualToString:@"Share Settings"])
    {
        MAShareSettingVC *objList=VCWithIdentifier(@"MAShareSettingVC");
       [self.navigationController pushViewController:objList animated:YES];
    }
    if([selectedCell isEqualToString:@"Edit Profile info"])
    {
        MAEditProfileVC *objList=VCWithIdentifier(@"MAEditProfileVC");
        objList.settingPg=@"settingPage";
        [self.navigationController pushViewController:objList animated:YES];
    }
    
    if([selectedCell isEqualToString:@"Push Notifications"])
    {
        [ApplicationDelegate show_LoadingIndicator];
        
        
        [API editPushNotificatio:^(NSDictionary *response){
            NSLog(@"responseDict--%@",response);
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
            if([[response valueForKey:@"result"] intValue] == 1){
                MAPushSettingsVC *Obj_MAPush = VCWithIdentifier(@"MAPushSettingsVC");
                Obj_MAPush.dict_Notification_check = [response objectForKey:@"data"];
                Obj_MAPush.optionSelected = @"push";
                [self.navigationController pushViewController:Obj_MAPush animated:YES];
            }
            
        }];
    }
    if([selectedCell isEqualToString:@"Email Notifications"])
    {
        [ApplicationDelegate show_LoadingIndicator];
        
        [API editEmailNotificatio:^(NSDictionary *response){
            NSLog(@"responseDict--%@",response);
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
            if([[response valueForKey:@"result"] intValue] == 1){
                
                MAPushSettingsVC *Obj_MAPush = VCWithIdentifier(@"MAPushSettingsVC");
                Obj_MAPush.dict_Notification_check = [response objectForKey:@"data"];
                Obj_MAPush.optionSelected = @"email";
                [self.navigationController pushViewController:Obj_MAPush animated:YES];
            }
            
            
        }];
    }
    if([selectedCell isEqualToString:@"Block User"])
    {
        [ApplicationDelegate show_LoadingIndicator];
        [API all_blocked_userList:^(NSDictionary *response){
            NSLog(@"responseDict--%@",response);
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
            
            if([[response valueForKey:@"result"] intValue] == 1){
                
                MABlockedUserListVC *Obj_MABlockUser = VCWithIdentifier(@"MABlockedUserListVC");
                Obj_MABlockUser.arr_blocked_user = [[NSMutableArray alloc]init];
                
                for (int i=0; i<[[[response objectForKey:@"data"]objectForKey:@"post_data"] count];i++) {
                    [Obj_MABlockUser.arr_blocked_user addObject:[[response objectForKey:@"data"]objectForKey:@"post_data"][i]];
                }
                
                //Obj_MABlockUser.arr_blocked_user = [[response objectForKey:@"data"]objectForKey:@"post_data"];
                [self.navigationController pushViewController:Obj_MABlockUser animated:YES];
            }
          
        }];
    }
    if([selectedCell isEqualToString:@"Help"])
    {
        [Utility openMiniBrowser:self navController:self.navigationController pageOption:k_HELP_URL];
        
    }
    if([selectedCell isEqualToString:@"Term of Use"])
    {
        [Utility openMiniBrowser:self navController:self.navigationController pageOption:k_TERMS_OF_USE_URL];
        
    }
    if([selectedCell isEqualToString:@"Privacy Policy"])
    {
        [Utility openMiniBrowser:self navController:self.navigationController pageOption:k_PRIVACY_URL];
    }
    [mainTable deselectRowAtIndexPath:indexPath animated:YES];
}

      

@end
