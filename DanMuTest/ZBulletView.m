//
//  ZBulletView.m
//  ZBarrage
//
//  Created by zc09v on 16/11/28.
//  Copyright © 2016年 zc09v. All rights reserved.
//

#import "ZBulletView.h"

#define FontSize 12
#define Padding 10

@interface ZBulletView ()
{
    //子弹内容
    NSString *_comment;
    UILabel *_commentLab;
    //子弹飞行时长
    CGFloat _duration;
    //完全飞入屏幕所走长度
    CGFloat _appearedWidth;
    //弹幕长度
    CGFloat _barrageWidth;
}

@end


@implementation ZBulletView

-(void)dealloc
{
    _flyStatusBlk = nil;
}

-(instancetype)initWithFrame:(CGRect)frame comment:(NSString *)comment flyDuration:(CGFloat)duration trackNum:(int)trackNum
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _duration = duration;
        //子弹初始位置在弹幕边缘，起始x即为弹幕长度
        _barrageWidth = frame.origin.x;
        _comment = [comment copy];
        _trackNum = trackNum;
        
        NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]};
        //子弹内容本身长度
        CGFloat width = [_comment sizeWithAttributes:attrDict].width;
        CGRect realFrame = frame;
        //起始点前加个间距
        realFrame.origin.x = Padding + frame.origin.x;
        realFrame.size.width = width;
        //完全飞入屏幕所走长度 = 子弹自身长度 ＋ 间距
        _appearedWidth = Padding + width;
        self.frame = realFrame;
        
        _commentLab = [[UILabel alloc] initWithFrame:self.bounds];
        _commentLab.font = [UIFont systemFontOfSize:FontSize];
        _commentLab.textAlignment = NSTextAlignmentLeft;
        _commentLab.text = _comment;
        [self addSubview:_commentLab];
        
    }
    return self;
}

-(void)startFly
{
    __block CGRect originalFrame = self.frame;
    //子弹走过的实际距离 = 完全飞入屏幕距离 + 弹幕宽度
    CGFloat realDistance = _appearedWidth + _barrageWidth;
    //飞行速度
    CGFloat speed = realDistance/_duration;
    //正好完全飞入屏幕用时
    CGFloat duration1 = _appearedWidth / speed;
    //从完全进入屏幕后，至完全飞出时长
    CGFloat duration2 = _duration - duration1;
    
    [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        originalFrame.origin.x = originalFrame.origin.x - _appearedWidth;
        self.frame = originalFrame;
        if (_flyStatusBlk)
        {
            _flyStatusBlk(FlyStart);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            originalFrame.origin.x = originalFrame.origin.x - _barrageWidth;
            self.frame = originalFrame;
        } completion:^(BOOL finished) {
            if (_flyStatusBlk)
            {
                _flyStatusBlk(FlyEnd);
            }
        }];
        //告知正好完全飞入屏幕时机
        if (_flyStatusBlk)
        {
            _flyStatusBlk(FlyAppeared);
        }
    }];
}


-(void)stopFly
{
    _flyStatusBlk = nil;
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

-(void)pauseFly
{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

-(void)resumeFly
{
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

