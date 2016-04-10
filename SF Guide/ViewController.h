//
//  ViewController.h
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewDataSource.h"
#import "ModelManager.h"
#import "UIColor+fromHex.h"

@interface ViewController : UIViewController<MapViewDataSource,MKMapViewDelegate>

// This is a delegate method that will be called when districts and district polygons are downloaded by model to update UI
-(void)loadDistricts:(NSMutableArray *)districts;

// This is a delegate method that will be called when incidents are downloaded by model to update UI

-(void)loadIncidents:(NSMutableArray *)incidents;



@end

