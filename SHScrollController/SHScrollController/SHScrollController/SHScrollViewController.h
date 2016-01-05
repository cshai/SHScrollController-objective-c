//
//  SHScrollViewController.h
//  SHScrollController
//
//  Created by Sam on 16/1/4.
//  Copyright © 2016年 Sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  SHScrollViewController;

@protocol SHScrollViewControllerDelegate <NSObject>

/**
 拖拽进度
 */
- (void)scrollViewControllerDraging:(SHScrollViewController *)scrollViewController progress:(CGFloat) progress;

/**
 当将索引改变代理方法
 */
- (void)scrollViewControllerCurrentTabIndexChanged:(SHScrollViewController *)scrollViewController index:(NSInteger) currentIndex;

/**
 右边按钮点击方法
 */
- (void)scrollViewControllerRigthButtonClicked:(SHScrollViewController *)scrollViewController button:(UIButton *)rigthButton;

@end


@interface SHScrollViewController : UIViewController

/**
 放置所有button的导航view
 */
@property (nonatomic,strong,readonly) UIScrollView *tabButtonScrollView;

/**
 button的宽度，高度固定等于buttonScrollView的高度
 */
@property (nonatomic,assign) CGFloat tabButtonWidth;

/**
 放置在buttonNavView的右边的顶部Button
 */
@property (nonatomic,strong) UIButton *rightButton;

/**
 当前tabbutton的字体大小,默认为nil
 */
@property (nonatomic,assign) CGFloat currentTabButtonTitleFontSize;

/**
 默认tabButton字体大小
 */
@property (nonatomic,assign) CGFloat tabButtonTitleFontSize;

/**
 放置视图控制器的scrollView
 */
@property (nonatomic,strong,readonly) UIScrollView *viewControllerScrollView;

/**
 当前tab索引
 */
@property (nonatomic,assign,readonly) NSInteger currentTabIndex;

/**
 事件通知代理
 */
@property (weak, nonatomic) id<SHScrollViewControllerDelegate> delegate;

/**
 tabButton的列表
 */
@property (nonatomic,strong,readonly)  NSArray<UIButton *> *tabButtons;

/**
 视图控制器列表
 */
@property (nonatomic,strong) NSArray<UIViewController *> *viewControllers;

/**
 用来添加tab
 */
- (void)addViewController:(UIViewController *) viewControler tabButton:(UIButton *) button;

/**
 移除tab
 */
- (void)removeViewController:(UIViewController *) viewControler;

@end
