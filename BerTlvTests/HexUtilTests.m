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

@interface HexUtilTests : XCTestCase

@end

@implementation HexUtilTests

- (void)testParse {
    [self expected:@"0102030405060708"];
    [self expected:@"98765432"];
    [self expected:@"1234567890"];
    [self expected:@"ABCDEF"];
}

- (void)testParseWithSpaces {
    [self expected:@"0102030405060708" hex:@"0 1 0     2030405060708"];
    [self expected:@"98765432" hex:@"98 76 54 32"];
    [self expected:@"1234567890" hex:@"12 z 34 \n 56 - 78 | 90"];
    [self expected:@"0102030405060708090A0B0C0D0E0D0F" hex:@"0102030405060708090a0b0c0d0e0d0f"];
    [self expected:@"F1F2F3F4F5F6F7F8F9FAFBFCFDFEFDFF" hex:@"f1f2f3f4f5f6f7f8f9fafbfcfdfefdff"];
}

- (void)expected:(NSString *)aHex {
    NSData *data = [HexUtil parse:aHex];
    NSString *was = [HexUtil format:data];
    // NSLog(@"%@ -> %@", aHex, was);

    XCTAssertTrue([aHex isEqualToString:was], @"Expected %@ but actual %@", aHex, was);
}

- (void)expected:(NSString *)aExpected hex:(NSString *)aHex {
    NSData *data = [HexUtil parse:aHex];
    NSString *actual = [HexUtil format:data];
    // NSLog(@"%@ -> %@", aHex, actual);

    XCTAssertTrue([aExpected isEqualToString:actual], @"Expected %@ but actual %@", aExpected, actual);
}


@end
