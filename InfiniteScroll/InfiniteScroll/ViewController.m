//
//  ViewController.m
//  InfiniteScroll
//
//  Created by line on 15/3/21.
//  Copyright © 2015年 line. All rights reserved.
//

#import "ViewController.h"
#import "HLInfiniteScrollView.h"

@interface ViewController ()<HLInfiniteScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HLInfiniteScrollView *scrollView = [[HLInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    scrollView.images = @[
                          [UIImage imageNamed:@"image0"],
                          [UIImage imageNamed:@"image1"],
                          [UIImage imageNamed:@"image2"],
                          [UIImage imageNamed:@"image3"]
                          ];
    scrollView.direction = HLInfiniteScrollViewDirectionHorizontal;
    scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
}

- (void)infiniteScrollView:(HLInfiniteScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%s--%zd", __func__, index);
}


@end
