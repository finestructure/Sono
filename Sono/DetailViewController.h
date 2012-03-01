//
//  DetailViewController.h
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Patient.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Patient *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *lastNameField;
@property (weak, nonatomic) IBOutlet UILabel *firstNameField;
@property (weak, nonatomic) IBOutlet UILabel *birthDateField;
@property (weak, nonatomic) IBOutlet UILabel *patientIdField;
@property (weak, nonatomic) IBOutlet UILabel *gebHeftField;
@property (weak, nonatomic) IBOutlet UILabel *famBelastungField;
@property (weak, nonatomic) IBOutlet UILabel *praenatDiagField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)insertNewObject:(id)sender;

@end
