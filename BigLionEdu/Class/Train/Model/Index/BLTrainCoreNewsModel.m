//
//  BLTrainCoreNewsModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/19.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainCoreNewsModel.h"
#import <UIKit/UIKit.h>

@implementation BLTrainCoreNewsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}
- (void)setTitle:(NSString *)title {
    _title = title;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"◆" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W03" size:8],NSForegroundColorAttributeName : [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}]];
    
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:_title?_title:@"" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"TsangerJinKai03-W03" size:13],NSForegroundColorAttributeName : [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}]];
    
    _titleString = att;
}


@end
