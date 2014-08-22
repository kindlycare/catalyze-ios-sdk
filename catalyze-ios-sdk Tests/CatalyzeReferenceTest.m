//
//  CatalyzeReferenceTest.m
//  catalyze-ios-sdk Tests
//
//  Created by Josh Ault on 8/19/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Catalyze.h"
#import "CatalyzeTest.h"

@interface CatalyzeReferenceTest : CatalyzeTest

@end

@implementation CatalyzeReferenceTest
static const NSString *className = @"medications";

//class level
+ (void)setUp {
    [super setUp];
    
    __block BOOL finished = NO;
    
    NSDictionary *customClass = @{@"name":className, @"schema":@{@"medication":@"string", @"frequency":@"integer"}};
    [CatalyzeHTTPManager doPost:@"/classes" withParams:customClass block:^(int status, NSString *response, NSError *error) {
        if (error) {
            [NSException raise:@"CustomClassException" format:@"Could not create the custom class"];
        }
        finished = YES;
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

+ (void)tearDown {
    __block BOOL finished = NO;
    
    [CatalyzeHTTPManager doDelete:[NSString stringWithFormat:@"/classes/%@", className] block:^(int status, NSString *response, NSError *error) {
        if (error) {
            [NSException raise:@"CustomClassException" format:@"Could not delete the custom class"];
        }
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        [NSException raise:@"TeardownException" format:@"Could not properly execute %s", __PRETTY_FUNCTION__];
    }
    [super tearDown];
}

//method level
- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

@end
