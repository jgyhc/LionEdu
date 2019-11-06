//
//  BLSetTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLSetTableViewController.h"
#import <YYMemoryCache.h>
#import <YYDiskCache.h>
#import <YYWebImageManager.h>
#import "UIViewController+ORAdd.h"

@interface BLSetTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;//row 8

@end

@implementation BLSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.1fM",[self folderSize]];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"setHelp"]) {
//        type
        [segue.destinationViewController setValue:@(1) forKey:@"type"];
    }else if ([segue.identifier isEqualToString:@"setAbout"]) {
        [segue.destinationViewController setValue:@(2) forKey:@"type"];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 8 && indexPath.section == 0) {
        if ([self folderSize] == 0) {
            return;
        }
        [self or_showAlert:@"温馨提示" message:@"确定清楚图片缓存吗" okAction:^{
            [self removeCache];
        }];
    }
}

- (CGFloat)folderSize{
    
    
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    
    return  (cache.diskCache.totalCost + cache.memoryCache.totalCost) / 1024.0 / 1024.0;
}


- (void)removeCache{
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.diskCache removeAllObjects];
        [cache.memoryCache removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cacheLabel.text = [NSString stringWithFormat:@"0.0M"];
        });
    });
    
}


@end
