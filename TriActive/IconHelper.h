//
//  IconHelper.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/1/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconHelper : NSObject

#define ICON_BICYCLE		"\ue000"
#define ICON_BIKE7			"\ue002"
#define ICON_HIKING			"\ue003"
#define ICON_HORSE118		"\ue004"
#define ICON_HORSE120		"\ue005"
#define ICON_HORSE125		"\ue006"
#define ICON_KITESURFING	"\ue009"
#define ICON_MAN6			"\ue00a"
#define ICON_MAN91			"\ue00b"
#define ICON_MAN99			"\ue00c"
#define ICON_MOUNTAIN22		"\ue00d"
#define ICON_PERSON37		"\ue00e"
#define ICON_PERSON87		"\ue00f"
#define ICON_PERSON91		"\ue010"
#define ICON_REGULAR		"\ue011"
#define ICON_RIDING			"\ue012"
#define ICON_ROWING			"\ue013"
#define ICON_RUBBER4		"\ue014"
#define ICON_RUNNING 		"\ue015"
#define ICON_RUNNING6		"\ue016"
#define ICON_RUNNING8		"\ue017"
#define ICON_SILHOUETTE2	"\ue018"
#define ICON_SILHOUETTE4	"\ue019"
#define ICON_SKATER1		"\ue01a"
#define ICON_SKATING2		"\ue01b"
#define ICON_SKI2 			"\ue01c"
#define ICON_SKIING 		"\ue01d"
#define ICON_SNOWBOARD1 	"\ue01e"
#define ICON_SNOWBOARDING	"\ue01f"
#define ICON_SOCCER38		"\ue020"
#define ICON_SPEED7			"\ue021"
#define ICON_SPORTIVE18		"\ue022"
#define ICON_SWIM1			"\ue023"
#define ICON_TRAIL			"\ue024"
#define ICON_VINTAGE 		"\ue026"
#define ICON_VINTAGE22		"\ue027"
#define ICON_WALKING3		"\ue028"
#define ICON_WINDSURF 		"\ue029"
#define ICON_WINDSURF1		"\ue02a"
#define ICON_WINTER2		"\ue02b"
#define ICON_SHOE 			"\ue600"
#define ICON_LINES 			"\ue601"
#define ICON_THERMOMETER 	"\ue602"
#define ICON_COMPASS 		"\ue603"
#define ICON_CELSIUS 		"\ue604"
#define ICON_FAHRENHEIT		"\ue605"
#define ICON_BOLT			"\ue606"
#define ICON_AWARD_FILL		"\ue607"
#define ICON_AWARD_STROKE	"\ue608"
#define ICON_SPIN			"\ue609"
#define ICON_COMPASS2		"\ue60a"
#define ICON_LIST 			"\ue60b"
#define ICON_CHART 			"\ue60c"
#define ICON_CHART_ALT 		"\ue60d"
#define ICON_LOCATION 		"\ue60e"
#define ICON_LOCATION2 		"\ue60f"
#define ICON_COMPASS3 		"\ue610"
#define ICON_MAP 			"\ue611"
#define ICON_MAP2 			"\ue612"
#define ICON_STOPWATCH 		"\ue613"
#define ICON_CALENDAR 		"\ue614"
#define ICON_LOCK 			"\ue615"
#define ICON_LOCK2 			"\ue616"
#define ICON_PIE  			"\ue617"
#define ICON_STATS 			"\ue618"
#define ICON_BARS 			"\ue619"
#define ICON_BARS2			"\ue61a"
#define ICON_HEART 			"\ue61b"
#define ICON_HEART2 		"\ue61c"
#define ICON_LOOP 			"\ue61d"
#define ICON_LOCATION3 		"\ue61e"
#define ICON_LOCKED 		"\ue61f"
#define ICON_REFRESH 		"\ue620"
#define ICON_LIST2 			"\ue621"
#define ICON_ARROW_RIGHT 	"\ue622"

#define ICON_HEART3			"\uf004"
#define ICON_LOCK3			"\uf023"
#define ICON_CHEVRON_RIGHT  "\uf054"
#define ICON_ARROW_RIGHT2   "\uf061"
#define ICON_CALENDAR2 		"\uf073"
#define ICON_BAR_CHART_O	"\uf080"
#define ICON_THUMBS_O_UP	"\uf087"
#define ICON_HEART_O		"\uf08a"
#define ICON_FLASH			"\uf0e7"
#define ICON_CHEVRON_CIRCLE "\uf137"
#define ICON_THUMBS_UP 		"\uf164"



+(void) makeThisLabel:(UILabel *)label anIcon:(char *)iconCode ofSize:(CGFloat)size;
+(void) makeThisButton:(UIButton *)button anIcon:(char *)iconCode ofSize:(CGFloat)size;

@end
