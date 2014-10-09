//
//  ViewController.m
//  SimpleGame
//
//  Created by Vishal Kuo on 2014-05-14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "Menu.h"
@import AVFoundation;

@interface ViewController()
@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@end

@implementation ViewController



- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //music
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"SpaceFinal" withExtension:@".mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];

    SKView * skView = (SKView *)self.view;
    if (!skView.scene){
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        SKScene * scene = [Menu sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [skView presentScene:scene];
    }
    
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
