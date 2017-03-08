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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *modelList;

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
    
    [self loadData];
}


- (void)loadData{
    //创建URL
    NSURL *url = [NSURL URLWithString:@"http://news.coolban.com/Api/Index/news_list/app/2/cat/0/limit/20/time/0/type/0"];
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
        
        NSLog(@"%@",newsModelArr);
        
        [_modelList addObjectsFromArray:newsModelArr];
        
        
        //刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
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
