//
//  Server+CoreDataProperties.h
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/22/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Server.h"

NS_ASSUME_NONNULL_BEGIN

@interface Server (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSSet<Groups *> *groups;

@end

@interface Server (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Groups *)value;
- (void)removeGroupsObject:(Groups *)value;
- (void)addGroups:(NSSet<Groups *> *)values;
- (void)removeGroups:(NSSet<Groups *> *)values;

@end

NS_ASSUME_NONNULL_END
