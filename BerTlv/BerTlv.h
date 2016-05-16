//
//  BerTlv.h
//  BerTlv
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double OMGHTTPURLRQVersionNumber;
FOUNDATION_EXPORT const unsigned char OMGHTTPURLRQVersionString[];

@class BerTag;

@interface BerTlv : NSObject

@property(copy, nonatomic, readonly) BerTag  *  tag         ;
@property(copy, nonatomic, readonly) NSData  *  value       ;
@property(copy, nonatomic, readonly) NSArray *  list        ;
@property(nonatomic, readonly)       BOOL       primitive   ;
@property(nonatomic, readonly)       BOOL       constructed ;

- (id)init:(BerTag *)aTag value:(NSData *)aValue;
- (id)init:(BerTag *)aTag array:(NSArray *)aArray;

- (BOOL)      hasTag:(BerTag *)aTag;
- (BerTlv *)  find:(BerTag *)aTag;
- (NSArray *) findAll:(BerTag *)aTag;

- (NSString *) hexValue;
- (NSString *) textValue;

- (NSString *) dump:(NSString *)aPadding;

@end
