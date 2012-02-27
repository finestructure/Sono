//
//  PatientEditViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "EditPatientViewController.h"

@interface EditPatientViewController ()

@end

@implementation EditPatientViewController

@synthesize detailItem = _detailItem;
@synthesize lastNameField = _lastNameField;
@synthesize firstNameField = _firstNameField;
@synthesize birthDateField = _birthDateField;
@synthesize patientIdField = _patientIdField;
@synthesize gebHeftField = _gebHeftField;
@synthesize famBelastungField = _famBelastungField;
@synthesize praenatDiagField = _praenatDiagField;


#pragma mark - Managing the detail item

- (void)setDetailItem:(Patient *)newDetailItem
{
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;
    
    // Update the view.
    [self configureView];
  }
}

- (void)configureView
{
  // Update the user interface for the detail item.
  
  if (self.detailItem) {
    self.firstNameField.text = self.detailItem.firstName;
    self.lastNameField.text = self.detailItem.lastName;
    self.birthDateField.text = self.detailItem.birthDate.description;
    self.patientIdField.text = self.detailItem.patientId;
    self.gebHeftField.text = self.detailItem.gebheftId;
    self.famBelastungField.text = self.detailItem.famBelastung.description;
    self.praenatDiagField.text = self.detailItem.praenatDiag;
  }
}


#pragma mark View delegates


- (void)viewWillDisappear:(BOOL)animated {
  NSLog(@"in here - save me!");
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
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
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

@end
