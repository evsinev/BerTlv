//
//  BerTlvErrors.h
//  BerTlv
//
//  Created by Alex Kent on 2017-08-30.
//  Copyright © 2017 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface BerTlvErrors : NSObject

+ (NSError *)invalidHexString;

@end
NS_ASSUME_NONNULL_END
