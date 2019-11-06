//
//  BLScreeningModel.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLScreeningModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, assign) BOOL isSelect;
- (instancetype)initWithId:(NSString *)Id label:(NSString *)label;

@end

NS_ASSUME_NONNULL_END
