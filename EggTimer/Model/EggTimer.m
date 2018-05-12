//
//  EggTimer.m
//  QQVideo
//
//  Created by 林超阳 on 2018/5/11.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "EggTimer.h"

@implementation EggTimer

- (BOOL)isStopped {
    return _timer == nil && _elapsedTime == 0;
}

- (BOOL)isPaused {
    return _timer == nil && _elapsedTime > 0;
}

- (void)startTimer {
    _startTime = [NSDate date];
    _elapsedTime = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self timerAction];
}

- (void)resumeTimer {
    _startTime = [NSDate dateWithTimeIntervalSinceNow:-_elapsedTime];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self timerAction];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self timerAction];
}

- (void)resetTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _startTime = nil;
    _duration = 360;
    _elapsedTime = 0;
    
    [self timerAction];
}

- (void)timerAction {
    
    if (_startTime == nil) {
        return;
    }
    _elapsedTime = -[_startTime timeIntervalSinceNow];
    
    NSTimeInterval secondsRemaining = _duration - _elapsedTime;
    if (secondsRemaining <= 0) {
        [self resetTimer];
        if (self.delegate && [self.delegate respondsToSelector:@selector(timerHasFinished:)]) {
            [self.delegate timerHasFinished:self];
        }
    } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeRemainingOnTimer:timeRemaining:)]) {
                [self.delegate timeRemainingOnTimer:self timeRemaining:secondsRemaining];
            }
    }
}




@end
