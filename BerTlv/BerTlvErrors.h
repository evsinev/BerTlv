//
//  Created by Alex Kent on 2017-08-30.
//  Copyright © 2017 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface BerTlvErrors : NSObject

+ (NSError *)invalidHexString;
+ (NSError *)outOfRangeAtOffset:(uint)aOffset length:(NSUInteger)aLen bufferLength:(NSUInteger)aBufLen level:(NSUInteger)aLevel;
+ (NSError *)badLengthAtOffset:(uint)aOffset numberOfBytes:(NSUInteger)numberOfBytes;

@end
NS_ASSUME_NONNULL_END
