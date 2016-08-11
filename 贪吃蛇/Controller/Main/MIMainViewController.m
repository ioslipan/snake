//
//  MIMainViewController.m
//  贪吃蛇
//
//  Created by mickey on 16/8/4.
//  Copyright © 2016年 mickey. All rights reserved.
//

#import "MIMainViewController.h"
#define snakeSize 15
//值必须是375和525的公倍数:5\15\25\75

@interface MIMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *playGround;
@property (weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UIButton *btnDown;
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UIButton *btnL;
@property (weak, nonatomic) IBOutlet UIButton *btnR;
@property (weak, nonatomic) IBOutlet UIView *butonView;

@property (nonatomic, strong) NSTimer *mainTimer;

@property (nonatomic, strong) NSMutableArray *snakeBlocks;
@property (weak, nonatomic) UIImageView *snake;
@property (nonatomic, strong) UIImageView *food;
@property (nonatomic ,strong)UIImage * headerimage;
@property (nonatomic,strong)UIImage * bodyImage;
@property (nonatomic ,strong)UIImage * tailImage;
@property (assign, nonatomic) NSInteger lastBtnTag;

@end

@implementation MIMainViewController

- (BOOL)prefersStatusBarHidden{
  return YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.headerimage                      = [UIImage new];
  self.bodyImage                        = [UIImage new];
  self.bodyImage  =[UIImage imageNamed:@"snakeBody"];
  self.tailImage                        = [UIImage new];
  self.tailImage =[UIImage imageNamed:@"snakeTail"];
  self.fd_prefersNavigationBarHidden    = YES;

  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];


  self.playGround.layer.borderColor     = [UIColor colorWithRed:1.0 green:0.4295 blue:0.1722 alpha:1.0].CGColor;
  self.playGround.layer.borderWidth =.5;
  //初始化
  self.points.text                      = @"0";
  self.mainTimer                        = [[NSTimer alloc]init];
  //生成一个食物
  [self showFood];
  self.lastBtnTag                       = -100;
  [self btnClick:self.btnDown];
}

//移动！！！！
- (void)move:(CGFloat)x and:(CGFloat)y{
  //如果前面是食物，吃！
  [self eatFoodWith:x and:y];
  //如果碰到边缘或者自己, 停止游戏，提示失败
  if ([self judgeFallWithX:x andY:y]) {
    //执行失败后步骤
    [self fallAlert];
    return;
  }

  //拿到头和尾
  UIImageView *tail                     = self.snakeBlocks.lastObject;
  UIImageView *head                     = self.snakeBlocks.firstObject;
  //头的下一个位置center
  CGFloat headX                         = head.center.x + x;
  CGFloat headY                         = head.center.y + y;

  //将尾移动到头前面
  tail.center                           = CGPointMake(headX, headY);
  //将数组中的最后一个元素移动到第一个位置
  [self.snakeBlocks insertObject:tail atIndex:0];
  //删除最后一个元素
  [self.snakeBlocks removeLastObject];
  for (int i                            = 0 ; i <self.snakeBlocks.count; i++) {
  UIImageView * view                    = [self.snakeBlocks objectAtIndex:i];

    if (i==0) {
      view.backgroundColor               =[UIColor clearColor];
      [view setImage:self.headerimage];
    }
    else
 [view setImage:self.bodyImage];

  }

  //尾巴
//  else if (i == self.snakeBlocks.count-1){
//    //      [view setImage:self.tailImage];
//    if (view.center.x == head.center.x || view.center.y == head.center.y) {
//      if (self.headerimage .imageOrientation == UIImageOrientationLeft) {
//        self.tailImage = [ MIMainViewController image:self.tailImage rotation:UIImageOrientationLeft];
//      }else if (self.headerimage.imageOrientation == UIImageOrientationRight){
//        self.tailImage = [ MIMainViewController image:self.tailImage rotation:UIImageOrientationRight];
//      }
//    }
//    //      [view setImage:self.tailImage];
//
//  }
//

}

//弹出是否重新开始提示框
- (void)fallAlert{
  //1.弹出alertView提示失败，是否重新开始
  UIAlertController *alert              = [UIAlertController alertControllerWithTitle:@"游戏结束" message:@"是否重新开始？" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancel                 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    [self pauseClick];
  }];
  UIAlertAction *confirm                = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self.playGround.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  self.snakeBlocks                      = nil;
    [self.mainTimer invalidate];
    [self viewDidLoad];
  }];
  [alert addAction:cancel];
  [alert addAction:confirm];
  [self presentViewController:alert animated:YES completion:nil];
}

//判断是否输了
- (BOOL)judgeFallWithX:(CGFloat)x andY:(CGFloat)y{
  //拿到当前的头的下一步坐标
  CGFloat nextX                         = [self.snakeBlocks.firstObject frame].origin.x + x;
  CGFloat nextY                         = [self.snakeBlocks.firstObject frame].origin.y + y;

  //判断是否超过playground边缘
  if (nextX >= self.playGround.frame.size.width || nextX < 0 || nextY >= self.playGround.frame.size.height || nextY < 0) {
    [self.mainTimer invalidate];
    [self writDataInPlistweithLevel:self.level adnScore:self.points.text  ];
    return YES;
  }
  //判断是否碰到蛇身
  for (UIImageView *snake in self.snakeBlocks) {
    if (nextX == snake.frame.origin.x && nextY == snake.frame.origin.y) {
      [self.mainTimer invalidate];
       [self writDataInPlistweithLevel:self.level adnScore:self.points.text  ];
      return YES;
    }
  }
  return NO;
}

//吃！
- (void)eatFoodWith:(CGFloat)x and:(CGFloat)y{
  //拿到头和食物
  UIImageView *head                     = self.snakeBlocks.firstObject;
  UIImageView *food                     = self.food;

  //头的下一个位置
  CGFloat nextX                         = head.frame.origin.x + x;
  CGFloat nextY                         = head.frame.origin.y + y;
  //拿到食物的x,y
  CGFloat foodX                         = food.frame.origin.x;
  CGFloat foodY                         = food.frame.origin.y;

  //判断食物和头的下一个位置是否相等
  if (nextX == foodX && nextY == foodY) {
    //将食物添加到蛇身数组的第一个位置
    [self.snakeBlocks insertObject:food atIndex:0];
  for (int i                            = 0 ; i <self.snakeBlocks.count; i++) {
  UIImageView * view                    = [self.snakeBlocks objectAtIndex:i];
view.backgroundColor               =[UIColor clearColor];
      if (i==0) {

          [view setImage:self.headerimage];
      }else
    [view setImage:self.bodyImage];

    }

    //生成新的食物
    [self showFood];
    //分数加10
  NSInteger point                       = self.points.text.intValue + 10;
  self.points.text                      = [NSString stringWithFormat:@"%ld",point];
  }
}

//生成食物
- (void)showFood{
  /*
   思路：在playGround的范围内随机产生x和y的值：（bug待解决：防止食物出现在蛇身的位置上）
   */
  //生成x坐标
  NSInteger x                           = arc4random_uniform(self.playGround.bounds.size.width - snakeSize - 1);
  while (x % snakeSize) {
  x                                     = arc4random_uniform(self.playGround.bounds.size.width - snakeSize - 1);
  }
  //生成y坐标
  NSInteger y                           = arc4random_uniform(self.playGround.bounds.size.height - snakeSize - 1);
  while (y % snakeSize) {
  y                                     = arc4random_uniform(self.playGround.bounds.size.height - snakeSize - 1);
  }

  //判断食物的位置是否在蛇身上
  [self.snakeBlocks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if (x == [obj frame].origin.x && y == [obj frame].origin.y) {
      *stop                                 = YES;
      [self showFood];
    }
  }];

  CGFloat h                             = snakeSize;
  CGFloat w                             = h;
  self.food                             = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
  self.food.backgroundColor             = [UIColor colorWithRed:0.9113 green:0.1397 blue:0.0971 alpha:1.0];

  //显示到playground上
  [self.playGround addSubview:self.food];
}

//改变方向
/*
 bug:
 ＃1.连续点按计时器重置：会加速蛇的移动。解决方法：定义一个全局变量，每次点击按钮时为该变量赋值为按钮的tag，每次点击按钮时判断当前按钮的tag是否与全局变量中存储的一致，若一致直接return
 ＃2.改变移动方向后没有立即移动。解决方法：在改变方向时先执行一次move方法
 */
- (void)changeDirectionWith:(NSInteger)direction{
  [self.mainTimer invalidate];
  self.mainTimer                        = nil;
  switch (direction) {
    case -100://上

      if (_lastBtnTag ==-200) {


  self.headerimage                      = [ MIMainViewController image:self.headerimage rotation:UIImageOrientationRight] ;

      }else if (_lastBtnTag ==200){
  self.headerimage                      = [ MIMainViewController image:self.headerimage rotation:UIImageOrientationLeft];
      }

      [self moveUp];

  self.mainTimer                        = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(moveUp) userInfo:nil repeats:YES];
      break;
    case 100://下

      if (_lastBtnTag ==-200) {


  self.headerimage                      = [ MIMainViewController image:self.headerimage rotation:UIImageOrientationLeft] ;
      }else if (_lastBtnTag ==200){
  self.headerimage                      = [ MIMainViewController image:self.headerimage rotation:UIImageOrientationRight];
      }

      [self moveDown];
  self.mainTimer                        = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(moveDown) userInfo:nil repeats:YES];
      break;
    case -200://左
      if (_lastBtnTag ==100) {
  self.headerimage                      = [ MIMainViewController image:self.headerimage rotation:UIImageOrientationRight];
      }else if(_lastBtnTag ==-100){
  self.headerimage                      = [ MIMainViewController image:self.headerimage rotation:UIImageOrientationLeft];
      }

           [self moveLeft];
  self.mainTimer                        = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(moveLeft) userInfo:nil repeats:YES];
      break;
    case 200://右
      if (_lastBtnTag ==100) {
  self.headerimage                      = [ MIMainViewController image:self.headerimage rotation:UIImageOrientationLeft];
      }else if(_lastBtnTag ==-100){
  self.headerimage                      = [ MIMainViewController image:self.headerimage rotation:UIImageOrientationRight];
      }

      [self moveRight];
  self.mainTimer                        = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(moveRight) userInfo:nil repeats:YES];
      break;
    default:
      break;
  }
}

- (void)moveUp{
  [self move:0 and:-snakeSize];
}

- (void)moveDown{
  [self move:0 and:snakeSize];
}

- (void)moveLeft{
  [self move:-snakeSize and:0];
}

- (void)moveRight{
  [self move:snakeSize and:0];
}

- (IBAction)btnClick:(UIButton *)sender {
  if (self.lastBtnTag == sender.tag) {
    return;
  }else{
    //禁用相反方向的button
  for (NSInteger i                      = 0; i<self.butonView.subviews.count; i++) {
  UIButton *btn                         = self.butonView.subviews[i];
      if (btn.tag == -sender.tag) {
  btn.enabled                           = NO;
      }else{
  btn.enabled                           = YES;
      }
    }
    [self changeDirectionWith:sender.tag];
  self.lastBtnTag                       = sender.tag;
  }
}

- (IBAction)pauseClick {
  [self.mainTimer invalidate];
  [self dismissViewControllerAnimated:YES completion:^{

  }];
}

//加载蛇身数组
- (NSMutableArray *)snakeBlocks{
  if (!_snakeBlocks) {
    //生成头
    //生成x坐标
  NSInteger x                           = arc4random_uniform(self.playGround.bounds.size.width - snakeSize - 1);
    while (x % snakeSize) {
  x                                     = arc4random_uniform(self.playGround.bounds.size.width - snakeSize - 1);
    }
    //生成y坐标
  NSInteger y                           = arc4random_uniform(self.playGround.bounds.size.height - snakeSize - 1);
    while (y % snakeSize) {
  y                                     = arc4random_uniform(self.playGround.bounds.size.height - snakeSize - 1);
    }




  UIImageView *head                     = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, snakeSize, snakeSize)];
    self.headerimage =[UIImage imageNamed:@"snakeheader"];
    [head setImage:self.headerimage];
//  head.backgroundColor               = [UIColor colorWithRed:0.9376 green:0.9319 blue:0.9618 alpha:1.0];
    [self.playGround addSubview:head];
  self.snake                            = head;
  _snakeBlocks                          = [NSMutableArray arrayWithObject:self.snake];
  }
  return _snakeBlocks;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
  long double rotate                    = 0.0;
  CGRect rect;
  float translateX                      = 0;
  float translateY                      = 0;
  float scaleX                          = 1.0;
  float scaleY                          = 1.0;

  switch (orientation) {
    case UIImageOrientationLeft:
  rotate                                = M_PI_2;
  rect                                  = CGRectMake(0, 0, image.size.height, image.size.width);
  translateX                            = 0;
  translateY                            = -rect.size.width;
  scaleY                                = rect.size.width/rect.size.height;
  scaleX                                = rect.size.height/rect.size.width;
      break;
    case UIImageOrientationRight:
  rotate                                = 3 * M_PI_2;
  rect                                  = CGRectMake(0, 0, image.size.height, image.size.width);
  translateX                            = -rect.size.height;
  translateY                            = 0;
  scaleY                                = rect.size.width/rect.size.height;
  scaleX                                = rect.size.height/rect.size.width;
      break;
    case UIImageOrientationDown:
  rotate                                = M_PI;
  rect                                  = CGRectMake(0, 0, image.size.width, image.size.height);
  translateX                            = -rect.size.width;
  translateY                            = -rect.size.height;
      break;
    default:
  rotate                                = 0.0;
  rect                                  = CGRectMake(0, 0, image.size.width, image.size.height);
  translateX                            = 0;
  translateY                            = 0;
      break;
  }

  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context                  = UIGraphicsGetCurrentContext();
  //做CTM变换
  CGContextTranslateCTM(context, 0.0, rect.size.height);
  CGContextScaleCTM(context, 1.0, -1.0);
  CGContextRotateCTM(context, rotate);
  CGContextTranslateCTM(context, translateX, translateY);

  CGContextScaleCTM(context, scaleX, scaleY);
  //绘制图片
  CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);

  UIImage *newPic                       = UIGraphicsGetImageFromCurrentImageContext();

  return newPic;
}

-(void)writDataInPlistweithLevel:(NSString*)level adnScore:(NSString*)score{
  //获取已有完整路径
  if ([[[TMCache sharedCache]objectForKey:@"top"] count]==0) {
    NSArray* array =[NSArray arrayWithObject:@{level:score}];
      [[TMCache sharedCache]
     setObject:array forKey:@"top"];

  }else{
    
    [[TMCache sharedCache]objectForKey:@"top" block:^(TMCache *cache, NSString *key, id object) {
      [[TMCache sharedCache]removeObjectForKey:@"top"];
      NSMutableArray * array = [NSMutableArray arrayWithObject:object];
       [array addObject:@{level:score}];
      [[TMCache sharedCache] setObject:array
                                forKey:@"top"];

    }];
  
      }
  
}
@end
