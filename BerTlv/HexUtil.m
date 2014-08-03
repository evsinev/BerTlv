//
// Created by Evgeniy Sinev on 04/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import "HexUtil.h"


@implementation HexUtil {


}

+ (NSString *)format:(NSData *)aData {
    NSMutableString *sb = [[NSMutableString alloc] initWithCapacity:aData.length*2];
    uint8_t const *bytes = aData.bytes;
    for(uint8_t i=0; i<aData.length; i++) {
        uint8_t b = bytes[i];
        [sb appendFormat:@"%02X", b];
    }
    return sb;
}


@end