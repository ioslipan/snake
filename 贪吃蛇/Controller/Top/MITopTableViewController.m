//
//  MITopTableViewController.m
//  贪吃蛇
//
//  Created by mickey on 16/8/4.
//  Copyright © 2016年 mickey. All rights reserved.
//

#import "MITopTableViewController.h"
#import "MIPlayer.h"
#define FILE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"tops.archive"]
@interface MITopTableViewController ()
@property (nonatomic, strong) NSMutableArray *playerArr;
@end

@implementation MITopTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.playerArr = [NSKeyedUnarchiver unarchiveObjectWithFile:FILE_PATH];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.playerArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"top" forIndexPath:indexPath];
  if (!cell) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"top"];
  }
  
  MIPlayer *curPly = self.playerArr[indexPath.row];
  cell.textLabel.text = curPly.name;
  cell.detailTextLabel.text = curPly.score;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self.navigationController popViewControllerAnimated:YES];
  
}

- (void)viewWillAppear:(BOOL)animated{
  [self.tableView reloadData];
  [NSKeyedArchiver archiveRootObject:self.playerArr toFile:FILE_PATH];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)playerArr{
  if (!_playerArr) {
    _playerArr = [NSMutableArray array];
  }
  return _playerArr;
}

@end
