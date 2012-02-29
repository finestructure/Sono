//
//  ExaminationViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "ExaminationViewController.h"

#import "Examination.h"
#import "Examination+Additions.h"
#import "Patient+Additions.h"
#import "Utils.h"
#import "EditExaminationViewController.h"


@interface ExaminationViewController ()

@end


@implementation ExaminationViewController

@synthesize detailItem = _detailItem;
@synthesize patientDescriptionLabel = _patientDescriptionLabel;
@synthesize examinationDateLabel = _examinationDateLabel;
@synthesize ageLabel = _ageLabel;
@synthesize heightLabel = _heightLabel;
@synthesize weightLabel = _weightLabel;
@synthesize examinerLabel = _examinerLabel;
@synthesize locationLabel = _locationLabel;


#pragma mark - Managing the detail item


- (void)setDetailItem:(Examination *)newDetailItem {
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;
    [self configureView];
  }
}


- (void)configureView {
  if (self.detailItem) {
    Patient *patient = self.detailItem.patient;
    
    self.patientDescriptionLabel.text = [NSString stringWithFormat:@"%@, geboren am %@", patient.fullName, [[Utils sharedInstance] shortDate:patient.birthDate]];
    
    self.examinationDateLabel.text = [[Utils sharedInstance] shortDate:self.detailItem.examinationDate];
    
    self.ageLabel.text = self.detailItem.ageAsString;    
    self.heightLabel.text = self.detailItem.heightAsString;
    self.weightLabel.text = self.detailItem.weightAsString;
    self.examinerLabel.text = self.detailItem.examiner;
    self.locationLabel.text = self.detailItem.location;
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
  [self configureView];
}


- (void)viewDidUnload
{
  [self setPatientDescriptionLabel:nil];
  [self setExaminationDateLabel:nil];
  [self setAgeLabel:nil];
  [self setHeightLabel:nil];
  [self setWeightLabel:nil];
  [self setExaminerLabel:nil];
  [self setLocationLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - Segue related


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"EditExamination"]) {
    NSLog(@"segue EditExamination");
    EditExaminationViewController *vc = segue.destinationViewController;
    vc.detailItem = self.detailItem;
  }
}



@end
