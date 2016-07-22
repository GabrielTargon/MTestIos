//
//  AppDelegate.m
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/21/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Initialize RestKit
    NSURL *baseURL = [NSURL URLWithString:@"https://mosyle.com"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    
    // Initialize managed object model from bundle
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    // Initialize managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    objectManager.managedObjectStore = managedObjectStore;
    
    
    // Complete Core Data stack initialization
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"GroupsDB.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    
    //CORE DATA STRUCTURE
    //Group
    RKEntityMapping *serverListMapping = [RKEntityMapping mappingForEntityForName:@"Server" inManagedObjectStore:managedObjectStore];
    serverListMapping.identificationAttributes = @[ @"status" ];
    [serverListMapping
     addAttributeMappingsFromDictionary:
     @{
       @"status" : @"status"
       }
     ];
    
    //Groups
    RKEntityMapping *groupStudentsMapping = [RKEntityMapping mappingForEntityForName:@"Groups" inManagedObjectStore:managedObjectStore];
    groupStudentsMapping.identificationAttributes = @[ @"group_name" ];
    [groupStudentsMapping
     addAttributeMappingsFromDictionary:
     @{
       @"group_name" : @"group_name",
       @"group_id" : @"group_id",
       @"group_status" : @"group_status",
       @"group_is_active" : @"group_is_active"
       }
     ];
    
    //Students
    RKEntityMapping *studentsListMapping = [RKEntityMapping mappingForEntityForName:@"Students" inManagedObjectStore:managedObjectStore];
    studentsListMapping.identificationAttributes = @[ @"student_name" ];
    [studentsListMapping
     addAttributeMappingsFromArray:
     @[@"student_name", @"student_id", @"student_photo"]];
    
    
    //CONNECTION
    [serverListMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"groups"
                                                 toKeyPath:@"groups"
                                               withMapping:groupStudentsMapping]
     ];
    
    [groupStudentsMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"group_students"
                                                 toKeyPath:@"students"
                                               withMapping:studentsListMapping]
     ];
    
    RKResponseDescriptor *groupListResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:serverListMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/json_example.php"
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [objectManager addResponseDescriptor:groupListResponseDescriptor];
    
    // Enable Activity Indicator Spinner
    [AFRKNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

@end
