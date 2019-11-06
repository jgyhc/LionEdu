//
//  BLCouponsCenterTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/29.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLCouponsCenterTableViewCell.h"

@interface BLCouponsCenterTableViewCell ()

@property (nonatomic, strong) CAGradientLayer *bgLayer;

@end

@implementation BLCouponsCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.getBtn.layer.cornerRadius = 12.3;
    self.getBtn.clipsToBounds = YES;
    self.getBtn.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BLMyCouponslistModel *)model{
    if (model.isDrawed) {
        self.statusLab.textColor = [UIColor colorWithRed:230/255.0 green:53/255.0 blue:53/255.0 alpha:1.0];
        self.statusLab.text = @"已领取";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"去使用" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"TsangerJinKai03" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0]}];
        [self.getBtn setAttributedTitle:string forState:UIControlStateNormal];
        
        _bgLayer.hidden = YES;
        self.getBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0].CGColor;
        self.getBtn.layer.borderWidth = 1;
    }else{
        self.statusLab.textColor = [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
        self.statusLab.text = [NSString stringWithFormat:@"剩余%@张",model.totalNum];

        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"立即领取" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"TsangerJinKai03" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        [self.getBtn setAttributedTitle:string forState:UIControlStateNormal];
//        view.frame = CGRectMake(274.5,284,72,24.5);
        
        if (!_bgLayer) {
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = self.getBtn.bounds;
            gl.startPoint = CGPointMake(0, 0);
            gl.endPoint = CGPointMake(1, 1);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:185/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0.0),@(1.0)];
            
            [self.getBtn.layer insertSublayer:gl atIndex:0];
            _bgLayer = gl;
        }
        _bgLayer.hidden = NO;
        self.getBtn.layer.borderWidth = 0;

    }
    
//    self.MoneyLab.text = model.overPrice;
//    self.titLab.text = model.instruction;
//    self.typeLab.text = model.isDiscount;
//    self.timeLab.text = model.validDay;
    
    
    self.MoneyLab.text = model.saleValue;
    self.titLab.text = model.title;
    self.typeLab.text = model.isDiscount;
//    self.timeLab.text = model.validDay;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"有效期至：yyyy-MM-dd";
    NSDate *valiDate = [NSDate dateWithTimeIntervalSinceNow:model.validDay.integerValue * 24 * 60 * 60];
    self.timeLab.text = [formatter stringFromDate:valiDate];
}

@end
