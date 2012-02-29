//
//  ExaminationViewController.h
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Examination;

@interface ExaminationViewController : UIViewController

@property (strong, nonatomic) Examination *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *patientDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *examinationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *examinerLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
