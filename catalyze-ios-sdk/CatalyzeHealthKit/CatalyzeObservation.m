//
//  CatalyzeObservation.m
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 9/3/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import "CatalyzeObservation.h"

@implementation CatalyzeObservation

- (id)init {
    self = [super init];
    if (self) {
        _extras = [NSDictionary dictionary];
    }
    return self;
}

@end
