#import "ZJWavesView.h"

#define ZJWavesColor [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1]

@interface ZJWaves ()

@property (nonatomic, assign) CGFloat waveA;
@property (nonatomic, assign) CGFloat waveW;
@property (nonatomic, assign) CGFloat wavesSpeed;
@property (nonatomic, assign) CGFloat wavesWidth;
@property (nonatomic, assign) CGFloat currentK;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) ZJWavesType wavesType;
@property (nonatomic, assign) ZJWavesViewWaveLocation location;
@property (nonatomic, strong) UIColor *wavesColor;
@property (nonatomic, strong) CADisplayLink *wavesDisplayLink;
@property (nonatomic, strong) CAShapeLayer *wavesLayer;

- (instancetype)initWithFrame:(CGRect)frame
                        waveA:(CGFloat)waveA
                        waveW:(CGFloat)waveW
                   wavesSpeed:(CGFloat)wavesSpeed
                   wavesWidth:(CGFloat)wavesWidth
                     currentK:(CGFloat)currentK
                    wavesType:(ZJWavesType)wavesType
                     location:(ZJWavesViewWaveLocation)location
                   wavesColor:(UIColor *)wavesColor;

@end

@implementation ZJWaves

- (instancetype)initWithFrame:(CGRect)frame
                        waveA:(CGFloat)waveA
                        waveW:(CGFloat)waveW
                   wavesSpeed:(CGFloat)wavesSpeed
                   wavesWidth:(CGFloat)wavesWidth
                     currentK:(CGFloat)currentK
                    wavesType:(ZJWavesType)wavesType
                     location:(ZJWavesViewWaveLocation)location
                   wavesColor:(UIColor *)wavesColor
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.alpha = 0.6;
        
        _waveA = waveA;
        _waveW = waveW;
        _wavesSpeed = wavesSpeed;
        _wavesWidth = wavesWidth;
        _currentK = currentK;
        _wavesType = wavesType;
        _location = location;
        _wavesColor = wavesColor;

        self.wavesLayer = [CAShapeLayer layer];
        self.wavesLayer.fillColor = self.wavesColor.CGColor;
        [self.layer addSublayer:self.wavesLayer];
        
        self.wavesDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
        [self.wavesDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)getCurrentWave:(CADisplayLink *)displayLink
{
    _offsetX += _wavesSpeed;
    
    [self setCurrentFirstWaveLayerPath];
}

- (void)setCurrentFirstWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat y = _currentK;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (NSInteger i = 0.0f; i <= _wavesWidth; i++) {

        if (self.wavesType == ZJWavesTypeSin) {
            y = _waveA * sin(_waveW * i + _offsetX) + _currentK;
        } else {
            y = _waveA * cos(_waveW * i + _offsetX) + _currentK;
        }
        
        CGPathAddLineToPoint(path, nil, i, y);
    }
    
    if (self.location == ZJWavesViewWaveLocationTop) {
        CGPathAddLineToPoint(path, nil, _wavesWidth, self.frame.size.height);
        CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    } else {
        CGPathAddLineToPoint(path, nil, _wavesWidth, 0);
        CGPathAddLineToPoint(path, nil, 0, 0);
    }
    
    CGPathCloseSubpath(path);
    self.wavesLayer.path = path;
    
    CGPathRelease(path);
}

#pragma mark - setter & getter
- (void)setWavesColor:(UIColor *)wavesColor
{
    _wavesColor = wavesColor;
    
    self.wavesLayer.fillColor = self.wavesColor.CGColor;
}

- (void)setLocation:(ZJWavesViewWaveLocation)location
{
    _location = location;
}

- (void)dealloc
{
    [self.wavesDisplayLink invalidate];
}

@end

@interface ZJWavesView ()
@property (nonatomic, strong) ZJWaves *firstWares;
@property (nonatomic, strong) ZJWaves *secondWares;
@property (nonatomic, strong) NSTimer *animationWaveTimer;
@end

@implementation ZJWavesView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.location = ZJWavesViewWaveLocationBottom;
        self.wavesColor = ZJWavesColor;
        self.isAnimateWave = NO;
        [self addWaresViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame location:ZJWavesViewWaveLocationBottom wavesColor:ZJWavesColor isAnimateWave:NO];
}

- (instancetype)initWithFrame:(CGRect)frame
                     location:(ZJWavesViewWaveLocation)location
                   wavesColor:(UIColor *)wavesColor
                isAnimateWave:(BOOL)isAnimateWave
{
    self = [super initWithFrame:frame];
    if (self) {
        self.location = location;
        self.wavesColor = wavesColor;
        self.isAnimateWave = isAnimateWave;
        [self addWaresViews];
    }
    return self;
}

+ (instancetype)waveWithFrame:(CGRect)frame
                     location:(ZJWavesViewWaveLocation)location
                   wavesColor:(UIColor *)wavesColor
                isAnimateWave:(BOOL)isAnimateWave
{
    return [[ZJWavesView alloc] initWithFrame:frame location:location wavesColor:wavesColor isAnimateWave:isAnimateWave];
}

#pragma mark 添加波纹视图
- (void)addWaresViews
{
    self.firstWares = [[ZJWaves alloc] initWithFrame:self.bounds waveA:12 waveW:0.5/30.0 wavesSpeed:0.02 wavesWidth:self.frame.size.width currentK:self.frame.size.height*0.5 wavesType:ZJWavesTypeSin location:self.location wavesColor:self.wavesColor];
    self.secondWares = [[ZJWaves alloc] initWithFrame:self.bounds waveA:13 waveW:0.5/30.0 wavesSpeed:0.04 wavesWidth:self.frame.size.width currentK:self.frame.size.height*0.5 wavesType:ZJWavesTypeCos location:self.location wavesColor:self.wavesColor];

    self.firstWares.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.secondWares.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.firstWares];
    [self addSubview:self.secondWares];
}

#pragma mark 震荡效果
- (void)animateWave
{
    CGFloat adjustedValue = 20;
    [UIView animateWithDuration:1.0f animations:^{
        self.firstWares.transform = CGAffineTransformMakeTranslation(0, (self.location == ZJWavesViewWaveLocationBottom) ? adjustedValue : -adjustedValue);
        self.secondWares.transform = CGAffineTransformMakeTranslation(0, (self.location == ZJWavesViewWaveLocationBottom) ? adjustedValue : -adjustedValue);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            self.firstWares.transform = CGAffineTransformMakeTranslation(0, 0);
            self.secondWares.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
    }];
}

#pragma mark - setter & getter
- (void)setWavesColor:(UIColor *)wavesColor
{
    _wavesColor = wavesColor;
    
    self.firstWares.wavesColor = wavesColor;
    self.secondWares.wavesColor = wavesColor;
}

#if TARGET_INTERFACE_BUILDER
- (void)setLocation:(NSUInteger)location
{
    _location = location;
    
    self.firstWares.location = (ZJWavesViewWaveLocation)location;
    self.secondWares.location = (ZJWavesViewWaveLocation)location;
}
#else
- (void)setLocation:(ZJWavesViewWaveLocation)location
{
    _location = location;
    
    self.firstWares.location = location;
    self.secondWares.location = location;
}
#endif

- (void)setIsAnimateWave:(BOOL)isAnimateWave
{
    _isAnimateWave = isAnimateWave;
    
    if (self.animationWaveTimer) {
        [self.animationWaveTimer invalidate];
        self.animationWaveTimer = nil;
    }
    
    if (_isAnimateWave) {
        self.animationWaveTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.animationWaveTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)dealloc
{
    [self.animationWaveTimer invalidate];
}

@end

