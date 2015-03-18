//
//  MapViewAnnotation.m
//  Odyssey
//
//  Created by Ketan on 15/04/14.
//  Copyright (c) 2014 Trigma. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation


- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	_title = ttl;
	_coordinate = c2d;
	return self;
}


@end
