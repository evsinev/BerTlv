//
//  BerTlvTests.m
//  BerTlvTests
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BerTag.h"
#import "BerTlvBuilder.h"
#import "HexUtil.h"
#import "BerTlv.h"
#import "BerTlvs.h"

@interface BerTlvBuilderTests : XCTestCase

@end


@implementation BerTlvBuilderTests {
    BerTag *TAG_E0;
    BerTag *TAG_86;
    BerTag *TAG_50;
    BerTag *TAG_57;
    BerTag *TAG_PRIMITIVE;

}

- (void)setUp {
    [super setUp];

    TAG_E0   = [BerTag parse:@"E0"];
    TAG_50   = [BerTag parse:@"50"];
    TAG_57   = [BerTag parse:@"57"];
    TAG_86   = [BerTag parse:@"86"];
    TAG_PRIMITIVE   = [BerTag parse:@"86"];
}


- (void)testInit {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];
    [builder addHex:@"56495341" tag:TAG_50];
    [builder addHex:@"1000023100000033D44122011003400000481F" tag:TAG_57];
    NSData *data = builder.buildData;

    //    - [50] 56495341
    //    - [57] 1000023100000033D44122011003400000481F
    NSString *expected =
        /*            0  1  2  3   4  5  6  7     8  9  a  b   c  d  e  f      0123 4567  89ab  cdef */
        /*    0 */   @"50 04 56 49  53 41 57 13    10 00 02 31  00 00 00 33" // P.VI SAW.  ...1  ...3
        /*   10 */   @"d4 41 22 01  10 03 40 00    00 48 1f                " // .A". ..@.  .H.
    ;

    [self assertHex:expected actual:data];
    BerTlvs *tlvs = builder.buildTlvs;
    XCTAssertEqual(2, tlvs.list.count);
    NSLog(@"data is\n%@", [tlvs dump:@"  "]);
}

- (void) testInitWithTemplate {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTemplate:TAG_E0];
    for(int i=0; i<10; i++) {
        [builder addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    }

    BerTlvs *tlvs = builder.buildTlvs;
    XCTAssertEqual(1, tlvs.list.count);
    XCTAssertEqual(10, [tlvs findAll:TAG_86].count);

    NSLog(@"data is\n%@", [builder.buildTlvs dump:@"  "]);
}

- (void) testInitWithPrimitiveTlv {

    BerTlv *primitiveTlv = [[BerTlv alloc] init:TAG_86 value:[HexUtil parse:@"F9128478E28F860D8424000008514C8F"]];

    BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTlv:primitiveTlv];

    [self assertHex:@"8610F9128478E28F860D8424000008514C8F" actual:builder.buildData];
    XCTAssertTrue(builder.buildTlv.primitive);
    NSLog(@"testInitWithPrimitiveTlv = \n%@", [builder.buildTlv dump:@"  "]);
}

- (void) testInitWithConstructedTlv {

    BerTlvBuilder *b0 = [[BerTlvBuilder alloc] initWithTemplate:TAG_E0];
    for(int i=0; i<10; i++) {
        [b0 addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    }

    BerTlv *constructedTlv = b0.buildTlv;

    BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTlv:constructedTlv];

    BerTlv *stage1 = builder.buildTlv;
    XCTAssertTrue(stage1.constructed);
    XCTAssertEqual(10, stage1.list.count);
    XCTAssertEqual(10, [stage1 findAll:TAG_86].count);

    [builder addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    BerTlv *stage2 = builder.buildTlv;
    XCTAssertTrue(stage2.constructed);
    XCTAssertEqual(11, stage2.list.count);
    XCTAssertEqual(11, [stage2 findAll:TAG_86].count);
    NSLog(@"testInitWithConstructedTlv = \n%@", [b0.buildTlv dump:@"  "]);
}


- (void)testAddText {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];
    [builder addText:@"12345" tag:TAG_PRIMITIVE];
    [self assertHex:@"86053132333435" actual:builder.buildData];
}

- (void)testAddBcd {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];
    [builder addBcd:12345 tag:TAG_PRIMITIVE length:6];
    [self assertHex:@"8606000000012345" actual:builder.buildData];
}

- (void)testAddAmount {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];
    NSDecimalNumber * amount = [[NSDecimalNumber alloc] initWithString:@"1234.56"];
    [builder addAmount:amount tag:TAG_PRIMITIVE];
    [self assertHex:@"8606000000123456" actual:builder.buildData];
}

- (void)testAddDate {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];

    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyMMdd"];
    NSDate *date = [dateFormat dateFromString:@"140701"];

    [builder addDate:date tag:TAG_PRIMITIVE];

    [self assertHex:@"8603140701" actual:builder.buildData];
}

- (void)testAddTime {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];

    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"HHmmss"];
    NSDate *date = [dateFormat dateFromString:@"160630"];

    [builder addTime:date tag:TAG_PRIMITIVE];

    [self assertHex:@"8603160630" actual:builder.buildData];
}



- (void)assertHex:(NSString *)aExpected actual:(NSData *)aData {
    NSData   *expectedData = [HexUtil parse:aExpected];
    NSString *expectedHex = [HexUtil format:expectedData];
    // NSLog(@"%@ -> %@", aHex, actual);

    NSString *actualHex = [HexUtil format:aData];
    XCTAssertTrue([expectedHex isEqualToString:actualHex], @"Expected %@ but actual was %@", expectedHex, actualHex);
}

- (void) testInitWithTlvs {

    BerTlvBuilder *b0 = [[BerTlvBuilder alloc] init];
    for(int i=0; i<10; i++) {
        [b0 addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    }

    BerTlvs *constructedTlvs = b0.buildTlvs;
    NSLog(@"testInitWithTlvs constructedTlv = \n%@", [b0.buildTlv dump:@"  "]);

    BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTlvs:constructedTlvs];

    BerTlvs *stage1 = builder.buildTlvs;
    NSLog(@"testInitWithTlvs stage1 = \n%@", [b0.buildTlv dump:@"  "]);
    XCTAssertEqual(10, stage1.list.count);
    XCTAssertEqual(10, [stage1 findAll:TAG_86].count);

    [builder addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    BerTlvs *stage2 = builder.buildTlvs;
    XCTAssertEqual(11, stage2.list.count);
    XCTAssertEqual(11, [stage2 findAll:TAG_86].count);
    NSLog(@"testInitWithTlvs = \n%@", [b0.buildTlv dump:@"  "]);
}


@end

