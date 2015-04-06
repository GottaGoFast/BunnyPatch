@interface MainScene : CCNode{
     CGFloat scrollSpeed;
     CGFloat firstTreePos;
     CGFloat distBtwnTrees;
    CCSprite * bunny;
    CCPhysicsNode * physicsNode;
    CCNode* ground;
    CCNode * ground1;
    CCNode * background;
    CCNode * background1;
    CCNode * berry;
    CCNode * berry1;
    NSArray * backgrounds;
    NSArray * grounds;
    NSMutableArray * trees;
}

-(void) update:(CCTime)delta;
-(void)didLoadFromCCB;
- (void)spawnNewTrees;

@end
