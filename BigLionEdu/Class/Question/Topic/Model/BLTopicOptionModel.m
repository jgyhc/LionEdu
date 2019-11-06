
//
//  BLTopicOptionModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/20.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopicOptionModel.h"
#import <YYText.h>


@implementation BLTopicOptionModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"Id", @"id"]};
}

//- (void)setValue:(NSString *)value {
//    _value = value;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//       NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:[_value?_value:@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil]];
//              titleAttributedString.yy_font = [UIFont systemFontOfSize:14];
//              titleAttributedString.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//        _valueString = titleAttributedString;
//    });
//    
//}

//- (NSMutableAttributedString *)valueString {
//    if (!_valueString) {
//        NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:[_value?_value:@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil]];
//        titleAttributedString.yy_font = [UIFont systemFontOfSize:14];
//        titleAttributedString.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//        _valueString = titleAttributedString;
//    }
//    return _valueString;
//}

@end
