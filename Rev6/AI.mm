//
//  AI.mm
//  Rev5
//
//  Created by Bryce Redd on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AI.h"
#import "Battlefield.h"
#import "GameSettings.h"
#import "Cannon.h"
#import "CannonBall.h"
#import "CatapultBall.h"
#import "Catapult.h"
#import "PlayerArea.h"
#import "PlayerAreaManager.h"
#import "GameSettings.h"
#import "Weapon.h"
#import "AppDelegate.h"

@implementation AI

static float CatapultForce = 0;

+(id)aiWithPlayer:(PlayerArea*)p {
	return [[[self alloc] initWithPlayer:p] autorelease];
}

-(id)initWithPlayer:(PlayerArea*)p {

	if((self = [super init])) {
		playerArea = p;

		NSString* baseName = @"basic";
		
		int fileNum = (arc4random()%5)+1;
		
		if([GameSettings instance].type == easy) 
			baseName = @"basic";
		if([GameSettings instance].type == medium)
			baseName = @"medium";
		if([GameSettings instance].type == hard)
			baseName = @"hard";
		if([GameSettings instance].isCampaign) {
			baseName = @"campaign";
			fileNum = [GameSettings instance].territoryID;
		}

		// if campaign, filenum = [gs insantce].territory.id
		// else
		
		NSLog(@"loading filenum: %d", fileNum);
		
		[[Battlefield instance] loadForPlayer:p file:[NSString stringWithFormat:@"%@%d", baseName, fileNum]];
		
		for(Piece* piece in p.pieces) {
			if([piece isKindOfClass:[Weapon class]]) {
				((Weapon*)piece).cooldown = rand() % 10;
			}
		}
		
	} return self;
}

-(void) readyToFire:(Weapon*)w { 

	int numberOfWeapons = 0;
	int r = 0;
	BOOL anyWeapon = NO;
	cannonPicked = NO;
	w.cooldown = w.maxCooldown;
	
	// make sure it's not upside down
	if (![w isUsable]) { return; }
	
	//AI calculation variables
	float Xo = 0;
	float Yo = 0;
	float Xt = 0;
	float Yt = 0;
	float d = 0;
	float V = 0;
	float alpha = 45;
	float Mc = 0;
	float F = 0;
	float H = 0;
	float W = 0;
	float g = -[Battlefield instance].world->GetGravity().y;

	//w is the AI weapon
	if([w isKindOfClass:[Weapon class]]) {

		b2Vec2 weaponPos = w.body->GetPosition();
		
		//in Meters
		CGPoint shootingFrom = CGPointMake(weaponPos.x,weaponPos.y);
		
		Xo = shootingFrom.x;
		Yo = shootingFrom.y;
		
		// get PlayerArea for human
		PlayerArea* humanPA = [[Battlefield instance].playerAreaManager getCurrentPlayerArea];
		
		for(Piece* piece in humanPA.pieces) {
			//find out how many weapons I have -> numberOfCannons
			if ([piece isKindOfClass:[Weapon class]]) {
				numberOfWeapons ++;
				anyWeapon = YES;
				//NSLog(@"number of Cannons: %i",numberOfCannons);
			}
		}
		
		//Pick a weapon if any is present
		if(!anyWeapon){ return; }
    
        r = arc4random() % numberOfWeapons;
        //NSLog(@"Weapon to target is number: %i",r);
        int counter = 0;
        
        for(Piece* piece in humanPA.pieces) {
            if ([piece isKindOfClass:[Weapon class]]) {
                if (counter == r) {
                    //get cannon position
                    b2Vec2 targetWeaponPosition = piece.body->GetPosition();

                    //in Meters
                    CGPoint target = CGPointMake(targetWeaponPosition.x,targetWeaponPosition.y);
                    Xt = target.x;
                    Yt = target.y;
                }
                counter ++;
            }
        }
		
		
        
		////////////////////////////////////////
		/////CALCULATE TRAJECTORY///////////////
		////////////////////////////////////////
		
		//d is the distance between the shooting cannon and the target
		d = fabs(Xt-Xo);
		float Yoffset = (Yt-Yo);

		//get Ball Mass (Mc)
		Mc = ([w isKindOfClass:[Cannon class]]?[CannonBall getMass]:[CatapultBall getMass]);
			
		//Set shooting angle
		//alpha = CC_DEGREES_TO_RADIANS(25+(arc4random()%40));
		alpha = CC_DEGREES_TO_RADIANS(45);
		
		//Calculate Speed
		V = ((g*pow((d), 2)*(1+pow(tan(alpha),2)))/(2*((d)*tan(alpha)-(Yoffset)))); 
		V = sqrt(V);
		//Calculate Cannon Force
		F = V*Mc;
		
		// add variability to the force depending on AI skill
		if([GameSettings instance].type == easy) 
			[self randomizeShot:&F by:EASY_SHOT_VARIATION];
		if([GameSettings instance].type == medium) 
			[self randomizeShot:&F by:MEDIUM_SHOT_VARIATION];
		if([GameSettings instance].type == hard)
			[self randomizeShot:&F by:HARD_SHOT_VARIATION];

		CatapultForce = F;
		
		//Is target to the right or to the left?
		//Then calculate x and y components of Force
		if ((Xt-Xo)>0){
			H = F*sin(alpha);
			W = F*cos(alpha);
		}else {
			H = F*sin(alpha);
			W = -F*cos(alpha);
		}
		
		
		//////END CALCULATION//////////////////

		/*NSLog(@"Angle alpha: %f",alpha);
		NSLog(@"Cannon Ball velocity: %f m/s",V);
		NSLog(@"Force Applied: %f",F);
		NSLog(@"H is: %f",H);
		NSLog(@"W is: %f",W);
		NSLog(@"The Y offset is: %f m",Yt-Yo);
		NSLog(@"Shooting from X position is: %f m",Xo);
		NSLog(@"Shooting from Y position is: %f m",Yo);
		NSLog(@"target X position is: %f m",Xt);
		NSLog(@"target Y position is: %f m",Yt);
		NSLog(@"Distance to target: %f",d);
		NSLog(@"The Mass of the ball is: %f",Mc);*/
		
		//IF THE AI WEAPON IS A CANNON
		if([w isKindOfClass:[Cannon class]]) {
			[(Cannon*)w shootFromAICannon:ccp(W/CANNON_DEFAULT_POWER,H/CANNON_DEFAULT_POWER)];
		} 
		
		//IF AI WEAPON IS A CATAPULT
		if([w isKindOfClass:[Catapult class]]) {
			//NSLog(@"The angle of the weapon is: %f",radiansToDegrees( w.body->GetAngle()));
			[(Catapult*)w shootFromAICatapult:CatapultForce isLeft:(Xt-Xo)<0];
			
		}
		
		
	}

}

-(void) randomizeShot:(float*)f by:(int)variation {
	*f = *f * (float)((rand()%variation)-(variation/2)+100)/100.0;
}


+(float)getCatapultForce{
	return CatapultForce;	
}

-(void) dealloc {
	[super dealloc];
}

@end
