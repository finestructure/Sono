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


NSString * const kP3 = @"P3";
NSString * const kP15 = @"P15";
NSString * const kP50 = @"P50";
NSString * const kP85 = @"P85";
NSString * const kP97 = @"P97";
NSString * const kUserValue = @"UserValue";


@interface WHOPlotViewController ()

@property (assign) CGRect frame;
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, strong) CPTScatterPlot *userPlot;

@end


@implementation WHOPlotViewController

@synthesize dataSet = _dataSet;
@synthesize frame = _frame;
@synthesize records = _records;
@synthesize userValue = _userValue;
@synthesize userPlot = _userPlot;


#pragma mark - Init

- (void)initInBackground {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *rows = [[Constants sharedInstance] whoData:self.dataSet];
    NSMutableArray *records = [NSMutableArray array];
    NSArray *identifiers = [NSArray arrayWithObjects:kP3, kP15, kP50, kP85, kP97, nil];
    int filter = 50;
    
    __block NSString *xKey = nil;
      
    for (NSDictionary *row in rows) {
      if (xKey == nil) {
        // try to find the x column in the header row
        [[NSArray arrayWithObjects:@"Age", @"Day", nil]
         enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          if ([row objectForKey:obj] != nil) {
            xKey = obj;
            *stop = YES;
          }
        }];
        if (xKey == nil) {
          break;
        }
      }
        
      NSDecimalNumber *x = [row objectForKey:xKey];
      int int_x = x.doubleValue / filter;
      if (fabs(int_x * filter - x.doubleValue) < 0.1) {
        NSMutableDictionary *values = [NSMutableDictionary dictionaryWithObject:x forKey:xKey];
        for (NSString *identifier in identifiers) {
          [values setObject:[NSDecimalNumber decimalNumberWithString:[row objectForKey:identifier]] forKey:identifier];
        }
        [records addObject:values];
      }
    }
    
    self.records = records;
  });
}


- (id)initWithWithFrame:(CGRect)frame dataSet:(NSString *)dataSet
{
  self = [super init];
  if (self) {
    self.frame = frame;
    self.dataSet = dataSet;
    self.records = [NSArray array];
    [self initInBackground];
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


- (void)setUserValueX:(double)x Y:(double)y
{
  self.userValue = [NSArray arrayWithObjects:
                    [NSDecimalNumber numberWithDouble:x],
                    [NSDecimalNumber numberWithDouble:y],
                    nil];
  [self.userPlot reloadData];
}


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
  plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(500)];
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


- (void)configurePlot:(CPTScatterPlot *)plot withIdentifier:(NSString *)identifier
{
  NSDictionary *colors = [NSDictionary dictionaryWithObjectsAndKeys:
                          [CPTColor redColor], kP3,
                          [CPTColor orangeColor], kP15,
                          [CPTColor colorWithComponentRed:0 green:102/255. blue:51/255. alpha:1], kP50,
                          [CPTColor orangeColor], kP85,
                          [CPTColor redColor], kP97,
                          [CPTColor blackColor], kUserValue,
                          nil];
  CPTColor *color = [colors objectForKey:identifier];

  plot.dataSource = self;
  plot.identifier = identifier;
  
  // line style
  CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
	lineStyle.lineWidth = 1.5;
  lineStyle.lineColor = color;
  plot.dataLineStyle = lineStyle;
  
  // symbol
  if (identifier == kUserValue) {
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill		 = [CPTFill fillWithColor:[CPTColor lightGrayColor]];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size		 = CGSizeMake(10.0, 10.0);
    plot.plotSymbol	 = plotSymbol;
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
  
  NSArray *identifiers = [NSArray arrayWithObjects:kP3, kP15, kP50, kP85, kP97, kUserValue, nil];
  for (NSString *identifier in identifiers) {
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    [self configurePlot:plot withIdentifier:identifier];
    [graph addPlot:plot];
    if (identifier == kUserValue) {
      self.userPlot = plot;
    }
  }
}


#pragma mark - CPPlotDataSource


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
  if (plot.identifier == kUserValue) {
    if (self.userValue != 0) {
      return 1;
    } else {
      return 0;
    }
  } else {
    return self.records.count;
  }
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
  if (plot.identifier == kUserValue) {
    if (self.userValue == nil) {
      return [NSNumber numberWithDouble:NAN];
    }
    if (fieldEnum == CPTCoordinateX) {
      return [self.userValue objectAtIndex:0];
    } else {
      return [self.userValue objectAtIndex:1];
    }
  } else {
    if (fieldEnum == CPTCoordinateX) {
      return [[self.records objectAtIndex:index] objectForKey:@"Age"];
    } else if (fieldEnum == CPTCoordinateY) {
      return [[self.records objectAtIndex:index] objectForKey:plot.identifier];
    } else {
      return [NSNumber numberWithDouble:NAN];
    }
  }
}



@end
