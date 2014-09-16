//
//  CatalyzeVital.m
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 9/3/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import "CatalyzeVital.h"
#import "CatalyzeObservation.h"
#import "CatalyzeHTTPManager.h"
#import "CatalyzeUser.h"

@implementation CatalyzeVital

- (id)init {
    self = [super init];
    if (self) {
        _extras = [NSMutableDictionary dictionary];
        _observations = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark Create

- (void)createInBackground {
    [self createInBackgroundWithSuccess:nil failure:nil];
}

- (void)createInBackgroundWithSuccess:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager doPost:[NSString stringWithFormat:@"/users/%@/vitals", [CatalyzeHTTPManager percentEncode:[CatalyzeUser currentUser].usersId]] withParams:[self JSON:[CatalyzeVital class]] success:^(id result) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:result];
        dict = [CatalyzeVital modifyDict:dict];
        [self setValuesForKeysWithDictionary:dict];
        
        self.observations = [NSMutableArray arrayWithArray:self.observations]; // to keep mutability
        self.extras = [NSMutableDictionary dictionaryWithDictionary:self.extras]; // to keep mutability
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)createInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self createInBackgroundWithSuccess:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Save

- (void)saveInBackground {
    [self saveInBackgroundWithSuccess:nil failure:nil];
}

- (void)saveInBackgroundWithSuccess:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager doPut:[NSString stringWithFormat:@"/users/%@/vitals/%@", [CatalyzeHTTPManager percentEncode:[CatalyzeUser currentUser].usersId], [CatalyzeHTTPManager percentEncode:_vitalsId]] withParams:[self JSON:[CatalyzeVital class]] success:^(id result) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:result];
        dict = [CatalyzeVital modifyDict:dict];
        [self setValuesForKeysWithDictionary:dict];
        
        self.observations = [NSMutableArray arrayWithArray:self.observations]; // to keep mutability
        self.extras = [NSMutableDictionary dictionaryWithDictionary:self.extras]; // to keep mutability
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self saveInBackgroundWithSuccess:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Retrieve

- (void)retrieveInBackground {
    [self retrieveInBackgroundWithSuccess:nil failure:nil];
}

- (void)retrieveInBackgroundWithSuccess:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager doGet:[NSString stringWithFormat:@"/users/%@/vitals/%@", [CatalyzeHTTPManager percentEncode:[CatalyzeUser currentUser].usersId], [CatalyzeHTTPManager percentEncode:_vitalsId]] success:^(id result) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:result];
        dict = [CatalyzeVital modifyDict:dict];
        [self setValuesForKeysWithDictionary:dict];
        
        self.observations = [NSMutableArray arrayWithArray:self.observations]; // to keep mutability
        self.extras = [NSMutableDictionary dictionaryWithDictionary:self.extras]; // to keep mutability
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self retrieveInBackgroundWithSuccess:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Delete

- (void)deleteInBackground  {
    [self deleteInBackgroundWithSuccess:nil failure:nil];
}

- (void)deleteInBackgroundWithSuccess:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager doDelete:[NSString stringWithFormat:@"/users/%@/vitals/%@", [CatalyzeHTTPManager percentEncode:[CatalyzeUser currentUser].usersId], [CatalyzeHTTPManager percentEncode:_vitalsId]] success:^(id result) {
        _vitalsId = nil;
        _usersId = nil;
        _documentedAt = nil;
        _createdAt = nil;
        _updatedAt = nil;
        _extras = nil;
        _observations = nil;
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)deleteInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self deleteInBackgroundWithSuccess:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark - JSONObject

- (id)JSON:(Class)aClass {
    NSMutableDictionary *dict = [super JSON:aClass];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dict setObject:[formatter stringFromDate:_documentedAt] forKey:@"documentedAt"];
    
    [dict removeObjectForKey:@"observations"];
    if (_observations && _observations.count > 0) {
        NSMutableArray *observations = [NSMutableArray array];
        for (CatalyzeObservation *co in _observations) {
            [observations addObject:[co JSON:[CatalyzeObservation class]]];
        }
        [dict setObject:observations forKey:@"observations"];
    }
    
    [dict removeObjectForKey:@"extras"];
    if (_extras) {
        [dict setObject:_extras forKey:@"extras"];
    }
    return dict;
}

+ (NSMutableDictionary *)modifyDict:(NSMutableDictionary *)dict {
    NSMutableArray *observations = [NSMutableArray array];
    
    if ([dict objectForKey:@"observations"] && [dict objectForKey:@"observations"] != [NSNull null]) {
        for (NSDictionary *observationDict in [dict objectForKey:@"observations"]) {
            CatalyzeObservation *co = [[CatalyzeObservation alloc] init];
            [co setValuesForKeysWithDictionary:observationDict];
            [observations addObject:co];
        }
    }
    [dict setObject:observations forKey:@"observations"];
    
    if ([dict objectForKey:@"extras"] && [dict objectForKey:@"extras"] != [NSNull null]) {
        [dict setObject:[NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"extras"]] forKey:@"extras"];
    }
    return dict;
}

@end
