//  我的套餐
//  BLMealViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMealViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMySelfMealApi.h"
#import <NSObject+YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <MJPlaceholderView/MJPlaceholderView.h>
#import <MJPlaceholderView/UITableView+MJPlaceholder.h>
#import "BLMyMealModel.h"
#import "BLMealBannerTableViewCell.h"
#import "BLMealButtonTableViewCell.h"
#import "ZLUserInstance.h"
#import "NTCatergory.h"

@interface BLMealViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic ,strong) NSMutableArray <BLMyMyMealModel *>*mealAry;
@property (nonatomic ,strong) BLAPPMySelfMyMealApi *mySelfMyMealApi;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation BLMealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mealAry  = [NSMutableArray new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self getData];

    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂无套餐信息",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    
    NT_WEAKIFY(self);
    [self nt_addNotificationForName:@"kBuyPackageSuccessNotification" block:^(NSNotification * _Nonnull notification) {
        [weak_self.mySelfMyMealApi loadData];
    }];    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 68 * 2, 48);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:217/255.0 blue:120/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:73/255.0 alpha:1.0].CGColor];
    gl.cornerRadius = 24;
    gl.locations = @[@(0.0),@(1.0)];
    
    [_openButton.layer addSublayer:gl];
    [_openButton.layer insertSublayer:gl atIndex:0];
}


#pragma mark data
- (void)getData{
    [self.mySelfMyMealApi loadData];
}

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    
    return nil;
}

- (BLAPPMySelfMyMealApi *)mySelfMyMealApi{
    if (!_mySelfMyMealApi) {
        _mySelfMyMealApi =[[BLAPPMySelfMyMealApi alloc]init];
        _mySelfMyMealApi.mj_delegate = self;
        _mySelfMyMealApi.paramSource = self;
    }
    return _mySelfMyMealApi;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    [self.tableView.mj_header endRefreshing];
    if (code != 200) {
        return;
    }
    NSArray  *model = [data objectForKey:@"data"];
    if (model.count == 0) {
//        [self setPlaceholderViewWith:YES];
    }else{
        
        self.mealAry = [NSArray yy_modelArrayWithClass:[BLMyMyMealModel class] json:model].mutableCopy;
        [self.manager reloadData];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


#pragma mark view
//-(UIBarButtonItem *)rightBarBtn{
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 40)];
//    [btn addTarget:self action:@selector(exchange:) forControlEvents:UIControlEventTouchUpInside];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"兑换卡卷" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"TsangerJinKai03" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
//
//    [btn setAttributedTitle:string forState:UIControlStateNormal];
//    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    return rightBarBtn;
//}



#pragma mark tableView
- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    
    if (self.mealAry.count == 0) {
        return nil;
    }
    
    return @[
                                ({
                                ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
                                sectionModel.items = @[({
                                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                    rowModel.identifier = @"BLMealBannerTableViewCell";
                                    rowModel.cellHeight = 181;
                                    rowModel.delegate = self;
                                    rowModel.data = self.mealAry;
                                    rowModel;
                                }),
                               ({
                                   ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                   rowModel.identifier = @"BLMealContentTableViewCell";
                                   rowModel.cellHeight = -1;
                                   if (self.mealAry.count > 0) {
                                       rowModel.data = self.mealAry[self.selectIndex].modelDescription;
                                   }
                                   rowModel;
                               })
                               ];
        sectionModel;
    })];
}

- (void)bannerDidChangeIndex:(NSInteger)index {
    self.selectIndex = index;
    [self.manager reloadData];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

#pragma mark action
-(void)sureAction:(UIButton *)sender{
    
}
@end
