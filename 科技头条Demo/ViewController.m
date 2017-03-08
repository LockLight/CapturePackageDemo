//
//  ViewController.m
//  科技头条Demo
//
//  Created by locklight on 17/3/8.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "ViewController.h"
#import "newsCell.h"
#import "YYModel.h"
#import "newsModel.h"

static NSString *newCell = @"newCell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger type;
}

@property (nonatomic, strong) NSMutableArray *modelList;
@property (nonatomic, strong) UIRefreshControl *refreshDown;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorUp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _modelList = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"newsCell" bundle:nil] forCellReuseIdentifier:newCell];
    
    //cell自适应
    _tableView.estimatedRowHeight = 200;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    //添加下拉刷新
    _refreshDown = [[UIRefreshControl alloc]init];
    [_refreshDown addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshDown];
    
    //添加上拉刷新
    _indicatorUp = [[UIActivityIndicatorView alloc]init];
    _tableView.tableFooterView = _indicatorUp;
    
    [self loadData];
}

//下拉刷新实现的方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == _modelList.count -1 ){
        type = 1;
        [_indicatorUp startAnimating];
        [self loadData];
    }
}

- (void)loadData{
    //初始化
    NSString *time = @"0";
    //1.判断上下拉刷新
    if(_refreshDown.refreshing == YES){
        type = 0;
        time = _modelList.count > 0 ? [_modelList.firstObject addtime]:@"0";
    }
    
    if(type == 1){
        time = _modelList.count > 0 ? [_modelList.lastObject addtime] :@"0";
    }
    
    //2.根据type,time拼接URL
    //创建URL
    NSString *urlString = [NSString stringWithFormat:@"http://news.coolban.com/Api/Index/news_list/app/2/cat/0/limit/20/time/%@/type/%zd",time,type];
    NSURL *url = [NSURL URLWithString:urlString];
    //创建request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //发起网络请求
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //异常获取
        if(error != nil){
            NSLog(@"error = %@",error);
            return;
        }
        //JSon反序列
        NSArray *newsDictArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        //字典数组转模型数组
        NSArray *newsModelArr = [NSArray yy_modelArrayWithClass:[newsModel class] json:newsDictArr];
        //NSLog(@"%@",newsModelArr);
//        NSMutableArray *responseMarr = [NSMutableArray arrayWithArray:newsModelArr];

    //3.数据源拼接
        //下拉刷新,直接赋值给数据源
        if(type == 0){
            _modelList = newsModelArr.mutableCopy;
        }else{ //上拉刷新,添加到数据源数组后
            [_modelList addObjectsFromArray:newsModelArr.mutableCopy];
        }
        
        
        //刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if(type == 0){
                [_refreshDown endRefreshing];
            }else{
                [_indicatorUp stopAnimating];
                type = 0;
            }
            
            [self.tableView reloadData];
        });
    }] resume];
    
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}


- (newsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    newsCell *cell = [tableView dequeueReusableCellWithIdentifier:newCell forIndexPath:indexPath];
    
//    // 设置 Cell...
//    cell.textLabel.text = indexPath.description;
    newsModel *model = _modelList[indexPath.row];
    cell.model = model;

    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
