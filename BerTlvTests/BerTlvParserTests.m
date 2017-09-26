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
#import "BerTlvs.h"

void assertTag(BerTag *aExpected, BerTag *actual);

@interface BerTlvParserTests : XCTestCase

@end


@implementation BerTlvParserTests

// + [E1]
//    - [9F1E] 3136303231343337
//    + [EF]
//        - [DF0D] 4D3030302D4D5049
//        - [DF7F] 312D3232
//    + [EF]
//        - [DF0D] 4D3030302D544553544F53
//        - [DF7F] 362D35
NSString *hex =
        /*            0  1  2  3   4  5  6  7     8  9  a  b   c  d  e  f      0123 4567  89ab  cdef */
        /*    0 */ @"e1 35 9f 1e  08 31 36 30    32 31 34 33  37 ef 12 df" // .5.. .160  2143  7...
        /*   10 */ @"0d 08 4d 30  30 30 2d 4d    50 49 df 7f  04 31 2d 32" // ..M0 00-M  PI..  .1-2
        /*   20 */ @"32 ef 14 df  0d 0b 4d 30    30 30 2d 54  45 53 54 4f" // 2... ..M0  00-T  ESTO
        /*   30 */ @"53 df 7f 03  36 2d 35                               " // S... 6-5
;

//    - [50] 56495341
//    - [57] 1000023100000033D44122011003400000481F
//    - [5A] 1000023100000033
//    - [5F20] 43415244332F454D562020202020202020202020202020202020
//    - [5F24] 441231
//    - [5F28] 0643
//    - [5F2A] 0643
//    - [5F30] 0201
//    - [5F34] 06
//    - [82] 5C00
//    - [84] A0000000031010
//    - [95] 4080008000
//    - [9A] 140210
//    - [9B] E800
//    - [9C] 00
//    - [9F02] 000000030104
//    - [9F03] 000000000000
//    - [9F06] A0000000031010
//    - [9F09] 008C
//    - [9F10] 06010A03A0A100
//    - [9F1A] 0826
//    - [9F1C] 3036303435333930
//    - [9F1E] 3036303435333930
//    - [9F26] CBFC767977111F15
//    - [9F27] 80
//    - [9F33] E0B8C8
//    - [9F34] 5E0300
//    - [9F35] 22
//    - [9F36] 000E
//    - [9F37] 461BDA7C
//    - [9F41] 00000063
NSString *hexPrimitive =
/*            0  1  2  3   4  5  6  7     8  9  a  b   c  d  e  f      0123 4567  89ab  cdef */
/*    0 */ @"50 04 56 49  53 41 57 13    10 00 02 31  00 00 00 33" // P.VI SAW.  ...1  ...3
/*   10 */ @"d4 41 22 01  10 03 40 00    00 48 1f 5a  08 10 00 02" // .A". ..@.  .H.Z  ....
/*   20 */ @"31 00 00 00  33 5f 20 1a    43 41 52 44  33 2f 45 4d" // 1... 3_ .  CARD  3/EM
/*   30 */ @"56 20 20 20  20 20 20 20    20 20 20 20  20 20 20 20" // V
/*   40 */ @"20 20 5f 24  03 44 12 31    5f 28 02 06  43 5f 2a 02" //   _$ .D.1  _(..  C_*.
/*   50 */ @"06 43 5f 30  02 02 01 5f    34 01 06 82  02 5c 00 84" // .C_0 ..._  4...  .\..
/*   60 */ @"07 a0 00 00  00 03 10 10    95 05 40 80  00 80 00 9a" // .... ....  ..@.  ....
/*   70 */ @"03 14 02 10  9b 02 e8 00    9c 01 00 9f  02 06 00 00" // .... ....  ....  ....
/*   80 */ @"00 03 01 04  9f 03 06 00    00 00 00 00  00 9f 06 07" // .... ....  ....  ....
/*   90 */ @"a0 00 00 00  03 10 10 9f    09 02 00 8c  9f 10 07 06" // .... ....  ....  ....
/*   a0 */ @"01 0a 03 a0  a1 00 9f 1a    02 08 26 9f  1c 08 30 36" // .... ....  ..&.  ..06
/*   b0 */ @"30 34 35 33  39 30 9f 1e    08 30 36 30  34 35 33 39" // 0453 90..  .060  4539
/*   c0 */ @"30 9f 26 08  cb fc 76 79    77 11 1f 15  9f 27 01 80" // 0.&. ..vy  w...  .'..
/*   d0 */ @"9f 33 03 e0  b8 c8 9f 34    03 5e 03 00  9f 35 01 22" // .3.. ...4  .^..  .5."
/*   e0 */ @"9f 36 02 00  0e 9f 37 04    46 1b da 7c  9f 41 04 00" // .6.. ..7.  F..|  .A..
/*   f0 */ @"00 00 63                                            " // ..c
;

NSString * badLengthData = @"DF 01 06 AA BB CC DD EE"; // Truncated data, length 06 but only 5 bytes value

- (void)testParse {

    NSData *data = [HexUtil parse:hex error:nil];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlv *tlv = [parser parseConstructed:data error:nil];
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
    NSData *data = [HexUtil parse:aHex error:nil];
    NSString *actual = [HexUtil format:data];
    // NSLog(@"%@ -> %@", aHex, actual);

    XCTAssertTrue([aExpected isEqualToString:actual], @"Expected %@ but actual %@", aExpected, actual);
}

- (void) testParseTlvs {
    NSData *data = [HexUtil parse:hexPrimitive error:nil];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlvs *tlvs = [parser parseTlvs:data error:nil];

    XCTAssertEqual(31, tlvs.list.count, @"Count must be 13");
    NSLog(@"tlvs = \n%@", [tlvs dump:@"  "]);

}

- (void)testParsePartial{
    NSData *data = [HexUtil parse:hexPrimitive error:nil];
    BerTlvParser *parser = [[BerTlvParser alloc] init];

    BerTlvs *tlvs = [parser parseTlvs:data numberOfTags: 2 error:nil];

    XCTAssertEqual(2, tlvs.list.count, @"Count must be 2");
    NSLog(@"tlvs = \n%@", [tlvs dump:@"  "]);
}

- (void)testBadLengthTlv{
    NSData *data = [HexUtil parse:badLengthData error:nil];

    NSError * parseError =nil;
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlvs *tlvs = [parser parseTlvs:data error:&parseError];

    XCTAssertNil(tlvs);
    XCTAssertNotNil(parseError);
}

- (void)testBadLengthTlvWithoutErrorParam{
    NSData *data = [HexUtil parse:badLengthData error:nil];
    
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlvs *tlvs = [parser parseTlvs:data error:nil];
    
    XCTAssertNil(tlvs);

}

@end

