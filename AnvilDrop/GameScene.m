//
//  GameScene.m
//
//  Created by Larry Feldman
//  http://www.raywenderlich.com/49721/how-to-create-a-breakout-game-using-spritekit


#import "GameScene.h"
#import "GameOverScene.h"


static const uint32_t anvilCategory  = 0x1 << 0; // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t playerCategory = 0x1 << 3; // 00000000000000000000000000001000


@interface GameScene()

@property (strong, nonatomic) NSTimer *blockTimer;

@end

@implementation GameScene

double gravityMag;
NSInteger numAnvils;

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        NSLog(@"here");
        gravityMag = -.5;
        numAnvils = 0;
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg2.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        self.physicsWorld.gravity = CGVectorMake(0.0f, gravityMag);
        
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

        self.physicsBody = borderBody;
        
      //  [ball.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
        
        SKSpriteNode* player = [[SKSpriteNode alloc] initWithImageNamed: @"player.png"];
        player.name = @"playerCategoryName";
        player.position = CGPointMake(CGRectGetMidX(self.frame), player.frame.size.height * 0.6f);
        [self addChild:player];
        player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.frame.size];
        player.physicsBody.affectedByGravity = NO;
        player.physicsBody.contactTestBitMask = anvilCategory;
        player.physicsBody.categoryBitMask = playerCategory;
        
        CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        SKNode* bottom = [SKNode node];
        bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
        bottom.physicsBody.restitution = 0;
        [self addChild:bottom];
        bottom.physicsBody.categoryBitMask = bottomCategory;
        bottom.physicsBody.contactTestBitMask = anvilCategory;

        self.physicsWorld.contactDelegate = self;
        
        self.blockTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dropAnvil) userInfo:nil repeats:YES];
    }

    return self;
}



-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
   
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    SKSpriteNode *player = (SKSpriteNode*)[self childNodeWithName: @"playerCategoryName"];
    int playerX = player.position.x + (touchLocation.x - previousLocation.x);
    player.position = CGPointMake(playerX, player.position.y);
    
}

-(void)dropAnvil {
    
    
   // gravityMag = gravityMag - 1.0;
    self.physicsWorld.gravity = CGVectorMake(0.0f, gravityMag);
    SKSpriteNode* anvil = [SKSpriteNode spriteNodeWithImageNamed: @"anvil.png"];
    int minX = anvil.size.width / 2;
    int maxX = self.frame.size.width - anvil.size.width / 2;
    int rangeX = maxX - minX;
    int actualXStart = (arc4random() % (rangeX + 1)) + minX;
    anvil.position = CGPointMake(actualXStart, self.frame.size.height*0.95f);
    anvil.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:anvil.frame.size];
    anvil.physicsBody.allowsRotation = NO;
    anvil.physicsBody.categoryBitMask = anvilCategory;
    anvil.physicsBody.contactTestBitMask = bottomCategory;
    anvil.physicsBody.restitution = 0;
    anvil.physicsBody.density = 1000.0;
    [self addChild:anvil];

}



- (void)didBeginContact:(SKPhysicsContact*)contact {
    
     if (contact.bodyA.categoryBitMask == anvilCategory && contact.bodyB.categoryBitMask == playerCategory) {
        
         [self endGame];
    }
    
    if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == anvilCategory) {
        
        [self endGame];
        
    }
    
    if (contact.bodyA.categoryBitMask == anvilCategory && contact.bodyB.categoryBitMask == bottomCategory) {
        
        numAnvils++;
        NSLog(@"num anvils A %lu", numAnvils);
        [contact.bodyA.node removeFromParent];

    }
    
    if (contact.bodyA.categoryBitMask == bottomCategory && contact.bodyB.categoryBitMask == anvilCategory) {
       
        numAnvils++;
        NSLog(@"num anvils B %lu", numAnvils);
        [contact.bodyB.node removeFromParent];
        
    }

    
}

- (void) endGame {
    
    NSLog(@"end Game");
    [[NSUserDefaults standardUserDefaults] setInteger:numAnvils forKey:@"lastGameScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.blockTimer invalidate];
    GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:gameOverScene];

}

-(void)update:(CFTimeInterval)currentTime {  // roughly 30 frames per second
    
}

@end
