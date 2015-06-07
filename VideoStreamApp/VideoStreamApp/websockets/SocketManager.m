//
//  SocketManager.m
//  iTaxi
//
//  Created by Maxim Guzun on 3/21/15.
//  Copyright (c) 2015 SmartData. All rights reserved.
//

#import "SocketManager.h"
//#import "AccountInfo.h"


static SocketManager *sharedInstance;
@implementation SocketManager
//------------------------------------------------------------------------------------------------------------------------
+ (id) getSharedInstanceForDelegate:(id<SocketManagerProtocol>)delegate
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[SocketManager alloc] init];
        //[sharedInstance updateDelegate:delegate];
    }

    return sharedInstance;
}
//------------------------------------------------------------------------------------------------------------------------
- (void) updateDelegate:(id<SocketManagerProtocol>)delegate
{
    m_delegate = delegate;
    [self _reconnect];
}
//------------------------------------------------------------------------------------------------------------------------
#pragma mark web socket delegate
//------------------------------------------------------------------------------------------------------------------------
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    [m_delegate onReceiveSocketData:message];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)_reconnect;
{
    m_socket.delegate = nil;
    [m_socket close];
    m_socket = nil;
    if(!m_socket)
    {
        NSString *_server = [[NSUserDefaults standardUserDefaults] valueForKey:kSkipper_server];
        m_socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:_server] sessionID:[[NSUserDefaults standardUserDefaults] valueForKey:kSkipper_user]];
        [m_socket setDelegate:self];
    }
    [m_socket open];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@", [error localizedDescription]);
}
//------------------------------------------------------------------------------------------------------------------------
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSLog(@"didReceivePong:%@", [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding]);
}
//------------------------------------------------------------------------------------------------------------------------
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    NSLog(@"Websocket Connected");
}
//------------------------------------------------------------------------------------------------------------------------
- (void) send:(id)data{
    [m_socket send:data];
}
//------------------------------------------------------------------------------------------------------------------------
- (void) reset{
    [self _reconnect];
}
//------------------------------------------------------------------------------------------------------------------------
- (void) disconnect{
    
    m_socket.delegate = nil;
    [m_socket close];
    m_socket = nil;
    NSLog(@"Websocket closed");
}
//------------------------------------------------------------------------------------------------------------------------
@end
