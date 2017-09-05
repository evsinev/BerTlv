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
    NSError *dataError;
    NSData *data = [builder buildDataWithError:&dataError];
    XCTAssertNil(dataError);
    
    //    - [50] 56495341
    //    - [57] 1000023100000033D44122011003400000481F
    NSString *expected =
        /*            0  1  2  3   4  5  6  7     8  9  a  b   c  d  e  f      0123 4567  89ab  cdef */
        /*    0 */   @"50 04 56 49  53 41 57 13    10 00 02 31  00 00 00 33" // P.VI SAW.  ...1  ...3
        /*   10 */   @"d4 41 22 01  10 03 40 00    00 48 1f                " // .A". ..@.  .H.
    ;

    [self assertHex:expected actual:data];
    NSError *tlvsError;
    BerTlvs *tlvs = [builder buildTlvsWithError:&tlvsError];
    XCTAssertNil(tlvsError);
    XCTAssertEqual(2, tlvs.list.count);
    NSLog(@"data is\n%@", [tlvs dump:@"  "]);
}

- (void) testInitWithTemplate {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTemplate:TAG_E0];
    for(int i=0; i<10; i++) {
        [builder addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    }

    NSError *error;
    BerTlvs *tlvs = [builder buildTlvsWithError:&error];
    XCTAssertNil(error);
    XCTAssertEqual(1, tlvs.list.count);
    XCTAssertEqual(10, [tlvs findAll:TAG_86].count);

    NSLog(@"data is\n%@", [tlvs dump:@"  "]);
}

- (void) testInitWithPrimitiveTlv {

    BerTlv *primitiveTlv = [[BerTlv alloc] init:TAG_86 value:[HexUtil parse:@"F9128478E28F860D8424000008514C8F" error:nil]];

    BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTlv:primitiveTlv];

    NSData *data = [builder buildDataWithError:nil];
    [self assertHex:@"8610F9128478E28F860D8424000008514C8F" actual:data];
    XCTAssertTrue([builder buildTlvWithError:nil].primitive);
    NSLog(@"testInitWithPrimitiveTlv = \n%@", [[builder buildTlvWithError:nil] dump:@"  "]);
}

- (void) testInitWithConstructedTlv {

    BerTlvBuilder *b0 = [[BerTlvBuilder alloc] initWithTemplate:TAG_E0];
    for(int i=0; i<10; i++) {
        [b0 addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    }

    BerTlv *constructedTlv = [b0 buildTlvWithError:nil];

    BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTlv:constructedTlv];

    BerTlv *stage1 = [builder buildTlvWithError:nil];
    XCTAssertTrue(stage1.constructed);
    XCTAssertEqual(10, stage1.list.count);
    XCTAssertEqual(10, [stage1 findAll:TAG_86].count);

    [builder addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    BerTlv *stage2 = [builder buildTlvWithError:nil];
    XCTAssertTrue(stage2.constructed);
    XCTAssertEqual(11, stage2.list.count);
    XCTAssertEqual(11, [stage2 findAll:TAG_86].count);
    NSLog(@"testInitWithConstructedTlv = \n%@", [[b0 buildTlvWithError:nil] dump:@"  "]);
}


- (void)testAddText {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];
    [builder addText:@"12345" tag:TAG_PRIMITIVE];
    [self assertHex:@"86053132333435" actual:[builder buildDataWithError:nil]];
}

- (void)testAddBcd {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];
    [builder addBcd:12345 tag:TAG_PRIMITIVE length:6];
    [self assertHex:@"8606000000012345" actual:[builder buildDataWithError:nil]];
}

- (void)testAddAmount {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];
    NSDecimalNumber * amount = [[NSDecimalNumber alloc] initWithString:@"1234.56"];
    [builder addAmount:amount tag:TAG_PRIMITIVE];
    [self assertHex:@"8606000000123456" actual:[builder buildDataWithError:nil]];
}

- (void)testAddAmount270 {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];
    NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:@"000270.00001"];
    [builder addAmount:amount tag:[BerTag parse:@"9f 02"]];
    [self assertHex:@"9f0206000000027000" actual:[builder buildDataWithError:nil]];
}

- (void)testAddDate {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];

    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyMMdd"];
    NSDate *date = [dateFormat dateFromString:@"140701"];

    [builder addDate:date tag:TAG_PRIMITIVE];

    [self assertHex:@"8603140701" actual:[builder buildDataWithError:nil]];
}

- (void)testAddTime {
    BerTlvBuilder *builder = [[BerTlvBuilder alloc] init];

    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"HHmmss"];
    NSDate *date = [dateFormat dateFromString:@"160630"];

    [builder addTime:date tag:TAG_PRIMITIVE];

    [self assertHex:@"8603160630" actual:[builder buildDataWithError:nil]];
}



- (void)assertHex:(NSString *)aExpected actual:(NSData *)aData {
    NSData   *expectedData = [HexUtil parse:aExpected error:nil];
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

    BerTlvs *constructedTlvs = [b0 buildTlvsWithError:nil];
    NSLog(@"testInitWithTlvs constructedTlv = \n%@", [[b0 buildTlvsWithError:nil] dump:@"  "]);

    BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTlvs:constructedTlvs];

    BerTlvs *stage1 = [builder buildTlvsWithError:nil];
    NSLog(@"testInitWithTlvs stage1 = \n%@", [[b0 buildTlvsWithError:nil] dump:@"  "]);
    XCTAssertEqual(10, stage1.list.count);
    XCTAssertEqual(10, [stage1 findAll:TAG_86].count);

    [builder addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
    BerTlvs *stage2 = [builder buildTlvsWithError:nil];
    XCTAssertEqual(11, stage2.list.count);
    XCTAssertEqual(11, [stage2 findAll:TAG_86].count);
    NSLog(@"testInitWithTlvs = \n%@", [[b0 buildTlvsWithError:nil] dump:@"  "]);
}


@end

