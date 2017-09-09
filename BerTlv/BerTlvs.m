//
// Created by Evgeniy Sinev on 06/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import "BerTlvs.h"
#import "BerTag.h"
#import "BerTlv.h"


@implementation BerTlvs {
    
}

@synthesize list;

- (id)init:(NSArray *)aList {
    self = [super init];
    if (self) {
        list = aList;
    }
    return self;
}

- (BerTlv *)find:(BerTag *)aTag {
    for (BerTlv *tlv in list) {
        BerTlv *found = [tlv find:aTag];
        if(found!=nil) {
            return found;
        }
    }
    return nil;
}

- (NSArray *)findAll:(BerTag *)aTag {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (BerTlv *tlv in list) {
        [ret addObjectsFromArray:[tlv findAll:aTag]];
    }
    return [ret copy];
}

- (NSString *) dump:(NSString *)aPadding {
    NSMutableString *sb = [[NSMutableString alloc] init];
    for (BerTlv *tlv in list) {
        [sb appendString:[tlv dump:aPadding]];
    }

    return [sb copy];
}

@end
