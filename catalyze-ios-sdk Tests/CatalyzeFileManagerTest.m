//
//  CatalyzeFileManagerTest.m
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 8/21/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Catalyze.h"
#import "CatalyzeTest.h"

@interface CatalyzeFileManagerTest : CatalyzeTest

@end

@implementation CatalyzeFileManagerTest

- (NSString *)uploadFile:(NSData *)data expectedStatus:(int)expectedStatus {
    __block NSString *filesId = nil;
    
    [CatalyzeFileManager uploadFileToUser:data phi:NO mimeType:@"text/plain" block:^(NSDictionary *json, int status, NSError *error) {
        XCTAssertEqual(expectedStatus, status, @"Unexpected status %i - %@", status, error.localizedDescription);
        filesId = [json valueForKey:@"filesId"];
        if (!filesId) filesId = @"";
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (filesId == nil && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    return filesId;
}

- (void)testUploadFileToUser {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data expectedStatus:200];
    XCTAssertNotNil(filesId, @"filesId not returned from upload");
}

- (void)testListFiles {
    
}

- (void)testRetrieveFile {
    
}

- (void)testDeleteFile {
    
}

- (void)testUploadFileToOtherUser {
    
}

- (void)testListFilesForUser {
    
}

- (void)testRetrieveFileFromUser {
    
}

- (void)testDeleteFileFromUser {
    
}

@end
