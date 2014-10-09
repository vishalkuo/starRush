//
//  ManagerClass.m
//  SimpleGame
//
//  Created by Vishal Kuo on 2014-05-25.
//  Copyright (c) 2014 Vishal Kuo. All rights reserved.
//

#import "ManagerClass.h"

@implementation ManagerClass


/*
+ (id)sharedManager {
    static ManagerClass *sharedManagerClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManagerClass = [[self alloc] init];
    });
    return sharedManagerClass;
}
*/

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static ManagerClass *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[super alloc] init];
    });
    return _sharedInstance;
}



-(id) init{
    if(self = [super init]) {
        _score = 0;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id highScore = [defaults objectForKey:@"highScore"];
        if (highScore){
            _highScore = [highScore intValue];
        }
        
    }
    return self;
}

- (void) saveState
{

	_highScore = MAX(_score, _highScore);
	

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:_highScore] forKey:@"highScore"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)dealloc{
    
}

@end
