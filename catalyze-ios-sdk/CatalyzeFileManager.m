//
//  CatalyzeFileManager.m
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 8/21/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import "CatalyzeFileManager.h"
#import "AFNetworking.h"
#import "Catalyze.h"

@interface CatalyzeFileManager()

@end

@implementation CatalyzeFileManager

+ (AFHTTPRequestOperationManager *)fileClient {
    static AFHTTPRequestOperationManager *fileClient = nil;
    static dispatch_once_t onceFilePredicate;
    dispatch_once(&onceFilePredicate, ^{
        fileClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kCatalyzeBaseURL]];
#ifdef LOCAL_ENV
        fileClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        fileClient.securityPolicy.allowInvalidCertificates = YES;
#endif
        //fileClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        fileClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        [fileClient.operationQueue setMaxConcurrentOperationCount:1];
    });
    return fileClient;
}

+ (void)uploadFileToUser:(NSData *)file phi:(BOOL)phi mimeType:(NSString *)mimeType block:(CatalyzeJsonResultBlock)block {
    NSLog(@"-1");
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    NSLog(@"-2");
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    NSLog(@"-3");
    [[CatalyzeFileManager fileClient] POST:@"/v2/users/files" parameters:@{@"phi":[NSNumber numberWithBool:phi]} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"-4");
        [formData appendPartWithFileData:file name:@"file" fileName:@"filename" mimeType:mimeType];
        NSLog(@"-4-2");
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-5");
        if (!responseObject) {
            responseObject = @"";
        }
        NSLog(@"-6");
        block([NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil], (int)[[operation response] statusCode], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-7");
        block(nil, (int)[[operation response] statusCode], error);
    }];
}

+ (void)listFiles:(CatalyzeHTTPArrayResponseBlock)block {
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeFileManager fileClient] GET:@"/v2/users/files" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            responseObject = @"";
        }
        block((int)[[operation response] statusCode], [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block((int)[[operation response] statusCode], nil, error);
    }];
}

+ (void)retrieveFile:(NSString *)filesId block:(CatalyzeDataResultBlock)block {
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeFileManager fileClient] GET:[NSString stringWithFormat:@"/v2/users/files/%@",filesId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, (int)[[operation response] statusCode], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, (int)[[operation response] statusCode], error);
    }];
}

+ (void)deleteFile:(NSString *)filesId block:(CatalyzeBooleanResultBlock)block {
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeFileManager fileClient] DELETE:[NSString stringWithFormat:@"/v2/users/files/%@",filesId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(YES, (int)[[operation response] statusCode], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO, (int)[[operation response] statusCode], error);
    }];
}

+ (void)uploadFileToOtherUser:(NSData *)file usersId:(NSString *)usersId phi:(BOOL)phi mimeType:(NSString *)mimeType block:(CatalyzeJsonResultBlock)block {
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeFileManager fileClient] POST:[NSString stringWithFormat:@"/v2/users/%@/files",usersId] parameters:@{@"phi":[NSNumber numberWithBool:phi]} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:file name:@"file" fileName:@"filename" mimeType:mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            responseObject = @"";
        }
        block([NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil], (int)[[operation response] statusCode], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, (int)[[operation response] statusCode], error);
    }];
}

+ (void)listFilesForUser:(NSString *)usersId block:(CatalyzeHTTPArrayResponseBlock)block {
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeFileManager fileClient] GET:[NSString stringWithFormat:@"/v2/users/%@/files", usersId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            responseObject = @"";
        }
        block((int)[[operation response] statusCode], [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block((int)[[operation response] statusCode], nil, error);
    }];
}

+ (void)retrieveFileFromUser:(NSString *)filesId usersId:(NSString *)usersId block:(CatalyzeDataResultBlock)block {
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeFileManager fileClient] GET:[NSString stringWithFormat:@"/v2/users/%@/files/%@",usersId,filesId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, (int)[[operation response] statusCode], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, (int)[[operation response] statusCode], error);
    }];
}

+ (void)deleteFileFromUser:(NSString *)filesId usersId:(NSString *)usersId block:(CatalyzeBooleanResultBlock)block {
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeFileManager fileClient] DELETE:[NSString stringWithFormat:@"/v2/users/%@/files/%@",usersId,filesId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(YES, (int)[[operation response] statusCode], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO, (int)[[operation response] statusCode], error);
    }];
}

@end
