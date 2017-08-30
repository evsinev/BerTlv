//
// Created by Evgeniy Sinev on 04/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import "BerTag.h"
#import "HexUtil.h"


@implementation BerTag {
}

@synthesize data;

- (id)init:(NSData *)aData offset:(uint)aOffset length:(uint)aLength {
    self = [super init];
    if(self) {
        if (aOffset + aLength <= aData.length) {
            NSRange range = {aOffset, aLength};
            data = [aData subdataWithRange:range];
        } else {
            return nil;
        }
    }
    return self;
}

- (id)init:(uint8_t)aFirstByte {
    self = [super init];
    if(self) {
        data = [NSData dataWithBytes:&aFirstByte length:1];
    }
    return self;
}

- (id)init:(uint8_t)aFirstByte secondByte:(uint8_t)aSecondByte {
    self = [super init];
    if(self) {
        uint8_t bytes[2];
        bytes[0] = aFirstByte;
        bytes[1] = aSecondByte;
        data = [NSData dataWithBytes:bytes length:2];
    }
    return self;
}

- (id)init:(uint8_t)aFirstByte secondByte:(uint8_t)aSecondByte thirdByte:(uint8_t)aThirdByte {
    self = [super init];
    if(self) {
        uint8_t bytes[3];
        bytes[0] = aFirstByte;
        bytes[1] = aSecondByte;
        bytes[2] = aThirdByte;
        data = [NSData dataWithBytes:bytes length:3];
    }
    return self;
}

- (BOOL)isConstructed {
    if (!data) return true;
    uint8_t *bytes = (uint8_t *) data.bytes;
    // 0x20
    return (bytes[0] & 0b00100000) != 0;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }

    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    return [self isEqualToTag:other];
}

- (BOOL)isEqualToTag:(BerTag *)tag {
    if (self == tag) {
        return YES;
    }

    if (tag == nil) {
        return NO;
    }

    return !(data != tag->data && ![data isEqualToData:tag->data]);
}

- (NSUInteger)hash {
    return [data hash];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithCapacity:data.length+2];
    if(self.isConstructed) {
        [description appendFormat:@"+ "];
    } else {
        [description appendFormat:@"- "];
    }
    [description appendFormat:@"%@", [HexUtil format:data]];
    return description;
}

+ (BerTag *)parse:(NSString *)aHexString {
    NSData *data = [HexUtil parse:aHexString];
    return [[BerTag alloc] init:data offset:0 length:(uint)data.length];
}

- (NSString *)hex {
    return [HexUtil format:data];
}

@end
