//
//  DetailViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DetailViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "EditPatientViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize lastNameField = _lastNameField;
@synthesize firstNameField = _firstNameField;
@synthesize birthDateField = _birthDateField;
@synthesize patientIdField = _patientIdField;
@synthesize gebHeftField = _gebHeftField;
@synthesize famBelastungField = _famBelastungField;
@synthesize praenatDiagField = _praenatDiagField;
@synthesize detailBox = _detailBox;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(Patient *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
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


- (void)viewWillAppear:(BOOL)animated {
  [self configureView];
}


#pragma mark - Init


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
  
  [self.detailBox.layer setCornerRadius:8.0f];
  [self.detailBox.layer setMasksToBounds:YES];
}

- (void)viewDidUnload
{
  [self setLastNameField:nil];
  [self setFirstNameField:nil];
  [self setBirthDateField:nil];
  [self setPatientIdField:nil];
  [self setGebHeftField:nil];
  [self setFamBelastungField:nil];
  [self setPraenatDiagField:nil];
  [self setDetailBox:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


#pragma mark - Segue related


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"EditPatient"]) {
    NSLog(@"segue EditPatient");
    EditPatientViewController *vc = segue.destinationViewController;
    vc.detailItem = self.detailItem;
  }
}


@end
