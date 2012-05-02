//
//  ViewController.m
//  DrawingView
//
//  Created by Sven A. Schmidt on 02.05.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "CanvasViewController.h"

#import "Canvas.h"


@interface CanvasViewController ()

@end

@implementation CanvasViewController

@synthesize canvas;


- (void)setupCocos2d
{
	CCGLView *glView = [CCGLView viewWithFrame:[self.canvas bounds]
                                 pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
                                 depthFormat:0	//GL_DEPTH_COMPONENT24_OES
                          preserveBackbuffer:NO
                                  sharegroup:nil
                               multiSampling:NO
                             numberOfSamples:0];
  glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.canvas insertSubview:glView atIndex:0];
  
  CCDirector *director = [CCDirector sharedDirector];
  director.view = glView;
  director.displayStats = YES;
  director.animationInterval = 1/60.;
  director.delegate = self;
  director.projection = kCCDirectorProjection2D;
	if(! [director enableRetinaDisplay:YES]) {
		CCLOG(@"Retina Display Not supported");
  }

	[[CCDirector sharedDirector] pushScene:[Canvas scene]];
  [[CCDirector sharedDirector] startAnimation];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupCocos2d];
}


- (void)viewDidUnload
{
  [[CCDirector sharedDirector] end];
  [self setCanvas:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

@end
