//
//  PatientEditViewController.h
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Patient.h"

@interface EditPatientViewController : UIViewController

@property (strong, nonatomic) Patient *detailItem;

@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *birthDateField;
@property (weak, nonatomic) IBOutlet UITextField *patientIdField;
@property (weak, nonatomic) IBOutlet UITextField *gebHeftField;
@property (weak, nonatomic) IBOutlet UITextField *famBelastungField;
@property (weak, nonatomic) IBOutlet UITextField *praenatDiagField;

@end
