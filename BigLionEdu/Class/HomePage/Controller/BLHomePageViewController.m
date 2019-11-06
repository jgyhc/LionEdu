//
//  BLHomePageViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLHomePageViewController.h"
#import "AdaptScreenHelp.h"
#import "iCarousel.h"
#import "BLTrainListViewController.h"
#import "BLAppModuleTypeGetAllBaseTypeAPI.h"
#import <YYModel.h>
#import "CWCarousel.h"
#import <Masonry.h>
#import "BLHomePageCollectionViewCell.h"
#import "BLModuleSingleton.h"
#import "BLTrainContentViewController.h"
#import "BLTrainViewController.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface BLHomePageViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource, CWCarouselDelegate, CWCarouselDatasource>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
//@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) BLAppModuleTypeGetAllBaseTypeAPI *appModuleTypeGetAllBaseTypeAPI;
@property (nonatomic, strong) CWCarousel *carousel;


@end

@implementation BLHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.appModuleTypeGetAllBaseTypeAPI loadData];
    [self.view addSubview:self.carousel];
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressView.mas_bottom).mas_offset(53);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(-flexibleWidth(70));
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(flexibleWidth(321)*1.2);
    }];
    self.progressView.progress = 0.0;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.appModuleTypeGetAllBaseTypeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            _datas = [NSArray yy_modelArrayWithClass:[BLHomePageItemModel class] json:[data objectForKey:@"data"]];
            [_carousel freshCarousel];
            if (_datas.count > 0) {
                self.progressView.progress = 1.0 / _datas.count;
            }
            [BLModuleSingleton sharedInstance].modules = _datas;
        }
    }
    
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    return nil;
}


- (NSInteger)numbersForCarousel {
    return _datas.count;
}

#pragma mark - Delegate
- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    BLHomePageCollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"BLHomePageCollectionViewCell" forIndexPath:indexPath];
    cell.model = _datas[index];
    return cell;
}

- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
//    BLTrainContentViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainContentViewController"];
//    BLHomePageItemModel *model = self.datas[index];
//    viewController.title = model.title;
//    viewController.modelId = model.Id;
    
    UINavigationController *navViewContoller = self.navigationController.tabBarController.viewControllers[1];
    BLTrainViewController *viewController =  (BLTrainViewController *)navViewContoller.viewControllers[0];
    viewController.selectIndex = index;
    [self.navigationController.tabBarController setSelectedIndex:1];
//    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)CWCarousel:(CWCarousel *)carousel didStartScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow {
}


- (void)CWCarousel:(CWCarousel *)carousel didEndScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow {
    NSInteger count = self.datas.count;
    CGFloat progress = (index + 1)*1.0 / (count*1.0);
    self.progressView.progress = progress;
}

- (BLAppModuleTypeGetAllBaseTypeAPI *)appModuleTypeGetAllBaseTypeAPI {
    if (!_appModuleTypeGetAllBaseTypeAPI) {
        _appModuleTypeGetAllBaseTypeAPI = [[BLAppModuleTypeGetAllBaseTypeAPI alloc] init];
        _appModuleTypeGetAllBaseTypeAPI.mj_delegate = self;
        _appModuleTypeGetAllBaseTypeAPI.paramSource = self;
    }
    return _appModuleTypeGetAllBaseTypeAPI;
}

- (CWCarousel *)carousel {
    if (!_carousel) {
        _carousel = ({
            CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:CWCarouselStyle_H_3];
            flowLayout.itemWidth = flexibleWidth(237);
            CWCarousel *carousel = [[CWCarousel alloc] initWithFrame:CGRectZero delegate:self datasource:self flowLayout:flowLayout];
            carousel.translatesAutoresizingMaskIntoConstraints = NO;
            carousel.endless = NO;
            [carousel registerNibView:@"BLHomePageCollectionViewCell" identifier:@"BLHomePageCollectionViewCell"];
            [carousel freshCarousel];
            [carousel setBackgroundColor:[UIColor whiteColor]];
            carousel;
        });
    }
    return _carousel;
}

@end
