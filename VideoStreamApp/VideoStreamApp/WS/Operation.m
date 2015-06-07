//
//  Operation.m
//  WebRadioAPI
//
//  Created by Maxim Guzun on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Operation.h"
#import "PostParam.h"
@implementation Operation
//---------------------------------------------------------------------------------------------------------------------
- (id) initWithURL:(NSURL *)pURL andDelegate:(id <OperationProtocol>)pDelegate
{
    self = [self init];
    if (self) {
        m_URL           = pURL;
        m_delegate      = pDelegate;
        m_operationType = OPERATION_GET;
    }
    return self;
}
//---------------------------------------------------------------------------------------------------------------------
- (void) setCookie:(NSHTTPCookie*)pCookie
{
    m_cookie = pCookie;
}
//---------------------------------------------------------------------------------------------------------------------
- (void) setOperationData:(id)pData
{
    m_postData = pData;
}
//---------------------------------------------------------------------------------------------------------------------
- (void) setOperationType:(OPERATION_TYPE)type
{
    m_operationType = type;
}
//---------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------
- (NSData*) loadData
{
    NSError *error;
    NSURLRequestCachePolicy policy = NSURLRequestReloadIgnoringCacheData;
    NSHTTPURLResponse *response;
    NSMutableURLRequest *lRequest = [NSMutableURLRequest requestWithURL:m_URL cachePolicy:policy timeoutInterval:TIMEOUT];
    
    // set the request type
    switch (m_operationType)
    {
        case OPERATION_GET: 	[lRequest setHTTPMethod:@"GET"];break;
        case OPERATION_POST:	[lRequest setHTTPMethod:@"POST"];break;
        case OPERATION_PUT: 	[lRequest setHTTPMethod:@"PUT"];break;
        case OPERATION_DELETE: 	[lRequest setHTTPMethod:@"DELETE"];break;
    }
    
    // mark that we handle cookies
    [lRequest setHTTPShouldHandleCookies: YES];
    if([m_postData isKindOfClass:[NSArray class]])
    {
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------RIDEPAL---------------------------";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        int index = 0;
        for(NSData *_data in m_postData)
        {
            if([_data isKindOfClass:[NSData class]])
            {
                [lRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image[]\"; filename=\"image%i.png\"\r\n", index] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:_data]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                index++;
            }
            else
                if([_data isKindOfClass:[PostParam class]])
                {
                    [lRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%i"
                                       ,((PostParam*)_data).name, [((PostParam*)_data).value intValue]] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                }
        }
        [lRequest setHTTPBody:body];
    }
    else
        if([m_postData isKindOfClass:[NSData class]])
        {
            NSMutableData *body = [NSMutableData data];
            NSString *boundary = @"---------------------------RIDEPAL---------------------------";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [lRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file0\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:m_postData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [lRequest setHTTPBody:body];
        }
        else
            [lRequest setHTTPBody:[(NSString*)m_postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    if(m_sesionID)
        [lRequest setValue:[NSString stringWithFormat:@"id=%@", m_sesionID] forHTTPHeaderField:kHeaderCookie];
    
    NSData *_pData = [NSURLConnection sendSynchronousRequest:lRequest returningResponse:&response error:&error];
    _response = response;
    return _pData;
}
//---------------------------------------------------------------------------------------------------------------------
- (void) executeSyncron
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableURLRequest *lRequest = [[NSMutableURLRequest alloc] initWithURL:m_URL
                                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                             timeoutInterval:TIMEOUT];
    // set the request type
    switch (m_operationType)
    {
        case OPERATION_GET: 	[lRequest setHTTPMethod:@"GET"];break;
        case OPERATION_POST:	[lRequest setHTTPMethod:@"POST"];break;
        case OPERATION_PUT: 	[lRequest setHTTPMethod:@"PUT"];break;
        case OPERATION_DELETE: 	[lRequest setHTTPMethod:@"DELETE"];break;
    }
    
    // mark that we handle cookies
    [lRequest setHTTPShouldHandleCookies: YES];
    if([m_postData isKindOfClass:[NSArray class]])
    {
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------RIDEPAL---------------------------";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        int index = 0;
        for(NSData *_data in m_postData)
        {
            if([_data isKindOfClass:[NSData class]])
            {
                [lRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image[]\"; filename=\"image%i.png\"\r\n", index] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:_data]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                index++;
            }
            else
                if([_data isKindOfClass:[PostParam class]])
                {
                    [lRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%i"
                                       ,((PostParam*)_data).name, [((PostParam*)_data).value intValue]] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                }
        }
        [lRequest setHTTPBody:body];
    }
    else
        if([m_postData isKindOfClass:[NSData class]])
        {
            NSMutableData *body = [NSMutableData data];
            NSString *boundary = @"---------------------------RIDEPAL---------------------------";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [lRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file0\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:m_postData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [lRequest setHTTPBody:body];
        }
        else
            [lRequest setHTTPBody:[(NSString*)m_postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    if(m_sesionID)
        [lRequest setValue:[NSString stringWithFormat:@"id=%@", m_sesionID] forHTTPHeaderField:kHeaderCookie];
    
    m_connection = [[NSURLConnection alloc] initWithRequest:lRequest delegate:self startImmediately:YES];
}
//---------------------------------------------------------------------------------------------------------------------
@end
