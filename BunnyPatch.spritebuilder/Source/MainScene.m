#import "MainScene.h"

@implementation MainScene



-(void)update:(CCTime)delta{
    
    bunny.position = ccp(bunny.position.x + scrollSpeed*(CGFloat)delta, bunny.position.y);
    
    physicsNode.position = ccp(physicsNode.position.x - scrollSpeed * delta, physicsNode.position.y);
    
    //loop ground
    for ( CCNode* n in grounds){
        CGPoint  groundWorldPostion = [physicsNode convertToWorldSpace:n.position];
        //NSLog(@"%f", groundWorldPostion.y);

        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPostion];
        
 
        
        
        if (groundScreenPosition.x <= -1*n.contentSize.width) {
            n.position = ccp(n.position.x+2*n.contentSize.width, n.position.y);

        }
        
    }
    for ( CCNode* n in backgrounds){
        CGPoint  groundWorldPostion = [physicsNode convertToWorldSpace:n.position];
        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPostion];
        if (groundScreenPosition.x <= -1*n.contentSize.width) {
            n.position = ccp(n.position.x+2*n.contentSize.width, n.position.y);
            
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
    
}

-(void)didLoadFromCCB{
    firstTreePos = 280.f;
    distBtwnTrees = 320.f;
    scrollSpeed = 80;
    trees = [NSMutableArray array];
    grounds = [NSArray arrayWithObjects:ground, ground1, nil];
    backgrounds = [NSArray arrayWithObjects:background, background1, nil];
    
    [bunny setZOrder: 500];
    
    [self spawnNewTrees];
    [self spawnNewTrees];
    
}
-(void)spawnNewTrees{
    
    CCNode* prevTree = [trees lastObject];
    
    CGFloat prevTreeXPos = prevTree.position.x;
    
    //distBtwnTrees = arc4random_uniform((u_int32_t)200)+ distBtwnTrees;
    
    if(!prevTree){
        prevTreeXPos = firstTreePos;
        
    }
    
    CCNode * newTree = [CCBReader load:@"Tree"];
    
    newTree.position = ccp(prevTreeXPos + distBtwnTrees, 90);
    
    [physicsNode addChild:newTree z: 8];
    [trees addObject: newTree];
    
    
    
}

@end
