#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@class CRMShowAdV;

@protocol CRMShowAdVDelegate <NSObject>


@optional
- (void)alertView:(CRMShowAdV *)alertView didSelectedButtonIndex:(NSInteger)buttonIndex;
@end




#if NS_BLOCKS_AVAILABLE
typedef void(^CRM_BasicActionBlock)(id sender);

#endif





@interface CRMShowAdV : UIView


/* 内容 */
@property (nonatomic, strong) UIView * contentView;
/* 取消按钮 */
@property (nonatomic, strong) UIButton * cancelButton;
/* info */
@property (nonatomic, strong) UIButton * markButton;




#if NS_BLOCKS_AVAILABLE
@property (nonatomic, copy) CRM_BasicActionBlock  cancelBlock;
@property (nonatomic, copy) CRM_BasicActionBlock  markBlock;
//

@property (nonatomic, copy) CRM_BasicActionBlock  touchesBegandismissBlock;



//@property (nonatomic, copy) void (^block)(id sender);

#endif
-(void)setCancelBlock:(CRM_BasicActionBlock)block;
- (void)setMarkBlock:(CRM_BasicActionBlock)block;






/* 在点击确认后,是否需要dismiss, 默认YES */
@property (nonatomic, assign) BOOL shouldDismissAfterConfirm;


/**
 是z展示弹出动画 默认NO
 
 */
/**
//
// 背景图片的宽高比例
//
// */
//@property (nonatomic, assign) CGFloat adsImageViewWHRatio;



@property (nonatomic, assign) BOOL isbounceAnimation;



@property (nonatomic, weak) id<CRMShowAdVDelegate> delegate;

/**
 
 背景图片按照实际大小 显示
 */
- (id)initWithBackgroundImage:(UIImage * )backImage delegate:(id <CRMShowAdVDelegate>)delegate;
/**
 
  adsImageViewWHRatio 背景图片的宽高比例

 */
- (id)initWithBackgroundImage:(UIImage *)backImage delegate:(id <CRMShowAdVDelegate>)delegate  adsImageViewWHRatio:(CGFloat)adsImageViewWHRatio;

/* 弹出alert */
- (void)show;

- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
