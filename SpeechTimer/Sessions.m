//
//  FirstViewController.m
//  PianoControl
//
//  Created by sphota on 3/11/15.
//  Copyright (c) 2015 Lex Levi. All rights reserved.
//

#import "Sessions.h"
#import "Timer.h"

#define ENTERED_TAG 1
#define DATE_TAG 2
#define ACTUAL_TAG 3

@implementation Sessions

#pragma mark - CoreData

- (NSManagedObjectContext *)managedObjectContext
{
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

#pragma mark - IBAction

- (IBAction)addButtonTapped:(id)sender
{
	[self presentTimerView];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	/* Init sessions array */
	_sessions = [NSMutableArray new];
	
	/* Table view set up */
	_tableView.frame = self.view.frame;
	_tableView.allowsMultipleSelectionDuringEditing = NO;
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
	NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Session"];
	self.sessions = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
	
	[_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_sessions count];
}

- (NSInteger)numberOfSections
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *sessionTableCellIdentifier = @"session";
	
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:sessionTableCellIdentifier];
	
	if (cell != nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sessionTableCellIdentifier];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *session = [self.sessions objectAtIndex:indexPath.row];
	
	UILabel *enteredMinutesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(cell.contentView.frame)+30.0, CGRectGetMidY(cell.contentView.frame), 220.0, 15.0)];
	UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(cell.contentView.frame), CGRectGetMidY(cell.contentView.frame), 220.0, 15.0)];
	UILabel *actualMinutesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.contentView.frame)-35.0, CGRectGetMidY(cell.contentView.frame), 220.0, 15.0)];
	
	enteredMinutesLabel.tag = ENTERED_TAG;
	enteredMinutesLabel.font = [UIFont systemFontOfSize:14.0];
	enteredMinutesLabel.textColor = [UIColor blackColor];
	enteredMinutesLabel.text = [NSString stringWithFormat:@"Entered: %@", [session valueForKey:@"enteredMins"]];
	[cell.contentView addSubview:enteredMinutesLabel];
	
	dateLabel.tag = DATE_TAG;
	dateLabel.font = [UIFont systemFontOfSize:14.0];
	dateLabel.textColor = [UIColor blackColor];
	dateLabel.text = [session valueForKey:@"date"];
	[cell.contentView addSubview:dateLabel];
	
	actualMinutesLabel.tag = ACTUAL_TAG;
	actualMinutesLabel.font = [UIFont systemFontOfSize:14.0];
	actualMinutesLabel.textColor = [UIColor blackColor];
	actualMinutesLabel.text = [NSString stringWithFormat:@"Productive: %@%%", [session valueForKey:@"productivePercentage"]];
	[cell.contentView addSubview:actualMinutesLabel];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Elapsed: %@", [session valueForKey:@"actualMins"]];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObjectContext *context = [self managedObjectContext];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[context deleteObject:[self.sessions objectAtIndex:indexPath.row]];
		
		NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
			return;
		}
		
		[self.sessions removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - Presentation

- (void)presentTimerView
{
	NSString * storyBoardName = @"Main";
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle: nil];
	UIViewController * timer = [storyboard instantiateViewControllerWithIdentifier:@"timer"];
	[self presentViewController:timer animated:YES completion:nil];
}

@end
