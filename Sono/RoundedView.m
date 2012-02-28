//
//  RoundedView.m
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "RoundedView.h"

#import <QuartzCore/QuartzCore.h>

@implementation RoundedView


- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super initWithCoder:decoder];
  if (self) {
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
