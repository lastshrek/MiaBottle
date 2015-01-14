//
//  ViewController.m
//  MiaBottle
//
//  Created by Purchas on 15/1/14.
//  Copyright (c) 2015年 Purchas. All rights reserved.
//
#define  PCColor(r, g, b, al) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(al)])
#define PCBLUE PCColor(66, 206, 170, 1.0)
#define PCPINK PCColor(245, 98, 114, 1.0)

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *leftBottle;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottle;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)btnClick:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
    } else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    // Do any additional setup after loading the view, typically from a nib.
    //获取哪个奶瓶该显示
    NSUserDefaults *yesOrNo = [NSUserDefaults standardUserDefaults];
    NSString *check = [NSString stringWithFormat:@"%@",[yesOrNo objectForKey:@"store"]];
    if (check ==  nil) {
        [yesOrNo setBool:NO forKey:@"store"];
        [yesOrNo synchronize];
        self.leftBottle.hidden = NO;
        self.rightBottle.hidden = YES;
        [self.leftBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.rightBtn setBackgroundColor:PCBLUE];
    } else if ([check isEqualToString:@"right"]) {
        self.leftBottle.hidden = YES;
        self.rightBottle.hidden = NO;
        
        [self.leftBtn setBackgroundColor:PCPINK];
        [self.rightBtn setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        self.leftBottle.hidden = NO;
        self.rightBottle.hidden = YES;
        [self.leftBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.rightBtn setBackgroundColor:PCBLUE];
    }

}

- (IBAction)btnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"左"]) {
        self.leftBottle.hidden = NO;
        self.rightBottle.hidden = YES;
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = YES;
        [self.leftBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.rightBtn setBackgroundColor:PCBLUE];
        NSUserDefaults *yesOrNo = [NSUserDefaults standardUserDefaults];
        [yesOrNo setObject:@"left" forKey:@"store"];
        [yesOrNo synchronize];
        
    } else {
        self.leftBottle.hidden = YES;
        self.rightBottle.hidden = NO;
        self.leftBtn.enabled = YES;
        self.rightBtn.enabled = NO;
        [self.leftBtn setBackgroundColor:PCPINK];
        [self.rightBtn setBackgroundColor:[UIColor lightGrayColor]];
        NSUserDefaults *yesOrNo = [NSUserDefaults standardUserDefaults];
        [yesOrNo setObject:@"right" forKey:@"store"];
        [yesOrNo synchronize];
    }
    
    
    
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSTimeInterval seconds = 3 * 60 * 60;
    
    NSDate *drinkDate = [[NSDate alloc] initWithTimeIntervalSinceNow:seconds];
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                   fromDate:drinkDate];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
                                                   fromDate:drinkDate];
    NSLog(@"%@,%@",dateComponents,timeComponents);
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
    // Notification will fire in one minute
    [dateComps setMinute:[timeComponents minute]];
    [dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    // Notification details
    if (self.leftBottle.hidden == YES) {
        localNotif.alertBody = @"该喂Mia左瓶🍼啦！";
    } else {
        localNotif.alertBody = @"该喂Mia右瓶🍼啦！";
    }
    
    // Set the action button
    localNotif.alertAction = @"View";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    // Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}
@end
