//
//  PrefsViewController.m
//  QQVideo
//
//  Created by 林超阳 on 2018/5/11.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "PrefsViewController.h"
#import "Preferences.h"

static NSString *const kPrefsChangedNotification = @"PrefsChanged";

@interface PrefsViewController ()

@property (weak) IBOutlet NSPopUpButton *presetsPopup;
@property (weak) IBOutlet NSSlider *customSlider;
@property (weak) IBOutlet NSTextField *customTextField;

@property (nonatomic, strong) Preferences *prefs;

@end

@implementation PrefsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showExistingPrefs];
}

- (Preferences *)prefs
{
    if (_prefs == nil) {
        _prefs = [[Preferences alloc] init];
    }
    return _prefs;
}

- (void)showExistingPrefs {
    NSInteger selectedTimeInMinutes = (NSInteger)([self prefs].selectedTime) / 60;
    
    [_presetsPopup selectItemWithTitle:@"Custom"];
    _customSlider.enabled = YES;
    
    for (NSMenuItem *item in _presetsPopup.itemArray) {
        if (item.tag == selectedTimeInMinutes) {
            [_presetsPopup selectItem:item];
            _customSlider.enabled = NO;
            break;
        }
    }
    
    _customSlider.integerValue = selectedTimeInMinutes;
    [self showSliderValueAsText];
}

- (void)showSliderValueAsText {
    NSInteger newTimerDuration = [_customSlider integerValue];
    NSString *minutesDescription = (newTimerDuration == 1) ? @"minute" : @"minutes";
    _customTextField.stringValue = [NSString stringWithFormat:@"%ld %@", (long)newTimerDuration, minutesDescription];
}

- (void)saveNewPrefs {
    self.prefs.selectedTime = _customSlider.doubleValue * 60;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPrefsChangedNotification object:nil];
}

- (IBAction)popupValueChanged:(NSPopUpButton *)sender {
    if ([[sender selectedItem].title isEqualToString:@"Custom"]) {
        _customSlider.enabled = YES;
        return;
    }
    
    NSInteger newTimerDuration = sender.selectedTag;
    _customSlider.integerValue = newTimerDuration;
    [self showSliderValueAsText];
    _customSlider.enabled = NO;
}

- (IBAction)sliderValueChanged:(id)sender {
    [self showSliderValueAsText];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.view.window close];
}

- (IBAction)okButtonClicked:(id)sender {
    [self saveNewPrefs];
    [self.view.window close];
}


@end
