//
//  EditExaminationViewController.h
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DateDropDown.h"

@class Examination;
@class RoundedView;


@interface EditExaminationViewController : UIViewController<DateDropdownDelegate>

@property (strong, nonatomic) Examination *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *patientDescriptionLabel;
@property (weak, nonatomic) IBOutlet DateDropDown *examinationDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UITextField *heightField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UITextField *examinerField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet RoundedView *boundingBox;

- (IBAction)saveButtonPressed:(id)sender;
- (void)backButtonPressed:(id)sender;
- (IBAction)editingChanged:(id)sender;
- (IBAction)editingDidBegin:(id)sender;

@end
