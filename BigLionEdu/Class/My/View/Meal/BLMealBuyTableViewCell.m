//
//  BLMealBuyTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMealBuyTableViewCell.h"

@interface BLMealBuyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation BLMealBuyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.containerView layoutIfNeeded];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0,self.buyButton.bounds.size.width, 25);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:185/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    gl.cornerRadius = 12.5;
    
    [self.buyButton.layer addSublayer:gl];
    [self.buyButton.layer insertSublayer:gl atIndex:0];
}

- (IBAction)action_buyPacket:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:buyPackageBtnDidClickWithModel:)]) {
        [self.delegate cell:self buyPackageBtnDidClickWithModel:self.model];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(BLMyAllMealModel *)model{
    _model = model;
    self.titLab.text = model.name;
    //将对象类型的时间转换为NSDate类型
//    double time = model.dueTime;
//    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
//    //设置时间格式
//    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    //将时间转换为字符串
//    NSString *timeStr=[formatter stringFromDate:myDate];
    self.timeLab.text = [NSString stringWithFormat:@"%li个月",(long)model.dueTime];
    self.moneyLab.text = [NSString stringWithFormat:@"%0.2f",model.price];
}
//
//-(void)setData:(BLMyAllMealModel *)model{
//
//}

@end
