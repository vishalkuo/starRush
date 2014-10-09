//
//  Menu.m
//  SimpleGame
//
//  Created by Vishal Kuo on 2014-05-16.
//  Copyright (c) 2014 Vishal Kuo. All rights reserved.
//

#import "Menu.h"
#import "MyScene.h"
#import "About.h"
#import "ManagerClass.h"
#import "Instructions.h"
@implementation Menu
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"MenuBG.jpg"];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:background];

        SKLabelNode *playButton = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        playButton.name = @"start";
        playButton.fontColor = [SKColor whiteColor];
        playButton.fontSize = 30;
        playButton.text = [NSString stringWithFormat:@"Play"];
        
        [self addChild:playButton];
        
        SKLabelNode *aboutButton = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
        aboutButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) +50);
        aboutButton.name = @"about";
        aboutButton.fontSize = 20;
        aboutButton.fontColor = [SKColor whiteColor];
        aboutButton.text = [NSString stringWithFormat:@"About"];
        
        [self addChild:aboutButton];
        
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
        highScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 20);
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        highScoreLabel.fontColor = [SKColor whiteColor];
        highScoreLabel.fontSize = 15;
        highScoreLabel.text = [NSString stringWithFormat:@"Your highscore is: %d", [ManagerClass sharedInstance].highScore];
        
        [self addChild:highScoreLabel];
        
        SKNode *title = [SKSpriteNode spriteNodeWithImageNamed:@"StarRush.png"];
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 90);
        [self addChild:title];
        
        SKLabelNode *instructions = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
        instructions.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-30);
        instructions.fontSize = 20;
        instructions.fontColor = [SKColor whiteColor];
        instructions.text = [NSString stringWithFormat:@"Instructions"];
        instructions.name = @"_lblInstruct";
        [self addChild:instructions];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touchStart = [touches anyObject];
    CGPoint locationStart = [touchStart locationInNode:self];
    SKNode *nodeStart = [self nodeAtPoint:locationStart];
    SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
    
    if ([nodeStart.name isEqualToString:@"start"]) {
        
       
        
        MyScene *scene = [MyScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
    
    UITouch *aboutTouch = [touches anyObject];
    CGPoint aboutLoc = [aboutTouch locationInNode:self];
    SKNode *aboutNode = [self nodeAtPoint:aboutLoc];
    
    if ([aboutNode.name isEqualToString:@"about"]) {
        About *scene = [About sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
    
    UITouch *instructions = [touches anyObject];
    CGPoint instructLoc = [instructions locationInNode:self];
    SKNode *instructNode = [self nodeAtPoint:instructLoc];
    
    if ([instructNode.name isEqualToString:@"_lblInstruct"]){
        Instructions *scene = [Instructions sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
}

@end