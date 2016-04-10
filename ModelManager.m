//
//  PopulateModel.m
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import "ModelManager.h"


@interface ModelManager()

@property (strong,nonatomic) NetworkClass * dataDownloader;
@property (strong,nonatomic) NSDateFormatter * formatter;
@end

@implementation ModelManager

//Lazy Instantiation
-(NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}


//Lazy Instantiation
-(NSMutableArray *)districts
{
    if (!_districts) {
        _districts=[[NSMutableArray alloc]init];
    }
    return _districts;
}

//Lazy Instantiation
-(NSMutableArray *)incidents
{
    if (!_incidents) {
        _incidents=[[NSMutableArray alloc]init];
    }
    
    return _incidents;
}

//Lazy Instantiation
-(NetworkClass *)dataDownloader
{
    if (!_dataDownloader) {
        _dataDownloader=[[NetworkClass alloc]init];
        _dataDownloader.delegate=self;
    }
    
    return _dataDownloader;
}

// This method initiates districts info download. This is called by veiw controller during launch

-(void)downloadDistricts
{
    NSURL * url= [NSURL URLWithString:@"https://data.sfgov.org/resource/cuks-n6tp.json?$select=pddistrict,COUNT(incidntnum),convex_hull(location)&$group=pddistrict&$order=COUNT(incidntnum)desc"];
    
    [self.dataDownloader downloadDataforURL:url withIdentifier:Districts];
}

//This method initiates incidents info download based on the coordinates provided. This is called by veiw controller when region on mapview changes

-(void)downloadIncidentsForCoordinates:(NSArray *)coordinates andCount:(NSNumber *)count
{
    NSValue * northWestvalue = coordinates[0];
    CLLocationCoordinate2D northWest = [northWestvalue MKCoordinateValue];
    NSValue * southEastValue = coordinates[1];
    CLLocationCoordinate2D southEast = [southEastValue MKCoordinateValue];
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    NSDate * monthAgoDate = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    NSString * monthAgoDateString = [self dateToString:monthAgoDate];
    NSString * urlString = [NSString stringWithFormat:@"https://data.sfgov.org/resource/cuks-n6tp.json?$select=x,y,date,category,incidntnum,address&$where=within_box(location,%lf,%lf,%lf,%lf) AND date > '%@'&$order=date desc&$limit=50&$offset=%@",northWest.latitude,northWest.longitude,southEast.latitude,southEast.longitude,monthAgoDateString,count];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:urlString];
    [self.dataDownloader downloadDataforURL:url withIdentifier:Incidents];
}


// This method populates model objects.It is a Delegate method of 'DownloadTaskProtocol' protocol called by network layer once download is finished

-(void) loadDatawithDictionary:(NSArray *)dataArray forIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:Districts]) {
        [self loadDistricts:dataArray];
    }else if ([identifier isEqualToString:Incidents]){
        [self loadIncidents:dataArray];
        
    }
}


-(void)loadDistricts:(NSArray *)data
{
    for (NSDictionary * obj in data) {
        District * district = [[District alloc]init];
        district.districtName = obj[@"pddistrict"];
        district.incidentsCount = obj[@"COUNT_incidntnum"];
        district.districtCoordinatesPolygon=[self createMKPloygonwithDictionary:obj];
        [self.districts addObject:district];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate loadDistricts:self.districts];
    });
    
}

-(void)loadIncidents:(NSArray *)data
{
    self.incidents=nil;
    
    
    for (NSDictionary * obj in data) {
        
        Incident * incident = [[Incident alloc]init];
        incident.category = obj[@"category"];
        NSString * datetimeString=obj[@"date"];
        NSString * dateString=[datetimeString substringWithRange:NSMakeRange(0, 10)];
        incident.incidentDate = dateString;
        incident.incidentAddress= obj[@"address"];
        incident.coordinate = CLLocationCoordinate2DMake([[obj valueForKey:@"y"] doubleValue], [[obj valueForKey:@"x"] doubleValue]);
        [self.incidents addObject:incident];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate loadIncidents:self.incidents];
    });
}

// creates MKPolygon object object from the array of coordinates provided

-(MKPolygon *)createMKPloygonwithDictionary:(NSDictionary *)dictionary
{
    NSArray * coordinatesInternStruct1= [dictionary valueForKeyPath:@"convex_hull_location.coordinates"];
    NSArray * coordinatesInternStruct2 = [coordinatesInternStruct1 firstObject];
    NSArray * coordinates = [coordinatesInternStruct2 firstObject];
    CLLocationCoordinate2D *pointsCoOrds = (CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D) * [coordinates count]);
    NSUInteger index = 0;
    
    for (NSArray * obj in coordinates) {
        
        if (!([obj[1] doubleValue] == 90.0)) {
            CGFloat lat = [obj[1] doubleValue];
            CGFloat lng = [obj[0] doubleValue];
            pointsCoOrds[index++] = CLLocationCoordinate2DMake(lat,lng);
        }
    }
    MKPolygon *polygon =[MKPolygon polygonWithCoordinates:pointsCoOrds count:coordinates.count];
    
    return polygon;
}


// Method to convert date to string
-(NSString *)dateToString:(NSDate *)date
{
    NSString * dateString = [self.formatter stringFromDate:date];
    return dateString;
}




@end
