//
//  GameOverScene.m
//  SimpleGame
//
//  Created by Vishal Kuo on 2014-05-14.
//  Copyright (c) 2014 Vishal Kuo. All rights reserved.
//



#import "GameOverScene.h"
#import "MyScene.h"
#import "ManagerClass.h"
#import "Menu.h"

@implementation GameOverScene

-(id)initWithSize:(CGSize)size won:(BOOL)won {
    if (self = [super initWithSize:size]) {
        
        
        SKSpriteNode *loseBG = [SKSpriteNode spriteNodeWithImageNamed:@"MenuBG.jpg" ];
        loseBG.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:loseBG];
        
        //  lose text
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
        label.text = [NSString stringWithFormat:@"Your score was: %i", [ManagerClass sharedInstance].score];
        label.fontSize = 20;
        label.fontColor = [SKColor whiteColor];
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
        
        
        //Play Again
        SKLabelNode *playAgain = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
        playAgain.text = [NSString stringWithFormat:@"Play Again"];
        playAgain.fontSize = 20;
        playAgain.name = @"playAgain";
        playAgain.fontColor = [SKColor whiteColor];
        playAgain.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 25);
        [self addChild:playAgain];
        /*
        // 4
        [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:3.0],
                              [SKAction runBlock:^{
             // 5
             SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
             SKScene * myScene = [[MyScene alloc] initWithSize:self.size];
             [self.view presentScene:myScene transition: reveal];
         }]
                              ]]
         ];
     */
        
        
        SKLabelNode *menu = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
        menu.text = [NSString stringWithFormat:@"Menu"];
        menu.fontSize = 20;
        menu.name = @"menu";
        menu.fontColor = [SKColor whiteColor];
        menu.position = CGPointMake (CGRectGetMidX(self.frame) + 220, CGRectGetMidY(self.frame) + 120);
        [self addChild:menu];
        
        
        SKLabelNode *highScore = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
        highScore.fontSize = 20;
        highScore.fontColor = [SKColor whiteColor];
        highScore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 20);
        highScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        highScore.text = [NSString stringWithFormat:@"Your High score is: %d", [ManagerClass sharedInstance].highScore];
        [self addChild:highScore];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //Replay
    SKTransition *reveal = [SKTransition crossFadeWithDuration:0.2];
    UITouch *gameTouch = [touches anyObject];
    CGPoint gameLoc = [gameTouch locationInNode:self];
    SKNode *gameNode = [self nodeAtPoint:gameLoc];
    
    if ([gameNode.name isEqualToString:@"playAgain"]) {
        MyScene *gameScene = [MyScene sceneWithSize:self.view.bounds.size];
        gameScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:gameScene transition:reveal];
    }
    
    //Menu
    UITouch *menuTouch = [touches anyObject];
    CGPoint menuLoc = [menuTouch locationInNode:self];
    SKNode *menuNode = [self nodeAtPoint:menuLoc];
    
    if ([menuNode.name isEqualToString:@"menu"]){
        Menu *menuScene = [Menu sceneWithSize:self.view.bounds.size];
        menuScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:menuScene transition:reveal];
    }
}

@end

