//
//  UIImage+Utils.h
//  AppDemo
//
//  Created by Schaffer on 2018/8/23.
//  Copyright © 2018年 Schaffer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZLUtils)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  裁剪图片
 *
 *  @param image 原图
 *  @param rect  裁剪的尺寸
 *
 *  @return 裁剪后的图片
 */
+ (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect;

/**
 生成二维码图片
 
 @author Schaffer
 @date 2018.10.31
 
 @param uid 用户id
 @return 二维码图片
 */
+ (UIImage *)createQRCodeImage:(NSString *)uid;



+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;


+(UIImage *)getThumbnailImage:(NSString *)videoURL;

/**
 获取灰化图片
 
 @author Schaffer
 @date 2018.10.31
 
 @param sourceImage 需要灰化的图片
 @return 灰化后图片
 */
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;

/**
 生成条形码图片
 
 @author Schaffer
 @date 2018.10.31
 
 @param content 条形码内容 
 @param size 条形码图片大小 
 @param red 红色比例 
 @param green 绿色比例 
 @param blue 蓝色比例
 @return 条形码图片
 */
+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size red:(CGFloat)red green:(CGFloat)green blue:(NSInteger)blue;


/**
 生成二维码图片
 
 @author Schaffer
 @date 2018.10.31
 
 @param content 二维码内容 
 @param size 二维码图片阿晓 
 @param logo 二维码LOGO图片 
 @param logoFrame 二维码LOGO图片大小 
 @param red 红色比例 
 @param green 绿色比例 
 @param blue 蓝色比例
 @return 二维码图片
 */
+ (UIImage *)qrCodeImageWithContent:(NSString *)content
                      codeImageSize:(CGFloat)size
                               logo:(UIImage *)logo
                          logoFrame:(CGRect)logoFrame
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(NSInteger)blue;

/**
 *  等比例缩放
 *
 *  @param image     需要缩放的图片
 *  @param scaleSize 缩放比例
 *
 *  @return 缩放后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/**
 通过尺寸和颜色获取渐变色图片
 
 @author Schaffer
 @date 2018.10.31
 
 @param size 图片大小 
 @param firstColor 渐变色起始色 
 @param secondColor 渐变色中间色 
 @param thirdColor 渐变色结尾色
 @return 渐变色图片
 */
+ (UIImage *)getGradientImageWithRectSize:(CGSize)size
                            andFirstColor:(CGColorRef)firstColor
                           andSecondColor:(CGColorRef)secondColor
                            andThirdColor:(CGColorRef)thirdColor;

/**
 通过位置、尺寸、颜色获取渐变色图片
 
 @author Schaffer
 @date 2018.10.31
 
 @param size 图片大小 
 @param locations   渐变色位置 
 @param firstColor 渐变色起始色 
 @param secondColor 渐变色中间色 
 @param thirdColor 渐变色结尾色
 @return 渐变色图片
 */
+ (UIImage *)getGradientImageWithRectSize:(CGSize)size
                             andLocations:(CGFloat [])locations
                            andFirstColor:(CGColorRef)firstColor
                           andSecondColor:(CGColorRef)secondColor
                            andThirdColor:(CGColorRef)thirdColor;

@end
