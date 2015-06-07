//
//  CommandItem.h
//  VideoStreamApp
//
//  Created by Maxim Guzun on 6/6/15.
//  Copyright (c) 2015 Maxim Guzun. All rights reserved.
//

#import "JSONModel.h"

@interface CommandItem : JSONModel
@property (strong, nonatomic)   NSNumber<Optional>  *cmd;
@property (strong, nonatomic)   NSNumber<Optional>  *usr;
@property (strong, nonatomic)   NSString<Optional>  *data;
@end
