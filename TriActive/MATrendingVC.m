//
//  TATrendingVC.m
//  TriActive
//
//  Created by Ketan on 05/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MATrendingVC.h"
#import "MAPostVC.h"
@interface MATrendingVC ()

@end

@implementation MATrendingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self callHashTagAPI];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Trending Posts"];
    self.navigationItem.leftBarButtonItem = [Utility leftbar:[UIImage imageNamed:@"sideMenu.png"] :self];
   self.navigationItem.rightBarButtonItem=[Utility rightbar:[UIImage imageNamed:@"post-icon-or-edit-icon.png"] :self];
    self.navigationController.navigationBar.translucent = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"activityIcons" ofType:@"plist"];
    NSDictionary *dict =  [NSDictionary dictionaryWithContentsOfFile:path];
    arrLogoImg = [dict objectForKey:@"ActivityImages"];
   
}
-(void)rightBtn
{
    MAPostVC *objPost=VCWithIdentifier(@"MAPostVC");
    objPost.openHome=YES;
    [self.navigationController pushViewController:objPost animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    
     [self callTrendingAPI];
}

-(void)callTrendingAPI
{
    NSDictionary* userInfo = @{@"keyword":@"trending",
                               @"page_number":@"1",
                               @"no_of_post":@"54"
                               };
    
    [ApplicationDelegate show_LoadingIndicator];
    [API userTrendingDetailWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            arrtrendingPhotos = [[NSMutableArray alloc]init];
            [arrtrendingPhotos addObject:[responseDict valueForKey:@"data"]];
            if([[arrtrendingPhotos objectAtIndex:0] count] %3==0)
            {
                scrollVw_Container.contentSize = CGSizeMake(_collectionView.frame.size.width,(([[arrtrendingPhotos objectAtIndex:0] count]/3)*106+80));
                //              collectionview.contentOffset = CGPointMake(0, scrollView.contentSize.height);
                _collectionView.frame = CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y, _collectionView.frame.size.width,  scrollVw_Container.contentSize.height);
                
            }
            else
            {
                
                scrollVw_Container.contentSize = CGSizeMake(_collectionView.frame.size.width,(([[arrtrendingPhotos objectAtIndex:0] count]/3)+1)*106+80);
                //             collectionview.contentOffset = CGPointMake(0, scrollView.contentSize.height);
                _collectionView.frame = CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y, _collectionView.frame.size.width, scrollVw_Container.contentSize.height);
                
            }
           [self.collectionView reloadData];
            
        }
        else
        {
            //            [ApplicationDelegate showAlert:@"You have no Post on home"];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}

-(void)callHashTagAPI
{
    NSDictionary* userInfo = @{@"keyword":@"popular_hashtags",
                               @"page_number":@"1",
                               @"no_of_post":@"4"
                               };
    [ApplicationDelegate show_LoadingIndicator];
    [API userTrendingHashTagWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
          NSLog(@"responseDict--%@",[responseDict valueForKey:@"data"]);
            for (int i = 0; i < [[responseDict valueForKey:@"data"] count];i++)
            {
                 NSLog(@"responseDict--%@",[[[responseDict valueForKey:@"data"] objectAtIndex:i] valueForKey:@"tag"]);
                if(i==0){
                 [btnHash1 setTitle:[[[responseDict valueForKey:@"data"] objectAtIndex:0] valueForKey:@"tag"] forState:UIControlStateNormal];
                }
                else  if(i==1){
                 [btnHash2 setTitle:[[[responseDict valueForKey:@"data"] objectAtIndex:1] valueForKey:@"tag"] forState:UIControlStateNormal];
                }
                else  if(i==2){

                 [btnHash3 setTitle:[[[responseDict valueForKey:@"data"] objectAtIndex:2] valueForKey:@"tag"] forState:UIControlStateNormal];
                }
                else  if(i==3){
                 [btnHash4 setTitle:[[[responseDict valueForKey:@"data"] objectAtIndex:3] valueForKey:@"tag"] forState:UIControlStateNormal];
                }
                 else{}
            }
        }
        else
        {
            //  [ApplicationDelegate showAlert:@"You have no Post on home"];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}
#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)leftBtn
{
    if ([self.tabBarController.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.tabBarController.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
         [self.tabBarController.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil afterDelay:0.0];
        
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Collection View Datasource/Delegates
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [[arrtrendingPhotos objectAtIndex:0] count ];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    UIImageView *logoImgVw = (UIImageView *)[cell viewWithTag:900];
   
    logoImgVw.layer.cornerRadius = 10.0f;
    logoImgVw.clipsToBounds = YES;
    UIImageView *trndingImgVw = (UIImageView *)[cell viewWithTag:182];
    [trndingImgVw sd_setImageWithURL:[NSURL URLWithString:[[[arrtrendingPhotos objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"post_image"]] placeholderImage:CoverPlaceholder options:SDWebImageRetryFailed];
    if(logoImgVw){
        if ([[arrLogoImg valueForKey:@"txt"] containsObject: [[[arrtrendingPhotos objectAtIndex:0]  objectAtIndex:indexPath.row] valueForKey:@"activity_name"]]) {
            
            NSUInteger index = [[arrLogoImg valueForKey:@"txt"] indexOfObject:[[[arrtrendingPhotos objectAtIndex:0]  objectAtIndex:indexPath.row] valueForKey:@"activity_name"]];
            if (index != NSNotFound) {
                logoImgVw.image =   [UIImage imageNamed:[[arrLogoImg objectAtIndex:index ] valueForKey:@"img"]];
            }
            
        }
    }
   return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *selectedRecipe = [[[arrtrendingPhotos objectAtIndex:0]  objectAtIndex:indexPath.row] valueForKey:@"activity_name"];
    MALog(@"%@",selectedRecipe);
    // Add the selected item into the array
    MATrendingPostVC *objList=VCWithIdentifier(@"MATrendingPostVC");
    objList.keyword = selectedRecipe;
   [self.navigationController pushViewController:objList animated:YES];
   
}
#pragma mark
#pragma mark UIButton Methods
#pragma mark

- (IBAction)btnClickImgShow:(id)sender {
    
    NSLog(@"button tag=====%li",(long)[(UIButton *)sender tag]);
    NSString *title = [(UIButton *)sender currentTitle];
    NSLog(@"button text=====%@",title);
    if([title isEqualToString:@"Popular"]){
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:412];
        imageView.hidden = NO;
        UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:414];
        myImageView.hidden = YES;
        UIImageView *myImageView1 = (UIImageView *)[self.view viewWithTag:416];
        myImageView1.hidden = YES;
        UIImageView *myImageView2 = (UIImageView *)[self.view viewWithTag:418];
        myImageView2.hidden = YES;
        UIImageView *myImageView3 = (UIImageView *)[self.view viewWithTag:420];
         myImageView3.hidden = YES;
        MATrendingPostVC *objList=VCWithIdentifier(@"MATrendingPostVC");
        objList.keyword = @"Popular";
        [self.navigationController pushViewController:objList animated:YES];
    }
    else if([title isEqualToString:@"Events"]){
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:412];
        imageView.hidden = YES;
        UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:414];
        myImageView.hidden = NO;
        UIImageView *myImageView1 = (UIImageView *)[self.view viewWithTag:416];
        myImageView1.hidden = YES;
        UIImageView *myImageView2 = (UIImageView *)[self.view viewWithTag:418];
        myImageView2.hidden = YES;
        UIImageView *myImageView3 = (UIImageView *)[self.view viewWithTag:420];
        myImageView3.hidden = YES;
        MATrendingGrpEvtVC *objList=VCWithIdentifier(@"MATrendingGrpEvtVC");
        objList.keyword = @"Popular Events";

        [self.navigationController pushViewController:objList animated:YES];
    }
    else if([title isEqualToString:@"Groups"]){
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:412];
        imageView.hidden = YES;
        UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:414];
        myImageView.hidden = YES;
        UIImageView *myImageView1 = (UIImageView *)[self.view viewWithTag:416];
        myImageView1.hidden = NO;
        UIImageView *myImageView2 = (UIImageView *)[self.view viewWithTag:418];
        myImageView2.hidden = YES;
        UIImageView *myImageView3 = (UIImageView *)[self.view viewWithTag:420];
        myImageView3.hidden = YES;
        MATrendingGrpEvtVC *objListEvnt=VCWithIdentifier(@"MATrendingGrpEvtVC");
        objListEvnt.keyword = @"Popular Groups";
        [self.navigationController pushViewController:objListEvnt animated:YES];
    }
    else if([title isEqualToString:@"New"]){
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:412];
        imageView.hidden = YES;
        UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:414];
        myImageView.hidden = YES;
        UIImageView *myImageView1 = (UIImageView *)[self.view viewWithTag:416];
        myImageView1.hidden = YES;
        UIImageView *myImageView2 = (UIImageView *)[self.view viewWithTag:418];
        myImageView2.hidden = NO;
        UIImageView *myImageView3 = (UIImageView *)[self.view viewWithTag:420];
        myImageView3.hidden = YES;
        MATrendingGrpEvtVC *objListEvnt=VCWithIdentifier(@"MATrendingGrpEvtVC");
         objListEvnt.keyword = @"New";
        [self.navigationController pushViewController:objListEvnt animated:YES];
    }
    else if([title isEqualToString:@"Music"]){
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:412];
        imageView.hidden = YES;
        UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:414];
        myImageView.hidden = YES;
        UIImageView *myImageView1 = (UIImageView *)[self.view viewWithTag:416];
        myImageView1.hidden = YES;
        UIImageView *myImageView2 = (UIImageView *)[self.view viewWithTag:418];
        myImageView2.hidden = YES;
        UIImageView *myImageView3 = (UIImageView *)[self.view viewWithTag:420];
        myImageView3.hidden = NO;;
        
        MAAddMusicVC* musicVC=VCWithIdentifier(@"MAAddMusicVC");
        [self.navigationController pushViewController:musicVC animated:YES];
    }
}

- (IBAction)btnPressed_hashTag:(id)sender {
    NSString *title = [(UIButton *)sender currentTitle];
    MALog(@"%@title",title);
    MAHashVC * new = VCWithIdentifier(@"MAHashVC");
    new.hashTitle=title;
    [self.navigationController pushViewController:new animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
