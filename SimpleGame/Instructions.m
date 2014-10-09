//
//  Instructions.m
//  SimpleGame
//
//  Created by Vishal Kuo on 2014-06-01.
//  Copyright (c) 2014 Vishal Kuo. All rights reserved.
//

#import "Instructions.h"
#import "Menu.h"


@implementation Instructions
-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        SKNode *instructions = [SKSpriteNode spriteNodeWithImageNamed:@"Instructions.png"];
        instructions.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:instructions];
        
        
        SKNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow.png"];
        arrow.position = CGPointMake(CGRectGetMinX(self.frame)+40, CGRectGetMaxY(self.frame) - 35);
        arrow.name = @"arrow";
        [self addChild: arrow];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *menu = [touches anyObject];
    CGPoint menuLoc = [menu locationInNode:self];
    SKNode *menuNode = [self nodeAtPoint:menuLoc];
    
    
    if ([menuNode.name isEqualToString:@"arrow"]){
        
        SKTransition *reveal = [SKTransition crossFadeWithDuration:0.2];
        
        Menu *scene = [Menu sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
}

@end
