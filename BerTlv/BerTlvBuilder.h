//
// Created by Evgeniy Sinev on 06/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTlv;
@class BerTlvs;
@class BerTag;


@interface BerTlvBuilder : NSObject

// initialize
- (id)init;
- (id)initWithTlv      :(BerTlv *  ) aTlv  ;
- (id)initWithTlvs     :(BerTlvs * ) aTlvs ;
- (id)initWithTemplate :(BerTag  * ) aTag  ;

// build
- (NSData  *) buildData ;
- (BerTlvs *) buildTlvs ;
- (BerTlv  *) buildTlv  ;

// add values
- (void) addBerTlv  :(BerTlv     *) aTlv ;
- (void) addBerTlvs :(BerTlvs    *) aTlvs;
- (void) addAmount  :(NSDecimalNumber  *) aAmount  tag:(BerTag *)aTag;
- (void) addDate    :(NSDate     *) aDate    tag:(BerTag *)aTag;
- (void) addTime    :(NSDate     *) aTime    tag:(BerTag *)aTag;
- (void) addText    :(NSString   *) aText    tag:(BerTag *)aTag;
- (void) addBcd     :(NSUInteger  ) aValue   tag:(BerTag *)aTag length:(NSUInteger )aLength;
- (void) addBytes   :(NSData     *) aBuf     tag:(BerTag *)aTag;
- (void) addHex     :(NSString   *) aHex     tag:(BerTag *)aTag;

@end