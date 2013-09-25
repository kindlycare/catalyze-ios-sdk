//
//  AFNetworkingClient.h
//  Catalyze iOS SDK
//
//  Created by dev on 6/4/13.
//  Copyright (c) 2013 Catalyze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetworkingClient : NSObject {
    AFHTTPClient *client;
}

+ (AFNetworkingClient *)sharedInstance;

@end
