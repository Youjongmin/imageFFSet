//
//  JMAlbumViewController.m
//  imageFFSet
//
//  Created by colondee on 2017. 10. 27..
//  Copyright © 2017년 yjm. All rights reserved.
//

#import "JMAlbumViewController.h"
#import "MMAlbumCollectionViewCell.h"
#import "MMCameraPreviewCollectionViewCell.h"

@import Photos;
@import AVFoundation;

@interface JMAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSArray<PHAsset *> *assets;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (nonatomic, strong) PHAsset *asset;
@property (strong) PHFetchResult *assetsFetchResults;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation JMAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self initNavigationBar];
    [self loadAsset];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:MMAlbumCollectionViewCellIdentifier bundle:nil]
          forCellWithReuseIdentifier:MMAlbumCollectionViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:MMCameraCollectionViewCellIdentifier bundle:nil]
          forCellWithReuseIdentifier:MMCameraCollectionViewCellIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadAsset {
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    switch (self.mediatype) {
        case JMAlbumTypeImage:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
            break;
        case JMAlbumTypeVideo:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
            break;
    }
    
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self calcCellSize];
    
}
//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//    return UIEdgeInsetsMake(20, 15, 0, 15);
//
//}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assetsFetchResults count] + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return [self cameraCollectionViewCellAtIndexPath:collectionView cellForItemAtIndexPath:indexPath];
    }else{
        return [self imageCollectionViewCellAtIndexPath:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    
    
}

- (UICollectionViewCell*)cameraCollectionViewCellAtIndexPath:(UICollectionView *)collectionView
                                      cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MMCameraPreviewCollectionViewCell *cell = (MMCameraPreviewCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:MMCameraCollectionViewCellIdentifier
                                                                                                                                  forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPresetMedium;
        
        NSUInteger replicatorInstances = 1;
        NSUInteger layerMarginValue = 0;
        
        CGRect layerRc = CGRectMake(0, 0, cell.cameraPreview.bounds.size.width / replicatorInstances, cell.cameraPreview.bounds.size.height);
        layerRc = CGRectMake(layerRc.origin.x + layerMarginValue,
                             layerRc.origin.y + layerMarginValue,
                             layerRc.size.width - (layerMarginValue * 2 * replicatorInstances),
                             layerRc.size.height - (layerMarginValue * 2 * replicatorInstances));
        
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = layerRc;
        replicatorLayer.instanceCount = replicatorInstances;
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(self.view.bounds.size.width / replicatorInstances, 0.0, 0.0);
        
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        captureVideoPreviewLayer.frame = layerRc;
        
        [replicatorLayer addSublayer:captureVideoPreviewLayer];
        [cell.cameraPreview.layer addSublayer:replicatorLayer];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input) {
            NSLog(@"%@", error);
        }
        [session addInput:input];
        
        [session startRunning];
        
    });
    
    
    
    return cell;
}

- (UICollectionViewCell*)imageCollectionViewCellAtIndexPath:(UICollectionView *)collectionView
                                     cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MMAlbumCollectionViewCell *cell = (MMAlbumCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:MMAlbumCollectionViewCellIdentifier
                                                                                                                  forIndexPath:indexPath];
    
    
    PHImageManager *manager = [PHImageManager defaultManager];
    PHAsset *asset = [self.assetsFetchResults objectAtIndex:indexPath.row - 1];
    
    PHImageRequestOptions *initialRequestOptions = [[PHImageRequestOptions alloc] init];
    initialRequestOptions.synchronous = true;
    initialRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    initialRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    [manager requestImageForAsset:asset
                       targetSize:CGSizeMake(300, 300)
                      contentMode:PHImageContentModeAspectFit
                          options:initialRequestOptions
                    resultHandler:^(UIImage *result, NSDictionary *info) {
                        // what you want to do with the image
                        cell.albumImageView.image = result;
                    }];
    
    
    
    return cell;
    
    
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self updateSelectedCell:indexPath.row isSelect:YES];
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
}

#pragma mark - etc

- (CGSize)calcCellSize {
    
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    width -= (flow.sectionInset.left + flow.sectionInset.right);
    width -= (flow.minimumInteritemSpacing * (3 - 1));
    width /= 3;
    width = floorf(width);
    
    return CGSizeMake(width, width);
    
}

- (void)updateSelectedCell:(NSInteger)idx isSelect:(BOOL)isSelect {
    if (idx != NSNotFound) {
        if (isSelect) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]
                                              animated:NO
                                        scrollPosition:UICollectionViewScrollPositionNone];
            
        } else {
            [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]
                                                animated:NO];
        }
    }
}

@end
