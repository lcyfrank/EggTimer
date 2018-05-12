//
//  AppDelegate.m
//  EggTimer
//
//  Created by 林超阳 on 2018/5/12.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSMenuItem *startTimerMenuItem;
@property (weak) IBOutlet NSMenuItem *stopTimerMenuItem;
@property (weak) IBOutlet NSMenuItem *resetTimerMenuItem;

@end

@implementation AppDelegate

- (void)enableMenusOfStart:(BOOL)enableStart stop:(BOOL)enableStop reset:(BOOL)enableReset
{
    _startTimerMenuItem.enabled = enableStart;
    _stopTimerMenuItem.enabled = enableStop;
    _resetTimerMenuItem.enabled = enableReset;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self enableMenusOfStart:YES stop:NO reset:NO];
}

@end
