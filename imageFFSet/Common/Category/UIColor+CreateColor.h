//
//  UIColor+CreateColor.h
//  minimemaker
//
//  Created by cy on 2017. 2. 13..
//  Copyright © 2017년 Minkook Yoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CreateColor)

/**
 @brief Hex code로 컬러 객체 생성.
 @param hexCode 000000 ~ FFFFFF. 코드앞에 #이나 0x도 사용 가능.
 @return 컬러 객체.
 */
+ (UIColor *)colorWithHexCode:(NSString *)hexCode;

/**
 @brief RGB값으로 컬러 객체 생성.
 @param R Red. 0 ~ 255.
 @param G Green. 0 ~ 255.
 @param B Blue. 0 ~ 255.
 @param A Alpha. 0 ~ 100.
 @return 컬러 객체.
 */
+ (UIColor *)colorWithR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B A:(NSInteger)A;

/**
 @brief RGB값으로 컬러 객체 생성.
 @param R Red. 0 ~ 255.
 @param G Green. 0 ~ 255.
 @param B Blue. 0 ~ 255.
 @return 컬러 객체.
 */
+ (UIColor *)colorWithR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B;

/**
 @brief RGB값으로 컬러 객체 생성. 싸이에서 사용.
 @param rgb ???(8자리인 듯).
 @return 컬러 객체.
 */
+ (UIColor *)colorWithRGB:(NSInteger)rgb;

/**
 @brief 싸이월드 오렌지 컬러. #FC7507.
 @return 컬러 객체.
 */
+ (UIColor *)mainColor;

@end
