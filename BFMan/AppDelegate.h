//
//  AppDelegate.h
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MobClickDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (unsafe_unretained, nonatomic) IBOutlet UITabBarController *tabBarController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
