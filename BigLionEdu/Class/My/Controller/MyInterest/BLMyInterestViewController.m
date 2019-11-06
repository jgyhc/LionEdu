//
//  BLMyInterestViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyInterestViewController.h"
#import "BLMyInterestItemsTableViewCell.h"
#import "AdaptScreenHelp.h"
#import "UIViewController+ZLCustomNavigationBar.h"
#import "ZLTableViewDelegateManager.h"
#import "BLMyInterestLogoTableViewCell.h"
#import "BLAPPMyselGetAppMyInterestInfoAPI.h"
#import "BLMyInterestItemModel.h"
#import <NSObject+YYModel.h>
#import "BLMyInterestButtonTableViewCell.h"
#import <LCProgressHUD.h>
#import "BLInterestItemView.h"
#import "ZLUserInstance.h"
#import "NTCatergory.h"
#import "BLInterestButton.h"
#import <Masonry.h>
#import <SDWebImage.h>

@interface BLMyInterestViewController ()<BLMyInterestItemsTableViewCellDelegate, ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>

@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic ,strong) NSMutableArray <BLInterestInfoModel *>*selectModels;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) CGFloat containerHeight;

@property (nonatomic, strong) ZLTableViewDelegateManager * manager;

@property (nonatomic, strong) ZLTableViewSectionModel * sectionModel;

@property (nonatomic, strong) NSMutableArray * items;

@property (nonatomic, strong) ZLTableViewRowModel * headerModel;

@property (nonatomic ,strong) BLAPPMyselGetAppMyInterestInfoAPI *myInterestInfoAPI;

@property (nonatomic ,strong) BLAPPMyselInsertMyInterestInfoAPI *insertInterestInfoAPI;

@property (nonatomic ,strong) BLMyInterestItemModel *itemModel;
@end

@implementation BLMyInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.customNavigationBar = [ZLCustomNavigationBar new];
    [self.customNavigationBar setTitle:@"我的兴趣" status:ZLCustomNavigationBarStatusOpaque];
    self.containerHeight = 30;
    
    [self.items addObject:self.headerModel];
    [self.items addObject:({
        ZLTableViewRowModel *row = [ZLTableViewRowModel new];
        row.identifier = @"BLMyInterestLogoTableViewCell";
        row.cellHeight = 66;
        row;
    })];
    [self.manager reloadData];
    [self.myInterestInfoAPI loadData];
}


#pragma mark data

- (void)getMyInterest{
    
}

-(BLAPPMyselGetAppMyInterestInfoAPI *)myInterestInfoAPI{
    if (_myInterestInfoAPI == nil) {
        _myInterestInfoAPI = [BLAPPMyselGetAppMyInterestInfoAPI new];
        _myInterestInfoAPI.mj_delegate =self;
        _myInterestInfoAPI.paramSource =self;
    }
    return _myInterestInfoAPI;
}

-(BLAPPMyselInsertMyInterestInfoAPI *)insertInterestInfoAPI{
    if (_insertInterestInfoAPI == nil) {
        _insertInterestInfoAPI = [BLAPPMyselInsertMyInterestInfoAPI new];
        _insertInterestInfoAPI.mj_delegate =self;
        _insertInterestInfoAPI.paramSource =self;
    }
    return _insertInterestInfoAPI;
}

- (id _Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.myInterestInfoAPI isEqual:manager]) {
        return @{@"memberId": @([ZLUserInstance sharedInstance].Id)
                 };
    }
    if ([self.insertInterestInfoAPI isEqual:manager]) {
        NSMutableArray *selectModelsAry = [NSMutableArray new];
        for (BLInterestInfoModel *model in self.selectModels) {
//            NSMutableDictionary *dic =  [model yy_modelToJSONObject];
//            dic[@"modelId"] = [NSNumber numberWithInteger:model.modelid];
//            dic[@"memberId"] = @(2019001101);
            [selectModelsAry addObject:@{@"modelId" : @(model.modelid),
                                         @"levelId" : @(1)
            }];
        }
        return selectModelsAry;
    }
    return nil;
}

-(void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    if ([manager isEqual:self.myInterestInfoAPI]) {
        NSDictionary *model = data[@"data"];
        self.itemModel = [BLMyInterestItemModel yy_modelWithJSON:model];
        for (BLInterestInfoModel *baseModel in self.itemModel.baseModels) {
            BOOL flag = NO;
            for (BLInterestInfoModel *myModel in self.itemModel.myModels) {
                if (baseModel.title == myModel.title) {
                    flag = YES;
                }
            }
            baseModel.isSelected = flag;
            if (flag == YES) {
                [self addNewTagLab:baseModel];
                [self.selectModels addObject:baseModel];
            }
        }
        [self updateTableView];
        [self addDataSource];
        [self.manager reloadData];
    }
    
    if ([manager isEqual:self.insertInterestInfoAPI]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code != 200) {
            return;
        }
        if (self.needPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (self.saveBlock) {
            self.saveBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [LCProgressHUD show:@"保存成功"];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


#pragma mark views

-(NSMutableArray *)tagViews{
    if (_tagViews == nil) {
        _tagViews = [NSMutableArray new];
    }
    return _tagViews;
}

-(NSMutableArray *)selectModels{
    if (_selectModels == nil) {
        _selectModels = [NSMutableArray new];
    }
    return _selectModels;
}

- (UIView *)getTagViewWithText:(NSString *)text icon:(NSString *)icon {
    UIView *view = [UIView new];
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:13];
    [view setBackgroundColor:NT_HEX(FF6B00)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    view.layer.cornerRadius = 3;
    view.clipsToBounds = YES;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.centerX.equalTo(view.mas_centerX).offset(-17);
    }];
    UIImageView *img = [UIImageView new];
    [img sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:icon?:@""]] placeholderImage:[UIImage imageNamed:@"my_vip_qt"]];
    [view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(label.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    return view;
}


-(void)updateTableViewWithModel:(BLInterestInfoModel *)model{
    if (model.isSelected == YES) {
        [self addNewTagLab:model];
        [self.selectModels addObject:model];
        [self updateTableView];
    }else{
        static NSUInteger index = 0;
        [self.selectModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BLInterestInfoModel *infoModel = (BLInterestInfoModel *)obj;
            if ([infoModel.title isEqualToString:model.title]) {
                index = idx;
            }
        }];
        [self.tagViews removeObjectAtIndex:index];
        [self.selectModels removeObjectAtIndex:index];
        [self updateTableView];
    }
}

-(void)addNewTagLab:(BLInterestInfoModel *)model{
    if (self.tagViews.count >= 5) {
        model.isSelected = NO;
        [LCProgressHUD show:@"最多选择5个兴趣"];
        return;
    }
    
    UIView *tagLab = [self getTagViewWithText:model.title icon:model.memberIcon];
    [self.tagViews addObject:tagLab];
}

- (void)updateTableView{
    __block CGFloat leftSpace = 0;
    __block CGFloat topSpace = 0;
    [self.tagViews enumerateObjectsUsingBlock:^( UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx % 2 == 0) {
            leftSpace = 0;
        }else {
            leftSpace = flexibleWidth(196);
        }
        NSInteger line = idx / 2;
        topSpace = line * 47;
        obj.frame = CGRectMake(leftSpace, topSpace, flexibleWidth(150), flexibleWidth(27));
        self.containerHeight = topSpace + flexibleWidth(27);
    }];
    self.headerModel.data = self.tagViews;
    self.headerModel.cellHeight = self.containerHeight + 110 + StatusBarHeight();
    [self.tableView reloadData];
}

#pragma mark table
-(void)addDataSource{
    [self.items addObject:({
        ZLTableViewRowModel *row = [ZLTableViewRowModel new];
        row.identifier = @"BLMyInterestItemsTableViewCell";
        row.data = self.itemModel;
        NSInteger count = self.itemModel.baseModels.count;
        row.cellHeight = count*34+ (count+1)*23.5;
        row.delegate = self;
        row;
    })];
    
    [self.items addObject:({
        ZLTableViewRowModel *row = [ZLTableViewRowModel new];
        row.identifier = @"BLMyInterestButtonTableViewCell";
        row.cellHeight = 109;
        row;
    })];
    self.sectionModel.items = self.items;
    [self.tableView reloadData];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel];
}

- (void)cellInitializeWithModel:(ZLTableViewRowModel *)model cell:(UITableViewCell *)cell manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[BLMyInterestLogoTableViewCell class]]) {
        BLMyInterestLogoTableViewCell *logoCell = (BLMyInterestLogoTableViewCell *)cell;
        [logoCell.checkLevelBtn addTarget:self action:@selector(checkLevelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([cell isKindOfClass:[BLMyInterestButtonTableViewCell class]]) {
        BLMyInterestButtonTableViewCell *btnCell = (BLMyInterestButtonTableViewCell *)cell;
        [btnCell.sureButton addTarget:self action:@selector(surelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView manager:(ZLTableViewDelegateManager *)manager {
    self.customNavigationBar.offsetY = scrollView.contentOffset.y;
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
        _sectionModel.items = self.items;
    }
    return _sectionModel;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (ZLTableViewRowModel *)headerModel {
    if (!_headerModel) {
        _headerModel = ({
            ZLTableViewRowModel *row = [ZLTableViewRowModel new];
            row.identifier = @"BLMyInterestHeaderTableViewCell";
            row.cellHeight = self.containerHeight + 110 + StatusBarHeight();
            row.data = self.tagViews;
            row;
        });
    }
    return _headerModel;
}


#pragma makr action
-(void)checkLevelAction:(UIButton *)sender{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLInterestDesViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)surelAction:(UIButton *)sender{
    if (self.tagViews.count == 0) {
        [LCProgressHUD show:@"请先选择至少一项兴趣"];
        return;
    }
    
    [self.insertInterestInfoAPI loadData];
}

@end
