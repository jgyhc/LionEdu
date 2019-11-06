//
//  BLQuestionScreeningAreaCollectionReusableView.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLQuestionScreeningAreaCollectionReusableView.h"

@interface BLQuestionScreeningAreaCollectionReusableView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BLQuestionScreeningAreaCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NSString *)model {
    _model = model;
    _titleLabel.text = model;
}

@end
