//
//  Shared.h
//  GroupWiish
//
//  Created by apple on 24/06/18.
//  Copyright © 2018 APPMASON STUDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJWavesView.h"
typedef NS_OPTIONS(NSUInteger, AppFontStyle)
{
    REGULAR  = 0,
    MEDIUM   = 1,
    BOLD     = 2
};

@interface Shared : NSObject

@property(nonatomic,retain) NSMutableURLRequest * request;
@property(nonatomic,retain) NSURLSession        * session;

@property ZJWavesView   * wavesView;
@property UILabel       * ToastLabel;

+(Shared *)sharedInstance;

-(void)textfieldAsLine:(UITextField *)myTextfield lineColor:(UIColor *)lineColor placeHolder:(NSString *)placeholder placeHolderColor:(UIColor *)placeholderColor myView:(UIView *)view;

-(void)networkErrorAlertWithMessage : (NSString *)message OnViewController : (UIViewController *)viewController;

-(void)showprogress:(NSString *)str ForViewController:(UIViewController *)vc;

-(void)webAPIRequestHelper:(NSObject *)delegate
                        VC :(UIViewController *)viewcontroller
                   POSTDATA:(NSMutableDictionary *)dicPostData
                        TAG:(int)tag
                 HTTPMethod:(NSString *)httpMethod;

-(void)CustomAlertWithMessage : (NSString *)message titleMessage : (NSString *) title onViewController : (UIViewController *)viewcontroller typeOfAlert : (NSString *)type;

-(void)showToastWithMessage:(NSString *)message onVc :(UIViewController *)vc Type :(NSString *)type;

-(void)showAlertWithTitle :(NSString *)title withMessage: (NSString *)message onViewController: (UIViewController *)viewController completion:(void (^)(void))completionBlock;

-(BOOL)validateEmailWithString:(NSString*)email;

-(BOOL)MobileNumberValidate:(NSString*)number;

-(BOOL)validatePhoneNumber:(NSString *)PhoneNum;

-(BOOL)isNetworkAvalible;

-(NSData *)imageconvert :(NSString *)image;

-(id)dateconvert :(id)date Format:(NSString *)format Convertion :(BOOL)normal;

-(NSString *)relativeDateStringForDate:(NSDate *)date;

-(UIImage *)resizeImage:(UIImage *)image maxHeight:(CGFloat)maxHeight maxWidth:(CGFloat)maxWidth;

-(UIColor *)appColor;

-(NSString*)trim:(NSString*)str;

-(UIFont *)appFont:(AppFontStyle)style withSize:(int)size;

-(UIViewController *)topViewController;

-(UIViewController *)topViewController:(UIViewController *)rootViewController;

-(UIColor *)colorFromHexString:(NSString *)hexString;

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size;

@end
