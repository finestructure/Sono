//
//  EditExaminationViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "EditExaminationViewController.h"
#import "DataStore.h"
#import "Utils.h"
#import "Examination.h"
#import "Examination+Additions.h"
#import "Patient+Additions.h"
#import "RoundedView.h"
#import "WHOPlotViewController.h"


@interface EditExaminationViewController ()

@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, weak) UIView *popoverTarget;
@property (nonatomic, strong) WHOPlotViewController *weightPlot;
@property (nonatomic, strong) WHOPlotViewController *heightPlot;

@end


@implementation EditExaminationViewController

@synthesize detailItem = _detailItem;
@synthesize patientDescriptionLabel = _patientDescriptionLabel;
@synthesize examinationDatePicker = _examinationDatePicker;
@synthesize ageLabel = _ageLabel;
@synthesize heightField = _heightField;
@synthesize weightField = _weightField;
@synthesize examinerField = _examinerField;
@synthesize locationField = _locationField;
@synthesize boundingBox = _boundingBox;
@synthesize popover = _popover;
@synthesize popoverTarget = _popoverTarget;
@synthesize weightPlot = _weightPlot;
@synthesize heightPlot = _heightPlot;


# pragma mark - Worker


- (void)updateModel {
  [self.detailItem setHeightFromString:self.heightField.text];
  [self.detailItem setWeightFromString:self.weightField.text];
  self.detailItem.examiner = self.examinerField.text;
  self.detailItem.location = self.locationField.text;
}


- (void)save {
  [self updateModel];
  
  NSError *error = nil;
  if ([[DataStore sharedInstance] saveContext:&error]) {
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    [[Utils sharedInstance] showError:error];
  }
}


- (void)showPopoverAnimated:(BOOL)animated
{
  int arrowDirection = UIPopoverArrowDirectionLeft;
  NSLog(@"orientation: %d", [[UIDevice currentDevice] orientation]);
  
  switch ([[UIDevice currentDevice] orientation]) {
    case UIDeviceOrientationLandscapeLeft:
    case UIDeviceOrientationLandscapeRight:
      arrowDirection = UIPopoverArrowDirectionLeft;
      break;
    case UIDeviceOrientationPortrait:
    case UIDeviceOrientationPortraitUpsideDown:
      arrowDirection = UIPopoverArrowDirectionLeft;
      break;
    default:
      break;
  }

  if (self.popoverTarget == self.heightField) {
    if (self.heightPlot != nil) {
      self.popover = [[UIPopoverController alloc] initWithContentViewController:self.heightPlot];
      self.popover.popoverContentSize = self.heightPlot.view.frame.size;
    }
  } else {
    if (self.weightPlot != nil) {
      self.popover = [[UIPopoverController alloc] initWithContentViewController:self.weightPlot];
      self.popover.popoverContentSize = self.weightPlot.view.frame.size;
    }
  }
  [self.popover presentPopoverFromRect:self.popoverTarget.frame inView:self.boundingBox permittedArrowDirections:arrowDirection animated:animated];
}


#pragma mark - Actions


- (IBAction)saveButtonPressed:(id)sender {
  [self save];
}


-(void)backButtonPressed:(id)sender {
  [[DataStore sharedInstance] rollback];
  [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)editingChanged:(id)sender {
  [self updateModel];
  if (sender == self.heightField) {
    [self.heightPlot setUserValueX:self.detailItem.ageInDays Y:self.detailItem.height.doubleValue];
  } else if (sender == self.weightField) {
    [self.weightPlot setUserValueX:self.detailItem.ageInDays Y:self.detailItem.weight.doubleValue];
  }
}


- (IBAction)editingDidBegin:(id)sender {
  self.popoverTarget = sender;
  [self showPopoverAnimated:YES];
}


#pragma mark - Managing the detail item


- (void)setDetailItem:(Examination *)newDetailItem{
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;
    [self configureView];
  }
}


- (void)configureView {
  if (self.detailItem) {
    self.examinationDatePicker.selectedDate = self.detailItem.examinationDate;
    self.ageLabel.text = self.detailItem.ageAsString;
    self.heightField.text = self.detailItem.heightAsString;
    self.weightField.text = self.detailItem.weightAsString;
    self.examinerField.text = self.detailItem.examiner;
    self.locationField.text = self.detailItem.location;
  }
}


#pragma mark - Init


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
  self.examinationDatePicker.delegate = self;
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Abbrechen" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)];
  self.navigationItem.leftBarButtonItem = backButton;
  
  Patient *patient = self.detailItem.patient;
  self.patientDescriptionLabel.text = [NSString stringWithFormat:@"%@, geboren am %@", patient.fullName, [[Utils sharedInstance] shortDate:patient.birthDate]];

  {
    float width = 300;
    float height = 200;
    CGRect frame = CGRectMake(0, 0, width, height);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      self.weightPlot = [[WHOPlotViewController alloc] initWithWithFrame:frame];
      self.heightPlot = [[WHOPlotViewController alloc] initWithWithFrame:frame];
    });
  }

  [self configureView];
}


- (void)viewDidUnload
{
  [self setExaminationDatePicker:nil];
  [self setAgeLabel:nil];
  [self setHeightField:nil];
  [self setWeightField:nil];
  [self setExaminerField:nil];
  [self setLocationField:nil];
  [self setPatientDescriptionLabel:nil];
  [self setBoundingBox:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - DateDropdownDelegate


- (void)dateDropDown:(DateDropDown *)dateDropDown didSelectDate:(NSDate *)date {
  self.detailItem.examinationDate = date;
  [self configureView];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  if (self.popover != nil) {
    [self.popover dismissPopoverAnimated:NO];
    [self showPopoverAnimated:NO];
  }
}


@end
