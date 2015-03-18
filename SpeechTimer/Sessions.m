//
//  FirstViewController.m
//  PianoControl
//
//  Created by sphota on 3/11/15.
//  Copyright (c) 2015 Lex Levi. All rights reserved.
//

#import "Sessions.h"
#import "Summary.h"
#import "Timer.h"

@implementation Sessions

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
	cell.textLabel.text = [_sessions objectAtIndex:indexPath.row];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[_sessions removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:@"toSummary" sender:self];
}

#pragma mark - Presentation

- (void)presentTimerView
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMM dd, YYYY"];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	
	/* Get the date today */
	NSString *dateToday = [formatter stringFromDate:[NSDate date]];
	/* Add the date to the session array */
	[_sessions addObject:dateToday];
	
	NSString * storyBoardName = @"Main";
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle: nil];
	UIViewController * timer = [storyboard instantiateViewControllerWithIdentifier:@"timer"];
	[self presentViewController:timer animated:YES completion:nil];
}

@end
