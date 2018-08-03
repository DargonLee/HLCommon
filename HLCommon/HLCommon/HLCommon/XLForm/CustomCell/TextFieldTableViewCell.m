//
//  PasswordTableViewCell.m
//  xiaoxinyong
//
//  Created by 杨桂香 on 3/22/16.
//  Copyright © 2016 xiaoxinyong. All rights reserved.
//

#import "TextFieldTableViewCell.h"
#import "XLFormViewController.h"
#import "UITableViewCell+Helper.h"
#import "XLForm.h"
#import "FormCellTagConstants.h"

@interface TextFieldTableViewCell() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTrailing;

@property (copy, nonatomic) NSString *previousTextFieldContent;
@property (strong, nonatomic) UITextRange *previousSelection;


@end

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.rightButton.hidden = YES;
    self.textField.delegate = self;
    [self.textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)update {
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypePassword] ) {
        self.textField.secureTextEntry = YES;
        self.textField.keyboardType = UIKeyboardTypeAlphabet;
    } else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypePhone]) {
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    } else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeVerificationCode]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeNumber]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeAccount]) {
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
    }
}

- (IBAction)actionShowPassword:(id)sender {
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    if (self.textField.secureTextEntry) {
        NSString *text = self.textField.text;
//        self.textField.font = [UIFont systemFontOfSize:self.textField.font.pointSize];
        self.textField.text = text;
        [self.rightButton setImage:[UIImage imageNamed:@"button_password_hide"] forState:UIControlStateNormal];
    } else {
       
        [self.rightButton setImage:[UIImage imageNamed:@"button_password_show"] forState:UIControlStateNormal];
    }
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return YES;
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return [self.formViewController textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.formViewController textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.rowDescriptor.tag isEqualToString:kBankNumber]) {
        self.previousTextFieldContent = textField.text;
        self.previousSelection = textField.selectedTextRange;
    }
    return [self.formViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.formViewController textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidChange:textField];
    [self.formViewController textFieldDidEndEditing:textField];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.textField == textField) {
        if ([self.textField.text length] > 0) {
            if ([self.rowDescriptor.tag isEqualToString:kBankNumber]) {
                self.rowDescriptor.value = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            } else {
                self.rowDescriptor.value = self.textField.text;
            }
        } else {
            self.rowDescriptor.value = nil;
        }
    }
}

-(void)reformatAsCardNumber:(UITextField *)textField
{
    if (![self.rowDescriptor.tag isEqualToString:kBankNumber]) {
        return;
    }
    // In order to make the cursor end up positioned correctly, we need to
    // explicitly reposition it after we inject spaces into the text.
    // targetCursorPosition keeps track of where the cursor needs to end up as
    // we modify the string, and at the end we set the cursor position to it.
    
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces =
    [self removeNonDigits:textField.text
andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 19) {
        // If the user is trying to enter more than 19 digits, we prevent
        // their change, leaving the text field in  its previous state.
        // While 16 digits is usual, credit card numbers have a hard
        // maximum of 19 digits defined by ISO standard 7812-1 in section
        // 3.8 and elsewhere. Applying this hard maximum here rather than
        // a maximum of 16 ensures that users with unusual card numbers
        // will still be able to enter their card number even if the
        // resultant formatting is odd.
        [textField setText:self.previousTextFieldContent];
        textField.selectedTextRange = self.previousSelection;
        
        return;
    }
    
    //    NSInteger length = [cardNumberWithoutSpaces length];
    
    
    NSString *cardNumberWithSpaces =
    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                      andPreserveCursorPosition:&targetCursorPosition];
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textField setSelectedTextRange:
     [textField textRangeFromPosition:targetPosition
                           toPosition:targetPosition]
     ];
}

/*
 Removes non-digits from the string, decrementing `cursorPosition` as
 appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
 and a cursor position of `8`, the cursor position will be changed to
 `7` (keeping it between the '2' and the '3' after the spaces are removed).
 */
- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

/*
 Inserts spaces into the string to format it as a credit card number,
 incrementing `cursorPosition` as appropriate so that, for instance, if we
 pass in `@"111111231111"` and a cursor position of `7`, the cursor position
 will be changed to `8` (keeping it between the '2' and the '3' after the
 spaces are added).
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

- (void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    [super setRowDescriptor:rowDescriptor];
    if ([rowDescriptor.tag isEqualToString:kBankNumber]) {
        [self.textField addTarget:self action:@selector(reformatAsCardNumber:) forControlEvents:UIControlEventEditingChanged];
    } else {
        //[self.textField removeTarget:self action:@selector(reformatAsCardNumber:) forControlEvents:UIControlEventEditingChanged];
    }
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return [self ui_textFieldCellHeight];
}

@end
