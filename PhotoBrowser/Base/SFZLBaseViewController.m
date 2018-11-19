/**
 * @file        SFBaseViewController.m
 *
 *              ## 一切ViewConroller的父类。为避代码冗余，子类常用变量和方法都会写在此类中。包含以下功能:
 *              1. 对每个子类的显示和消失在后台进行打印。
 *              2. 创建initData、initUI方法让子类继承，每次viewDidLoad时会按顺序调用，分离数据初始化和界面初始化。
 *
 * @note        使用方法：直接继承此类即可使用。
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

@interface SFZLBaseViewController ()

/** 本类的管理器 */
@property (nonatomic, copy) SFBaseManager *sfBaseManager;
/** 销毁界面时间戳 */
@property (nonatomic, assign) NSTimeInterval popSelfTimeInterval;

@end

@implementation SFZLBaseViewController{
    BOOL bb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //后台打印界面生命周期动态
    NSLog(@"\n▂▃▅▆█ 进入%@ █▆▅▃▂",self.class);
    [self initData];
    [self initUI];
    [self addNotificationObserver];
}

//初始化数据
- (void)initData{
}

//初始化界面
- (void)initUI{
    //导航栏默认会遮蔽视图，设置视图布局时不向任何方向延伸。
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

//添加KVO
- (void)addNotificationObserver{
    //交给子类实现
}

//移除KVO
- (void)removeNotificationObserver{
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [self removeNotificationObserver];
    NSLog(@"\n▒▒▒▒▒ 释放%@ ▒▒▒▒▒",self.class);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
