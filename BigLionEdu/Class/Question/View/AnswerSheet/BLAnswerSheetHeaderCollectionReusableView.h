//
//  BLAnswerSheetHeaderCollectionReusableView.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLAnswerSheetHeaderCollectionReusableView : UICollectionReusableView

//@property (nonatomic, strong) BLTopicSectionModel * model;

@property (nonatomic, copy) NSString *model;

@end

NS_ASSUME_NONNULL_END
