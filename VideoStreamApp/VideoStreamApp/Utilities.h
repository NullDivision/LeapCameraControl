//
//  Utilities.h
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define __IPHONE_5_0 50000
#define __IPHONE_6_0 60000
#define __IPHONE_7_0 70000

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

@interface Utilities : NSObject

+ (NSInteger) getSystemVersionAsAnInteger;
+ (void) slideAnimateView:(UIView *) pAdded byAddindToView:(UIView *) pParent andFadeIn:(BOOL) pFade;
+ (void) removeAnimateView:(UIView *) pRemoved andFadeOut:(BOOL) pFade animateLeft:(BOOL)pDir;
+ (void) animateView:(UIView *) pView makeVisible:(BOOL)pVisible andRemove:(BOOL) pRemove;
+ (void) animateView:(UIView *) pView makeVisible:(BOOL)pVisible;
+ (void) animateView:(UIView *) pView1 flipToView:(UIView *) pView2 onContainer:(UIView *) pContainer directionRight:(BOOL) pDir;
+ (void) slideUpView:(UIView *) pView onContainer:(UIView *) pContainer;
+ (void) slideDownView:(UIView *) pView onContainer:(UIView *) pContainer;
+ (UIColor*) UIColorFromRGB:(int)rgbValue;
+ (UIColor*) UIColorFromHEX:(NSString*)hexValue;
+ (BOOL) validateEmail: (NSString *) candidate;
+ (BOOL) validatePostCode: (NSString *) candidate;
+ (BOOL) validatePhone: (NSString *) candidate;
+ (BOOL) validateNumber: (NSString *) candidate;
+ (NSString*) optimzePrice:(NSString*) candidate;
+ (NSString*) md5:(NSString *) input;
+ (void) removeAllSubviewsFromView:(UIView*)pView;
+ (void) customizeBordersForInputField:(UIView *) inputField withColor:(UIColor*)pColor;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (NSString *) getCacheDirectory;
+ (NSString *) stringByStrippingHTML:(NSString*)candidate;
+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString*)pTitle;
+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString*)pTitle tag:(int)tag delegate:(id<UIAlertViewDelegate>)delegate;
+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString*)pTitle tag:(int)tag delegate:(id<UIAlertViewDelegate>)delegate otherButtonTitles:(NSString *)otherButtonTitles, ...;
+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString*)pTitle tag:(int)tag delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString*)cancel otherButtonTitles:(NSString *)otherButtonTitles, ...;
+ (NSString*) getNumberThousandSeparated:(NSNumber*)pNumber;
+ (NSString*) removeCharactersFromPhone:(NSString*)pPhone;
+ (void) setSeparatorForCell:(UITableViewCell*)cell;
@end

@interface UIImage (UIImageFunctions)
    - (UIImage *) scaleToSize: (CGSize)size;
    + (UIImage*) blur:(UIImage*)theImage;
    + (UIImage *)imageWithGradient:(UIImage *)img startColor:(UIColor *)color1 endColor:(UIColor *)color2;
    - (UIImage *) scaleProportionalToSize: (CGSize)size;
    - (UIImage *) fixOrientation;
	+ (UIImage *) imageWithColor:(UIColor *)color;
    - (UIImage *) imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
@implementation UIImage (UIImageFunctions)

- (UIImage *) scaleToSize: (CGSize)size
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, 1);
    
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));

    if(self.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);

    CGImageRef scaledImage=CGBitmapContextCreateImage(context);

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    UIImage *image = [UIImage imageWithCGImage: scaledImage];

    CGImageRelease(scaledImage);

    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}

- (UIImage *) scaleProportionalToSize: (CGSize)size1
{
    if(self.size.width>self.size.height)
        size1=CGSizeMake((self.size.width/self.size.height)*size1.height,size1.height);
    else
        size1=CGSizeMake(size1.width,(self.size.height/self.size.width)*size1.width);
    return [self scaleToSize:size1];
}

- (UIImage *) fixOrientation {

    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);

    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor) 
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }

        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }   

    UIGraphicsBeginImageContext(targetSize); // this will crop

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }

    //pop the context to get back to the default
    UIGraphicsEndImageContext();

    return newImage;
}

+ (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of    many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

+ (UIImage *)imageWithGradient:(UIImage *)img startColor:(UIColor *)color1 endColor:(UIColor *)color2 {
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    //CGContextDrawImage(context, rect, img.CGImage);
    
    // Create gradient
    NSArray *colors = [NSArray arrayWithObjects:(id)color2.CGColor, (id)color1.CGColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
    
    // Apply gradient
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0, img.size.height), 0);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    
    return gradientImage;
}
@end
