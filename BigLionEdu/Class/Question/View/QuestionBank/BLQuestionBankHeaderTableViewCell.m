//
//  BLQuestionBankHeaderTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionBankHeaderTableViewCell.h"
#import "BLQuestionsClassificationModel.h"
#import "NTCatergory.h"

@interface BLQuestionBankHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *openImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation BLQuestionBankHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _countLabel.text = @"";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bl_openAction)];
    self.openImageView.userInteractionEnabled = YES;
    self.openImageView.externalTouchInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.openImageView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLQuestionsClassificationModel *)model {
    _model = model;
    if (model.open) {
        _openImageView.image = [UIImage imageNamed:@"my_tmsc_zk"];
        _line.hidden = YES;
    }else {
        _line.hidden = NO;
        _openImageView.image = [UIImage imageNamed:@"my_tmsc_sq"];
    }
    _titleLabel.text = model.title;
    _countLabel.text = [NSString stringWithFormat:@"(%ld套)", model.setNum];
    if ([model.isAdvance isEqualToString:@"1"]) {
        self.timeLabel.text = [NSString stringWithFormat:@"(%@发放试卷)", model.advanceDate];
    }else {
        self.timeLabel.text = @"";
    }
}

- (void)bl_openAction {
    [self.delegate BLQuestionBankHeaderTableViewCellSelect:self.model];
}

@end
