//
//  DateDropDown.m
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DateDropDown.h"

#import "DatePopupController.h"
#import "Utils.h"


@interface DateDropDown () {
  NSDate *_selectedDate;
}

@end


@implementation DateDropDown

@synthesize delegate = _delegate;
@synthesize popover = _popover;
@synthesize datePopupController = _datePopupController;


- (void)initialize {
  [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}


- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super initWithCoder:decoder];
  if (self) {
    [self initialize];
  }
  return self;
}


- (void)setSelectedDate:(NSDate *)selectedDate {
  NSString *title = [[Utils sharedInstance] shortDate:selectedDate];
  [self setTitle:title forState:UIControlStateNormal];
  [self setTitle:title forState:UIControlStateHighlighted];
  _selectedDate = selectedDate;
}


- (NSDate *)selectedDate {
  return _selectedDate;
}


#pragma mark - Action


- (void)buttonPressed:(id)sender {
  // hide keyboard if it's up
  [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

  self.datePopupController = [[DatePopupController alloc] initWithNibName:@"DatePopupController" bundle:nil];
  
  self.datePopupController.delegate = self;
  self.datePopupController.datePicker.date = self.selectedDate;
  
  self.popover = [[UIPopoverController alloc] initWithContentViewController:self.datePopupController];
  self.popover.delegate = self;
  self.popover.popoverContentSize = self.datePopupController.view.frame.size;
  [self.popover presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

  // keep button selected while the popover is up
  self.selected = YES;
}


#pragma mark - UIPopoverController delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  self.selected = NO;  
}


#pragma mark - DatePopupControllerDelegate


- (void)cancel:(id)sender {
  [self.popover dismissPopoverAnimated:YES];  
}


- (void)done:(id)sender {
  if ([self.delegate respondsToSelector:@selector(dateDropDown:didSelectDate:)]) {
    [self.delegate dateDropDown:self didSelectDate:self.datePopupController.datePicker.date];
  }
  [self.popover dismissPopoverAnimated:YES];
}


@end
