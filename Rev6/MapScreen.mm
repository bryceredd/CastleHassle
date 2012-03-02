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


float kZoomNormal = 100;
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

		//zoom = kZoomNormal;
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
        
        BOOL allTerritoriesConquered = YES;
        for(Territory* territory in [territories allValues]) {
            if(!territory.conqured) {
                allTerritoriesConquered = NO;
            }
        }
        
        if(allTerritoriesConquered) {
            victoryWhite = [CCLabelTTF labelWithString:@"Total Victory!" fontName:@"Arial" fontSize:80];
            [victoryWhite setColor:ccc3(255, 255, 255)];
            
            victoryBlack = [CCLabelTTF labelWithString:@"Total Victory!" fontName:@"Arial" fontSize:80];
            [victoryBlack setColor:ccc3(0, 0, 0)];
            
            [self addChild:victoryBlack z:9999];
            [self addChild:victoryWhite z:9999];
            
            victoryBlack.position = ccp(240,160);
            victoryWhite.position = ccp(243,163);
            
            victoryBlack.opacity = 0;
            victoryWhite.opacity = 0;
            
            victoryBlack.scale = .3;
            victoryWhite.scale = .3;
            
            [victoryBlack runAction:[CCFadeIn actionWithDuration:.5]];
            [victoryWhite runAction:[CCFadeIn actionWithDuration:.5]];
            
            [victoryBlack runAction:[CCScaleTo actionWithDuration:.5 scale:1]];
            [victoryWhite runAction:[CCScaleTo actionWithDuration:.5 scale:1]];
        }
        
	}
	
	return self;
}

-(void) createTerritories {

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
    
        Territory* territory = [[[Territory alloc] initWithID:[territoryId intValue] flagPosition:flagPosition hasBase:hasBase baseOffset:baseOffset castleOffset:castleOffset castleRotation:castleRotation castleType:type territoryPosition:territoryPosition tileset:tileset mapScreen:self] autorelease];
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
	zoomFactor = 1;
    
	float zoomx = x;
	float zoomy = y;
	float zoomw = 480 * zoomFactor;
	float zoomh = 320 * zoomFactor;
	
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
    if(!conqueredTerritories) conqueredTerritories = [NSMutableDictionary dictionary];

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

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    initialTouch = [self transformTouchToPoint:[[touches allObjects] objectAtIndex:0] withCameraOffset:NO];
}

//this is where I deal with the ZOOM and PANNING of the mapScreen
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint location = [self transformTouchToPoint:[[touches allObjects] objectAtIndex:0] withCameraOffset:NO];
    CGPoint delta = ccpSub(initialTouch, location);

    float newX = self.position.x + delta.x;
    float newY = self.position.y + delta.y;
    
    newY = MAX(-195.f, newY);
    newY = MIN(200.f, newY);
    
    newX = MIN(230.f, newX);
    newX = MAX(-220.f, newX);
    
    self.position = ccp(newX, newY);
    
    victoryBlack.position = ccpAdd(victoryBlack.position, delta);
    victoryWhite.position = ccpAdd(victoryWhite.position, delta);
 
    //NSLog(@"position: %f, %f", newX, newY);
        
    initialTouch = location;
}

-(CGPoint) transformTouchToPoint:(UITouch *)touch withCameraOffset:(BOOL)cam {
	
	// get the x,y of the point on the iphone
	CGPoint location = [touch locationInView:nil];
	
	// convert the point to landscape
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	return location;
}




@end
