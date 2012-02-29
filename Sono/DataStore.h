//
//  DataStore.h
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

+ (DataStore *)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)saveContext:(NSError **)error;
- (void)rollback;

- (NSURL *)applicationDocumentsDirectory;
- (NSFetchedResultsController *)fetchEntity:(NSString *)entityName sortDescriptor:(NSArray *)sortDescriptors delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
- (id)insertNewObject:(NSString *)entityName;
- (void)deleteObject:(id)object;


@end
