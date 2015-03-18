//
//  MAAddFriendVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 11/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAAddFriendVC : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
{
    
    IBOutlet UITableView *friendTable;
    NSMutableArray *dataArray;
    NSMutableArray *arrSugestion;
    NSMutableArray *searchResults;
    NSString *name;
    NSString *detail;
    NSString *imageFile;
    BOOL isSearching;
     __weak IBOutlet UISearchBar *SearchBarFrnd;
    
}
@property (weak, nonatomic) IBOutlet NSString *keyword;
@property (weak, nonatomic) IBOutlet NSString *settingPg;
- (IBAction)btnPressed_Follow:(id)sender;

@end;
