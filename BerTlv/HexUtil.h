//
// Created by Evgeniy Sinev on 04/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HexUtil : NSObject

+ (NSString *) format:(NSData *)aData;
+ (NSString *) prettyFormat:(NSData *)aData;

+ (NSData * _Nullable) parse:(NSString *)aHex __deprecated;
+ (NSData *) parse:(NSString *)aHex error:(NSError **)error;

+ (NSString *)format:(NSData *)data offset:(uint)offset len:(NSUInteger)len;
@end
NS_ASSUME_NONNULL_END
