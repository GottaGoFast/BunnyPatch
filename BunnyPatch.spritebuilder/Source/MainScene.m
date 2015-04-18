#import "MainScene.h"
#import "Berry.h"
#import <CCNode.h> 

@implementation MainScene



-(void)update:(CCTime)delta{
    NSLog(@"fox position is %f", self->fox.position.x);
    if (!gameStarted){
        return;
    }

    if (bunny.position.y < 0){
        NSLog(@"Bunny died");
        
        [self setGameOver];
        return;
    }

    
    physicsNode.position = ccp(physicsNode.position.x - scrollSpeed * delta, physicsNode.position.y);
    
    
    
    
    CGPoint foxWorldPostion = [physicsNode convertToWorldSpace:fox.position];
    CGPoint foxScreenPosition = [self convertToNodeSpace:foxWorldPostion];
    if(foxScreenPosition.x+50 < -(fox.contentSize.width)){
        fox.position = ccp(fox.position.x + 1200.f,100.f);
    }
    else if(foxScreenPosition.y < 20){
        [fox.physicsBody applyImpulse:ccp(500, 2000)];
    }
    else{
        
        fox.position = ccp(fox.position.x - scrollSpeed*(CGFloat) delta, fox.position.y);
    }
    
    
    CGPoint bunnyWorldPosition = [physicsNode convertToWorldSpace:bunny.position];
    CGPoint bunnyScreenPosition = [self convertToNodeSpace:bunnyWorldPosition];
    bunny.position = ccp(bunny.position.x + bunnySpeed*delta, bunny.position.y );
    if (bunnyScreenPosition.x > 400 && bunnyScreenPosition.y < 100) {
        scrollSpeed = 1.05*scrollSpeed;
    }
    else if (bunnyScreenPosition.x < 100){
        scrollSpeed = scrollConst;
    }
    
    
    
    
    //loop ground
    for ( CCSprite* n in grounds){
        CGPoint  groundWorldPosition = [physicsNode convertToWorldSpace:n.position];
        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
        int cliff_rand = 3; //arc4random_uniform((u_int32_t)4);
        int cliff_size = arc4random_uniform((u_int32_t)10) + 15;
        
        if (groundScreenPosition.x <= -1*n.contentSize.width) {
            NSLog(@"%f", n.position.x);

            n.position = ccp(n.position.x+n.contentSize.width*2, n.position.y);
            
            CGPoint  rCliffWorldPosition = [physicsNode convertToWorldSpace:cliffRight.position];
            
            CGPoint rCliffScreenPosition = [self convertToNodeSpace:rCliffWorldPosition];
           
            if (cliff_rand == 3 && rCliffScreenPosition.x <= -0.8*cliffRight.contentSize.width){
                [n setVisible:NO];
                n.physicsBody.sensor = YES;
                cliffLeft.position = ccp(n.position.x- 800 - cliff_size, n.position.y);
                cliffRight.position = ccp(n.position.x+ 300 + cliff_size, n.position.y);
            }
            
            else{
                [n setVisible:YES];
                n.physicsBody.sensor = NO;
            }
            
            
            
        }
        
    }
    

    for ( CCSprite* n in backgrounds){
        CGPoint  groundWorldPostion = [physicsNode convertToWorldSpace:n.position];
        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPostion];
        
        if (groundScreenPosition.x <= -1*n.contentSize.width*n.scaleX) {
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
    
    [self removeBerries];

    
    //don't allow double jumps on bunny
    CGFloat temp = bunny.position.y - bunny.contentSize.height/2;
    CGFloat temp2 = ground.position.y + ground.contentSize.height/2;
    
    if (temp <= temp2) {
        

        self.userInteractionEnabled = YES;


    }
    else{
        self.userInteractionEnabled = NO;
    }
    if (self->bunny.scale > .5 ) {
        self->bunny.scale = self->bunny.scale*.9995;
    }
}

-(void)removeBerries{
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
}

-(void)didLoadFromCCB{
    firstTreePos = 280.f;
    foxPos = 960.f;
    scrollSpeed = 80;
    scrollConst = 80;
    trees = [NSMutableArray array];
    grounds = [NSArray arrayWithObjects:ground, ground1, nil];
    backgrounds = [NSArray arrayWithObjects:background, background1, nil];
    gameStarted = NO;
    score = 0;
    [startButton setVisible:true];
}

-(void)play{
    gameStarted = YES;
    [startButton setVisible:false];
    [scoreLabel setVisible:true];
    
    cliffLeft = (CCSprite*)[CCBReader load:@"cliffLeft"];
    cliffRight = (CCSprite*)[CCBReader load:@"cliffRight"];
    cliffRight.scaleY = 2;
    cliffLeft.scaleY = 2;
    [physicsNode addChild:cliffRight];
    [physicsNode addChild:cliffLeft];

    
    
    bunny = (CCSprite*) [CCBReader load:@"Bunny"];
    bunny.scale = 0.5;
    [physicsNode addChild:bunny z:500];
    bunny.position = [self convertToNodeSpaceAR: ccp(100, 100) ];
    bunnySpeed = scrollSpeed;
    bunny.physicsBody.collisionType = @"bunny";
    
    
    self.userInteractionEnabled = YES;
    
    [self spawnNewTrees];
    [self spawnNewTrees];
    
    
    
    physicsNode.collisionDelegate = self;
    
   
    
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


-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny berry:(CCNode *)berry{
    

    [berry removeFromParent];
    [berries removeObject:berry];
    score = score + 1;
    NSLog(@"%f", self->bunny.contentSize.height);
    [scoreLabel setString:[NSString stringWithFormat:@"Current Score: %d",score]];
    if(self->bunny.scale < 0.9)
        self->bunny.scale = self->bunny.scale*1.05;
        [self->bunny setContentSizeInPoints: CGSizeMake(self->bunny.contentSize.width*1.05, self->bunny.contentSize.height*1.05)];
    return FALSE;
    
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny fox:(CCNode *)fox{
    if(abs(self->fox.position.y-self->bunny.position.y)/(self->fox.position.x-self->bunny.position.x)>0.3||self->bunny.position.x > self->fox.position.x){
        self->fox.position = ccp(self->fox.position.x + 1200.f,100.f);
        return TRUE;
    }
    else{
        [self->bunny removeFromParent];
        [restartButton setVisible:true];
    }
    
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
    
    [bunny.physicsBody applyImpulse:ccp(800, 2800)];
}

-(void)spawnNewFox{
    
    fox.position = ccp(foxPos, 40);
    

                   
}

-(void)spawnNewTrees{
    
    CCNode* prevTree = [trees lastObject];
    
    CGFloat prevTreeXPos = prevTree.position.x;
    
    distBtwnTrees = arc4random_uniform((u_int32_t)200)+ 400.f;
    
    if(!prevTree){
        prevTreeXPos = firstTreePos;
        
    }
    
    CCNode * newTree = [CCBReader load:@"Tree"];
    
    newTree.position = ccp(prevTreeXPos + distBtwnTrees, 100);
    newTree.scaleX = 1;
    newTree.scaleY = 1.4;
    
    [physicsNode addChild:newTree z: 8];
    [trees addObject: newTree];
    
    
    
    
    int numOfBerries = 2; //arc4random_uniform((u_int32_t)4);
    int lowerBoundX = -newTree.contentSize.width/2*newTree.scaleX+10;
    int upperBoundX = newTree.contentSize.width/2*newTree.scaleX-10;
    int lowerBoundY = -newTree.contentSize.height/2*newTree.scaleY+20;
    int upperBoundY = newTree.contentSize.height/2*newTree.scaleY-10;
    
    for (int i = 0; i<numOfBerries; i++) {
        Berry* berry = (Berry*)[CCBReader load:@"berry"];
        int rndValueX = lowerBoundX + arc4random() % (upperBoundX - lowerBoundX);
        int rndValueY = lowerBoundY + arc4random() % (upperBoundY - lowerBoundY);
        berry.scale = .4;
        berry.position = ccp(newTree.position.x+ rndValueX, newTree.position.y +rndValueY);
        
        berry.physicsBody.collisionType = @"berry";
        berry.physicsBody.sensor = YES;
        [physicsNode addChild:berry z: 9];
        [berries addObject: berry];
    }

    
}
-(void)setGameOver{
    [restartButton setVisible:YES];
    [self->fox removeFromParent];
    [self->bunny removeFromParent];
    self->gameStarted = NO;
}

@end
