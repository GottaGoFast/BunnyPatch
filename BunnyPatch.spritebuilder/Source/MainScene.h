

#import <CCNode.h> 


@interface MainScene : CCNode <CCPhysicsCollisionDelegate>{
     CGFloat scrollSpeed;
     CGFloat firstTreePos;
    CGFloat foxPos;
     CGFloat distBtwnTrees;
    CGFloat bunnyHeight;
    CCSprite * bunny;
    CCPhysicsNode * physicsNode;
    CCNode* ground;
    CCNode * ground1;
    CCNode * background;
    CCNode * background1;
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
