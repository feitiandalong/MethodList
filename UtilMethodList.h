//
//  UtilMethodList.h
//  controlSystem
//
//  Created by 程龙 on 17/2/27.
//  Copyright © 2017年 程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilMethodList : NSObject

+ (instancetype)shared;

/// 时间戳转为标准时间
- (NSString *)timeStampStr:(NSString *)timeStamp;

/// 获取当前的标准时间（含星期几）
- (NSString *)currentTime;

///获取当前的标准时间（不含星期几,包含时分秒）
- (NSString *)currentTimeWaHaHa;

///时间比较
- (NSInteger)compareDate:(NSString*)aDate;

/// 获取当前的标准时间（不含星期几）
- (NSString *)currentTimeWaHaHaWaCa;

///当前时间戳
-(NSString*)getCurrentTimestamp;

/// 给定的时间转换为时间戳
- (NSString *)userTimeStringChange:(NSString *)str;

- (NSString *)userTimeStringChangeStr:(NSString *)str;

/// 只有年和月份
- (NSString *)timeStampYearMonthDayStr:(NSString *)timeStamp;

///用时间戳倒计时
-(void)countDownWithStratTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
-(void)destoryTimer;

// 文件存储
//数组文件
-(NSArray *)readArrFile:(NSString *)str;
-(void)writeArrFile:(NSArray *)array toFile:(NSString *)str;

//字典文件
-(NSDictionary *)readDictFile:(NSString *)str;
-(void)writeDictFile:(NSDictionary *)dict toFile:(NSString *)str;

//字符串
-(NSString *)readStrFile:(NSString *)str;
-(void)writeStrFile:(NSString *)array toFile:(NSString *)str;

//JSON图片
- (NSString *)imageChange:(NSMutableArray *)imageArr;

//写入图片
- (void)writeImageData:(NSData *)imageData toFile:(NSString *)str;
//读取图片
- (UIImage *)readImageDataFile:(NSString *)str;
        

//删除缓存的数据
- (void)deleteSaveFileArr:(NSMutableArray *)array;

//图片转换横data
- (NSMutableArray *)imagesArr:(NSMutableArray *)imageArr;

//删除本地的写文件的操作记录
- (void)deleateFileWriteRecordPath:(NSString *)str;


@end
