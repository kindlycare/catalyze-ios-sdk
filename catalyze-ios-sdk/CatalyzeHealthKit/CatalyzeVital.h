//
//  CatalyzeVital.h
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 9/3/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"
#import "CatalyzeObjectProtocol.h"
#import "JSONObject.h"

@interface CatalyzeVital : JSONObject<CatalyzeObjectProtocol>

#pragma mark -
#pragma mark Properties

/** @name Properties */

@property (strong, nonatomic) NSString *vitalsId;
@property (strong, nonatomic) NSString *usersId;
@property (strong, nonatomic) NSDate *documentedAt;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSMutableDictionary *extras;
@property (strong, nonatomic) NSMutableArray *observations;

@end
