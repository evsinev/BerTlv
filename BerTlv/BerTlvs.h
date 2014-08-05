//
// Created by Evgeniy Sinev on 06/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTag;
@class BerTlv;


@interface BerTlvs : NSObject

@property(copy, nonatomic, readonly) NSArray *  list        ;

- (id)init:(NSArray *)aList;

- (BerTlv *)  find   :(BerTag *)aTag;
- (NSArray *) findAll:(BerTag *)aTag;

- (NSString *) dump:(NSString *)aPadding;


@end