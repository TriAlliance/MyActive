//
//  TATrendingVC.h
//  TriActive
//
//  Created by Ketan on 05/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAAddMusicVC.h"
#import "MATrendingPostVC.h"
#import "MATrendingGrpEvtVC.h"

@interface MATrendingVC : UIViewController<UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *arrtrendingPhotos;
    NSArray *arrLogoImg;
    
    __weak IBOutlet UIButton *btnHash1;
    __weak IBOutlet UIButton *btnHash2;
    __weak IBOutlet UIButton *btnHash3;
    __weak IBOutlet UIButton *btnHash4;
    __weak IBOutlet UIScrollView *scrollVw_Container;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) NSString *keyword;
- (IBAction)btnClickImgShow:(id)sender;

- (IBAction)btnPressed_hashTag:(id)sender;

@end
