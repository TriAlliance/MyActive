//
//  MAAddLocationVC.h
//  MyActive
//
//  Created by Jimcy Goyal on 22/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol locationDelegate;
@interface MAAddLocationVC : UIViewController<UISearchBarDelegate>
{
    NSMutableArray *arrSendData;
    NSMutableArray* arrLocationImages;
    NSMutableArray* arrLocationType;
    NSMutableArray* arrLocationName;
    NSMutableArray *searchResults;
 
    __weak IBOutlet UITableView *tblLocation;
    __weak IBOutlet UISearchBar *SearchBar;
    BOOL isSearching;
    BOOL selectAll;
    
}
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, weak) id<locationDelegate> delegate;
@end
@protocol locationDelegate <NSObject>
-(void)locationData:(NSDictionary *)value;