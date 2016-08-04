//
//  MIPlayer.m
//  贪吃蛇
//
//  Created by mickey on 16/8/4.
//  Copyright © 2016年 mickey. All rights reserved.
//

#import "MIPlayer.h"

@implementation MIPlayer
- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self) {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.score forKey:@"score"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  self.name = [coder decodeObjectForKey:@"name"];
  self.score = [coder decodeObjectForKey:@"score"];
  
}

@end
