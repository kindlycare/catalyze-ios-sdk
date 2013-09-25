//
//  AFNetworkingClient.m
//  Catalyze iOS SDK
//
//  Created by dev on 6/4/13.
//  Copyright (c) 2013 Catalyze. All rights reserved.
//

#import "AFNetworkingClient.h"

@implementation AFNetworkingClient

static AFNetworkingClient *sharedInstance = nil;

+ (AFNetworkingClient *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

#pragma mark - Private Singleton

- (id)init {
    self = [super init];
    
    if (self) {
        client = nil;
    }
    
    return self;
}

- (AFHTTPClient *)visit {
    if (client == nil) {
        client = [[AFHTTPClient alloc] init];
    }
    return client;
}

@end
