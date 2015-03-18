//
//  MABlockedUserListVC.h
//  MyActive
//
//  Created by Eliza Dhamija on 03/02/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MABlockedUserListVC : UIViewController{
    IBOutlet UITableView *tbl_blocked_user;
}

@property (nonatomic, strong) NSMutableArray *arr_blocked_user;
@end
