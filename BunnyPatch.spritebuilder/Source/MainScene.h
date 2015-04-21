

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
    CCLabelTTF * scoreLabel;
    CCSprite * cliffLeft;
    CCSprite * cliffRight;
    CCParticleSystem *smoke;
    
    NSArray * backgrounds;
    NSArray * grounds;
    NSMutableArray * trees;
    NSMutableArray * berries;
    
    BOOL gameStarted;
    BOOL foxhit;
    int score;
    
}

-(void) update:(CCTime)delta;
-(void)didLoadFromCCB;
- (void)spawnNewTrees;
-(void)play;
-(void)setGameOver;
-(void)restart;
-(void)removeBerries;
-(void)resetFox;
-(void)smokeOnOff:(BOOL) on;
@end
