//
//  BerTlv.m
//  BerTlv
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import "BerTlv.h"
#import "BerTag.h"

@implementation BerTlv

@synthesize tag, value, list;

- (id)init:(BerTag *)aTag array:(NSArray *)aArray {
    self = [super init];
    if(self) {
        tag = aTag;
        list = aArray;
    }
    return self;
}

- (id)init:(BerTag *)aTag value:(NSData *)aValue {
    self = [super init];
    if(self) {
        tag = aTag;
        value = aValue;
    }
    return self;
}


@end
