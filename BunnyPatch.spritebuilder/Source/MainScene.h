

#import <CCNode.h> 


@interface MainScene : CCNode <CCPhysicsCollisionDelegate>{
     CGFloat scrollSpeed;
    CGFloat scrollConst;
     CGFloat firstTreePos;
    CGFloat foxPos;
     CGFloat distBtwnTrees;
    CGFloat bunnyHeight;
    CGFloat bunnySpeed;
    CCSprite * bunny;
    CCPhysicsNode * physicsNode;
    CCSprite * ground;
    CCSprite * ground1;
    CCSprite * background;
    CCSprite * background1;
    CCSprite * fox;
    CCButton * startButton;
    CCButton * restartButton;

    CCSprite * cliffLeft;
    CCSprite * cliffRight;
    
    NSArray * backgrounds;
    NSArray * grounds;
    NSMutableArray * trees;
    NSMutableArray * berries;
    
    BOOL gameStarted;
    
}

-(void) update:(CCTime)delta;
-(void)didLoadFromCCB;
- (void)spawnNewTrees;
-(void)play;
-(void)setGameOver;
-(void)restart;
@end
