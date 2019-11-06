//
//  BLTopicTextModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTopicTextModel : NSObject

@property (nonatomic, copy) NSString * text;

@property (nonatomic, strong) NSMutableAttributedString * attributedString;

@property (nonatomic, strong) NSAttributedString * tagAttributedString;

@property (nonatomic, strong) NSMutableAttributedString * contentAttributedString;

@end

NS_ASSUME_NONNULL_END
