//
//  BLInterestButton.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/17.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLInterestButton.h"
#import "NTCatergory.h"

@implementation BLInterestButton

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.titleLabel.nt_x > self.imageView.nt_x) {
        CGFloat x = self.imageView.nt_x;
        if (x <= 0) {
            self.titleLabel.nt_centerX = self.nt_centerX;
        } else {
            self.titleLabel.nt_x = x;
        }
        NSLog(@"%lf", x);
        NSLog(@"%lf", self.nt_width);
        NSLog(@"%lf", self.titleLabel.nt_width);
        self.imageView.nt_x = x + self.titleLabel.nt_width + 5;
    }
}

@end
