//
//  MyCity311CoreDataManager.h
//  MyCity311
//
//  Created by Piyush on 6/8/16.
//  Copyright © 2016 Kahuna Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *customManagedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign, nonatomic) BOOL isDeleting;

+ (CoreDataManager *)sharedInstance;

- (NSString*) getDatabaseName;

- (void)saveContext;

- (void) clear;

- (id) createEntinty:(NSString*)entityName;

-(void) deleteEntity:(id) entity;

- (NSMutableArray*)managedobjects:(NSString *)entityName;

- (NSArray *)objects:(NSString *)entityName;

- (NSArray *)objects:(NSString *)entityName
       withPredicate:(NSPredicate *)predicate;

- (id) firstObject:(NSString *)entityName
         predicate:(NSPredicate *)predicate;

- (NSArray *)objects:(NSString *)entityName
       withPredicate:(NSPredicate *)predicate
         WithSortKey:(NSString*)sortKey
       WithAscending:(BOOL) ascending;

-(NSArray *)objects:(NSString *)entityName
        WithSortKey:(NSString*)sortKey
      WithAscending:(BOOL) ascending;

-(void)deleteObj:(NSString *)esName;


-(NSMutableArray *) fetchAllEventDataFromDB:(NSString *) entityName;
-(NSMutableArray*) fetchAllEventDataFromDB:(NSString *) entityName withPredicate:(NSPredicate *)predicate;


@end
