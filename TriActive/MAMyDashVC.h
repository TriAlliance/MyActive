//
//  MAMyDashVC.h
//  MyActive
//
//  Created by Ketan on 29/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenu.h"
#import "BEMSimpleLineGraphView.h"
#import "XYPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "Base64.h"
@interface MAMyDashVC : UIViewController<AwesomeMenuDelegate,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate,XYPieChartDelegate, XYPieChartDataSource,UIActionSheetDelegate>
{
    __weak IBOutlet UIScrollView *scrollVw_container;
    AwesomeMenu *menu;
    __weak IBOutlet UISegmentedControl *segmnt_Graph;
    NSString * base64;
    __weak IBOutlet UIView *viewDash;
}
- (IBAction)btnPressed_Segment:(id)sender;
- (IBAction)btnPressed_Shared:(id)sender;


//Line Graph
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph_Activity;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph_Recovery;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph_Nutrition;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph_WellBeing;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph_MyBody;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph_MyGoal;
@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfActivity;
@property (strong, nonatomic) NSMutableArray *ArrayOfRecovery;
@property (strong, nonatomic) NSMutableArray *ArrayOfNutrition;
@property (strong, nonatomic) NSMutableArray *ArrayOfWellbeing;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;
@property (strong, nonatomic) NSMutableArray *ArrayOfWeeks;
@property (strong, nonatomic) NSMutableArray *ArrayOfMonths;
@property (strong, nonatomic) NSMutableArray *ArrayOfYears;
@property (strong, nonatomic) NSMutableArray *ArrayOfGraphPts;
//Pie Chart
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;
@property(nonatomic, strong) NSString *SegmentValue;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSMutableArray * arrData;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSData *image;

@end
