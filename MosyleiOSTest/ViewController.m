//
//  ViewController.m
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/21/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import "ViewController.h"

#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

#import "Server.h"
#import "Groups.h"
#import "Students.h"

@interface ViewController ()

@property NSArray *groups;

@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self requestURL];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    Groups *groupsList = self.groups[indexPath.row];
//    cell.textLabel.text = groupsList.group_name;
//    return cell;
    
    //Order array alphabetical
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"student_name" ascending:YES];
    self.groups = [self.groups sortedArrayUsingDescriptors:@[sort]];
    
    Students *studentsList = self.groups[indexPath.row];
    cell.textLabel.text = studentsList.student_name;
    return cell;
}

#pragma mark - RESTKit

- (void)requestData {
    
    NSString *requestPath = @"/json_example.php";
    
    [[RKObjectManager sharedManager]
     getObjectsAtPath:requestPath
     parameters:nil
     success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         //Groups have been saved in core data by now
         [self fetchGroupsFromContext];
     }
     failure: ^(RKObjectRequestOperation *operation, NSError *error) {
         RKLogError(@"Load failed with error: %@", error);
     }
     ];
    
}

- (void)fetchGroupsFromContext {
    //Add and order alphabetical array
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Groups"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"group_name" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    Groups *groupList = [fetchedObjects firstObject];
    self.groups = [groupList.students allObjects];
    
    [self.tableView reloadData];
}

@end
