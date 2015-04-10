#import "MainScene.h"
#import "Berry.h"
#import <CCNode.h> 

@implementation MainScene



-(void)update:(CCTime)delta{
    int location = 300;
    
    
    CGPoint bunnyWorldPosition = [physicsNode convertToWorldSpace:bunny.position];
    CGPoint bunnyScreenPosition = [self convertToNodeSpace:bunnyWorldPosition];
    if (bunnyScreenPosition.x <= location) { //NOTE: change relative to ground later
        bunny.position = ccp(bunny.position.x + scrollSpeed*(CGFloat)delta, bunny.position.y);
    }
 
    
    physicsNode.position = ccp(physicsNode.position.x - scrollSpeed * delta, physicsNode.position.y);
    
    fox.position = ccp(fox.position.x - scrollSpeed*(CGFloat) delta, fox.position.y);
    
    
    //loop ground
    for ( CCNode* n in grounds){
        CGPoint  groundWorldPostion = [physicsNode convertToWorldSpace:n.position];
        //NSLog(@"%f", groundWorldPostion.y);

        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPostion];
        
 
        
        
        if (groundScreenPosition.x <= -1*location) {
            n.position = ccp(n.position.x+2*location, n.position.y);

        }
        
    }
    for ( CCNode* n in backgrounds){
        CGPoint  groundWorldPostion = [physicsNode convertToWorldSpace:n.position];
        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPostion];
        if (groundScreenPosition.x <= -1*location) {
            n.position = ccp(n.position.x+2*location, n.position.y);
            
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
    distBtwnTrees = 320.f;
    foxPos = 960.f;
    scrollSpeed = 80;
    trees = [NSMutableArray array];
    grounds = [NSArray arrayWithObjects:ground, ground1, nil];
    backgrounds = [NSArray arrayWithObjects:background, background1, nil];
    
    
    
    bunny = (CCSprite*) [CCBReader load:@"Bunny"];
    bunny.scale = 0.5;
            
    bunny.position = ccp(100, 100);
    [physicsNode addChild:bunny z:500];
    
    self.userInteractionEnabled = YES;
    
    [self spawnNewTrees];
    [self spawnNewTrees];
    
    
    
    physicsNode.collisionDelegate = self;
    
    bunny.physicsBody.collisionType = @"bunny";

    self->fox =  (CCSprite*)[CCBReader load:@"Fox"];
    [physicsNode addChild: fox z:10];
    [self spawnNewFox];
    fox.physicsBody.collisionType = @"fox";
    
    
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny berry:(CCNode *)berry{
    

    [berry removeFromParent];
    [berries removeObject:berry];
    NSLog(@"%f", self->bunny.scale);
    if(self->bunny.scale < 0.9)
        self->bunny.scale = self->bunny.scale*1.05;
    return FALSE;
    
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair bunny:(CCNode *)bunny fox:(CCNode *)fox{
    
    NSLog(@"fox touched bunny");
    return FALSE;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [bunny.physicsBody applyImpulse:ccp(1000, 6000.f)];
    //bunny =[CCBReader load:@"Fox"];
    self.userInteractionEnabled = NO;
}


-(void)spawnNewFox{
    
    fox.position = ccp(foxPos, 40);
    
    
                   
}

-(void)spawnNewTrees{
    
    CCNode* prevTree = [trees lastObject];
    
    CGFloat prevTreeXPos = prevTree.position.x;
    
    //distBtwnTrees = arc4random_uniform((u_int32_t)200)+ distBtwnTrees;
    
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
