

#import <CCNode.h> 


@interface MainScene : CCNode <CCPhysicsCollisionDelegate>{
     CGFloat scrollSpeed;
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

    
    NSArray * backgrounds;
    NSArray * grounds;
    NSMutableArray * trees;
    NSMutableArray * berries;
    
}

-(void) update:(CCTime)delta;
-(void)didLoadFromCCB;
- (void)spawnNewTrees;

@end
