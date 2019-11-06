//
//  BLVoiceSpeedAlertView.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLVoiceSpeedAlertView.h"
#import "NTCatergory.h"
#import <Masonry.h>

@interface BLVoiceSpeedAlertView ()<UITableViewDelegate, UITableViewDataSource, BLVoiceSpeedAlertViewCellDelegate>

@property (nonatomic, strong) NSArray *speeds;

@end

@implementation BLVoiceSpeedAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    _current = 1;
    self.speeds = @[@"0.75x", @"1x", @"1.25x", @"1.5x", @"2.0x"];
    self.frame = CGRectMake(0, 0, NT_SCREEN_WIDTH, NT_SCREEN_HEIGHT);
    self.mask = [[UIView alloc] initWithFrame:self.bounds];
    self.mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:self.mask];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.cornerRadius = 5.0;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NT_SCREEN_WIDTH, 265));
        make.bottom.left.right.equalTo(self);
    }];
    
    self.tableView = [UITableView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44.0;
    [self.tableView registerClass:[BLVoiceSpeedAlertViewCell class] forCellReuseIdentifier:NSStringFromClass([BLVoiceSpeedAlertViewCell class])];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)updateLayout {
    self.isLand = YES;
    [self.mask mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(265);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(265);
    }];
    [self layoutSubviews];
    [self.tableView reloadData];
}



- (void)setCurrent:(NSInteger)current {
    _current = current;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLVoiceSpeedAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLVoiceSpeedAlertViewCell class])];
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (indexPath.row == 5) {
        cell.cancelLab.hidden = NO;
        cell.checkBtn.hidden = YES;
    } else {
        [cell.speedLab setTitle:self.speeds[indexPath.row] forState:UIControlStateNormal];
        cell.cancelLab.hidden = YES;
        cell.checkBtn.hidden = NO;
    }
    if (_current == indexPath.row) {
        cell.checkBtn.selected = YES;
    } else {
        cell.checkBtn.selected = NO;
    }
    return cell;
}

- (void)didSelectHandler:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        [self dismiss];
    } else {
        self.didSelectHandler(indexPath.row);
        [self dismiss];
    }
}

- (void)cancelHandler {
    [self dismiss];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        [self dismiss];
    } else {
        self.didSelectHandler(indexPath.row);
        [self dismiss];
    }
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.mask.alpha = 1;
        self.contentView.alpha = 1;
    }];
}

- (void)dismiss {
    if (self.isLand) {
        self.hidden = YES;
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.mask.alpha = 0;
            self.contentView.alpha = 0;
        }];
        [self removeFromSuperview];
    }
}

- (void)cancel {
    
    [self dismiss];
}

- (void)sure {
    [self dismiss];
}

@end


@implementation BLVoiceSpeedAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self rt_initailizeUI];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (void)rt_initailizeUI {
    self.speedLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.speedLab setTitleColor:[UIColor nt_colorWithHexString:@"#333333"] forState:UIControlStateNormal];;
    self.speedLab.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.speedLab setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.contentView addSubview:self.speedLab];
    [self.speedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
    [self.speedLab addTarget:self action:@selector(bl_select) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelLab setTitleColor:[UIColor nt_colorWithHexString:@"#333333"] forState:UIControlStateNormal];;
    self.cancelLab.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelLab setTitle:@"取消" forState:UIControlStateNormal];
    [self.contentView addSubview:self.cancelLab];
    [self.cancelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.cancelLab.hidden = YES;
    [self.cancelLab addTarget:self action:@selector(bl_cancel) forControlEvents:UIControlEventTouchUpInside];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor nt_colorWithHexString:@"#E5E5E5"];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkBtn setImage:[UIImage imageNamed:@"sx_g"] forState:UIControlStateSelected];
    [self.checkBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.contentView addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)bl_cancel {
    [self.delegate cancelHandler];
}

- (void)bl_select {
    [self.delegate didSelectHandler:self.indexPath];
}

@end
