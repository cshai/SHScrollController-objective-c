//
//  SHTestMainViewController.m
//  SHScrollController
//
//  Created by Sam on 16/1/4.
//  Copyright © 2016年 Sam. All rights reserved.
//

#import "SHTestMainViewController.h"

#import "SHScrollViewController.h"

#define SHRandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0]

@interface SHTestMainViewController () <SHScrollViewControllerDelegate>

@property (nonatomic,strong)  SHScrollViewController *scrollViewContoller;
@end

@implementation SHTestMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化对象
    self.scrollViewContoller = [[SHScrollViewController alloc] init];
    self.scrollViewContoller.delegate = self;
    [self.view addSubview:self.scrollViewContoller.view];
    [self addChildViewController:self.scrollViewContoller];
    
    //添加测试的tab
    for (int i = 0; i < 10; i++) {
        UIViewController *oneVc = [[UIViewController alloc] init];
        
        oneVc.view.backgroundColor = SHRandomColor;
        
        UIButton *oneBut = [[UIButton alloc] init];
        
        [oneBut setTitle:[NSString stringWithFormat:@"按钮%zd",i] forState:UIControlStateNormal];
        
        [self.scrollViewContoller addViewController:oneVc tabButton:oneBut];

    }
    //添加右边添加按钮
    UIButton *addButton = [[UIButton alloc] init];
    addButton.frame = CGRectMake(0.0, 0.0, 50, 40);
    addButton.backgroundColor = [UIColor redColor];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    self.scrollViewContoller.rightButton = addButton;
    
    //设置字体大小，
    self.scrollViewContoller.tabButtonTitleFontSize = 13.0;
    self.scrollViewContoller.currentTabButtonTitleFontSize = 18.0;
    
}

- (void)scrollViewControllerCurrentTabIndexChanged:(SHScrollViewController *)scrollViewController index:(NSInteger)currentIndex
{

}

- (void)scrollViewControllerDraging:(SHScrollViewController *)scrollViewController progress:(CGFloat)progress
{
    
}

- (void)scrollViewControllerRigthButtonClicked:(SHScrollViewController *)scrollViewController button:(UIButton *)rigthButton
{
    NSLog(@"右边button被点击！");
}

@end
