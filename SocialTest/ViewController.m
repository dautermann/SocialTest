//
//  ViewController.m
//  SocialTest
//
//  Created by Michael Dautermann on 2/28/13.
//  Copyright (c) 2013 Michael Dautermann. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import "OurServiceObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)displayErrorAlert: (NSString *)alertMessage
{
    // suprise, I don't have any delegate methods defined :-)
    UIAlertView * anAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message: alertMessage delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil];
    
    NSLog(@"%@", alertMessage);
    [anAlert show];
}

- (void)viewDidLoad
{
    NSString * errorMsg;

    [super viewDidLoad];

    // how to determine if Social framework is available?
    // let's check to see if the class exists
    //
    // http://stackoverflow.com/questions/3057325/osx-weak-linking-check-if-a-class-exists-and-use-that-class
    if([SLComposeViewController class])
    {
        OurServiceObject * newService;
        NSMutableArray * arrayOfAvailableServices = [[NSMutableArray alloc] init];
        BOOL isAvailable = [SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter];
        if(isAvailable)
        {
            newService = [[OurServiceObject alloc] init];
            newService.type = SLServiceTypeTwitter;
            newService.name = @"Twitter";
            [arrayOfAvailableServices addObject: newService]; 
        }

        isAvailable = [SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook];
        if(isAvailable)
        {
            newService = [[OurServiceObject alloc] init];
            newService.type = SLServiceTypeFacebook;
            newService.name = @"Facebook";

            [arrayOfAvailableServices addObject: newService];
        }
        
        isAvailable = [SLComposeViewController isAvailableForServiceType: SLServiceTypeSinaWeibo];
        if(isAvailable)
        {
            newService = [[OurServiceObject alloc] init];
            newService.type = SLServiceTypeSinaWeibo;
            newService.name =  @"Sina Weibo";
            
            [arrayOfAvailableServices addObject: newService];
        }

        // I suspect other services will magically appear when iOS 7 is previewed at the next WWDC
        
        if([arrayOfAvailableServices count] == 0)
        {
            errorMsg = @"You need to set up some social network accounts in order to make practical use of this app.";
        } else {
            // mutable becomes immutable
            availableServices = arrayOfAvailableServices;
        }
    } else {
        // throw an alert, or do older social network specific stuff (e.g. Facebook SDK, Twitter SDK, etc.)
        errorMsg = @"You need to run this on an iOS 6 device or simulator";
        
        NSLog( @"this device or simulator apparently doesn't have Social.framework available to it" );
    }
        
    if(errorMsg)
    {
        // suprise, I don't have any delegate methods defined :-)
        [bringUpComposeViewButton setEnabled: NO];
        [self displayErrorAlert: errorMsg];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark picker methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(availableServices)
        return([availableServices count]);
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // I'm not too worried about null checking this because we'd only request rows for existing
    // entries in the availableServices array
    OurServiceObject * sObject = [availableServices objectAtIndex: row];
    return(sObject.name);
}

#pragma mark compose methods

- (IBAction) bringUpComposeView: (id) sender
{
    if([availableServices count] > 0)
    {
        OurServiceObject * sObject = [availableServices objectAtIndex: [servicePicker selectedRowInComponent: 0]];
        SLComposeViewController * composeVC = [SLComposeViewController composeViewControllerForServiceType: sObject.type];
        if(composeVC)
        {
            // assume everything validates
            BOOL success = YES;
            
#pragma warning I should probably de-conditionalize this
#if 0
            if(sObject.type == SLServiceTypeTwitter)
            {
                success = [composeVC setInitialText: @"NSChat could have a drawing where people try to guess how many names Silly has used over the years. It could be like trying to count jellybeans in a glass vase."];
                if(success == NO)
                {
                    [self displayErrorAlert: @"this error hits because Twitter has 160 characters limit"];
                }
            }
#endif
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    NSLog(@"Cancelled");
                    
                } else
                    
                {
                    NSLog(@"Post");
                }
                
                [composeVC dismissViewControllerAnimated:YES completion:Nil];
            };
            
            composeVC.completionHandler =myBlock;
            
            if(success)
            {
                [self presentViewController: composeVC animated: YES completion: nil];
            }
        }
    } else {
        [self displayErrorAlert: @"why isn't the compose view button disabled if there are zero available services?"];
    }
}


@end
