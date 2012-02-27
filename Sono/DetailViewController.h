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

@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *patientIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *gebHeftTextField;
@property (weak, nonatomic) IBOutlet UITextField *famBelastungTextField;
@property (weak, nonatomic) IBOutlet UITextField *praenatDiagTextField;

@end
