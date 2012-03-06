//
//  IntroViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 01.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "IntroViewController.h"

#import "Constants.h"
#import "WHOPlotViewController.h"


@interface IntroViewController ()

@property (nonatomic, strong) WHOPlotViewController *plotViewController;

@end

@implementation IntroViewController

@synthesize vendorLabel = _vendorLabel;
@synthesize versionLabel = _versionLabel;
@synthesize plotViewController = _plotViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.hidesBackButton = YES;
  self.vendorLabel.textColor = [[Constants sharedInstance] color4];
  self.versionLabel.text = [[Constants sharedInstance] version];
  self.versionLabel.textColor = [[Constants sharedInstance] color4];
  
  float fullwidth = self.view.frame.size.width;
  float width = 600;
  float height = 400;
  CGRect frame = CGRectMake(fullwidth/2 - width/2, 300, width, height);
  self.plotViewController = [[WHOPlotViewController alloc] initWithWithFrame:frame];
  [self.view addSubview:self.plotViewController.view];
}


- (void)viewDidUnload
{
  [self setVendorLabel:nil];
  [self setVersionLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
