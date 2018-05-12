//
//  EggTimer.h
//  QQVideo
//
//  Created by 林超阳 on 2018/5/11.
//  Copyright © 2018 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EggTimer;
@protocol EggTimerProtocol <NSObject>

- (void)timeRemainingOnTimer:(EggTimer *)timer timeRemaining:(NSTimeInterval)remaining;
- (void)timerHasFinished:(EggTimer *)timer;

@end

@interface EggTimer : NSObject

@property (nonatomic, weak) id <EggTimerProtocol> delegate;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

- (BOOL)isStopped;
- (BOOL)isPaused;

- (void)startTimer;
- (void)resumeTimer;
- (void)stopTimer;
- (void)resetTimer;

@end
