//
//  MAActivityVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 10/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol activityDelegate;
@interface MAActivityVC : UIViewController<UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
{
    NSArray *imgActivity;
    NSArray *txtActivity;
    __weak IBOutlet UICollectionView *cvActivity;
    __weak IBOutlet UISearchBar *searchBarActivity;
     NSMutableArray *searchResults;
    BOOL isSearching;
    BOOL selectAll;
    IBOutlet UIView *View_activity;
}
@property (nonatomic, weak) id<activityDelegate> delegate;
@property (nonatomic, weak) NSString *myGoal;
- (IBAction)btnPressed_Cancel:(id)sender;
- (IBAction)btnPressed_Save:(id)sender;
@end
@protocol activityDelegate <NSObject>
-(void)activityData:(NSString *)value;
@end
