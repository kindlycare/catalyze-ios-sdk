//
//  CatalyzeObjectTest.m
//  catalyze-ios-sdk Tests
//
//  Created by Josh Ault on 8/19/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Catalyze.h"
#import "CatalyzeTest.h"

@interface CatalyzeObjectTest : CatalyzeTest

@end

@implementation CatalyzeObjectTest
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
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
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
    CatalyzeEntry *entry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [entry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [entry createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertNotNil(entry.entryId, @"entryId not populated");
    XCTAssertNotNil(entry.parentId, @"parentId not populated");
    XCTAssertNotNil(entry.authorId, @"authorId not populated");
    XCTAssertEqualObjects(entry.content, content, @"content incorrect");
    XCTAssertNotNil(entry.createdAt, @"createdAt not populated");
    XCTAssertNotNil(entry.updatedAt, @"updatedAt not populated");
}

- (void)testRetrieve {
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myEntry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myEntry createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        CatalyzeEntry *retrieveEntry = [CatalyzeEntry entryWithClassName:className.copy];
        [retrieveEntry setEntryId:myEntry.entryId];
        [retrieveEntry retrieveInBackgroundWithBlock:^(CatalyzeEntry *entry, NSError *error) {
            XCTAssertEqualObjects(entry.entryId, retrieveEntry.entryId, @"\"entryId\" not set on retrieved object");
            XCTAssertEqualObjects(entry.parentId, retrieveEntry.parentId, @"\"parentId\" not set on retrieved object");
            XCTAssertEqualObjects(entry.authorId, retrieveEntry.authorId, @"\"authorId\" not set on retrieved object");
            XCTAssertEqualObjects(entry.content, retrieveEntry.content, @"\"content\" not set on retrieved object");
            XCTAssertEqualObjects(entry.createdAt, retrieveEntry.createdAt, @"\"createdAt\" not set on retrieved object");
            XCTAssertEqualObjects(entry.updatedAt, retrieveEntry.updatedAt, @"\"updatedAt\" not set on retrieved object");
            
            XCTAssertEqualObjects(myEntry.entryId, retrieveEntry.entryId, @"\"entryId\" not equivalent");
            XCTAssertEqualObjects(myEntry.parentId, retrieveEntry.parentId, @"\"parentId\" not equivalent");
            XCTAssertEqualObjects(myEntry.authorId, retrieveEntry.authorId, @"\"authorId\" not equivalent");
            XCTAssertEqualObjects(myEntry.content, retrieveEntry.content, @"\"content\" not equivalent");
            XCTAssertEqualObjects(myEntry.createdAt, retrieveEntry.createdAt, @"\"createdAt\" not equivalent");
            XCTAssertEqualObjects(myEntry.updatedAt, retrieveEntry.updatedAt, @"\"updatedAt\" not equivalent");
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
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myEntry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myEntry createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [[myEntry content] setObject:[NSNumber numberWithInt:1] forKey:@"frequency"];
        [myEntry saveInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
            XCTAssertNotNil(myEntry.entryId, @"\"entryId\" not set on object");
            XCTAssertNotNil(myEntry.parentId, @"\"parentId\" not set on object");
            XCTAssertNotNil(myEntry.authorId, @"\"authorId\" not set on object");
            XCTAssertNotNil(myEntry.content, @"\"content\" not set on object");
            XCTAssertNotNil(myEntry.createdAt, @"\"createdAt\" not set on object");
            XCTAssertNotNil(myEntry.updatedAt, @"\"updatedAt\" not set on object");
            
            XCTAssertEqual([[myEntry.content objectForKey:@"frequency"] intValue], 1, @"Updated field is incorrect");
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
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myEntry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myEntry createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [myEntry deleteInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
            XCTAssertNil(myEntry.entryId, @"\"entryId\" not unset on object");
            XCTAssertNil(myEntry.parentId, @"\"parentId\" not unset on object");
            XCTAssertNil(myEntry.authorId, @"\"authorId\" not unset on object");
            XCTAssertNil(myEntry.content, @"\"content\" not unset on object");
            XCTAssertNil(myEntry.createdAt, @"\"createdAt\" not unset on object");
            XCTAssertNil(myEntry.updatedAt, @"\"updatedAt\" not unset on object");
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
