//
//  ViewController.h
//  SocialTest
//
//  Created by Michael Dautermann on 2/28/13.
//  Copyright (c) 2013 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource>
{
    NSArray * availableServices;
    IBOutlet UIButton * bringUpComposeViewButton;
    IBOutlet UIPickerView * servicePicker;
}

- (IBAction) bringUpComposeView: (id) sender;


@end
