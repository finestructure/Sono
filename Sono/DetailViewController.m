//
//  DetailViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize lastNameTextField = _lastNameTextField;
@synthesize firstNameTextField = _firstNameTextField;
@synthesize birthDateTextField = _birthDateTextField;
@synthesize patientIdTextField = _patientIdTextField;
@synthesize gebHeftTextField = _gebHeftTextField;
@synthesize famBelastungTextField = _famBelastungTextField;
@synthesize praenatDiagTextField = _praenatDiagTextField;
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
    self.firstNameTextField.text = self.detailItem.firstName;
    self.lastNameTextField.text = self.detailItem.lastName;
    self.birthDateTextField.text = self.detailItem.birthDate.description;
    self.patientIdTextField.text = self.detailItem.patientId;
    self.gebHeftTextField.text = self.detailItem.gebheftId;
    self.famBelastungTextField.text = self.detailItem.famBelastung.description;
    self.praenatDiagTextField.text = self.detailItem.praenatDiag;
  }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)viewDidUnload
{
  [self setLastNameTextField:nil];
  [self setFirstNameTextField:nil];
  [self setBirthDateTextField:nil];
  [self setPatientIdTextField:nil];
  [self setGebHeftTextField:nil];
  [self setFamBelastungTextField:nil];
  [self setPraenatDiagTextField:nil];
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

@end
