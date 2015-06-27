//
//  Summary.m
//  PianoControl
//
//  Created by sphota on 3/12/15.
//  Copyright (c) 2015 Lex Levi. All rights reserved.
//

#import "Summary.h"
#import "Sessions.h"

@implementation Summary

#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
	_enteredMinutesLabel.text		= [NSString stringWithFormat:@"%.01f", _enteredMinutes];
	_productivePercentageLabel.text = [NSString stringWithFormat:@"%.01f", _productivityPercentage];
	_productiveMinutesLabel.text	= [NSString stringWithFormat:@"%.01f", _productiveElapsedMins];
	_actualElapsedMinutesLabel.text = [NSString stringWithFormat:@"%.01f", _actualElapsedMinutes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

@end
