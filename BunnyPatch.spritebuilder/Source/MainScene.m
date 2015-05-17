#import "MainScene.h"
#import "Berry.h"
#import <CCNode.h> 

@implementation MainScene



-(void)update:(CCTime)delta{
    //NSLog(@"fox position is %f", self->fox.position.x);
    CGPoint foxWorldPostion = [physicsNode convertToWorldSpace:fox.position];
    CGPoint foxScreenPosition = [self convertToNodeSpace:foxWorldPostion];

    
    if (!gameStarted){
        if (foxScreenPosition.x > 300){
            physicsNode.position = ccp(physicsNode.position.x - scrollSpeed * delta, physicsNode.position.y);
        }
        return;
    }

    if (bunny.position.y < 0){
        NSLog(@"Bunny died");
        gameStarted = NO;
        [self setGameOver];
        return;
    }

    
    physicsNode.position = ccp(physicsNode.position.x - scrollSpeed * delta, physicsNode.position.y);
    
    
//    if(foxScreenPosition.x+50 < -(fox.contentSize.width)){
//        fox.position = ccp(fox.position.x + 1200.f,100.f);
//    }
    
    
    
    
    CGPoint bunnyWorldPosition = [physicsNode convertToWorldSpace:bunny.position];
    CGPoint bunnyScreenPosition = [self convertToNodeSpace:bunnyWorldPosition];
    
    if (bunnyScreenPosition.x > 400 && bunnyScreenPosition.y < 100) {
        scrollSpeed = 1.06*scrollSpeed;
        fox.position = ccp(fox.position.x , 38);
        bunnySpeed = 0;
    }
    else if (bunnyScreenPosition.x < 100){
        scrollSpeed = scrollConst;
        fox.position = ccp(fox.position.x - scrollConst*(CGFloat) delta, 38);
        bunnySpeed = scrollConst;
    }

    else{
        fox.position = ccp(fox.position.x - scrollConst*(CGFloat) delta, 38);
    }
    bunny.position = ccp(bunny.position.x + bunnySpeed*delta, bunny.position.y );
//    if(foxScreenPosition.y < 20 && foxScreenPosition.x > 1000){
//        //[fox.physicsBody applyImpulse:ccp(500, 1000)];
//        fox.position = ccp(fox.position.x - scrollConst*(CGFloat) delta, 50);
//    }
//    else{
//        
    
//    }
    
    
    
    
    //loop ground
    for ( CCSprite* n in grounds){
        CGPoint  groundWorldPosition = [physicsNode convertToWorldSpace:n.position];
        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
        int cliff_rand = arc4random_uniform((u_int32_t)2);
        int cliff_size = arc4random_uniform((u_int32_t)10) + 15;
        
        if (groundScreenPosition.x <= -1*n.contentSize.width) {

            n.position = ccp(n.position.x+n.contentSize.width*2, n.position.y);
            
            CGPoint  rCliffWorldPosition = [physicsNode convertToWorldSpace:cliffRight.position];
            
            CGPoint rCliffScreenPosition = [self convertToNodeSpace:rCliffWorldPosition];
           
            if (cliff_rand == 1 && rCliffScreenPosition.x <= -0.8*cliffRight.contentSize.width){
                [n setVisible:NO];
                n.physicsBody.sensor = YES;
                cliffLeft.position = ccp(n.position.x- 800 - cliff_size, n.position.y);
                cliffRight.position = ccp(n.position.x+ 300 + cliff_size, n.position.y);
            }
            
            else{
                [n setVisible:YES];
                n.physicsBody.sensor = NO;
            }
            //CGPoint foxWorldPostion = [physicsNode convertToWorldSpace:fox.position];
            //CGPoint foxScreenPosition = [self convertToNodeSpace:foxWorldPostion];
            
        }
        
    }
    

    for ( CCSprite* n in backgrounds){
        CGPoint  groundWorldPostion = [physicsNode convertToWorldSpace:n.position];
        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPostion];
        
        if (groundScreenPosition.x <= -1*n.contentSize.width*n.scaleX) {
            n.position = ccp(n.position.x+n.contentSize.width*n.scaleX*2, n.position.y);
            int fox_rand = 2; //arc4random_uniform((u_int32_t)4);
            
            if(fox_rand >= 2 && foxScreenPosition.x <= -1*fox.contentSize.width){

                fox.position = ccp(n.position.x, n.position.y);
                CCAnimationManager* animationManager = self->fox.userObject;
                [animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
                NSLog(@"fox: %f, %f", fox.position.x, fox.position.y);
            }
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
//    CGFloat temp = bunny.position.y - bunny.contentSize.height/2;
//    CGFloat temp2 = ground.position.y + ground.contentSize.height/2;
    
//    if (temp <= temp2) {

//        self.userInteractionEnabled = YES;



//    }
//   else{
//        self.userInteractionEnabled = NO;
//    }

    


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
    
    
    smoke = (CCParticleSystem *)[CCBReader load:@"smoke"];
    [self.physicsNode addChild:smoke z:1000];
    //[smoke stopSystem ];
    
    
    cliffLeft = (CCSprite*)[CCBReader load:@"cliffLeft"];
    cliffRight = (CCSprite*)[CCBReader load:@"cliffRight"];
    cliffRight.scaleY = 2;
    cliffLeft.scaleY = 2;
    [physicsNode addChild:cliffRight];
    [physicsNode addChild:cliffLeft];
    cliffLeft.physicsBody.collisionType = @"ground";
    cliffRight.physicsBody.collisionType = @"ground";
    
    
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
    [[CCDirector sharedDirector] replaceScene:scene];
}


-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny berry:(CCNode *)berry{
    

    [berry removeFromParent];
    [berries removeObject:berry];
    score = score + 1;
    [scoreLabel setString:[NSString stringWithFormat:@"Current Score: %d",score]];
    if(self->bunny.scale < 1.0)
        self->bunny.scale = self->bunny.scale*1.05;
        [self->bunny setContentSizeInPoints: CGSizeMake(self->bunny.contentSize.width*1.05, self->bunny.contentSize.height*1.05)];
    if (score%5 == 4){
        scrollConst += 5;
        NSLog(@"%f b: %f", scrollConst, bunnySpeed);
    }
    return FALSE;
    
}
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny yellowBerry:(CCNode *)berry{
    
    
    [berry removeFromParent];
    [berries removeObject:berry];
    score = score - 1;
    [scoreLabel setString:[NSString stringWithFormat:@"Current Score: %d",score]];
    if(self->bunny.scale < 1.0)
        self->bunny.scale = self->bunny.scale*1.05;
    [self->bunny setContentSizeInPoints: CGSizeMake(self->bunny.contentSize.width*1.05, self->bunny.contentSize.height*1.05)];
    if (score%5 == 4){
        scrollConst += 5;
        NSLog(@"%f b: %f", scrollConst, bunnySpeed);
    }
    return FALSE;
    
}
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny blueBerry:(CCNode *)berry{
    
    
    [berry removeFromParent];
    [berries removeObject:berry];
    score = score + 1;
    [scoreLabel setString:[NSString stringWithFormat:@"Current Score: %d",score]];
    if(self->bunny.scale < 1.0)
        self->bunny.scale = self->bunny.scale*0.95;
    [self->bunny setContentSizeInPoints: CGSizeMake(self->bunny.contentSize.width*0.95, self->bunny.contentSize.height*0.95)];
    if (score%5 == 4){
        scrollConst += 5;
        NSLog(@"%f b: %f", scrollConst, bunnySpeed);
    }
    return FALSE;
    
}

-(void)resetFox{
    if (gameStarted){
        //self->fox.position = ccp(self->fox.position.x + 1200.f,100.f);
        CCAnimationManager* animationManager = self->fox.userObject;
        [animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
        //[self->fox setVisible:NO];
        //fox.physicsBody.sensor = YES;
        //NSLog(@"%f, %f", fox.position.x, fox.position.y);
    }
}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)nodeA fox:(CCNode *)nodeB{
    
    if (gameStarted) {
        CCAnimationManager* animationManager = self->fox.userObject;
        [animationManager runAnimationsForSequenceNamed:@"foxSquashed"];
        [self->bunny.physicsBody applyImpulse:ccp(200, 500)];
        [self performSelector:@selector(resetFox) withObject:self afterDelay:.8];
        
    }
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny ground:(CCNode *)ground{
    self.userInteractionEnabled = true;
    foxhit = NO;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny fox:(CCNode *)fox{
    if((self->bunny.position.x > self->fox.position.x) && self->gameStarted){
        
        return YES;
    }
    else if (self->gameStarted){
        
        [self->fox setZOrder:600];
        self->gameStarted = NO;
        //self->bunny.position = ccp(self->bunny.position.x - 10, self->bunny.position.y );
        CCAnimationManager* animationManager2 = self->bunny.userObject;
        [animationManager2 runAnimationsForSequenceNamed:@"bunnyAttacked"];
        
        self->bunny.position = ccp(self->fox.position.x - 100, self->bunny.position.y );
        CCAnimationManager* animationManager = self->fox.userObject;
        [animationManager performSelector:@selector(runAnimationsForSequenceNamed: ) withObject:@"attackBunny" afterDelay:.15];
        [self performSelector:@selector(setGameOver) withObject:self afterDelay:0.6];
        [self smokeOnOff:YES];

        self->fox.position = ccp(self->fox.position.x, self->bunny.position.y );
        [animationManager performSelector:@selector(runAnimationsForSequenceNamed: ) withObject:@"foxWins" afterDelay:.4];
        [self smokeOnOff:NO];
        
        self.userInteractionEnabled = NO;
        
        
    }
    return NO;
}
;-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair fox:(CCNode *)nodeA bunny:(CCNode *)nodeB{
    if (foxhit) {
        return NO;
    }
    foxhit = YES;
    score += 1;
    [scoreLabel setString:[NSString stringWithFormat:@"Current Score: %d",score]];
    return YES;
}
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair fox:(CCNode *)nodeA ground:(CCNode *)nodeB{
    return YES;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    if (gameStarted){
   
        CCAnimationManager* animationManager = bunny.userObject;
        [animationManager runAnimationsForSequenceNamed:@"bunnyPrep"];
        if (bunny.scale >.5) {
           bunny.scale = bunny.scale*0.9;
            NSLog(@"%f", bunny.contentSize.height);
        }
    }
    
    
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    if (gameStarted) {
        self.userInteractionEnabled = NO;
        CCAnimationManager* animationManager = bunny.userObject;
        [animationManager runAnimationsForSequenceNamed:@"bunnyHop"];
        
        [bunny.physicsBody applyImpulse:ccp(700, 2800)];
    }

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
    
    
    
    
    int numOfBerries = arc4random_uniform((u_int32_t)4);
    int lowerBoundY = -newTree.contentSize.height/2*newTree.scaleY+40;
    int upperBoundY = newTree.contentSize.height/2*newTree.scaleY;
    

    int lowerBoundX = -newTree.contentSize.width/2*newTree.scaleX+30;
    int upperBoundX = newTree.contentSize.width/2*newTree.scaleX-30;
    int rndValueX = 0;
    
    for (int i = 0; i<numOfBerries; i++) {
        Berry* berry;
        int rand = arc4random_uniform((u_int32_t)40);
        if(rand <= 5){
            berry = (Berry*)[CCBReader load:@"yellowBerry"];
           berry.physicsBody.collisionType = @"yellowBerry";
        }
        else if(rand >5 && rand <= 10){
            berry = (Berry*)[CCBReader load:@"blueBerry"];
             berry.physicsBody.collisionType = @"blueBerry";
        }
        else{
            berry = (Berry*)[CCBReader load:@"berry"];
             berry.physicsBody.collisionType = @"berry";
        }
        
        
        int rndValueY = lowerBoundY + arc4random() % (upperBoundY - lowerBoundY);

        if (rndValueY>30 && rndValueY<80){
            lowerBoundX = -12;
            upperBoundX = 12;
            
        }
        if (rndValueY >=80) {
            lowerBoundX = -1;
            upperBoundX = 1;
        }
        if(rndValueY > 85){
            return;
        }
        
        rndValueX = lowerBoundX + arc4random() % (upperBoundX - lowerBoundX);
        berry.scale = .4;
        berry.position = ccp(newTree.position.x+ rndValueX, newTree.position.y +rndValueY);
        
        berry.physicsBody.sensor = YES;
        [physicsNode addChild:berry z: 9];
        [berries addObject: berry];
    }


}
-(void)setGameOver{
    [restartButton setVisible:YES];
    //[self->fox removeFromParent];
    [self->bunny removeFromParent];
    
    self.userInteractionEnabled = NO;
}

-(void)smokeOnOff: (BOOL) on{
    if(on){
        smoke.position = bunny.position;
        [smoke resetSystem];
    }
    else{
        [smoke stopSystem];
    }
    
}
@end
