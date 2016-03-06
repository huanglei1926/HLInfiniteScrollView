//
//  HLInfiniteScrollVIew.m
//  无限滚动
//
//  Created by line on 15/3/21.
//  Copyright © 2015年 line. All rights reserved.
//

#import "HLInfiniteScrollView.h"

//需要导入SDWebImage框架
#import <UIImageView+WebCache.h>
//#import <objc/runtime.h>

@interface HLInfiniteScrollView ()<UIScrollViewDelegate>
/**
 *  UIPageControl
 */
@property (nonatomic, weak) UIPageControl *pageControl;
/**
 *  UIScrollView
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  NSTimer
 */
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation HLInfiniteScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        // 开启分页
        scrollView.pagingEnabled = YES;
        // 取消滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        // 取消弹簧效果
        scrollView.bounces = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        for (NSInteger i = 0; i < 3; i++) {
            //创建imageview并添加点击手势
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVIewClick:)]];
            [scrollView addSubview:imageView];
        }
        //添加分页控制器
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        //自定义pageControl图片
//        [pageControl setValue:[UIImage imageNamed:@"InfiniteScrollView.bundle/other"] forKeyPath:@"_pageImage"];
//        [pageControl setValue:[UIImage imageNamed:@"InfiniteScrollView.bundle/current"] forKeyPath:@"_currentPageImage"];
        
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        [self startTimer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat scrollViewW = self.bounds.size.width;
    CGFloat scrollViewH = self.bounds.size.height;
    
    self.scrollView.frame = self.bounds;
    
    if (self.direction == HLInfiniteScrollViewDirectionHorizontal) {
        self.scrollView.contentSize = CGSizeMake(3 * scrollViewW, 0);
    }else{
        self.scrollView.contentSize = CGSizeMake(0, 3 * scrollViewH);
    }
    
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        if (self.direction == HLInfiniteScrollViewDirectionHorizontal) {
            imageView.frame = CGRectMake( i * scrollViewW, 0, scrollViewW, scrollViewH);
        }else{
            imageView.frame = CGRectMake( 0, i * scrollViewH, scrollViewW, scrollViewH);
        }
    }
    
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 30;
    self.pageControl.frame = CGRectMake(scrollViewW - pageControlW, scrollViewH - pageControlH, pageControlW, pageControlH);
    [self updateContent];

}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    self.pageControl.numberOfPages = imageUrls.count;
}

//- (void)setImageUrls:(NSArray *)imageUrls
//{
//    _imageUrls = imageUrls;
//
//    // 总页数
//    self.pageControl.numberOfPages = imageUrls.count;
//}

- (void)updateContent
{
    //获取当前页码
    NSInteger currentPage = self.pageControl.currentPage;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        NSInteger index = 0;
        if (i == 0) {
            index = currentPage - 1;
        }else if (i == 1){
            index = currentPage;
        }else {
            index = currentPage + 1;
        }
        
        //处理特殊情况
        if (index == -1) {
            index = self.imageUrls.count - 1;
//            index = 4;
        }else if (index == self.imageUrls.count){
            index = 0;
        }
        if (self.imageUrls.count) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[index]]];
        }

        imageView.tag = index;
//        NSLog(@"%zd", index);
    }
    if (self.direction == HLInfiniteScrollViewDirectionHorizontal) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }else{
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
    
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage
{
    if (self.direction == HLInfiniteScrollViewDirectionHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + self.scrollView.frame.size.height) animated:YES];
    }
}

- (void)imageVIewClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectItemAtIndex:)]) {
        [self.delegate infiniteScrollView:self didSelectItemAtIndex:tap.view.tag];
    }
}
//scrollView滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIImageView *destImageView = nil;
    CGFloat minDistance = MAXFLOAT;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        if (self.direction == HLInfiniteScrollViewDirectionHorizontal) {
            distance = ABS(scrollView.contentOffset.x - imageView.frame.origin.x);
        }else{
            distance = ABS(scrollView.contentOffset.y - imageView.frame.origin.y);
        }
        if (distance < minDistance) {
            minDistance = distance;
            destImageView = imageView;
        }
    }
    
    self.pageControl.currentPage = destImageView.tag;
    
    
}
//当手动滚动图片时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

//系统滚动动画结束时调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateContent];
}
//手动滚动停止时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimer];
    [self updateContent];
}


@end
