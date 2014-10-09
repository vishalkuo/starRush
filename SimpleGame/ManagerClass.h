//
//  ManagerClass.h
//  SimpleGame
//
//  Created by Vishal Kuo on 2014-05-25.
//  Copyright (c) 2014 Vishal Kuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerClass : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;

+ (instancetype)sharedInstance;
-(void)saveState;

@end
