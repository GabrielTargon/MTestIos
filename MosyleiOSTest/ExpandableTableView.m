//
//  ExpandableTableView.m
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/22/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import "ExpandableTableView.h"
#import "HeaderTableViewCell.h"

@interface ExpandableTableView ()

@property (nonatomic, strong) NSMutableDictionary *sectionStatusDic;

@end

@implementation ExpandableTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _sectionStatusDic = [[NSMutableDictionary alloc] init];
    self.initiallyExpandedSection = -1;
}

- (BOOL)collapsedForSection:(NSInteger)section {
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    
    if (self.sectionStatusDic[key]) {
        return ((NSNumber *)self.sectionStatusDic[key]).boolValue;
    }
    
    return (self.initiallyExpandedSection == section) ? NO : self.allHeadersInitiallyCollapsed;
}

//- (UIView *)headerWithTitle:(NSString *)title totalRows:(NSInteger)row inSection:(NSInteger)section {
//    
//    BOOL isCollapsed = [self collapsedForSection:section];
//    
//    HeaderTableViewCell *headerView = self.headerView;
//    [headerView updateWithTitle:title isCollapsed:isCollapsed totalRows:row andSection:section];
//    
//    return headerView;
//}

- (void)didTapHeader:(UITableViewCell *)headerCell {
    
}

@end
