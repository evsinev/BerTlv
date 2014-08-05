//
//  BerTlv.h
//  BerTlv
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTag;

@interface BerTlv : NSObject

@property(copy, nonatomic, readonly) BerTag * tag;
@property(copy, nonatomic, readonly) NSData * value;
@property(copy, nonatomic, readonly) NSArray * list;

- (id)init:(BerTag *)aTag value:(NSData *)aValue;
- (id)init:(BerTag *)aTag array:(NSArray *)aArray;

@end
