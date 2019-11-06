//
//  BLMessageTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMessageTypeTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAPPMyMessageApi.h"
#import "ZLUserInstance.h"
#import "BLMyNewsModel.h"
#import <NSObject+YYModel.h>
#import "BLMessageListViewController.h"

@interface BLMessageTypeTableViewController ()<ZLTableViewDelegateManagerDelegate,MJAPIBaseManagerDelegate,CTAPIManagerParamSource>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLAPPMyMessageTypeApi *typeApi;

@property(nonatomic, strong) NSMutableArray *sectionModelItems;

@end

@implementation BLMessageTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.typeApi loadData];
    self.sectionModelItems = [NSMutableArray new];
    [self.manager reloadData];
}


#pragma mark data

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.typeApi isEqual:manager]) {
        return @{
                 };
    }
    return nil;
}

- (BLAPPMyMessageTypeApi *)typeApi{
    if (!_typeApi) {
        _typeApi =[[BLAPPMyMessageTypeApi alloc]init];
        _typeApi.mj_delegate =self;
        _typeApi.paramSource =self;
    }
    return _typeApi;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code != 200) {
        return;
    }
    id model = [data objectForKey:@"data"];
    for (NSDictionary *dic in model) {
        BLMyNewsTypeModel *model = [BLMyNewsTypeModel yy_modelWithJSON:dic];
        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
        rowModel.identifier = @"BLMessageTypeTableViewCell";
        rowModel.cellHeight = 73;
        rowModel.data = model;
        [self.sectionModelItems addObject:rowModel];
    }
    [self.manager reloadData];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        sectionModel.items = self.sectionModelItems;
        sectionModel;
    })];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLMessageListViewController *viewController = (BLMessageListViewController *)[[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMessageListViewController"];
    BLMyNewsTypeModel *typeModel = (BLMyNewsTypeModel *)model.data;
    viewController.messageTypeId = typeModel.Id;
    viewController.titleStr = typeModel.title;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

@end
