//
//  Utilities.m
//

#import "Utilities.h"

@implementation Utilities
//------------------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}
//------------------------------------------------------------------------------------------------------------------------
+ (NSInteger) getSystemVersionAsAnInteger{
    int index = 0;
    NSInteger version = 0;
    
    NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSEnumerator* enumer = [digits objectEnumerator];
    NSString* number;
    while (number = [enumer nextObject]) {
        if (index>2) {
            break;
        }
        NSInteger multipler = powf(100, 2-index);
        version += [number intValue]*multipler;
        index++;
    }
    return version;
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) slideAnimateView:(UIView *) pAdded byAddindToView:(UIView *) pParent andFadeIn:(BOOL) pFade{

    CGRect lChildrame = pAdded.frame;
    lChildrame.origin.x = 0;
    lChildrame.origin.y = 0;
    CGRect lInitialFrame = lChildrame;
    if(pFade)
        pAdded.alpha = 0.0f;
    else
        pAdded.alpha = 1.0f;

    lInitialFrame.origin.x += pAdded.frame.size.width;
    pAdded.frame = lInitialFrame;
    [pParent addSubview:pAdded];
    [UIView beginAnimations:@"ToolBox:SlideView" context:nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    if(pFade)
        pAdded.alpha = 1.0f;
    pAdded.frame = lChildrame;

    [UIView commitAnimations];
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) removeAnimateView:(UIView *) pRemoved andFadeOut:(BOOL) pFade animateLeft:(BOOL)pDir{
    CGRect lChildrame = pRemoved.frame;
    CGRect lInitialFrame = lChildrame;
    if(pFade)
        pRemoved.alpha = 1.0f;
    if(pDir)
        lInitialFrame.origin.x += pRemoved.frame.size.width;
    else
        lInitialFrame.origin.x -= pRemoved.frame.size.width;
    [UIView beginAnimations:@"ToolBox:RemoveView" context:nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    if(pFade)
        pRemoved.alpha = 0.0f;
    pRemoved.frame = lInitialFrame;
    [UIView commitAnimations];
    [pRemoved performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5f];
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) animateView:(UIView *) pView1 flipToView:(UIView *) pView2 onContainer:(UIView *) pContainer directionRight:(BOOL) pDir
{
    [UIView beginAnimations:@"ToolBox:View Flip" context:nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.75f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    if(pDir){
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight
                           forView: pContainer
                             cache: YES];
    }
    else
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft
                               forView: pContainer
                                 cache: YES];
    //[pView1 removeFromSuperview];
    [pContainer addSubview:pView2];
    [UIView commitAnimations];
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) animateView:(UIView *) pView makeVisible:(BOOL)pVisible andRemove:(BOOL) pRemove{
 //   pView.hidden = !pVisible;
    if(pVisible)
        pView.alpha = 0.0f;
    else
        pView.alpha = 1.0f;
    [UIView beginAnimations:@"ToolBox:VisibleView" context:nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.5f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    if(pVisible)
        pView.alpha = 1.0f;
    else
        pView.alpha = 0.0f;
    [UIView commitAnimations];
    if (pRemove) {
        [pView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.6f];
    }
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) animateView:(UIView *) pView makeVisible:(BOOL)pVisible{
    [Utilities animateView:pView makeVisible:pVisible andRemove:NO];
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) slideUpView:(UIView *) pView onContainer:(UIView *) pContainer
{
    CGRect origin =  pView.frame;
    pView.alpha = 0.0f;
    [pView setFrame:origin];
    //[pContainer addSubview:pView]; 
    
    [UIView beginAnimations:@"ToolBox:SlideUpView" context:nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.5f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    origin.origin.y = (origin.origin.y - origin.size.height);
    [pView setFrame:origin];
    pView.alpha = 1.0f;
    [UIView commitAnimations];
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) slideDownView:(UIView *) pView onContainer:(UIView *) pContainer
{
    CGRect origin = pView.frame;
    pView.alpha = 1.0f;
    [pView setFrame:origin];
    //[pContainer addSubview:pView]; 
    
    [UIView beginAnimations:@"ToolBox:SlideDownView" context:nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.5f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    origin.origin.y = (origin.origin.y + origin.size.height);
    [pView setFrame:origin];
    pView.alpha = 0.0f;
    [UIView commitAnimations];
}
//------------------------------------------------------------------------------------------------------------------------
+ (UIColor*) UIColorFromRGB:(int)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}
//------------------------------------------------------------------------------------------------------------------------
+ (UIColor*) UIColorFromHEX:(NSString*)hexValue
{
    unsigned int color;
    [[NSScanner scannerWithString:hexValue] scanHexInt:&color];
    return [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:1.0];
}
//------------------------------------------------------------------------------------------------------------------------
+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //  return 0;
    return [emailTest evaluateWithObject:candidate];
}
//------------------------------------------------------------------------------------------------------------------------
+ (BOOL) validatePostCode: (NSString *) candidate {
    NSString *postRegex = @"[A-B0-9]{5,5}";
    NSPredicate *postTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postRegex];
    //  return 0;
    return [postTest evaluateWithObject:candidate];
}
//------------------------------------------------------------------------------------------------------------------------
+ (BOOL) validatePhone: (NSString *) candidate {
    NSString *phoneRegex = @"[0-9]{1,14}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    //  return 0;
    return [phoneTest evaluateWithObject:candidate];
}
//------------------------------------------------------------------------------------------------------------------------
+ (NSString*) removeCharactersFromPhone:(NSString*)pPhone
{
    return [[[[pPhone stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"(" withString:@""];
}
//------------------------------------------------------------------------------------------------------------------------
+ (NSString*) getNumberThousandSeparated:(NSNumber*)pNumber
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    return [numberFormatter stringFromNumber:pNumber];
}
//------------------------------------------------------------------------------------------------------------------------
+ (BOOL) validateNumber: (NSString *) candidate
{
    if(![candidate length])
        return TRUE;

    NSString *phoneRegex = @"[0-9]{1,14}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    //  return 0;
    return [phoneTest evaluateWithObject:candidate];
}
//------------------------------------------------------------------------------------------------------------------------
+ (NSString*) optimzePrice:(NSString*) candidate
{
    long long value = [candidate longLongValue];
    long long tail = value%200;
    long long price = value - tail;
    
    if(price > 10000000)
        return [NSString stringWithFormat:@"10000000"];
    else
        return [NSString stringWithFormat:@"%llu", price];
}
//------------------------------------------------------------------------------------------------------------------------
+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) removeAllSubviewsFromView:(UIView *)pView
{
    for(int i=0; i<[pView.subviews count]; i++)
    {
        UIView *tmp = [pView.subviews objectAtIndex:i];
        if(tmp==nil)
            continue;
        else
        [tmp removeFromSuperview];
    }
}
//------------------------------------------------------------------------------------------------------------------------
+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString*)pTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pTitle message:message
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
//---------------------------------------------------------------------------------------------------------
+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString*)pTitle tag:(int)tag delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pTitle message:message
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setTag:tag];
    [alert setDelegate:delegate];
    [alert show];
}
//---------------------------------------------------------------------------------------------------------
+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString*)pTitle tag:(int)tag delegate:(id<UIAlertViewDelegate>)delegate otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pTitle message:message
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:otherButtonTitles, nil];
    [alert setTag:tag];
    [alert setDelegate:delegate];
    [alert show];
}
//---------------------------------------------------------------------------------------------------------
+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString*)pTitle tag:(int)tag delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString*)cancel otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pTitle message:message
                                                   delegate:nil cancelButtonTitle:cancel otherButtonTitles:otherButtonTitles, nil];
    [alert setTag:tag];
    [alert setDelegate:delegate];
    [alert show];
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) customizeBordersForInputField:(UIView *) inputField withColor:(UIColor*)pColor
{
    inputField.layer.cornerRadius = 6.0f;
    inputField.layer.borderWidth  = 1.0f;
    inputField.layer.masksToBounds = YES;
    inputField.layer.borderColor  = [pColor CGColor];
}
//------------------------------------------------------------------------------------------------------------------------
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getCacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"XMTRADE"];
}
//------------------------------------------------------------------------------------------------------------------------
+ (NSString *) stringByStrippingHTML:(NSString*)candidate
{
    NSRange r;
    while ((r = [candidate rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        candidate = [candidate stringByReplacingCharactersInRange:r withString:@""];
    
    // remove the last 
    candidate = [candidate stringByReplacingOccurrencesOfString:@"[" withString:@""];
    candidate = [candidate stringByReplacingOccurrencesOfString:@"]" withString:@""];
    return candidate;
}
//------------------------------------------------------------------------------------------------------------------------
+ (void) setSeparatorForCell:(UITableViewCell*)cell
{
    UIView *_separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    [_separator setBackgroundColor:[Utilities UIColorFromRGB:kMainGrayLight]];
    [cell.contentView addSubview:_separator];
    [_separator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin];
}
//------------------------------------------------------------------------------------------------------------------------
@end
