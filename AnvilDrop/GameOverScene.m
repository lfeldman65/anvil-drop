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

- (id)initWithSize:(CGSize)size playerWon:(BOOL)isWon
{
    self = [super initWithSize:size];
    
    if (self) {
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        // 1
        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameOverLabel.fontSize = 20;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        if (isWon) {
            gameOverLabel.text = @"Game Won. Tap to Start New Game";
        } else {
            gameOverLabel.text = @"Game Over. Tap to Start New Game.";
        }
        [self addChild:gameOverLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.size];
    [self.view presentScene:gameScene];
    
}

@end
