//
//  StudyViewController.h
//  TableViewALAssetsLibrary
//
//  Created by kazuhiro.honma on 12/06/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface StudyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    int rowNum;
    int nowPage;
}
@property (nonatomic, strong) NSArray *photos;
@property (weak, nonatomic) IBOutlet UITableView *photoListTableView;
@property (weak, nonatomic) IBOutlet UILabel *date;
- (IBAction)pushNextButton:(id)sender;
- (IBAction)previousButton:(id)sender;

+ (ALAssetsLibrary *)defaultAssetsLibrary;
@end
