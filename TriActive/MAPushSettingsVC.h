//
//  MAPushSettingsVC.h
//  MyActive
//
//  Created by Eliza Dhamija on 30/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAPushSettingsVC : UIViewController{
    IBOutlet UITableView *tableView_notification;
    NSArray *tmp_Key_arr;
    NSMutableArray *tmp_Value_For_Key_arr;
    NSArray *arr_notification_text, *arr_push_text;

}
@property NSMutableDictionary *dict_Notification_check;
@property (nonatomic,strong)NSString *optionSelected;
@end
