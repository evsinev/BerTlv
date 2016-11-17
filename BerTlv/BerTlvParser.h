//
// Created by Evgeniy Sinev on 05/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTlv;
@class BerTlvs;


@interface BerTlvParser : NSObject

- (BerTlv *)parseConstructed:(NSData *)aData;
- (BerTlvs *)parseTlvs:(NSData *)aData;
- (BerTlvs *)parseTlvs:(NSData *)aData numberOfTags:(NSUInteger)numberOfTags;
@end