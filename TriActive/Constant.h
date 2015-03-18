//
//  Constant.h
//  TriActive
//
//  Created by Ketan on 04/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#ifndef TriActive_Constant_h
#define TriActive_Constant_h

#import "MAAppDelegate.h"

#define k_HELP_URL @"http://myactive.co/faq.php"
#define k_TERMS_OF_USE_URL @"http://myactive.co/terms.php"
#define k_PRIVACY_URL @"http://myactive.co/privacy.php"



#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON)
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)
#define ApplicationDelegate  ((MAAppDelegate*)[[UIApplication sharedApplication] delegate])
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define WindowFrame  [UIScreen mainScreen].bounds
#define iOSVersion   [[[UIDevice currentDevice] systemVersion] floatValue]
#define Storyboard   ApplicationDelegate.mainNavigationController.storyboard
#define VCWithIdentifier(i) [Storyboard instantiateViewControllerWithIdentifier:i]

//Font
#define ROBOTO_LIGHT(i) [UIFont fontWithName:@"Roboto-Light" size:i]
#define ROBOTO_REGULAR(i) [UIFont fontWithName:@"Roboto-Regular" size:i]
#define ROBOTO_MEDIUM(i) [UIFont fontWithName:@"Roboto-Medium" size:i]
#define SIGNIKA_REGULAR(i) [UIFont fontWithName:@"Signika-Regular" size:i]

//Placeholder
#define PlaceholderTextColor(i) [i setValue:[UIColor colorWithRed:225.0f/255.0f green:228.0f/255.0f blue:233.0f/255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"]

//error string
#define ErrorStr @"Something went wrong try again."

//Plist Load
#define LoadPlist(i) [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:i ofType:@"plist"]]
#define ToolBarItem(i) [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithTitle:i style:UIBarButtonItemStyleDone target:self action:@selector(doneWithToolBar)],nil]
#define ToolBarItemKeyboard(i) [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithTitle:i style:UIBarButtonItemStyleDone target:self action:@selector(doneWithToolBarKeyboard)],nil]
//Load Array Data
#define LoadArrayData(i) [[NSMutableArray alloc]initWithArray:[dictRootMyData objectForKey:i]]

#define DATEFORMAT @"yyyy-MM-dd HH:mm a"


//Log
#define LoggingEnabled YES
#ifndef MALog
#define MALog(format, ...) if(LoggingEnabled) NSLog(format, ##__VA_ARGS__)
#endif

//App Name
#define AppName @"MyActive"

//API
#define API [APIMaster singleton]
#define JSONObjectFromData(d) [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]
#define BaseURL          @"http://208.109.176.111/"
//#define BaseURL          @"http://dev614.trigma.us/triactive/"
#define URLForAPI(api)   [NSURL URLWithString:[BaseURL stringByAppendingString:api]]
#define RequestForURL(url) [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:90.0f]

//Cover Photo Placeholder
#define CoverPlaceholder [UIImage imageNamed:@"no_cover.png"]
#define ProfilePlaceholder [UIImage imageNamed:@"PicPlaceholder.png"]
#define HomePlaceholder [UIImage imageNamed:@"No_Cover1.png"]
//Alert
#define ShowAlertWithTitleNMessage(t,m) [[[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show]
#define ShowAlertWithTitleMess_YES_NO_Delegate(t,m,d) [[[UIAlertView alloc] initWithTitle:t message:m delegate:d cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show]

#define AlertMsg1 @"Work in progress...."
#endif
