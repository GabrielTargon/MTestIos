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
#import "HeaderTableViewCell.h"
#import "CellTableViewCell.h"

@interface ViewController ()

@property NSArray *server;
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
    return [self.server count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groups count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Order array alphabetical
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"student_name" ascending:YES];
    self.groups = [self.groups sortedArrayUsingDescriptors:@[sort]];
    
    CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Students *studentsList = self.groups[indexPath.row];
    cell.textLabel.text = studentsList.student_name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderTableViewCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    headerCell.titleHeader.text = @"Group 1";

    return headerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section-%ld, row-%ld", (long)indexPath.section, (long)indexPath.row);
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
    //Fetch and order alphabetical array
    //SERVER
    NSManagedObjectContext *contextServer = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequestServer = [NSFetchRequest fetchRequestWithEntityName:@"Server"];
    NSSortDescriptor *descriptorServer = [NSSortDescriptor sortDescriptorWithKey:@"status" ascending:YES];
    fetchRequestServer.sortDescriptors = @[descriptorServer];
    NSError *errorServer = nil;
    NSArray *fetchedObjectsServer = [contextServer executeFetchRequest:fetchRequestServer error:&errorServer];
    
    Server *serverList = [fetchedObjectsServer firstObject];
    self.server = [serverList.groups allObjects];
    
    //GROUPS
    NSManagedObjectContext *contextGroups = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequestGroups = [NSFetchRequest fetchRequestWithEntityName:@"Groups"];
    NSSortDescriptor *descriptorGroups = [NSSortDescriptor sortDescriptorWithKey:@"group_name" ascending:YES];
    fetchRequestGroups.sortDescriptors = @[descriptorGroups];
    NSError *errorGroups = nil;
    NSArray *fetchedObjectsGroups = [contextGroups executeFetchRequest:fetchRequestGroups error:&errorGroups];
    
    Groups *groupList = [fetchedObjectsGroups firstObject];
    self.groups = [groupList.students allObjects];
    
    [self.tableView reloadData];
}

@end
