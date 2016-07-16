//
//  DataDownloader.h
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTaskProtocol.h"
#import "ModelManager.h"

@interface NetworkClass : NSObject<NSURLSessionDownloadDelegate>

//This method downloads date for the URL provided and calls 'DownloadTaskProtocol' delegate method when done
-(void)downloadDataforURL:(NSURL *)url withIdentifier:(NSString *)identifier;

//Delegate
@property (weak,nonatomic) id <DownloadTaskProtocol> delegate; 

@end
