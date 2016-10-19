//
//  NumberConverter.m
//  NumberConverter
//
//  Created by Vladimir Orlov on 01.10.16.
//  Copyright © 2016 Vladimir Orlov. All rights reserved.
//

#import "NumberConverter.h"

typedef NS_ENUM(NSInteger, Constants) {
    kDigitLength = 19,
    kTensLength = 9,
    kModifierLength = 4
};

NSString * digitName(NSInteger number) {
    switch (number) {
        case 1: return @"one";
        case 2: return @"two";
        case 3: return @"three";
        case 4: return @"four";
        case 5: return @"five";
        case 6: return @"six";
        case 7: return @"seven";
        case 8: return @"eight";
        case 9: return @"nine";
        case 10: return @"ten";
        case 11: return @"eleven";
        case 12: return @"twelve";
        case 13: return @"thirteen";
        case 14: return @"fourteen";
        case 15: return @"fifteen";
        case 16: return @"sixteen";
        case 17: return @"seventeen";
        case 18: return @"eighteen";
        case 19: return @"nineteen";
        default: return @"";
    }
}

NSString * tensName(NSInteger number) {
    switch (number) {
        case 1: return @"ten";
        case 2: return @"twenty";
        case 3: return @"thirty";
        case 4: return @"fourty";
        case 5: return @"fifty";
        case 6: return @"sixty";
        case 7: return @"seventy";
        case 8: return @"eighty";
        case 9: return @"ninety";
        default: return @"";
    }
}

NSString * modifierName(NSInteger number) {
    switch (number) {
        case 1: return @"thousand";
        case 2: return @"million";
        case 3: return @"billion";
        case 4: return @"trillion";
        case 5: return @"quadrillion";
        default: return @"";
    }
}

@implementation NumberConverter

+ (NSString *)convert:(long long)number {
    if (!number) {
        return [[self alloc] zeroNumber];
    } else if ((number > 0 && number < 999) || (number > -999 && number < 0)) {
        return [[self alloc] hundredNumber:number];
    }
    return [[self alloc] anyNumber:number];
}

- (NSString *)zeroNumber {
    return @"zero";
}

- (NSString *)hundredNumber:(NSInteger)value {
    if (!value) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] init];
    if (value < 0) {
        [string appendString:@"minus "];
        value = -value;
    }
    NSInteger mod = value % 100;
    NSInteger intPart = value / 100;
    
    if (intPart > 0) {
        [string appendFormat:@"%@ hundred%@", digitName(intPart), (mod > 0) ? @" " : @""];
    }
    if (mod && mod <= kDigitLength) {
        [string appendString:digitName(mod)];
    } else {
        NSInteger tens = mod / 10;
        NSInteger units = mod % 10;
        if (!units) {
            [string appendFormat:@"%@", tensName(tens)];
        } else {
            [string appendFormat:@"%@-%@", tensName(tens), digitName(units)];
        }
    }
    return string;
}

- (NSString *)anyNumber:(long long)number {
    NSMutableString *string = [NSMutableString string];
    if (number < 0) {
        [string appendString:@"minus "];
        number = -number;
    }
    
    NSMutableArray *thousands = [NSMutableArray array];
    for (int i = 0; i <= kModifierLength; i++) {
        [thousands addObject: modifierName(i)];
    }
    int index = 0;
    while (number) {
        thousands[index] = @(number % 1000);
        number /= 1000;
        ++index;
    }
    
    BOOL first = YES;
    NSNumber *firstObject = [thousands firstObject];
    while (--index > 0) {
        if (!first) {
            [string appendString:@" "];
        }
        first = false;
        if ([thousands[index] integerValue] > 0) {
            [string appendFormat:@"%@ %@", [self hundredNumber:[thousands[index] integerValue]], modifierName(index)];
        }
    }
    
    if (!first && firstObject) {
        [string appendFormat:@" %@", [self hundredNumber:[firstObject integerValue]]];
    }
    return string;
}

@end
