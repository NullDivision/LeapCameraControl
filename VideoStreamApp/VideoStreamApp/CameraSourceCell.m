//
//  CameraSourceCell.m
//  VideoStreamApp
//
//  Created by Maxim Guzun on 6/6/15.
//  Copyright (c) 2015 Maxim Guzun. All rights reserved.
//

#import "CameraSourceCell.h"


@implementation CameraSourceCell
//------------------------------------------------------------------------------------------------------------------------
- (void) setSourceInfo:(AVCaptureDevice*)sourceInfo
{
    NSMutableString *_info = [[NSMutableString alloc] init];
    [_info appendString:[sourceInfo localizedName]];
    [m_lblInfo setText:_info];
}
//------------------------------------------------------------------------------------------------------------------------
@end
