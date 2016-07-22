//
//  Groups+CoreDataProperties.h
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/22/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Groups.h"

NS_ASSUME_NONNULL_BEGIN

@interface Groups (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *group_id;
@property (nullable, nonatomic, retain) NSNumber *group_is_active;
@property (nullable, nonatomic, retain) NSString *group_name;
@property (nullable, nonatomic, retain) NSString *group_status;
@property (nullable, nonatomic, retain) NSSet<Students *> *students;
@property (nullable, nonatomic, retain) Server *server;

@end

@interface Groups (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Students *)value;
- (void)removeStudentsObject:(Students *)value;
- (void)addStudents:(NSSet<Students *> *)values;
- (void)removeStudents:(NSSet<Students *> *)values;

@end

NS_ASSUME_NONNULL_END
