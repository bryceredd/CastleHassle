//
//  PListReader.h
//  ProSound
//
//  Created by Bryce Redd on 10/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PLIST_FILE_NAME @"Settings.plist"

@interface PListReader : NSObject {

}

+ (NSDictionary *)getAppPlist;
+ (void)saveAppPlist:(NSDictionary *)plistDict;

@end
