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

@interface EditExaminationViewController ()

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


# pragma mark - Worker


- (void)save {
  static NSNumberFormatter *f = nil;
  if (f == nil) {
    f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
  }

  Patient *patient = self.detailItem.patient;
  
  self.patientDescriptionLabel.text = [NSString stringWithFormat:@"%@, geboren am %@", patient.fullName, [[Utils sharedInstance] shortDate:patient.birthDate]];

  [self.detailItem setHeightFromString:self.heightField.text];
  [self.detailItem setWeightFromString:self.weightField.text];
  self.detailItem.examiner = self.examinerField.text;
  self.detailItem.location = self.locationField.text;
  
  NSError *error = nil;
  if ([[DataStore sharedInstance] saveContext:&error]) {
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    [[Utils sharedInstance] showError:error];
  }
}


-(void)backButtonPressed:(id)sender {
  [self save];
}


#pragma mark - Actions


- (IBAction)saveButtonPressed:(id)sender {
  [self save];
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
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Untersuchung" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)];
  self.navigationItem.leftBarButtonItem = backButton;
  
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


@end
