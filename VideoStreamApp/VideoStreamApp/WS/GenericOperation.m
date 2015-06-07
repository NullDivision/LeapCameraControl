//
//  GenericOperation.m
//  Kraftera
//
//  Created by Maxim Guzun on 6/1/15.
//  Copyright (c) 2015 SmartData. All rights reserved.
//

#import "GenericOperation.h"

@implementation GenericOperation
//------------------------------------------------------------------------------------------------------------------------
- (void)main {
    // Show activity
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.block((NSMutableData*)[self loadData], [(NSHTTPURLResponse*)_response statusCode], self.m_index);
    // Hide activity
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
//------------------------------------------------------------------------------------------------------------------------
#pragma mark NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _response = response;
    m_data = [[NSMutableData alloc] init];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [m_data appendData:data];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.block(m_data, [(NSHTTPURLResponse*)_response statusCode], self.m_index);
}
//------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // invoke callback on operation complete
    if (m_delegate != nil)
        [m_delegate onError:[error localizedDescription]];
}
//------------------------------------------------------------------------------------------------------------------------
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
//------------------------------------------------------------------------------------------------------------------------
@end
