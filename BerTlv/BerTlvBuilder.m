//
// Created by Evgeniy Sinev on 06/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import "BerTlvBuilder.h"
#import "BerTlv.h"
#import "BerTlvs.h"
#import "BerTag.h"
#import "HexUtil.h"
#import "BerTlvParser.h"
#import "BerTlvErrors.h"


@implementation BerTlvBuilder {
    NSMutableData *data;
    BerTag *templateTag;
}

- (id)init {
    self = [super init];
    if (self) {
        data = [[NSMutableData alloc] initWithCapacity:0xff];
    }

    return self;
}

- (id)initWithTemplate:(BerTag *)aTag {
    self = [super init];
    if (self) {
        data = [[NSMutableData alloc] initWithCapacity:0xff];
        templateTag = aTag;
    }
    return self;
}

- (id)initWithTlv:(BerTlv *)aTlv {
    self = [super init];
    if (self) {
        data = [[NSMutableData alloc] initWithCapacity:0xff];
        if(aTlv.primitive) {
            [self addBytes:aTlv.value tag:aTlv.tag];
        } else {
            templateTag = aTlv.tag;
            for (BerTlv *tlv in aTlv.list) {
                [self addBerTlv:tlv];
            }
        }
    }
    return self;
}

- (id)initWithTlvs:(BerTlvs *)aTlvs {
    self = [super init];
    if (self) {
        data = [[NSMutableData alloc] initWithCapacity:0xff];
        [self addBerTlvs:aTlvs];
    }
    return self;
}

- (BOOL)addBcd:(NSUInteger )aValue tag:(BerTag *)aTag length:(NSUInteger )aLength {
    NSMutableString *hex = [NSMutableString stringWithFormat:@"%@", @(aValue)];
    for(int i=0; hex.length < aLength*2 && i<100; i++) {
        [hex insertString:@"0" atIndex:0];
    }
    return [self addHex:hex tag:aTag];
}

- (BOOL)addAmount:(NSDecimalNumber *)aAmount tag:(BerTag *)aTag {
    NSUInteger cents = [aAmount decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithInt:100]].unsignedIntegerValue;
    return [self addBcd:cents tag:aTag length:6];
}

- (void)addDate:(NSDate *)aDate tag:(BerTag *)aTag {
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyMMdd"];
    NSString *hex =  [dateFormat stringFromDate:aDate];
    [self addHex:hex tag:aTag];
}

- (void)addTime:(NSDate *)aTime tag:(BerTag *)aTag {
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"HHmmss"];
    NSString *hex =  [dateFormat stringFromDate:aTime];
    [self addHex:hex tag:aTag];
}

- (BOOL)addBytes:(NSData *)aBuf tag:(BerTag *)aTag {
    NSData * lenData = [self createLengthData:aBuf.length error:nil];
    if (lenData == nil) {
        return NO;
    }
    
    // TYPE
    [data appendData:aTag.data];

    // LEN
    [data appendData:lenData];

    // VALUE
    [data appendData:aBuf];
    return YES;
}

- (BOOL)addText:(NSString *)aText tag:(BerTag *)aTag {
    NSData *buf = [aText dataUsingEncoding:NSASCIIStringEncoding];
    return [self addBytes:buf tag:aTag];
}

- (BOOL)addHex:(NSString *)aHex tag:(BerTag *)aTag {
    NSData *buf = [HexUtil parse:aHex error:nil];
    return [self addBytes:buf tag:aTag];
}

- (NSData  *) buildData __deprecated {
    return [self buildDataWithError: nil];
}

- (NSData *)buildDataWithError:(NSError **)error {
    // no template tag so can simply return data buffer
    if (templateTag == nil) {
        return data;
    }

    // calculates bytes count for TYPE and LENGTH
    NSUInteger typeBytesCount   = templateTag.data.length;
    NSUInteger lengthBytesCount = [self calcBytesCountForLength:data.length error:error];
    if (lengthBytesCount == 0) {
        return nil;
    }
    
    NSMutableData *ret = [[NSMutableData alloc] initWithCapacity:
                     + typeBytesCount
                     + lengthBytesCount
                     + data.length
    ];

    // TYPE
    [ret appendData:templateTag.data];

    // LENGTH
    NSData *lengthData = [self createLengthData:data.length error:error];
    if (lengthData == nil) {
        return nil;
    }
    [ret appendData:lengthData];

    // VALUE
    [ret appendData:data];

    return ret;
}

- (NSData *)createLengthData:(NSUInteger)aLength error:(NSError **)error {
    if(aLength < 0x80) {
        uint8_t buf[1];
        buf[0] = (uint8_t) aLength;
        return [NSData dataWithBytes:buf length:1];

    } else if (aLength <0x100) {
        uint8_t buf[2];
        buf[0] = 0x81;
        buf[1] = (uint8_t) aLength;
        return [NSData dataWithBytes:buf length:2];

    } else if( aLength < 0x10000) {
        uint8_t buf[3];
        buf[0] = 0x82;
        buf[1] = (uint8_t) (aLength / 0x100);
        buf[2] = (uint8_t) (aLength % 0x100);
        return [NSData dataWithBytes:buf length:3];

    } else if( aLength < 0x1000000 ) {
        uint8_t buf[4];
        buf[0] =  0x83;
        buf[1] = (uint8_t) (aLength / 0x10000);
        buf[2] = (uint8_t) (aLength / 0x100);
        buf[3] = (uint8_t) (aLength % 0x100);
        return [NSData dataWithBytes:buf length:4];

    } else {
        NSLog(@"Length [%lu] is out of range ( > 0x1000000)", (unsigned long) aLength);
        return nil;
    }
}

- (BerTlv *) buildTlv __deprecated {
    return [self buildTlvWithError:nil];
}

- (BerTlv *)buildTlvWithError:(NSError **)error {
    BerTlvParser * parser = [[BerTlvParser alloc] init];
    NSData *builtData = [self buildDataWithError:error];
    return builtData ? [parser parseConstructed:builtData error:error] : nil;
}

- (BerTlvs *) buildTlvs __deprecated {
    return [self buildTlvsWithError:nil];
}

- (BerTlvs *)buildTlvsWithError:(NSError **)error {
    BerTlvParser * parser = [[BerTlvParser alloc] init];
    NSData *builtData = [self buildDataWithError:error];
    return builtData ? [parser parseTlvs:builtData error:error] : nil;
}

- (NSUInteger) calcBytesCountForLength:(NSUInteger)aLength error:(NSError **)error {
    NSUInteger ret;
    if(aLength < 0x80) {
        ret = 1;
    } else if (aLength <0x100) {
        ret = 2;
    } else if( aLength < 0x10000) {
        ret = 3;
    } else if( aLength < 0x1000000 ) {
        ret = 4;
    } else {
        ret = 0;
        if (error) {
            *error = [BerTlvErrors lengthOutOfRange:(unsigned long) aLength];
        }
    }
    return ret;
}


- (BOOL)addBerTlv:(BerTlv *)aTlv {
    // primitive
    if(aTlv.primitive) {
        return [self addBytes:aTlv.value tag:aTlv.tag];

    // constructed
    } else {
        BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTemplate:aTlv.tag];
        for (BerTlv *tlv in aTlv.list) {
            [builder addBerTlv:tlv];
        }
        NSData *builtData = [builder buildDataWithError:nil];
        if (builtData) {
            [data appendData:builtData];
            return YES;
        }
        return NO;
    }
}

- (BOOL)addBerTlvs:(BerTlvs *)aTlvs {
    for (BerTlv *tlv in aTlvs.list) {
        BOOL success = [self addBerTlv:tlv];
        if (!success) {
            return NO;
        }
    }
    return YES;
}


@end
