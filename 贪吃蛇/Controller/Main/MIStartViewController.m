//
//  MIStartViewController.m
//  贪吃蛇
//
//  Created by mickey on 16/8/4.
//  Copyright © 2016年 mickey. All rights reserved.
//

#import "MIStartViewController.h"
#import "MIMainViewController.h"

#define Easy 1
#define Middle .5
#define Hard .3
#define Crazy .1
#define OMG   .05
#define Fuck   .01

@interface MIStartViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *difficultSlect;
@property (assign, nonatomic) CGFloat dif;

@end

@implementation MIStartViewController

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  if (row == 0) {
    return @"Easy";
  }else if(row == 1){
    return @"Middle";
  }else if(row == 2){
    return @"Difficult";
  }else if(row == 3) {
    return @"Crazy";
  }else if(row == 4)
    return @"OMG";
  else
    return @"Fuck";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  if (row == 0) self.dif = Easy;
  else if (row == 1) self.dif = Middle;
  else if (row == 2) self.dif = Hard;
  else if (row == 3) self.dif = Crazy;
  else if (row == 4) self.dif = OMG;
  else self.dif = Fuck;
}

- (IBAction)startClick:(id)sender {
  [self performSegueWithIdentifier:@"start" sender:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.dif = Easy;
  self.difficultSlect.delegate = self;
  self.difficultSlect.dataSource = self;
    self.fd_prefersNavigationBarHidden = YES;
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"start"]) {
    MIMainViewController *vc = segue.destinationViewController;
//    CATransition *transition = [CATransition animation];
//    
//    transition.duration = 0.3f;
//    
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    transition.type = kCATransitionPush;
//    
//    transition.subtype = kCATransitionFromBottom;
//    
//    transition.delegate = self;
//    
//    [vc.view.layer addAnimation:transition forKey:nil];

    vc.timeInterval = self.dif;
  }
  
}



@end
