//
//  About.m
//  SimpleGame
//
//  Created by Vishal Kuo on 2014-06-01.
//  Copyright (c) 2014 Vishal Kuo. All rights reserved.
//

#import "About.h"
#import "Menu.h"


@implementation About
-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        
        SKNode *bgInfo = [SKSpriteNode spriteNodeWithImageNamed:@"SpaceBG.png"];
        bgInfo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:bgInfo];
        
        SKNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow.png"];
        arrow.position = CGPointMake(CGRectGetMinX(self.frame)+40, CGRectGetMidY(self.frame));
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
