//
//  SonoImageViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 09.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "SonoImageViewController.h"

@interface SonoImageViewController ()

@end

@implementation SonoImageViewController

@synthesize scrollView = _scrollView;


- (void)tapHandler:(UITapGestureRecognizer *)sender {
  [self performSegueWithIdentifier:@"ShowSonoImage" sender:self];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  int totalWidth = self.scrollView.frame.size.width;
  int sepWidth = 7;

  float aspectRatio = 768./592;
  int imageWidth = (totalWidth - sepWidth)/2;
  int imageHeight = round(imageWidth/aspectRatio);
  int colWidth = imageWidth + sepWidth;
  int rowHeight = imageHeight + sepWidth;
  
  // load images
  int imageCount = 16;
  for (int i = 0; i < imageCount; ++i) {
    NSString *name = [NSString stringWithFormat:@"Image-%d.jpeg", i];
    UIImage *image = [UIImage imageNamed:name];
    NSAssert(image, @"image must not be nil");
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)]];

    int col = i % 2;
    int row = i / 2;
    view.frame = CGRectMake(col*colWidth, row*rowHeight, imageWidth, imageHeight);
    [self.scrollView addSubview:view];
  }
  int nRows = ceil(imageCount / 2);
  CGSize contentSize = self.scrollView.contentSize;
  contentSize.height = nRows * rowHeight - sepWidth; // rowHeight includes sepWidth, remove extra one
  self.scrollView.contentSize = contentSize;
}

- (void)viewDidUnload
{
  [self setScrollView:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
