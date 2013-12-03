//
//  IDZTipViewController.m
//  codepath-tipcalculator
//
//  Created by Anthony Powles on 12/2/13.
//  Copyright (c) 2013 Anthony Powles. All rights reserved.
//

#import "IDZTipViewController.h"
#import "IDZSettingsViewController.h"

@interface IDZTipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UITextView *infoText;
@property (weak, nonatomic) IBOutlet UILabel *splitTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *splitAmountLabel;
@property (weak, nonatomic) IBOutlet UISlider *splitSlider;
@property (weak, nonatomic) IBOutlet UILabel *splitSliderLabel;

@property NSMutableArray *tipValues;

- (IBAction)onTap:(id)sender;
- (IBAction)onSplitChange:(UISlider *)sender;

- (void)updateValues;
- (void)updateInfos:(float)amount;
- (void)onSettingsButton;
- (void)loadSettings;

- (float)getTipPercent:(int)index;
- (void)updateCustomTipPercent:(int)value;
- (void)selectTip:(int)value;
- (void)resetSettings;
- (int)splitValue;

@end

@implementation IDZTipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = @"Tip Calculator";
		self.tipValues = [NSMutableArray arrayWithArray:@[@(0.1), @(0.15), @(0.2), @(0)]];
    }

	// for debug only
	//[self resetSettings];

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
	
	[self updateValues];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self loadSettings];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (IBAction)onTap:(id)sender
{
	[self.view endEditing:YES];
	[self updateValues];
}

- (IBAction)onSplitChange:(UISlider *)sender
{
	self.splitSliderLabel.text = [NSString stringWithFormat:@"%d", [self splitValue]];
	[self updateValues];
}

- (int)splitValue
{
	return round(self.splitSlider.value);
}

- (float)getTipPercent:(int)index
{
	return [self.tipValues[index] floatValue];
}

- (void)updateCustomTipPercent:(int)value
{
	[self.tipValues replaceObjectAtIndex:(self.tipValues.count - 1) withObject:@(value / 100.0)];

	NSString *customTipText = [NSString stringWithFormat:@"%d%%", value];
	
	int segmentCount = [self.tipControl numberOfSegments];
	
	if (segmentCount < 4) {
		[self.tipControl insertSegmentWithTitle:customTipText atIndex:segmentCount animated:NO];
	}
	else {
		[self.tipControl setTitle:customTipText forSegmentAtIndex:(segmentCount-1)];
	}
}

- (void)updateValues
{
	float billAmount = [self.billTextField.text floatValue];
	float tipPercent = [self getTipPercent:self.tipControl.selectedSegmentIndex];
	float tipAmount = billAmount * tipPercent;
	float totalAmount = billAmount + tipAmount;
    
	float splitTip = tipAmount / [self splitValue];
	float splitAmount = (billAmount / [self splitValue]) + splitTip;
    
	self.tipLabel.text = [NSString stringWithFormat:@"$%.2f", tipAmount];
	self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", totalAmount];
	self.tipPercentLabel.text = [NSString stringWithFormat:@"%.0f%%", tipPercent * 100];
	self.splitTipLabel.text = [NSString stringWithFormat:@"$%.2f", splitTip];
	self.splitAmountLabel.text = [NSString stringWithFormat:@"$%.2f", splitAmount];
	
	[self updateInfos:billAmount];
}

- (void)updateInfos:(float)amount
{
	NSMutableString *info = [[NSMutableString alloc] init];
	NSArray *sortedTips = [self.tipValues sortedArrayUsingSelector:@selector(compare:)];
	
	for (NSNumber *tipPercent in sortedTips) {
		float tipAmount = amount * [tipPercent floatValue];
		[info appendFormat:@"Tip %3.0f%% = $%0.2f\n", [tipPercent floatValue] * 100, tipAmount];
	}

	self.infoText.text = info;
}

- (void)onSettingsButton
{
	[self.navigationController pushViewController:[[IDZSettingsViewController alloc] init] animated:YES];
}

- (void)selectTip:(int)value
{
	int tipIndex = [self.tipValues indexOfObject:@(value/100.0)];
	[self.tipControl setSelectedSegmentIndex:tipIndex];
	[self updateValues];
}

- (void)loadSettings
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	int customTip = [defaults integerForKey:@"customTip"];
	[self updateCustomTipPercent:customTip];
	
	int defaultTip = [defaults integerForKey:@"defaultTip"];
	[self selectTip:defaultTip];
}

- (void)resetSettings
{
	NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
