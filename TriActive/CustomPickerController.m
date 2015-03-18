//
//  CustomPickerController.m
//  UVuume
//
//  Created by Rajender Sharma on 13/07/11.
//  Copyright 2011 Netsmartz. All rights reserved.
//

#import "CustomPickerController.h"
#import "Constant.h"


@implementation CustomPickerController

@synthesize updateTimer = _updateTimer; 
@synthesize tempFileName = _tempFileName;
@synthesize isVideo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) updateMetaFile {
    
    /*
     NSCalendar * calendar = [NSCalendar currentCalendar];
     NSDateComponents * timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
     
     NSString * time = [[NSString alloc] initWithFormat:@"%d:%d:%d",[timeComponents hour],[timeComponents minute],[timeComponents second]];
     
     NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
     [dateFormatter setDateFormat:@"dd-MM-YYYY"];
     
     */
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
    
    NSString * metaFlags = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    NSError * error = nil;
    NSString * metaFileString = [NSString stringWithContentsOfFile:self.tempFileName encoding:NSUTF8StringEncoding error:&error];
    
    
    NSString * metaString = [NSString stringWithFormat:@"<MetaData>"
                             "<Date>%@</Date>"
                             "<Time>%@</Time>"
                             "<Latitude>0.0</Latitude>"
                             "<Longitude>0.0</Longitude>"
                             "</MetaData>",
                             [[metaFlags componentsSeparatedByString:@" "]objectAtIndex:0],
                             [[metaFlags componentsSeparatedByString:@" "]objectAtIndex:1]];
    
     metaFileString = [metaFileString stringByAppendingString:metaString];
    [metaFileString writeToFile:self.tempFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
   // [dateFormatter release];
    
    if (!_updateTimer && self.isVideo)
    {
     
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateMetaFile) userInfo:nil repeats:YES];
    }  
}
- (void) createMetaFile
{
    NSString * metaString = nil;
    
    if (self.isVideo) {
        
        metaString = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><Root><MetaData/>"];
    }
    else {
        
        metaString = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><Root>"];
    }
    
    NSError * error = nil;
    [metaString writeToFile:self.tempFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error)
    {
      [self updateMetaFile];
    }
}

- (void) closeFile 
{

    NSError * error = nil;  
    NSString * metaFileString = [NSString stringWithContentsOfFile:self.tempFileName encoding:NSUTF8StringEncoding error:&error];
    if (self.isVideo) {
        
        self.isVideo  = NO;
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        
        // Create the NSDates
        NSDate *date2 = [NSDate date];//initWithTimeInterval: sinceDate:startDate]; 
        
        // Get conversion to months, days, hours, minutes
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:startDate  toDate:date2  options:0];
        
        metaFileString = [metaFileString stringByAppendingFormat:@"<Duration>%ld:%ld:%ld</Duration></Root>", (long)[conversionInfo hour], (long)[conversionInfo minute], (long)[conversionInfo second]];
        
       // [startDate release],
        startDate = nil;
    }
    else {
        
        metaFileString = [metaFileString stringByAppendingString:@"</Root>"];        
    }
    [metaFileString writeToFile:self.tempFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    self.tempFileName = nil;
    
    
   
}

- (void)stopVideoCapture 
{
    
    [super stopVideoCapture];
    
    if (_updateTimer)
    {
      [_updateTimer invalidate];
        
    }
     self.updateTimer = nil;
    [self closeFile];
    
}

- (BOOL)startVideoCapture
{

    if (!_recording) 
    {
        _recording = YES;
        [self createMetaFile];
        startDate = [NSDate date];//[[NSDate date]retain];
        self.updateTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        return [super startVideoCapture];
    }
    else
    {
        [self stopVideoCapture];
        _recording = NO;
    }
    
    //[self]
    return YES;
}


- (void)takePicture 
{
    
    [super takePicture];
    [self createMetaFile];
    [self closeFile];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.secondsPassed = 0;
    //self.isVideo  = YES;
    captureButton = [[UIControl alloc] initWithFrame:CGRectMake(110.0, 435.0, 100.0, 30.0)];
    if (self.isVideo) 
    {
      
       [captureButton addTarget:self action:@selector(startVideoCapture) forControlEvents:UIControlEventTouchUpInside];
    }
    else 
    {
       [captureButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    }
    captureButton.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:captureButton];
}

- (void)viewDidDisappear:(BOOL)animated 

{
    //eshan
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        self.edgesForExtendedLayout = UIRectEdgeNone;
	// stop the preview timer
	//
    self.updateTimer = nil;
	// make sure to call the same method on the super class!!!
	//
	[super viewDidDisappear:animated];
  
}

-(void) viewDidAppear: (BOOL)animated {
    
	[super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
- (void)timerTick:(NSTimer *)timer {
    self.secondsPassed += 1;
    NSUInteger hoursPassed = self.secondsPassed / 3600;
    NSUInteger minsPassed = (self.secondsPassed - hoursPassed *3600) / 60;
    NSUInteger secsPassed = self.secondsPassed - hoursPassed *3600 - minsPassed * 60;
    self.timerLabel.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)hoursPassed, (unsigned long)minsPassed, (unsigned long)secsPassed];
    
    if(secsPassed==12){
        if (_recording) {
            [self stopVideoCapture];
            [_updateTimer invalidate];
        }
        _recording = !_recording;
        
    }
}
@end
