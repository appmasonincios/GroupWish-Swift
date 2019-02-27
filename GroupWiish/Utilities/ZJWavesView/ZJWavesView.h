#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZJWavesType) {
    ZJWavesTypeSin,
    ZJWavesTypeCos,
};

typedef NS_ENUM(NSUInteger, ZJWavesViewWaveLocation) {
    ZJWavesViewWaveLocationBottom = 0,
    ZJWavesViewWaveLocationTop = 1,
};


@interface ZJWaves : UIView

@end


IB_DESIGNABLE
@interface ZJWavesView : UIView

@property (nonatomic, strong) IBInspectable UIColor *wavesColor;

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSUInteger location;
#else
@property (nonatomic, assign) ZJWavesViewWaveLocation location;
#endif

@property (nonatomic, assign) IBInspectable BOOL isAnimateWave;

- (instancetype)initWithFrame:(CGRect)frame
                     location:(ZJWavesViewWaveLocation)location
                   wavesColor:(UIColor *)wavesColor
                isAnimateWave:(BOOL)isAnimateWave;

+ (instancetype)waveWithFrame:(CGRect)frame
                     location:(ZJWavesViewWaveLocation)location
                   wavesColor:(UIColor *)wavesColor
                isAnimateWave:(BOOL)isAnimateWave;

@end
