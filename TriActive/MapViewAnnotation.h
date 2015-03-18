//
//  MapViewAnnotation.h
//  Odyssey
//
//  Created by Ketan on 15/04/14.
//  Copyright (c) 2014 Trigma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"

@interface MapViewAnnotation : NSObject<MKAnnotation>
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,retain) NSDictionary * dictImg;  // <-- add reference

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;

@end

