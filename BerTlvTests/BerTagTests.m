//
//  BerTlvTests.m
//  BerTlvTests
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BerTag.h"

@interface BerTagTests : XCTestCase

@end

@implementation BerTagTests

- (void)testIsConstructed {
    XCTAssertEqual(YES,  [[BerTag alloc] init:0x20].isConstructed, "Must be constructed");
    XCTAssertEqual(NO ,  [[BerTag alloc] init:0b00000000].isConstructed, "Must not be constructed");
    XCTAssertEqual(NO ,  [[BerTag alloc] init:0x01 secondByte:0x20 thirdByte:0x20].isConstructed, "Must not be constructed");
    XCTAssertEqual(YES , [[BerTag alloc] init:0x21 secondByte:0x20 thirdByte:0x20].isConstructed, "Must be constructed");
}

- (void)testInit {
    XCTAssertTrue(  [[[BerTag alloc] init:0x20] isEqual:[[BerTag alloc] init:0x20]] );
    XCTAssertFalse( [[[BerTag alloc] init:0x20] isEqual:[[BerTag alloc] init:0x21]] );
    XCTAssertFalse( [[[BerTag alloc] init:0x20] isEqual:[[BerTag alloc] init:0x21 secondByte:0x20 thirdByte:0x20]] );

    uint8_t bytes[3];
    bytes[0] = 0x01;
    bytes[1] = 0x02;
    bytes[2] = 0x03;

    NSData *raw = [NSData dataWithBytes:bytes length:3];
    XCTAssertTrue( [[[BerTag alloc] init:raw offset:0 length:3] isEqual:[[BerTag alloc] init:0x01 secondByte:0x02 thirdByte:0x03]] );

}

- (void)testDescription {
    BerTag *tag = [[BerTag alloc] init:0x21 secondByte:0x20 thirdByte:0x20];
    XCTAssertTrue([@"+ 212020" isEqual:tag.description]);
}


@end
