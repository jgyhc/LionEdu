//
//  BLNewsListModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/3.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLNewsDTOListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLNewsListModel : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<BLNewsDTOListModel *> *list;

@end

NS_ASSUME_NONNULL_END
