//
//  MainViewController.m
//  SlideStartUpTest
//
//  Created by lijinhai on 12/1/14.
//  Copyright (c) 2014 gaussli. All rights reserved.
//

#import "MainViewController.h"

#define JH_DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define JH_DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 获得滑动图是否出现过标识位，出现过就不再出现，没出现过证明应用第一次打开，同时打开滑动图
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![@"YES" isEqualToString:[userDefaults objectForKey:@"isShowScrollView"]]) {
        [self showScrollView];
    }
    else {
        NSLog(@"滑动图已经出现过，进行其他操作。");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 展示滑动图
/*!
 @brief 展示滑动图
 */
- (void) showScrollView {
    // 初始化scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 根据图片张数确定scrollView的大小位置，这里有5张图片，长度为屏幕宽度*5
    scrollView.contentSize = CGSizeMake(JH_DEVICE_WIDTH*5, JH_DEVICE_HEIGHT);
    scrollView.tag = 101;
    // 设置翻页效果，为一页一页翻
    scrollView.pagingEnabled = YES;
    // 设置不允许反弹
    scrollView.bounces = NO;
    // 设置不显示水平滑动条
    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理为自身
    scrollView.delegate = self;
    
    // 把图片加入到scrollView中
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm.png"]];
    imageView1.frame = CGRectMake(0, 0, JH_DEVICE_WIDTH, JH_DEVICE_HEIGHT);
    [scrollView addSubview:imageView1];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"didianku.png"]];
    imageView2.frame = CGRectMake(JH_DEVICE_WIDTH, 0, JH_DEVICE_WIDTH, JH_DEVICE_HEIGHT);
    [scrollView addSubview:imageView2];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gongzuoqiandao.png"]];
    imageView3.frame = CGRectMake(JH_DEVICE_WIDTH*2, 0, JH_DEVICE_WIDTH, JH_DEVICE_HEIGHT);
    [scrollView addSubview:imageView3];
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gongzuoqiandao.png"]];
    imageView4.frame = CGRectMake(JH_DEVICE_WIDTH*3, 0, JH_DEVICE_WIDTH, JH_DEVICE_HEIGHT);
    [scrollView addSubview:imageView4];
    UIImageView *imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suishidiaopei.png"]];
    imageView5.frame = CGRectMake(JH_DEVICE_WIDTH*4, 0, JH_DEVICE_WIDTH, JH_DEVICE_HEIGHT);
    [scrollView addSubview:imageView5];
    
    // 初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(140, JH_DEVICE_HEIGHT - 60, 50, 40)];
    pageControl.numberOfPages = 5;
    pageControl.tag = 201;
    
    [self.view addSubview:scrollView];
    [self.view addSubview:pageControl];
    
}

#pragma mark - UIScrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 获得当前位置，确定展示第几张图片
    int currentNum = scrollView.contentOffset.x / JH_DEVICE_WIDTH;
    // 设置pageControl当前值
    UIPageControl *tempPageControl = (UIPageControl*)[self.view viewWithTag:201];
    tempPageControl.currentPage = currentNum;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // 获得当前位置，确定展示第几张图片
    int currentNum = scrollView.contentOffset.x / JH_DEVICE_WIDTH;
    // 最后一张开始滑动的时候，进行图片消失动画
    if (currentNum == 4) {
        [self destroyScrollView];
    }
}

#pragma mark - 取消scrollView
- (void) destroyScrollView {
    // 获得scrollView和pageControl
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    
    // 设置滑动图消失的动画效果
    [UIView animateWithDuration:1.5f animations:^{
        scrollView.center = CGPointMake(-JH_DEVICE_WIDTH/2, JH_DEVICE_HEIGHT/2);
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
        [page removeFromSuperview];
    }];
    
    //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
}

@end
