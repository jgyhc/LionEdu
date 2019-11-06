//
//  BLClassDetailTeacherModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLClassDetailTeacherModel : NSObject

@property (nonatomic, copy)   NSString *headImg;
@property (nonatomic, copy)   NSString *tutorTitle;
@property (nonatomic, copy)   NSString *descriptionString;
@property (nonatomic, assign) NSInteger tutorSort;
@property (nonatomic, copy)   NSString *name;
@end

NS_ASSUME_NONNULL_END
