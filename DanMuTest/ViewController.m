//
//  ViewController.m
//  ZBarrage
//
//  Created by zc09v on 16/11/28.
//  Copyright © 2016年 zc09v. All rights reserved.
//

#import "ViewController.h"
#import "ZBarrage.h"

@interface ViewController ()
{
    ZBarrage *_barrage;
    UIButton *_startFlyBut;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *comments = [NSMutableArray arrayWithObjects:@"评论1~~~!!!!!!",@"评论2~~~!!",@"评论3~~~!!!!!!!!!!!!!!!!!!!!",@"评论4~~~",@"评论5~~~!!!",@"评论6~~~!!!!!!!!",@"评论7~~~!!!",@"评论8~~~!!!",@"评论9~~~!!!",@"评论10~~~!!!",@"评论11~~~!!!",@"评论12~~~!!!",@"评论13~~~!!!",@"评论14~~~!!!",@"评论15~~~!!!",@"评论16~~~!!!", nil];
    
    _startFlyBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [_startFlyBut setTitle:@"Start" forState:UIControlStateNormal];
    [_startFlyBut setTitle:@"Pause" forState:UIControlStateSelected];
    _startFlyBut.frame = CGRectMake(0, 20, 100, 30);
    [_startFlyBut addTarget:self action:@selector(startFlyButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startFlyBut];
    
    UIButton *stopFlyBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [stopFlyBut setTitle:@"Stop" forState:UIControlStateNormal];
    stopFlyBut.frame = CGRectMake(120, 20, 100, 30);
    [stopFlyBut addTarget:self action:@selector(stopFlyButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopFlyBut];
    
    //初始化弹幕类
    _barrage = [[ZBarrage alloc] initWithComments:comments];
    __weak typeof(UIButton) *wBut = _startFlyBut;
    _barrage.allBulletsFlyFinishBlk = ^void()
    {
        wBut.selected = NO;
    };
    
    //生成弹幕view
    UIView *barrageView = [_barrage generateBarrageView:CGRectMake(0, _startFlyBut.frame.origin.y + _startFlyBut.frame.size.height, self.view.frame.size.width - 50, 100) trackNum:3 flyDuration:5];
    //添加弹幕view到视图
    [self.view addSubview:barrageView];
}

//播放、暂停弹幕
-(void)startFlyButClick
{
    //第一次点击是播放，再次点击变为暂停，再次点击变回播放，以此类推
    //播放完成后再次点击，重新再次播放
    [_barrage startPlay];
    if (_barrage.isPaused)//判断当前弹幕是否处于暂停状态
    {
        _startFlyBut.selected = NO;
    }
    else
    {
        _startFlyBut.selected = YES;
    }
}

//停止播放弹幕
-(void)stopFlyButClick
{
    _startFlyBut.selected = NO;
    [_barrage stopPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
