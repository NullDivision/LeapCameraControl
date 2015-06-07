//
//  SocketManager.h
//  iTaxi
//
//  Created by Maxim Guzun on 3/21/15.
//  Copyright (c) 2015 SmartData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@protocol SocketManagerProtocol <NSObject>
@required
- (void) onReceiveSocketData:(id)data;
@end

@interface SocketManager : NSObject<SRWebSocketDelegate>{
    SRWebSocket                 *m_socket;
    id<SocketManagerProtocol>   m_delegate;
}
+ (id) getSharedInstanceForDelegate:(id<SocketManagerProtocol>)delegate;
- (void) send:(id)data;
- (void) reset;
- (void) disconnect;
@end
