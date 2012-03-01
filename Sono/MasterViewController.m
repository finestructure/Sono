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
@property (strong, nonatomic) NSIndexPath *insertedIndexPath;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize patients = _patients;
@synthesize insertedIndexPath = _insertedIndexPath;


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
  
  // select first row (if available)
  if (self.patients.fetchedObjects.count > 0) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    Patient *object = [self.patients objectAtIndexPath:indexPath];
    self.detailViewController.detailItem = object;
  } else {
    // or show intro screen
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    IntroViewController *vc = [sb instantiateViewControllerWithIdentifier:@"IntroViewController"];
    [self.detailViewController.navigationController pushViewController:vc animated:NO];
  }
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
  // get rid of intro view controller if it's up
  if ([self.detailViewController.navigationController.topViewController isKindOfClass:[IntroViewController class]]) {
    [self.detailViewController.navigationController popViewControllerAnimated:NO];
  }
  
  Patient *newObject = [[DataStore sharedInstance] insertNewObject:@"Patient"];
  newObject.firstName = @"Neuer";
  newObject.lastName = @"Patient";

  self.detailViewController.detailItem = newObject;
  [self.detailViewController performSegueWithIdentifier:@"EditPatient" sender:self];
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
  Patient *object = [self.patients objectAtIndexPath:indexPath];
  self.detailViewController.detailItem = object;
  [self.detailViewController.navigationController popToRootViewControllerAnimated:YES];
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
    [self.tableView selectRowAtIndexPath:self.insertedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
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
