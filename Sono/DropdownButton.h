//
//  DropdownButton.h
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdownButton : UIButton<UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate>

@property (nonatomic, weak) id<UIPickerViewDelegate> delegate;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) NSArray *values;
@property (assign) CGFloat pickerContentWidth;

- (void)selectIndex:(NSUInteger)index;

@end
