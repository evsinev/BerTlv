//
// Created by Evgeniy Sinev on 04/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import "HexUtil.h"

static uint8_t HEX_BYTES[] = {
       // 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
         99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99
/* 0 */, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99
/* 1 */, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99
/* 2 */,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 99, 99, 99, 99, 99, 99
/* 3 */, 99, 10, 11, 12, 13, 14, 15, 99, 99, 99, 99, 99, 99, 99, 99, 99
/* 4 */, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99
/* 5 */, 99, 10, 11, 12, 13, 14, 15, 99, 99, 99, 99, 99, 99, 99, 99, 99
/* 6 */, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99
};

static uint8_t HEX_BYTES_LEN = 128;
static uint8_t HEX_BYTE_SKIP = 99;


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

+ (NSData *)parse:(NSString *)aHex {
    char const *text = [aHex cStringUsingEncoding:NSASCIIStringEncoding];
    size_t len = strnlen(text, aHex.length);

    uint8_t high = 0;
    BOOL highPassed = NO;

    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:len/2];

    for(int i=0; i< len; i++) {
        char index = text[i];

        // checks if value out of 127 (ASCII must contains from 0 to 127)
        if(index >= HEX_BYTES_LEN ) {
            continue;
        }

        uint8_t nibble = HEX_BYTES[index];

        // checks if not HEX chars
        if(nibble == HEX_BYTE_SKIP) {
            continue;
        }

        if(highPassed) {
            // fills right nibble, creates byte and adds it
            uint8_t low = (uint8_t) (nibble & 0x7f);
            highPassed = NO;
            uint8_t currentByte = ((high << 4) + low);
            [data appendBytes:&currentByte length:1];

        } else {
            // fills left nibble
            high = (uint8_t) (nibble & 0x7f);
            highPassed = YES;
        }
    }

    // returns immutable
    return [NSData dataWithData:data];
}


@end