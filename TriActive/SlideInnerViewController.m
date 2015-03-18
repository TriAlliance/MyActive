//
//  SlideInnerViewController.m
//  My Competition
//
//  Copyright (c) 2014 Trigma. All rights reserved.
//

#import "SlideInnerViewController.h"
#import "MAAddEventVC.h"
#import "MAAddGroupsVC.h"
#import "MAAddFriendVC.h"
#import "MAProfileSettingVC.h"
#import "MANotificationVC.h"
#import "MASeachEventVC.h"
#import "MASearchGroupVC.h"
@interface SlideInnerViewController ()

@end

@implementation SlideInnerViewController


#pragma mark
#pragma mark <ViewLifeCycle>
#pragma mark


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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slide-nav-black-bg.png"]];
    Tableoult.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons-bg.png"]];
    imgVw_Profile.layer.borderWidth = 1.0;
    imgVw_Profile.layer.cornerRadius = 35.0;
    imgVw_Profile.layer.borderColor = [UIColor whiteColor].CGColor;
    [lbl_Name setFont:ROBOTO_MEDIUM(17)];
    [lbl_Location setFont:ROBOTO_MEDIUM(14)];
    _dictProfile = [[NSDictionary alloc]init];
    _dictProfile = [UserDefaults dictionaryForKey:@"userDetails"];
    MALog(@"_dictProfile---%@",_dictProfile);
     MALog(@"profile_image---%@",[_dictProfile valueForKey:@"profile_image"]);

    [imgVw_Profile sd_setImageWithURL:[NSURL URLWithString:[_dictProfile valueForKey:@"profile_image"]] placeholderImage:ProfilePlaceholder options:SDWebImageRetryFailed];
    imgVw_Profile.clipsToBounds = YES;
    lbl_Name.text = [_dictProfile valueForKey:@"name"];
    lbl_Location.text = [_dictProfile valueForKey:@"city"];
    
    if (IS_IPHONE_5) {
        if (iOSVersion > 7.0) {
            view_ContainerTbl.frame = CGRectMake(0, 156, 260, 291);
            btn_Signout.frame = CGRectMake(39, 480, 182, 44);
        }else
        {
            view_ContainerTbl.frame = CGRectMake(0, 126, 260, 291);
            btn_Signout.frame = CGRectMake(39, 450, 182, 44);
        }
    }else
    {
        if (iOSVersion > 7.0) {
            view_ContainerTbl.frame = CGRectMake(0, 131, 260, 291);
            btn_Signout.frame = CGRectMake(39, 420, 182, 44);
        }else
        {
            view_ContainerTbl.frame = CGRectMake(0, 101, 260, 291);
            btn_Signout.frame = CGRectMake(39, 387, 182, 44);
        }
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    SliderOptionImgArray=[[NSMutableArray alloc]initWithObjects:@"home_icons.png",@"notification_icon.png",@"icon-add-user.png"
                          ,@"icon-add-event.png",@"add-group-team.png",@"search_event_icon.png",@"search_group_icon.png",nil];
    SliderOptionstringArray=[[NSMutableArray alloc]initWithObjects:@"Home",@"Notifications",@"Add Friends",@"Add Events",@"Add Group/Team",@"Find Events",@"Find Groups",nil];

    // Do any additional setup after loading the view.
}

+(void)sideMenuOpen
{
    MALog(@"sideMenuOpen");
  
   
}


-(void)viewWillAppear:(BOOL)animated
{
   
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
#pragma mark <UITableViewDelegate & DataSource>
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SliderOptionstringArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = (RearTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    if(cell ==nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"RearTableViewCell" owner:self options:nil];
    }
    cell.Realcellimgoult.image= [UIImage imageNamed:[SliderOptionImgArray objectAtIndex:indexPath.row]];
    cell.RearcellLabloult.text=[SliderOptionstringArray objectAtIndex:indexPath.row];
    cell.RearcellLabloult.textColor=[UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	// Grab a handle to the reveal controller, as if you'd do with a navigtion controller via 	RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if (indexPath.row == 0)
	{
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CustomTabBarController class]])
        {
            CustomTabBarController *tabBar = VCWithIdentifier(@"CustomTabBarController");
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBar];
            [revealController setFrontViewController:navigationController animated:NO];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
           
        }

    }
    if (indexPath.row == 1)
    {
        // Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MANotificationVC class]])
        {
            MANotificationVC * NotificationVC =VCWithIdentifier(@"MANotificationVC");
            
            UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:NotificationVC];
            [revealController setFrontViewController:navigationController animated:NO];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
        }
        
    }
   if (indexPath.row == 2)
	{
        
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MAAddFriendVC class]])
        {
            MAAddFriendVC *AddEventVC = VCWithIdentifier(@"MAAddFriendVC");
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:AddEventVC];
            [revealController setFrontViewController:navigationController animated:NO];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
        }
    }
   if (indexPath.row == 3)
    {
        // Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        
        
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MAAddEventVC class]])
        {
            MAAddEventVC *AddEventVC = VCWithIdentifier(@"MAAddEventVC");
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:AddEventVC];
            [revealController setFrontViewController:navigationController animated:NO];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
        }
    }
    if(indexPath.row==4)
    {
        
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MAAddGroupsVC class]])
        {
            MAAddGroupsVC *AddGroupVC = VCWithIdentifier(@"MAAddGroupsVC");
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:AddGroupVC];
            [revealController setFrontViewController:navigationController animated:NO];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
        }
    }
    
    if(indexPath.row==5)
    {
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MAProfileSettingVC class]])
        {
            MASeachEventVC *SeachEventVC =VCWithIdentifier(@"MASeachEventVC");
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:SeachEventVC];
            [revealController setFrontViewController:navigationController animated:NO];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
        }
        
    }

    if(indexPath.row==6)
    {
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MAProfileSettingVC class]])
        {
            MASearchGroupVC *SeachGrpVC =VCWithIdentifier(@"MASearchGroupVC");
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:SeachGrpVC];
            [revealController setFrontViewController:navigationController animated:NO];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
        }
        
    }

}

- (IBAction)btnPressed_Signout:(id)sender {
    
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
@end
