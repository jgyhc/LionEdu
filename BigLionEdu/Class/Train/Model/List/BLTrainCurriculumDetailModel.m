//
//  BLTrainShareDetailModel.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainCurriculumDetailModel.h"
#import "NTCatergory.h"

@implementation BLTrainCurriculumDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tutorDTOS": [BLTrainShareDetailTutorModel class],
             @"liveRecCourseTypeDTOS": [BLTrainShareDetailCourseModel class]
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}

- (BOOL)isVideo {
    NSArray *arr = @[@"mp4", @"rmvb", @"avi", @"flv"];
    NSLog(@"%@", [self.lionFilePath pathExtension]);
    return [arr containsObject:[self.lionFilePath pathExtension]];
}

- (NSAttributedString *)introduceAttr {
    if (!_introduceAttr) {
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[self.introduce dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [attrString setYy_font:[UIFont systemFontOfSize:14]];
        _introduceAttr = attrString.copy;
    }
    return _introduceAttr;
}

- (void)setIntroduce:(NSString *)introduce {
    
    NSString *width = [NSString stringWithFormat:@"<img style=\"max-width:%fpx; height:auto;\"", NT_SCREEN_WIDTH - 20];
    introduce  = [introduce stringByReplacingOccurrencesOfString:@"<img" withString:width];
    _introduce = introduce;
}

@end


@implementation BLTrainShareDetailTutorModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc": @"description"};
}

@end

@implementation BLTrainShareDetailCourseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @"id"};
}


@end
