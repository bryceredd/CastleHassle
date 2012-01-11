//
//  MapScreen.m
//  Rev5
//
//  Created by Dave Durazzani on 5/6/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//



#import "MapScreen.h"
#import "AppDelegate.h"
#import "Territory.h"


float kZoomNormal = 415.009521;
NSString* kMapFile = @"map.plist";	
NSString* kTerritoryFile = @"territories";


@implementation MapScreen


@synthesize statusGrid;
@synthesize mapDictionary;
@synthesize territories;
@synthesize mapPlistPath;
@synthesize zoomBox;
@synthesize bases, flags, castles;

-(id) init {
	if((self = [super init])) {

		zoom = kZoomNormal;
		self.territories = [NSMutableDictionary dictionary];
        self.statusGrid = [NSMutableArray array];
		
		//SPRITES
		CCSprite *mainMap = [CCSprite spriteWithFile:@"mapBase.png"];
		[mainMap setPosition:ccp(240,160)];
		[self addChild:mainMap z:1];
		
        
        self.bases = [[CCTextureCache sharedTextureCache] addImage:@"castleBase.png"];
        self.flags = [[CCTextureCache sharedTextureCache] addImage:@"flag.png"];
        self.castles = [[CCTextureCache sharedTextureCache] addImage:@"castles.png"];
        		
		//[self addChild:castleBases z:2];
		//[self addChild:castleManager z:3];
		
		//hillsAndTrees
		CCSprite *objectsOverCastle = [CCSprite spriteWithFile:@"hillsAndTrees.png"];
		[objectsOverCastle setPosition:ccp(240,160)];
		[self addChild:objectsOverCastle z:4];

		//bridge
		CCSprite *bridge = [CCSprite spriteWithFile:@"bridge.png"];
		[bridge setPosition:ccp(325,255)];
		[self addChild:bridge z:4];
		
		//dock
		CCSprite *dock = [CCSprite spriteWithFile:@"dock.png"];
		[dock setPosition:ccp(48,2)];
		[self addChild:dock z:4];

	
		[self setIsTouchEnabled:YES];
		[self createTerritories];
		[self updateZoomBox];
	}
	
	return self;
}

-(void)createTerritories {

    NSDictionary* conqueredDictionary = [MapScreen conqueredDictionary];
    

    NSPropertyListFormat format;
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:kTerritoryFile ofType:@"plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *dictionary = (NSDictionary *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format
										  errorDescription:nil];

    
    for(NSString* territoryId in [dictionary allKeys]) {
        NSDictionary* territoryData = [dictionary objectForKey:territoryId];
        CGPoint flagPosition = ccp([[territoryData objectForKey:@"flagPositionX"] intValue], [[territoryData objectForKey:@"flagPositionY"] intValue]);
        CGPoint baseOffset = ccp([[territoryData objectForKey:@"baseOffsetX"] intValue], [[territoryData objectForKey:@"baseOffsetY"] intValue]);
        CGPoint castleOffset = ccp([[territoryData objectForKey:@"castleOffsetX"] intValue], [[territoryData objectForKey:@"castleOffsetY"] intValue]);
        CGPoint territoryPosition = ccp([[territoryData objectForKey:@"territoryPositionX"] intValue], [[territoryData objectForKey:@"territoryPositionY"] intValue]);
        
        BOOL hasBase = [[territoryData objectForKey:@"hasBase"] boolValue];
        BOOL castleRotation = [[territoryData objectForKey:@"castleRotation"] boolValue];
        
        castleType type = small;
        if([[territoryData objectForKey:@"castleType"] isEqualToString:@"medium"])
            type = mediumC;
        if([[territoryData objectForKey:@"castleType"] isEqualToString:@"large"])
            type = large;
            
        tileset tileset = tuscany;
        if([[territoryData objectForKey:@"tileset"] isEqualToString:@"britany"])
            tileset = britany;
        else if ([[territoryData objectForKey:@"tileset"] isEqualToString:@"saxony"])
            tileset = saxony;
            
            
        NSMutableArray* neighbors = [territoryData objectForKey:@"neighbors"];
    
        Territory* territory = [[[Territory alloc] initWithID:[territoryId intValue] flagPosition:flagPosition hasBase:hasBase baseOffset:baseOffset castleOffset:castleOffset castleRotation:castleRotation castleType:type territoryPosition:territoryPosition tileset:tileset] autorelease];
        territory.conqured = [[conqueredDictionary objectForKey:territoryId] boolValue];
        territory.neighbors = neighbors;
        
        if(territoryId.intValue == 1) territory.conquerable = YES;
        
        
        [territories setObject:territory forKey:territoryId];
        [self addChild:territory z:4];
    }
    
    for(Territory* territory in [territories allValues]) {
        if(territory.conqured) {
            for(NSNumber* neighbor in territory.neighbors) {
                Territory* conquerableTerritory = [territories objectForKey:neighbor];
                conquerableTerritory.conquerable = YES;
            }
        }
    }
}

-(void) updateZoomBox {
	float x,y,z;
	[self.camera centerX:&x centerY:&y centerZ:&z];
	float zoomFactor = zoom/kZoomNormal;
	
	float zoomx = x+80-(240*zoomFactor);
	float zoomy = y-80+(160*zoomFactor);
	float zoomw = x+80+(240*zoomFactor)-zoomx;
	float zoomh = zoomy-(y-80-(160*zoomFactor));
	
	zoomBox = CGRectMake(zoomx, zoomy, zoomw, zoomh);	
}


#pragma mark Save Territory Status Methods

+(NSMutableDictionary*) conqueredDictionary {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* file = [documentsDirectory stringByAppendingPathComponent:kMapFile];

	return [[[NSMutableDictionary alloc] initWithContentsOfFile:file] autorelease];
}

+(void) saveConqueredTerritory:(int)territoryID {
    NSMutableDictionary* conqueredTerritories = [self conqueredDictionary];

	NSString* tempID = [NSString stringWithFormat:@"%d", territoryID];
	[conqueredTerritories setObject:[NSNumber numberWithBool:YES] forKey:tempID];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* file = [documentsDirectory stringByAppendingPathComponent:kMapFile];

	[conqueredTerritories writeToFile:file atomically:YES];
}

+(void) resetConqueredDictionary {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* file = [documentsDirectory stringByAppendingPathComponent:kMapFile];

	[[NSDictionary dictionary] writeToFile:file atomically:YES];
}





#pragma mark Manage Touches

//this is where I deal with the ZOOM and PANNING of the mapScreen
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	float x,y,z;
	[self.camera centerX:&x centerY:&y centerZ:&z];
	
	// ZOOMING
	if([touches count] == 2) {
		
		// get the first 2 touches
		CGPoint touch1 = [self transformTouchToPoint:[[touches allObjects] objectAtIndex:0] withCameraOffset:NO];
		CGPoint touch2 = [self transformTouchToPoint:[[touches allObjects] objectAtIndex:1] withCameraOffset:NO];
        
		// get distance between the 2 touches
		float currentDist = ccpLength(ccpSub(touch1, touch2));
        
		// get the previous 2 touches thanks to the method previousLocationInView called in the transformPreviousTouchToPoint
		CGPoint previousTouch1 = [self transformPreviousTouchToPoint:[[touches allObjects] objectAtIndex:0]];
		CGPoint previousTouch2 = [self transformPreviousTouchToPoint:[[touches allObjects] objectAtIndex:1]];
        
		// distance between the previous 2 touches
		float previousDist = ccpLength(ccpSub(previousTouch1, previousTouch2));
		
		//ZOMMING
		// 500 is closer
		//1000 is further
		
		zoom += (previousDist - currentDist)*1.3;
		
		//limit zoom
		zoom = MAX(zoom, 350);
		zoom = MIN(zoom, 750);
		
		//set the camera
		[self.camera setEyeX:x eyeY:y eyeZ:zoom];
		
	} else {

		// PANNING
		
		CGPoint delta = [self getTouchDelta:[[touches allObjects] objectAtIndex:0]];

		float newX = x-delta.x;
		float newY = y-delta.y;
		
        newX = MAX(newX, -190);
        newX = MIN(newX, 500);
		
        newY = MAX(newY, -40);
        newY = MIN(newY, 530);
		
		[self.camera setCenterX:newX centerY:newY centerZ:0.0];
		[self.camera setEyeX:newX eyeY:newY eyeZ:zoom];
		
	}
	
	[self updateZoomBox];
	
}

-(CGPoint) getTouchDelta:(UITouch *)touch {
	
	CGPoint first = [touch locationInView:nil];
	CGPoint second = [touch previousLocationInView:nil];
	
	return [[CCDirector sharedDirector] convertToGL:ccpSub(first, second)];
	
}

-(CGPoint) transformTouchesToPoint:(NSSet *)touches withCameraOffset:(BOOL)cam {

	// select a touch object
	UITouch *touch = [touches anyObject];
	
	return [self transformTouchToPoint:touch withCameraOffset:cam];
}

-(CGPoint) transformTouchToPoint:(UITouch *)touch withCameraOffset:(BOOL)cam {
	
	// get the x,y of the point on the iphone
	CGPoint location = [touch locationInView:nil];
	
	// convert the point to landscape
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if(cam) {
		// offset the touch by the camera
		float x,y,z;
		[self.camera centerX:&y centerY:&x centerZ:&z];
		location.x += y - 160; location.y += x - 240;
	}
	
	return location;
}

-(CGPoint) transformPreviousTouchToPoint:(UITouch *)touch {
	CGPoint location = [touch previousLocationInView:nil];
	return [[CCDirector sharedDirector] convertToGL: location];
}
	




@end
