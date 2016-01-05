//
//  SHScrollViewController.m
//  SHScrollController
//
//  Created by Sam on 16/1/4.
//  Copyright © 2016年 Sam. All rights reserved.
//

#import "SHScrollViewController.h"
#define kTagStartVal                    (7500000)


@interface SHScrollViewController () <UIScrollViewDelegate>
{
    NSInteger _nextTagVal;
}

@property (nonatomic,assign,readonly) NSInteger nextTagVal;

@end

@implementation SHScrollViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        _nextTagVal = kTagStartVal;
        _tabButtonWidth = 60.0;
        _tabButtonTitleFontSize = 12.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

- (NSInteger)nextTagVal
{
    return _nextTagVal++;
}

//初始化UI
- (void)setupUI
{
    _tabButtonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 54.0)];
    _tabButtonScrollView.showsHorizontalScrollIndicator = NO;
    _tabButtonScrollView.showsVerticalScrollIndicator = NO;
    
    _viewControllerScrollView = [[UIScrollView alloc] init];
    _viewControllerScrollView.bounces = NO;
    _viewControllerScrollView.pagingEnabled = YES;
    _viewControllerScrollView.showsHorizontalScrollIndicator = NO;
    _viewControllerScrollView.showsVerticalScrollIndicator = NO;
    _viewControllerScrollView.delegate = self;
    
    
    _tabButtonScrollView.backgroundColor = [UIColor redColor];
    
    _viewControllerScrollView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:_tabButtonScrollView];
    [self.view addSubview:_viewControllerScrollView];
    
    
}

- (void)addViewController:(UIViewController *) viewControler tabButton:(UIButton *) button
{
    if (!button || !viewControler)
        return;
    
    button.tag = self.nextTagVal;
    viewControler.view.tag = button.tag;
    [self.tabButtonScrollView addSubview:button];
    [self.viewControllerScrollView addSubview:viewControler.view];
    [self addChildViewController:viewControler];
    
    //添加点击事件
    [button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)removeViewController:(UIViewController *) viewControler
{
    if (!viewControler) return;
    NSInteger tag = viewControler.view.tag;
    UIButton *button = [self.tabButtonScrollView viewWithTag:tag];
    [button removeTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button removeFromSuperview];
    [[self.viewControllerScrollView viewWithTag:tag] removeFromSuperview];
    [self addChildViewController:viewControler];
}

- (void)tabButtonClicked:(UIButton *)button
{
    NSInteger index;
    for (index = 0; index < self.tabButtons.count; index++) {
        if (self.tabButtons[index] == button) {
            break;
        }
    }
    if (index == self.currentTabIndex)
        return;
    
    self.currentTabIndex = index;
}

- (void)rigthButtonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(scrollViewControllerRigthButtonClicked:button:)]) {
        [self.delegate scrollViewControllerRigthButtonClicked:self button:button];
    }
}

- (void)setRightButton:(UIButton *)rightButton
{
    [_rightButton addTarget:self action:@selector(rigthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton removeFromSuperview];
    
    _rightButton = rightButton;
    
    [rightButton addTarget:self action:@selector(rigthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //布局button的位置
    for (int i = 0; i < self.tabButtons.count; i++)
    {
        self.tabButtons[i].frame = CGRectMake(i * self.tabButtonWidth, 0.0, self.tabButtonWidth, self.tabButtonScrollView.frame.size.height);
        self.tabButtons[i].titleLabel.font = [self.tabButtons[i].titleLabel.font fontWithSize:i == self.currentTabIndex? self.currentTabButtonTitleFontSize : self.tabButtonTitleFontSize];
    }
    
    self.tabButtonScrollView.contentSize = CGSizeMake(self.tabButtonScrollView.subviews.count * self.tabButtonWidth,self.tabButtonScrollView.frame.size.height);
    
    //布局contentVc的位置
    for (int i = 0; i < self.viewControllers.count; i++)
    {
        self.viewControllers[i].view.frame = CGRectMake(i * self.viewControllerScrollView.frame.size.width, 0.0, self.viewControllerScrollView.frame.size.width, self.viewControllerScrollView.frame.size.height);
    }
    
    self.viewControllerScrollView.contentSize = CGSizeMake(self.viewControllers.count * self.viewControllerScrollView.frame.size.width, self.viewControllerScrollView.frame.size.height);
    
    //布局右边按钮
    if (self.rightButton) {
        self.tabButtonScrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.rightButton.frame.size.width);
        self.rightButton.frame = CGRectMake(CGRectGetMaxX(self.tabButtonScrollView.frame) - self.rightButton.frame.size.width, self.tabButtonScrollView.frame.origin.y, self.rightButton.frame.size.width, self.tabButtonScrollView.frame.size.height);
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabButtonScrollView.frame = CGRectMake(self.tabButtonScrollView.frame.origin.x,self.tabButtonScrollView.frame.origin.y, self.view.frame.size.width, self.tabButtonScrollView.frame.size.height);
    
    self.viewControllerScrollView.frame = CGRectMake(self.viewControllerScrollView.frame.origin.x, CGRectGetMaxY(self.tabButtonScrollView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.tabButtonScrollView.frame));
    
}

#pragma mark - 实现UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    NSInteger oneIndex = progress;
    NSInteger twoIndex = oneIndex + 1;
    self.tabButtons[oneIndex].titleLabel.font = [UIFont systemFontOfSize:(self.tabButtonTitleFontSize + (self.currentTabButtonTitleFontSize - self.tabButtonTitleFontSize) *(1 - progress + oneIndex))];
    if (twoIndex < self.tabButtons.count) {
        self.tabButtons[twoIndex].titleLabel.font = [UIFont systemFontOfSize:(self.tabButtonTitleFontSize + (self.currentTabButtonTitleFontSize - self.tabButtonTitleFontSize) *(progress - oneIndex))];
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollViewControllerDraging:progress:)]) {
        [self.delegate scrollViewControllerDraging:self progress:progress];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentTabIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if ([self.delegate respondsToSelector:@selector(scrollViewControllerCurrentTabIndexChanged:index:)]) {
        [self.delegate scrollViewControllerCurrentTabIndexChanged:self index:self.currentTabIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.currentTabIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        if ([self.delegate respondsToSelector:@selector(scrollViewControllerCurrentTabIndexChanged:index:)]) {
            [self.delegate scrollViewControllerCurrentTabIndexChanged:self index:self.currentTabIndex];
        }
    }
}

- (void)setCurrentTabIndex:(NSInteger)currentTabIndex
{
    NSInteger needShowOffset = currentTabIndex * self.tabButtonWidth;
    //需要调整大小
    CGFloat offset = needShowOffset - self.tabButtonScrollView.frame.size.width / 2.0 + self.tabButtonWidth / 2.0;
    if (self.rightButton) {
        offset = MIN(self.tabButtons.count * self.tabButtonWidth - self.tabButtonScrollView.frame.size.width + self.rightButton.frame.size.width, offset);
    }else{
        offset = MIN(self.tabButtons.count * self.tabButtonWidth - self.tabButtonScrollView.frame.size.width, offset);
    }
    offset = MAX(offset, 0.0);

    self.tabButtons[_currentTabIndex].titleLabel.font = [self.tabButtons[_currentTabIndex].titleLabel.font fontWithSize:self.tabButtonTitleFontSize];
    _currentTabIndex = currentTabIndex;
    self.tabButtons[_currentTabIndex].titleLabel.font = [self.tabButtons[_currentTabIndex].titleLabel.font fontWithSize:self.currentTabButtonTitleFontSize];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.tabButtonScrollView.contentOffset = CGPointMake(offset, 0.0);
    }];
    self.viewControllerScrollView.contentOffset = CGPointMake(currentTabIndex * self.viewControllerScrollView.frame.size.width,0.0);

}

- (CGFloat)currentTabButtonTitleFontSize
{
    if (_currentTabButtonTitleFontSize <= 0.0) {
        return _tabButtonTitleFontSize;
    }
    return _currentTabButtonTitleFontSize;
}

- (NSArray<UIButton *> *)tabButtons
{
    return [self.tabButtonScrollView subviews];
}

- (NSArray<UIViewController *> *)viewControllers
{
    return [self childViewControllers];
}

@end
