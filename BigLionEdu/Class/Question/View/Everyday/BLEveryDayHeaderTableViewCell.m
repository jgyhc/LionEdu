//
//  BLEveryDayHeaderTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLEveryDayHeaderTableViewCell.h"

@interface BLEveryDayHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *continueLabel;

@end

@implementation BLEveryDayHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.containerView.layer.shadowColor = [UIColor colorWithRed:245/255.0 green:206/255.0 blue:170/255.0 alpha:1.0].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0,2);
    self.containerView.layer.shadowOpacity = 1;
    self.containerView.layer.shadowRadius = 4;
    self.containerView.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)shareEvent:(id)sender {
    [[CTMediator sharedInstance] performTarget:@"share" action:@"mjshare" params:@{
    @"sid":@"",
    @"shareEventCallbackUrl":@"",
    @"generalOptions": @{
            @"describe": @"测试文本",
            @"img": @"https://wx3.sinaimg.cn/mw690/67dd74e0gy1g5lpdxwtz5j20u00u0ajl.jpg",
            @"linkurl": @"https://weibo.com/u/3223229794/home?wvr=5#1564759631081",
            @"title": @"测试文本​​​​"
            }
    } shouldCacheTarget:YES];
}

- (void)setModel:(BLEveryDayDailyTipModel *)model {
    _model = model;
    _dayLabel.text = [NSString stringWithFormat:@"%ld", model.days];
    _contentLabel.text = model.tip;
}

@end
