//
//  BLInterViewContainerView.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/9.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLInterViewContainerView.h"
#import "BLInterviewCell.h"
#import "NTCatergory.h"
#import <Masonry.h>

@interface BLInterViewContainerView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BLInterViewContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self rt_initailizeUI];
    }
    return self;
}

- (void)rt_initailizeUI {
    self.tableView = [UITableView new];
    self.tableView.backgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 72;
    [self.tableView registerNib:[UINib nibWithNibName:@"BLInterviewCell" bundle:nil] forCellReuseIdentifier:@"BLInterviewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLInterviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLInterviewCell"];
    return cell;
}


@end
