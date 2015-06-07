///
//  WS.h
//  iTaxi
//
//  Created by Maxim Guzun on 15/11/14.
//  Copyright SmartData All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationProtocol.h"

#define MAX_OPERATIONS      20

@class FeedItem;
@class JSONModel;
@interface WS : NSObject{
    NSOperationQueue        *m_queue;
    NSString                *m_VID;
	NSString				*m_sessionID;
}

+ (id) getShareInstance;
- (void) resetAllOperations;
- (void) pauseOperations:(BOOL)pause;
- (NSString*) getVID;
- (void) setSessionID:(NSString*)pSessionID;
- (void) uploadImageBinary:(id)data forDelegate:(id<OperationProtocol>)delegate;
 @end