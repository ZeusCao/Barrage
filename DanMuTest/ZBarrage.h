//
//  ZBarrage.h
//  ZBarrage
//
//  Created by zc09v on 16/11/28.
//  Copyright © 2016年 zc09v. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZBarrage : NSObject

//弹幕是否处于播放中(暂停也属于播放中)
@property (nonatomic,readonly) BOOL isPlaying;
//弹幕是否被暂停
@property (nonatomic,readonly) BOOL isPaused;
//当所有弹幕播放完成时回调
@property (nonatomic,copy) void(^allBulletsFlyFinishBlk)();

//初始化方法
//参数：弹幕数据数组
-(instancetype)initWithComments:(NSMutableArray *)comments;

//生成弹幕视图
//参数：视图frame、弹道数、播放持续时长
-(UIView *)generateBarrageView:(CGRect)frame trackNum:(int)trackNum flyDuration:(CGFloat)duration;

//开始、暂停播放
-(void)startPlay;
//停止播放
-(void)stopPlay;

@end
