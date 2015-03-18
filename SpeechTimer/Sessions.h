//
//  FirstViewController.h
//  PianoControl
//
//  Created by sphota on 3/11/15.
//  Copyright (c) 2015 Lex Levi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Timer.h"

@interface Sessions : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sessions;

@property(nonatomic, assign) int productiveElapsedMins;
@property(nonatomic, assign) int productivityPercentage;
@property(nonatomic, assign) int enteredMins;
@property(nonatomic, assign) int actualElapsedMinutes;

@end

