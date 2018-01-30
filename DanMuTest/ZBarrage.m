//
//  ZBarrage.m
//  ZBarrage
//
//  Created by zc09v on 16/11/28.
//  Copyright © 2016年 zc09v. All rights reserved.
//

#import "ZBarrage.h"
#import "ZBulletView.h"

@interface ZBarrage ()
{
    //弹幕原始数据备份
    NSMutableArray *_comments;
    //运行时使用数据备份
    NSMutableArray *_useingComments;
    //子弹视图数组
    NSMutableArray *_bulletViewsAry;
    
    //弹道高度
    CGFloat _trackHeight;
    //弹道宽度
    CGFloat _trackWidth;
    //弹道数
    int _trackNum;
    //飞行时长
    CGFloat _duration;
    //弹幕视图
    UIView *_barrageView;
}
@end

@implementation ZBarrage

-(instancetype)initWithComments:(NSMutableArray *)comments
{
    self = [super init];
    if (self)
    {
        _isPlaying = NO;
        _comments = [NSMutableArray arrayWithArray:comments];
        _useingComments = [NSMutableArray arrayWithArray:comments];
        _bulletViewsAry = [[NSMutableArray alloc] init];
    }
    return self;
}

-(UIView *)generateBarrageView:(CGRect)frame trackNum:(int)trackNum flyDuration:(CGFloat)duration
{
    if (trackNum > 0)
    {
        _duration = duration;
        
        _barrageView = [[UIView alloc] initWithFrame:frame];
        _barrageView.clipsToBounds = YES;
        _trackHeight = frame.size.height/trackNum;
        _trackWidth = frame.size.width;
        _trackNum = trackNum;
        
        [self setupBullet];
        
        return _barrageView;
    }
    else
        return nil;
}

-(void)setupBullet
{
    for (int i = 0; i < _trackNum; i++)
    {
        NSString *comment = [_useingComments firstObject];
        if (comment)
        {
            [self createBulletWithComment:comment tackNum:i immediatelyFly:NO];
        }
    }
}

-(void)createBulletWithComment:(NSString *)comment tackNum:(int)trackNum immediatelyFly:(BOOL)immediatelyFly
{
    ZBulletView *bulletView = [[ZBulletView alloc] initWithFrame:CGRectMake(_trackWidth, trackNum * _trackHeight, 0, _trackHeight) comment:comment flyDuration:_duration trackNum:trackNum];
    //移走一条弹幕内容
    [_useingComments removeObjectAtIndex:0];
    
    __weak typeof(ZBulletView) *wBulletView = bulletView;
    __weak typeof(ZBarrage) *wSelf = self;
    
    bulletView.flyStatusBlk = ^void(FlyStatus status)
    {
        switch (status) {
            case FlyAppeared:
            {
                //取下一跳评论
                NSString *nextComment = [_useingComments firstObject];
                if (nextComment)
                {
                    [wSelf createBulletWithComment:nextComment tackNum:wBulletView.trackNum immediatelyFly:YES];
                }
                break;
            }
            case FlyEnd:
                [wBulletView removeFromSuperview];
                [_bulletViewsAry removeObject:wBulletView];
                if ([_bulletViewsAry count] == 0)//最后一个子弹消失
                {
                    //重置弹幕状态
                    [self reSetup];
                    if (_allBulletsFlyFinishBlk)
                    {
                        _allBulletsFlyFinishBlk();
                    }
                }
                break;
            default:
                break;
        }
    };
    [_barrageView addSubview:bulletView];
    [_bulletViewsAry addObject:bulletView];
    if (immediatelyFly)
    {
        [bulletView startFly];
    }
    return;
}

-(void)startPlay
{
    if (_isPlaying)
    {
        if (_isPaused)
        {
            [self resumePlay];
        }
        else
        {
            [self pausePlay];
        }
        return;
    }
    else
    {
        _isPlaying = YES;
        for (ZBulletView *bullet in _bulletViewsAry)
        {
            [bullet startFly];
        }
    }
}

-(void)stopPlay
{
    for (ZBulletView *bullet in _bulletViewsAry)
    {
        [bullet stopFly];
    }
    [self reSetup];
}

-(void)pausePlay
{
    for (ZBulletView *bullet in _bulletViewsAry)
    {
        [bullet pauseFly];
    }
    _isPaused = YES;
}

-(void)resumePlay
{
    for (ZBulletView *bullet in _bulletViewsAry)
    {
        [bullet resumeFly];
    }
    _isPaused = NO;
}

//重置弹幕状态
-(void)reSetup
{
    [_bulletViewsAry removeAllObjects];
    _useingComments = [NSMutableArray arrayWithArray:_comments];
    [self setupBullet];
    _isPlaying = NO;
    _isPaused = NO;
}

@end
