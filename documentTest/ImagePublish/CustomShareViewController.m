//
//  CustomShareViewController.m
//  ImagePublish
//
//  Created by xj_mac on 2021/5/20.
//

#import "CustomShareViewController.h"

@interface CustomShareViewController ()
@property (nonatomic,strong) NSMutableArray *imageDataArray;
@end

@implementation CustomShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *contentView = [[UIView alloc]initWithFrame:self.view.bounds];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"打开" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //UIApplication.sharedApplication().openURL(NSURL(string: "1234://"))
}

- (void)donePressed{
    [self didSelectPost];
}

- (void)didSelectPost {
//    [self open]
    NSLog(@"点击发布");
//    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
       //获取文本内容
//       NSString *textString = self.textView.text;

       self.imageDataArray = [NSMutableArray array];

       //扩展中的处理不能太长时间阻塞主线程,放入线程中处处理，否则可能导致苹果拒绝你的应用
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

           for (NSExtensionItem *item in self.extensionContext.inputItems) {

               NSInteger count = item.attachments.count;

               for (NSItemProvider *itemProvider in item.attachments) {
                   NSLog(@"文件的类型:%@",itemProvider.registeredTypeIdentifiers);
                   if ([itemProvider hasItemConformingToTypeIdentifier:@"public.image"]) {

                       //获取缩略图，但备忘录获取不到 item UIImage类型
                       [itemProvider loadPreviewImageWithOptions:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                       }];
                       //item Url类型：file:///var/mobile/Media/PhotoData/OutgoingTemp/0F2F2637-0DBF-44F2-8F89-EFD9579BB76E/RenderedPhoto/IMG_0185.JPG

                       [itemProvider loadItemForTypeIdentifier:@"public.image" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {

                           // 对itemProvider夹带着的图片进行解析
                           NSURL *imageUrl = (NSURL *)item;

                           // 把图片转换为data数据
                           NSData *data = [NSData dataWithContentsOfURL:imageUrl];

                           [self.imageDataArray addObject:data];

                           dispatch_async(dispatch_get_main_queue(), ^{

                               if (self.imageDataArray.count == count) {

                                   NSLog(@"%@", [NSString stringWithFormat:@"获取全部%ld张照片",(long)count]);

                                   //name同App groups匹配
                                    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.tqhnet.documentTest.ImagePublish"];
                                    //存图片数组
                                    [userDefaults setObject:self.imageDataArray forKey:@"shareImageDataArray"];
                                    //用于标记是新的分享
                                    [userDefaults setBool:YES forKey:@"newShare"];
                                   //存文本内容
//                                    [userDefaults setObject:textString forKey:@"shareTextString"];
                                   //报错解决 target ->build settings ->Require Only App-Extension-Safe API 置为NO即可
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tqhdocument://"] options:nil completionHandler:nil];
//                                   [self.extensionContext openURL:[NSURL URLWithString:@"tqhdocument://"] completionHandler:^(BOOL success) {
//                                       if (success) {
//                                           NSLog(@"成功");
//                                       }else {
//                                           NSLog(@"失败");
//                                       }
//                                   }];
                                   //获取全部再销毁
                                   [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
                               }
                           });
                       }];
                   }
               }
           }
       });
   
}


@end
