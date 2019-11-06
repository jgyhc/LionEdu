//
//  BLMyMistakeModel.m
//  BigLionEdu
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyMistakeModel.h"
@implementation BLMyMistakeIDotsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end

@implementation BLMyMistakeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"functionTypeDTOList": [BLMyMistakeModel class],
             @"questionList" : [BLMyMistakeQuestionModel class]
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    [self.questionList enumerateObjectsUsingBlock:^(BLMyMistakeQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = selected;
    }];
    [self.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = selected;
    }];
}

- (void)setIsPull:(BOOL)isPull {
    _isPull = isPull;
    if (!isPull) {
        [self.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isPull = NO;
        }];
    }
}

- (void)or_changeSelect {
    
    __block BOOL selected = YES;

    [self.questionList enumerateObjectsUsingBlock:^(BLMyMistakeQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.selected) {
            selected = NO;    
        }
    }];
    

    [self.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj or_changeSelect];
        if (!obj.selected) {
            selected = NO;
        }
    }];
    _selected = selected;
}

- (NSInteger)questionNum {
    __block NSInteger num = self.questionList.count;
    [self.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        num += obj.questionNum;
    }];
    return num;
}

- (NSArray *)questionIDData {
    NSMutableArray *array = [NSMutableArray array];
    [self.questionList enumerateObjectsUsingBlock:^(BLMyMistakeQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            [array addObject:[NSString stringWithFormat:@"%ld",(long)obj.memberQuestionId]];
        }
    }];
    [self.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyMistakeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObjectsFromArray:obj.questionIDData];
    }];
    return array;
}

@end

@implementation BLMyMistakeFunctionTypesModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end

@implementation BLMyMistakeQuestionListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end

@implementation BLMyMistakeQuestionModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end


@implementation BLMyMistakeInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"functionTypes": [BLMyMistakeFunctionTypesModel class],@"questionList":[BLMyMistakeQuestionListModel class]};
}
@end
