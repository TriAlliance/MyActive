//
//  Utility.h
//  TriActive
//
//  Created by Ketan on 04/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import "TSMiniWebBrowser.h"

@interface Utility : NSObject
+(void)slideVwUp :(int)size :(UIViewController*)viewController;
+(UILabel *)lblTitleNavBar:(NSString *)title;
+(void)backGestureDisable:(UIViewController*)viewController;
+(UIBarButtonItem *)leftbar:(UIImage *)image :(UIViewController*)viewController;
+(UIBarButtonItem *)rightbar:(UIImage *)image :(UIViewController*)viewController;
+(void)swipeSideMenu :(UIViewController*)viewController;
+(NSMutableArray *)fetchContacts;
+(NSMutableArray *)fetchStravaData:(NSMutableArray *)Arr;

//**********ELIZA**********//
+(void)openMiniBrowser:(UIViewController*)selfView navController:(UINavigationController*)navController pageOption:(NSString*)urlToBeOpened;
@end
