//
//  Territory.m
//  Rev5
//
//  Created by Dave Durazzani on 5/6/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import "Territory.h"
#import "MapScreen.h"
#import "GameSettings.h"
#import "MainScene.h"

@interface Territory() 
- (CGPoint) transformTouchToPoint:(UITouch *)touch withCameraOffset:(BOOL)cam;
- (void) updateUI;
@end

@implementation Territory

@synthesize neighbors;
@synthesize territoryID;
@synthesize conqured;
@synthesize type;
@synthesize overlayImage;
@synthesize borderImage;
@synthesize castle;
@synthesize castleBase;
@synthesize hasBase;
@synthesize castleRotation;
@synthesize flag;
@synthesize tapped;
@synthesize conquerable;
@synthesize tileset;


ccColor3B blue = {10, 145, 181};
ccColor3B red = {213, 7, 7};
ccColor3B gray = {40, 40, 40};


#pragma mark Territory Initialization

-(id)  initWithID:(int)tid
	 flagPosition:(CGPoint)fPosition
		  hasBase:(BOOL)base
	   baseOffset:(CGPoint)bOffset
	 castleOffset:(CGPoint)cOffSet
   castleRotation:(BOOL)r
	   castleType:(castleType)cst 
territoryPosition:(CGPoint)territoryPosition 
          tileset:(tileset)t {
	
	if((self = [super init])) {
		[self setIsTouchEnabled:YES];
		
		//prepare variables
		NSString* olStr = [NSString stringWithFormat:@"%dto.png", tid];
		NSString* bStr = [NSString stringWithFormat:@"%dsb.png", tid];
        
		self.territoryID = [NSNumber numberWithInt:tid];
		self.type = cst;
		baseOffset = bOffset;
		castleOffset = cOffSet;
		self.hasBase = base;
		self.castleRotation = r;
		flagPosition = fPosition;
        self.tileset = t;
		
		//Overlay
		self.overlayImage = sprite(olStr);
		[self addChild:overlayImage z:6];
        
		//border
		self.borderImage = sprite(bStr);
		[self setPosition:territoryPosition];
		[self addChild:borderImage z:6];
        
		//Flags
		flag = sprite(@"flag.png");
		flag.position = flagPosition;
		[self addChild:flag	z:10];
        
            
        CGRect baseRect, castleRect;
        if (type == large) {
            baseRect = CGRectMake(0, 0, 88, 48);
            castleRect = CGRectMake(0, 0, 67, 65);
        }
        if(type == mediumC) {
            baseRect = CGRectMake(88, 0, 88, 48);
            castleRect = CGRectMake(67, 0, 67, 65);
        }
        if(type == small) {
            baseRect = CGRectMake(176, 0, 88, 48);
            castleRect = CGRectMake(134, 0, 67, 65);
        }
        
        
        castleBase = spriteWithRect(@"castleBase.png", baseRect);
        castleBase.position = ccpAdd(baseOffset, self.position);
        [self addChild:castleBase];
        
        castle = spriteWithRect(@"castles.png", castleRect); 
        castle.position = ccpAdd(castleOffset, self.position);
        castle.flipX = self.castleRotation;
        [self addChild:castle];


	} return self;
	
}

-(void) setConqured:(BOOL)c {
	conqured = c;
    
    [self updateUI];
}

-(void) setConquerable:(BOOL)c {
    conquerable = c;
    
    [self updateUI];
} 

-(void) territoryTapped {
    
    if(conqured || !conquerable) {
        return;
    }
	
	[GameSettings instance].territoryID = [self.territoryID intValue];
	[GameSettings instance].backgroundType = self.tileset;
	[GameSettings instance].type = campaign;
	[GameSettings instance].numPlayers = 2;
	
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}


- (void) updateUI {
    
    if(conqured) {
        
        flag.visible = YES;
        flag.color = blue;
		borderImage.visible = YES;
        borderImage.color = blue;
		overlayImage.visible = NO;
        castleBase.visible = YES;
        castleBase.color = blue;
        castle.visible = YES;
        
	} else {
        
        flag.visible = NO;
        
        if(conquerable) {
        
            castle.visible = YES;
            overlayImage.visible = NO;
            borderImage.color = red;
            borderImage.visible = YES;
            flag.visible = NO;
            castleBase.color = red;
            castleBase.visible = YES;
            
		} else {
        
            castle.visible = NO;
            overlayImage.visible = YES;
            overlayImage.color = gray;
            borderImage.visible = NO;
            castleBase.visible = NO;
        }
        
	}

}


#pragma mark Touch Location

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	self.tapped = NO;
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	MapScreen* ms = (MapScreen*) self.parent;
	
	CGPoint touchOnMap = [self transformTouchToPoint:[[touches allObjects] objectAtIndex:0] withCameraOffset:NO];
	CGPoint relativePoint = ccp(touchOnMap.x/480.0, touchOnMap.y/320.0);
	CGPoint mapTouch = ccp(relativePoint.x*ms.zoomBox.size.width+ms.zoomBox.origin.x, ms.zoomBox.origin.y-ms.zoomBox.size.height+(relativePoint.y*ms.zoomBox.size.height));
	CGRect castleRect = {ccpAdd(self.position, ccpSub(castleOffset, ccpMult(ccp(castle.textureRect.size.width,castle.textureRect.size.height), 0.5))), castle.textureRect.size};
    
	
	if(CGRectContainsPoint(castleRect, mapTouch) && self.tapped) {
		[self territoryTapped];
		return;
	}
	
	self.tapped = YES;
}

-(CGPoint) transformTouchToPoint:(UITouch *)touch withCameraOffset:(BOOL)cam {
	MapScreen* ms = (MapScreen*) self.parent;
	// get the x,y of the point on the iphone
	CGPoint location = [touch locationInView:nil];
	
	// convert the point to landscape
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	
	if(cam) {
		// offset the touch by the camera
		float x,y,z;
		[ms.camera centerX:&x centerY:&y centerZ:&z];
		location.x += x - 160;
		location.y += y - 240;
	}
	
	return location;
}

@end
