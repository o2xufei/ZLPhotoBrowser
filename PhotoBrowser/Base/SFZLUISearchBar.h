/**
 * @file        SFUISearchBar.h
 *
 *              ## 增加改变UISearchBar高度的功能。UISearchBar外部是无法完美改变其高度的。如果强行改变其高度，在使用圆角的时候圆角会只显示一半。
 *              1. 增加搜索框搜索图标属性，可通过直接修改来改变搜索图标。
 *              2. 增加搜索框占位符字体属性，可通过直接修改此属性来更改占位符字体。
 *              3. 增加搜索框占位符颜色属性，可以通过直接修改此属性来更改占位符颜色。
 *              4. 增加中文字输入框距离搜索框的内边距属性，可通过直接修改此值来更改文字输入框大小。优化了原生UISearchBar无法调节的问题。
 *              5. 解决IOS11占位符和搜索图片不居中问题。
 *
 * @note        Xcode v10.14
 *
 * @author      [Schaffer Xu](http://nas.xufei.online:9000/blog/5b508b8fc07ee523e4000002)
 * @version     1.0
 * @date        2018/5/14
 *
 * #Demo
 * ```
 * _searchBar = [[SFUISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-leftNavigationBarItemsLength-rightNavigationBarItemsLength, 44)];
 * [_searchBar setSearchIcon:[UIImage imageNamed:@"more"]];    //设置搜索图片
 * [_searchBar setPlaceholderFont:[UIFont systemFontOfSize:17]];   //设置占位符字体
 * [_searchBar setPlaceholderColor:[UIColor lightGrayColor]];  //设置占位符颜色
 * [_searchBar setTextFieldMargin:UIEdgeInsetsMake(7.5, 10, 7.5, 10)]; //设置内边距
 * [_searchBar setPlaceholder:placeholderText];          //设置提示文字
 * [_searchBar setTintColor:andCursorColor];   //设置光标颜色
 * [_searchBar setBackgroundColor:[UIColor clearColor]];   //修改背景色
 * [_searchBar setShowsCancelButton:NO];  //显示取消文字按钮
 * [_searchBar setBarTintColor:textBackgroundColor]; //设置搜索框背景色
 * ```
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

@interface SFZLUISearchBar : UISearchBar

/** 搜索框图标 */
@property (nonatomic, strong) UIImage *searchIcon;
/** 占位文字字体 */
@property (nonatomic, strong) UIFont *placeholderFont;
/** 占位文字字体 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets textFieldMargin;
/** 输入框背景色 */
@property (nonatomic, strong) UIColor *textFieldBackgroundColor;

@end
