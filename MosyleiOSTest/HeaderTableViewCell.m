//
//  HeaderTableViewCell.m
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/22/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import "HeaderTableViewCell.h"

@interface HeaderTableViewCell ()

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger totalRows;
@property (nonatomic, assign) BOOL isCollapsed;

@end

@implementation HeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithTitle:(UILabel *)title isCollapsed:(BOOL)isCollapsed totalRows:(NSInteger)row andSection:(NSInteger)section {
    
    self.titleHeader = title;
    self.isCollapsed = isCollapsed;
    self.section = section;
    self.totalRows = row;
    
//    [self setHeaderText];
}

@end
