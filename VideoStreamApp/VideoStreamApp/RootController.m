//
//  RootController.m
//  VideoStreamApp
//
//  Created by Maxim Guzun on 6/6/15.
//  Copyright (c) 2015 Maxim Guzun. All rights reserved.
//

#import "RootController.h"
#import "CameraSourceCell.h"
#import "Utilities.h"
#import "WS.h"
#import "OperationProtocol.h"
#import "SocketManager.h"
#import "CommandItem.h"
@import AVFoundation;
//#import <VCSimpleSession.h>

@interface RootController ()<AVCaptureVideoDataOutputSampleBufferDelegate, UITabBarDelegate, UITableViewDataSource, OperationProtocol, SocketManagerProtocol>{
    
    IBOutlet UIImageView        *m_preview;
    NSMutableArray              *m_cameras;
    IBOutlet UITableView        *m_table;
    IBOutlet UIButton           *m_btnStream;
    AVCaptureSession            *m_captureSession;
    NSInteger                   _currentZoomLevel;
    BOOL canStream;
    NSInteger                   _selectedSource;
    NSInteger                   _granularity;
    
    IBOutlet UIButton           *m_btnTourch;
}
@end

@implementation RootController

//------------------------------------------------------------------------------------------------------------------------
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:@"RootController" bundle:[NSBundle mainBundle]];
    if (self)
    {
        //TODO
        m_cameras = [[NSMutableArray alloc] init];
        [self.view setFrame:frame];
    }
    return self;
}
//------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildCameraSourceList];
    [m_table reloadData];
    
    
    [Utilities customizeBordersForInputField:m_btnStream withColor:[UIColor clearColor]];
    [m_btnStream setBackgroundImage:[UIImage imageWithColor:[Utilities UIColorFromRGB:kMainGreen]] forState:UIControlStateNormal];
}
//------------------------------------------------------------------------------------------------------------------------
- (void) buildCameraSourceList{
    [m_cameras removeAllObjects];
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        NSLog(@"Device name: %@", [device localizedName]);
        if ([device hasMediaType:AVMediaTypeVideo]) {
            // add the video device to the list
            [m_cameras addObject:device];
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
            }
            else {
                NSLog(@"Device position : front");
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Delegate
//------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return m_cameras.count;
}
//------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(m_captureSession.isRunning)
        [self startStreamWithSource:[m_cameras objectAtIndex:indexPath.row]];
}
//------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
//------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CameraSourceCell *_cell = [tableView dequeueReusableCellWithIdentifier:[CameraSourceCell reuseIdentifier]];
    if(!_cell)
    {
        _cell = [CameraSourceCell getCell];
        [_cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [Utilities setSeparatorForCell:_cell];
    }
    [_cell setSourceInfo:[m_cameras objectAtIndex:indexPath.row]];
    return _cell;
}
//------------------------------------------------------------------------------------------------------------------------
- (void) startStreamWithSource:(AVCaptureDevice*)source{

    canStream = TRUE;
    _currentZoomLevel = 1;
    [m_btnTourch setSelected:FALSE];
    [m_preview setImage:nil];
    [m_captureSession stopRunning];
    
        @try {
            for(CALayer *layer in m_preview.layer.sublayers)
                [layer removeFromSuperlayer];
        }
        @catch (NSException *exception) {
            //TODO
        }
        @finally {
            //TODO
        }
    
    NSError *deviceError;
    AVCaptureDeviceInput *inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:source error:&deviceError];
    
    // make output device
    AVCaptureVideoDataOutput *outputDevice = [[AVCaptureVideoDataOutput alloc] init];
    [outputDevice setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
    
    [outputDevice setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey]];
    m_captureSession = nil;
    m_captureSession = [[AVCaptureSession alloc] init];
    m_captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    
    [m_captureSession addInput:inputDevice];
    [m_captureSession addOutput:outputDevice];
    
    // make preview layer and add so that camera's view is displayed on screen
    
    AVCaptureVideoPreviewLayer  *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:m_captureSession];
    previewLayer.frame = m_preview.frame;
    [m_preview.layer addSublayer:previewLayer];
    
    // go!
    [m_captureSession startRunning];
}
//------------------------------------------------------------------------------------------------------------------------
-(void) captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection
{
    _granularity++;
    if(_granularity > kGranularyTrashold)
    {
        CGImageRef cgImage = [self imageFromSampleBuffer:sampleBuffer];
        NSData *_imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage: cgImage ], kCompression);
        CGImageRelease( cgImage );
        
        CommandItem *_command = [[CommandItem alloc] init];
        _command.data = [self base64forData:_imageData];
        _command.usr = [[NSUserDefaults standardUserDefaults] valueForKey:kSkipper_user];
        _command.cmd = [NSNumber numberWithInt:CMD_VIDEO_SEND];
        [[SocketManager getSharedInstanceForDelegate:self] send:[_command toJSONString]];
        _granularity = 0;
    }
    
    /*
    CGImageRef cgImage = [self imageFromSampleBuffer:sampleBuffer];
    NSData *_imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage: cgImage ], kCompression);
    CGImageRelease( cgImage );
    
    CommandItem *_command = [[CommandItem alloc] init];
    _command.data = [self base64forData:_imageData];
    _command.usr = [NSNumber numberWithInt:kUserID];
    _command.cmd = [NSNumber numberWithInt:CMD_VIDEO_SEND];
    [[SocketManager getSharedInstanceForDelegate:self] send:[_command toJSONString]];
     */
    
    //[[SocketManager getSharedInstanceForDelegate:self] send:[self base64forData:_imageData]];
    //[[SocketManager getSharedInstanceForDelegate:self] send:_imageData];
    //[[WS getShareInstance] uploadImageBinary:_imageData forDelegate:self];
    
    /*
    if(canStream)
    {
        _granularity++;
        if(_granularity > 10)
        {
            CGImageRef cgImage = [self imageFromSampleBuffer:sampleBuffer];
            NSData *_imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage: cgImage ], kCompression);
            CGImageRelease( cgImage );
            //[[SocketManager getSharedInstanceForDelegate:self] send:_imageData];
            [[WS getShareInstance] uploadImageBinary:_imageData forDelegate:self];
            canStream = FALSE;
            _granularity = 0;
        }
    }
     */
}
//------------------------------------------------------------------------------------------------------------------------
- (IBAction) stopStream:(id)sender{
    
    if(m_captureSession.isRunning)
    {
        [m_btnStream setTitle:@"Start stream" forState:UIControlStateNormal];
        [m_btnStream setBackgroundImage:[UIImage imageWithColor:[Utilities UIColorFromRGB:kMainGreen]] forState:UIControlStateNormal];
        
        [m_captureSession stopRunning];
        canStream = FALSE;
        
        @try {
            for(CALayer *layer in m_preview.layer.sublayers)
                [layer removeFromSuperlayer];
        }
        @catch (NSException *exception) {
            //TODO
        }
        @finally {
            //TODO
        }
        
        [m_preview setImage:[UIImage imageNamed:@"logo"]];
        
        NSData *_imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"team"], kCompression);
        CommandItem *_command = [[CommandItem alloc] init];
        _command.data = [self base64forData:_imageData];
        _command.usr = [[NSUserDefaults standardUserDefaults] valueForKey:kSkipper_user];
        _command.cmd = [NSNumber numberWithInt:CMD_VIDEO_SEND];
        [[SocketManager getSharedInstanceForDelegate:self] send:[_command toJSONString]];
        [[SocketManager getSharedInstanceForDelegate:self] disconnect];
    }
    else
    {
        [[SocketManager getSharedInstanceForDelegate:self] reset];
        [m_btnStream setBackgroundImage:[UIImage imageWithColor:[Utilities UIColorFromRGB:kMainRed]] forState:UIControlStateNormal];
        [m_btnStream setTitle:@"End stream" forState:UIControlStateNormal];
        [self performSelector:@selector(startBroadcast) withObject:nil afterDelay:1];
    }
}
//------------------------------------------------------------------------------------------------------------------------
- (void) startBroadcast
{
    [self startStreamWithSource:m_cameras.firstObject];
}
//------------------------------------------------------------------------------------------------------------------------
- (void) onError:(NSString *)pMessage
{
    canStream = TRUE;
}
//------------------------------------------------------------------------------------------------------------------------
- (void) onUploadImageBinaryData:(JSONModel *)pResult status:(NSInteger)status
{
    canStream = TRUE;
}
//------------------------------------------------------------------------------------------------------------------------
- (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer // Create a CGImageRef from sample buffer data
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    /* CVBufferRelease(imageBuffer); */  // do not call this!
    
    return newImage;
}
//------------------------------------------------------------------------------------------------------------------------
- (void) enableTourch:(BOOL)enable{
    
    AVCaptureDevice *device = [self getCurrentDevice];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode:enable];  // use AVCaptureTorchModeOff to turn off
        [device unlockForConfiguration];
    }
    [m_btnTourch setSelected:enable];
}
//------------------------------------------------------------------------------------------------------------------------
- (void) zoomIn{
    
    if(IS_IPAD)
        return;
    
    AVCaptureDevice *device = [self getCurrentDevice];
    
    _currentZoomLevel ++;
    if(_currentZoomLevel > kMaxZoom)
        _currentZoomLevel = kMaxZoom;
    
    NSError *error = nil;
    if ([device lockForConfiguration:&error]) {
        device.videoZoomFactor = _currentZoomLevel;
        [device unlockForConfiguration];
    } else {
        NSLog(@"error: %@", error);
    }
}
//------------------------------------------------------------------------------------------------------------------------
- (void) zoomOut{
    
    if(IS_IPAD)
        return;
    
    AVCaptureDevice *device = [self getCurrentDevice];
    
    _currentZoomLevel --;
    if(_currentZoomLevel < 1)
        _currentZoomLevel = 1;
    
    NSError *error = nil;
    if ([device lockForConfiguration:&error]) {
        device.videoZoomFactor = _currentZoomLevel;
        [device unlockForConfiguration];
    } else {
        NSLog(@"error: %@", error);
    }
}
//------------------------------------------------------------------------------------------------------------------------
- (AVCaptureDevice*) getCurrentDevice{
    return [m_cameras objectAtIndex:_selectedSource];
}
//------------------------------------------------------------------------------------------------------------------------
- (IBAction) onZoomIn:(id)sender{
    [self zoomIn];
}
//------------------------------------------------------------------------------------------------------------------------
- (IBAction) onZoomOut:(id)sender{
    [self zoomOut];
}
//------------------------------------------------------------------------------------------------------------------------
- (IBAction) onTourch:(UIButton*)sender{
    
    [self enableTourch:!sender.selected];
}
//------------------------------------------------------------------------------------------------------------------------
#pragma mark web socket delegate
//------------------------------------------------------------------------------------------------------------------------
- (void) onReceiveSocketData:(id)data
{
    NSError *error;
    //NSLog(@"DATA:%@", data);
    CommandItem *_command = [[CommandItem alloc] initWithString:data usingEncoding:NSASCIIStringEncoding error:&error];
    if(_command)
    {
        switch(_command.cmd.intValue)
        {
            case    CMD_ZOOM_IN:
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:kSkipper_user] integerValue] == _command.usr.intValue)
                    [self zoomIn];
            }break;
                
            case    CMD_ZOOM_OUT:
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:kSkipper_user] integerValue] == _command.usr.intValue)
                    [self zoomOut];
            };break;
                
            case    CMD_TORCH_ON:
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:kSkipper_user] integerValue] == _command.usr.intValue)
                    [self enableTourch:TRUE];
            }break;
                
            case    CMD_TORCH_OFF:
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:kSkipper_user] integerValue] == _command.usr.intValue)
                    [self enableTourch:FALSE];
            }break;
            default:break;
        }
    }
}
//------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
{
    //[SocketManager getSharedInstanceForDelegate:self];
}
//------------------------------------------------------------------------------------------------------------------------
- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
//------------------------------------------------------------------------------------------------------------------------
@end
