//
//  GenericOperation.h
//  Kraftera
//
//  Created by Maxim Guzun on 6/1/15.
//  Copyright (c) 2015 SmartData. All rights reserved.
//

#import "Operation.h"

@interface GenericOperation : Operation <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (strong, nonatomic) void (^block)(NSMutableData *result, NSInteger status, NSNumber *index);
@property (strong, nonatomic) NSNumber  *m_index;
@end
