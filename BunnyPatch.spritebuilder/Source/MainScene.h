

#import <CCNode.h> 


@interface MainScene : CCNode <CCPhysicsCollisionDelegate>{
     CGFloat scrollSpeed;
     CGFloat firstTreePos;
     CGFloat distBtwnTrees;
    CGFloat bunnyHeight;
    CCSprite * bunny;
    CCPhysicsNode * physicsNode;
    CCNode* ground;
    CCNode * ground1;
    CCNode * background;
    CCNode * background1;

    NSArray * backgrounds;
    NSArray * grounds;
    NSMutableArray * trees;
    NSMutableArray * berries;
}

-(void) update:(CCTime)delta;
-(void)didLoadFromCCB;
- (void)spawnNewTrees;

@end
