//
//  MainViewController.m
//  Demo
//
//  Created by Apple on 2018/9/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * leftTableView;
@property (nonatomic,strong) UITableView * centerTableView;
@property (nonatomic,strong) NSArray <NSArray <NSString*>*>* dataArr;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self setUPData];
    [self setUpUI];
  
    
    // Do any additional setup after loading the view.
}
-(void)setUPData{
    NSMutableArray * dataArr = @[].mutableCopy;
    for (int i = 0; i < 10; i++) {
        NSMutableArray * subArr = @[].mutableCopy;
        for (int j = 0; j < 10; j++) {
            NSString * str = [NSString stringWithFormat:@"第%d区-%d行",i,j];
            [subArr addObject:str];
        }
        [dataArr addObject:subArr];
    }
    self.dataArr = [dataArr copy];
}
-(void)setUpUI{
    self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, self.view.frame.size.height)];
    self.centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(80, 0, self.view.bounds.size.width - 80, self.view.frame.size.height)];
    self.leftTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.centerTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.centerTableView];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.centerTableView.delegate = self;
    self.centerTableView.dataSource = self;
    self.leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
#pragma mark - UITableViewDelegate&UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        return 1;
    }else{
        return self.dataArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.dataArr.count;
    }else{
        return self.dataArr[section].count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.centerTableView) {
        return 30;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.centerTableView) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width - 20, 30)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"第%ld区",section];
        return label;
    }else{
        return nil;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (tableView == self.leftTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld区",indexPath.row];
    }else{
        cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [self.centerTableView selectRowAtIndexPath:moveToIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // 如果是 左侧的 tableView 直接return
    if (scrollView == self.leftTableView){
         return;
    }
    /**如果不是主动滑动的直接return*/
    BOOL isUserTouch = scrollView.dragging || scrollView.tracking || scrollView.decelerating;
    if (!isUserTouch) {
        return;
    }
    // 取出显示在 视图 且最靠上 的 cell 的 indexPath
    NSIndexPath *topCellIndexpath = [[self.centerTableView indexPathsForVisibleRows] firstObject];

    // 左侧 talbelView 移动到的位置 indexPath
    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topCellIndexpath.section inSection:0];

    // 移动 左侧 tableView 到 指定 indexPath 居中显示
    [self.leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}


@end
