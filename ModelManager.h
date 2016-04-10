//
//  PopulateModel.h
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NetworkClass.h"
#import "District.h"
#import "Incident.h"
#import "Constants.h"
#import "DownloadTaskProtocol.h"
#import "MapViewDataSource.h"



@interface ModelManager : NSObject<DownloadTaskProtocol>

// This method initiates districts info download. This is called by veiw controller during launch
-(void)downloadDistricts;

//This method initiates incidents info download based on the coordinates provided. This is called by veiw controller when region on mapview changes
-(void)downloadIncidentsForCoordinates:(NSArray *)coordinates andCount:(NSNumber *)count;

// This method populates model objects.It is a Delegate method of 'DownloadTaskProtocol' protocol called by network layer once download is finished

-(void)loadDatawithDictionary:(NSArray *)dataArray forIdentifier:(NSString *)identifier;


@property (strong,nonatomic) NSMutableArray<District *> * districts;
@property (strong,nonatomic) NSMutableArray<Incident *> * incidents;
@property (strong,nonatomic) id<MapViewDataSource> delegate;

@end
