//
// Created by Evgeniy Sinev on 05/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTlv;
@class BerTlvs;

NS_ASSUME_NONNULL_BEGIN
@interface BerTlvParser : NSObject

- (BerTlv *)parseConstructed:(NSData *)aData __deprecated NS_SWIFT_UNAVAILABLE("");
- (BerTlv * _Nullable)parseConstructed:(NSData *)aData error:(NSError **)error;

- (BerTlvs *)parseTlvs:(NSData *)aData __deprecated NS_SWIFT_UNAVAILABLE("");
- (BerTlvs * _Nullable)parseTlvs:(NSData *)aData error:(NSError **)error;

- (BerTlvs *)parseTlvs:(NSData *)aData numberOfTags:(NSUInteger)numberOfTags __deprecated NS_SWIFT_UNAVAILABLE("");
- (BerTlvs * _Nullable)parseTlvs:(NSData *)aData numberOfTags:(NSUInteger)numberOfTags error:(NSError **)error;
@end
NS_ASSUME_NONNULL_END
