//win 的显示Leavel
#define BBAlertLeavel  300


#import "CRMShowAdV.h"


@interface CRMShowAdV ()


/* 是否已经显示 */
@property (nonatomic, assign) BOOL  visible;


@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIImageView * adsImageView;






@end




static CGFloat kTransitionDuration = 0.3f;
static NSMutableArray * gAlertViewStack = nil;
static UIWindow *gPreviouseKeyWindow = nil;// 保存显示之前的KeyWindow,用于还原
static UIWindow * gMaskWindow = nil;// 当前显示的Window


@implementation CRMShowAdV




#pragma mark - 栈区顶层的view
+ (instancetype )getStackTopAlertView{
    CRMShowAdV * topItem = nil;
    if (0 != [gAlertViewStack count]) {
        topItem = [gAlertViewStack lastObject];
    }
    return topItem;
}



/**
 *  把当前的alertView添加到当前队列中
 *
 *  @param alertView <#alertView description#>
 */
+ (void)addAlertViewOnMaskWindow:(CRMShowAdV *)alertView{
    
    if (!gMaskWindow ||[gMaskWindow.subviews containsObject:alertView]) {
        return;
    }
    
    [gMaskWindow addSubview:alertView];
    
    alertView.hidden = NO;
    
    
    CRMShowAdV *previousAlertView = [[self class] getStackTopAlertView];
    
    
    
    if (previousAlertView) {
        previousAlertView.hidden = YES;
    }
    [[self class] pushAlertViewInStack:alertView];
    
    
}

#pragma mark -入栈
+ (void)pushAlertViewInStack:(CRMShowAdV *)alertView{
    if (!gAlertViewStack) {
        gAlertViewStack = [[NSMutableArray alloc] init];
    }
    [gAlertViewStack addObject:alertView];
}


- (id)initWithBackgroundImage:(UIImage *)backImage delegate:(id <CRMShowAdVDelegate>)delegate  adsImageViewWHRatio:(CGFloat)adsImageViewWHRatio {
    
    
    
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _delegate = delegate;
        
        self.shouldDismissAfterConfirm = YES;
        self.backgroundColor = [UIColor clearColor];
        
//          = 540/740.00;
        __weak __typeof__(self) weakSelf = self;

        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
//            make.size.mas_equalTo(backImage.size);
            
            make.left.offset(kAdjustRatio(30));
            make.right.offset(kAdjustRatio(-30));
            
            make.height.equalTo(weakSelf.contentView.mas_width).multipliedBy(1/adsImageViewWHRatio);
            
            

        }];
        
        
        
        
        self.adsImageView.image = backImage;
        self.adsImageView.layer.cornerRadius = 8;
        self.adsImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.adsImageView];
        

        [self.adsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(self);
//            make.size.mas_equalTo(backImage.size);// 540 740
            
            
            
            make.edges.offset(0);
            
            

            
        }];
        
        
        
        [self serupinit];

        
    }
    return self;
}


- (id)initWithBackgroundImage:(UIImage *)backImage delegate:(id <CRMShowAdVDelegate>)delegate   {
    
    
    
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _delegate = delegate;
        
        self.shouldDismissAfterConfirm = YES;
        self.backgroundColor = [UIColor clearColor];
        
//          = 540/740.00;
        __weak __typeof__(self) weakSelf = self;

        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(backImage.size);
            
//            make.left.offset(kAdjustRatio(30));
//            make.right.offset(kAdjustRatio(-30));
//
//            make.height.equalTo(weakSelf.contentView.mas_width).multipliedBy(1/self.adsImageViewWHRatio);
            

        }];
        
        
        
        
        self.adsImageView.image = backImage;
        self.adsImageView.layer.cornerRadius = 8;
        self.adsImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.adsImageView];
        

        [self.adsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(self);
//            make.size.mas_equalTo(backImage.size);// 540 740
//
            
            
            make.edges.offset(0);
            
            

            
        }];
        
        [self serupinit];
        
        
    }
    return self;
}

- (void)serupinit{
    
    // 底部的关闭按钮
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    self.markButton.hidden = YES;
    
    [self addSubview:self.markButton];
    self.markButton.backgroundColor = [UIColor redColor];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(-90);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    

    
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
    }
    return _contentView;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView * hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    if (hitView == self) {
        [self dismiss];
        
        if(self.touchesBegandismissBlock){
            self.touchesBegandismissBlock(nil);
        }
    }else{
        
    }
}


/* 背景渐变 */
-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 0.0f};
    CGFloat gradColors[8] = {
        0.0f,0.0f,0.0f,
        0.0f,0.0f,0.0f,
        0.0f,0.40f
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    //Gradient center
    CGPoint gradCenter = self.contentView.center;
    //Gradient radius
    float gradRadius = 320 ;
    //Gradient draw
    CGContextDrawRadialGradient (context, gradient, gradCenter,
                                 0, gradCenter, gradRadius,
                                 kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}


+ (void)dismissMaskWindow{
    // make previouse window the key again
    if (gMaskWindow) {
        [gPreviouseKeyWindow makeKeyWindow];
        gPreviouseKeyWindow = nil;
        
        gMaskWindow = nil;
    }
}
- (void)dismissAlertView {
    
    [[self class] removeAlertViewFormMaskWindow:self];
    
    
    // If there are no dialogs visible, dissmiss mask window too.
    if (![[self class] getStackTopAlertView]) {
        [[self class] dismissMaskWindow];
    }
}



#pragma mark -出栈
+ (void)popAlertViewFromStack{
    if (![gAlertViewStack count]) {
        return;
    }
    [gAlertViewStack removeLastObject];
    
    if ([gAlertViewStack count] == 0) {
        gAlertViewStack = nil;
    }
}

+ (void)removeAlertViewFormMaskWindow:(CRMShowAdV *)alertView{
    
    
    if (!gMaskWindow || ![gMaskWindow.subviews containsObject:alertView]) {
        return;
    }
    
    [alertView removeFromSuperview];
    alertView.hidden = YES;
    
    
    [[self class] popAlertViewFromStack];
    
    
    CRMShowAdV *previousAlertView = [[self class] getStackTopAlertView];
    
    if (previousAlertView) {
        
        previousAlertView.hidden = NO;
        
        [previousAlertView bounce0Animation];
        
    }
}

#pragma mark - func
- (void)buttonTapped:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:didSelectedButtonIndex:)]) {
        [self.delegate alertView:self didSelectedButtonIndex:tag];
    }
    if (0 == tag) {
        
        if (self.cancelBlock) {
            
            self.cancelBlock(nil);
            
        }
        [self dismiss];
        
    } else if (1 == tag) {
        
        if (self.markBlock) {
            
            self.markBlock(nil);
            
        }
        if (_shouldDismissAfterConfirm) {
            [self dismiss];
        }
    }
}



#pragma mark block setter block 构造器
- (void)setCancelBlock:(CRM_BasicActionBlock)block {
    _cancelBlock = [block copy];
}
- (void)setMarkBlock:(CRM_BasicActionBlock)block {
    
    _markBlock = [block copy];
}

#pragma mark - lazy
- (UIImageView *)adsImageView {
    if (!_adsImageView) {
        _adsImageView = [[UIImageView alloc] init];
    }
    return _adsImageView;
}



- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"icon_tanchuang_xiaochengxu_guanbi"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTag:0];
    }
    return _cancelButton;
}

-(UIButton *)markButton {
    if (!_markButton) {
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_markButton setTag:1];
    }
    return _markButton;
}


#pragma mark animation
- (void)bounce0Animation{
    self.contentView.transform = CGAffineTransformScale([self transformForOrientation], 0.001f, 0.001f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationDidStop)];
    self.contentView.transform = CGAffineTransformScale([self transformForOrientation], 1.1f, 1.1f);
    [UIView commitAnimations];
}

- (void)bounce1AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationDidStop)];
    self.contentView.transform = CGAffineTransformScale([self transformForOrientation], 0.9f, 0.9f);
    [UIView commitAnimations];
}

- (void)bounce2AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceDidStop)];
    self.contentView.transform = [self transformForOrientation];
    [UIView commitAnimations];
}

/* 动画结束 */
- (void)bounceDidStop{
   
}

- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5f);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2.0f);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}


/* 显示 */
- (void)show {
    if (_visible) {
        return;
    }
    _visible = YES;
    
    //如果栈中没有alertview,就表示maskWindow没有弹出，所以弹出maskWindow
    if (![[self class] getStackTopAlertView]) {
        
        [[self class] presentMaskWindow];
        
    }
    
    //如果有背景图片，添加背景图片
    if (nil != self.backgroundView && ![[gMaskWindow subviews] containsObject:self.backgroundView]) {
        [gMaskWindow addSubview:self.backgroundView];
    }
    //将alertView显示在window上
    [[self class] addAlertViewOnMaskWindow:self];
    
    
    self.alpha = 1.0;
    
    //alertView弹出动画
    if(self.isbounceAnimation){
        
        
        [self bounce0Animation];//

        
    }
}

/**
 *  取得最靠前的window
 */
+ (void)presentMaskWindow{
    
    if (!gMaskWindow) {
        gMaskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        //edited by gjf 修改alertview leavel
        gMaskWindow.windowLevel = UIWindowLevelStatusBar + BBAlertLeavel;
        gMaskWindow.backgroundColor = [UIColor clearColor];
        gMaskWindow.hidden = YES;
        
        // FIXME: window at index 0 is not awalys previous key window.
//        gPreviouseKeyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        
        gPreviouseKeyWindow = [UIApplication sharedApplication].keyWindow;

        
        
        [gMaskWindow makeKeyAndVisible];
        
        // Fade in background
        gMaskWindow.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        gMaskWindow.alpha = 1;
        [UIView commitAnimations];
    }
}

/* 消失 */
- (void)dismiss {
    if (!_visible) {
        return;
    }
    _visible = NO;
    
    UIView *__bgView = self->_backgroundView;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissAlertView)];
    self.alpha = 0;
    [UIView commitAnimations];
    
    if (__bgView && [[gMaskWindow subviews] containsObject:__bgView]) {
        [__bgView removeFromSuperview];
    }
    
    gMaskWindow.hidden = YES;
    
    
}


@end
