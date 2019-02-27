//
//  Shared.m
//  GroupWiish
//
//  Created by apple on 24/06/18.
//  Copyright © 2018 APPMASON STUDIOS. All rights reserved.
//

#import "Shared.h"

@interface NSObject(Extended)

-(void)responseData:(NSData *)data WITHTAG:(int)tag;

@end

@implementation Shared

static Shared * sharedClassObj;

+(Shared *)sharedInstance
{
    if (sharedClassObj == nil)
    {
        sharedClassObj = [[super allocWithZone:NULL] init];
    }
    
    return sharedClassObj;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return sharedClassObj;
}

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        
    }
    
    return self;
}

#pragma mark - Network Checking



#pragma mark - Text field as a Line

-(void)textfieldAsLine:(UITextField *)myTextfield lineColor:(UIColor *)lineColor placeHolder:(NSString *)placeholder placeHolderColor:(UIColor *)placeholderColor myView:(UIView *)view
{
    [myTextfield setBorderStyle:UITextBorderStyleNone];
    myTextfield.placeholder = placeholder;
    [myTextfield setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    CALayer * border = [CALayer layer];
    
    CGFloat borderWidth = 2;
    border.borderColor  = lineColor.CGColor;
    border.frame        = CGRectMake(0, myTextfield.frame.size.height - borderWidth, view.frame.size.width, myTextfield.frame.size.height);
    border.borderWidth  = borderWidth;
    
    [myTextfield.layer addSublayer:border];
    myTextfield.layer.masksToBounds = YES;
}



#pragma mark - Network Error Alert

-(void)networkErrorAlertWithMessage : (NSString *)message OnViewController : (UIViewController *)viewController {
    
    UIView * netWorkView = [[UIView alloc]init];
    netWorkView.frame = CGRectMake(0, 0, viewController.view.frame.size.width, 64);
    netWorkView.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:48.0f/255.0f blue:22.0f/255.0f alpha:1];
    
    UILabel * networkErrorName = [[UILabel alloc]initWithFrame:CGRectMake(3, 10, netWorkView.frame.size.width-6, netWorkView.frame.size.height-6)];
    networkErrorName.minimumScaleFactor = 0.5;
    networkErrorName.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
    networkErrorName.numberOfLines = 3;
    networkErrorName.textAlignment = NSTextAlignmentCenter;
    networkErrorName.text = message;
    networkErrorName.textColor = [UIColor whiteColor];
    
    [netWorkView addSubview:networkErrorName];
    [viewController.view.window addSubview:netWorkView];
    
    netWorkView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.4 delay:0.0 options:0 animations:^{
        
        netWorkView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.8 delay:1.0 options:0 animations:^{
            
            netWorkView.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.4 delay:0.5 options:0 animations:^{
                
                netWorkView.alpha = 1.0f;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.8 delay:1.0 options:0 animations:^{
                    
                    netWorkView.alpha = 0.0f;
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.4 delay:0.5 options:0 animations:^{
                        
                        netWorkView.alpha = 1.0f;
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.8 delay:1.0 options:0 animations:^{
                            
                            netWorkView.alpha = 0.0f;
                            
                        } completion:^(BOOL finished) {
                            
                            [netWorkView removeFromSuperview];
                            
                        }];
                        
                    }];
                    
                    
                }];
                
            }];
            
            
        }];
        
    }];
}

#pragma mark - Default iOS Alert

-(void)showAlertWithTitle :(NSString *)title withMessage: (NSString *)message onViewController: (UIViewController *)viewController completion:(void (^)(void))completionBlock
{
    UIAlertController * suggestionsAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionBlock();
        
    }];
    
    UIAlertAction * noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [suggestionsAlert addAction:okAction];
    [suggestionsAlert addAction:noAction];
    
    [viewController presentViewController:suggestionsAlert animated:YES completion:nil];
}




#pragma Email-Validation

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString    * emailRegex  = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate * emailTest   = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

#pragma Mobile-Validation

-(BOOL)validatePhoneNumber:(NSString *)PhoneNum
{
    PhoneNum = [[PhoneNum componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];

    NSString * phoneRegex = @"[23456789][0-9]{6}([0-9]{3})?";
    NSPredicate * test    = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    BOOL matches = [test evaluateWithObject:PhoneNum];
    
    return matches;
}

- (BOOL)MobileNumberValidate:(NSString*)number
{
    NSString * numberRegEx   = @"[0-9]";
    NSPredicate * numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}


//-(void)dismissToast
//{
//    [self.wavesView removeFromSuperview];
//}

#pragma Image Convert

-(NSData *)imageconvert :(NSString *)image
{
    NSURL  * imageUrl  = [NSURL URLWithString:image];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    return imageData;
}

#pragma Date Convert

-(id)dateconvert :(id)date Format:(NSString *)format Convertion :(BOOL)normal
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    if(normal)
    {
        return [formatter dateFromString:date];
        
    }else{
        return [formatter stringFromDate:date];
    }
}

#pragma Time Ago

- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSCalendar * cal     = [NSCalendar currentCalendar];
    NSDateComponents * components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate * today                 = [cal dateFromComponents:components1];
    components1      = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *thatdate = [cal dateFromComponents:components1];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:thatdate
                                                                     toDate:today
                                                                options:0];
    if (components.year > 0)
    {return [NSString stringWithFormat:@"%li %@ %li",(long)[components1 day],[self dateconvert:date Format:@"MMMM" Convertion:NO],(long)[components1 year]];
    }
    else if (components.month > 0)
    {return [NSString stringWithFormat:@"%li %@ %li",(long)[components1 day],[self dateconvert:date Format:@"MMMM" Convertion:NO],(long)[components1 year]];
    }
    else if (components.weekOfYear > 0)
    {return components.weekOfYear == 1 ? [NSString stringWithFormat:@"%ld week ago", (long)components.weekOfYear] :[NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    }
    else if (components.day > 0)
    {if (components.day > 1)
        {return components.day == 1 ? [NSString stringWithFormat:@"%ld day ago", (long)components.day] : [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        }else
        {return @"Yesterday";
        }
    }
    else
    {return @"Today";
    }
}

-(UIFont *)appFont:(AppFontStyle)style withSize:(int)size
{
    UIFont * font = nil;
    
    switch (style)
    {
        case REGULAR:
            font = [UIFont fontWithName:@"OpenSans-Regular" size:size];
            break;
            
        case MEDIUM:
            font = [UIFont fontWithName:@"OpenSans-Semibold" size:size];
            break;
            
        case BOLD:
            font = [UIFont fontWithName:@"OpenSans-Bold" size:size];
            break;
            
        default:
            break;
    }
    
    return font;
}

-(NSString*)trim:(NSString*)str
{
    return [str stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}

-(UIColor *)appColor
{
    return [UIColor blueColor];
}

-(UIImage *)resizeImage:(UIImage *)image maxHeight:(CGFloat)maxHeight maxWidth:(CGFloat)maxWidth
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma Top-Viewcontroller

- (UIViewController *)topViewController
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self topViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self topViewController:rootViewController];
    }
    return rootViewController;
}

#pragma Color From Hexa

-(UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
