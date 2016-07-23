//
//  ExpandableTableView.h
//  MosyleiOSTest
//
//  Created by Gabriel Targon on 7/22/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandableTableView : UITableView

@property (nonatomic, assign) int initiallyExpandedSection;
@property (nonatomic, assign) BOOL allHeadersInitiallyCollapsed;

@end
