//
//  EditExaminationViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "EditExaminationViewController.h"

#import "Constants.h"
#import "DataStore.h"
#import "Utils.h"
#import "Examination.h"
#import "Examination+Additions.h"
#import "ExaminationViewController.h"
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
@synthesize unitLabel = _unitLabel;
@synthesize heightLabel = _heightLabel;
@synthesize weightLabel = _weightLabel;
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
    NSMutableArray *vcs = [self.navigationController.viewControllers mutableCopy];
    [vcs removeLastObject];
    if ([[vcs lastObject] isKindOfClass:[ExaminationViewController class]]) {
      // if the top of the stack is an examination vc, just pop to it -- in this case
      // we got here via the examination vc
      [self.navigationController popViewControllerAnimated:YES];
    } else {
      // otherwise we got here via the patient vc (new examination), so we need to
      // put the examination view on the stack ourselves
      UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
      ExaminationViewController *examVc = [sb instantiateViewControllerWithIdentifier:@"ExaminationViewController"];
      examVc.detailItem = self.detailItem;
      [vcs addObject:examVc];
      [self.navigationController setViewControllers:vcs animated:NO];
    }
  } else {
    [[Utils sharedInstance] showError:error];
  }
}


- (void)showPopoverAnimated:(BOOL)animated
{
  int arrowDirection = UIPopoverArrowDirectionLeft;
  
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
  
  // handle unit display
  UIView *fieldLabel = nil;
  if (sender == self.heightField) {
    self.heightField.text = [self.detailItem heightAsStringWithUnits:NO];
    fieldLabel = self.heightLabel;
    self.unitLabel.text = @"(cm)";
  } else if (sender == self.weightField) {
    self.weightField.text = [self.detailItem weightAsStringWithUnits:NO];
    fieldLabel = self.weightLabel;
    self.unitLabel.text = @"(g)";
  }
  CGRect frame = fieldLabel.frame;
  self.unitLabel.frame = frame;
  CGSize size = [self.unitLabel sizeThatFits:frame.size];
  frame.origin.x -= size.width +5;
  [UIView animateWithDuration:0.2 animations:^{
    fieldLabel.frame = frame;
    self.unitLabel.alpha = 1;
  }];
}


- (IBAction)editingDidEnd:(id)sender {
  [self.popover dismissPopoverAnimated:NO];
  
  // handle unit display
  UIView *fieldLabel = nil;
  if (sender == self.heightField) {
    self.heightField.text = [self.detailItem heightAsStringWithUnits:YES];
    fieldLabel = self.heightLabel;
  } else if (sender == self.weightField) {
    self.weightField.text = [self.detailItem weightAsStringWithUnits:YES];
    fieldLabel = self.weightLabel;
  }
  CGRect frame = fieldLabel.frame;
  CGSize size = [self.unitLabel sizeThatFits:frame.size];
  frame.origin.x += size.width +5;
  [UIView animateWithDuration:0.2 animations:^{
    fieldLabel.frame = frame;
    self.unitLabel.alpha = 0;
  }];
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
    self.heightField.text = [self.detailItem heightAsStringWithUnits:YES];
    self.weightField.text = [self.detailItem weightAsStringWithUnits:YES];
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

  float width = 300;
  float height = 200;
  CGRect frame = CGRectMake(0, 0, width, height);

  self.weightPlot = [[WHOPlotViewController alloc] initWithWithFrame:frame dataSet:kWhoWeightBoys];
  [self.weightPlot setUserValueX:self.detailItem.ageInDays Y:self.detailItem.weight.doubleValue];
  self.heightPlot = [[WHOPlotViewController alloc] initWithWithFrame:frame dataSet:kWhoHeightBoys];
  [self.heightPlot setUserValueX:self.detailItem.ageInDays Y:self.detailItem.height.doubleValue];

  self.unitLabel.alpha = 0;
  self.unitLabel.textColor = [UIColor grayColor];
  
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
    [self setUnitLabel:nil];
    [self setHeightLabel:nil];
    [self setWeightLabel:nil];
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
