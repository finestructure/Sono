//
//  DateDropDown.h
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DropdownButton.h"

#import "DatePopupController.h"

@class DateDropDown;


@protocol DateDropdownDelegate <NSObject>

- (void)dateDropDown:(DateDropDown *)dateDropDown didSelectDate:(NSDate *)date;

@end


@interface DateDropDown : UIButton <DatePopupControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, weak) id<DateDropdownDelegate> delegate;
@property (nonatomic, retain) UIPopoverController *popover;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) DatePopupController *datePopupController;

@end
