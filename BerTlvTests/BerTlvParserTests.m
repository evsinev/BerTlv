//
//  BerTlvTests.m
//  BerTlvTests
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BerTag.h"
#import "HexUtil.h"
#import "BerTlvParser.h"
#import "BerTlv.h"

void assertTag(BerTag *aExpected, BerTag *actual);

@interface BerTlvParserTests : XCTestCase

@end


@implementation BerTlvParserTests

NSString *hex =
        /*            0  1  2  3   4  5  6  7     8  9  a  b   c  d  e  f      0123 4567  89ab  cdef */
        /*    0 */ @"e1 35 9f 1e  08 31 36 30    32 31 34 33  37 ef 12 df" // .5.. .160  2143  7...
        /*   10 */ @"0d 08 4d 30  30 30 2d 4d    50 49 df 7f  04 31 2d 32" // ..M0 00-M  PI..  .1-2
        /*   20 */ @"32 ef 14 df  0d 0b 4d 30    30 30 2d 54  45 53 54 4f" // 2... ..M0  00-T  ESTO
        /*   30 */ @"53 df 7f 03  36 2d 35                               " // S... 6-5
;

- (void)testParse {

    NSData *data = [HexUtil parse:hex];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlv *tlv = [parser parseConstructed:data];
    [self assertTag:[BerTag parse:@"e1"] actual:tlv.tag];
    XCTAssertTrue(3 == tlv.list.count, @"");

    BerTlv *_0_9f1e = [tlv.list objectAtIndex:0];
    [self assertTag:[BerTag parse:@"9F1E"] actual:_0_9f1e.tag];
    [self assertHex:@"3136303231343337" actual:[HexUtil format:_0_9f1e.value]];
}

- (void)assertTag:(BerTag *)aExpected actual: (BerTag *)aActual {
    XCTAssertTrue([aExpected isEqualToTag:aActual], @"Expected %@ but actual is %@", aExpected, aActual);
}

- (void)assertHex:(NSString *)aExpected actual:(NSString *)aHex {
    NSData *data = [HexUtil parse:aHex];
    NSString *actual = [HexUtil format:data];
    // NSLog(@"%@ -> %@", aHex, actual);

    XCTAssertTrue([aExpected isEqualToString:actual], @"Expected %@ but actual %@", aExpected, actual);
}


@end

