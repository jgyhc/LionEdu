//
//  BLQuestionYearViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/19.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLQuestionYearViewController.h"
#import "AdaptScreenHelp.h"

@interface BLQuestionYearViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pikerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (nonatomic, strong) NSArray * years;

@property (nonatomic, assign) NSInteger row;
@end

@implementation BLQuestionYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger year = [[self currentYear] integerValue];
    NSMutableArray *years = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i ++) {
        [years addObject:[NSString stringWithFormat:@"%ld", year - i]];
    }
    _years = years;
    if (_startYear) {
        NSMutableArray *currentYears = [NSMutableArray array];
        [_years enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [currentYears addObject:obj];
            if ([obj isEqualToString:self.startYear]) {
                *stop = YES;
            }
        }];
        _years = currentYears;
    }
    
    if (_endYear) {
        NSMutableArray *currentYears = [NSMutableArray array];
        [_years enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj integerValue] <= [self.endYear integerValue]) {
                [currentYears addObject:obj];
            }
        }];
        _years = currentYears;
    }
    self.bottomSpace.constant = -300 - BottomSpace();
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself show];
    });
}

- (void)show {
    self.bottomSpace.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hide {
    self.bottomSpace.constant = -300;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

- (NSString *)currentYear {
    NSDate * senddate=[NSDate date];
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *thisYearString = [dateformatter stringFromDate:senddate];
    return thisYearString;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _years.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _row = row;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _years[row];
}

- (IBAction)cancelEvent:(id)sender {
    [self hide];
}

- (IBAction)sureEvent:(id)sender {
    if (_block) {
        _block(_years[_row]);
    }
    [self hide];
}

@end
