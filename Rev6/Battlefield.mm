// Import the interfaces
#import "Battlefield.h"
#import "Ground.h"
#import "ContactListener.h"
#import "HUD.h"
#import "HUDSelectedMenu.h"
#import "Background.h"
#import "Tileable.h"
#import "PlayerAreaManager.h"
#import "PlayerArea.h"
#import "PieceList.h"
#import "DestroyedPieceAnimation.h"
#import "GameSettings.h"
#import "AI.h"
#import "MainMenu.h"
#import "Loser.h"
#import "Winner.h"
#import "HUDActionController.h"

#import "AppDelegate.h"
#import "JSONKit.h"

#import "MapScreen.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.



// Battlefield implementation
@implementation Battlefield

@synthesize touchables, selected, lastCreated,  hud, tileables, playerAreaManager, gameTime, sentLoseWarning, world, sentFinalLoseWarning, lastShot, bin;

static Battlefield * instance = nil;

+(Battlefield *) instance {
	if(instance == nil) {
		instance = [Battlefield alloc];
		[instance init];
	}
		
	return instance;
}

+(void) resetInstance {
    [instance release];
	instance = nil;
}

+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Battlefield *layer = [Battlefield node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



-(id) init {
	if((self = [super init])) {
		
		instance = self;
		
		AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		[delegate.window setMultipleTouchEnabled:NO];
		
		//************* Sound section starts ******************************
		// (Back ground sound, volume reduced to 0.08f, range: 0.0f - 1.0f)
		//*****************************************************************
		
		SimpleAudioEngine *backgroundSound = [SimpleAudioEngine sharedEngine];
		if (backgroundSound != nil) {
			[backgroundSound preloadBackgroundMusic:@"backGroundMusic.caf"];
			if (backgroundSound.willPlayBackgroundMusic) {
				backgroundSound.backgroundMusicVolume = 0.3f;
			}
		}
		
		[backgroundSound playBackgroundMusic:@"backGroundMusic.caf"];
		
		//************************** Pre-load Effects **********************
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"cannonball-wall-hita.caf"];
		
		//************************** Sound section over ********************
		//******************************************************************
		
		GameSettings* gameSettings = [GameSettings instance];
		self.touchables = [NSMutableArray array];
		self.tileables = [NSMutableArray array];
        self.bin = [NSMutableArray array];
		screenMomentum = 0.0;
		gameTime = 0.0;
		cameraXBeforeShot = 0.0;
		lastShot = nil;
		followProjectile = NO;
		sentLoseWarning = NO;
		didMoveInFollow = NO;
		
                		
		// enable touches
		self.isTouchEnabled = YES;
		touchDown = NO;
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -9.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		world->SetContinuousPhysics(true);
		world->SetContactListener(new ContactListener);
		
		Background * foreground = [[[Background alloc] initWithLeftImage:[gameSettings getBackgroundFileName:@"frontLeft.png"]
															 rightImage:[gameSettings getBackgroundFileName:@"frontRight.png"]
														 imageDimension:CGPointMake(607.0, 320.0) 
																	layer:self
																  index:FOREGROUND_Z_INDEX 
														 parallaxFactor:-1.0] autorelease];
		
		Background * midground = [[[Background alloc] initWithLeftImage:[gameSettings getBackgroundFileName:@"middleLeft.png"]
															rightImage:[gameSettings getBackgroundFileName:@"middleRight.png"]
														imageDimension:CGPointMake(607.0, 320.0) 
																 layer:self
																 index:MIDGROUND_Z_INDEX 
														parallaxFactor:BACKGROUND_SCALE_FACTOR] autorelease];

		Background * background = [[[Background alloc] initWithLeftImage:[gameSettings getBackgroundFileName:@"backLeft.jpg"]
													  	 	 rightImage:[gameSettings getBackgroundFileName:@"backRight.jpg"]
														 imageDimension:CGPointMake(607.0, 320.0) 
																  layer:self
																  index:BACKGROUND_Z_INDEX 
														 parallaxFactor:10.0] autorelease];
		 
		[tileables addObject:foreground];
		[tileables addObject:midground];
		[tileables addObject:background];


		self.playerAreaManager = [[[PlayerAreaManager alloc] initWithPlayerAreaWorld:world] autorelease];		
		[playerAreaManager loadAI];
        [playerAreaManager loadPlayer];


		[self schedule: @selector(tick:)];
		//[self schedule:@selector(tick:) interval:1.0/30.0];

		// setup the hud
		self.hud = [[[HUD alloc] init] autorelease];

		[hud showMessage:[NSString stringWithFormat:@"Build your castle, war begins soon!", NO_FIRE_TIME]];

		// set initial camera position
		screenMomentum = -PLAYER_GROUND_WIDTH*[GameSettings instance].playerID;
		[self moveScreen];
		screenMomentum = -6.0;
        
        payclock = MONEY_CLOCK;

	}
	
	return self;
}

-(void) resetInstance {
	[self unschedule:@selector(tick:)];	
    [[HUDActionController instance] setHud:nil];
	[Battlefield resetInstance];
}


#pragma mark hud functions

-(void) setSelected:(Piece *)p updateHUD:(bool)b {
	
	if(selected && !selected.shouldDestroy && p != selected) {
		[selected unselect];
	}
	
	if(b) [hud showSelectedMenu:p];
	self.selected = p; 
}


#pragma mark tick functions

-(void) tick: (ccTime) dt {
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 3;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
	gameTime += dt;
	
	// countdown timer
	if(gameTime < NO_FIRE_TIME+1.0) { [hud setCountdownTimer:NO_FIRE_TIME-gameTime]; }
	
    // payclock
    if(gameTime > payclock) {
        int amount = [[[self playerAreaManager] getCurrentPlayerArea] giveMoney];
        [self.hud showPaycheck:amount];
        payclock += MONEY_CLOCK;
    }
    
	// get the camera position
	float camX,camY,camZ;
	[self.camera centerX:&camX centerY:&camY centerZ:&camZ];
	
	[self checkForLoser:dt];
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
		if (b->GetUserData() != NULL && ![(NSObject *)b->GetUserData() isKindOfClass:[PlayerArea class]]) {
			
			// Synchronize the AtlasSprites position and rotation with the corresponding body
			Piece* piece = (Piece*)b->GetUserData();
			b2Vec2 pos = b->GetPosition();
			float ang = b->GetAngle();
			
			if(pos.y < 0) { piece.shouldDestroy = YES; }
			
			// remove the destroyed pieces
			if(piece.shouldDestroy && piece.shouldDestroyReally) {
				[self cleanupTick:piece body:b];
				continue;
			}
            if(piece.shouldDestroy) piece.shouldDestroyReally = YES;
			
			piece.currentSprite.position = ccp(pos.x*PTM_RATIO, pos.y*PTM_RATIO);
			piece.currentSprite.rotation = -1 * CC_RADIANS_TO_DEGREES(ang);
			piece.backSprite.position = [playerAreaManager getBackImagePosFromObjPos:ccp(pos.x * PTM_RATIO, pos.y * PTM_RATIO) cameraPosition:ccp(camX, camY)];
            piece.backSprite.rotation = CC_RADIANS_TO_DEGREES(ang);
			
			if([piece isKindOfClass:[Weapon class]]) {
                [(Weapon*)piece updateSpritesAngle:ang position:pos time:dt];
			}
			
			if([piece isKindOfClass:[City class]]) {
                [(City*)piece updateSprites];
			}
			
			if([piece isKindOfClass:[Projectile class]]) {
                [(Projectile*)piece updateSpritePosition:pos body:b];
			}
		}	
	}
	
	// move the screen if there is still momentum
	if(!touchDown && abs(screenMomentum) > (SCROLL_MOMENTUM)) {
		
		// cap the screen momentum 
		if(abs(screenMomentum) > SCROLL_MOMENTUM_CAP) {	
			screenMomentum = screenMomentum > 0 ? SCROLL_MOMENTUM_CAP : SCROLL_MOMENTUM_CAP * -1;
		}
		
		[self moveScreen];
	}
	
	// move the screen to the last shot
	if([GameSettings instance].followShot && lastShot && !touchDown && lastShot.owner == [playerAreaManager getCurrentPlayerArea]) {
		b2Body* b = lastShot.body;
		float diff = (b->GetPosition().x*PTM_RATIO-camX);
		
		if(followProjectile || diff < -60 || fabs(diff) > 200) {
			followProjectile = YES;
			didMoveInFollow = YES;

			if(b->GetPosition().x*PTM_RATIO > camX)
				screenMomentum = -1.0*(b->GetPosition().x*PTM_RATIO-camX-200.0);
			else
				screenMomentum = -1.0*(b->GetPosition().x*PTM_RATIO-camX+60.0);
			
			[self moveScreen];
			screenMomentum = 0.0;
		}
	}
}

-(void) cleanupTick:(Piece *)piece body:(b2Body *)b {
	
    [playerAreaManager removePiece:piece forPlayer:piece.owner];
	[touchables removeObject:piece];

	
	if(![piece isKindOfClass:[Projectile class]] && piece.hasBeenPlaced) {
		//Destruction Animation
		//animation runs each time the piece is hit.
		//need to make it so it runs only when destroyed...
        
		CGPoint loc = ccp(piece.body->GetPosition().x*PTM_RATIO, piece.body->GetPosition().y*PTM_RATIO - 8);
		CCParticleSystem* ps = [[[DestroyedPieceAnimation alloc] initWithTotalParticles:20] autorelease];
		ps.position = loc;
		ps.life = 0.08f;
		[[Battlefield instance] addChild:ps z:ANIMATION_Z_INDEX];
		
	}
	
	if(piece == lastShot) { 
		followProjectile = NO; 
		lastShot = nil;
	}
	
	// remove the spirte
	[self removeChild:piece.currentSprite cleanup:YES];
	[self removeChild:piece.backSprite cleanup:YES];
	
	if([piece isKindOfClass:[Weapon class]]) {
		Weapon* weapon = (Weapon*)piece;
		
		if(selected == piece || [hud.selectedMenu getSelectedPiece] == piece) {
			[self setSelected:nil updateHUD:YES];
		}
		
		if(weapon.cdSprite != nil) { 
			[weapon.cdSprite stopAllActions];
			[self removeChild:weapon.cdSprite cleanup:YES]; 
		}
		
		if(weapon.shootIndicatorTail) {
			[self removeChild:weapon.shootIndicatorTail cleanup:YES];
		}
        
        if(weapon.shootIndicatorTop) {
			[self removeChild:weapon.shootIndicatorTop cleanup:YES];
		}
		
		[self removeChild:weapon.swingSprite cleanup:YES];
		[self removeChild:weapon.backSwingSprite cleanup:YES];
	}
	
	if(![piece.owner hasWeapon] && piece.owner.ai != nil) { [piece.owner destroyPlayer]; }
	
	world->DestroyBody(b);
	
	
	if([piece isKindOfClass:[Weapon class]]) { 
        if([self playerDidWin]) {
            [self winGame];
        }
    }
}


#pragma mark game conclusion functions

-(void) checkForLoser:(float)dt {
	PlayerArea* player = [playerAreaManager getCurrentPlayerArea];
	
	// calculate if the player has lost the game
	if(!player.hasWeapon && gameTime > NO_FIRE_TIME) {
		
		if(!sentLoseWarning) {
			[hud showMessage:@"Place a weapon or you will lose!"];
			sentLoseWarning = YES;
		}
		
		if(player.timeTillLoss<5.0) {
			
			if(!sentFinalLoseWarning) {
				sentFinalLoseWarning = YES;
				[hud showMessage:@"Place a weapon or you will lose!"];
			}
			
			[hud setCountdownTimer:player.timeTillLoss];
		}
		
		if((player.timeTillLoss -= dt)<0.0) {
						
			[self loseGame];
		}
	}
}

-(void) winGame {
		
		[MainMenu resetInstance];        
		[[CCDirector sharedDirector] replaceScene:[MainMenu instance]];
		
		
		if([[GameSettings instance] isCampaign]) {
            [MapScreen saveConqueredTerritory:[GameSettings instance].territoryID];
		}
		

		Winner* w = [Winner node];
		[w setGameTime:gameTime];
		[[MainMenu instance] addChild:w];
        
		
		[self resetInstance];

}

-(void) loseGame {
	
	[MainMenu resetInstance];
	[[CCDirector sharedDirector] replaceScene: [MainMenu instance]];
    
    
	Loser* l = [Loser node];
	[l setGameTime:gameTime];
	[[MainMenu instance] addChild:l];
    
	
	[self resetInstance];
}

-(BOOL) playerDidWin {

	// check for winner
	BOOL opponentLeft = YES;
	if(gameTime > NO_FIRE_TIME) {

		opponentLeft = NO;
		for(PlayerArea* pa in playerAreaManager.playerAreas) {
        
            BOOL areaIsOwn = pa == [playerAreaManager getCurrentPlayerArea];
            BOOL areaIsAI = pa.ai && !areaIsOwn;
            BOOL areaHasWeapons = !pa.destroyed;
                        
            opponentLeft = opponentLeft || (areaIsAI && areaHasWeapons);

		}
	}
	
    return !opponentLeft;
}


#pragma mark piece creation functions

-(void) addNewPieceWithCoords:(CGPoint)p andClass:(Class)c withImageName:(NSString *)managerName finalize:(BOOL)finalize player:(PlayerArea*)player {
	Piece *piece = [[[c alloc] initWithWorld:world coords:p] autorelease];
	
	piece.owner = player;
	
	if(finalize) {
		[piece snapToPosition:b2Vec2(piece.body->GetPosition().x * PTM_RATIO, piece.body->GetPosition().y * PTM_RATIO)];
		[piece finalizePiece];
	}
	
	[playerAreaManager addPiece:(Piece*)piece forPlayer:player];
	
    if([piece isKindOfClass:[Weapon class]])
        [touchables addObject:piece];
        
	self.lastCreated = piece;
    
    [self.bin addObject:piece];
}

-(void) addProjectileToBin:(Projectile*)p {
    [self.bin addObject:p];
}


#pragma mark movement functions 

-(void) setLastShot:(Projectile*)proj {
	float camX,camY,camZ;
	[self.camera centerX:&camX centerY:&camY centerZ:&camZ];
	
	lastShot = proj;
	cameraXBeforeShot = camX;
}

-(void) tileImagePool:(CGPoint)loc delta:(CGPoint)d {
	
	for(Tileable *t in tileables) {
		[t positionForCameraLoc:loc];
		
		float factor = (t.parallaxFactor != 0.0 ? d.x/t.parallaxFactor + d.x : d.x);
		
		[t.imageA setPosition:CGPointMake(t.imageA.position.x - factor, t.imageA.position.y)];
		[t.imageB setPosition:CGPointMake(t.imageB.position.x - factor, t.imageB.position.y)];
	}
}

-(void) resetTileImagePool:(CGPoint)loc {

	for(Tileable *t in tileables) {
		[t positionForCameraLoc:loc];
		
		[t.imageA setPosition:CGPointMake(loc.x-(t.imageA.textureRect.size.width/2)+1.0, t.imageA.position.y)];
		[t.imageB setPosition:CGPointMake(loc.x+(t.imageB.textureRect.size.width/2), t.imageB.position.y)];
	}
}

-(void) resetScreenToX:(float)x {
	[self setSelected:nil updateHUD:NO];
	float camX,camY,camZ;
	[self.camera centerX:&camX centerY:&camY centerZ:&camZ];
	[self.camera setCenterX:x centerY:camY centerZ:0.0];
	[self.camera setEyeX:x eyeY:camY eyeZ:[CCCamera getZEye]];
	[self resetTileImagePool:ccp(x,camY)];
	[hud moveAllObjects:ccp(camX-x, 0)];
	
	// could need this
	[playerAreaManager checkAndMovePlayerAreas:ccp(x, camY)];
	[playerAreaManager checkAndMovePlayerAreas:ccp(x, camY)];
	[playerAreaManager checkAndMovePlayerAreas:ccp(x, camY)];
	[playerAreaManager checkAndMovePlayerAreas:ccp(x, camY)];	
	
	screenMomentum = 0;
	didMoveInFollow = NO;
	
}

-(void) resetViewToLastShot {
	[self resetScreenToX:cameraXBeforeShot];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	CGPoint location = [self transformTouchesToPoint:touches withCameraOffset:YES];
	initialTouch = [self transformTouchesToPoint:touches withCameraOffset:NO];
	screenMomentum = 0.0;
	touchDown = YES;
	isConstructionTouch = NO;
	
	//if(didMoveInFollow) {[self resetViewToLastShot]; }
	
	// check if its a hud touch
	if ([hud handleInitialTouch:initialTouch]) {
		[self setSelected:nil updateHUD:NO];
		return; //isConstructionTouch = YES;
	}
	
	// converto the location to world coords
	b2Vec2 worldCoor = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
	
	bool touchHandled = NO;
	
	for (Piece *p in touchables) {
		if (p.acceptsTouches && [p containsPoint:worldCoor] && p.owner == [playerAreaManager getCurrentPlayerArea]) {
			[p onTouchBegan:location];
			[self setSelected:p updateHUD:NO];
			touchHandled = YES;
			break;
		}
	}
	
	// finds any weapons within the threshold
	if(!touchHandled) {
		Piece *closest = [self getClosestPiece:location];
			
		if(closest != nil) {
			[self setSelected:closest updateHUD:NO];
			[closest onTouchBegan:location];
		} else {
			[self setSelected:nil updateHUD:NO];
		}
	}
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// check if touch is in the hud
	if ([hud handleTouchDrag:[self transformTouchesToPoint:touches withCameraOffset:NO]])
		return;
	
	CGPoint location;
	
	if (selected && selected.acceptsTouches) {
		
		// send the move to the object if selected
		location = [self transformTouchesToPoint:touches withCameraOffset:YES];
		[selected onTouchMoved:location];
		
		if(!selected.hasBeenPlaced) {
			if([playerAreaManager touchPos:location inPlayerArea:[GameSettings instance].playerID])
				[selected updateView];
			else
				selected.currentSprite.color = ccc3(255, 40, 40);
		}
		
	} else {
		
		// else pan the camera
		location = [self transformTouchesToPoint:touches withCameraOffset:NO];
		CGPoint movement = CGPointMake(location.x - initialTouch.x, location.y - initialTouch.y);
		initialTouch = location;
		
		// set the acceleration 
		screenMomentum = movement.x;
		
		[self moveScreen];
	}
	
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
		
	if(lastShot != nil) {
		self.lastShot = nil;
		
		if(followProjectile) {
			[self setSelected:nil updateHUD:NO];
			float camX,camY,camZ;
			[self.camera centerX:&camX centerY:&camY centerZ:&camZ];
			screenMomentum = camX-cameraXBeforeShot-10.0;
			[self moveScreen];
			screenMomentum = 2;
		}
		
		followProjectile = NO;
		
	}
	
	CGPoint location = [self transformTouchesToPoint:touches withCameraOffset:YES];
	touchDown = NO;
	
	if(isConstructionTouch && ![playerAreaManager touchPos:location inPlayerArea:[GameSettings instance].playerID]) {
		if(selected && !selected.hasBeenPlaced) {
			selected.shouldDestroy = YES;
			[[Battlefield instance].hud showMessage:@"Must build in your own city"];
		}
		return;
	}
	
	if ([hud handleEndTouch:[self transformTouchesToPoint:touches withCameraOffset:NO]])
		return;
	
	bool firedPiece = NO;
	
	if (selected && selected.acceptsTouches) { firedPiece = [selected onTouchEnded:location]; }
	
	b2Vec2 worldCoor = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
	
	bool touchHandled = NO;
	
	if(!isConstructionTouch) {
		
		Piece *closest = [self getClosestPiece:location];
		
		if(closest == selected) {
			[closest onTouchEnded:location];
			[self setSelected:closest updateHUD:YES];
			touchHandled = YES;
		}

	}
	
	self.lastCreated = nil;
    
	if(!touchHandled && !firedPiece)
		[self setSelected:nil updateHUD:NO];
	
    if([[[touches allObjects] objectAtIndex:0] tapCount] == 2) {
            [self resetViewToLastShot]; 
    }
    
}

-(Piece*) getClosestPiece:(CGPoint)location {
	Piece *closest = nil;
	float closestDist = WEAPON_SELECT_THRESHOLD;
	
	for (Piece *p in touchables) {
		if([p isKindOfClass:[Weapon class]] && p.owner == [playerAreaManager getCurrentPlayerArea]) {
			
			b2Vec2 pos = p.body->GetPosition();
			
			float lengthFromTouch = b2Vec2(abs(pos.x*PTM_RATIO)-abs(location.x), 
										   abs(pos.y*PTM_RATIO)-abs(location.y)).Length();
			
			if(lengthFromTouch < WEAPON_SELECT_THRESHOLD)					
				closest = closestDist < lengthFromTouch ? closest : p;
			
		}
	}

	if(closest) { return closest; }
	
	for (Piece *p in touchables) {
		if(p.owner == [playerAreaManager getCurrentPlayerArea]) {
			
			b2Vec2 pos = p.body->GetPosition();
			
			float lengthFromTouch = b2Vec2(abs(pos.x*PTM_RATIO)-abs(location.x), 
										   abs(pos.y*PTM_RATIO)-abs(location.y)).Length();
			
			if(lengthFromTouch < PIECE_SELECT_THRESHOLD)					
				closest = closestDist < lengthFromTouch ? closest : p;
			
		}
	}
	return closest;
}

-(void) moveScreen {
	CGPoint delta = CGPointMake(screenMomentum, 0.0);
	
	// get the camera coords
	float x,y,z;
	[self.camera centerX:&x centerY:&y centerZ:&z];

	// move the objects on the screen before the camera
	[hud moveAllObjects:delta];
	[self tileImagePool:CGPointMake(x, y) delta:delta];
	
    [playerAreaManager checkAndMovePlayerAreas:CGPointMake(x, y)];
    
	[self.camera setCenterX:x-(delta.x) centerY:y centerZ:0.0];
	[self.camera setEyeX:x-(delta.x) eyeY:y eyeZ:[CCCamera getZEye]];
	
	screenMomentum += screenMomentum > 0.0 ? SCROLL_MOMENTUM * -1 : SCROLL_MOMENTUM;
}

-(CGPoint) transformTouchesToPoint:(NSSet *)touches withCameraOffset:(BOOL)cam {
	// select a touch object
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	
	// get the x,y of the point on the iphone
	CGPoint location = [touch locationInView: [touch view]];
	
	// convert the point to landscape
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if(cam) {
		// offset the touch by the camera
		float x,y,z;[self.camera centerX:&x centerY:&y centerZ:&z];
		location.x += x; location.y += y;
	}
	
	return location;
}


#pragma mark memory functions

-(void) save {
		
	self.lastCreated = nil;
	
	PlayerArea* pa = [playerAreaManager.playerAreas objectAtIndex:0];
		
	NSArray* pieceArr = [pa getPieceDescriptions];
		
	NSString *savefile = [[AppDelegate documentDir] stringByAppendingPathComponent:SAVE_FILE_NAME];
	[[pieceArr JSONString] writeToFile:savefile atomically:YES encoding:NSASCIIStringEncoding error:nil];
	
	NSLog(@"Game saved to: %@", savefile);
}

-(bool) canFire {
	return NO_FIRE_TIME < gameTime;
}

-(void) loadForPlayer:(PlayerArea*)player file:(NSString*)filename {
	self.lastCreated = nil;
	[self setSelected:nil updateHUD:YES];
	
	// clear everything out
	/*for(uint i=0; i<[playerAreaManager.playerAreas count]; ++i) {
		PlayerArea* pa = [playerAreaManager.playerAreas objectAtIndex:i];
		for(Piece* piece in [pa getPieces]) {
			piece.shouldDestroy = YES;
		}
	}*/
	
	//[self tick:0.0];
	
	filename = [[NSBundle mainBundle] pathForResource:filename ofType:@"dat"];


	NSLog(@"attempting to open %@", filename);
	
	NSDictionary* state = [[NSString stringWithContentsOfFile:filename encoding:NSASCIIStringEncoding error:nil] objectFromJSONString];
	
	for(NSDictionary* data in state) {
		NSMethodSignature *sig;
		SEL func = @selector(addNewPieceWithCoords:andClass:withImageName:finalize:player:);
		
		Class c = NSClassFromString([data objectForKey:@"class"]);
		NSString* s = [NSString stringWithFormat:@"%@.png", [[data objectForKey:@"class"] lowercaseString]];
		float x = [[data objectForKey:@"x"] floatValue]*PTM_RATIO;
		CGPoint p = CGPointMake([[data objectForKey:@"y"] floatValue]*PTM_RATIO+player.left, x);
		BOOL left = [[data objectForKey:@"left"] intValue] == 0;
		BOOL f = YES;
		
		sig = [Battlefield instanceMethodSignatureForSelector:func];
		
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
		[invocation setSelector: func];
		[invocation setTarget: self];
		[invocation setArgument:&p atIndex:2];
		[invocation setArgument:&c atIndex:3];
		[invocation setArgument:&s atIndex:4];
		[invocation setArgument:&f atIndex:5];
		[invocation setArgument:&player atIndex:6];
		[invocation invoke];
		
		lastCreated.hasBeenPlaced = YES;
		[lastCreated updateView];
		
		lastCreated.isFacingLeft = !left;
		
	}
}

-(void) dealloc {
	[touchables release];
	[tileables release];
    [selected release];
    [lastCreated release];
    [hud release];
    [playerAreaManager release];
    [bin release];
	
	delete world;
	
	[super dealloc];
}

@end
