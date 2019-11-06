//
//  BLFeedbackTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLFeedbackTableViewController.h"
#import "UITextView+PlaceHolder.h"
#import "TZImagePickerController.h"
#import "ZLPicSelectView.h"
#import <LCProgressHUD.h>
#import "ZLNetTool.h"
#import "BLInsertFeedbackAPI.h"
#import "NTCatergory.h"

@interface BLFeedbackTableViewController ()<TZImagePickerControllerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSArray *imageUrls;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet ZLPicSelectView *picSelctView;


//197 44

@property (nonatomic, strong) BLInsertFeedbackAPI *insertFeedbackAPI;
@end

@implementation BLFeedbackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.placeholder = @"首位留言反馈，经采纳有奖";
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    
    self.picSelctView.dataMaxCount = 20;
    
    [self.picSelctView setViewHeightUpdate:^{
        [weakSelf.tableView reloadData];
    }];
}

- (IBAction)submitEvent:(id)sender {
    if (self.textView.text.length == 0) {
        [LCProgressHUD show:@"请输入反馈内容"];
        return;
    }
    
    if (self.picSelctView.imgDatas) {
        
//        [self.insertFeedbackAPI loadData];

        [ZLNetTool zl_upLoadWithImages:self.picSelctView.imgDatas success:^(id  _Nullable obj) {

            if ([obj[@"code"] intValue] == 200) {
                self.imageUrls = obj[@"data"];
                [self.insertFeedbackAPI loadData];
            }

        } failure:^(NSError * _Nullable error) {
            [LCProgressHUD show:error.localizedDescription];
        }];
    }else {
        [self.insertFeedbackAPI loadData];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120 + self.picSelctView.viewHeight;
    }
    return 44;
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.insertFeedbackAPI isEqual:manager]) {
        
        if (self.imageUrls.count > 0) {
            return @{@"contact":_textField.text?_textField.text: @"",
                     @"content": _textView.text?_textView.text:@"",
                     @"img" : [self.imageUrls componentsJoinedByString:@","],
                     @"type": @2
            };
        }
        
        return @{@"contact":_textField.text?_textField.text: @"",
                 @"content": _textView.text?_textView.text:@"",
                 @"type": @2
        };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.insertFeedbackAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [LCProgressHUD show:@"感谢您的反馈"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLInsertFeedbackAPI *)insertFeedbackAPI {
    if (!_insertFeedbackAPI) {
        _insertFeedbackAPI = [[BLInsertFeedbackAPI alloc] init];
        _insertFeedbackAPI.mj_delegate = self;
        _insertFeedbackAPI.paramSource = self;
    }
    return _insertFeedbackAPI;
}

@end
