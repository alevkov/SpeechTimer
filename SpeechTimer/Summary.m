//
//  Summary.m
//  PianoControl
//
//  Created by sphota on 3/12/15.
//  Copyright (c) 2015 Lex Levi. All rights reserved.
//

#import "Summary.h"

@implementation Summary

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
	_enteredMinutesLabel.text		= [NSString stringWithFormat:@"%.02f", _enteredMinutes];
	_productivePercentageLabel.text = [NSString stringWithFormat:@"%.02f", _productivityPercentage];
	_productiveMinutesLabel.text	= [NSString stringWithFormat:@"%.02f", _productiveElapsedMins];
	_actualElapsedMinutesLabel.text = [NSString stringWithFormat:@"%.02f", _actualElapsedMinutes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end