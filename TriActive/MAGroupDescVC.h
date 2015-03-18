//
//  MAGroupDescVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 31/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLblRLight.h"
#import "MAAddGroupsVC.h"
#import <MapKit/MapKit.h>
@interface MAGroupDescVC : UIViewController<MKMapViewDelegate>{
    
    __weak IBOutlet UITableView *tblGrpDetail;
    NSMutableArray *ArrGrpData;

}
@property (retain, nonatomic) NSString *groupId;

- (IBAction)btnPressed_editGroup:(id)sender;
- (IBAction)btnPressed_followed:(id)sender;
@end
