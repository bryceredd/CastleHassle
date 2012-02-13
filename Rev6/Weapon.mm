//
//  Weapon.m
//  Rev3
//
//  Created by Bryce Redd on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"
#import "StaticUtils.h"
#import "Turret.h"
#import "Tower.h"
#import "Balcony.h"
#import "City.h"
#import "Arch.h"
#import "Wall.h"
#import "Merlin.h"
#import "Wedge.h"
#import "GameSettings.h"
#import "Piece.h"
#import "Battlefield.h"
#import "PlayerAreaManager.h"
#import "PlayerArea.h"
#import "AI.h"
#import "HUD.h"
#import "Catapult.h"

@implementation Weapon

@synthesize swingSprite, initialTouch, offset, currentShotAngle, shotPower, backSwingSprite;
@synthesize upgradePrice, weaponLevel, shootIndicatorTop, shootIndicatorTail, cooldown, maxCooldown, cdSprite;

-(id) init {
	if((self = [super init])) {
		acceptsDamage = YES;
		weaponLevel = 1;
		upgradePrice = 100;
		cooldown = 0;
		maxCooldown = 5;
	}
	return self;
}

-(void) setupSwingSpritesWithRect:(CGRect)rect image:(NSString*)image atPoint:(CGPoint)p {

	// we setup a trick here, because we want the cannon barrel to pivot at one 
	// end of the base, we'll make the sprite box twice as long, and set the center
	// to either end of the cannon
    
	self.swingSprite = spriteWithRect(image, rect);
	[[Battlefield instance] addChild:swingSprite z:PIECE_Z_INDEX];
	swingSprite.position = ccp(p.x, p.y);
	
    
	// define the shadow sprites
    
	self.backSwingSprite = spriteWithRect(image, rect);
	backSwingSprite.flipX = YES;
	[[Battlefield instance] addChild:backSwingSprite z:FAR_PIECE_Z_INDEX];
	backSwingSprite.position = ccp(p.x, p.y+PLAYER_BACKGROUND_HEIGHT);
	[backSwingSprite setScale:1/BACKGROUND_SCALE_FACTOR];
	
	hasBeenPlaced = NO;
	acceptsTouches = YES;
	
}

-(void) updateSpritesAngle:(float)ang position:(b2Vec2)pos time:(float)t {
	
	if(self.cooldown > 0) {
		self.cooldown -= t;
        
		if(self.cooldown <= 0 && self.owner) {
			self.cooldown = 0;
            
			if(self.owner.ai) { 
                [self.owner.ai readyToFire:self]; 
            }
		}
	}
	
	if(self.cdSprite && self.currentSprite) { 
		self.cdSprite.position = ccpAdd(self.currentSprite.position, ccp(5.0, 10.0)); 
	}

}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	[StaticUtils snapVerticallyToClasses:[NSArray arrayWithObjects:[Tower class], [Turret class], [Balcony class], [Wall class], [Merlin class], [Arch class], nil] 
							   withPoint:&pos 
							   fromPiece:self
								   world:world];	
	return pos;
}

-(void) moveObject:(CGPoint)touch {
	[super onTouchMoved:touch];
}

-(void) setIsFacingLeft:(BOOL)l {
	isFacingLeft = l;
	self.currentSprite.flipX = isFacingLeft;
	swingSprite.flipY = isFacingLeft;
}

-(void) onTouchBegan:(CGPoint)touch {
	
	// get touch location in landscape 
	initialTouch = touch;
	shotPower = 0;
	
	if(hasBeenPlaced && [self isUsable]) {
        self.shootIndicatorTail = sprite(@"shootIndicatorTail.png");
        self.shootIndicatorTop = sprite(@"shootIndicatorTop.png");
        
        self.shootIndicatorTail.position = self.swingSprite.position;
        self.shootIndicatorTop.position = touch;
        
        self.shootIndicatorTail.anchorPoint = ccp(0.5,0);
        self.shootIndicatorTop.anchorPoint = ccp(0.5, 0);
        
        [self.shootIndicatorTail setScaleY:(1/130.0)];
        
        self.shootIndicatorTop.visible = NO;
        self.shootIndicatorTail.visible = NO;
        
        [[Battlefield instance] addChild:self.shootIndicatorTail z:6];
        [[Battlefield instance] addChild:self.shootIndicatorTop z:6];
	}
	
}

-(void) onTouchMoved:(CGPoint)touch {

    self.shootIndicatorTop.visible = YES;
    self.shootIndicatorTail.visible = YES;

	if(!hasBeenPlaced) {
		[self moveObject:touch];
		
		// make the object transparent
		[self.currentSprite setOpacity:HUD_ITEM_DRAG_OPACITY];
		[self.swingSprite setOpacity:HUD_ITEM_DRAG_OPACITY];
        
        [self.currentSprite setScale:HUD_ITEM_DRAG_SIZE];
        [self.swingSprite setScale:HUD_ITEM_DRAG_SIZE];
        
		shotPower = 0;
	}
	
	// calculate angle of current pull
	float h = touch.y - initialTouch.y;
	float w = touch.x - initialTouch.x;
	
        
    // convert angle to cocos2d angle
	currentShotAngle = atan2(w, h);
    currentShotAngle += M_PI_2;
    

    // shot power is simply the length of the pull
	shotPower = MIN(WEAPON_MAX_POWER, b2Vec2(w,h).Length());
	
    
    float minAngle = MAX(0, CC_DEGREES_TO_RADIANS(self.currentSprite.rotation));
    float maxAngle = MIN(M_PI, CC_DEGREES_TO_RADIANS(self.currentSprite.rotation) + M_PI);
    

    if(currentShotAngle < minAngle) {
        currentShotAngle = minAngle;
    }

    if(currentShotAngle > maxAngle) {
		currentShotAngle = maxAngle;
	}
    
    float tailScale = shotPower/80.0;
    float pixelsInFront = 20;
    float headPixelsInFront = tailScale * self.shootIndicatorTail.texture.contentSize.height;
	
	if(![self isUsable]) { return; }
	
    
    self.shootIndicatorTail.rotation = CC_RADIANS_TO_DEGREES(currentShotAngle) - 90.f;
    self.shootIndicatorTop.rotation = CC_RADIANS_TO_DEGREES(currentShotAngle) - 90.f;
    
    self.shootIndicatorTail.position = ccpSub(self.swingSprite.position, ccp(cos(-currentShotAngle)*pixelsInFront,sin(-currentShotAngle)*pixelsInFront));
    self.shootIndicatorTop.position = ccpSub(self.shootIndicatorTail.position, ccp(cos(-currentShotAngle)*headPixelsInFront, sin(-currentShotAngle)*headPixelsInFront));
                                       
    [self.shootIndicatorTail setScaleY:tailScale];
    
    
    if(!hasBeenPlaced) { shotPower = 0; }

}

-(BOOL) onTouchEnded:(CGPoint)touch {
	if(!hasBeenPlaced) {
		[super onTouchEnded:touch];
		return YES;
	}
	
    return [self onTouchEndedLocal:touch];
}

-(BOOL) shouldDestroy {
    BOOL isSleeping = !self.body->IsAwake();
    BOOL isTiltedTooFar = ((int) CC_RADIANS_TO_DEGREES(body->GetAngle())%360) > MAX_TILT_FOR_WEAPON || ((int) CC_RADIANS_TO_DEGREES(body->GetAngle())%360) < -MAX_TILT_FOR_WEAPON;
    
    return [super shouldDestroy] || (isTiltedTooFar && isSleeping && hasBeenPlaced);
}

-(void) unselect {
	[super unselect];
	
	if(shootIndicatorTop) { 
        [[Battlefield instance] removeChild:shootIndicatorTop cleanup:YES]; 
    }
    if(shootIndicatorTail) { 
        [[Battlefield instance] removeChild:shootIndicatorTail cleanup:YES]; 
    }
    
	self.shootIndicatorTail = nil;
    self.shootIndicatorTop = nil;
}

-(BOOL) onTouchEndedLocal:(CGPoint)touch {
	[self doesNotRecognizeSelector:_cmd];
	return NO;
}

-(void) fired:(Projectile*)p {
	[self fired:p follow:YES];
}

-(void) fired:(Projectile*)p follow:(BOOL)follow {
	cooldown = maxCooldown;
	
	if(self.owner == [[Battlefield instance].playerAreaManager getCurrentPlayerArea]) {
		if(follow) { [[Battlefield instance] setLastShot:p]; }
	}
	
	self.cdSprite = [CCSprite spriteWithFile:@"timer_00000.png"];
	CCAnimation* anim = [CCAnimation animation];
    anim.delay = cooldown/59.f;
	
	for(int i=0;i<59;++i) {
		[anim addFrameWithFilename:[NSString stringWithFormat:@"timer_000%02d.png", i]];
	}
	
	id action = [CCAnimate actionWithAnimation:anim];
	id seq = [CCSequence actionOne:action two:[CCCallFunc actionWithTarget:self selector:@selector(removeCooldownImage)]];
	
	[[Battlefield instance] addChild:cdSprite z:ANIMATION_Z_INDEX];
	[cdSprite runAction:seq];
	
}

-(void) removeCooldownImage {
	[[Battlefield instance] removeChild:cdSprite cleanup:YES];
	self.cdSprite = nil;
}

-(BOOL) isUsable {
	
	Battlefield* bf = [Battlefield instance];
	BOOL isFromLocal = self.owner == [bf.playerAreaManager getCurrentPlayerArea];
	
	if(((int) CC_RADIANS_TO_DEGREES(body->GetAngle())%360) > MAX_TILT_FOR_WEAPON || 
	   ((int) CC_RADIANS_TO_DEGREES(body->GetAngle())%360) < -MAX_TILT_FOR_WEAPON) {
		
		if(isFromLocal) { [bf.hud showMessage:@"Weapon tilted too far to use"]; }
		
		return NO;
	}
	
	if(![[Battlefield instance] canFire]) { return NO; }
	
	if(self.owner.ai == nil && cooldown>0) { return NO; }
	
	return YES;
}

-(void) updateView {
	[super updateView];
	
	if (acceptsPlayerColoring) {
		self.swingSprite.color = [[GameSettings instance] getColorForPlayer:self.owner]; 
		self.backSwingSprite.color = [[GameSettings instance] getColorForPlayer:self.owner]; 	
	} else {
		swingSprite.color = ccc3(255, 255, 255);
		backSwingSprite.color = ccc3(255, 255, 255);
	}
	
}

-(void) upgradeLevel {
	
	if(![self.owner canAfford:[self getUpgradePrice]]) {
		[[Battlefield instance].hud showMessage:@"Not enough gold."];
		return;
	}
	
	[self.owner removeMoney:[self getUpgradePrice]];
	
    [self upgradeLevelLocal];
	
}

-(void) upgradeLevelLocal {
	weaponLevel++;
	[[SimpleAudioEngine sharedEngine] playEffect:@"upgrade.caf"];
	[self updateView];
	[self setIsChanged:!isChanged];
}

-(int) getUpgradePrice {
	return upgradePrice;
}

-(void) restoreToState:(NSDictionary*)state {
	[super restoreToState:state];
	weaponLevel = [[state objectForKey:@"level"] intValue];
}

-(NSDictionary*) getPieceData {
	NSMutableDictionary* pd = (NSMutableDictionary*)[super getPieceData];
	
	[pd setObject:[NSString stringWithFormat:@"%d", weaponLevel] forKey:@"level"]; 
	
	return pd;
}

-(void) finalizePiece {
	
	if(self.owner) { [self.owner setHasWeapon:YES]; }
	
	[self updateView];
	[swingSprite setOpacity:255];
    [swingSprite setScale:1];
	[super finalizePiece];
}

- (void) dealloc {
    [swingSprite release];
    [backSwingSprite release];
    [shootIndicatorTail release];
    [shootIndicatorTop release];
    [cdSprite release];
    
    [super dealloc];
}

@end
