///
//  WS.m
//  iTaxi
//
//  Created by Maxim Guzun on 15/11/14.
//  Copyright SmartData All rights reserved.
//

#import <AdSupport/ASIdentifierManager.h>
#import "UploadBinaryImageOperation.h"
#import "GenericOperation.h"
#import "WS.h"

static WS *sharedInstance = nil;
@implementation WS
//------------------------------------------------------------------------------------------------------------------------
+ (id) getShareInstance
{
    if (sharedInstance == nil)
        sharedInstance = [[WS alloc] init];
    return sharedInstance;
}
//------------------------------------------------------------------------------------------------------------------------
- (void) pauseOperations:(BOOL)pause
{
    [m_queue setSuspended:pause];
}
//------------------------------------------------------------------------------------------------------------------------
- (id) init
{
    self = [super init];
    if (self) {
        m_queue = [[NSOperationQueue alloc] init];
        m_VID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [m_queue setMaxConcurrentOperationCount:MAX_OPERATIONS];
    }
    return self;
}
#pragma mark account operations
//------------------------------------------------------------------------------------------------------------------------
- (NSString*) getVID
{
    return m_VID;
}
//------------------------------------------------------------------------------------------------------------------------
- (void) resetAllOperations
{
    [m_queue cancelAllOperations];
}
//------------------------------------------------------------------------------------------------------------------------
- (void) setSessionID:(NSString*)pSessionID
{
	m_sessionID = pSessionID;
}
//------------------------------------------------------------------------------------------------------------------------
- (void) uploadImageBinary:(id)data forDelegate:(id<OperationProtocol>)delegate
{
    UploadBinaryImageOperation *_uploadImage = [[UploadBinaryImageOperation alloc] initWithURL:[NSURL URLWithString:kServer] andDelegate:delegate];
    
    [_uploadImage setOperationType:OPERATION_POST];
    [_uploadImage setOperationData:data];
    [m_queue addOperation:_uploadImage];
}
//------------------------------------------------------------------------------------------------------------------------
@end














