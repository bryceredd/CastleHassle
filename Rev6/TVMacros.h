/*
 *  TVMacros.h
 *  tvclient
 *
 *  Created by Bryce Redd on 7/1/10.
 *  Copyright 2010 i.TV LLC. All rights reserved.
 *
 */

// TVDEBUG is defined in the build settings on Debug only
#define TVDEBUG 
//#undef TVDEBUG

#ifdef TVDEBUG
#define TVLog(__f,...) NSLog(__f, ##__VA_ARGS__)
#else
#define TVLog(__f,...)
#endif

#define setFrameX(_a_, _x_) { CGRect tempframe = _a_.frame; tempframe.origin.x = _x_; _a_.frame = tempframe; }
#define setFrameY(_a_, _y_) { CGRect tempframe = _a_.frame; tempframe.origin.y = _y_; _a_.frame = tempframe; }
#define setFrameWidth(_a_, _w_) { CGRect tempframe = _a_.frame; tempframe.size.width = _w_; _a_.frame = tempframe; }
#define setFrameHeight(_a_, _h_) { CGRect tempframe = _a_.frame; tempframe.size.height = _h_; _a_.frame = tempframe; }

#define printDimensions(__X__) TVLog(@"%s : Origin:(%f, %f) Size:(%f, %f)", #__X__, __X__.frame.origin.x, __X__.frame.origin.y, __X__.frame.size.width, __X__.frame.size.height)
#define printSize(a) TVLog(@"%s : (%f, %f)", #a, a.width, a.height)

#define radiansForOrientation(_a_) (_a_ == UIInterfaceOrientationPortrait? 0 : _a_ == UIInterfaceOrientationLandscapeLeft? M_PI/2.f : _a_ == UIInterfaceOrientationLandscapeRight? -M_PI/2.f : _a_ == UIInterfaceOrientationPortraitUpsideDown?  -M_PI : 0)

#define INCREMENT_NETWORK_ACTIVITY_INDICATOR() [[[UIApplication sharedApplication] delegate] performSelector:@selector(incrementNetworkActivityIndicator)]
#define DECREMENT_NETWORK_ACTIVITY_INDICATOR() [[[UIApplication sharedApplication] delegate] performSelector:@selector(decrementNetworkActivityIndicator)]

#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define RGB(r,g,b) [UIColor colorWithRed:(float)r/0xff green:(float)g/0xff blue:(float)b/0xff alpha:1.0]

#define CGRectShrink(_rect_, _padding_) CGRectMake(_rect_.origin.x+_padding_, _rect_.origin.y+_padding_, _rect_.size.width-_padding_*2, _rect_.size.height-_padding_*2);
#define CGRectScale(_rect_, _scale_) CGRectMake(_rect_.origin.x+(_rect_.size.width-(_rect_.size.width*_scale_))/2.f, _rect_.origin.y+(_rect_.size.height-(_rect_.size.height*_scale_))/2.f, _rect_.size.width*_scale_, _rect_.size.height*_scale_);

#define retina ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
#define ipad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define roundFrame(__a__)  __a__.frame = CGRectMake((int)__a__.frame.origin.x, (int)__a__.frame.origin.y, (int)__a__.frame.size.width, (int)__a__.frame.size.height)
#define roundRect(__a__) __a__ = CGRectMake((int)__a__.origin.x, (int)__a__.origin.y, (int)__a__.size.width, (int)__a__.size.height)

#define setCenterX(__view__, __x__) { __view__.center = CGPointMake(__x__, __view__.center.y); }
#define setCenterY(__view__, __y__) { __view__.center = CGPointMake(__view__.center.x, __y__); }

#define spriteWithRect(__name__, __rect__) [CCSprite spriteWithSpriteFrame:[CCSpriteFrame frameWithTexture:[[CCTextureCache sharedTextureCache] addImage:__name__] rect:__rect__]]
#define sprite(__name__) [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:__name__]]
