//
//  ViewController.h
//  DrawingView
//
//  Created by Sven A. Schmidt on 02.05.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cocos2d.h"

@interface CanvasViewController : UIViewController<CCDirectorDelegate>

@property (weak, nonatomic) IBOutlet UIView *canvas;

@end
