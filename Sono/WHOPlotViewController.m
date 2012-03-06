//
//  WHOPlotViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 05.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "WHOPlotViewController.h"

#import "Constants.h"
#import "CSVParser.h"


@interface WHOPlotViewController ()

@property (assign) CGRect frame;
@property (nonatomic, strong) NSArray *records;

@end


@implementation WHOPlotViewController

@synthesize frame = _frame;
@synthesize records = _records;


#pragma mark - Init


- (id)initWithWithFrame:(CGRect)frame
{
  self = [super init];
  if (self) {
    self.frame = frame;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"wfa_boys_p_exp" withExtension:@"txt"];
    NSAssert(url != nil, @"url must not be nil");
    NSError *error = nil;
    NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
      CSVParser *parser = [[CSVParser alloc] initWithString:data separator:@"\t" hasHeader:YES fieldNames:nil];
      self.records = [parser arrayOfParsedRows];
    } else {
      NSLog(@"Warning: no data for WHO plot");
    }
  }
  return self;
}


- (void)loadView
{
  self.view = [[UIView alloc] initWithFrame:self.frame];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self createGraph];
}


- (void)viewDidUnload
{
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
  plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(2000)];
  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(20)];
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
    x.majorIntervalLength = CPTDecimalFromInt(500);
    x.minorTicksPerInterval = 10;
    x.majorGridLineStyle = gridLineStyle;
    x.labelFormatter = [[NSNumberFormatter alloc] init];
    [x.labelFormatter setMaximumFractionDigits:0];
  }
  {
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromInt(5);
    y.minorTicksPerInterval = 0;
    y.majorGridLineStyle = gridLineStyle;
    y.labelFormatter = [[NSNumberFormatter alloc] init];
    [y.labelFormatter setMaximumFractionDigits:0];
  }
}


- (void)createGraph {
  CPTGraphHostingView *gv = [[CPTGraphHostingView alloc] init];
  gv.frame = self.view.bounds;
  self.view.layer.borderColor = [[Constants sharedInstance] color1].CGColor;
  self.view.layer.borderWidth = 2;
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
  return self.records.count -1; // skip header row
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
  NSUInteger recordIndex = index +1; // skip header row
  if (fieldEnum == CPTCoordinateX) {
    NSString *value = [[self.records objectAtIndex:recordIndex] objectForKey:@"Age"];
    return [NSDecimalNumber decimalNumberWithString:value];
  } else {
    NSString *value = [[self.records objectAtIndex:recordIndex] objectForKey:@"P50"];
    return [NSDecimalNumber decimalNumberWithString:value];
  }
}



@end
