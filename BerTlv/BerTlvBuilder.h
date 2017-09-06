//
// Created by Evgeniy Sinev on 06/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTlv;
@class BerTlvs;
@class BerTag;


NS_ASSUME_NONNULL_BEGIN
@interface BerTlvBuilder : NSObject

// initialize
- (id)init;
- (id)initWithTlv      :(BerTlv *  ) aTlv  ;
- (id)initWithTlvs     :(BerTlvs * ) aTlvs ;
- (id)initWithTemplate :(BerTag  * ) aTag  ;

// build
- (NSData  *) buildData __deprecated NS_SWIFT_UNAVAILABLE("");
- (NSData  * _Nullable) buildDataWithError:(NSError **)error;

- (BerTlvs *) buildTlvs __deprecated NS_SWIFT_UNAVAILABLE("");
- (BerTlvs * _Nullable) buildTlvsWithError:(NSError **)error;

- (BerTlv  *) buildTlv  __deprecated NS_SWIFT_UNAVAILABLE("");
- (BerTlv  * _Nullable) buildTlvWithError:(NSError **)error;

// add values
// return BOOL indicates success
- (BOOL) addBerTlv  :(BerTlv     *) aTlv ;
- (BOOL) addBerTlvs :(BerTlvs    *) aTlvs;
- (BOOL) addAmount  :(NSDecimalNumber  *) aAmount  tag:(BerTag *)aTag;
- (void) addDate    :(NSDate     *) aDate    tag:(BerTag *)aTag;
- (void) addTime    :(NSDate     *) aTime    tag:(BerTag *)aTag;
- (BOOL) addText    :(NSString   *) aText    tag:(BerTag *)aTag;
- (BOOL) addBcd     :(NSUInteger  ) aValue   tag:(BerTag *)aTag length  :(NSUInteger )aLength;
- (BOOL) addBytes   :(NSData     *) aBuf     tag:(BerTag *)aTag;
- (BOOL) addHex     :(NSString   *) aHex     tag:(BerTag *)aTag;

@end
NS_ASSUME_NONNULL_END
