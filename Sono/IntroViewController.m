//
//  IntroViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 01.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "IntroViewController.h"

#import "Constants.h"

@interface IntroViewController ()

@end

@implementation IntroViewController
@synthesize vendorLabel;

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
}


- (void)viewDidUnload
{
  [self setVendorLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
