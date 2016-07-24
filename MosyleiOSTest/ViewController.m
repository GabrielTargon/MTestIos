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
@property NSArray *fetchedObjectsGroups;

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
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(requestData)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.server != 0) {
        return [self.server count];
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
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
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"student_name"
                                                        ascending:YES
                                                         selector:@selector(localizedStandardCompare:)];
    self.groups = [self.groups sortedArrayUsingDescriptors:@[sort]];
    
    CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Students *studentsList = self.groups[indexPath.row];
    cell.textLabel.text = studentsList.student_name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //Order array alphabetical
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"group_name"
                                                        ascending:YES
                                                         selector:@selector(localizedStandardCompare:)];
    self.server = [self.server sortedArrayUsingDescriptors:@[sort]];
    
    HeaderTableViewCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    Groups *groupsList = self.server[section];
    headerCell.titleHeader.text = groupsList.group_name;
    
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
         [self.refreshControl endRefreshing];
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
    NSSortDescriptor *descriptorServer = [[NSSortDescriptor alloc]initWithKey:@"status"
                                                                    ascending:YES
                                                                     selector:@selector(localizedStandardCompare:)];
    fetchRequestServer.sortDescriptors = @[descriptorServer];
    NSError *errorServer = nil;
    NSArray *fetchedObjectsServer = [contextServer executeFetchRequest:fetchRequestServer
                                                                 error:&errorServer];

    Server *serverList = [fetchedObjectsServer firstObject];
    self.server = [serverList.groups allObjects];
    
    //GROUPS
    NSManagedObjectContext *contextGroups = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequestGroups = [NSFetchRequest fetchRequestWithEntityName:@"Groups"];
    NSSortDescriptor *descriptorGroups = [[NSSortDescriptor alloc]initWithKey:@"group_name"
                                                                    ascending:YES
                                                                     selector:@selector(localizedStandardCompare:)];
    fetchRequestGroups.sortDescriptors = @[descriptorGroups];
    NSError *errorGroups = nil;
    self.fetchedObjectsGroups = [contextGroups executeFetchRequest:fetchRequestGroups
                                                                 error:&errorGroups];

    Groups *groupList = [self.fetchedObjectsGroups firstObject];
    self.groups = [groupList.students allObjects];
    NSLog(@"%@", self.groups);

    [self.tableView reloadData];
}

@end
