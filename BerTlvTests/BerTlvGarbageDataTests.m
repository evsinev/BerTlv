//
//  akTests.m
//  BerTlvTests
//
//  Created by Alex Kent on 04/08/2017.
//  Copyright © 2017 Evgeniy Sinev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BerTag.h"
#import "HexUtil.h"
#import "BerTlvParser.h"
#import "BerTlv.h"
#import "BerTlvs.h"


@interface BerTlvGarbageDataTests : XCTestCase
@end

@implementation BerTlvGarbageDataTests

- (void)testHexValueOnConstructedTagLogsError {
    BerTag *tag = [[BerTag alloc] init:0xff];
    BerTlv *tlv = [[BerTlv alloc] init:tag array:@[]];
    NSString *hexValue = [tlv hexValueWithError:nil];
    
    XCTAssertNil(hexValue);
}

- (void)testNSDataParseStringMiscountReturnsNil {
    NSData *data = [HexUtil parse:@"fff"];
    XCTAssertNil(data);
}

- (void)testCalcDataBadLength {
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    NSData *testData = [HexUtil parse:@"ff20ffff0000"];
    NSError *error;
    [parser parseTlvs:testData error:&error];
    XCTAssertNotNil(error);
//    XCTAssertEqual([[result list] count], 0); // should a parsing error cause nil to be returned, or return a partial result?
}

- (void)testOutOfRange {
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    NSData *testData = [HexUtil parse:@"3f9f5745 c37ede54"];
    NSError *error;
    [parser parseTlvs:testData error:&error];
    XCTAssertNotNil(error);
}

- (void)testParseTlvsFromGarbageData {
    NSArray *garbageDatas = @[[HexUtil parse:@"1c1308fd 11212a28"], [HexUtil parse:@"c8036f54"], [HexUtil parse:@"1f84f9fe"]];
    
    for (NSData *testData in garbageDatas) {
        BerTlvParser *parser = [[BerTlvParser alloc] init];
        BerTlvs *result = [parser parseTlvs:testData error:nil];
        XCTAssertEqual([[result list] count], 0);
    }
}

- (void)testFuzzer {
    BerTlvParser *parser = [[BerTlvParser alloc] init];

    NSInteger maxSize = 2048;
    NSInteger count = 10000; // increase this number to run the fuzzer longer.
    NSInteger failCount = 0;

    for (NSInteger i = 0; i < count; i++) {
        NSDate *startTime = [NSDate date];
        NSInteger length = (arc4random() % maxSize) + 1; // +1 because zero length isn't too exciting.
        NSData * rndData = [self randomNSData:length];
        @try {
            [parser parseTlvs:rndData error:nil];
        }
        @catch (NSException * e) {
            XCTFail(@"crash %@, %@", rndData.description, e.name);
            failCount++;
        }
        double timePassed_ms = [startTime timeIntervalSinceNow] * -1000.0;
        if (timePassed_ms > 1.0) {
            NSLog(@"Took suspiciously long (%fs) to parse:\n%@", timePassed_ms, rndData);
        }
    }
    NSLog(@"fuzzer crashed %ld from %ld runs, with max length %ld", (long)failCount, (long)count, (long)maxSize);
}


// MARK: Random data generator

-(NSData*)randomNSData: (NSInteger)length
{
    NSMutableData* theData = [NSMutableData dataWithCapacity:length];
    for( unsigned int i = 0 ; i < length/4 ; ++i )
    {
        u_int32_t randomBits = arc4random();
        [theData appendBytes:(void*)&randomBits length:4];
    }
    return theData;
}

@end


