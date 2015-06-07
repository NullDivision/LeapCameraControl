//
//  CameraSourceCell.h
//  VideoStreamApp
//
//  Created by Maxim Guzun on 6/6/15.
//  Copyright (c) 2015 Maxim Guzun. All rights reserved.
//

#import "CustomCell.h"
@import AVFoundation;

@interface CameraSourceCell : CustomCell{
    
    IBOutlet UILabel    *m_lblInfo;
}
- (void) setSourceInfo:(AVCaptureDevice*)sourceInfo;
@end
