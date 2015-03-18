//
//  MAUserGrpEventViewController.h
//  MyActive
//
//  Created by Preeti Malhotra on 28/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol userListDelegate;
@interface MAUserGrpEventVC : UIViewController
{
    IBOutlet UITableView *tblGrpEvnt;
   
      NSMutableArray *arrayAddPeople;
     NSMutableArray *arraySuggestPeople;
   

}

@property (retain, nonatomic) NSString *listType;
@property (retain, nonatomic) NSString *switchVal;
@property (retain, nonatomic) NSMutableArray *arraySelectedPeople;
@property (retain, nonatomic) NSMutableArray *arraySelectedGrp;
@property (nonatomic, weak) id<userListDelegate> delegate;
- (IBAction)btnPressed_add:(id)sender;
@end
@protocol userListDelegate <NSObject>
-(void)userData:(NSArray *)value;
@end
