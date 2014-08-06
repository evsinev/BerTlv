//
//  BerTlv.m
//  BerTlv
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import "BerTlv.h"
#import "BerTag.h"
#import "HexUtil.h"

@implementation BerTlv

@synthesize tag, value, list, constructed, primitive;

- (id)init:(BerTag *)aTag array:(NSArray *)aArray {
    self = [super init];
    if(self) {
        tag = aTag;
        list = aArray;
        constructed = aTag.isConstructed;
        primitive = !constructed;
    }
    return self;
}

- (id)init:(BerTag *)aTag value:(NSData *)aValue {
    self = [super init];
    if(self) {
        tag = aTag;
        value = aValue;
        constructed = aTag.isConstructed;
        primitive = !constructed;
    }
    return self;
}

- (BerTlv *)find:(BerTag *)aTag {
    if([aTag isEqualToTag:tag]) {
        return self;
    }

    if(primitive) {
        return nil;
    }
    
    for( BerTlv * tlv in list) {
        BerTlv *found = [tlv find:aTag];
        if(found!=nil) {
            return found;
        }
    }

    return nil;
}

- (NSArray *)findAll:(BerTag *)aTag {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([aTag isEqualToTag:tag]) {
        [array addObject:self];
    }

    if(constructed) {
        for( BerTlv * tlv in list) {
            NSArray *found = [tlv findAll:aTag];
            [array addObjectsFromArray:found];
        }
    }

    return array;
}

- (NSString *)hexValue {
    [self checkPrimitive];
    return [HexUtil format:value];
}

- (NSString *)textValue {
    return [[NSString alloc] initWithData:self.value encoding:NSASCIIStringEncoding];
}

- (NSUInteger)intValue {
    NSUInteger i=0;
    NSUInteger j=0;
    NSUInteger number = 0;

    for (i = 0; i < value.length; i++) {
        j= ((uint8_t *)value.bytes)[i];
        number = number * 256 + ( j<0 ? j+=256 : j);
    }
    return number;
}

- (void)checkPrimitive {
    if(constructed) {
        @throw([NSException exceptionWithName:@"NotPrimitiveTagException"
                                       reason:[NSString stringWithFormat:@"Tag %@ is constructed", tag]
                                     userInfo:nil]);
    }
}


- (NSString *)dump:(NSString *)aPadding {
    NSMutableString *sb = [[NSMutableString alloc] init];

    if(primitive) {
        [sb appendFormat:@"%@ - [%@] %@\n", aPadding, tag.hex, [self hexValue]];
    } else {
        [sb appendFormat:@"%@ + [%@]\n", aPadding, tag.hex];
        NSMutableString *childPadding = [[NSMutableString alloc] init];
        [childPadding appendString:aPadding];
        [childPadding appendString:aPadding];
        for (BerTlv *tlv in list) {
            [sb appendString:[tlv dump:childPadding]];
        }
    }
    return sb;
}


@end
