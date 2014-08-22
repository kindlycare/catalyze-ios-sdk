//
//  CatalyzeObject.h
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 8/22/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatalyzeEntry.h"

__attribute__((deprecated))
@interface CatalyzeObject : CatalyzeEntry

+ (CatalyzeObject *)objectWithClassName:(NSString *)className;

+ (CatalyzeObject *)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary;

@end
