//
// Created by Evgeniy Sinev on 05/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTlv;


@interface BerTlvParser : NSObject

- (BerTlv *)parseConstructed:(NSData *)aData;


@end