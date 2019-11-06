//
//  BLAnswerSheetHeaderCollectionReusableView.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerSheetHeaderCollectionReusableView.h"

@interface BLAnswerSheetHeaderCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BLAnswerSheetHeaderCollectionReusableView


//- (void)setModel:(BLTopicSectionModel *)model {
//    _model = model;
//    _titleLabel.text = model.classfierType;
//}

- (void)setModel:(NSString *)model {
    _model = model;
    _titleLabel.text = model;
}

@end
