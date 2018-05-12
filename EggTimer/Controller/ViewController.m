//
//  ViewController.m
//  EggTimer
//
//  Created by 林超阳 on 2018/5/12.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "EggTimer.h"
#import "Preferences.h"

static NSString *const kPrefsChangedNotification = @"PrefsChanged";

@interface ViewController () <EggTimerProtocol>

@property (weak) IBOutlet NSTextField *timeLeftField;
@property (weak) IBOutlet NSImageView *eggImageView;

@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSButton *resetButton;

@property (nonatomic, strong) EggTimer *eggTimer;
@property (nonatomic, strong) Preferences *prefs;


@end

@implementation ViewController

- (Preferences *)prefs
{
    if (_prefs == nil) {
        _prefs = [[Preferences alloc] init];
    }
    return _prefs;
}

- (EggTimer *)eggTimer {
    if (_eggTimer == nil) {
        _eggTimer = [[EggTimer alloc] init];
        _eggTimer.delegate = self;
    }
    return _eggTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureButtonsAndMenus];
    [self setupPrefs];
}

- (void)updateDisplayForTimeRemaining:(NSTimeInterval)timeRemaining {
    _timeLeftField.stringValue = [self textToDisplayForTimeRemaining:timeRemaining];
    _eggImageView.image = [self imageToDisplayForTimeRemaining:timeRemaining];
}

- (NSString *)textToDisplayForTimeRemaining:(NSTimeInterval)timeRemaining {
    if (timeRemaining == 0) {
        return @"Done!";
    }
    
    NSInteger minutesRemaining = timeRemaining / 60;
    CGFloat secondsRemaining = timeRemaining - (minutesRemaining * 60);
    
    NSString *secondsDisplay = [NSString stringWithFormat:@"%02ld", (long)secondsRemaining];
    NSString *timeRemainingDisplay = [NSString stringWithFormat:@"%ld:%@", (long)minutesRemaining, secondsDisplay];
    
    return timeRemainingDisplay;
}

- (NSImage *)imageToDisplayForTimeRemaining:(NSTimeInterval)timeRemaining {
    CGFloat percentageComplete = 100 - (timeRemaining / self.prefs.selectedTime * 100);
    
    if ([self.eggTimer isStopped]) {
        NSString *stoppedImageName = timeRemaining == 0 ? @"100" : @"stopped";
        return [NSImage imageNamed:stoppedImageName];
    }
    
    NSString *imageName = nil;
    if (percentageComplete >= 0 && percentageComplete < 25) {
        imageName = @"0";
    } else if (percentageComplete < 50) {
        imageName = @"25";
    } else if (percentageComplete < 75) {
        imageName = @"50";
    } else if (percentageComplete < 100) {
        imageName = @"75";
    } else {
        imageName = @"100";
    }
    
    return [NSImage imageNamed:imageName];
}

- (IBAction)startButtonClicked:(id)sender {
    if ([self.eggTimer isPaused]) {
        [self.eggTimer resumeTimer];
    } else {
        self.eggTimer.duration = self.prefs.selectedTime;
        [self.eggTimer startTimer];
    }
    [self configureButtonsAndMenus];
    
}
- (IBAction)stopButtonClicked:(id)sender {
    [self.eggTimer stopTimer];
    [self configureButtonsAndMenus];
    
}
- (IBAction)resetButtonClicked:(id)sender {
    [self.eggTimer resetTimer];
    [self updateDisplayForTimeRemaining:self.prefs.selectedTime];
    [self configureButtonsAndMenus];
}

- (IBAction)startTimerMenuItemSelected:(id)sender {
    [self startButtonClicked:self];
}

- (IBAction)stopTimerMenuItemSelected:(id)sender {
    [self stopButtonClicked:self];
}

- (IBAction)resetTimerMenuItemSelected:(id)sender {
    [self resetButtonClicked:self];
}

- (void)timeRemainingOnTimer:(EggTimer *)timer timeRemaining:(NSTimeInterval)remaining {
    [self updateDisplayForTimeRemaining:remaining];
}

- (void)timerHasFinished:(EggTimer *)timer {
    [self updateDisplayForTimeRemaining:0];
    [self configureButtonsAndMenus];
}

- (void)configureButtonsAndMenus {
    BOOL enableStart;
    BOOL enableStop;
    BOOL enableReset;
    
    if ([self.eggTimer isStopped]) {
        enableStart = YES;
        enableStop = NO;
        enableReset = NO;
    } else if ([self.eggTimer isPaused]) {
        enableStart = YES;
        enableStop = NO;
        enableReset = YES;
    } else {
        enableStart = NO;
        enableStop = YES;
        enableReset = NO;
    }
    
    _startButton.enabled = enableStart;
    _stopButton.enabled = enableStop;
    _resetButton.enabled = enableReset;
    
    [((AppDelegate *)[[NSApplication sharedApplication] delegate]) enableMenusOfStart:enableStart stop:enableStop reset:enableReset];
}

- (void)setupPrefs {
    [self updateDisplayForTimeRemaining:self.prefs.selectedTime];
    
    NSNotificationName notificationName = [NSNotification notificationWithName:kPrefsChangedNotification object:nil].name;
    [[NSNotificationCenter defaultCenter] addObserverForName:notificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//        [self updateFromPrefs];
        [self checkForResetAfterPrefsChange];
    }];
}

- (void)updateFromPrefs {
    self.eggTimer.duration = self.prefs.selectedTime;
    [self resetButtonClicked:self];
}

- (void)checkForResetAfterPrefsChange {
    if ([self.eggTimer isStopped] || [self.eggTimer isPaused]) {
        [self updateFromPrefs];
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Reset timer with the new settings?";
        alert.informativeText = @"This will stop your current timer!";
        alert.alertStyle = NSAlertStyleWarning;
        
        [alert addButtonWithTitle:@"Reset"];
        [alert addButtonWithTitle:@"Cancel"];
        
        NSModalResponse response = alert.runModal;
        if (response == NSAlertFirstButtonReturn) {
            [self updateFromPrefs];
        }
    }
}

@end
