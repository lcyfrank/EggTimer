//
//  Preferences.m
//  QQVideo
//
//  Created by 林超阳 on 2018/5/11.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "Preferences.h"

#define kSelectedTime @"selectedTime"


@implementation Preferences

- (NSTimeInterval)selectedTime
{
    NSInteger savedTime = [[NSUserDefaults standardUserDefaults] doubleForKey:kSelectedTime];
    if (savedTime > 0) {
        return savedTime;
    }
    return 360;
}

- (void)setSelectedTime:(NSTimeInterval)selectedTime
{
    [[NSUserDefaults standardUserDefaults] setDouble:selectedTime forKey:kSelectedTime];
}

@end
