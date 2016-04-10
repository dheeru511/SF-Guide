//
//  DownloadTaskDelegate.h
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadTaskProtocol <NSObject>

-(void) loadDatawithDictionary:(NSDictionary *)dictionary forIdentifier:(NSString *)identifier;

@end
