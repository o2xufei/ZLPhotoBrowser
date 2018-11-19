//
//  NSString+Size.h
//  AppDemo
//
//  用于计算NSString在界面中所占宽度和高度。
//
//  Created by Schaffer on 2018/5/14.
//  Copyright © 2018年 Schaffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ZLSize)

/**
 获取一段文字在屏幕中显示的宽和高
 
 @author Schaffer
 @date 2018.10.31
 
 @param text 文字内容
 @param font 文字字体
 @return 文字显示尺寸
 */
+(CGSize)getTextSize:(NSString *)text font:(UIFont *)font;

//

/**
 根据文字、字体、截断方式获取文字在屏幕中显示的宽和高
 
 @author Schaffer
 @date 2018.10.31
 
 @param text 文字内容
 @param font 文字字体
 @param lineBreakMode 截断模式
 @return 文字显示尺寸
 */
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font andLineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 获取一段文字在屏幕中显示的宽和高
 
 @author Schaffer
 @date 2018.10.31
 
 @param text 文字内容
 @param font 文字字体
 @param maxWidth 文字最大宽度
 @param maxHeight 文字最大高度
 @return 文字显示尺寸
 */
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font maxWidth:(float)maxWidth maxHeight:(float)maxHeight;


/**
 获取一段文字在屏幕中显示的宽和高
 
 @author Schaffer
 @date 2018.10.31
 
 @param font 文字字体
 @return 文字显示尺寸
 */
- (CGSize)getTextSizeWithFont:(UIFont *)font;


/**
 获取一段文字在屏幕中显示的宽和高
 
 @author Schaffer
 @date 2018.10.31
 
 @param font 文字字体
 @param maxWidth 文字最大宽度
 @param maxHeight 文字最大高度
 @return 文字显示尺寸
 */
- (CGSize)getTextSizeWithFont:(UIFont *)font andMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight;

/**
 根据文字、字体、显示宽度、显示高度、截断方式获取一段文字在屏幕中显示的宽和高
 
 @author Schaffer
 @date 2018.10.31
 
 @param text 文字内容
 @param font 文字字体
 @param maxWidth 文字最大宽度
 @param maxHeight 文字最大高度
 @param lineBreakMode 文字截断模式
 @return 文字显示尺寸
 */
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font maxWidth:(float)maxWidth maxHeight:(float)maxHeight andLineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 根据文字、字体、显示宽度、显示高度、截断方式、行间距获取一段文字在屏幕中显示的宽和高
 
 @author Schaffer
 @date 2018.10.31
 
 @param text 文字内容
 @param font 文字字体
 @param maxWidth 文字最大宽度
 @param maxHeight 文字最大高度
 @param lineBreakMode 文字截断模式
 @param lineSpacing 行间距
 @return 文字显示尺寸
 */
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font maxWidth:(float)maxWidth maxHeight:(float)maxHeight andLineBreakMode:(NSLineBreakMode)lineBreakMode andLineSpacing:(float)lineSpacing;

@end
