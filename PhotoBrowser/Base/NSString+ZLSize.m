//
//  NSString+Size.m
//  AppDemo
//
//  Created by Schaffer on 2018/5/14.
//  Copyright © 2018年 Schaffer. All rights reserved.
//

#import "NSString+ZLSize.h"

@implementation NSString (ZLSize)

#pragma mark -计算字符串大小
//根据文字和字体计算大小
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font{
    return [NSString getTextSize:text font:font maxWidth:0 maxHeight:0];
}

//根据文字、字体、截断方式计算大小
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font andLineBreakMode:(NSLineBreakMode)lineBreakMode{
    return [NSString getTextSize:text font:font maxWidth:0 maxHeight:0];
}

//根据文字、字体、显示宽度、显示高度计算大小
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font maxWidth:(float)maxWidth maxHeight:(float)maxHeight{
    return [NSString getTextSize:text font:font maxWidth:maxWidth maxHeight:maxHeight andLineBreakMode:NSLineBreakByCharWrapping];
}

//根据文字、字体、显示宽度、显示高度、截断方式计算大小
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font maxWidth:(float)maxWidth maxHeight:(float)maxHeight andLineBreakMode:(NSLineBreakMode)lineBreakMode{
    return [NSString getTextSize:text font:font maxWidth:maxWidth maxHeight:maxHeight andLineBreakMode:lineBreakMode andLineSpacing:NSNotFound];
}

//根据文字、字体、显示宽度、显示高度、截断方式、行间距计算大小
+ (CGSize)getTextSize:(NSString *)text font:(UIFont *)font maxWidth:(float)maxWidth maxHeight:(float)maxHeight andLineBreakMode:(NSLineBreakMode)lineBreakMode andLineSpacing:(float)lineSpacing{
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

- (CGSize)getTextSizeWithFont:(UIFont *)font{
    return [NSString getTextSize:self font:font maxWidth:0 maxHeight:0];
}

- (CGSize)getTextSizeWithFont:(UIFont *)font andMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight{
    return [NSString getTextSize:self font:font maxWidth:maxWidth maxHeight:maxHeight];
}

@end
