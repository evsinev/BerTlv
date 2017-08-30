//
//  BerTlvTests.m
//  BerTlvTests
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BerTlv.h"
#import "BerTlvParser.h"
#import "HexUtil.h"
#import "BerTag.h"

@interface BerTlvTests : XCTestCase

@end


@implementation BerTlvTests {

    BerTlv *tlv;
    NSString *hex;

    BerTag *TAG_DF7F;
    BerTag *TAG_9F1E;
    BerTag *TAG_E1;
    BerTag *TAG_E2;
    BerTag *TAG_DF0D;
}

- (void)setUp {
    [super setUp];

    // + [E1]
    //    - [9F1E] 3136303231343337
    //    + [EF]
    //        - [DF0D] 4D3030302D4D5049
    //        - [DF7F] 312D3232
    //    + [EF]
    //        - [DF0D] 4D3030302D544553544F53
    //        - [DF7F] 362D35
    hex =
        /*            0  1  2  3   4  5  6  7     8  9  a  b   c  d  e  f      0123 4567  89ab  cdef */
        /*    0 */ @"e1 35 9f 1e  08 31 36 30    32 31 34 33  37 ef 12 df" // .5.. .160  2143  7...
        /*   10 */ @"0d 08 4d 30  30 30 2d 4d    50 49 df 7f  04 31 2d 32" // ..M0 00-M  PI..  .1-2
        /*   20 */ @"32 ef 14 df  0d 0b 4d 30    30 30 2d 54  45 53 54 4f" // 2... ..M0  00-T  ESTO
        /*   30 */ @"53 df 7f 03  36 2d 35                               " // S... 6-5
    ;

    NSData *data = [HexUtil parse:hex];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    tlv = [parser parseConstructed:data error:nil];

    TAG_DF7F   = [BerTag parse:@"DF 7F"];
    TAG_9F1E   = [BerTag parse:@"9F 1E"];
    TAG_E1     = [BerTag parse:@"E1"];
    TAG_E2     = [BerTag parse:@"E2"];
    TAG_DF0D   = [BerTag parse:@"DF0D"];
}

- (void)testFind {
    XCTAssertNotNil([tlv find:TAG_E1]);
    XCTAssertNotNil([tlv find:TAG_9F1E]);
    XCTAssertNotNil([tlv find:TAG_DF7F]);
    XCTAssertNil   ([tlv find:TAG_E2]  );
}

- (void)testFindAll {
    XCTAssertEqual(1, [tlv findAll:TAG_E1].count);
    XCTAssertEqual(1, [tlv findAll:TAG_9F1E].count);
    XCTAssertEqual(2, [tlv findAll:TAG_DF7F].count);
    XCTAssertEqual(0, [tlv findAll:TAG_E2].count);
}

- (void)testTextValue {
    [self assertString:@"16021437" actual:[tlv find:TAG_9F1E].textValue];
    [self assertString:@"1-22"     actual:[tlv find:TAG_DF7F].textValue];
    [self assertString:@"M000-MPI" actual:[tlv find:TAG_DF0D].textValue];
}

- (void)testHexValue {
    [self assertString:@"4D3030302D4D5049" actual:[tlv find:TAG_DF0D].hexValue];
}

//- (void)testIntValue {
//    XCTAssertEqual(5561998523279167561, [tlv find:TAG_DF0D].intValue);
//}


- (void)assertString:(NSString *)aExpected actual:(NSString *)aActual {
    XCTAssertTrue([aExpected isEqualToString:aActual], "Expected %@ but actual is %@", aExpected, aActual);
}

- (void)testDescription {

    NSLog(@"\n%@", [tlv dump:@"  "]);
}
@end
