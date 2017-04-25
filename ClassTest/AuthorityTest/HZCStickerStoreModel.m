//
//  HZCStickerStoreModel.m
//  Co8
//
//  Created by Hanzengchao on 2017/4/17.
//  Copyright © 2017年 mad x studio. All rights reserved.
//

#import "HZCStickerStoreModel.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "SSKeychain.h"
#import "Reachability.h"
#import "sys/utsname.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation HZCStickerStoreModel
+ (NSString *)mac
{
    //获得手机IMEI
    @try
    {
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error/n");
            return NULL;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1/n");
            return NULL;
        }
        
        if ((buf = malloc(len)) == NULL) {
            printf("Could not allocate memory. error!/n");
            return NULL;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 2");
            return NULL;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        
        NSLog(@"outString:%@", outstring);
        
        free(buf);
        
        return [outstring uppercaseString];
    }
    @catch (NSException *exception)
    {
        // Error
        return nil;
    }
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    /*NSString* phoneModel = [[UIDevice currentDevice] model];
     NSLog(@"手机型号: %@",phoneModel );
     return phoneModel;*/
    NSString *correspondVersion = [self getDeviceVersionInfo];
    
    if ([correspondVersion isEqualToString:@"i386"])        return@"Simulator";
    if ([correspondVersion isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([correspondVersion isEqualToString:@"iPhone1,1"])   return@"iPhone 1";
    if ([correspondVersion isEqualToString:@"iPhone1,2"])   return@"iPhone 3";
    if ([correspondVersion isEqualToString:@"iPhone2,1"])   return@"iPhone 3S";
    if ([correspondVersion isEqualToString:@"iPhone3,1"] || [correspondVersion isEqualToString:@"iPhone3,2"])   return@"iPhone 4";
    if ([correspondVersion isEqualToString:@"iPhone4,1"])   return@"iPhone 4S";
    if ([correspondVersion isEqualToString:@"iPhone5,1"] || [correspondVersion isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
    if ([correspondVersion isEqualToString:@"iPhone5,3"] || [correspondVersion isEqualToString:@"iPhone5,4"])   return @"iPhone 5C";
    if ([correspondVersion isEqualToString:@"iPhone6,1"] || [correspondVersion isEqualToString:@"iPhone6,2"])   return @"iPhone 5S";
    if ([correspondVersion isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([correspondVersion isEqualToString:@"iPhone7,2"])   return @"iPhone 6";
    
    if ([correspondVersion isEqualToString:@"iPod1,1"])     return@"iPod Touch 1";
    if ([correspondVersion isEqualToString:@"iPod2,1"])     return@"iPod Touch 2";
    if ([correspondVersion isEqualToString:@"iPod3,1"])     return@"iPod Touch 3";
    if ([correspondVersion isEqualToString:@"iPod4,1"])     return@"iPod Touch 4";
    if ([correspondVersion isEqualToString:@"iPod5,1"])     return@"iPod Touch 5";
    
    if ([correspondVersion isEqualToString:@"iPad1,1"])     return@"iPad 1";
    if ([correspondVersion isEqualToString:@"iPad2,1"] || [correspondVersion isEqualToString:@"iPad2,2"] || [correspondVersion isEqualToString:@"iPad2,3"] || [correspondVersion isEqualToString:@"iPad2,4"])     return@"iPad 2";
    if ([correspondVersion isEqualToString:@"iPad2,5"] || [correspondVersion isEqualToString:@"iPad2,6"] || [correspondVersion isEqualToString:@"iPad2,7"] )      return @"iPad Mini";
    if ([correspondVersion isEqualToString:@"iPad3,1"] || [correspondVersion isEqualToString:@"iPad3,2"] || [correspondVersion isEqualToString:@"iPad3,3"] || [correspondVersion isEqualToString:@"iPad3,4"] || [correspondVersion isEqualToString:@"iPad3,5"] || [correspondVersion isEqualToString:@"iPad3,6"])      return @"iPad 3";
    if ([correspondVersion isEqualToString:@"iPad3,6"])   return @"iPad 4(A1460)";
    
    if ([correspondVersion isEqualToString:@"iPad4,1"])   return @"iPad Air(A1474)";
    if ([correspondVersion isEqualToString:@"iPad4,2"])   return @"iPad Air(A1475)";
    if ([correspondVersion isEqualToString:@"iPad4,3"])   return @"iPad Air(A1476)";
    if ([correspondVersion isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G(A1489)";
    if ([correspondVersion isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G(A1490)";
    if ([correspondVersion isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G(A1491)";
    NSLog(@"手机型号: %@",correspondVersion);
    return correspondVersion;
}

+ (NSString *)getuuid
{
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.mohe.userinfo"account:@"uuid"];
    
    if ( retrieveuuid == nil || [retrieveuuid isEqualToString:@""]){
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        
        retrieveuuid = [NSString stringWithFormat:@"%@", uuidStr];
        
        [SSKeychain setPassword:retrieveuuid forService:@"com.mohe.userinfo"account:@"uuid"];
    }
    return retrieveuuid;
}

+(NSString *)internetStatus
{
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"wifi";
    switch (internetStatus)
    {
        case ReachableViaWiFi:
            net = @"wifi";
            break;
            
        case ReachableViaWWAN:
            net = @"wwan";
            break;
            
        case NotReachable:
            net = @"notReachable";
            
        default:
            break;
    }
    
    return net;
}

+ (NSString *) issim;//判断是否有sim卡
{
    NSString * IsSim=@"1";
    return IsSim;
}

+(NSString *)getDeviceVersionInfo
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithFormat:@"%s", systemInfo.machine];
    
    return platform;
}

// Get IP Address
+(NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


@end
