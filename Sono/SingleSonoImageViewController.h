//
//  SingleSonoImageViewController.h
//  Sono
//
//  Created by Sven A. Schmidt on 09.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cocos2d.h"

@interface SingleSonoImageViewController : UIViewController<CCDirectorDelegate>

@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *canvas;

@end
