//
//  GameOverScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Köhler on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)size

{
    self = [super initWithSize:size];
    
    if (self) {
        
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameOverLabel.fontSize = 15;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        NSInteger lastGameScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastGameScore"];
        NSString *endString = [NSString stringWithFormat:@"Last Game: %lu anvils. Tap to start new game.", lastGameScore];
        gameOverLabel.text = endString;
        [self addChild:gameOverLabel];
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.size];
    [self.view presentScene:gameScene];
    
}

@end
