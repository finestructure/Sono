//
//  MasterViewController.m
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "DataStore.h"
#import "IntroViewController.h"
#import "Patient.h"
#import "Patient+Additions.h"
#import "Utils.h"


@interface MasterViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSIndexPath *insertedIndexPath;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize introViewController = _introViewController;
@synthesize patients = _patients;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize insertedIndexPath = _insertedIndexPath;


- (void)showIntroViewControllerAnimated:(BOOL)animated {
  if (self.introViewController == nil) {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.introViewController = [sb instantiateViewControllerWithIdentifier:@"IntroViewController"];
  }
  UINavigationController *nc = [self.splitViewController.viewControllers lastObject];
  nc.viewControllers = [NSArray arrayWithObject:self.introViewController];
}


- (void)hideIntroViewController {
  if (self.introViewController != nil) {
    self.introViewController = nil;
    UINavigationController *nc = [self.splitViewController.viewControllers lastObject];
    nc.viewControllers = [NSArray arrayWithObject:self.detailViewController];
  }
}


- (void)awakeFromNib
{
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  self.navigationItem.leftBarButtonItem = self.editButtonItem;

  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
  self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
  
  NSArray *sortDescriptors = [NSArray arrayWithObjects:
                              [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES], 
                              [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES], 
                              nil];

  self.patients = [[DataStore sharedInstance] fetchEntity:@"Patient" sortDescriptor:sortDescriptors delegate:self];
  
  [self showIntroViewControllerAnimated:NO];
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


- (void)insertNewObject:(id)sender
{
  Patient *newObject = [[DataStore sharedInstance] insertNewObject:@"Patient"];
  newObject.firstName = @"Neuer";
  newObject.lastName = @"Patient";

  [self hideIntroViewController];
  self.detailViewController.detailItem = newObject;
  [self.detailViewController performSegueWithIdentifier:@"EditPatient" sender:self];
  if (self.masterPopoverController != nil) {
    [self.masterPopoverController dismissPopoverAnimated:YES];
  }        
}


#pragma mark - Split view


- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
  barButtonItem.title = @"Patienten";
  [self.introViewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
  [self.detailViewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
  self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  [self.introViewController.navigationItem setLeftBarButtonItem:nil animated:YES];
  [self.detailViewController.navigationItem setLeftBarButtonItem:nil animated:YES];
  self.masterPopoverController = nil;
}


#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.patients sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.patients sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
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
    [[DataStore sharedInstance] deleteObject:[self.patients objectAtIndexPath:indexPath]];

    NSError *error = nil;
    if (! [[DataStore sharedInstance] saveContext:&error]) {
      [[Utils sharedInstance] showError:error];
    }
  }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self hideIntroViewController];
  Patient *object = [self.patients objectAtIndexPath:indexPath];
  self.detailViewController.detailItem = object;
  [self.detailViewController.navigationController popToRootViewControllerAnimated:YES];  
  if (self.masterPopoverController != nil) {
    [self.masterPopoverController dismissPopoverAnimated:YES];
  }        
}


#pragma mark - NSFetchedResultsControllerDelegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      self.insertedIndexPath = newIndexPath;
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      if (self.patients.fetchedObjects.count == 0) {
        [self showIntroViewControllerAnimated:YES];
      }
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
  if (self.insertedIndexPath) {
    [self.tableView selectRowAtIndexPath:self.insertedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    self.insertedIndexPath = nil;
  }
}


/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Patient *p = [self.patients objectAtIndexPath:indexPath];
    cell.textLabel.text = p.fullName;
}


@end
