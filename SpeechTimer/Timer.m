//
//  TimerViewController.m
//  PianoControl
//
//  Created by sphota on 3/12/15.
//  Copyright (c) 2015 Lex Levi. All rights reserved.
//

#import "Timer.h"
#import "Summary.h"

@implementation Timer

#pragma mark - IBAction

- (IBAction)unwindToTimer:(UIStoryboardSegue *)unwindSegue
{
	/* persist session data */
}

- (IBAction)unwindToSessions:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)startButtonTapped:(id)sender
{
	isTimerStopped		= NO;
	isCountdownPaused	= NO;
	
	[_decibelTimer		invalidate];
	[_countdownTimer	invalidate];
	[_backgroundTimer	invalidate];
	[_recorder			stop];
	_recorder			= nil;
	decibels			= 0.0;
	minutes				= 0.0;
	currentMin			= 0;
	
	minutes				= [_practiceTimeTextField.text floatValue];
	currentMin			= minutes;
	currentSec			= 00;
	_timerLabel.text		= [NSString stringWithFormat:@"%d%@%02d",currentMin,@":",currentSec];
	
	[self startRecorderMonitoring];
	
	if (_hardcoreSwitch.on)
	{
		[self startTimer: YES];
	}
	else
	{
		[self startTimer: NO];
	}
	
	
	[self.practiceTimeTextField resignFirstResponder];
}

- (IBAction)quitButtonTapped:(id)sender
{
	isTimerStopped		= YES;
	
	[_decibelTimer		invalidate];
	[_countdownTimer	invalidate];
	[_backgroundTimer	invalidate];
	
	[_recorder			stop];
	_recorder = nil;
	
	[self performSegueWithIdentifier:@"toSummary" sender:self];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	/* A little setting/hack to be able write to /dev/null/ on a physical device */
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:NULL];
	
	[self.practiceTimeTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if( textField == self.practiceTimeTextField )
	{
		[self performSelector:@selector(startButtonTapped:) withObject:self afterDelay:0.0];
		return NO;
	}
	return YES;
}

#pragma mark - Recorder

- (void)startRecorderMonitoring // Set up recorder with settings, start recording and update decibel metering
{
	/* Recorder settings */
	NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];
	NSError* error = nil;
	_recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
	
	/* Start recorder */
	if (_recorder)
	{
		[_recorder prepareToRecord];
		_recorder.meteringEnabled = YES;
		[_recorder record];
		/* Update recorder meter */
		_decibelTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
														 target:self
													   selector:@selector(updateDecibels:)
													   userInfo:nil
														repeats:YES];
	} else
		NSLog(@"error with recorder");
}

- (void)updateDecibels:(NSTimer *) timer // Update the meter of the recorder every 0.03 seconds
{
	[_recorder updateMeters];
	decibels = [_recorder averagePowerForChannel:0];
	/* Strict supervision mode -> countdown only starts when a certain power level is detected */
	if (decibels > -20.0)
	{
		isCountdownPaused = NO;
	}
	else if (decibels < -20.0)
	{
		isCountdownPaused = YES;
	}
	NSLog(@"%f", decibels);
}

#pragma mark - Timer

- (void)startTimer:(BOOL) strictModeIsOn
{
	if (!strictModeIsOn) // If not in strict mode, fire concurrentbackground timer for tracking "productive" seconds
	{
		_backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
															target:self
														  selector:@selector(productiveTimerFired:)
														  userInfo:nil
														   repeats:YES];
	}
	
	/* Visible countdown */
	_countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
													   target:self
													 selector:@selector(timerCountdownFired:)
													 userInfo:[NSNumber numberWithBool:strictModeIsOn]
													  repeats:YES];
}

- (void)timerCountdownFired:(NSTimer *) timer; // Countdown for timer
{
	BOOL strictModeOn = [timer.userInfo boolValue];
	
	if (strictModeOn)
	{
		if (isCountdownPaused == NO)
		{
			[self updateCountdownWithLabel];
		}
	}
	else
	{
		[self updateCountdownWithLabel];
	}
}

- (void)productiveTimerFired:(NSTimer *) timer; // Runs in background and counts seconds when receiving noise at -14 lvl
{
	if (!isTimerStopped && !isCountdownPaused)
	{
		productiveElapsedSecs += 1;
		NSLog(@"%d", productiveElapsedSecs);
	}
}

- (void)updateCountdownWithLabel
{
	if((currentMin > 0 || currentSec >= 0) && currentMin >= 0)
	{
		if( currentSec == 0 )
		{
			currentMin -= 1;
			currentSec = 59;
		}
		else if( currentSec > 0 )
		{
			currentSec -= 1;
		}
		
		if(currentMin > -1)
			[_timerLabel setText:[NSString stringWithFormat:@"%d%@%02d",currentMin,@":",currentSec]];
	}
	else
	{
		[_countdownTimer invalidate];
		isTimerStopped = YES;
	}
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSString *identifier = segue.identifier;
	
	if ([identifier  isEqual: @"toSummary"]) {
		Summary *destination		= (Summary *)segue.destinationViewController;
		
		if (!_hardcoreSwitch.on)
		{ // Obtain the productive time measured in the background and pass to Summary view
			productiveElapsedMins	= productiveElapsedSecs / 60.0;
			percentage				= (productiveElapsedMins / (minutes - currentMin)) * 100;
			actualElapsedMinutes	= minutes - currentMin;
		}
		else
		{ // Obtain the productive time measured explicitly and pass to Summary view
			productiveElapsedMins	= minutes - currentMin;
			percentage				= productiveElapsedMins / minutes * 100;
			actualElapsedMinutes	= productiveElapsedMins;
		}
		
		destination.productiveElapsedMins	= productiveElapsedMins;
		destination.productivityPercentage	= percentage;
		destination.actualElapsedMinutes	= actualElapsedMinutes;
		destination.enteredMinutes			= minutes;
	}
}

#pragma mark - Aux methods

//- (BOOL) determineGender:(unsigned int) averageFreq
//{
//	if (avera) {
//		<#statements#>
//	}
//	return NO;
//}

@end
