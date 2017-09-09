//
//  BerTlv.h
//  BerTlv
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BerTag;

@interface BerTlv : NSObject

@property(copy, nonatomic, readonly) BerTag  *  tag         ;
@property(copy, nonatomic, readonly, nullable) NSData  *  value       ;
@property(copy, nonatomic, readonly, nullable) NSArray *  list        ;
@property(nonatomic, readonly)       BOOL       primitive   ;
@property(nonatomic, readonly)       BOOL       constructed ;

- (id)init:(BerTag *)aTag value:(NSData *)aValue;
- (id)init:(BerTag *)aTag array:(NSArray *)aArray;

- (BOOL)      hasTag:(BerTag *)aTag;
- (BerTlv * _Nullable)  find:(BerTag *)aTag;
- (NSArray *) findAll:(BerTag *)aTag;

- (NSString * _Nullable) hexValue;
- (NSString * _Nullable) textValue;

- (NSString *) dump:(NSString *)aPadding;

@end
NS_ASSUME_NONNULL_END
