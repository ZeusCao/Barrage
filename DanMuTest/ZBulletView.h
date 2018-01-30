//
//  ZBulletView.h
//  ZBarrage
//
//  Created by zc09v on 16/11/28.
//  Copyright © 2016年 zc09v. All rights reserved.
//

#import <UIKit/UIKit.h>

//子弹状态
typedef enum
{
    FlyStart,//开始飞行
    FlyAppeared,//正好完全飞入屏幕
    FlyEnd//飞行结束
}FlyStatus;

@interface ZBulletView : UIView

//飞行状态回调
@property (nonatomic,copy) void(^flyStatusBlk)(FlyStatus flyStatus);
//子弹所在轨道
@property (nonatomic,readonly) int trackNum;

//初始化方法
//参数:子弹frame  子弹内容  子弹飞行时长  子弹所在轨道
-(instancetype)initWithFrame:(CGRect)frame comment:(NSString *)comment flyDuration:(CGFloat)duration trackNum:(int)trackNum;
//开始飞行
-(void)startFly;
//停止飞行
-(void)stopFly;
//暂停飞行
-(void)pauseFly;
//恢复飞行
-(void)resumeFly;

@end

