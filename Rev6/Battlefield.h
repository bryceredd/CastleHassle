
// import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h" 
#import <AVFoundation/AVFoundation.h>
#import "SimpleAudioEngine.h"

@class Ground, Piece, HUD, PlayerAreaManager, Weapon, Projectile, PlayerArea, City;

@interface Battlefield : CCLayer 
{
	CGPoint initialTouch; 
	float screenMomentum; 
    float payclock;
	BOOL isConstructionTouch;
	BOOL followProjectile;
	BOOL didMoveInFollow;
	BOOL sentLoseWarning;
	BOOL sentFinalLoseWarning;
	float cameraXBeforeShot;
	float gameTime;
    
    @public
    BOOL touchDown;
}

@property(nonatomic) BOOL sentLoseWarning;
@property(nonatomic) BOOL sentFinalLoseWarning;
@property(readonly) float gameTime;
@property(nonatomic) b2World* world;
@property(nonatomic, retain) HUD *hud;
@property(nonatomic, retain) Piece *selected;
@property(nonatomic, retain) Piece *lastCreated;
@property(nonatomic, retain) NSMutableArray *touchables;
@property(nonatomic, retain) NSMutableArray *tileables;
@property(nonatomic, retain) NSMutableArray *bin;
@property(nonatomic, retain) PlayerAreaManager *playerAreaManager;
@property(nonatomic, retain) Projectile* lastShot;


// returns a Scene that contains the scene as the only child
+(id) scene;

+(Battlefield *) instance;
+(void) resetInstance;

-(bool) canFire;
-(void) moveScreen;
-(void) tileImagePool:(CGPoint)loc delta:(CGPoint)d;
-(BOOL) playerDidWin;
-(void) checkForLoser:(float)dt;
-(void) loseGame;
-(void) winGame;


-(void) save;
-(void) loadForPlayer:(PlayerArea*)player file:(NSString*)filename;
-(void) setLastShot:(Projectile*)proj;
-(void) resetTileImagePool:(CGPoint)loc;
-(void) resetScreenToX:(float)x;
-(CGPoint) transformTouchesToPoint:(NSSet *)touches withCameraOffset:(BOOL)cam;
-(Piece*) getClosestPiece:(CGPoint)location;
-(void) addProjectileToBin:(Projectile*)p;

-(void) setSelected:(Piece *)p updateHUD:(bool)b;
-(void) addNewPieceWithCoords:(CGPoint)p andClass:(Class)c withImageName:(NSString *)managerName finalize:(BOOL)finalize player:(PlayerArea*)player;

-(void) cleanupTick:(Piece *)piece body:(b2Body *)b;

@end
 