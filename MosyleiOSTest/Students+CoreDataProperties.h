//
//  Students+CoreDataProperties.h
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/22/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Students.h"

NS_ASSUME_NONNULL_BEGIN

@interface Students (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *student_id;
@property (nullable, nonatomic, retain) NSString *student_name;
@property (nullable, nonatomic, retain) NSString *student_photo;
@property (nullable, nonatomic, retain) Groups *groups;

@end

NS_ASSUME_NONNULL_END
