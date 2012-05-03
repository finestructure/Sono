//
//  SingleSonoImageViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 09.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "SingleSonoImageViewController.h"

#import "Canvas.h"

@interface SingleSonoImageViewController ()

@end

@implementation SingleSonoImageViewController

@synthesize image = _image;
@synthesize canvas = _canvas;


- (void)handleTap {
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.canvas.userInteractionEnabled = YES;
	[self.canvas addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)]];
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
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)setupCocos2d
{
  CCDirector *director = [CCDirector sharedDirector];
  [director end];
  [director.view removeFromSuperview];
  director.view = nil;

	CCGLView *glView = [CCGLView viewWithFrame:[self.canvas bounds]
                                 pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
                                 depthFormat:0	//GL_DEPTH_COMPONENT24_OES
                          preserveBackbuffer:NO
                                  sharegroup:nil
                               multiSampling:NO
                             numberOfSamples:0];
  glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.canvas insertSubview:glView atIndex:0];
  
  director.view = glView;
  director.displayStats = YES;
  director.animationInterval = 1/60.;
  director.delegate = self;
  director.projection = kCCDirectorProjection2D;
	if(! [director enableRetinaDisplay:YES]) {
		CCLOG(@"Retina Display Not supported");
  }
  
	[[CCDirector sharedDirector] pushScene:[Canvas sceneWithImage:self.image]];
  [[CCDirector sharedDirector] startAnimation];
}


@end
