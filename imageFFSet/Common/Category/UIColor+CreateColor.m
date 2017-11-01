//
//  UIColor+CreateColor.m
//  minimemaker
//
//  Created by cy on 2017. 2. 13..
//  Copyright © 2017년 Minkook Yoo. All rights reserved.
//

#import "UIColor+CreateColor.h"

@implementation UIColor (CreateColor)


+ (UIColor *)colorWithHexCode:(NSString *)hexCode {
    
    NSString *arrangedCode = [hexCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    arrangedCode = arrangedCode.uppercaseString;
    
    if (arrangedCode.length < 6) {
        return [UIColor blackColor];
    }
    
    NSArray *deletingCharacters = @[@"0X", @"#"];
    
    for (NSString *deletingCharacter in deletingCharacters) {
        
        if ([arrangedCode hasPrefix:deletingCharacter]) {
            arrangedCode = [arrangedCode substringFromIndex:deletingCharacter.length];
            break;
        }
        
    }
    
    if (arrangedCode.length != 6) {
        return [UIColor blackColor];
    }
    
    NSString *redCode = [arrangedCode substringWithRange:NSMakeRange(0, 2)];
    NSString *greenCode = [arrangedCode substringWithRange:NSMakeRange(2, 2)];
    NSString *blueCode = [arrangedCode substringWithRange:NSMakeRange(4, 2)];
    
    unsigned int red, green, blue = 0;
    [[NSScanner scannerWithString:redCode] scanHexInt:&red];
    [[NSScanner scannerWithString:greenCode] scanHexInt:&green];
    [[NSScanner scannerWithString:blueCode] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(red / 255.0f)
                           green:(green / 255.0f)
                            blue:(blue / 255.0f)
                           alpha:1.0f];
    
}


+ (UIColor *)colorWithR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B A:(NSInteger)A {
    return [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A/100.f];
}


+ (UIColor *)colorWithR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B {
    return [self colorWithR:R G:G B:B A:100];
}


+ (UIColor *)colorWithRGB:(NSInteger)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >>16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}


+ (UIColor *)mainColor {
    return [self colorWithHexCode:@"FC7507"];
}

@end
