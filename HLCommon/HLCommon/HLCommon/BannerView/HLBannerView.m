//
//  HLBannerView.m
//  tokenlender
//
//  Created by Harlan on 2018/7/30.
//  Copyright © 2018年 xiaoxinyong. All rights reserved.
//
#define kCount 100
#import "HLBannerView.h"
#import "BannerViewCell.h"

static NSString *cellID = @"cell";

@interface HLBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,weak) UIPageControl *pageControl;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation HLBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma 初始化UI界面
- (void)setupUI
{
    [self collectionView];
    [self pageControl];
    [self timer];
}

#pragma mark 获取图片URL数组
- (void)setImgUrls:(NSArray *)imgUrls
{
    _imgUrls = imgUrls;
    self.pageControl.numberOfPages = imgUrls.count;
    [self.collectionView reloadData];
    
    //滚动到中间位置
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:imgUrls.count * kCount inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark 开始拖拽时,停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    // 当拖拽的时候 设置下次触发的时间 为 4001年!!!
    self.timer.fireDate = [NSDate distantFuture];
}

#pragma mark 结束拖拽时,恢复定时器
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}

#pragma mark 更新定时器 获取当前位置,滚动到下一位置
- (void)updateTimer
{
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].lastObject;
    NSIndexPath *nextPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
    [self.collectionView scrollToItemAtIndexPath:nextPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark 滚动动画结束的时候调用 - 获取当前页码,滚动到下一页,如果当前页码是第一页,继续往下滚动,如果是最后一页回到第一页
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:self.collectionView];
}

#pragma mark 正在滚动(设置分页) -- 算出滚动位置,更新指示器
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat page = offsetX/self.bounds.size.width + 0.5;
    page = (NSInteger)page % self.imgUrls.count;
    self.pageControl.currentPage = page;
}

#pragma mark 监听手动减速完成(停止滚动)  - 获取当前页码,滚动到下一页,如果当前页码是第一页,继续往下滚动,如果是最后一页回到第一页
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / self.bounds.size.width;
    
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    if (page == 0) { // 第一页
        self.collectionView.contentOffset = CGPointMake(offsetX + self.imgUrls.count * kCount * self.bounds.size.width, 0);
    } else if (page == itemsCount - 1) { // 最后一页
        self.collectionView.contentOffset = CGPointMake(offsetX - self.imgUrls.count * kCount * self.bounds.size.width, 0);
    }
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgUrls.count*2*kCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imgUrl = self.imgUrls[indexPath.item%self.imgUrls.count];
    cell.LoadImageBlock = self.LoadImageBlock;
    return cell;
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectedItemAtIndex:)])
    {
        [self.delegate bannerView:self didSelectedItemAtIndex:indexPath.item % self.imgUrls.count];
    }
}

#pragma mark 随父控件的消失取消定时器
- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.timer invalidate];
}

#pragma lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.bounces = NO;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        
        [self addSubview:collectionView];
        self.collectionView = collectionView;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        CGFloat width = 120;
        CGFloat height = 20;
        CGFloat pointX = ([UIScreen mainScreen].bounds.size.width - width) / 2;
        CGFloat pointY = self.bounds.size.height - height;
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(pointX, pointY, width, height)];
        pageControl.numberOfPages = self.imgUrls.count;
        pageControl.userInteractionEnabled = NO;
        pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return _pageControl;
}

- (NSTimer *)timer
{
    if (!_timer) {
        //MARK: 设置定时器
        NSTimer* timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    return _timer;
}

@end
