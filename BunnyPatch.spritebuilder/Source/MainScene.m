#import "MainScene.h"
#import "Berry.h"
#import <CCNode.h> 

@implementation MainScene



-(void)update:(CCTime)delta{
    CGPoint bunnyWorldPosition = [physicsNode convertToWorldSpace:bunny.position];
    CGPoint bunnyScreenPosition = [self convertToNodeSpace:bunnyWorldPosition];

    
    physicsNode.position = ccp(physicsNode.position.x - scrollSpeed * delta, physicsNode.position.y);
    CGPoint foxWorldPostion = [physicsNode convertToWorldSpace:fox.position];
    CGPoint foxScreenPosition = [self convertToNodeSpace:foxWorldPostion];
     if(foxScreenPosition.x+50 < -(fox.contentSize.width)){
         fox.position = ccp(fox.position.x + 900.f,fox.position.y);
     }
     else{
         
         fox.position = ccp(fox.position.x - scrollSpeed*(CGFloat) delta, fox.position.y);
     }
    
    bunny.position = ccp(bunny.position.x + bunnySpeed*delta, bunny.position.y );
    if (bunnyScreenPosition.x > 400) {
        bunnySpeed = -scrollSpeed;
    }
    else if (bunnyScreenPosition.x < 100){
        bunnySpeed = scrollSpeed;
    }
    
    
    //loop ground
    for ( CCSprite* n in grounds){
        CGPoint  groundWorldPosition = [physicsNode convertToWorldSpace:n.position];
        //NSLog(@"%f", groundWorldPostion.y);

        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
 
        
        
        if (groundScreenPosition.x <= -1*n.contentSize.width) {
            n.position = ccp(n.position.x+n.contentSize.width*2, n.position.y);
            
        }
        
    }
    

    for ( CCSprite* n in backgrounds){
        CGPoint  groundWorldPostion = [physicsNode convertToWorldSpace:n.position];
        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPostion];
        
        if (groundScreenPosition.x <= -0.9*n.contentSize.width*n.scaleX) {
            n.position = ccp(n.position.x+n.contentSize.width*n.scaleX*2, n.position.y);
            
            
        }
    }
 
    
    
    //add new trees
    
    NSMutableArray * offScreenTrees = nil;
    for (CCNode* tree in trees){
        CGPoint treeWorldPostion = [physicsNode convertToWorldSpace:tree.position];
        CGPoint treeScreenPosition = [self convertToNodeSpace:treeWorldPostion];
        
        if(treeScreenPosition.x+50 < -(tree.contentSize.width)){
            if(!offScreenTrees){
                offScreenTrees = [NSMutableArray array];
                
            }
            [offScreenTrees addObject:tree];
        }
    }
    
    for(CCNode* treeToRemove in  offScreenTrees){
        [treeToRemove removeFromParent];
        [trees removeObject:treeToRemove];
        [self spawnNewTrees];
    }
    
    
    //take out berries that are no longer on screen
    NSMutableArray * offScreenBerries = nil;
    for (CCNode* berry in berries){
        CGPoint berryWorldPosition = [physicsNode convertToWorldSpace:berry.position];
        CGPoint berryScreenPosition = [self convertToNodeSpace:berryWorldPosition];
        
        if(berryScreenPosition.x+50 < -(berry.contentSize.width)){
            if(!offScreenBerries){
                offScreenBerries = [NSMutableArray array];
                
            }
            [offScreenBerries addObject:berry];
        }
    }
    
    for(CCNode* berryToRemove in  offScreenBerries){
        [berryToRemove removeFromParent];
        [berries removeObject:berryToRemove];
    }
    
    //don't allow double jumps on bunny
    CGFloat temp = bunny.position.y - bunny.contentSize.height/2;
    CGFloat temp2 = ground.position.y + ground.contentSize.height/2;
    
    if (temp <= temp2) {
        
        self.userInteractionEnabled = YES;

    }
    else{
        self.userInteractionEnabled = NO;
    }
    if (self->bunny.scale > .5) {
        self->bunny.scale = self->bunny.scale*.9999;
    }
}

-(void)didLoadFromCCB{
    firstTreePos = 280.f;
    foxPos = 960.f;
    scrollSpeed = 80;
    trees = [NSMutableArray array];
    grounds = [NSArray arrayWithObjects:ground, ground1, nil];
    backgrounds = [NSArray arrayWithObjects:background, background1, nil];
    
    [startButton setVisible:true];
    
    
}

-(void)play{
    [startButton setVisible:false];
    bunny = (CCSprite*) [CCBReader load:@"Bunny"];
    bunny.scale = 0.5;
    
    bunny.position = ccp(100, 100);
    [physicsNode addChild:bunny z:500];
    
    self.userInteractionEnabled = YES;
    
    [self spawnNewTrees];
    [self spawnNewTrees];
    
    bunnySpeed = scrollSpeed;
    
    physicsNode.collisionDelegate = self;
    
    bunny.physicsBody.collisionType = @"bunny";
    
    for(CCSprite * gr in  grounds){
        gr.physicsBody.collisionType = @"ground";
    }
    self->fox =  (CCSprite*)[CCBReader load:@"Fox"];
    [physicsNode addChild: fox z:10];
    [self spawnNewFox];
    fox.physicsBody.collisionType = @"fox";
    

}

-(void)restart{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    NSLog(@"now we are restarting");
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny ground:(CCNode *)ground{
    
    self.userInteractionEnabled = YES;
    return YES;
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny berry:(CCNode *)berry{
    

    [berry removeFromParent];
    [berries removeObject:berry];
    NSLog(@"%f", self->bunny.contentSize.height);
    if(self->bunny.scale < 0.9)
        self->bunny.scale = self->bunny.scale*1.05;
        [self->bunny setContentSizeInPoints: CGSizeMake(self->bunny.contentSize.width*1.05, self->bunny.contentSize.height*1.05)];
    return FALSE;
    
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny fox:(CCNode *)fox{
    
    [self->bunny removeFromParent];
    [restartButton setVisible:true];
    NSLog(@"fox touched bunny");
    return FALSE;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    self.userInteractionEnabled = NO;
   
    CCAnimationManager* animationManager = bunny.userObject;
    [animationManager runAnimationsForSequenceNamed:@"bunnyPrep"];
    
    
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CCAnimationManager* animationManager = bunny.userObject;
    [animationManager runAnimationsForSequenceNamed:@"bunnyHop"];
    
    [bunny.physicsBody applyImpulse:ccp(1000, 6000.f)];
}

-(void)spawnNewFox{
    
    fox.position = ccp(foxPos, 40);
    

                   
}

-(void)spawnNewTrees{
    
    CCNode* prevTree = [trees lastObject];
    
    CGFloat prevTreeXPos = prevTree.position.x;
    
    distBtwnTrees = arc4random_uniform((u_int32_t)200)+ 320.f;
    
    if(!prevTree){
        prevTreeXPos = firstTreePos;
        
    }
    
    CCNode * newTree = [CCBReader load:@"Tree"];
    
    newTree.position = ccp(prevTreeXPos + distBtwnTrees, 100);
    
    [physicsNode addChild:newTree z: 8];
    [trees addObject: newTree];
    
    
    Berry* berry = (Berry*)[CCBReader load:@"berry"];
    
    //[berry spawnNewBerries:newTree.position];
    berry.position = ccp(newTree.position.x-10, newTree.position.y-10);
    berry.physicsBody.collisionType = @"berry";
    berry.physicsBody.sensor = YES;
    [physicsNode addChild:berry z: 9];
    [berries addObject: berry];
    
}

@end
