//
//  BLMistakesHeaderTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/28.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMistakesHeaderTableViewCell.h"

@interface BLMistakesHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end

@implementation BLMistakesHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLMyMistakeModel *)model {
    
    _backGroundView.backgroundColor = model.functionTypeDTOList.count > 0 ? [UIColor whiteColor] : [UIColor clearColor];
    
//    NSString *imagename = @"my_tmsc_sq_2";
//    NSString *selectImageName = @"my_tmsc_zk_2";
//    
//    if (model.functionTypeDTOList.count > 0) {
//        imagename = @"my_tmsc_sq";
//        selectImageName = @"my_tmsc_zk";
//    }
//    [_statusBtn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
//    [_statusBtn setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    
    _model = model;
    _numLabel.text = [NSString stringWithFormat:@"%ld题",(long)model.questionNum];
    
    _statusBtn.selected = model.isPull;
    _selectBtn.selected = model.selected;
    _titleLabel.text = model.title;
}

- (IBAction)action_select:(UIButton *)sender {
    _model.selected = !_model.selected;
    _selectBtn.selected = _model.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(or_celldidChangeSelected)]) {
        [self.delegate or_celldidChangeSelected];
    }
    
}
@end
