//
//  BerTlvErrors.m
//  BerTlv
//
//  Created by Alex Kent on 2017-08-30.
//  Copyright © 2017 Evgeniy Sinev. All rights reserved.
//

#import "BerTlvErrors.h"

@implementation BerTlvErrors

+ (NSError *)invalidHexString {
    return [[NSError alloc] initWithDomain:@"com.payneteasy.BerTlvFramework" code:2 userInfo: @{NSLocalizedDescriptionKey : NSLocalizedString(@"Invalid Hex string", "Invalid hex string")}];
}

@end
