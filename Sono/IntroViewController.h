//
//  IntroViewController.h
//  Sono
//
//  Created by Sven A. Schmidt on 01.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"


@interface IntroViewController : UIViewController<CPTPlotDataSource>

@property (weak, nonatomic) IBOutlet UILabel *vendorLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end
