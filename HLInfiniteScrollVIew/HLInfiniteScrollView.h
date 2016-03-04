//
//  HLInfiniteScrollVIew.h
//  无限滚动
//
//  Created by line on 15/3/21.
//  Copyright © 2015年 line. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLInfiniteScrollView;

@protocol HLInfiniteScrollViewDelegate <NSObject>

- (void)infiniteScrollView:(HLInfiniteScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, HLInfiniteScrollViewDirection){
    /**
     Horizontal scrolling
     */
    HLInfiniteScrollViewDirectionHorizontal = 0,
    /**
     Vertical scrolling
     */
    HLInfiniteScrollViewDirectionVertical
};


@interface HLInfiniteScrollView : UIView

/**
 *  image array
 */
@property (nonatomic, strong) NSArray *images;
/**
 *  imageUrls array
 */
//@property (nonatomic, strong) NSArray *imageUrls;

/**
 *  scrolling direction
 */
@property (nonatomic, assign) HLInfiniteScrollViewDirection direction;

/**
 *  UIPageControl - readonly
 */
@property (nonatomic, weak, readonly) UIPageControl *pageControl;

/**
 *  HLInfiniteScrollViewDelegate
 */
@property (nonatomic, weak) id<HLInfiniteScrollViewDelegate> delegate;

@end
