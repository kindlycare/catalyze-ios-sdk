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

#import "Catalyze.h"

@implementation Catalyze

+ (void)setApplicationKey:(NSString *)applicationKey URLScheme:(NSString *)scheme applicationId:(NSNumber *)appId {
    [[NSUserDefaults standardUserDefaults] setValue:applicationKey forKey:@"app_key"];
    [[NSUserDefaults standardUserDefaults] setValue:scheme forKey:@"url_scheme"];
    [[NSUserDefaults standardUserDefaults] setValue:appId forKey:@"app_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    (void)[[CatalyzeUser alloc] init];
}

+ (NSString *)applicationKey {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"app_key"]) {
        NSLog(@"Warning! Application key not set! Please call [Catalyze setApplicationId:URLScheme:applicationId:] in your AppDelegate's applcatinDidFinishLaunchingWithOptions: method");
    }
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"app_key"];
}

+ (NSString *)URLScheme {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"url_scheme"]) {
        NSLog(@"Warning! URL Scheme not set! Please call [Catalyze setApplicationId:URLScheme:applicationId:] in your AppDelegate's applcatinDidFinishLaunchingWithOptions: method");
    }
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"url_scheme"];
}

+ (NSString *)applicationId {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"]) {
        NSLog(@"Warning! Application id not set! Please call [Catalyze setApplicationId:URLScheme:applicationId:] in your AppDelegate's applcatinDidFinishLaunchingWithOptions: method");
    }
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"];
}

+ (void)handleOpenURL:(NSURL *)url withBlock:(CatalyzeHandleOpenURLBlock)block {
    BOOL authenticated = NO;
    BOOL new = NO;
    for (NSString *s in [[url query] componentsSeparatedByString:@"&"]) {
        NSArray *part = [s componentsSeparatedByString:@"="];
        if ([[part objectAtIndex:0] isEqualToString:@"userId"]) {
            NSLog(@"found userId: %@",[part objectAtIndex:1]);
            [[NSUserDefaults standardUserDefaults] setInteger:[[part objectAtIndex:1] integerValue] forKey:@"catalyze_user_id"];
        } else if ([[part objectAtIndex:0] isEqualToString:@"sessionToken"]) {
            NSLog(@"found sessionToken: %@",[part objectAtIndex:1]);
            [[NSUserDefaults standardUserDefaults] setValue:[part objectAtIndex:1] forKey:@"Authorization"];
        } else if ([[part objectAtIndex:0] isEqualToString:@"new"]) {
            NSLog(@"found new: %@",[part objectAtIndex:1]);
            new = [[part objectAtIndex:1] boolValue];
        } else if ([[part objectAtIndex:0] isEqualToString:@"authorized"]) {
            NSLog(@"found authorized: %@",[part objectAtIndex:1]);
            authenticated = [[part objectAtIndex:1] boolValue];
        }
    }
    block(authenticated, new);
}

@end
