//
//  SingleSonoImageViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 09.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "SingleSonoImageViewController.h"

@interface SingleSonoImageViewController ()

@end

@implementation SingleSonoImageViewController

@synthesize image = _image;
@synthesize imageView = _imageView;


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

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.imageView.image = self.image;
  self.imageView.userInteractionEnabled = YES;
	[self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)]];
}

- (void)viewDidUnload
{
  [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
