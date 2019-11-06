//
//  BLOrderFooterCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOrderFooterCell.h"
#import "NTCatergory.h"


@implementation BLOrderFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, NT_SCREEN_WIDTH - 10, 40) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 40);
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
}

- (void)setModel:(BLOrderModel *)model {
    _model = model;
    self.timeLab.text = @"";
    self.cancelBtn.hidden = self.sureBtn.hidden = YES;
//    订单状态(1：待付款，2：待发货，3：待收货，4：退款中，5：交易关闭，6：交易成功，7：交易失败)
    if ([model.status isEqualToString:@"1"]) {
        self.cancelBtn.hidden = self.sureBtn.hidden = NO;
        [self setButton:self.cancelBtn color:@"#878C97" title:@"取消订单"];
        [self setButton:self.sureBtn color:@"#FF6B00" title:@"立即支付"];
    } else if ([model.status isEqualToString:@"2"]) {
        
    } else if ([model.status isEqualToString:@"3"]) {
        self.sureBtn.hidden = NO;
        [self setButton:self.sureBtn color:@"#FF6B00" title:@"查看物流"];
    } else if ([model.status isEqualToString:@"4"]) {
        self.cancelBtn.hidden = self.sureBtn.hidden = YES;
    } else if ([model.status isEqualToString:@"5"]) {
        self.sureBtn.hidden = NO;
        [self setButton:self.sureBtn color:@"#878C97" title:@"删除订单"];
    } else if ([model.status isEqualToString:@"6"]) {
        self.sureBtn.hidden = NO;
        [self setButton:self.sureBtn color:@"#878C97" title:@"删除订单"];
    } else if ([model.status isEqualToString:@"7"]) {
        self.sureBtn.hidden = NO;
        [self setButton:self.sureBtn color:@"#FF6B00" title:@"申请退款"];
    }
    NSInteger groupStatus = model.orderGoodsList.firstObject.groupStatus.integerValue;
    if (groupStatus == 0) {
        
        if (model.orderGoodsList.firstObject.endTime) {
            self.timeLab.text = [NSString stringWithFormat:@"拼团结束时间：%@", model.orderGoodsList.firstObject.endTime];
        } else {
            self.timeLab.text = @"拼团中";
        }
    } else if (groupStatus == 1) {
        self.timeLab.text = @"拼团成功";
    } else if (groupStatus == 2) {
        self.timeLab.text = @"拼团失败";
    } else if (groupStatus == 3) {
        self.timeLab.text = @"拼团已退款";
    } else if (groupStatus == 4) {
        self.timeLab.text = @"拼团已发货";
    } else if (groupStatus == 5) {
        self.timeLab.text = @"大狮解小吼一声：拼团失败，确认退款中，原路返回退款中";
    } else if (groupStatus == 6) {
        self.timeLab.text = @"拼团发货成功";
    }
    //订单类型：0:正常订单,1：拼团订单
    if (model.singleType <= 0) {
        self.timeLab.text = @"";
    }
}

- (void)setButton:(UIButton *)button color:(NSString *)color title:(NSString *)title {
    button.layer.borderColor = [UIColor nt_colorWithHexString:color].CGColor;
    button.layer.borderWidth = 0.6;
    [button setTitleColor:[UIColor nt_colorWithHexString:color] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
}

- (IBAction)bl_cancel:(id)sender {
    [self.delegate bl_cancel:self.model];
}

- (IBAction)bl_sure:(id)sender {
    //    订单状态(1：待付款，2：待发货，3：待收货，4：退款中，5：交易关闭，6：交易成功，7：交易失败)
    if ([self.model.status isEqualToString:@"1"]) {
        [self.delegate bl_toPay:self.model];
    } else if ([self.model.status isEqualToString:@"2"]) {
        
    } else if ([self.model.status isEqualToString:@"3"]) {
        [self.delegate bl_viewDetail:self.model];
    } else if ([self.model.status isEqualToString:@"4"]) {
        
    } else if ([self.model.status isEqualToString:@"5"]) {
        [self.delegate bl_delete:self.model];
    } else if ([self.model.status isEqualToString:@"6"]) {
        [self.delegate bl_delete:self.model];
    } else if ([self.model.status isEqualToString:@"7"]) {
        [self.delegate bl_backMoney:self.model];
    }
    
}

@end
