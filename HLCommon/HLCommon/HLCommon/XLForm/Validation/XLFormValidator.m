//
//  XLFormValidator.h
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLFormValidationStatus.h"
#import "XLFormRegexValidator.h"

#import "XLFormValidator.h"

@implementation XLFormValidator

-(XLFormValidationStatus *)isValid:(XLFormRowDescriptor *)row
{
    return [XLFormValidationStatus formValidationStatusWithMsg:nil status:YES rowDescriptor:row];
}

#pragma mark - Validators


+(XLFormValidator *)emailValidator
{
    return [XLFormRegexValidator formRegexValidatorWithMsg:NSLocalizedString(@"Invalid email address", nil) regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

+(XLFormValidator *)emailValidatorLong
{
    return [XLFormRegexValidator formRegexValidatorWithMsg:NSLocalizedString(@"Invalid email address", nil) regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,11}"];
}

+ (XLFormValidator *)passwordValidator {
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"密码为8-16位的数字和字母组合" regex:@"^(?![0-9]+$)(?![a-zA-Z!@#$%^&*]+$)[\\w\\W]{8,16}"];
}

+ (XLFormValidator *)phoneValidator {
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"手机号不正确" regex:@"^1+[3578]+\\d{9}" ];
}

+ (XLFormValidator *)bankCardNumberValidator {
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"银行卡号有误" regex:@"[0-9]{16,19}" ];
}

+ (XLFormValidator *)IDNumberValidator {
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"身份证号不正确" regex:@"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)" ];
}

+ (XLFormValidator *)verificationCodeValidator {
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"验证码不正确" regex:@"[0-9]{6}" ];
}

+ (XLFormValidator *)usernameValidator {
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"请输入正确的姓名" regex:@"^[a-zA-Z\u4E00-\u9FA5·•]{1,20}" ];
}



@end
