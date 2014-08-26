/*
 * Copyright (C) 2013 catalyze.io, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CatalyzeTest.h"
#import "Catalyze.h"

@interface CatalyzeTest()

@end

@implementation CatalyzeTest

//the following values are generated for test environments and inserted manually for now
static const NSString * const username = @"test@catalyze.io";
static const NSString * const password = @"password";
static const NSString * const apiKey = @"ios io.catalyze.Mobile-Mom 36580477-acc7-4776-af2e-6a9226c8fb61";
static const NSString * const appId = @"77cfb302-fe46-4ade-94d7-5bc388ecfc47";
const NSString * const secondaryUsername = @"test-secondary@catalyze.io";
const NSString * const secondaryPassword = @"password";
const NSString * const secondaryUsersId = @"429e26b8-ec81-472a-84e1-27208a62c49a";

//class level
+ (void)setUp {
    [super setUp];
    
    __block BOOL finished = NO;
    
    [Catalyze setApiKey:apiKey.copy applicationId:appId.copy baseUrl:@"https://10.0.1.4:8443"];
    
    [CatalyzeUser logInWithUsernameInBackground:username.copy password:password.copy success:^(CatalyzeUser *result) {
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [NSException raise:@"AuthenticationException" format:@"Could not login"];
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

+ (void)tearDown {
    __block BOOL finished = NO;
    
    [[CatalyzeUser currentUser] logoutWithSuccess:^(id result) {
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super tearDown];
}

@end
