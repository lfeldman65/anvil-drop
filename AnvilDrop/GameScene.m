//
//  GameScene.m
//
//  Created by Larry Feldman


#import "GameScene.h"
#import "GameOverScene.h"


static const uint32_t anvilCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000


@interface GameScene()

@property (strong, nonatomic) NSTimer *blockTimer;

@end

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        self.physicsWorld.gravity = CGVectorMake(-1.0f, -1.0f);
        
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody;
        
      //  [ball.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
        
        SKSpriteNode* paddle = [[SKSpriteNode alloc] initWithImageNamed: @"paddle"];
        paddle.name = @"paddleCategoryName";
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 0.6f);
        [self addChild:paddle];
        paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
        paddle.physicsBody.restitution = 0.1f;
        paddle.physicsBody.friction = 0.4f;
        
        paddle.physicsBody.affectedByGravity = NO;
        paddle.physicsBody.contactTestBitMask = anvilCategory;
        
        CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        SKNode* bottom = [SKNode node];
        bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
        [self addChild:bottom];
        
        bottom.physicsBody.categoryBitMask = bottomCategory;
        paddle.physicsBody.categoryBitMask = paddleCategory;
        
        self.physicsWorld.contactDelegate = self;
        
        self.blockTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dropAnvil) userInfo:nil repeats:YES];
    }

    return self;
}



-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
   
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint previousLocation = [touch previousLocationInNode:self];
    // 3 Get node for paddle
    SKSpriteNode* player = (SKSpriteNode*)[self childNodeWithName: @"paddleCategoryName"];
    // 4 Calculate new position along x for paddle
    int playerX = player.position.x + (touchLocation.x - previousLocation.x);
    player.position = CGPointMake(playerX, player.position.y);
    
}

-(void)dropAnvil {
    
    SKSpriteNode* anvil = [SKSpriteNode spriteNodeWithImageNamed: @"anvil.png"];
    
    int minX = anvil.size.width / 2;
    int maxX = self.frame.size.width - anvil.size.width / 2;
    int rangeX = maxX - minX;
    int actualXStart = (arc4random() % rangeX) + minX;
    anvil.position = CGPointMake(actualXStart, self.frame.size.height*0.95f);
    anvil.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:anvil.frame.size];
    anvil.physicsBody.allowsRotation = NO;
    anvil.physicsBody.categoryBitMask = anvilCategory;
    anvil.physicsBody.contactTestBitMask = bottomCategory;
    [self addChild:anvil];

}



- (void)didBeginContact:(SKPhysicsContact*)contact {
    
    NSLog(@"here");
    
     if (contact.bodyA.categoryBitMask == anvilCategory && contact.bodyB.categoryBitMask == paddleCategory) {
        
        GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:gameOverScene];
        
    }
    
    if (contact.bodyA.categoryBitMask == paddleCategory && contact.bodyB.categoryBitMask == anvilCategory) {
        
        GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:gameOverScene];
        
    }
    
    if (contact.bodyA.categoryBitMask == anvilCategory && contact.bodyB.categoryBitMask == bottomCategory) {
        
        [contact.bodyA.node removeFromParent];

    }
    
    if (contact.bodyA.categoryBitMask == bottomCategory && contact.bodyB.categoryBitMask == anvilCategory) {
       
        [contact.bodyB.node removeFromParent];
        
    }

    
}


-(void)update:(CFTimeInterval)currentTime {  // roughly 30 frames per second
    
}

@end
