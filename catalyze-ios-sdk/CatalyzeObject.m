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

#import "CatalyzeObject.h"
#import "AFNetworking.h"
#import "CatalyzeHTTPManager.h"

@interface CatalyzeObject()

@end

@implementation CatalyzeObject

#pragma mark Constructors

+ (CatalyzeObject *)objectWithClassName:(NSString *)className {
    return [[CatalyzeObject alloc] initWithClassName:className];
}

+ (CatalyzeObject *)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary {
    CatalyzeObject *obj = [[CatalyzeObject alloc] initWithClassName:className];
    for (NSString *s in [dictionary allKeys]) {
        [[obj content] setObject:[dictionary objectForKey:s] forKey:s];
    }
    return obj;
}

- (id)initWithClassName:(NSString *)newClassName {
    self = [super init];
    if (self) {
        _content = [[NSMutableDictionary alloc] init];
        self.className = newClassName;
    }
    return self;
}

- (id)init {
    self = [self initWithClassName:@"object"];
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    @try {
        [super setValue:value forKey:key];
    } @catch (NSException *e) {}
}

#pragma mark -
#pragma mark Create

- (void)createInBackground {
    [self createInBackgroundWithBlock:nil];
}

- (void)createInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block {
    [CatalyzeHTTPManager doPost:[self lookupURL:YES] withParams:[self prepSendDict] block:^(int status, NSString *response, NSError *error) {
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            [self setValuesForKeysWithDictionary:responseDict];
        }
        if (block) {
            block(error == nil, status, error);
        }
    }];
}

- (void)createInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId {
    [self createInBackgroundForUserWithUsersId:usersId block:nil];
}

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId block:(CatalyzeBooleanResultBlock)block {
    [CatalyzeHTTPManager doPost:[NSString stringWithFormat:@"/classes/%@/entry/%@",[self className],usersId] withParams:[self prepSendDict] block:^(int status, NSString *response, NSError *error) {
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            [self setValuesForKeysWithDictionary:responseDict];
        }
        if (block) {
            block(error == nil, status, error);
        }
    }];
}

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId target:(id)target selector:(SEL)selector {
    [self createInBackgroundForUserWithUsersId:usersId block:^(BOOL succeeded, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Save

- (void)saveInBackground {
    [self saveInBackgroundWithBlock:nil];
}

- (void)saveInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block {
    [CatalyzeHTTPManager doPut:[self lookupURL:NO] withParams:[self content] block:^(int status, NSString *response, NSError *error) {
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            [self setValuesForKeysWithDictionary:responseDict];
        }
        if (block) {
            block(error == nil, status, error);
        }
    }];
}

- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self saveInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Retrieve

- (void)retrieveInBackground {
    [self retrieveInBackgroundWithBlock:nil];
}

- (void)retrieveInBackgroundWithBlock:(CatalyzeObjectResultBlock)block {
    NSString *url = [self lookupURL:NO];
    [CatalyzeHTTPManager doGet:url block:^(int status, NSString *response, NSError *error) {
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            [self setValuesForKeysWithDictionary:responseDict];
        }
        if (block) {
            block(self, error);
        }
    }];
}

- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self retrieveInBackgroundWithBlock:^(CatalyzeObject *object, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Delete

- (void)deleteInBackground  {
    [self deleteInBackgroundWithBlock:nil];
}

- (void)deleteInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block {
    [CatalyzeHTTPManager doDelete:[self lookupURL:NO] block:^(int status, NSString *response, NSError *error) {
        if (!error) {
            _className = nil;
            _entryId = nil;
            _authorId = nil;
            _parentId = nil;
            _content = nil;
            _updatedAt = nil;
            _createdAt = nil;
        }
        if (block) {
            block(error == nil, status, error);
        }
    }];
}

- (void)deleteInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self deleteInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

#pragma mark - 
#pragma mark Helpers

- (NSString *)lookupURL:(BOOL)post {
    NSString *retval;
    if ([_className isEqualToString:@"reference"]) {
        retval = [NSString stringWithFormat:@"/classes/%@/%@/ref/%@",[self valueForKey:@"__reference_parent_class"],[self valueForKey:@"__reference_parent_id"],[self valueForKey:@"__reference_name"]];
    } else {
        retval = [NSString stringWithFormat:@"/classes/%@/entry",_className];
        if (!post) {
            retval = [NSString stringWithFormat:@"%@/%@",retval,_entryId];
        }
    }
    return retval;
}

- (NSDictionary *)prepSendDict {
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    [sendDict setObject:_content forKey:@"content"];
    return sendDict;
}

@end
