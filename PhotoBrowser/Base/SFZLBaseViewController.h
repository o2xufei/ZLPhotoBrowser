/**
 * @file        SFBaseViewController.h
 *
 *              ## 一切ViewConroller的父类。为避代码冗余，子类常用变量和方法都会写在此类中。包含以下功能:
 *              1. 检查每个子类是否存在内存泄漏：运行后push、pop后等待1秒，如果出现内存泄漏会进行弹框提示（配合SFBaseManager）。
 *              2. 实时获取每个子类的当前显示界面（配合SFBaseManager）。
 *              3. 实时获取每个子类的上一个显示界面（配合SFBaseManager）。
 *              4. 对每个子类的显示和消失在后台进行打印。
 *              5. 创建initData、initUI方法让子类继承，每次viewDidLoad时会按顺序调用，分离数据初始化和界面初始化。
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

#import <UIKit/UIKit.h>

@class SFBaseManager;
@interface SFZLBaseViewController : UIViewController

/**
 viewDidLoad后会调用此方法，进行初始化数据，避免空数组或空字典插值导致崩溃。
 
 @author    Schaffer
 @date      2018.11.1
 */
- (void)initData;

/**
 initData后会调用此方法，进行界面相关初始化
 
 @author    Schaffer
 @date      2018.11.1
 */
- (void)initUI;

/**
 initUI后会调用此方法，为界面控制器添加消息监听事件KVO
 
 @author    Schaffer
 @date      2018.11.7
 */
- (void)addNotificationObserver;

/**
 dealloc时会调用此方法，移除需要的消息监听事件，避免循环引用
 
 @author    Schaffer
 @date      2018.11.7
 */
- (void)removeNotificationObserver;



@end
