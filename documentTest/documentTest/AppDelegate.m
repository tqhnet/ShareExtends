//
//  AppDelegate.m
//  documentTest
//
//  Created by xj_mac on 2021/5/20.
//

#import "AppDelegate.h"
#import "DocumentBrowserViewController.h"
#import "DocumentViewController.h"
#import "Document.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
   //获取共享的UserDefaults
   NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.tqhnet.documentTest.ImagePublish"];
   
   if ([userDefaults boolForKey:@"newShare"]){
       NSArray *imagesDataArray = [userDefaults valueForKey:@"shareImageDataArray"];
       NSLog(@"新的分享 : %lu", (unsigned long)imagesDataArray.count);
       
       //重置分享标识
       [userDefaults setBool:NO forKey:@"newShare"];
       //自己相应的操作，比如请求服务器
       NSLog(@"存入沙盒移除缓存");
   }else {
       NSLog(@"没有");
   }
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)inputURL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    // Ensure the URL is a file URL
    if (!inputURL.isFileURL) {
        return NO;
    }

    // Reveal / import the document at the URL
    DocumentBrowserViewController *documentBrowserViewController = (DocumentBrowserViewController *)self.window.rootViewController;
    [documentBrowserViewController revealDocumentAtURL:inputURL importIfNeeded:YES completion:^(NSURL * _Nullable revealedDocumentURL, NSError * _Nullable error) {
        if (error) {
            // Handle the error appropriately
            NSLog(@"Failed to reveal the document at URL %@ with error: '%@'", inputURL, error);
            return;
        }
        
        // Present the Document View Controller for the revealed URL
        [documentBrowserViewController presentDocumentAtURL:revealedDocumentURL];
    }];
    return YES;
}


@end
