//
//  BLMyRecordModel.m
//  BigLionEdu
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyRecordModel.h"

@implementation BLMyRecordTypeDotsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end

@implementation BLMyRecordTypeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"functionTypeErrorDTOS": [BLMyRecordTypeDotsModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end

@implementation BLMyRecordInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"functionTypeDTOList" : [BLMyRecordInfoModel class],
             @"setRecordDTOList" : [BLMyRecordDTOListModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}

- (NSInteger)questionNum {
    __block NSInteger num = self.setRecordDTOList.count;
    [self.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyRecordInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        num += obj.questionNum;
    }];
    return num;
}

- (void)setIsPull:(BOOL)isPull {
    _isPull = isPull;
    if (!isPull) {
        [self.functionTypeDTOList enumerateObjectsUsingBlock:^(BLMyRecordInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isPull = NO;
        }];
    }
}



@end

@implementation BLMyRecordDTOListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modelid": @"id"};
}
@end
