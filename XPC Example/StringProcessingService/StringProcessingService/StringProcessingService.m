// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

#import "StringProcessingService.h"

@implementation StringProcessingService

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)uppercaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
