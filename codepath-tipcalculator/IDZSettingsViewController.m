//
//  IDZSettingsViewController.m
//  codepath-tipcalculator
//
//  Created by Anthony Powles on 02/12/13.
//  Copyright (c) 2013 Anthony Powles. All rights reserved.
//

#import "IDZSettingsViewController.h"

@interface IDZSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *defaultTipTextField;
@property (weak, nonatomic) IBOutlet UITextField *customTipTextField;

- (void)onDoneButton;
- (void)updateSettings;
- (void)loadSettings;

@end

@implementation IDZSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = @"Settings";
	}

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDoneButton)];
	
	[self loadSettings];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)onDoneButton
{
	[self updateSettings];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSettings
{
	int defaultTip = [self.defaultTipTextField.text intValue];
	int customTip = [self.customTipTextField.text intValue];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:defaultTip forKey:@"defaultTip"];
	[defaults setInteger:customTip forKey:@"customTip"];
	[defaults synchronize];
}

- (void)loadSettings
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	int defaultTip = [defaults integerForKey:@"defaultTip"];
	self.defaultTipTextField.text = [NSString stringWithFormat:@"%d", defaultTip];

	int customTip = [defaults integerForKey:@"customTip"];
	self.customTipTextField.text = [NSString stringWithFormat:@"%d", customTip];
}

@end
