/**
 * @file        SFUIViewController.m
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

#import "SFZLBaseUIViewController.h"
//#import "NSString+ZLSize.h"
#import "SDWebImage/UIButton+WebCache.h"

//判断机型
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_XMAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_X_SERIES IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_XS || IS_IPHONE_XMAX

/* 颜色相关 */
#define UICOLOR_FROM_HEX(s) ([UIColor colorWithRed:((float)((s & 0xFF0000) >> 16))/255.0 green:((float)((s & 0xFF00) >> 8))/255.0 blue:((float)(s & 0xFF))/255.0 alpha:1.0])
#define UICOLOR_FROM_HEX_ALPHA(s, a) ([UIColor colorWithRed:((float)((s & 0xFF0000) >> 16))/255.0 green:((float)((s & 0xFF00) >> 8))/255.0 blue:((float)(s & 0xFF))/255.0 alpha:a])

//防止block里引用self造成循环引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
/* 屏幕相关 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width    //当前屏幕宽度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height  //当前屏幕高度

#define STATUS_BAR_HEIGHT (IS_IPHONE_X_SERIES ? 44 : 20)        //当前屏幕状态栏高度
#define NAVIGATION_BAR_HEIGHT (STATUS_BAR_HEIGHT+44)            //系统导航栏高度
#define TAB_BAR_HEIGHT (IS_IPHONE_X_SERIES ? 83 : 49)           //系统tabbar高度

@interface SFZLBaseUIViewController ()

@end

@implementation SFZLBaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        UIView *_customStatusBar = nil;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        for (UIView *subView in keyWindow.subviews) {
            if (subView.tag == 109090909) {
                _customStatusBar = subView;
            }
        }
        
        UIColor *color = nil;
        if (color) {//有颜色
            if (_customStatusBar) {//已经有自定义的StatusBar，那就直接设置颜色
                _customStatusBar.backgroundColor = color;
            } else {//没有那就添加一个，并且设置颜色
                UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                statusBar.backgroundColor = color;
                statusBar.tag = 109090909;
                [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
            }
        } else {//没有颜色
            if (_customStatusBar) {//已经有自定义的StatusBar，那就设置成透明色
                _customStatusBar.backgroundColor = [UIColor clearColor];
            } else {//没有就不用管了
                
            }
        }

    } else {
        //设置状态栏背景色
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor clearColor];
        }
    }
}

//设置界面状态栏颜色 需要在SFBaseNavigationController中重写childViewControllerForStatusBarStyle才有效
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)initData{
    [super initData];
}

- (void)initUI{
    [super initUI];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)addNotificationObserver{
    [super addNotificationObserver];
}

- (void)removeNotificationObserver{
    [super removeNotificationObserver];
}

#pragma mark - 导航栏相关
//设置导航栏颜色
- (void)setNavigationBarTintColor:(UIColor *)color{
//    self.navigationController.navigationBar.barTintColor = color;
    
    //去除导航栏下方的横线并设置颜色
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:color size:CGSizeMake(1.0, 1.0)]
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
}

//设置导航栏背景图片
- (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage{
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBottomLine:(UIImage *)lineImage{
    [self.navigationController.navigationBar setShadowImage:lineImage ? lineImage : [UIImage new]];
}

#pragma mark - 导航栏标题相关
//更改当前导航栏标题
- (void)base_createNavigationTitleWithString:(NSString *)title andFont:(UIFont *)font andColor:(UIColor *)titleColor{
    if (_navigationTitleLabel) {
        [_navigationTitleLabel removeFromSuperview];
    }
    _navigationTitleLabel = [[UILabel alloc] init];
    _navigationTitleLabel.numberOfLines = 1;
    CGSize titleSize = [self getTextSize:title withFont:font];
    _navigationTitleLabel.frame = CGRectMake(0, 0, titleSize.width, 44.0);  //44.0
    _navigationTitleLabel.backgroundColor = [UIColor clearColor];
    _navigationTitleLabel.font = font;//[UIFont fontWithName:@"HiraginoSansGB-W3" size:FontSizeOf36];
    _navigationTitleLabel.text = title;
    _navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    _navigationTitleLabel.textColor = titleColor;
    self.navigationItem.titleView = _navigationTitleLabel;
}

//更改当前导航栏标题
-(void)base_changeNavigationTitleWithString:(NSString *)title andFont:(UIFont *)font{
    if (_navigationTitleLabel == nil) {
        [self base_createNavigationTitleWithString:title andFont:font andColor:[UIColor whiteColor]];
    }else{
        [_navigationTitleLabel setText:title];
        [_navigationTitleLabel setFont:font==nil ? _navigationTitleLabel.font : font];
    }
}

//使用默认方式创建导航栏标题搜索框
- (void)base_createNavigationSearchBar{
    [self base_createNavigationSearchBarWithTextColor:[UIColor darkGrayColor] andTextBackgroundColor:[UIColor whiteColor] andTextFont:[UIFont systemFontOfSize:14] andPlaceholderText:@"搜索" andPlaceholderColor:[UIColor lightGrayColor] andCursorColor:[UIColor darkGrayColor] isCenter:YES leftOffset:0 rightOffset:0];
}

//使用详细参数创建导航栏标题搜索框
- (void)base_createNavigationSearchBarWithTextColor:(UIColor *)textColor andTextBackgroundColor:(UIColor *)textBackgroundColor andTextFont:(UIFont *)textFont andPlaceholderText:(NSString *)placeholderText andPlaceholderColor:(UIColor *)placeholderColor andCursorColor:(UIColor *)andCursorColor isCenter:(BOOL)isCenter leftOffset:(float)leftOffset rightOffset:(float)rightOffset{
    //计算NavigationBar左右Item各自占用的长度
    __block float leftNavigationBarItemsLength = 0;
    __block float rightNavigationBarItemsLength = 0;
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.width > 0) {
            leftNavigationBarItemsLength += obj.width;
        }else{
            leftNavigationBarItemsLength += obj.customView.frame.size.width;
        }
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.width > 0) {
            rightNavigationBarItemsLength += obj.width;
        }else{
            rightNavigationBarItemsLength += obj.customView.frame.size.width;
        }
    }];
    if (isCenter) {
        //设置搜索框居中，则左右留白需要相等，取左右ITEM占用长度较大值
        if (leftNavigationBarItemsLength > rightNavigationBarItemsLength) {
            rightNavigationBarItemsLength = leftNavigationBarItemsLength;
        }else{
            leftNavigationBarItemsLength = rightNavigationBarItemsLength;
        }
    }
    //根据占用长度初始化搜索框
    _searchBar = [[SFZLUISearchBar alloc] initWithFrame:CGRectMake(-leftOffset, 0, [UIScreen mainScreen].bounds.size.width-leftNavigationBarItemsLength-rightNavigationBarItemsLength+leftOffset+rightOffset, 44)];
//    [_searchBar setSearchIcon:[UIImage imageNamed:@"more"]];    //设置搜索图片
    [_searchBar setPlaceholderFont:textFont];   //设置占位符字体
//    [_searchBar setPlaceholderColor:[UIColor lightGrayColor]];  //设置占位符颜色
    [_searchBar setTextFieldMargin:UIEdgeInsetsMake(7.5, 10, 7.5, 10)]; //设置内边距
    [_searchBar setPlaceholder:placeholderText];          //设置提示文字
    [_searchBar setTintColor:andCursorColor];   //设置光标颜色
    [_searchBar setBackgroundColor:[UIColor clearColor]];   //修改背景色
    [_searchBar setShowsCancelButton:NO];  //显示取消文字按钮
//    [_searchBar setBarTintColor:textBackgroundColor]; //设置搜索框背景色
    _searchBar.textFieldBackgroundColor = textBackgroundColor;
    //设置搜索框背景色为透明色
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    [_searchBar setBackgroundImage:searchBarBg];
    
    UIView *wrapView = [[UIView alloc] initWithFrame:_searchBar.frame];
    [wrapView addSubview:_searchBar];
    self.navigationItem.titleView = wrapView;
}

//在导航栏中间创建一块显示区域
- (void)base_createNavigationTitleWithView:(UIView *)view
                                  isCenter:(BOOL)isCenter
                                leftOffset:(float)leftOffset
                               rightOffset:(float)rightOffset{
    //计算NavigationBar左右Item各自占用的长度
    __block float leftNavigationBarItemsLength = 0;
    __block float rightNavigationBarItemsLength = 0;
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.width > 0) {
            leftNavigationBarItemsLength += obj.width;
        }else{
            leftNavigationBarItemsLength += obj.customView.frame.size.width;
        }
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.width > 0) {
            rightNavigationBarItemsLength += obj.width;
        }else{
            rightNavigationBarItemsLength += obj.customView.frame.size.width;
        }
    }];
    if (isCenter) {
        //设置搜索框居中，则左右留白需要相等，取左右ITEM占用长度较大值
        if (leftNavigationBarItemsLength > rightNavigationBarItemsLength) {
            rightNavigationBarItemsLength = leftNavigationBarItemsLength;
        }else{
            leftNavigationBarItemsLength = rightNavigationBarItemsLength;
        }
    }
    
    [view setFrame:CGRectMake(-leftOffset, 0, [UIScreen mainScreen].bounds.size.width-leftNavigationBarItemsLength-rightNavigationBarItemsLength+leftOffset+rightOffset, 44)];
    self.navigationItem.titleView = view;
}

#pragma mark 实现搜索条背景透明化
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 创建导航栏左右按钮
//创建导航栏左按钮
- (void)base_createLeftNavigationBarButtonItemWithImageName:(NSString *)imageName orImageUrl:(NSString *)imageUrl orTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor andAction:(SEL)action horizontalOffset:(float)horizontalOffset{
    [self base_createNavigationBarButtonItemWithImageName:imageName orImageUrl:imageUrl orTitle:title titleFont:titleFont titleColor:titleColor andAction:action andIsLeft:YES horizontalOffset:horizontalOffset];
}

//根据图片名创建导航栏右按钮
- (void)base_createRightNavigationBarButtonItemWithImageName:(NSString *)imageName orImageUrl:(NSString *)imageUrl orTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor andAction:(SEL)action horizontalOffset:(float)horizontalOffset{
    [self base_createNavigationBarButtonItemWithImageName:imageName orImageUrl:imageUrl orTitle:title titleFont:titleFont titleColor:titleColor andAction:action andIsLeft:NO horizontalOffset:horizontalOffset];
}

//根据图片创建导航栏右按钮
- (void)base_createRightNavigationBarButtonItemWithImage:(UIImage *)image orImageUrl:(NSString *)imageUrl orTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor andAction:(SEL)action horizontalOffset:(float)horizontalOffset{
    [self base_createNavigationBarButtonItemWithImage:image orImageUrl:imageUrl orTitle:title titleFont:titleFont titleColor:titleColor andAction:action andIsLeft:NO horizontalOffset:horizontalOffset];
}

//创建导航栏左或者右按钮
- (void)base_createNavigationBarButtonItemWithImageName:(NSString *)imageName orImageUrl:(NSString *)imageUrl orTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor andAction:(SEL)action andIsLeft:(BOOL)isLeft horizontalOffset:(float)horizontalOffset{
    [self base_createNavigationBarButtonItemWithImage:imageName.length > 0 ? [UIImage imageNamed:imageName] : nil orImageUrl:imageUrl orTitle:title titleFont:titleFont titleColor:titleColor andAction:action andIsLeft:isLeft horizontalOffset:horizontalOffset];
}

//创建导航栏左或者右按钮
- (void)base_createNavigationBarButtonItemWithImage:(UIImage *)image orImageUrl:(NSString *)imageURL orTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor andAction:(SEL)action andIsLeft:(BOOL)isLeft horizontalOffset:(float)horizontalOffset{
    //创建按钮对象
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];                 //创建UIButton
    
    float widthPlus = horizontalOffset;
    float realHorizontalOffset = horizontalOffset;
    //根据版本来设置缩进
    if (@available(iOS 13, *)) {
        //如果版本为iOS13或以上
        realHorizontalOffset = realHorizontalOffset - 20;
        widthPlus = widthPlus-20 < 0 ? 0 : widthPlus-20;
    }else if (@available(iOS 11, *)) {
        //如果版本为IOS11或以上
        if (realHorizontalOffset != 0) {
            //修复右按钮偏移不为0时错误，修复左按钮偏移大于0且小于10时错误(修复无效)
            if (isLeft == NO) {
                //如果是右侧导航按钮，则偏移距离会比左侧少8，不知道是什么原因，可能是IOSBUG。暂用此方法解决
                realHorizontalOffset += 8;
                widthPlus = realHorizontalOffset;
            }else{
                //修复左按钮偏移大于0且小于10时错误(修复无效)，左按钮偏移最小为10
                if (realHorizontalOffset > 0 && realHorizontalOffset < 10) {
                    realHorizontalOffset = -10 + realHorizontalOffset;
                    widthPlus = realHorizontalOffset;
                }
            }
        }
    }else{
        //如果版本为IOS11以下
        realHorizontalOffset = realHorizontalOffset - 20;
        widthPlus = widthPlus-20 < 0 ? 0 : widthPlus-20;
    }
    
    //如果图片名所对应图片存在，则显示图片
    if (imageURL.length > 0){
        //有网络图片地址，则设置加载图片，图片信息作为备用图片
        float fixTouchWidth = 5 * [UIScreen mainScreen].bounds.size.width/375;  //为修复图片边缘无法点击，此变量数值大约为4.75
        [button sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:image];    //设置网路加载图片
        float titleWidth = 0;
        if (title.length > 0) {
            //如果文字也存在，则图文混合
            [button setTitle:title forState:UIControlStateNormal];//设置UIButton文字
            [button.titleLabel setFont:titleFont]; //设置UIButton字体和大小
            [button setTitleColor:titleColor forState:UIControlStateNormal];  //设置普通状态下UIButton标题颜色
            CGSize titleSize = [self getTextSize:title withFont:titleFont];
            titleWidth = titleSize.width;
        }
        [button setFrame:CGRectMake(0, 0, image.size.width+fixTouchWidth+titleWidth+widthPlus, 44)];//image.size.width
        //如果当前版本大于IOS11，则使用此方法来设置导航栏按钮点击区域偏移
        if (@available(iOS 11, *)) {
            if (isLeft) {
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 5 * [UIScreen mainScreen].bounds.size.width / 375.0+widthPlus/2, 0, 0);
            }else {
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5 * [UIScreen mainScreen].bounds.size.width / 375.0 + widthPlus/2);
            }
        }
    }else if (image) {
        //有图片信息，则显示图片
        float fixTouchWidth = 5 * [UIScreen mainScreen].bounds.size.width/375;  //为修复图片边缘无法点击，此变量数值大约为4.75
        [button setImage:image forState:UIControlStateNormal];   //设置UIButton图片
        float titleWidth = 0;
        if (title.length > 0) {
            //如果文字也存在，则图文混合
            [button setTitle:title forState:UIControlStateNormal];//设置UIButton文字
            [button.titleLabel setFont:titleFont]; //设置UIButton字体和大小
            [button setTitleColor:titleColor forState:UIControlStateNormal];  //设置普通状态下UIButton标题颜色
            CGSize titleSize = [self getTextSize:title withFont:titleFont];
            titleWidth = titleSize.width;
        }
        [button setFrame:CGRectMake(0, 0, image.size.width+fixTouchWidth+titleWidth+widthPlus, 44)];//image.size.width
        //如果当前版本大于IOS11，则使用此方法来设置导航栏按钮点击区域偏移
        if (@available(iOS 11, *)) {
            if (isLeft) {
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 5 * [UIScreen mainScreen].bounds.size.width / 375.0+widthPlus/2, 0, 0);
            }else {
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5 * [UIScreen mainScreen].bounds.size.width / 375.0 + widthPlus/2);
            }
        }
    }else if(title && title.length > 0){
        //没有图片信息，显示文字
        [button setTitle:title forState:UIControlStateNormal];//设置UIButton文字
        [button.titleLabel setFont:titleFont]; //设置UIButton字体和大小
        CGSize titleSize = [self getTextSize:title withFont:titleFont];
        [button setFrame:CGRectMake(0, 0, titleSize.width+widthPlus, 44)];
        [button setTitleColor:titleColor forState:UIControlStateNormal];  //设置普通状态下UIButton标题颜色
    }else{
        //什么都没有，根据horizontalOffset缩进
        UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedButton.width = realHorizontalOffset;
        UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        if (isLeft){
            self.navigationItem.leftBarButtonItems = @[fixedButton,buttonItem];
        }else{
            self.navigationItem.rightBarButtonItems = @[fixedButton,buttonItem];
        }
        return;
    }
    if (isLeft) {
        action = action == nil ? @selector(base_leftNavigationBarButtonClicked:) : action;
    }else{
        action = action == nil ? @selector(base_rightNavigationBarButtonClicked:) : action;
    }
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];//为UIButton添加事件
    //设置对其方式，左侧按钮左对齐，右侧按钮右对齐
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //    button.contentHorizontalAlignment = isLeft ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight;
    //此处由于需要扩大按钮范围，所以不对左右按钮进行实际的间距设置，只增加左右按钮宽度，所以不用
    UIBarButtonItem *fixedButton = nil;
    //    fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    fixedButton.width = horizontalOffset;
    
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft){
        _leftNavigationButton = button;
        if (fixedButton) {
            self.navigationItem.leftBarButtonItems = @[fixedButton,buttonItem];
        }else{
            self.navigationItem.leftBarButtonItem = buttonItem;
        }
    }else{
        _rightNavigationButton = button;
        if (fixedButton) {
            self.navigationItem.rightBarButtonItems = @[fixedButton,buttonItem];
        }else{
            self.navigationItem.rightBarButtonItem = buttonItem;
        }
    }
}

- (void)base_createNavigationBarButtonItemWithView:(UIView *)view andIsLeft:(BOOL)isLeft horizontalOffset:(float)horizontalOffset{
    UIBarButtonItem *fixedButton = nil;
    //根据版本来设置缩进
    if (@available(iOS 11, *)) {
        //如果版本为IOS11或以上
        if (horizontalOffset != 0) {
            //修复右按钮偏移不为0时错误，修复左按钮偏移大于0且小于10时错误(修复无效)
            if (isLeft == NO) {
                //如果是右侧导航按钮，则偏移距离会比左侧少8，不知道是什么原因，可能是IOSBUG。暂用此方法解决
                horizontalOffset += 8;
            }else{
                //修复左按钮偏移大于0且小于10时错误(修复无效)，左按钮偏移最小为10
                if (horizontalOffset > 0 && horizontalOffset < 10) {
                    horizontalOffset = -10 + horizontalOffset;
                }
            }
            fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedButton.width = horizontalOffset;
        }
    }else{
        //如果版本为IOS11以下
        if (horizontalOffset-20 != 0) {
            horizontalOffset = horizontalOffset-20;
            fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedButton.width = horizontalOffset;
        }
        
    }
    
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    if (isLeft){
        _leftNavigationButton = view;
        if (fixedButton) {
            self.navigationItem.leftBarButtonItems = @[fixedButton,buttonItem];
        }else{
            self.navigationItem.leftBarButtonItem = buttonItem;
        }
    }else{
        _rightNavigationButton = view;
        if (fixedButton) {
            self.navigationItem.rightBarButtonItems = @[fixedButton,buttonItem];
        }else{
            self.navigationItem.rightBarButtonItem = buttonItem;
        }
    }
}

#pragma mark - 左右导航栏按钮点击事件
- (void)base_leftNavigationBarButtonClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)base_rightNavigationBarButtonClicked:(UIButton *)button{
    //留给子类实现
}

#pragma mark - 界面相关
//创建线
- (UIView *)createLine{
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:[UIColor blackColor]];
    return line;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
    
//根据文字、字体、显示宽度、显示高度、截断方式、行间距计算大小
- (CGSize)getTextSize:(NSString *)text font:(UIFont *)font maxWidth:(float)maxWidth maxHeight:(float)maxHeight andLineBreakMode:(NSLineBreakMode)lineBreakMode andLineSpacing:(float)lineSpacing{
    CGSize maxSize = CGSizeMake(maxWidth == 0 ? MAXFLOAT : maxWidth,maxHeight == 0 ? MAXFLOAT : maxHeight);
    CGSize singleLineSize = CGSizeZero;
    //由于文字中有换行符无法准确计算高度，所以遇到换行符主动加一行高度
    //    //由于直接使用(boundingRectWithSize:options:attributes:context:)方法无法计算出带有换行符的高度，所以采用UITextView来计算高度
    //    UITextView *ysTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 10)];
    //    ysTextView.text = text;
    //    // 可以将标签 ，进行转换
    //    ysTextView.font = font;;
    //    singleLineSize = [ysTextView sizeThatFits:maxSize];
    //    return singleLineSize;
    
    //如果当前版本高于或等于7.0，则NSString有(boundingRectWithSize:options:attributes:context:)方法，直接使用此方法计算文字尺寸
    if ([@"" respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:lineBreakMode];
        if (lineSpacing != NSNotFound) {
            [style setLineSpacing:lineSpacing];
        }
        NSDictionary *attributes = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
        CGRect singleLineRect = [text boundingRectWithSize:maxSize options:opts attributes:attributes context:nil];
        singleLineSize = singleLineRect.size;
    }else{
        //如果没有则说明版本低于7.0，则使用(sizeWithFont:constrainedToSize:lineBreakMode:)方法计算文字尺寸
        if ([@"" respondsToSelector:@selector(sizeWithFont:constrainedToSize:lineBreakMode:)]) {
            singleLineSize =[text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
        }
    }
    return singleLineSize;
}
    
- (CGSize)getTextSize:(NSString *)text withFont:(UIFont *)font{
    return [self getTextSize:text withFont:font andMaxWidth:0 andMaxHeight:0];
}
    
- (CGSize)getTextSize:(NSString *)text withFont:(UIFont *)font andMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight{
    return [self getTextSize:text font:font maxWidth:maxWidth maxHeight:maxHeight andLineBreakMode:NSLineBreakByCharWrapping andLineSpacing:NSNotFound];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
