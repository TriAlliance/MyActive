//
//  MAMyDashVC.m
//  MyActive
//
//  Created by Ketan on 29/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAMyDashVC.h"
#import <QuartzCore/QuartzCore.h>
#import "MyDashActivityVC.h"
#import "MyDashMyBodyVC.h"
#import "MyDashMyGoalVC.h"
#import "MyDashNutritionVC.h"
#import "MyDashRecoveryVC.h"
#import "MyDashWellBeingVC.h"
#import "MACommentsVC.h"

@interface MAMyDashVC ()

@end

@implementation MAMyDashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"MyDash"];
    self.navigationItem.leftBarButtonItem = [Utility leftbar:[UIImage imageNamed:@"sideMenu.png"] :self];
    self.navigationController.navigationBar.translucent = NO;
    
    [scrollVw_container setContentSize:CGSizeMake(320 , 1355)];
    //Bottom Menu
    [self addBottomMenu];
    
    //Pie Chart
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    for(int i = 0; i < 6; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [_slices addObject:one];
    }
    [self.pieChartLeft setDelegate:self];
    [self.pieChartLeft setDataSource:self];
    [self.pieChartLeft setStartPieAngle:M_PI_2];
    [self.pieChartLeft setAnimationSpeed:1.0];
    [self.pieChartLeft setLabelFont:[UIFont fontWithName:@"Roboto-Regular" size:10]];
    [self.pieChartLeft setLabelRadius:50];
    [self.pieChartLeft setShowPercentage:YES];
    [self.pieChartLeft setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    //    [self.pieChartLeft setPieCenter:CGPointMake(150, 150)];
    [self.pieChartLeft setUserInteractionEnabled:NO];
    [self.pieChartLeft setLabelShadowColor:[UIColor blackColor]];
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:215.0f/255.0f green:73.0f/255.0f blue:66.0f/255.0f alpha:1.0f],
                       [UIColor colorWithRed:65.0f/255.0f green:125.0f/255.0f blue:214.0f/255.0f alpha:1.0f],
                       [UIColor colorWithRed:66.0f/255.0f green:167.0f/255.0f blue:121.0f/255.0f alpha:1.0f],
                       [UIColor colorWithRed:243.0f/255.0f green:123.0f/255.0f blue:66.0f/255.0f alpha:1.0f],
                       [UIColor colorWithRed:123.0f/255.0f green:53.0f/255.0f blue:255.0f/255.0f alpha:1.0f],
                       [UIColor colorWithRed:215.0f/255.0f green:210.0f/255.0f blue:0.0f/255.0f alpha:1.0f],nil];
    [self.pieChartLeft reloadData];
    //Line Graph
    //    self.ArrayOfValues = [[NSMutableArray alloc] init];
    _ArrayOfActivity =   [[NSMutableArray alloc] init];
    _ArrayOfRecovery =   [[NSMutableArray alloc] init];
    _ArrayOfNutrition =  [[NSMutableArray alloc] init];
    _ArrayOfWellbeing =  [[NSMutableArray alloc] init];
    _ArrayOfWeeks=  [[NSMutableArray alloc] init];
    _ArrayOfMonths=  [[NSMutableArray alloc] init];
    _ArrayOfYears=  [[NSMutableArray alloc] init];
    _arrData=[[NSMutableArray alloc] init];
    self.ArrayOfDates = [[NSMutableArray alloc] init];
    _SegmentValue=@"day";
    [self callMydashData];
    
    [self addGraph:self.myGraph_Activity backgroundColor:[UIColor colorWithRed:215.0f/255.0f green:73.0f/255.0f blue:66.0f/255.0f alpha:1.0f]];
    [self addGraph:self.myGraph_Recovery backgroundColor:[UIColor colorWithRed:65.0f/255.0f green:125.0f/255.0f blue:214.0f/255.0f alpha:1.0f]];
    [self addGraph:self.myGraph_Nutrition backgroundColor:[UIColor colorWithRed:66.0f/255.0f green:167.0f/255.0f blue:121.0f/255.0f alpha:1.0f]];
    [self addGraph:self.myGraph_WellBeing backgroundColor:[UIColor colorWithRed:243.0f/255.0f green:123.0f/255.0f blue:66.0f/255.0f alpha:1.0f]];
    [self addGraph:self.myGraph_MyBody backgroundColor:[UIColor colorWithRed:123.0f/255.0f green:53.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self addGraph:self.myGraph_MyGoal backgroundColor:[UIColor colorWithRed:215.0f/255.0f green:210.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    /***** End HealthKit Permission *****/
}

-(void)addGraph : (BEMSimpleLineGraphView *)grph backgroundColor : (UIColor *)color
{
    grph.colorLine = [UIColor whiteColor];
    grph.colorXaxisLabel = [UIColor whiteColor];
    grph.colorYaxisLabel = [UIColor whiteColor];
    grph.widthLine = 2.0;
    grph.enableTouchReport = YES;
    grph.enablePopUpReport = YES;
    grph.enableBezierCurve = YES;
    grph.enableYAxisLabel = YES;
    grph.autoScaleYAxis = YES;
    grph.alwaysDisplayDots = YES;
    grph.enableReferenceAxisLines = YES;
    grph.enableReferenceAxisFrame = YES;
    grph.animationGraphStyle = BEMLineAnimationDraw;
    grph.colorTop = color;
    grph.colorBottom = color;
    grph.backgroundColor = color;
}

#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)leftBtn
{
    if ([self.tabBarController.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.tabBarController.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
        
        [self.tabBarController.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil afterDelay:0.0];
        
    }
}

#pragma mark
#pragma mark scrollView delegate Method
#pragma mark
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         menu.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         menu.hidden = YES;
                     }];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    MALog(@"scrollViewDidEndScrollingAnimation");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         menu.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         menu.hidden = NO;
                     }];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         menu.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         menu.hidden = NO;
                     }];
    
}


#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    if(graph == self.myGraph_Activity)
        return [_ArrayOfActivity count];
    else if(graph == self.myGraph_WellBeing)
        return [_ArrayOfWellbeing count];
    else if(graph == self.myGraph_Nutrition)
        return [_ArrayOfNutrition count];
    else if(graph == self.myGraph_Recovery)
        return [_ArrayOfRecovery count];
    else
        return 0;
}

/*
 - (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
 {
 if(self.myGraph_Activity)
 return (int)[_ArrayOfActivity count];
 else if(self.myGraph_WellBeing)
 return (int)[_ArrayOfWellbeing count];
 else if(self.myGraph_Nutrition)
 return (int)[_ArrayOfNutrition count];
 else if(self.myGraph_Recovery)
 return (int)[_ArrayOfRecovery count];
 else
 return 0;
 }
 */

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    
    if(graph == self.myGraph_Activity){
        
        if([[_ArrayOfActivity objectAtIndex:index] isEqualToString:@"0"] ){
            
            return 0;
            
        }
        else{
            
            return [[_ArrayOfActivity objectAtIndex:index] intValue];
            
        }
    }
    else if(graph == self.myGraph_WellBeing)
    {
        return [[_ArrayOfWellbeing objectAtIndex:index] intValue];
    }
    else if(graph == self.myGraph_Nutrition)
    {
        return [[_ArrayOfNutrition objectAtIndex:index] intValue];
    }
    else if(graph == self.myGraph_Recovery)
    {
        return [[_ArrayOfRecovery objectAtIndex:index] intValue];
    }
    else
    {
        return 0;
    }
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}


- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label=@"";
    MALog(@"%@",label);
    if([_SegmentValue isEqualToString:@"day"]){
        
        label = [self.ArrayOfDates objectAtIndex:index];
        return label;
    }
    else if([_SegmentValue isEqualToString:@"week"]){
        label = [_ArrayOfWeeks objectAtIndex:index];
        return label;
    }
    else if([_SegmentValue isEqualToString:@"month"]){
        label = [_ArrayOfMonths objectAtIndex:index];
        return label;
    }
    else if([_SegmentValue isEqualToString:@"year"]){
        label = [_ArrayOfYears objectAtIndex:index];
        return label;
    }
    else
        return label;
}



- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    
    
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    //    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}


#pragma mark
#pragma mark Add Bottom Menu Method
#pragma mark
-(void)addBottomMenu
{
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"myDash_activity.png"]
                                                           highlightedImage:[UIImage imageNamed:@""]
                                                               ContentImage:[UIImage imageNamed:@""]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"myDash_recovery.png"]
                                                           highlightedImage:[UIImage imageNamed:@""]
                                                               ContentImage:[UIImage imageNamed:@""]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"myDash_nutrition.png"]
                                                           highlightedImage:[UIImage imageNamed:@""]
                                                               ContentImage:[UIImage imageNamed:@""]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"myDash_wellbeing.png"]
                                                           highlightedImage:[UIImage imageNamed:@""]
                                                               ContentImage:[UIImage imageNamed:@""]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"myDash_Mybody.png"]
                                                           highlightedImage:[UIImage imageNamed:@""]
                                                               ContentImage:[UIImage imageNamed:@""]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"myDash_mygoal.png"]
                                                           highlightedImage:[UIImage imageNamed:@""]
                                                               ContentImage:[UIImage imageNamed:@""]
                                                    highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5,starMenuItem6, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"myDash_more.png"]
                                                       highlightedImage:[UIImage imageNamed:@"myDash_more.png"]
                                                           ContentImage:[UIImage imageNamed:@""]
                                                highlightedContentImage:[UIImage imageNamed:@""]];
    
    menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:startItem optionMenus:menus];
    menu.delegate = self;
    menu.rotateAngle = M_PI / 180 * -90;
    menu.menuWholeAngle = M_PI / 180 * 180;
    menu.farRadius = 10;
    menu.endRadius = 100.0f;
    menu.nearRadius = 90.0f;
    menu.animationDuration = 0.3f;
    if (IS_IPHONE_4) {
        menu.startPoint = CGPointMake(160.0, 320.0);
    }else
    {
        menu.startPoint = CGPointMake(160.0, 410.0);
    }
    
    [self.view addSubview:menu];
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %ld",(long)idx);
    
    //    MyDashActivityVC *ActMenuVcObj=VCWithIdentifier(@"MyDashActivityVC");
    switch (idx) {
        case 0:
        {
            MyDashActivityVC *ActMenuVcObj=VCWithIdentifier(@"MyDashActivityVC");
            ActMenuVcObj.dict_MyDashData = [[NSMutableDictionary alloc]init];
            [ActMenuVcObj.dict_MyDashData setObject:[self.myGraph_Activity graphSnapshotImage] forKey:@"imgGraph"];
            [ActMenuVcObj.dict_MyDashData setValue:@"Activity" forKey:@"type"];
            [self.navigationController presentViewController:ActMenuVcObj animated:YES completion:nil];
        }
            break;
            
        case 1:
        {
            MyDashRecoveryVC *ActMenuVcObj=VCWithIdentifier(@"MyDashRecoveryVC");
            ActMenuVcObj.dict_MyDashData = [[NSMutableDictionary alloc]init];
            [ActMenuVcObj.dict_MyDashData setObject:[self.myGraph_Recovery graphSnapshotImage] forKey:@"imgGraph"];
            [ActMenuVcObj.dict_MyDashData setValue:@"Recovery" forKey:@"type"];
            [self.navigationController presentViewController:ActMenuVcObj animated:YES completion:nil];
        }
            break;
            
        case 2:
        {
            MyDashNutritionVC *ActMenuVcObj=VCWithIdentifier(@"MyDashNutritionVC");
            ActMenuVcObj.dict_MyDashData = [[NSMutableDictionary alloc]init];
            [ActMenuVcObj.dict_MyDashData setObject:[self.myGraph_Nutrition graphSnapshotImage] forKey:@"imgGraph"];
            [ActMenuVcObj.dict_MyDashData setValue:@"MyFood" forKey:@"type"];
            [self.navigationController presentViewController:ActMenuVcObj animated:YES completion:nil];
        }
            break;
            
        case 3:
        {
            MyDashWellBeingVC *ActMenuVcObj=VCWithIdentifier(@"MyDashWellBeingVC");
            ActMenuVcObj.dict_MyDashData = [[NSMutableDictionary alloc]init];
            [ActMenuVcObj.dict_MyDashData setObject:[self.myGraph_WellBeing graphSnapshotImage] forKey:@"imgGraph"];
            [ActMenuVcObj.dict_MyDashData setValue:@"WellBeing" forKey:@"type"];
            [self.navigationController presentViewController:ActMenuVcObj animated:YES completion:nil];
        }
            break;
            
        case 4:
        {
            MyDashMyBodyVC *ActMenuVcObj=VCWithIdentifier(@"MyDashMyBodyVC");
            ActMenuVcObj.dict_MyDashData = [[NSMutableDictionary alloc]init];
            [ActMenuVcObj.dict_MyDashData setObject:[self.myGraph_MyBody graphSnapshotImage] forKey:@"imgGraph"];
            [ActMenuVcObj.dict_MyDashData setValue:@"MyBody" forKey:@"type"];
            [self.navigationController presentViewController:ActMenuVcObj animated:YES completion:nil];
        }
            break;
            
        case 5:
        {
            MyDashMyGoalVC *ActMenuVcObj=VCWithIdentifier(@"MyDashMyGoalVC");
            ActMenuVcObj.dict_MyDashData = [[NSMutableDictionary alloc]init];
            [ActMenuVcObj.dict_MyDashData setObject:[self.myGraph_MyGoal graphSnapshotImage] forKey:@"imgGraph"];
            [ActMenuVcObj.dict_MyDashData setValue:@"MyGoal" forKey:@"type"];
            [self.navigationController presentViewController:ActMenuVcObj animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnPressed_Segment:(id)sender {
    
    switch (segmnt_Graph.selectedSegmentIndex) {
        case 0:
            _SegmentValue=@"day";
            break;
        case 1:
            _SegmentValue=@"week";
            break;
        case 2:
            _SegmentValue=@"month";
            break;
        case 3:
            _SegmentValue=@"year";
            break;
        default:
            break;
    }
    [self callMydashData];
    
    MALog(@"%@====SegmentValue",_SegmentValue);
    //    [self.myGraph_Activity reloadGraph];
    //    [self.myGraph_MyBody reloadGraph];
    //    [self.myGraph_MyGoal reloadGraph];
    //    [self.myGraph_Nutrition reloadGraph];
    //    [self.myGraph_Recovery reloadGraph];
    //    [self.myGraph_WellBeing reloadGraph];
    
    [_slices removeAllObjects];
    for(int i = 0; i < 6; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [_slices addObject:one];
    }
    [self.pieChartLeft reloadData];
    
}
-(void)callMydashData
{
    
    
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"segment":_SegmentValue};
    
    [ApplicationDelegate show_LoadingIndicator];
    [_ArrayOfActivity removeAllObjects];
    [self.ArrayOfDates removeAllObjects];
    [_ArrayOfMonths removeAllObjects];
    [_ArrayOfWeeks removeAllObjects];
    [_ArrayOfYears removeAllObjects];
    [_ArrayOfActivity removeAllObjects];
    [_ArrayOfNutrition removeAllObjects];
    [_ArrayOfWellbeing removeAllObjects];
    [_ArrayOfRecovery removeAllObjects];
    
    [API segmentMyDashDataWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            _arrData=[responseDict valueForKey:@"data"];
            
            for(int i = 0; i <[[responseDict valueForKey:@"data"] count]; i++)
            {
                if([_SegmentValue isEqualToString:@"day"])
                {
                    [self.ArrayOfDates addObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"date"]];
                }
                else if([_SegmentValue isEqualToString:@"week"])
                {
                    [_ArrayOfWeeks addObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"date"]];
                }
                else if([_SegmentValue isEqualToString:@"month"])
                {
                    [_ArrayOfMonths addObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"date"]];
                }
                else
                {
                    [_ArrayOfYears addObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"date"]];
                }
                
                if([[[responseDict valueForKey:@"data"] objectAtIndex:i ] valueForKey:@"activity"]){
                    [_ArrayOfActivity insertObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"activity"] atIndex:i];
                }
                if([[[responseDict valueForKey:@"data"] objectAtIndex:i ]valueForKey:@"nutrition"]){
                    
                    [_ArrayOfNutrition insertObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i ] valueForKey:@"nutrition"] atIndex:i];
                }
                if([[[responseDict valueForKey:@"data"] objectAtIndex:i ]valueForKey:@"wellbeing"])
                {
                    
                    [_ArrayOfWellbeing insertObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i ] valueForKey:@"wellbeing"] atIndex:i];
                }
                
                if([[[responseDict valueForKey:@"data"] objectAtIndex:i ]valueForKey:@"recovery"] ){
                    
                    [_ArrayOfRecovery insertObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i ] valueForKey:@"recovery"] atIndex:i];
                }
                
            }
            [_ArrayOfDates addObject:@" "];
            [_ArrayOfWeeks addObject:@" "];
            [_ArrayOfMonths addObject:@" "];
            [_ArrayOfYears addObject:@" "];
            [_ArrayOfActivity addObject:@" "];
            [_ArrayOfWellbeing addObject:@" "];
            [_ArrayOfNutrition addObject:@" "];
            [_ArrayOfRecovery addObject:@" "];
            
            NSLog(@"_ArrayOfWeeks--%@",_ArrayOfWeeks);
            NSLog(@"_ArrayOfActivity--%@",_ArrayOfActivity);
            NSLog(@"_ArrayOfWellbeing--%@",_ArrayOfWellbeing);
            NSLog(@"_ArrayOfNutrition--%@",_ArrayOfNutrition);
            NSLog(@"_ArrayOfRecovery--%@",_ArrayOfRecovery);
            
            [self.myGraph_Activity reloadGraph];
            [self.myGraph_Nutrition reloadGraph];
            [self.myGraph_Recovery reloadGraph];
            [self.myGraph_WellBeing reloadGraph];
        }
        else
        {
            [ApplicationDelegate showAlert:ErrorStr];
        }
        
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
    
    
}
-(void)DayMyDashDataWithInfo
{
    NSDictionary* userInfo = @{@"user_id":[UserDefaults valueForKey:@"user_id"]
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API segmentMyDashDataWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            _arrData=[responseDict valueForKey:@"data"];
            for(int i = 0; i <[[responseDict valueForKey:@"data"] count]; i ++)
            {
                
                [self.ArrayOfDates addObject:[[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"date"]];
                
                if([[[[responseDict valueForKey:@"data"] objectAtIndex:i ] valueForKey:@"activity"] count]>0){
                    _ArrayOfActivity=[[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"activity"];
                    
                }
                else {
                    [_ArrayOfActivity addObject:@"0"];
                    
                }
            }
            
            NSLog(@"_arrData for date--%@",self.ArrayOfDates);
            NSLog(@"_ArrayOfActivity--%@",_ArrayOfActivity);
            
            
            
        }
        else
        {
            [ApplicationDelegate showAlert:ErrorStr];
        }
        
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}



- (IBAction)btnPressed_Shared:(id)sender {
    UIButton *button=(UIButton *)sender;
    NSInteger tag = [button tag];
    UIImage *img;
    CGFloat compression =0.9f;
    
    switch (tag) {
        case 1210:
        {
            NSLog(@"Button Tag is : %li", (long)tag);
            _text=@"Activity";
            img=[self.myGraph_Activity graphSnapshotImage];
        }
            break;
        case 1211:
        {
            _text=@"Recovery";
            img=[self.myGraph_Recovery graphSnapshotImage];
        }
            break;
            
        case 1212:
        {
            _text=@"Nutrition";
            img=[self.myGraph_Nutrition graphSnapshotImage];
        }
            break;
            
        case 1213:
        {
            _text=@"WellBeing";
            img=[self.myGraph_WellBeing graphSnapshotImage];
        }
            break;
            
        case 1214:
        {
            _text=@"MyBody";
            img=[self.myGraph_MyBody graphSnapshotImage];
            
        }
            break;
        case 1215:
        {
            _text=@"MyGoal";
            img=[self.myGraph_MyGoal graphSnapshotImage];
        }
            break;
            
        case 1216:
        {
            _text=[NSString stringWithFormat:@"%@'s MyDash",[UserDefaults valueForKey:@"username"]];
            
            img=[self captureView:viewDash withArea:viewDash.bounds];
        }
            
            break;
        default:
            NSLog(@"Button Tag is : %lu", tag);
            break;
    }
    _image = UIImageJPEGRepresentation(img, compression);
    base64 = [[NSString alloc] initWithString:[Base64 encode:_image]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AppName
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Facebook"];
    [actionSheet addButtonWithTitle:@"Twitter"];
    [actionSheet addButtonWithTitle:@"MyActive"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
}

#pragma mark
#pragma mark UIActionSheet Methods
#pragma mark
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: // Static button
        {
            MALog(@"Facebook");
            
        }
            break;
        case 1:
        {
            MALog(@"Twitter");
            
        }
            break;
        case 2:
        {
            
            MACommentsVC *objComments=VCWithIdentifier(@"MACommentsVC");
            objComments.dataImg=_image;
            objComments.baseData=base64;
            objComments.type=_text;
            // [self.navigationController pushViewController:objComments animated:YES];
            [self presentViewController:objComments animated:YES completion:nil];
            MALog(@"MyActive");
            
        }
            break;
        case 3:
        {
            MALog(@"Cancel");
            
        }
            break;
        default:
            break;
    }
}
- (UIImage *)captureView:(UIView *)view withArea:(CGRect)screenRect {
    UIGraphicsBeginImageContextWithOptions(screenRect.size,YES, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage ;
    
}
@end
