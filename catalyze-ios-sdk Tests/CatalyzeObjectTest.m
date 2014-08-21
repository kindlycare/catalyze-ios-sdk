//
//  catalyze_ios_sdk_Tests.m
//  catalyze-ios-sdk Tests
//
//  Created by Josh Ault on 8/19/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Catalyze.h"

@interface CatalyzeObjectTest : XCTestCase

@end

@implementation CatalyzeObjectTest

//the following values are generated for test environments and inserted manually for now
static const NSString *className = @"medications";
static const NSString *username = @"test@catalyze.io";
static const NSString *password = @"password";
static const NSString *apiKey = @"ios io.catalyze.Mobile-Mom b48139f0-0446-45fa-a719-0cc2206e68fa";
static const NSString *appId = @"a8d199d4-5601-4f07-bd5a-f9d7890969e0";

//class level
+ (void)setUp {
    [super setUp];
    
    __block BOOL finished = NO;
    
    [Catalyze setApiKey:apiKey.copy applicationId:appId.copy];
    
    [CatalyzeUser logInWithUsernameInBackground:username.copy password:password.copy block:^(int status, NSString *response, NSError *error) {
        if (error) {
            [NSException raise:@"AuthenticationException" format:@"Could not login"];
        }
        
        NSDictionary *customClass = @{@"name":className, @"schema":@{@"medication":@"string", @"frequency":@"integer"}};
        [CatalyzeHTTPManager doPost:@"/classes" withParams:customClass block:^(int status, NSString *response, NSError *error) {
            if (error) {
                [NSException raise:@"CustomClassException" format:@"Could not create the custom class"];
            }
            finished = YES;
        }];
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
        [[CatalyzeUser currentUser] logoutWithBlock:^(int status, NSString *response, NSError *error) {
            finished = YES;
        }];
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

- (void)testCreate {
    CatalyzeObject *object = [CatalyzeObject objectWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [object setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [object createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertNotNil(object.entryId, @"entryId not populated");
    XCTAssertNotNil(object.parentId, @"parentId not populated");
    XCTAssertNotNil(object.authorId, @"authorId not populated");
    XCTAssertEqualObjects(object.content, content, @"content incorrect");
    XCTAssertNotNil(object.createdAt, @"createdAt not populated");
    XCTAssertNotNil(object.updatedAt, @"updatedAt not populated");
}

- (void)testRetrieve {
    CatalyzeObject *myObject = [CatalyzeObject objectWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myObject setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myObject createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        CatalyzeObject *retrieveObject = [CatalyzeObject objectWithClassName:className.copy];
        [retrieveObject setEntryId:myObject.entryId];
        [retrieveObject retrieveInBackgroundWithBlock:^(CatalyzeObject *object, NSError *error) {
            XCTAssertEqualObjects(object.entryId, retrieveObject.entryId, @"\"entryId\" not set on retrieved object");
            XCTAssertEqualObjects(object.parentId, retrieveObject.parentId, @"\"parentId\" not set on retrieved object");
            XCTAssertEqualObjects(object.authorId, retrieveObject.authorId, @"\"authorId\" not set on retrieved object");
            XCTAssertEqualObjects(object.content, retrieveObject.content, @"\"content\" not set on retrieved object");
            XCTAssertEqualObjects(object.createdAt, retrieveObject.createdAt, @"\"createdAt\" not set on retrieved object");
            XCTAssertEqualObjects(object.updatedAt, retrieveObject.updatedAt, @"\"updatedAt\" not set on retrieved object");
            
            XCTAssertEqualObjects(myObject.entryId, retrieveObject.entryId, @"\"entryId\" not equivalent");
            XCTAssertEqualObjects(myObject.parentId, retrieveObject.parentId, @"\"parentId\" not equivalent");
            XCTAssertEqualObjects(myObject.authorId, retrieveObject.authorId, @"\"authorId\" not equivalent");
            XCTAssertEqualObjects(myObject.content, retrieveObject.content, @"\"content\" not equivalent");
            XCTAssertEqualObjects(myObject.createdAt, retrieveObject.createdAt, @"\"createdAt\" not equivalent");
            XCTAssertEqualObjects(myObject.updatedAt, retrieveObject.updatedAt, @"\"updatedAt\" not equivalent");
            finished = YES;
        }];
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

- (void)testUpdate {
    CatalyzeObject *myObject = [CatalyzeObject objectWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myObject setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myObject createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [[myObject content] setObject:[NSNumber numberWithInt:1] forKey:@"frequency"];
        [myObject saveInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
            XCTAssertNotNil(myObject.entryId, @"\"entryId\" not set on object");
            XCTAssertNotNil(myObject.parentId, @"\"parentId\" not set on object");
            XCTAssertNotNil(myObject.authorId, @"\"authorId\" not set on object");
            XCTAssertNotNil(myObject.content, @"\"content\" not set on object");
            XCTAssertNotNil(myObject.createdAt, @"\"createdAt\" not set on object");
            XCTAssertNotNil(myObject.updatedAt, @"\"updatedAt\" not set on object");
            
            XCTAssertEqual([[myObject.content objectForKey:@"frequency"] intValue], 1, @"Updated field is incorrect");
            finished = YES;
        }];
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

- (void)testDelete {
    CatalyzeObject *myObject = [CatalyzeObject objectWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myObject setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myObject createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [myObject deleteInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
            XCTAssertNil(myObject.entryId, @"\"entryId\" not unset on object");
            XCTAssertNil(myObject.parentId, @"\"parentId\" not unset on object");
            XCTAssertNil(myObject.authorId, @"\"authorId\" not unset on object");
            XCTAssertNil(myObject.content, @"\"content\" not unset on object");
            XCTAssertNil(myObject.createdAt, @"\"createdAt\" not unset on object");
            XCTAssertNil(myObject.updatedAt, @"\"updatedAt\" not unset on object");
            finished = YES;
        }];
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

@end
