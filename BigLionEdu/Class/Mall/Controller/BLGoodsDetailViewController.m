//
//  BLGoodsDetailViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGoodsDetailViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLGoodsDetailHeaderView.h"
#import "UIViewController+ZLCustomNavigationBar.h"
#import <CTMediator.h>
#import "BLGoodsDetailNav.h"
#import "NTCatergory.h"
#import "AdaptScreenHelp.h"
#import "BLGoodsDetailHeader.h"
#import <Masonry.h>
#import "BLGoodsDetailBannerTableViewCell.h"
#import "BLGetGoodsDetailAPI.h"
#import "BLAddGoodsCartAPI.h"
#import "BLGoodsDetailModel.h"
#import <LCProgressHUD.h>
#import <YYModel.h>
#import "BLGetCartNumAPI.h"
#import "BLGoodsDetailGroupHeaderCell.h"
#import "BLGoodsGroupCell.h"
#import "BLGoodsDetailVideoCourseCell.h"
#import "BLGoodsDetailInfoTableViewCell.h"
#import "BLJoinGroupRuleController.h"
#import "BLMallOrderSureViewController.h"
#import "BLVideoClassDetailViewController.h"
#import "NTCatergory.h"
#import "BLGoodsDetailSXCell.h"
#import "BLGoodsDetailHeaderViewCell.h"
#import "ZLUserInstance.h"
#import "BLTrainShareDetailController.h"

@interface BLGoodsDetailViewController ()<ZLTableViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate, BLGoodsGroupCellDelegate, BLGoodsDetailHeaderDelegate, BLGoodsDetailHeaderViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomRightBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinGroup;

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLGoodsDetailNav *nav;
@property (nonatomic, strong) BLGoodsDetailHeader *headerView;
@property (nonatomic, strong) BLGetGoodsDetailAPI *getGoodsDetailAPI;
@property (nonatomic, strong) BLAddGoodsCartAPI *addGoodsCartAPI;
@property (nonatomic, strong) BLGetCartNumAPI *getCartNumAPI;
@property (nonatomic, strong) BLGoodsDetailModel *model;
@property (nonatomic, strong) NSMutableArray *datas;

//1详情 2目录 3推荐
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ZLTableViewRowModel *introRow;
@property (nonatomic, strong) ZLTableViewRowModel *catalogRow;
////1详情 2目录 3推荐 内容
@property (nonatomic, strong) NSMutableDictionary *tjDict;
@property (nonatomic, strong) ZLTableViewRowModel *tjHeaderRow;

@property (nonatomic, assign) BOOL isSelectRecommend;
@property (nonatomic, assign) BOOL isSelectCatalogue;

@end

@implementation BLGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tjDict = [NSMutableDictionary dictionary];
    _index = 1;
    [_tjDict setValue:@(_index) forKey:@"index"];
    [_tjDict setValue:@"推荐" forKey:@"tj"];
    [self.tableView registerClass:NSClassFromString(@"BLGoodsDetailHeaderView") forHeaderFooterViewReuseIdentifier:@"BLGoodsDetailHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLGoodsDetailGroupHeaderCell" bundle:nil] forCellReuseIdentifier:@"BLGoodsDetailGroupHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLGoodsGroupCell" bundle:nil] forCellReuseIdentifier:@"BLGoodsGroupCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLGoodsDetailVideoCourseCell" bundle:nil] forCellReuseIdentifier:@"BLGoodsDetailVideoCourseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLGoodsDetailSXCell" bundle:nil] forCellReuseIdentifier:@"BLGoodsDetailSXCell"];
    [self.tableView registerClass:[BLGoodsDetailHeaderViewCell class] forCellReuseIdentifier:NSStringFromClass([BLGoodsDetailHeaderViewCell class])];
    
    [self.tableView registerClass:[BLGoodsDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"BLGoodsDetailHeaderView"];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.backgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.datas = [NSMutableArray array];
    [self.manager reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.nav = [[BLGoodsDetailNav alloc] initWithFrame:CGRectMake(0, 0, NT_SCREEN_WIDTH, NavigationHeight())];
    [self.view addSubview:self.nav];
    self.nav.numLab.hidden = YES;
    self.headerView = [BLGoodsDetailHeader new];
    self.headerView.delegate = self;
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.hidden = YES;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.nav.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    __weak typeof(self) wself = self;
    [self.nav setBackHandler:^{
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.nav setShareHandler:^{
        [[CTMediator sharedInstance] performTarget:@"share" action:@"mjshare" params:@{
                                                                                       @"sid":@"",
                                                                                       @"shareEventCallbackUrl":@"",
                                                                                       @"generalOptions": @{
                                                                                               @"describe": @"别身在福中不知福 ​​​​",
                                                                                               @"img": @"https://wx3.sinaimg.cn/mw690/67dd74e0gy1g5lpdxwtz5j20u00u0ajl.jpg",
                                                                                               @"linkurl": @"https://weibo.com/u/3223229794/home?wvr=5#1564759631081",
                                                                                               @"title": @"别身在福中不知福 ​​​​"
                                                                                               }
                                                                                       } shouldCacheTarget:YES];
    }];
    
    [self.nav setCartHandler:^{
        if (![ZLUserInstance sharedInstance].isLogin) {
            [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
            return;
        }
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLShoppingCartViewController"];
        [wself.navigationController pushViewController:controller animated:YES];
    }];
    
    [self.getGoodsDetailAPI loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ZLUserInstance sharedInstance].isLogin) {
        [self.getCartNumAPI loadData];
    }
}

- (IBAction)bl_addToShopCart:(id)sender {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    if (self.model.isGroup) {
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
        [controller setValue:@0 forKey:@"groupType"];
        [controller setValue:self.model.Id forKey:@"goodsId"];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self.addGoodsCartAPI loadData];
    }
}

- (IBAction)bl_toBuy:(id)sender {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
    [controller setValue:self.model.Id forKey:@"goodsId"];
    //拼团类型：0：单独购买，1：发起拼团，2：参加拼团
    if (self.model.isGroup == 1) {
        [controller setValue:@1 forKey:@"groupType"];
        [controller setValue:@"" forKey:@"groupId"];
    } else {
        [controller setValue:@0 forKey:@"groupType"];
        [controller setValue:@"" forKey:@"groupId"];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

/// 团购
- (void)BLGoodsGroupCellJoinGroup:(BLGoodsDetailGroupModel *)model {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    if (model.isEnd) {
        [LCProgressHUD show:@"该团购已结束"];
        return;
    }
    if ([model.groupType containsString:@"邀请好友"]) {
        [[CTMediator sharedInstance] performTarget:@"share" action:@"mjshare" params:@{
        @"sid":@"",
        @"shareEventCallbackUrl":@"",
        @"generalOptions": @{
                @"describe": @"别身在福中不知福 ​​​​",
                @"img": @"https://wx3.sinaimg.cn/mw690/67dd74e0gy1g5lpdxwtz5j20u00u0ajl.jpg",
                @"linkurl": @"https://weibo.com/u/3223229794/home?wvr=5#1564759631081",
                @"title": @"别身在福中不知福 ​​​​"
                }
        } shouldCacheTarget:YES];
    } else {
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
        [controller setValue:@2 forKey:@"groupType"];
        [controller setValue:model.goodsId forKey:@"groupId"];
        [controller setValue:self.model.Id forKey:@"goodsId"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView manager:(ZLTableViewDelegateManager *)manager {
    CGRect rect = self.datas.count <= 1 ? CGRectMake(0, NavigationHeight() + 10, 0, 0):CGRectZero;
    if (self.model.groupLists.count) {
        rect = [self.tableView rectForHeaderInSection:2];
    } else {
        if (self.datas.count > 1) {
            rect = [self.tableView rectForHeaderInSection:1];
        }
    }
    CGFloat offset = rect.origin.y - scrollView.contentOffset.y;
    if (offset <= NavigationHeight()) {
        [self.nav bl_topStyle];
        self.headerView.hidden = NO;
    } else {
        self.headerView.hidden = YES;
        [self.nav bl_normalStyle];
    }
    if (self.isSelectRecommend) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isSelectRecommend = NO;
        });
        return;
    }
    if (self.isSelectCatalogue) {
        [self.tjDict setValue:@2 forKey:@"index"];
        [self.headerView bl_selectToIndex:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isSelectCatalogue = NO;
        });
        return;
    }
    if (![self.model.type isEqualToString:@"1"]) {
        CGFloat y = scrollView.contentOffset.y+70;
        NSIndexPath *index = [self.tableView indexPathForRowAtPoint:CGPointMake(0, y)];
        if (index.section == self.datas.count - 2 && index.row <= 1) {
            [self.tjDict setValue:@1 forKey:@"index"];
            [self.headerView bl_selectToIndex:1];
        } else if (index.section == self.datas.count - 2 && index.row == 2) {
            [self.tjDict setValue:@2 forKey:@"index"];
            [self.headerView bl_selectToIndex:2];
        } else if (index.section == self.datas.count - 1) {
            [self.tjDict setValue:@3 forKey:@"index"];
            [self.headerView bl_selectToIndex:3];
        } else if (index != nil){
            [self.tjDict setValue:@1 forKey:@"index"];
            [self.headerView bl_selectToIndex:1];
        }
    } else {
        self.headerView.hidden = YES;
    }
    if (scrollView.contentOffset.y < 0) {
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
//    [[CTMediator sharedInstance] performTarget:@"share" action:@"mjshare" params:@{} shouldCacheTarget:YES];
    if ([model.identifier isEqualToString:@"BLGoodsDetailGroupHeaderCell"]) {
        BLJoinGroupRuleController *controller = [BLJoinGroupRuleController new];
        controller.rule = self.model.groupRule;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([model.identifier isEqualToString:@"BLGoodsDetailVideoCourseCell"]) {
        BLVideoClassDetailViewController *viewControoler = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLVideoClassDetailViewController"];
        BLGoodsDetailVideoModel *vmodel = model.data;
        viewControoler.recId = vmodel.infoId.integerValue;
        [self.navigationController pushViewController:viewControoler animated:YES];
    } else if ([model.identifier isEqualToString:@"BLGoodsDetailRecommendTableViewCell"]) {//狮享
//        BLTrainShareDetailController *viewControoler = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainShareDetailController"];
//        BLGoodsDetailSXModel *vmodel = model.data;
////        viewControoler.Id = vmodel.
    }
}


- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    if ([manager isEqual:self.getGoodsDetailAPI]) {
        return @{@"goodsId": self.goodsId};
    } else if ([manager isEqual:self.addGoodsCartAPI]) {
        return @{@"goodsId": self.goodsId,
                 @"cartPrice": self.model.price,
                 @"goodsNum": @"1"
                 };
    }
    return nil;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([manager isEqual:self.getGoodsDetailAPI]) {
        NSInteger code = [data[@"code"] integerValue];
        if (code == 200) {
            self.model = [BLGoodsDetailModel yy_modelWithJSON:data[@"data"]];
//            self.joinGroup.hidden = self.model.isGroup == 1 ? NO : YES;
            self.joinGroup.hidden = YES;
            if (self.model.isGroup == 1) {
                [self.bottomLeftBtn setTitle:[NSString stringWithFormat:@"单独购买 \n ￥%.2f", self.model.price.floatValue] forState:UIControlStateNormal];
                [self.bottomRightBtn setTitle:[NSString stringWithFormat:@"发起拼团 \n ￥%.2f", self.model.provoterPrice.floatValue] forState:UIControlStateNormal];
            }
            __weak typeof(self) wself = self;
            [self.model setRefreshHandler:^{
                wself.introRow.cellHeight = wself.model.bookIntroduceHeight;
                wself.introRow.data = wself.model.bookIntroduceAttr;
                wself.catalogRow.cellHeight = wself.model.catalogHeight;
                wself.catalogRow.data = wself.model.catalogAttr;
                [wself.manager reloadData];
            }];
            
            //banner和商品信息
            ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
            sectionModel.footerHeight = 10;
            sectionModel.headerHeight = 0.01;
            sectionModel.footerBackgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
            sectionModel.items = @[
                                ({
                                    ZLTableViewRowModel *row = [ZLTableViewRowModel new];
                                    row.identifier = @"BLGoodsDetailBannerTableViewCell";
                                    row.cellHeight = 376;
                                    row.data = self.model;
                                    row;
                                }),
                                ({
                                    ZLTableViewRowModel *row = [ZLTableViewRowModel new];
                                    row.identifier = @"BLGoodsDetailInfoTableViewCell";
                                    row.cellHeight = -1;
                                    row.data = self.model;
                                    row;
                                }),
                            ];
             [self.datas addObject:sectionModel];
            
            //团购
            if (self.model.isGroup == 1) {
                ZLTableViewSectionModel *groupSection = [ZLTableViewSectionModel new];
                groupSection.footerHeight = 10;
                groupSection.headerHeight = 0.01;
                groupSection.footerBackgroundColor = [UIColor nt_colorWithHexString:@"#F2F5F5"];
                NSMutableArray *groupItems = [NSMutableArray array];
                
                ZLTableViewRowModel *groupHeaderRow = [ZLTableViewRowModel new];
                groupHeaderRow.identifier = @"BLGoodsDetailGroupHeaderCell";
                groupHeaderRow.cellHeight = 35.0;
                [groupItems addObject:groupHeaderRow];
                if (self.model.groupLists.count > 0) {
                    for (NSInteger i = 0; i < self.model.groupLists.count; i ++) {
                        ZLTableViewRowModel *groupRow = [ZLTableViewRowModel new];
                        groupRow.identifier = @"BLGoodsGroupCell";
                        groupRow.cellHeight = 60.0;
                        groupRow.data = self.model.groupLists[i];
                        groupRow.delegate = self;
                        [groupItems addObject:groupRow];
                    }
                }
                groupSection.items = groupItems.copy;
                [self.datas addObject:groupSection];
            }
            
            //如果是试卷的话就没有目录
            if ([self.model.type isEqualToString:@"1"]) {
                if (self.model.bookIntroduce.length > 0) {
                    ZLTableViewSectionModel *recomendSection = [ZLTableViewSectionModel new];
                    recomendSection.headerHeight = 0.01;
                    recomendSection.footerHeight = 0.0;
                    
                    //推荐
                    ZLTableViewRowModel *rHeaderRow = [ZLTableViewRowModel new];
                    rHeaderRow.identifier = @"BLGoodsDetailRecommendTableViewCell";
                    rHeaderRow.cellHeight = 40;
                    rHeaderRow.data = @"详情介绍";
                    
                    ZLTableViewRowModel *intrRow = [ZLTableViewRowModel new];
                    intrRow.identifier = @"BLGoodsDetailCatalogueHeaderTableViewCell";
                    intrRow.cellHeight = self.model.bookIntroduceHeight;
                    intrRow.data = self.model.bookIntroduceAttr;
                    
                    recomendSection.items = @[rHeaderRow, intrRow];
                    
                    [self.datas addObject:recomendSection];
                }

            } else {
                //详情和目录
                ZLTableViewSectionModel *sectionModel2 = [ZLTableViewSectionModel new];
                sectionModel2.headerHeight = 0.01;
                sectionModel2.footerHeight = 0.01;
                sectionModel2.items = @[
                    ({
                        ZLTableViewRowModel *row = [ZLTableViewRowModel new];
                        row.identifier = @"BLGoodsDetailHeaderViewCell";
                        row.cellHeight = 35.0;
                        row.delegate = self;
                        self.tjHeaderRow =  row;
                        row.data = self.tjDict;
                        row;
                    }),
                    ({
                        ZLTableViewRowModel *row = [ZLTableViewRowModel new];
                        self.introRow = row;
                        row.identifier = @"BLGoodsDetailCatalogueHeaderTableViewCell";
                        row.cellHeight = self.model.bookIntroduceHeight;
                        row.data = self.model.bookIntroduceAttr;
                        row;
                    }),
                    ({
                        ZLTableViewRowModel *row = [ZLTableViewRowModel new];
                        self.catalogRow = row;
                        row.identifier = @"BLGoodsDetailCatalogueHeaderTableViewCell";
                        row.cellHeight = self.model.catalogHeight;
                        row.data = self.model.catalogAttr;
                        row;
                    })];
                [self.datas addObject:sectionModel2];
            }
            
            
            ZLTableViewSectionModel *recomendSection = [ZLTableViewSectionModel new];
            recomendSection.headerHeight = 0.01;
            recomendSection.footerHeight = 0.0;

            //推荐商品
            if (self.model.goodsList.count) {
                [self.headerView.recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
                //推荐
                ZLTableViewRowModel *rHeaderRow = [ZLTableViewRowModel new];
                rHeaderRow.identifier = @"BLGoodsDetailRecommendTableViewCell";
                rHeaderRow.cellHeight = 40;
                rHeaderRow.data = @"推荐";
                [self.tjDict setValue:@"推荐" forKey:@"tj"];
                
                //推荐的商品
                ZLTableViewRowModel *goodsRow = [ZLTableViewRowModel new];
                goodsRow.identifier = @"BLGoodsDetailGoodsListTableViewCell";
                goodsRow.cellHeight = ceilf(self.model.goodsList.count / 2.0) * NTWidthRatio(265);
                goodsRow.data = self.model.goodsList;
                
                recomendSection.items = @[rHeaderRow, goodsRow];
                [self.datas addObject:recomendSection];
                
            } else if (self.model.goodsInfoList.count) {
                NSMutableArray *recommendItems = [NSMutableArray array];
                [self.headerView.recommendButton setTitle:@"赠送视频" forState:UIControlStateNormal];
                [self.tjDict setValue:@"赠送视频" forKey:@"tj"];
                //推荐视频
                ZLTableViewRowModel *rHeaderRow = [ZLTableViewRowModel new];
                rHeaderRow.identifier = @"BLGoodsDetailRecommendTableViewCell";
                rHeaderRow.cellHeight = 40;
                rHeaderRow.data = @"赠送视频";
                [recommendItems addObject:rHeaderRow];
                
                for (NSInteger i = 0; i < self.model.goodsInfoList.count; i ++) {
                    BLGoodsDetailVideoModel *obj = self.model.goodsInfoList[i];
                    //赠送的视频
                    ZLTableViewRowModel *goodsRow = [ZLTableViewRowModel new];
                    goodsRow.identifier = @"BLGoodsDetailVideoCourseCell";
                    goodsRow.cellHeight = 126.0;
                    goodsRow.data = obj;
                    [recommendItems addObject:goodsRow];
                }
                recomendSection.items = recommendItems.copy;
                [self.datas addObject:recomendSection];
            } else if (self.model.tutorDTOS.count) {
                NSMutableArray *recommendItems = [NSMutableArray array];
                [self.headerView.recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
                [self.tjDict setValue:@"推荐" forKey:@"tj"];
                //推荐狮享
                ZLTableViewRowModel *rHeaderRow = [ZLTableViewRowModel new];
                rHeaderRow.identifier = @"BLGoodsDetailRecommendTableViewCell";
                rHeaderRow.cellHeight = 40;
                rHeaderRow.data = @"推荐";
                [recommendItems addObject:rHeaderRow];
                
                for (NSInteger i = 0; i < self.model.tutorDTOS.count; i ++) {
                    BLGoodsDetailSXModel *obj = self.model.tutorDTOS[i];
                    //赠送的视频
                    ZLTableViewRowModel *goodsRow = [ZLTableViewRowModel new];
                    goodsRow.identifier = @"BLGoodsDetailSXCell";
                    goodsRow.cellHeight = 126.0;
                    goodsRow.data = obj;
                    [recommendItems addObject:goodsRow];
                }
                recomendSection.items = recommendItems.copy;
                [self.datas addObject:recomendSection];
            } else {
                [self.datas addObject:recomendSection];
            }
            [self.manager reloadData];
        }
    } else if ([manager isEqual:self.addGoodsCartAPI]) {
        [LCProgressHUD show:data[@"msg"]];
        [self.getCartNumAPI loadData];
    } else if ([self.getCartNumAPI isEqual:manager]) {
        NSInteger number = [data[@"data"] integerValue];
        if (number <= 0) {
            self.nav.numLab.text = @"";
            self.nav.numLab.hidden = YES;
        } else {
            self.nav.numLab.hidden = !self.headerView.hidden;
            self.nav.numLab.text = [NSString stringWithFormat:@"%ld", (long)number];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

#pragma mark -- BLGoodsDetailHeaderViewDelegate
- (void)BLGoodsDetailHeaderViewCellRecommend {
    self.isSelectRecommend = YES;
    [self.tjDict setValue:@3 forKey:@"index"];
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.datas.count - 1]];
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - NavigationHeight() - 45) animated:YES];
    self.tjHeaderRow.data = self.tjDict;
    [self.headerView bl_selectToIndex:3];
}

- (void)BLGoodsDetailHeaderViewCellCatalogue {
    self.isSelectCatalogue = YES;
    [self.headerView bl_selectToIndex:2];
    [self.tjDict setValue:@2 forKey:@"index"];
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:self.datas.count - 2]];
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - NavigationHeight() - 45) animated:YES];
    self.tjHeaderRow.data = self.tjDict;
    [self.headerView bl_selectToIndex:2];
}


- (void)BLGoodsDetailHeaderRecommend {
    self.isSelectRecommend = YES;
    [self.tjDict setValue:@3 forKey:@"index"];
    self.tjHeaderRow.data = self.tjDict;
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.datas.count - 1]];
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - NavigationHeight() - 45) animated:YES];
}

- (void)BLGoodsDetailHeaderCatalogue {
    self.isSelectCatalogue = YES;
    [self.tjDict setValue:@2 forKey:@"index"];
    self.tjHeaderRow.data = self.tjDict;
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:self.datas.count - 2]];
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - NavigationHeight() - 45) animated:YES];
//    [self.manager reloadData];
}


- (void)BLGoodsDetailHeaderViewCellDetail {
    self.isSelectRecommend = YES;
    [self.tjDict setValue:@1 forKey:@"index"];
   CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:self.datas.count - 2]];
   [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - NavigationHeight() - 45) animated:YES];
    self.tjHeaderRow.data = self.tjDict;
    [self.headerView bl_selectToIndex:1];
}

- (void)BLGoodsDetailHeaderViewDetail {
    [self.tjDict setValue:@1 forKey:@"index"];
    self.tjHeaderRow.data = self.tjDict;
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:self.datas.count - 2]];
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - NavigationHeight() - 45) animated:YES];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.tableView = self.tableView;
        _manager.delegate = self;
    }
    return _manager;
}

- (BLGetGoodsDetailAPI *)getGoodsDetailAPI {
    if (!_getGoodsDetailAPI) {
        _getGoodsDetailAPI = [BLGetGoodsDetailAPI new];
        _getGoodsDetailAPI.mj_delegate = self;
        _getGoodsDetailAPI.paramSource = self;
    }
    return _getGoodsDetailAPI;
}

- (BLAddGoodsCartAPI *)addGoodsCartAPI {
    if (!_addGoodsCartAPI) {
        _addGoodsCartAPI = [BLAddGoodsCartAPI new];
        _addGoodsCartAPI.mj_delegate = self;
        _addGoodsCartAPI.paramSource = self;
    }
    return _addGoodsCartAPI;
}

- (BLGetCartNumAPI *)getCartNumAPI {
    if (!_getCartNumAPI) {
        _getCartNumAPI = [[BLGetCartNumAPI alloc] init];
        _getCartNumAPI.mj_delegate = self;
        _getCartNumAPI.paramSource = self;
    }
    return _getCartNumAPI;
}


@end
