//
//  UploadBinaryImageOperation.m
//  XMTrade
//
//  Created by Maxim Guzun on 12/6/13.
//
//

#import "UploadBinaryImageOperation.h"
#import "OperationResult.h"

@implementation UploadBinaryImageOperation
//------------------------------------------------------------------------------------------------------------------------
- (void)main
{
    // Show activity
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [m_delegate onUploadImageBinaryData:[self parseJSONResult:[self loadData]] status:[(NSHTTPURLResponse*)_response statusCode]];
    // Hide activity
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
//------------------------------------------------------------------------------------------------------------------------
- (JSONModel*) parseJSONResult:(NSData*)pData
{
    //NSLog(@"UploadBinaryImageOperation JSON:%@", [[NSString alloc] initWithData:pData encoding:NSUTF8StringEncoding]);
    NSError* error;
    OperationResult *_uploadResult = [[OperationResult alloc] initWithData:pData error:&error];
    return _uploadResult;
}
//------------------------------------------------------------------------------------------------------------------------
#pragma mark NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = (NSHTTPURLResponse*)response;
    m_data = [[NSMutableData alloc] init];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [m_data appendData:data];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [m_delegate onUploadImageBinaryData:[self parseJSONResult:[self loadData]] status:[(NSHTTPURLResponse*)_response statusCode]];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // invoke callback on operation complete
    if (m_delegate != nil)
        [m_delegate onError:[error localizedDescription]];
}
//------------------------------------------------------------------------------------------------------------------------
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
//------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
//------------------------------------------------------------------------------------------------------------------------
@end
