//
//  DropdownButton.m
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DropdownButton.h"


@interface DropdownButton () {
  NSInteger _selectedRow;
}
@end



@implementation DropdownButton

@synthesize popover = _popover;
@synthesize values = _values;
@synthesize pickerContentWidth = _pickerContentWidth;
@synthesize delegate = _delegate;


- (void)initialize {
  self.values = [NSArray array];
  self.pickerContentWidth = self.frame.size.width;
//  [self setBackgroundImage:[UIImage imageNamed:@"dropdown_button"] forState:UIControlStateNormal];
//  [self setBackgroundImage:[UIImage imageNamed:@"dropdown_button_pressed"] forState:UIControlStateHighlighted];
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


- (void)setSelectedRow:(NSInteger)aRow {
  NSString *title = [self.values objectAtIndex:aRow];
  [self setTitle:title forState:UIControlStateNormal];
  [self setTitle:title forState:UIControlStateHighlighted];
  _selectedRow = aRow;
}


- (NSInteger)selectedRow {
  return _selectedRow;
}


#pragma mark - Action


- (void)buttonPressed:(id)sender {
  UIViewController *vc = [[UIViewController alloc] init];
  
  UIPickerView *picker = [[UIPickerView alloc] init];
  [vc.view addSubview:picker];
  picker.delegate = self;
  picker.dataSource = self;
  picker.showsSelectionIndicator = YES;
  [picker selectRow:_selectedRow inComponent:0 animated:NO];
  CGRect frame = picker.frame;
  frame.size.width = self.pickerContentWidth + 30;
  picker.frame = frame;
  CGSize contentSize = picker.frame.size;
  
  self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
  self.popover.delegate = self;
  self.popover.popoverContentSize = contentSize;
  [self.popover presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
  // keep button selected while the popover is up
  self.selected = YES;
}


#pragma mark - UIPopoverController delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  self.selected = NO;  
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [self.values objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if ([self.delegate respondsToSelector:@selector(dropdownButton:didSelectRow:inComponent:)]) {
    [self.delegate dropdownButton:self didSelectRow:row inComponent:component];
  }
//  [self.popover dismissPopoverAnimated:YES];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  return self.pickerContentWidth;
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return self.values.count;
}


@end
