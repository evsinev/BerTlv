//
//  Created by Alex Kent on 2017-08-30.
//  Copyright © 2017 Evgeniy Sinev. All rights reserved.
//

#import "BerTlvErrors.h"

#define kBerTlvErrorDomain @"com.payneteasy.BerTlvFramework"

@implementation BerTlvErrors

+ (NSError *)invalidHexString {
    return [[NSError alloc] initWithDomain:kBerTlvErrorDomain code:0 userInfo: @{NSLocalizedDescriptionKey : NSLocalizedString(@"Invalid Hex string", "Invalid hex string")}];
}

+ (NSError *)outOfRangeAtOffset:(uint)aOffset length:(NSUInteger)aLen bufferLength:(NSUInteger)aBufLen level:(NSUInteger)aLevel {
    return [[NSError alloc] initWithDomain:kBerTlvErrorDomain code:1 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Length is out of the range [offset=%d,  len=%d, array.length=%lu, level=%d]", "Length is out of the range"), aOffset, aLen, aBufLen, aLevel] }];
}


+ (NSError *)badLengthAtOffset:(uint)aOffset numberOfBytes:(NSUInteger)numberOfBytes {
    return [[NSError alloc] initWithDomain:kBerTlvErrorDomain code:2 userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"At position %d the len is more then 3 [%d]", "Length is out of the range"), aOffset, numberOfBytes]}];
}

@end
