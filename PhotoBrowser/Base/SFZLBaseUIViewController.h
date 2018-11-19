/**
 * @file        SFUIViewController.h
 *
 *              ## 拓展了UI显示上的功能
 *              1. 显示和更改导航栏标题文字和字体。
 *              2. 创建或替换导航栏标题为搜索框。
 *              3. 创建导航栏左右按钮，按钮可显示纯文字、纯图片、图文混合。
 *              4. 修复IOS11右按钮偏右问题。
 *
 * @note        左按钮最小偏移为10像素，目前只能通过修改UINavigation+FixSpace.m文件中subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);代码第二个参数left值来实现10以内的偏移。
 *
 * @author      [Schaffer Xu](http://nas.xufei.online:9000/blog/5b508b8fc07ee523e4000002)
 * @version     1.0
 * @date        2018/5/14
 *
 * # update
 *
 * 2018/5/14 Schaffer v1.0
 * + v1.0版发布
 *
 *
 *              Copyright © 2018 Schaffer. All rights reserved.
 */

#import "SFZLBaseViewController.h"
#import "SFZLUISearchBar.h"

@interface SFZLBaseUIViewController : SFZLBaseViewController

/** 本界面导航栏标题 */
@property (nonatomic, strong) UILabel *navigationTitleLabel;
/** 本界面导航栏代替标题的搜索框 */
@property (nonatomic, strong) SFZLUISearchBar *searchBar;
/** 本界面导航栏左按钮 */
@property (nonatomic, strong) UIButton *leftNavigationButton;
/** 本界面导航栏右按钮 */
@property (nonatomic, strong) UIButton *rightNavigationButton;

#pragma mark - 导航栏相关
/**
 设置导航栏颜色
 
 @author Schaffer
 @date 2018.10.31
 
 @param color 导航栏颜色
 */
- (void)setNavigationBarTintColor:(UIColor *)color;

/**
 设置导航栏背景图片
 
 @author Schaffer
 @date 2018.10.31
 
 @param backgroundImage 背景图片
 */
- (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage;

/**
 设置导航栏下分割线颜色
 
 @author Schaffer
 @date 2018.10.31
 
 @param lineImage 只能以图片方式设置
 */
- (void)setNavigationBottomLine:(UIImage *)lineImage;

#pragma mark - 导航栏标题相关
/**
 改变导航栏显示的标题文字
 
 @author Schaffer
 @date 2018.10.31
 
 @param title 导航栏文字
 @param font 导航栏文字字体
 @param titleColor 标题颜色
 */
- (void)base_createNavigationTitleWithString:(NSString *)title andFont:(UIFont *)font andColor:(UIColor *)titleColor;

/**
 改变导航栏显示的标题文字
 
 @author Schaffer
 @date 2018.10.31
 
 @param title 导航栏文字
 @param font 导航栏文字字体。当为空时，不改变当前标题文字字体；当有值时，改变当前标题字体为指定字体。
 */
-(void)base_changeNavigationTitleWithString:(NSString *)title andFont:(UIFont *)font;

/**
 创建搜索框代替标题文字，会使用默认颜色风格进行创建。
 */
- (void)base_createNavigationSearchBar;

/**
 创建搜索框代替标题文字
 
 @author Schaffer
 @date 2018.10.31
 
 @param textColor 搜索框输入文字颜色
 @param textBackgroundColor 搜索框背景颜色
 @param textFont 搜索框文字字体
 @param placeholderText 搜索框默认文字
 @param placeholderColor 搜索框默认文字颜色
 @param andCursorColor 搜索框光标颜色
 @param isCenter 是否居中
 @param leftOffset 左侧偏移，用于置顶最左侧
 @param rightOffset 右侧偏移，用于置顶最右侧
 */
- (void)base_createNavigationSearchBarWithTextColor:(UIColor *)textColor andTextBackgroundColor:(UIColor *)textBackgroundColor andTextFont:(UIFont *)textFont andPlaceholderText:(NSString *)placeholderText andPlaceholderColor:(UIColor *)placeholderColor andCursorColor:(UIColor *)andCursorColor isCenter:(BOOL)isCenter leftOffset:(float)leftOffset rightOffset:(float)rightOffset;

/**
 在导航栏中间创建一块显示区域
 
 @author Schaffer
 @date 2018.10.31
 
 @param view 需要创建的区域
 @param isCenter 是否居中
 @param leftOffset 左侧偏移，用于置顶左侧
 @param rightOffset 右侧偏移，用于置顶右侧
 */
- (void)base_createNavigationTitleWithView:(UIView *)view
                                  isCenter:(BOOL)isCenter
                                leftOffset:(float)leftOffset
                               rightOffset:(float)rightOffset;
#pragma mark - 创建导航栏按钮
/**
 创建导航栏左按钮
 
 @author Schaffer
 @date 2018.10.31
 
 @param imageName 导航栏按钮图片明
 @param imageUrl 网络图片地址
 @param title 导航栏按钮文字
 @param titleFont 导航栏按钮文字字体
 @param titleColor 导航栏按钮文字颜色
 @param action 导航栏按钮点击事件
 @param horizontalOffset 导航栏按钮水平偏移距离
 */
- (void)base_createLeftNavigationBarButtonItemWithImageName:(NSString *)imageName orImageUrl:(NSString *)imageUrl orTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor andAction:(SEL)action horizontalOffset:(float)horizontalOffset;

/**
 根据图片创建导航栏右按钮
 
 @author Schaffer
 @date 2018.10.31
 
 @param image 导航栏图片
 @param imageUrl 网络图片地址
 @param title 导航栏按钮文字
 @param titleFont 导航栏按钮文字字体
 @param titleColor 导航栏按钮文字颜色
 @param action 导航栏按钮点击事件
 @param horizontalOffset 导航栏按钮水平偏移距离
 */
- (void)base_createRightNavigationBarButtonItemWithImage:(UIImage *)image orImageUrl:(NSString *)imageUrl orTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor andAction:(SEL)action horizontalOffset:(float)horizontalOffset;

/**
 创建导航栏左或者右按钮
 
 @author Schaffer
 @date 2018.10.31
 
 @param imageName 导航栏按钮图片明
 @param imageUrl 网络图片地址
 @param title 导航栏按钮文字
 @param titleFont 导航栏按钮文字字体
 @param titleColor 导航栏按钮文字颜色
 @param action 导航栏按钮点击事件
 @param isLeft 是否是左按钮，NO则是右按钮
 @param horizontalOffset 导航栏按钮水平偏移距离
 */
- (void)base_createNavigationBarButtonItemWithImageName:(NSString *)imageName orImageUrl:(NSString *)imageUrl orTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor andAction:(SEL)action andIsLeft:(BOOL)isLeft horizontalOffset:(float)horizontalOffset;

- (void)base_createNavigationBarButtonItemWithView:(UIView *)view andIsLeft:(BOOL)isLeft horizontalOffset:(float)horizontalOffset;


/**
 导航栏左按钮点击事件
 
 @author Schaffer
 @date 2018.10.31
 
 @param button 左按钮
 */
- (void)base_leftNavigationBarButtonClicked:(UIButton *)button;

/**
 导航栏右按钮点击事件
 
 @author Schaffer
 @date 2018.10.31
 
 @param button 右按钮
 */
- (void)base_rightNavigationBarButtonClicked:(UIButton *)button;

/**
 创建线
 
 @author Schaffer
 @date 2018.10.31
 
 @return 线
 */
- (UIView *)createLine;


/**
 在指定UIView中隐藏或显示一个无数据界面
 
 @author Schaffer
 @date 2018.10.31
 
 @param hidden 隐藏或显示
 @param view 指定UIView
 */
- (void)setNoDataViewHidden:(BOOL)hidden inView:(UIView *)view;

/**
 在指定UIView中隐藏或显示一个无数据界面，并以指定VIEW为基准
 
 @author Schaffer
 @date 2018.10.31
 
 @param hidden 隐藏或显示
 @param view 指定UIView
 @param baseOnView 以此界面为基准
 @param refreshBlock 刷新按钮点击回调
 */
- (void)setNoDataViewHidden:(BOOL)hidden inView:(UIView *)view baseOnView:(UIView *)baseOnView refreshBlock:(void (^)(void))refreshBlock;

/**
 在指定UIView中隐藏或显示一个404界面
 
 @author Schaffer
 @date 2018.10.31
 
 @param hidden 隐藏或显示
 @param view 指定UIView
 */
- (void)setRequestFailureViewHidden:(BOOL)hidden inView:(UIView *)view;

/**
 在指定UIView中隐藏或显示一个404界面，并以指定VIEW为基准
 
 @author Schaffer
 @date 2018.10.31
 
 @param hidden 隐藏或显示
 @param view 指定UIView
 @param baseOnView 以此界面为基准
 @param refreshBlock 刷新按钮点击回调
 */
- (void)setRequestFailureViewHidden:(BOOL)hidden inView:(UIView *)view baseOnView:(UIView *)baseOnView refreshBlock:(void (^)(void))refreshBlock;


/**
 显示或隐藏刷新界面
 
 @author Schaffer
 @date 2018.10.31
 
 @param hidden 显示或隐藏
 */
- (void)base_setRefreshingViewHidden:(BOOL)hidden;

@end
