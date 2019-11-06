//
//  BLQuestionScreeningTimeCollectionViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/19.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLQuestionScreeningTimeCollectionViewCell.h"

@interface BLQuestionScreeningTimeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *endButton;

@end

@implementation BLQuestionScreeningTimeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)startEvent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(startTimeEvent:)]) {
        [self.delegate startTimeEvent:@""];
    }
    
}

- (IBAction)endEvent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(endTimeEvent:)]) {
        [self.delegate endTimeEvent:@""];
    }
}

- (void)setModel:(NSDictionary *)model {
    NSString *startYear = [model objectForKey:@"startYear"];
    if (startYear && startYear.length > 0) {
        [_startButton setTitle:startYear forState:UIControlStateNormal];
    }else {
        [_startButton setTitle:@"起始" forState:UIControlStateNormal];
    }
    
    NSString *endYear = [model objectForKey:@"endYear"];
    if (endYear && endYear.length > 0) {
        [_endButton setTitle:endYear forState:UIControlStateNormal];
    }else {
        [_endButton setTitle:@"结束" forState:UIControlStateNormal];
    }
}

@end
