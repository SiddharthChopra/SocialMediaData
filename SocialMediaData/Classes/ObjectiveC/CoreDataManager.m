//
//  MyCity311CoreDataManager.m
//  MyCity311
//
//  Created by Piyush on 6/8/16.
//  Copyright © 2016 Kahuna Systems. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()
@property (nonatomic, strong) NSString *dbName;
@end

@implementation CoreDataManager

@synthesize managedObjectModel = _managedObjectModel;
//@synthesize managedObjectContext = _managedObjectContext;
@synthesize customManagedObjectContext = _customManagedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoreDataManager *)sharedInstance
{
    static dispatch_once_t predicate;
    static CoreDataManager *instance = nil;
    dispatch_once(&predicate, ^{instance = [[self alloc] init];});
    return instance;
}

- (NSString*) getDatabaseName
{
    return @"SocialMedia";
}

-(void)setDatabaseName:(NSString *)string{
    self.dbName = string;
}

-(void)setManagedObjectContextFromApp:(NSManagedObjectContext *)managedObjectContext {
    self.customManagedObjectContext = managedObjectContext;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.dbName = [self getDatabaseName];
    }
    return self;
}


#pragma mark - manage entities

- (id) createEntinty:(NSString*)entityName
{
    NSManagedObjectContext *context = self.customManagedObjectContext;
    id newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    //[self saveContext];
    return newObject;
}

- (NSMutableArray*)managedobjects:(NSString *)entityName{
    
    NSManagedObjectContext *context = self.customManagedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.customManagedObjectContext executeFetchRequest:req error:&error] mutableCopy];
    return mutableFetchResults;
}

- (NSMutableArray*)objects:(NSString *)entityName
{
    NSManagedObjectContext *context = self.customManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSMutableArray *dataArray;// =[[NSMutableArray alloc]init];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entity];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.customManagedObjectContext executeFetchRequest:req error:&error] mutableCopy];
    if (!mutableFetchResults) {
        //****NSLog(@"%@",error);
        return mutableFetchResults;
    }
    else
    {
        dataArray = mutableFetchResults;// [NSMutableArray arrayWithArray:mutableFetchResults];
    }
    return dataArray;
}

- (NSArray *)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *context = self.customManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entity];
    [req setPredicate:predicate];
    NSError *error;
    NSArray *mutableFetchResults = [[self.customManagedObjectContext executeFetchRequest:req error:&error] mutableCopy];
    
    return mutableFetchResults;
}


-(NSString *)timeInterval:(double)interval{
    double timestampComment = interval/1000;
    NSTimeInterval diff = (NSTimeInterval)timestampComment;
    NSDate *methodStart = [NSDate dateWithTimeIntervalSince1970:diff] ;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"] ; //hh:mm:ss a
    ////****NSLog(@"result: %@", [dateFormatter stringFromDate:methodStart]);
    return [dateFormatter stringFromDate:methodStart];
}

- (id)firstObject:(NSString *)entityName predicate:(NSPredicate *)predicate
{
    NSArray *result = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.customManagedObjectContext];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entity];
    [req setPredicate:predicate];
    @try
    {
        result = [self.customManagedObjectContext executeFetchRequest:req error:nil];
    }
    @catch(NSException *exception)
    {
        //****NSLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
    }
    
    return ([result count] == 0 ? nil : [result objectAtIndex:0]);
}

- (NSArray *)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate WithSortKey:(NSString*)sortKey WithAscending:(BOOL) ascending
{
    NSArray *result = nil;
    
    NSManagedObjectContext *context = self.customManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entity];
    [req setPredicate:predicate];
    [req setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending],nil]];
    
    @try
    {
        result = [context executeFetchRequest:req error:nil];
    }
    @catch(NSException *exception)
    {
        //****NSLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
    }
    
    return ([result count] == 0 ? nil : result);
}


- (NSArray *)objects:(NSString *)entityName WithSortKey:(NSString*)sortKey WithAscending:(BOOL) ascending{
    
    NSArray *result = nil;
    
    NSManagedObjectContext *context = self.customManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entity];
    [req setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending],nil]];
    
    @try
    {
        result = [context executeFetchRequest:req error:nil];
    }
    @catch(NSException *exception)
    {
        //****NSLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
    }
    
    return ([result count] == 0 ? nil : result);
}


#pragma mark - Core Data stack

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.customManagedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void) clear
{
    @synchronized(self){
        self.isDeleting=YES;
        NSDictionary *allES = [[self managedObjectModel] entitiesByName];
        for (NSString *esName in allES) {
            NSArray *objects = [self objects:esName];
            //[self deleteObj:esName];
            [self deleteObj2];
            for (NSManagedObject *obj in objects) {
                //****NSLog(@"%@ %d", esName, objects.count);
                [self.customManagedObjectContext deleteObject:obj];
            }
        }
        [self saveContext];
        self.isDeleting=NO;
    };
}

-(void)deleteObj2
{
    //Erase the persistent store from coordinator and also file manager.
    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
    NSError *error = nil;
    NSURL *storeURL = store.URL;
    [self.persistentStoreCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    
    
    //****NSLog(@"Data Reset");
    
    //Make new persistent store for future saves   (Taken From Above Answer)
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // do something with the error
    }
    
}

-(void)deleteObj:(NSString *)esName
{
    NSManagedObjectContext *context = self.customManagedObjectContext; // your managed object context
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:esName];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_customManagedObjectContext != nil) {
     return _customManagedObjectContext;
    }
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.dbName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL =[[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.dbName]];
    //****NSLog(@"storeURL: %@", storeURL.absoluteString);
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        //****NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - fetch data from DB

-(NSMutableArray*) fetchAllEventDataFromDB:(NSString *) entityName
{
    NSManagedObjectContext *context = self.customManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entity];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.customManagedObjectContext executeFetchRequest:req error:&error] mutableCopy];
    if (!mutableFetchResults)
    {
        NSLog(@"%@",error);
    }
    else
    {
        if ([mutableFetchResults count] > 0)
        {
            if([entityName isEqualToString:entityName])
            {
                //                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"eventID" ascending:YES];
                //                NSArray *descriptors = [NSArray arrayWithObject:descriptor];
                /// NSArray *reverseOrder = [mutableFetchResults sortedArrayUsingDescriptors:descriptors];
                return mutableFetchResults;
            }
            else
                return mutableFetchResults;
        }
    }
    return dataArray;
}

#pragma mark - fetch data from DB

-(NSMutableArray*) fetchAllEventDataFromDB:(NSString *) entityName withPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *context = self.customManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setReturnsObjectsAsFaults:NO];
    [req setEntity:entity];
    if(predicate && (NSNull *)predicate != [NSNull null])
        [req setPredicate:predicate];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.customManagedObjectContext executeFetchRequest:req error:&error] mutableCopy];
    if (!mutableFetchResults)
    {
        NSLog(@"%@",error);
    }
    else
    {
        if ([mutableFetchResults count] > 0)
        {
            if([entityName isEqualToString:entityName])
            {
                //                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"eventID" ascending:YES];
                //                NSArray *descriptors = [NSArray arrayWithObject:descriptor];
                /// NSArray *reverseOrder = [mutableFetchResults sortedArrayUsingDescriptors:descriptors];
//                if([entityName isEqualToString:@"APN"])
//                {
//                    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
//                    for(APN *apnOject in mutableFetchResults)
//                    {
//                        [responseArray addObject:apnOject];
//                        //                        APN *apnOject = [mutableFetchResults objectAtIndex:0];
//                        //                        NSLog(@"%@", apnOject.aPN);
//                    }
//                    return responseArray;
//                    
//                }
                return mutableFetchResults;
            }
            else
                return mutableFetchResults;
        }
    }
    return dataArray;
}


- (void) deleteEntity:(id) entity
{
    NSManagedObjectContext *context = self.customManagedObjectContext; // your managed object context
    [context deleteObject:entity];
}

@end
