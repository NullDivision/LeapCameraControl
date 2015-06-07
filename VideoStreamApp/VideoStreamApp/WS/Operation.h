//
//  Operation.h
//  WebRadioAPI
//
//  Created by Maxim Guzun on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationProtocol.h"
#define TIMEOUT 30

typedef enum{
    OPERATION_GET = 0,
    OPERATION_POST,
    OPERATION_PUT,
    OPERATION_DELETE
}OPERATION_TYPE;

@interface Operation : NSOperation{
    
    NSURL                           *m_URL;
    __weak id <OperationProtocol>   m_delegate;
    OPERATION_TYPE                  m_operationType;
    NSHTTPCookie                    *m_cookie;
    NSMutableData                   *m_data;
    NSURLConnection                 *m_connection;
    id                              m_postData;
    NSURLResponse                   *_response;
	NSString						*m_sesionID;
}

- (id) initWithURL:(NSURL *)pURL andDelegate:(id <OperationProtocol>)pDelegate;
- (void) setOperationType:(OPERATION_TYPE)type;
- (void) setOperationData:(id)pData;
- (void) setCookie:(NSHTTPCookie*)pCookie;
- (NSData*) loadData;
- (void) executeSyncron;   // this one is used in case we don't need to add the operation in queue
@end
