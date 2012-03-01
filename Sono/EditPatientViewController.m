//
//  PatientEditViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "EditPatientViewController.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "DataStore.h"
#import "Utils.h"


@interface EditPatientViewController ()

@end

@implementation EditPatientViewController

@synthesize detailItem = _detailItem;
@synthesize lastNameField = _lastNameField;
@synthesize firstNameField = _firstNameField;
@synthesize patientIdField = _patientIdField;
@synthesize gebHeftField = _gebHeftField;
@synthesize famBelastungPicker = _famBelastungPicker;
@synthesize praenatDiagPicker = _praenatDiagPicker;
@synthesize birthDatePicker = _birthDatePicker;


# pragma mark - Worker


- (void)updateModel {
  self.detailItem.firstName = self.firstNameField.text;
  self.detailItem.lastName = self.lastNameField.text;
  self.detailItem.patientId = self.patientIdField.text;
  self.detailItem.gebheftId = self.gebHeftField.text;
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
}


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
    self.patientIdField.text = self.detailItem.patientId;
    self.gebHeftField.text = self.detailItem.gebheftId;
    self.famBelastungPicker.selectedRow = self.detailItem.famBelastung.integerValue;
    self.praenatDiagPicker.selectedRow = self.detailItem.praenatDiag.integerValue;
    self.birthDatePicker.selectedDate = self.detailItem.birthDate;
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
  self.famBelastungPicker.values = [[Constants sharedInstance] booleanValues];
  self.famBelastungPicker.delegate = self;
  self.praenatDiagPicker.values = [[Constants sharedInstance] praenatDiagValues];
  self.praenatDiagPicker.delegate = self;
  self.birthDatePicker.delegate = self;
  
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Abbrechen" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)];
  self.navigationItem.leftBarButtonItem = backButton;

  [self configureView];
}


- (void)viewDidUnload
{
  [self setFamBelastungPicker:nil];
  [self setPraenatDiagPicker:nil];
  [self setBirthDatePicker:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - DropdownButtonDelegate


- (void)dropdownButton:(DropdownButton *)dropdownButton didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (dropdownButton == self.famBelastungPicker) {
    self.detailItem.famBelastung = [NSNumber numberWithInt:row];
  } else if (dropdownButton == self.praenatDiagPicker) {
    self.detailItem.praenatDiag = [NSNumber numberWithInt:row];
  }
  [self configureView];
}


#pragma mark - DateDropdownDelegate


- (void)dateDropDown:(DateDropDown *)dateDropDown didSelectDate:(NSDate *)date {
  self.detailItem.birthDate = date;
  [self configureView];
}


@end
