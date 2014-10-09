//
//  MyScene.m
//  SimpleGame
//
//  Created by Vishal Kuo on 2014-05-14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"
#import "Menu.h"
#import "ManagerClass.h"


#define scoreHudName @"scoreHud"
//Private player variable declaration

@interface MyScene() <SKPhysicsContactDelegate>{
    BOOL _gameOver;
    BOOL _reload;
    BOOL _reset;
    BOOL _redundancy;
    BOOL _safety;
    SKLabelNode *_clipSize;
}

@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) SKSpriteNode *pause;
@property (nonatomic) SKSpriteNode *play;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property NSUInteger score;
@property NSUInteger minSpeed;
@property NSUInteger maxSpeed;
@property NSUInteger addedSpeed;
@property NSUInteger clip;



@end

//P-hysics
static const uint32_t projectileCategory = 0x1 <<0;
static const uint32_t monsterCategory = 0x1 <<1;

//Vectors
static inline CGPoint rwAdd (CGPoint a, CGPoint b){
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b){
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a){
    return sqrt(a.x * a.x + a.y * a.y);
}

//Unit vector
static inline CGPoint rwNormalize (CGPoint a){
    float length = rwLength(a);
    return CGPointMake(a.x/length, a.y/length);
}



@implementation MyScene
{
    SKSpriteNode *_danger;
    NSArray *_dangerBGFrames;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        _minSpeed = 3;
        _maxSpeed = 7;
        _addedSpeed = 10;
        _clip = 4;
        //_reload = FALSE;
        _reset = FALSE;
        _redundancy = TRUE;
        _reload = FALSE;
        _safety = TRUE;
        [ManagerClass sharedInstance].score = 0;
        
        
        // Log screen touches
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        
        //bg call
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background.png"];
        background.position = CGPointMake(self.size.width/2 , self.size.height/2);
        [self addChild:background];
        
        //D-D-D-DangerZone!
        NSMutableArray *dangerFrames = [NSMutableArray array];
        SKTextureAtlas *dangerAtlas = [SKTextureAtlas atlasNamed:@"Danger"];
        
        int numImages = dangerAtlas.textureNames.count;
        for (int i=1; i<= numImages; i++){
            NSString *textureName = [NSString stringWithFormat:@"Danger%d", i];
            SKTexture *temp = [dangerAtlas textureNamed:textureName];
            [dangerFrames addObject:temp];
        }
        _dangerBGFrames = dangerFrames;
        
        SKTexture *temp = _dangerBGFrames[0];
        _danger = [SKSpriteNode spriteNodeWithTexture:temp];
        _danger.position = CGPointMake(CGRectGetMidX(self.frame) - 5, CGRectGetMidY(self.frame));
        [self addChild:_danger];
        [self movingDanger];
        
        // spawn
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        self.player.position = CGPointMake(self.player.size.width/2 + 15, self.frame.size.height/2);
        [self addChild:self.player];
        
        //Moar physics
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        self.pause = [SKSpriteNode spriteNodeWithImageNamed:@"Pause.png"];
        self.pause.position = CGPointMake(CGRectGetMinX(self.frame) + 25, CGRectGetMidY(self.frame)+140);
        self.pause.name = @"_pause";
        [self addChild:self.pause];
        
        //init play
        self.play = [SKSpriteNode spriteNodeWithImageNamed:@"Play.png"];
        self.play.position = CGPointMake(CGRectGetMinX(self.frame)+25, CGRectGetMidY(self.frame)+140);
        self.play.name = @"_play";
        self.play.hidden = YES;
        [self addChild:self.play];
       
        
        //Menu
        SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:@"Menu.png"];
        button.name = @"menu";
        button.position = CGPointMake(CGRectGetMinX(self.frame) + 70, CGRectGetMidY(self.frame) + 140);
        [self addChild:button];
        
        [self setupHud];

    }
    return self;
}

-(void)setupHud{
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
    scoreLabel.text = [NSString stringWithFormat:@"%i", [ManagerClass sharedInstance].score];
    scoreLabel.name = scoreHudName;
    scoreLabel.fontSize = 20;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+ 120);
    
    [self addChild:scoreLabel];
    //Ammo
    _clipSize = [SKLabelNode labelNodeWithFontNamed:@"8BITWONDERNominal"];
    _clipSize.text = [NSString stringWithFormat:@"Ammo left: %lu", (unsigned long)_clip];
    _clipSize.fontSize = 15;
    _clipSize.fontColor = [SKColor whiteColor];
    _clipSize.name = @"_lblClip";
    _clipSize.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+20);
    
    [self addChild:_clipSize];
    
    // Original Score Label
    /*
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
    
    scoreLabel.name = scoreHudName;
    scoreLabel.fontSize = 20;
    
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %04u", 0];
    
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 125);
    
    [self addChild:scoreLabel];
    */
    


}

-(void)movingDanger
{
    [_danger runAction:[SKAction repeatActionForever:
                        [SKAction animateWithTextures:_dangerBGFrames timePerFrame:1.0f resize:NO restore:YES]]withKey:@"dangerCheck"];
    return;
}


-(void)reloadMe{
    
    [self runAction:
     [SKAction sequence:@[
                          [SKAction waitForDuration:1.0],
                          [SKAction runBlock:^{
         [self reset];
     }]
                          ]]
     ];

    [_clipSize setText:[NSString stringWithFormat:@"Reloading"]];
    
}
-(void)reset{
    //_reload = FALSE;
    _reset = TRUE;
    _clip = 4;
    _redundancy = TRUE;
    _safety = TRUE;
    [_clipSize setText:[NSString stringWithFormat:@"Ammunition: %lu",(unsigned long)_clip]];;
}
-(void)addMonster{
    //Create enemy sprite
    SKSpriteNode * monster = [SKSpriteNode spriteNodeWithImageNamed:@"Alien"];
    
    //Enemy Spawn along Y-Axis
    int minY = monster.size.height/2;
    int maxY = self.frame.size.height - monster.size.height/2 * 2 - 20;
    //NSLog(@"%i %i", maxY, minY);
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    //Spawn enemy off screen (right side)
    
    monster.position = CGPointMake(self.frame.size.width + monster.size.width/2, actualY);
    
    [self addChild:monster];
    NSLog(@"Monster");
    
    //PHYSICS
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size];
    monster.physicsBody.dynamic = YES;
    monster.physicsBody.categoryBitMask = monsterCategory;
    monster.physicsBody.contactTestBitMask = projectileCategory;
    monster.physicsBody.collisionBitMask = 0;
    
    
    //Enemy speed
    
    
    
    long rangeDuration = _maxSpeed - _minSpeed;
    long actualSpeed = (arc4random() &rangeDuration) + _addedSpeed;
    
    if ([ManagerClass sharedInstance].score % 50 == 0) {
        _addedSpeed -= 1;
        if (_addedSpeed < 2){
            _addedSpeed = 2;
        }
    }
    
    //NSLog(@"%i",rangeDuration);
    //NSLog(@"%i", actualSpeed);
    
    
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, actualY) duration:actualSpeed];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * loseAction = [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition fadeWithDuration:0.2];
        [self endGame];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
        [self.view presentScene:gameOverScene transition: reveal];
    }];
    [monster runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
}
-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval >1){
        self.lastSpawnTimeInterval = 0;
        if (_safety == TRUE){
              [self addMonster];
        }
    }
    if (_redundancy) {
        if (_clip <1){
            [self reloadMe];
            _redundancy = FALSE;
        }
    }
    
    if (_play.hidden){
        _play.position = CGPointMake(0, 0);
    }
    else{
        _play.position = CGPointMake(CGRectGetMinX(self.frame) + 25, CGRectGetMidY(self.frame)+140);
    }
    if (_pause.hidden){
        _pause.position = CGPointMake(0, 0);
    }
    else{
        _pause.position = CGPointMake(CGRectGetMinX(self.frame) + 25, CGRectGetMidY(self.frame)+140);
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //Fire sound
    
    [self runAction:[SKAction playSoundFileNamed:@"Fire.mp3" waitForCompletion:NO]];
    
    //Touch type
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    //initial projectile position
    SKSpriteNode *projectile = [SKSpriteNode spriteNodeWithImageNamed:@"Missile"];
    projectile.position = self.player.position;
    
    //Fizzx
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = projectileCategory;
    projectile.physicsBody.contactTestBitMask = monsterCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    
    //offset
    CGPoint offset = rwSub(location, projectile.position);
    
    
    UITouch *setPause = [touches anyObject];
    CGPoint pauseLoc = [setPause locationInNode:self];
    SKNode *pauseNode = [self nodeAtPoint:pauseLoc];
    
    UITouch *resumeTouch = [touches anyObject];
    CGPoint resumeLoc = [resumeTouch locationInNode:self];
    SKNode *resumeNode = [self nodeAtPoint:resumeLoc];


    //safety
    if (offset.x <= 0){
        
        if([pauseNode containsPoint:_pause.position]){
            _safety = FALSE;
            _pause.hidden = YES;
            _play.hidden = NO;
            [self.view.scene setPaused:YES];
        }
        if ([resumeNode containsPoint:_play.position]){
            _play.hidden = YES;
            _pause.hidden = NO;
            [self.view.scene setPaused:NO];
            _safety = TRUE;
        }

        return;
    }
    
    //Reload Check
    
    //NSLog(@"%i",_reload);
    //NSLog(@"Clip: %lu", (unsigned long)_clip);

    if (_reset){
        _reset = FALSE;
    }
    //Add
    if (_clip > 0){
        if (_safety){
            _clip -= 1;
            //NSLog(@"%lu", (unsigned long)_clip);
            [self addChild:projectile];
            [_clipSize setText:[NSString stringWithFormat:@"Ammunition: %lu",(unsigned long)_clip]];
        }
        
    }
    
    
    //Direction
    CGPoint direction = rwNormalize(offset);
    
    //Get off screen
    CGPoint shootAmount = rwMult(direction, 1000);
    
    //Shoot amount + current position
    CGPoint realDest = rwAdd(shootAmount, projectile.position);
    
    //projectile action
    float velocity = 300.0/1.0;
    float realMoveDuration = self.size.width/velocity;
    SKAction * actionMove = [SKAction moveTo: realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
  
    
    //Force Reload
    UITouch *reloadTouch = [touches anyObject];
    CGPoint reloadLoc = [reloadTouch locationInNode:self];
    SKNode *reloadNode = [self nodeAtPoint:reloadLoc];
    
    if([reloadNode.name isEqualToString:@"_lblClip"]){
        if (_redundancy){
            if (_safety){
                _reload = TRUE;
                [self questionable];
                NSLog(@"reloaded");
                _redundancy = FALSE;
                _safety = FALSE;
            }
        }
        
    }
    
    
    
    
    

    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //Menu
    UITouch *menuTouch = [touches anyObject];
    CGPoint menuLoc = [menuTouch locationInNode:self];
    SKNode *menuNode = [self nodeAtPoint:menuLoc];
    
    if ([menuNode.name isEqualToString:@"menu"]) {
        
        SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
        
        Menu *menuScene = [Menu sceneWithSize:self.view.bounds.size];
        menuScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:menuScene transition:reveal];
    }
    
  
    
}

-(void)adujustScore:(NSUInteger)points {
    [ManagerClass sharedInstance].score += points;
    SKLabelNode* score = (SKLabelNode *)[self childNodeWithName:scoreHudName];
    score.text = [NSString stringWithFormat:@"%i", [ManagerClass sharedInstance].score];
}
-(void)questionable{
    if (_reload == TRUE){
        [self reloadMe];
        _reload = FALSE;
    }
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)monster {
    //NSLog(@"Hit");
    [projectile removeFromParent];
    [monster removeFromParent];
    
}


-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
    if ((firstBody.categoryBitMask & projectileCategory) != 0 && (secondBody.categoryBitMask & monsterCategory) !=0){
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
        [self adujustScore:10];
    }
}

-(void)endGame{
    _gameOver = YES;
    
    [[ManagerClass sharedInstance] saveState];
}

-(void)pauseGame{
    _pause.hidden = YES;
    [self.view.scene setPaused:YES];
    _play.hidden = NO;
}
-(void)resumeGame{
    _play.hidden = YES;
    [self.view.scene setPaused:NO];
    _pause.hidden = NO;
}

-(void)update:(NSTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1){
        timeSinceLast = 1.0/60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];

}

@end
