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

#pragma mark - CoreData

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMM dd, YYYY"];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	
	/* Get the date today */
	NSString *dateToday = [formatter stringFromDate:[NSDate date]];
	/* Return context from delegate */
	NSManagedObjectContext *context = [self managedObjectContext];
	
	// Create a new managed object
	NSManagedObject *newSession = [NSEntityDescription insertNewObjectForEntityForName:@"Session"
																inManagedObjectContext:context];
	
	[newSession setValue:self.enteredMinutesLabel.text			forKey:@"enteredMins"];
	[newSession setValue:self.productivePercentageLabel.text	forKey:@"productivePercentage"];
	[newSession setValue:self.productiveMinutesLabel.text		forKey:@"productiveMins"];
	[newSession setValue:self.actualElapsedMinutesLabel.text	forKey:@"actualMins"];
	[newSession setValue:dateToday								forKey:@"date"];
	
	NSError *error = nil;
	// Save the object to persistent store
	if (![context save:&error]) {
		NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
	} else {
		NSLog(@"Successfully saved session");
	}
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
	self.enteredMinutesLabel.text		= [NSString stringWithFormat:@"%.01f", _enteredMinutes];
	self.productivePercentageLabel.text = [NSString stringWithFormat:@"%.01f", _productivityPercentage];
	self.productiveMinutesLabel.text	= [NSString stringWithFormat:@"%.01f", _productiveElapsedMins];
	self.actualElapsedMinutesLabel.text = [NSString stringWithFormat:@"%.01f", _actualElapsedMinutes];
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
