//
//  BLOffLineVideoCell.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOffLineVideoCell.h"
#import "FKDownloader.h"

@interface BLOffLineVideoCell ()<FKTaskDelegate>

@end

@implementation BLOffLineVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = self.backgroundColor = [UIColor whiteColor];
    self.contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(operationDidTap)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(BLClassScheduleItemModel *)model {
    _model = model;
    self.titleLab.text = model.liveRecCourseTitle;
    self.timeLab.text = [NSString stringWithFormat:@"时长：%ld", model.hours];
    FKTask *task = [[FKDownloadManager manager] acquire:[IMG_URL stringByAppendingString:model.noteLocation?:@""]];
    self.task = task;
    if (task.status == TaskStatusSuspend) {
        self.timeLab.text = [NSString stringWithFormat:@"时长：%ld   已暂停下载", model.hours];
    } else if (task.status == TaskStatusExecuting) {
         NSString *speedAddRemianing = [NSString stringWithFormat:@"%@  剩余：%@", [task bytesPerSecondSpeedDescription], [task estimatedTimeRemainingDescription]];
        self.timeLab.text = [NSString stringWithFormat:@"时长：%ld    %@", self.model.hours, speedAddRemianing];
    } else if (task.status == TaskStatusFinish) {
        self.timeLab.text = [NSString stringWithFormat:@"时长：%ld   已完成下载", model.hours];
    } else {
        self.timeLab.text = [NSString stringWithFormat:@"时长：%ld", model.hours];
    }
}

- (void)setTask:(FKTask *)task {
    _task = task;
    task.delegate = self;
}

/*
TaskStatusNone = 0,     // 无状态, 仅表示已加入队列
TaskStatusPrepare,      // 预处理
TaskStatusIdle,         // 等待中
TaskStatusExecuting,    // 执行中
TaskStatusFinish,       // 已完成
TaskStatusSuspend,      // 已暂停
TaskStatusResuming,     // 恢复中
TaskStatusChecksumming, // 文件校验中
TaskStatusChecksummed,  // 文件校验完成
TaskStatusCancelld,     // 已取消
TaskStatusUnknowError   // 未知错误
 */
- (void)operationDidTap{
    FKTask *task = [[FKDownloadManager manager] acquire:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
    if (task.status == TaskStatusSuspend) {
        [[FKDownloadManager manager] resume:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
    } else if (task.status == TaskStatusExecuting) {
        [[FKDownloadManager manager] suspend:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
    } else if (task.status == TaskStatusFinish) {
        [self.delegate BLOffLineVideoCellPush:self.model];
    } else {
        [[FKDownloadManager manager] start:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
    }
}

- (void)stopDidTap:(UIButton *)sender {
    [[FKDownloadManager manager] cancel:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
}

#pragma mark - FKTaskDelegate
- (void)downloader:(FKDownloadManager *)downloader prepareTask:(FKTask *)task {
    NSLog(@"预处理: %@", task.url);
    // 在这里可以最后一次处理任务信息
}

- (void)downloader:(FKDownloadManager *)downloader willExecuteTask:(FKTask *)task {
    NSLog(@"准备开始: %@", task.url);
//    self.nameLable.text = [NSURL URLWithString:task.url].lastPathComponent;
}

- (void)downloader:(FKDownloadManager *)downloader didExecuteTask:(FKTask *)task {
    NSLog(@"已开始: %@", task.url);
//    [self.operationButton setTitle:@"暂停" forState:UIControlStateNormal];
}

- (void)downloader:(FKDownloadManager *)downloader didIdleTask:(FKTask *)task {
    NSLog(@"开始等待: %@", task.url);
//    [self.operationButton setTitle:@"等待中" forState:UIControlStateNormal];
}

- (void)downloader:(FKDownloadManager *)downloader progressingTask:(FKTask *)task {

}

- (void)downloader:(FKDownloadManager *)downloader didFinishTask:(FKTask *)task {
    NSLog(@"已完成: %@", task.url);
    self.timeLab.text = [NSString stringWithFormat:@"时长：%ld   已完成下载", self.model.hours];
}

- (void)downloader:(FKDownloadManager *)downloader willSuspendTask:(FKTask *)task {
    NSLog(@"将暂停: %@", task.url);
}

- (void)downloader:(FKDownloadManager *)downloader didSuspendTask:(FKTask *)task {
    NSLog(@"已暂停: %@", task.url);
//    [self.operationButton setTitle:@"继续" forState:UIControlStateNormal];
    self.timeLab.text = [NSString stringWithFormat:@"时长：%ld   已暂停下载", self.model.hours];
}

- (void)downloader:(FKDownloadManager *)downloader willCanceldTask:(FKTask *)task {
    NSLog(@"将取消: %@", task.url);
}

- (void)downloader:(FKDownloadManager *)downloader didCancelldTask:(FKTask *)task {
    NSLog(@"已取消: %@", task.url);
}

- (void)downloader:(FKDownloadManager *)downloader willChecksumTask:(FKTask *)task {
    NSLog(@"开始校验文件");
}

- (void)downloader:(FKDownloadManager *)downloader didChecksumTask:(FKTask *)task {
    NSLog(@"校验文件结束: %d", task.isPassChecksum);
}

- (void)downloader:(FKDownloadManager *)downloader errorTask:(FKTask *)task {
    NSLog(@"下载出错: %@", task.error);
}

- (void)downloader:(FKDownloadManager *)downloader speedInfo:(FKTask *)task {
    
    NSString *speedAddRemianing = [NSString stringWithFormat:@"%@  剩余：%@", [task bytesPerSecondSpeedDescription], [task estimatedTimeRemainingDescription]];
    
     self.timeLab.text = [NSString stringWithFormat:@"时长：%ld    %@", self.model.hours, speedAddRemianing];
}

@end
