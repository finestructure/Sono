//
//  DetailViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DetailViewController.h"

#import "EditExaminationViewController.h"
#import "EditPatientViewController.h"
#import "ExaminationViewController.h"
#import "Constants.h"
#import "Utils.h"
#import "Examination.h"
#import "DataStore.h"


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
@synthesize tableView = _tableView;
@synthesize masterPopoverController = _masterPopoverController;


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
    self.birthDateField.text = [[Utils sharedInstance] shortDate:self.detailItem.birthDate];
    self.patientIdField.text = self.detailItem.patientId;
    self.gebHeftField.text = self.detailItem.gebheftId;
    
    NSInteger index = self.detailItem.famBelastung.integerValue;
    NSString *text = [[[Constants sharedInstance] booleanValues] objectAtIndex:index];
    self.famBelastungField.text = text;
    
    index = self.detailItem.praenatDiag.integerValue;
    text = [[[Constants sharedInstance] praenatDiagValues] objectAtIndex:index];
    self.praenatDiagField.text = text;
    
    [self.tableView reloadData];
  }
}


#pragma mark - View delegates


- (void)viewWillAppear:(BOOL)animated {
  [self configureView];
}


#pragma mark - Init


- (void)viewDidLoad
{
  [super viewDidLoad];
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
  [self setTableView:nil];
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
	if ([segue.identifier isEqualToString:@"EditPatient"]) {
    NSLog(@"segue EditPatient");
    EditPatientViewController *vc = segue.destinationViewController;
    vc.detailItem = self.detailItem;
  } else if ([segue.identifier isEqualToString:@"ShowExamination"]) {
    NSLog(@"segue ShowExamination");
    ExaminationViewController *vc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    vc.detailItem = [self.detailItem.examinations objectAtIndex:indexPath.row];
  } else if ([segue.identifier isEqualToString:@"NewExamination"]) {
    NSLog(@"segue NewExamination");
    Examination *newObject = [[DataStore sharedInstance] insertNewObject:@"Examination"];
    newObject.examinationDate = [NSDate date];
    [self.detailItem addExaminationsObject:newObject];

    EditExaminationViewController *vc = segue.destinationViewController;
    vc.detailItem = newObject;
    
    [self.tableView reloadData];    
  }
}


#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSOrderedSet *e = self.detailItem.examinations;
  return e.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.detailItem removeObjectFromExaminationsAtIndex:indexPath.row];

    NSError *error = nil;
    if (! [[DataStore sharedInstance] saveContext:&error]) {
      [[Utils sharedInstance] showError:error];
    }
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return NO;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  Examination *e = [self.detailItem.examinations objectAtIndex:indexPath.row];
  cell.textLabel.text = [[Utils sharedInstance] mediumDate:e.examinationDate];
}


@end
