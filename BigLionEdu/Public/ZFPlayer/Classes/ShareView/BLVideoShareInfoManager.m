//
//  BLVideoShareInfoManager.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/23.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLVideoShareInfoManager.h"


@implementation BLVideoShareInfoManager

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t conceToken;
    dispatch_once(&conceToken, ^{
        
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
}

- (void)setVideoName:(NSString *)videoName {
    _videoName = videoName;
}

- (void)setOnlinenumber:(NSString *)onlinenumber {
    _onlinenumber = [NSString stringWithFormat:@"%@人在线观看", onlinenumber];
}

@end
