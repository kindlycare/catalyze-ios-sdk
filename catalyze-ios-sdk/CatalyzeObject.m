//
//  CatalyzeObject.m
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 8/22/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import "CatalyzeObject.h"

@implementation CatalyzeObject

+ (CatalyzeObject *)objectWithClassName:(NSString *)className {
    return (CatalyzeObject *)[CatalyzeEntry entryWithClassName:className];
}

+ (CatalyzeObject *)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary {
    return (CatalyzeObject *)[CatalyzeEntry entryWithClassName:className dictionary:dictionary];
}

@end
