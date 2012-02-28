//
//  DropdownButton.h
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropdownButton;


@protocol DropdownButtonDelegate <NSObject>

- (void)dropdownButton:(DropdownButton *)dropdownButton didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end


@interface DropdownButton : UIButton<UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate>

@property (nonatomic, weak) id<DropdownButtonDelegate> delegate;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) NSArray *values;
@property (assign) CGFloat pickerContentWidth;
@property (assign) NSInteger selectedRow;

@end
