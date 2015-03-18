//
//  Summary.h
//  PianoControl
//
//  Created by sphota on 3/12/15.
//  Copyright (c) 2015 Lex Levi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timer.h"

@interface Summary : UIViewController <timerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *enteredMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualElapsedMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *productiveMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *productivePercentageLabel;

@property (nonatomic, assign) float productiveElapsedMins;
@property (nonatomic, assign) float productivityPercentage;
@property (nonatomic, assign) float enteredMinutes;
@property (nonatomic, assign) float actualElapsedMinutes;

@end
