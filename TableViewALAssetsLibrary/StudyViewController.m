//
//  StudyViewController.m
//  TableViewALAssetsLibrary
//
//  Created by kazuhiro.honma on 12/06/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StudyViewController.h"

@interface StudyViewController ()

@end

@implementation StudyViewController
@synthesize photos = _photos;
@synthesize photoListTableView = _photoListTableView;
@synthesize date = _date;

- (void)viewDidLoad 
{
    NSLog(@"Booom!");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _photoListTableView.dataSource = self;
    _photoListTableView.delegate = self;
    rowNum = 30;
    nowPage = 1;
    _date.text = @"画像ロード中...";
}

- (void)viewWillAppear:(BOOL)animated{
    // collect the photos
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    ALAssetsLibrary *al = [StudyViewController defaultAssetsLibrary];
    
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop) 
     {
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
          {
              if (asset) {
                  [collector addObject:asset];
              }  
          }];
         
         self.photos = collector;
         [self.photoListTableView reloadData];
         NSLog(@"photo count = %d",self.photos.count);
         _date.text = [NSString stringWithFormat:@"%dpage/%dpage",nowPage ,((int)(self.photos.count / (3 * rowNum)) + 1) ];
     }
                    failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
     ];
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setPhotoListTableView:nil];
    [self setDate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"self photos count = %d",self.photos.count);
//    return [self.photos count];
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIndentifier = @"photolistCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    
    // Configure the cell...
    UILabel *label = (UILabel *)[cell viewWithTag:4];
    label.text = [NSString stringWithFormat:@"row %d",indexPath.row];
    for (int tag = 1; tag <= 3; tag++) {
        UIImageView *image = (UIImageView *)[cell viewWithTag:tag];
        NSInteger assetNum = (3 * indexPath.row + (tag - 1) + (nowPage - 1) * 3 * rowNum );
        if (self.photos.count > assetNum) {
            ALAsset *asset = [self.photos objectAtIndex:assetNum];
            if (asset) {
                NSLog(@"at index = %d", (3 * indexPath.row + (tag - 1) + (nowPage - 1) * 3 * rowNum ));
                
                ALAssetRepresentation *representation = [asset defaultRepresentation];
                NSURL *url = [representation url];
                NSLog(@"url: %@", [url absoluteString]);
                
                [image setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
            } else {
                NSLog(@"not found");
                [image setImage:nil];
            }
        }
    }
    
    return cell;
}

- (IBAction)pushNextButton:(id)sender {
    if ( nowPage < ((int)(self.photos.count / (3 * rowNum)) + 1)) {
        nowPage++;
    }
    _date.text = [NSString stringWithFormat:@"%dpage/%dpage",nowPage ,((int)(self.photos.count / (3 * rowNum)) + 1) ];
    [self.photoListTableView reloadData];
}

- (IBAction)previousButton:(id)sender {
    if (nowPage > 1) {
        nowPage--;
    }
    _date.text = [NSString stringWithFormat:@"%dpage/%dpage",nowPage ,((int)(self.photos.count / (3 * rowNum)) + 1) ];
    [self.photoListTableView reloadData];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library; 
}

@end
