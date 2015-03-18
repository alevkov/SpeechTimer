//
//  TimerViewController.h
//  PianoControl
//
//  Created by sphota on 3/12/15.
//  Copyright (c) 2015 Lex Levi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol timerViewDelegate <NSObject>

@optional

- (void)userDidFinishLessonWithStats:(id)sender
			   productiveElapsedMins:(float)productiveMinutes
			  productivityPercentage:(float)percentage
					  enteredMinutes:(float)enteredMinutes
				actualElapsedMinutes:(float)actualMinutes;

@end

@interface Timer : UIViewController <UITextFieldDelegate>
{
	id summaryView;
	
	BOOL  isCountdownPaused;
	BOOL  isTimerStopped;
	
	float minutes, productiveElapsedMins, decibels, percentage, actualElapsedMinutes;
	int	  productiveElapsedSecs, currentMin, currentSec;
	
	AVAudioRecorder		*_recorder;
	NSTimer				*_countdownTimer, *_decibelTimer, *_backgroundTimer;
	NSString			*_minutesAsString;
}

@property (weak, nonatomic) IBOutlet UITextField *practiceTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel	 *timerLabel;
@property (weak, nonatomic) IBOutlet UISwitch	 *hardcoreSwitch;

@property (nonatomic, weak) id<timerViewDelegate> delegate;

- (void)startRecorderMonitoring;
- (void)updateDecibels:(NSTimer*) timer;
- (void)startTimer:(BOOL) strictModeIsOn;
- (void)timerCountdownFired:(NSTimer*) timer;
- (void)productiveTimerFired: (NSTimer *)timer;

@end
