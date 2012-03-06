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

- (id)initWithWithFrame:(CGRect)frame;

@end
