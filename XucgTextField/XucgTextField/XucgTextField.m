//
//  XucgTextField.m
//  Test
//
//  Created by xucg on 2017/2/27.
//  Copyright © 2017年 xucg. All rights reserved.
//

#import "XucgTextField.h"

@interface XucgTextField() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation XucgTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _maxLength = NSUIntegerMax;
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    [self addSubview:_textField];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxLength = NSUIntegerMax;
        _textField = [[UITextField alloc] initWithFrame:frame];
        _textField.delegate = self;
        [self addSubview:_textField];
    }
    
    return self;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    return [self shouldChangeCharactersInRange:range replacementString:string];
}

// 截断字符串，使其不超过最长长度
- (void)text:(NSString*)srcText shouldLessThanOrEqualTo:(NSInteger)maxLength {
    while ([self charLengthOf:srcText] > maxLength) {
        srcText = [srcText substringToIndex:srcText.length - 1];
        _textField.text = srcText;
    }
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    NSString *toBeString = [_textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger charLength = [self charLengthOf:toBeString];
    if (charLength > _maxLength) {
        if (![string isEqualToString:@""]) {
            if ([self charLengthOf:_textField.text] != _maxLength) {
                
                // 如果输入的最后一个字符是emoji, 且输入后超过最大限制字符编码, 则返回
                NSInteger curLength = [self charLengthOf:_textField.text];
                NSInteger stringLength = [self charLengthOf:string];
                if (curLength + stringLength > _maxLength && [self isContainsEmoji:string]) {
                    return NO;
                }
                
                [self text:toBeString shouldLessThanOrEqualTo:_maxLength];
            }

            return NO;
        }
    }
    
    return YES;
}

- (NSInteger)charLengthOf:(NSString*)string {
    // 拿到所有str的length长度（包括中文英文..都算为1个字符）
    NSUInteger len = string.length;
    // 汉字字符集
    NSString *pattern = @"[\u4e00-\u9fa5]";
    // 正则表达式筛选条件
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    // len已经把中文算进去了，中文少的一个字符通过numMatch个数来补充，效果就是中文2个字符，英文1个字符
    return len + numMatch;
}

// 是否含有emoji表情
- (BOOL)isContainsEmoji:(NSString*)string {
    __block BOOL flag = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar curChar = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= curChar && curChar <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((curChar - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    flag = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar curChar = [substring characterAtIndex:1];
            if (curChar == 0x20e3) {
                flag = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= curChar && curChar <= 0x27ff) {
                flag = YES;
            } else if (0x2B05 <= curChar && curChar <= 0x2b07) {
                flag = YES;
            } else if (0x2934 <= curChar && curChar <= 0x2935) {
                flag = YES;
            } else if (0x3297 <= curChar && curChar <= 0x3299) {
                flag = YES;
            } else if (curChar == 0xa9 || curChar == 0xae || curChar == 0x303d || curChar == 0x3030 || curChar == 0x2b55 || curChar == 0x2b1c || curChar == 0x2b1b || curChar == 0x2b50) {
                flag = YES;
            }
        }
    }];
    
    return flag;
}

- (void)drawRect:(CGRect)rect {
    _textField.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (_textField) {
        _textField.placeholder = placeholder;
    }
}

@end
