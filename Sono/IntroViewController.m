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
@synthesize versionLabel;

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
  
  [self createGraph];
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


#pragma mark - Workers


- (void)configureGraph:(CPTXYGraph *)graph {
	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
  [graph applyTheme:theme];
  
  graph.paddingLeft = 0.0;
  graph.paddingTop = 0.0;
  graph.paddingRight = 0.0;
  graph.paddingBottom = 0.0;
  
  graph.plotAreaFrame.paddingTop = 20;
  graph.plotAreaFrame.paddingBottom = 30;
  graph.plotAreaFrame.paddingLeft = 40;
  graph.plotAreaFrame.paddingRight = 20;
  //graph.plotAreaFrame.cornerRadius = 8;
}


- (void)configurePlotSpace:(CPTXYPlotSpace *)plotSpace {
  plotSpace.allowsUserInteraction = YES;
  plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(10)];
  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(15)];
}


- (void)configureAxes:(CPTXYAxisSet *)axisSet {
  CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
  gridLineStyle.lineWidth = 0.75;
  gridLineStyle.dashPattern = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:2.0f],
                               [NSNumber numberWithFloat:5.0f],
                               nil];
  
  CPTMutableTextStyle *axisTitleTextStyle = [CPTMutableTextStyle textStyle];
	axisTitleTextStyle.fontName = @"Helvetica-Bold";
	axisTitleTextStyle.fontSize = 14.0;
  
  {
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromInt(5);
    x.minorTicksPerInterval = 1;
    x.majorGridLineStyle = gridLineStyle;
  }
  {
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromInt(5);
    y.minorTicksPerInterval = 1;
    y.majorGridLineStyle = gridLineStyle;
  }
}


- (void)createGraph {
  CPTGraphHostingView *gv = [[CPTGraphHostingView alloc] init];
  float fullwidth = self.view.frame.size.width;
  float width = 400;
  gv.frame = CGRectMake(fullwidth/2 - width/2, 300, width, 300);
  gv.layer.borderColor = [[Constants sharedInstance] color1].CGColor;
  gv.layer.borderWidth = 2;
  [self.view addSubview:gv];
  
  CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
  gv.hostedGraph = graph;

  [self configureGraph:graph];
  [self configurePlotSpace:(CPTXYPlotSpace *)graph.defaultPlotSpace];
  [self configureAxes:(CPTXYAxisSet *)graph.axisSet];

  CPTScatterPlot *plot1 = [[CPTScatterPlot alloc] init];
  plot1.dataSource = self;
  [graph addPlot:plot1];
}


#pragma mark - CPPlotDataSource


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
  return 10;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
  NSArray *data = [NSArray arrayWithObjects:
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithInt:3],
                   [NSNumber numberWithInt:2],
                   [NSNumber numberWithInt:4],
                   [NSNumber numberWithInt:6],
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithInt:7],
                   [NSNumber numberWithInt:8],
                   [NSNumber numberWithInt:9],
                   [NSNumber numberWithInt:6],
                   nil];
  if (fieldEnum == CPTCoordinateX) {
    return [NSNumber numberWithInt:index];
  } else {
    return [data objectAtIndex:index];
  }
}


@end
