//
//  DetailViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DetailViewController.h"

#import "EditPatientViewController.h"
#import "Constants.h"


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
    
    NSInteger index = self.detailItem.famBelastung.integerValue;
    NSString *text = [[[Constants sharedInstance] booleanValues] objectAtIndex:index];
    self.famBelastungField.text = text;
    
    index = self.detailItem.praenatDiag.integerValue;
    text = [[[Constants sharedInstance] praenatDiagValues] objectAtIndex:index];
    self.praenatDiagField.text = text;
  }
}


#pragma mark - Add new exam


//- (void)insertNewExam:(id)sender
//{
//  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//  NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//  Patient *newObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//  newObject.firstName = @"Neuer";
//  newObject.lastName = @"Patient";
//  
//  // Save the context.
//  NSError *error = nil;
//  if (![context save:&error]) {
//    // Replace this implementation with code to handle the error appropriately.
//    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//    abort();
//  }
//}


#pragma mark - Actions


- (IBAction)addButtonPressed:(id)sender {
#warning Imlement me!
  NSLog(@"add exam");
}


#pragma mark - View delegates


- (void)viewWillAppear:(BOOL)animated {
  [self configureView];
}


#pragma mark - Init


- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
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
