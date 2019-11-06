//
//  BLAnswerSheetItemCollectionViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerSheetItemCollectionViewCell.h"
#import <NSArray+BlocksKit.h>

@interface BLAnswerSheetItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BLAnswerSheetItemCollectionViewCell

- (void)setModel:(BLTopicModel *)model {
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%ld", (long)model.idx];
    if (_model.isParsing) {
        if ([_model.isCorrect isEqualToString:@"1"]) {
            self.titleLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
            self.titleLabel.textColor = [UIColor whiteColor];
        }else {
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.backgroundColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:160/255.0 alpha:1.0];
        }
        return;
    }
    if (model.isFinish) {
        self.titleLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
        self.titleLabel.textColor = [UIColor whiteColor];
    }else {
        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

@end
