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
@synthesize mapScreen;


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
          tileset:(tileset)t 
        mapScreen:(MapScreen *)ms {
	
	if((self = [super init])) {
		[self setIsTouchEnabled:YES];
		
		//prepare variables
		NSString* olStr = [NSString stringWithFormat:@"%dto.png", tid];
		NSString* bStr = [NSString stringWithFormat:@"%dsb.png", tid];
        
        self.mapScreen = ms;
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
        castleBase.position = baseOffset;
        [self addChild:castleBase];
                
        castle = spriteWithRect(@"castles.png", castleRect);
        castle.flipX = self.castleRotation;
        castle.position = ccpAdd(castleOffset, self.position);
        
        [self.mapScreen addChild:castle z:1000];


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
    NSLog(@"tapped territory %d", territoryID.intValue);
    
    if(conqured || !conquerable) {
        return;
    }
	
	[GameSettings instance].territoryID = [self.territoryID intValue];
	[GameSettings instance].backgroundType = self.tileset;
    [GameSettings instance].isCampaign = YES;
    
    
    if(self.type == small) {
        [GameSettings instance].type = easy;
    } if(self.type == mediumC) {
        [GameSettings instance].type = medium;
    } if(self.type == large) {
        [GameSettings instance].type = hard;
    }
    
    BOOL numPlayers = 2;
    
    if(self.territoryID.intValue % 4 == 0)
        numPlayers = 3;
    if(self.territoryID.intValue % 17 == 0) {
        numPlayers = 4;
        [GameSettings instance].type = medium;
    }
    
	[GameSettings instance].numPlayers = numPlayers;
	
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
            
            overlayImage.visible = YES;
            overlayImage.color = gray;
            castle.visible = NO;
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
    CGPoint mapTouch = ccpAdd(touchOnMap, ms.position);            
    CGRect castleRect = {ccpAdd(castleOffset, self.position), castle.textureRect.size};
    
    mapTouch = ccpMult(mapTouch, -1);
    mapTouch = ccpAdd(ccp(500, 350), mapTouch); // dont ask.
    
    
    if(CGRectContainsPoint(castleRect, mapTouch) && self.tapped) {
        [self territoryTapped];
        return;
    }
	
	self.tapped = YES;
}

-(CGPoint) transformTouchToPoint:(UITouch *)touch withCameraOffset:(BOOL)cam {
	
    CGPoint location = [touch locationInView:nil];
	
	// convert the point to landscape
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	return location;
}

@end
