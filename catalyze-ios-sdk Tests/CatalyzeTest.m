//
//  CatalyzeTest.m
//  catalyze-ios-sdk Tests
//
//  Created by Josh Ault on 8/19/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CatalyzeTest.h"
#import "Catalyze.h"

@interface CatalyzeTest()

@end

@implementation CatalyzeTest

//the following values are generated for test environments and inserted manually for now
static const NSString *username = @"test@catalyze.io";
static const NSString *password = @"password";
static const NSString *apiKey = @"ios io.catalyze.Mobile-Mom 41f97026-ac41-431a-897e-fbf0ca5e2398";
static const NSString *appId = @"6cc12315-f1d3-4072-a059-a6ec893ac899";

//class level
+ (void)setUp {
    [super setUp];
    
    __block BOOL finished = NO;
    
    [Catalyze setApiKey:apiKey.copy applicationId:appId.copy];
    
    [CatalyzeUser logInWithUsernameInBackground:username.copy password:password.copy block:^(int status, NSString *response, NSError *error) {
        if (error) {
            [NSException raise:@"AuthenticationException" format:@"Could not login"];
        }
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

+ (void)tearDown {
    __block BOOL finished = NO;
    
    [[CatalyzeUser currentUser] logoutWithBlock:^(int status, NSString *response, NSError *error) {
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super tearDown];
}

@end
