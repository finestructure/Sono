//
//  WHOPlotViewController.h
//  Sono
//
//  Created by Sven A. Schmidt on 05.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"


@interface WHOPlotViewController : UIViewController<CPTPlotDataSource>

@property (nonatomic, strong) NSArray *userValue;
@property (nonatomic, strong) NSString *dataSet;

- (id)initWithWithFrame:(CGRect)frame dataSet:(NSString *)dataSet;
- (void)setUserValueX:(double)x Y:(double)y;

@end
