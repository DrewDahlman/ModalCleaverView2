/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//
//  Created by Randy McMillan on 5/9/12.
//  Copyright OpenOSX.org 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cleaverViewController.h"



#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.420 green:0.420 blue:0.420 alpha:1.000]
#define BARBUTTON(TITLE, SELECTOR) 	[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define IS_IPAD        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)









#pragma mark Custom Modal View Controller
@interface ModalViewController : UIViewController
- (IBAction)done:(id)sender;
@end

@implementation ModalViewController
- (IBAction)done:(id)sender {[self dismissModalViewControllerAnimated:YES];}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {return YES;}
@end







#pragma mark Primary Controller
@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void) action: (id) sender
{
    
    
    

    
    
    // Load info controller from storyboard
    NSString *sourceName = IS_IPAD ? @"Modal~iPad" : @"Modal~iPhone";
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sourceName bundle:[NSBundle mainBundle]];
    
    
    
    // Select the transition style
	int styleSegment = [(UISegmentedControl *)self.navigationItem.titleView selectedSegmentIndex];
    NSLog(@"styleSegment = %i",styleSegment);
	int transitionStyles[3] = {/*UIModalTransitionStyleCoverVertical,*/ UIModalTransitionStyleCrossDissolve, UIModalTransitionStyleFlipHorizontal, UIModalTransitionStylePartialCurl};
    
     UINavigationController *navController = [sb instantiateViewControllerWithIdentifier:@"infoNavigationController"];
        NSLog(@"%@",navController);

      
	navController.modalTransitionStyle = transitionStyles[styleSegment];
	
	// Select the presentation style for iPad only
	if (IS_IPAD)
	{
		int presentationSegment = [(UISegmentedControl *)[[self.view subviews] lastObject] selectedSegmentIndex];
		int presentationStyles[3] = {UIModalPresentationFullScreen, UIModalPresentationPageSheet, UIModalPresentationFormSheet};
        
		if (navController.modalTransitionStyle == UIModalTransitionStylePartialCurl)
		{
			// Partial curl with any non-full screen presentation raises an exception
			navController.modalPresentationStyle = UIModalPresentationFullScreen;
			[(UISegmentedControl *)[[self.view subviews] lastObject] setSelectedSegmentIndex:0];
		}
		else 
			navController.modalPresentationStyle = presentationStyles[presentationSegment];
	}
    
    
    
    
    
    
    
    if (styleSegment == 3)
    {
        NSLog(@"TRUE styleSegment = %i",styleSegment);

        CDVViewController* cleaverViewController = [CDVViewController new];
            cleaverViewController.wwwFolderName = @"www";
            cleaverViewController.startPage = @"page1.html";
            cleaverViewController.modalPresentationStyle = navController.modalPresentationStyle;
    
        CGRect viewBounds = [[UIScreen mainScreen] bounds];
        int x = 100;//viewBounds.size.width * .5;
        int y = viewBounds.size.width * .5;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self 
                   action:@selector(closeCleaverView:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Close Cleaver View" forState:UIControlStateNormal];
        button.frame = CGRectMake(x, y, 160.0, 40.0);
        button.center = cleaverViewController.view.center ;
        [cleaverViewController.view addSubview:button];
        [navController.view addSubview:cleaverViewController.view];
        [navController.view bringSubviewToFront:cleaverViewController.view];
       // [self.navigationController presentModalViewController:navController animated:YES];

        
    }
    else
    {
    
       // [self.navigationController presentModalViewController:navController animated:YES];

    
    }
    
    [self.navigationController presentModalViewController:navController animated:YES];

    

}













- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action:));
    
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[@"Fade Flip Curl Cleaver" componentsSeparatedByString:@" "]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl setSelectedSegmentIndex:3];
	self.navigationItem.titleView = segmentedControl;
    
    
    
    CDVViewController* cleaverViewController = [CDVViewController new];
    cleaverViewController.wwwFolderName = @"www";
    cleaverViewController.startPage = @"index.html";
    
    //CGRect viewBounds = [[UIScreen mainScreen] bounds];
    //int x = 100;//viewBounds.size.width * .5;
    //int y = viewBounds.size.width * .5;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(closeCleaverView:)
     forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"Close Cleaver View" forState:UIControlStateNormal];
    //button.frame = CGRectMake(x, y, 160.0, 40.0);
    //button.center = cleaverViewController.view.center ;
    //[cleaverViewController.view addSubview:button];
    [self.view addSubview:cleaverViewController.view];
    [self.view bringSubviewToFront:cleaverViewController.view];
    // [self.navigationController presentModalViewController:navController animated:YES];
    
    
    
    if (IS_IPAD)
	{
		NSArray *presentationChoices = [NSArray arrayWithObjects:@"Full Screen", @"Page Sheet", @"Form Sheet", nil];
		UISegmentedControl *iPadStyleControl = [[UISegmentedControl alloc] initWithItems:presentationChoices];
		iPadStyleControl.segmentedControlStyle = UISegmentedControlStyleBar;
		iPadStyleControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        iPadStyleControl.center = CGPointMake(CGRectGetMidX(self.view.bounds), 22.0f);
        [iPadStyleControl setSelectedSegmentIndex:2];

//        [iPadStyleControl.selectedSegmentIndex:1];
		[self.view addSubview:iPadStyleControl];
	}
}




-(void)closeCleaverView:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"closeCleaverView");
    
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
@end










#pragma mark -


#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
}
@end

@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    [application setStatusBarHidden:YES];
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    window.rootViewController = nav;
	[window makeKeyAndVisible];
    return YES;
}
@end












int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}