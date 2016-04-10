//
//  DataDownloader.m
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import "NetworkClass.h"

@interface NetworkClass()

@property (strong,nonatomic) NSOperationQueue * delegateQueue;

@end

@implementation NetworkClass

// Lazy instantion of delegate queue where deledate method is called once download is finished.
-(NSOperationQueue *)delegateQueue
{
    
    if (!_delegateQueue) {
        _delegateQueue = [[NSOperationQueue alloc]init];
        return _delegateQueue;
        
    }
    
    return _delegateQueue;
    
}

-(void)downloadDataforURL:(NSURL *)url withIdentifier:(NSString *)identifier
{
    if (url) {
        NSURLRequest * urlRequest = [[NSURLRequest alloc]initWithURL:url];
        NSURLSessionConfiguration * configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
        
        //Main queue is not used as delegate queue because once download is done, in the delegate method below 'loadDatawithDictionary:forIdentifier' is called.If this method is called on main queue it may block UI as it loops through dictionaries and populate model objects
        
        NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.delegateQueue];
        NSURLSessionDownloadTask * task= [session downloadTaskWithRequest:urlRequest] ;
        task.taskDescription = identifier;
        [task resume];
        
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)localFile
{
    if (localFile) {
        NSDictionary * dataDictionary;
        NSData * data = [NSData dataWithContentsOfURL:localFile];
        if (data) {
            dataDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:NULL];
        }
        [self.delegate loadDatawithDictionary:dataDictionary forIdentifier:downloadTask.taskDescription];
        
    }
}




@end
