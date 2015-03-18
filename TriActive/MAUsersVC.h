//
//  MAUsersVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 17/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAEventDescVC.h"
#import "MAGroupDescVC.h"
#import "MAProfileVC.h"
#import "OtherUserProfileVC.h"

@interface MAUsersVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

{
     NSMutableArray* arrList;
    }
@property (weak, nonatomic) IBOutlet UITableView *tblView_list;
@property (retain, nonatomic) NSString *listType;
//**********ELIZA**********//
@property (nonatomic, strong) NSString *post_id;
@property (nonatomic, strong) NSString *trendingType;
@property (nonatomic, strong) NSString *my_user_id;
@property (nonatomic, strong) NSString *my_Profile_or_other;
@property (retain, nonatomic) NSString *mutual;

@end
