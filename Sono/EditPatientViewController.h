//
//  PatientEditViewController.h
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Patient.h"
#import "DropdownButton.h"
#import "DateDropDown.h"


@interface EditPatientViewController : UIViewController<DropdownButtonDelegate>

@property (strong, nonatomic) Patient *detailItem;

@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientIdField;
@property (weak, nonatomic) IBOutlet UITextField *gebHeftField;
@property (weak, nonatomic) IBOutlet DropdownButton *famBelastungPicker;
@property (weak, nonatomic) IBOutlet DropdownButton *praenatDiagPicker;
@property (weak, nonatomic) IBOutlet DateDropDown *birthDatePicker;

- (IBAction)saveButtonPressed:(id)sender;

@end
