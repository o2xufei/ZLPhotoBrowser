/**
 * @file        SFUISearchBar.m
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

#import "SFZLUISearchBar.h"
#import "NSString+ZLSize.h"

//图片与占位符间间隙
const static float kSFIconSpacing = 10.0;
//系统放大镜图片默认左侧留白宽度
const static float kSFDefaultIconMarginLeft = 10;

@interface SFZLUISearchBar () <UITextFieldDelegate>

// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;
// 文字 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat textWidth;

/** 搜索图片的宽高 */
@property (nonatomic, assign) float searchIconWidth;

@end

@implementation SFZLUISearchBar{
    //记录前后运行时间间隔
    NSTimeInterval endEditTime;
}

//重写方法
- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置背景图片
//    UIImage *backImage = [UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]];
//    [self setBackgroundImage:backImage];
    //找到搜索框的文字输入框并进行设置
    for (UIView *view in [self.subviews lastObject].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            //找到文字输入框
            UITextField *field = (UITextField *)view;
            // 重设field的frame
            field.frame = CGRectMake(0+_textFieldMargin.left, 0+_textFieldMargin.top, self.frame.size.width-_textFieldMargin.left-_textFieldMargin.right-(self.showsCancelButton ? 45 : 0 ), self.frame.size.height-_textFieldMargin.top-_textFieldMargin.bottom);//(15.0, 7.5, self.frame.size.width-30.0-(self.showsCancelButton ? 45 : 0 ), self.frame.size.height-15.0)
//            _textField = field;
            [field setBackgroundColor:_textFieldBackgroundColor];
            //            field.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            //
            //            field.borderStyle = UITextBorderStyleNone;
//                        field.layer.cornerRadius = 3.0f;
//                        field.layer.masksToBounds = YES;
            //
            // 设置占位文字字体颜色
            if (_placeholderColor) {
                [field setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
            }
            if (_placeholderFont) {
                [field setValue:_placeholderFont forKeyPath:@"_placeholderLabel.font"];
            }
            
            //修改默认的放大镜图片
            if (_searchIcon) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];  //CGRectMake(0, 0, _searchIcon.size.width, _searchIcon.size.height)
                _searchIconWidth = imageView.frame.size.width + kSFDefaultIconMarginLeft;
                imageView.backgroundColor = [UIColor clearColor];
                imageView.image = _searchIcon;
                field.leftView = imageView;
            }else{
                if ([field.leftView isKindOfClass:[UIImageView class]]) {
                    UIImage *image = ((UIImageView *)field.leftView).image;
                    _searchIconWidth = image.size.width + kSFDefaultIconMarginLeft;
                }else{
                    _searchIconWidth = 20 + + kSFDefaultIconMarginLeft;
                }
            }
            //当未输入过文字
            if (self.text.length <= 0) {
                if (@available(iOS 11.0, *)) {
                    // 先默认居中placeholder
                    _placeholderWidth = [self calculatePlaceholderWidthWithFont:_placeholderFont?_placeholderFont:field.font];
                    [self setPositionAdjustment:UIOffsetMake((field.frame.size.width-_placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
                }
            }
            
        }
    }
}

// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSTimeInterval dValue = [[NSDate date] timeIntervalSince1970]*1000 - endEditTime;
    if (dValue < 500) {
        //不满一秒 不作处理
        return NO;
    }
    // 继续传递代理方法
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}

// 当为输入文字时，结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    endEditTime = [[NSDate date] timeIntervalSince1970]*1000;
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    if (self.text.length <= 0) {
        if (@available(iOS 11.0, *)) {
            _placeholderWidth = [self calculatePlaceholderWidthWithFont:_placeholderFont?_placeholderFont:textField.font];
            [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-_placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
        }
    }
    
    return YES;
}

// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)calculatePlaceholderWidthWithFont:(UIFont *)font{
    if (!_placeholderWidth) {
        CGSize size = [NSString getTextSize:self.placeholder font:font maxWidth:MAXFLOAT maxHeight:MAXFLOAT];
//        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_placeholderFont} context:nil].size;
        _placeholderWidth = size.width + kSFIconSpacing + _searchIconWidth;
    }
    return _placeholderWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
