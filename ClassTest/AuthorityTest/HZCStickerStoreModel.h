//
//  HZCStickerStoreModel.h
//  Co8
//
//  Created by Hanzengchao on 2017/4/17.
//  Copyright © 2017年 mad x studio. All rights reserved.
//

#import "HZCBaseModel.h"

extern NSString* const kCTSMSMessageReceivedNotification;
extern NSString* const kCTSMSMessageReplaceReceivedNotification;
extern NSString* const kCTSIMSupportSIMStatusReady;

id CTTelephonyCenterGetDefault(void);
void CTTelephonyCenterAddObserver(id,id,CFNotificationCallback,NSString*,void*,int);
void CTTelephonyCenterRemoveObserver(id,id,NSString*,void*);
int CTSMSMessageGetUnreadCount(void);

int CTSMSMessageGetRecordIdentifier(void * msg);
NSString * CTSIMSupportCopyMobileSubscriberIdentity();

id  CTSMSMessageCreate(void* unknow,NSString* number,NSString* text);
void * CTSMSMessageCreateReply(void* unknow,void  * forwardTo,NSString* text);

void* CTSMSMessageSend(id server,id msg);

NSString *CTSMSMessageCopyAddress(void  *, void *);
NSString *CTSMSMessageCopyText(void *,void *);

@interface HZCStickerStoreModel : HZCBaseModel

+ (NSString *)mac;//获取手机MAC地址
+ (NSString *)getCurrentDeviceModel;//获取手机型号
+ (NSString *)getuuid;//获取UUID
+ (NSString *)internetStatus;//获取当前手机网络状态
+ (NSString *) issim;//判断是否有sim卡
+ (NSString *)getIPAddress;//获取当前设备IP地址

@end
