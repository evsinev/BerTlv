//
// Created by Evgeniy Sinev on 04/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface BerTag : NSObject

@property(nonatomic, copy) NSData *data;;

- (id _Nullable) init:(NSData *)aData
     offset:(uint)aOffset
     length:(uint)aLength;

- (id) init:(uint8_t)aFirstByte;
- (id) init:(uint8_t)aFirstByte secondByte:(uint8_t)aSecondByte;
- (id) init:(uint8_t)aFirstByte secondByte:(uint8_t)aSecondByte thirdByte:(uint8_t)aThirdByte;

- (BOOL)isConstructed;

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToTag:(BerTag *)tag;
- (NSUInteger)hash;
- (NSString *)description;

- (NSString *)hex;

+ (BerTag *)parse:(NSString *)aHexString;
@end
NS_ASSUME_NONNULL_END
