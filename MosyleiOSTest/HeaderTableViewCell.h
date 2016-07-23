//
//  HeaderTableViewCell.h
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/22/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;
@property (weak, nonatomic) IBOutlet UIButton *buttonHeader;

@property (nonatomic, readonly) NSInteger section;
@property (nonatomic, readonly) NSInteger totalRows;

- (void)updateWithTitle:(NSString *)title isCollapsed:(BOOL)isCollapsed totalRows:(NSInteger)row andSection:(NSInteger)section;

@end
