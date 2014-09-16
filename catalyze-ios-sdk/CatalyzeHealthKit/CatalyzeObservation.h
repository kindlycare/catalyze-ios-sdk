//
//  CatalyzeObservation.h
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 9/3/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"
#import "CatalyzeObjectProtocol.h"
#import "JSONObject.h"

@interface CatalyzeObservation : JSONObject

#pragma mark -
#pragma mark Properties

/** @name Properties */

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *codeSystem;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *uom;
@property (strong, nonatomic) NSString *referenceRange;
@property (strong, nonatomic) NSDictionary *extras;

@end
