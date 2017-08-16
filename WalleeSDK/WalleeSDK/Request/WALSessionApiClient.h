//
//  WALSessionApiClient.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WALSessionApiClient : NSObject

+(instancetype)clientWithBaseUrl:(NSString*)baseUrl;
-(void) buildMobileSdkUrl;
@end
