//
//  OperationResult.h
//  Kraftera
//
//  Created by Maxim Guzun on 3/25/15.
//  Copyright (c) 2015 SmartData. All rights reserved.
//

#import "JSONModel.h"

@interface OperationResult : JSONModel
@property (strong, nonatomic) NSString<Optional>                    *message;
@end
