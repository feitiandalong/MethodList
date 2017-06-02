//
//  UtilMethodList.m
//  controlSystem
//
//  Created by 程龙 on 17/2/27.
//  Copyright © 2017年 程龙. All rights reserved.
//

#import "UtilMethodList.h"

@interface UtilMethodList ()

@property(nonatomic,retain) dispatch_source_t timer;
//@property(nonatomic,retain) NSDateFormatter *dateFormatter;

@end

@implementation UtilMethodList


+ (instancetype)shared{
    
    static UtilMethodList *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[UtilMethodList alloc] init];
    });
    return singleton;
}

- (NSString *)userTimeStringChange:(NSString *)str{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate* date = [formatter dateFromString:str];
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return [NSString stringWithFormat:@"%ld",(long)timeSp];
}

- (NSString *)userTimeStringChangeStr:(NSString *)str{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    if (str.length == 10) {
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }else{
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }

    NSDate* date = [formatter dateFromString:str];
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return [NSString stringWithFormat:@"%ld",(long)timeSp];
}


- (NSString *)timeStampStr:(NSString *)timeStamp{
    
    if (timeStamp.length > 13) {
        
        return timeStamp;
    }
    
    NSDateFormatter *m = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [m setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *str = timeStamp;//时间戳
    
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    return [m stringFromDate:detaildate];
}

- (NSString *)timeStampYearMonthDayStr:(NSString *)timeStamp{
    
    NSDateFormatter *m = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [m setDateFormat:@"YYYY-MM-dd"];
    
    NSString *str = timeStamp;//时间戳
    
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    return [m stringFromDate:detaildate];
}

-(NSString*)getCurrentTimestamp{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

// 获取当前的标准时间
- (NSString *)currentTime{
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"MM月dd号"];
    NSString *strDate = [dataFormatter stringFromDate:[NSDate date]];
    //获取星期几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [componets weekday];//a就是星期几，1代表星期日，2代表星期一，后面依次
    NSArray *weekArray = @[@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSString *weekStr = weekArray[weekday-1];
    return  [strDate stringByAppendingString:weekStr];
}

// 获取当前的标准时间（不含星期几）
- (NSString *)currentTimeWaHaHa{
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *strDate = [dataFormatter stringFromDate:[NSDate date]];
    return strDate;
}

- (NSInteger)compareDate:(NSString*)aDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //给定的时间
    NSDate *dta = [[NSDate alloc] init];
    dta = [dateformater dateFromString:aDate];
    
    //当前的时间
    NSString *strDate = [dateformater stringFromDate:[NSDate date]];
    NSDate *dtb = [[NSDate alloc] init];
    dtb = [dateformater dateFromString:strDate];
    
    //
    NSComparisonResult result = [dta compare:dtb];
    
    if (result == NSOrderedSame)
    {
        //    相等
        aa=0;
    }else if (result == NSOrderedAscending)
    {
        //aDate小
        aa=1;
        
    }else if (result == NSOrderedDescending)
    {
        //aDate大
        aa=-1;
    }
    return aa;
}

// 获取当前的标准时间（不含星期几）
- (NSString *)currentTimeWaHaHaWaCa{
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *strDate = [dataFormatter stringFromDate:[NSDate date]];
    return strDate;
}


-(NSDate *)dateWithLongLong:(long long)longlongValue{
    long long value = longlongValue/1000;
    NSNumber *time = [NSNumber numberWithLongLong:value];
    //转换成NSTimeInterval
    NSTimeInterval nsTimeInterval = [time longValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}
-(void)countDownWithStratTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock{
    if (_timer==nil) {
        
        NSDate *finishDate = [self dateWithLongLong:finishTimeStamp];
        NSDate *startDate  = [self dateWithLongLong:starTimeStamp];
        NSTimeInterval timeInterval =[finishDate timeIntervalSinceDate:startDate];
        __block int timeout = timeInterval; //倒计时时间
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(0,0,0,0);
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(days,hours,minute,second);
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

/**
 *  主动销毁定时器
 */
-(void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

//读取数组文件
-(NSArray *)readArrFile:(NSString *)str{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistPath=[path stringByAppendingPathComponent: str];
    NSArray *array=[NSArray arrayWithContentsOfFile:plistPath];
    return  array;
}

//写入数组文件
-(void)writeArrFile:(NSArray *)array toFile:(NSString *)str{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistPath=[path stringByAppendingPathComponent: str];
    [array writeToFile:plistPath atomically:YES];
}

//写入图片
- (void)writeImageData:(NSData *)imageData toFile:(NSString *)str{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistPath=[path stringByAppendingPathComponent: str];
    
    [imageData writeToFile:plistPath atomically:YES];
}

//读取图片
- (UIImage *)readImageDataFile:(NSString *)str{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistPath=[path stringByAppendingPathComponent: str];
   return  [UIImage imageWithContentsOfFile:plistPath];
}

//读取字典文件
-(NSDictionary *)readDictFile:(NSString *)str{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistPath=[path stringByAppendingPathComponent:str];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return  dict;
}
//写入字典文件
-(void)writeDictFile:(NSDictionary *)dict toFile:(NSString *)str{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistPath=[path stringByAppendingFormat:@"/%@",str];
    [dict writeToFile:plistPath atomically:YES];
}


//读取字符串文件
-(NSString *)readStrFile:(NSString *)str{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistPath=[path stringByAppendingPathComponent: str];
    NSString *array=[NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil];
    return  array;
}
//写入字符串文件
-(void)writeStrFile:(NSString *)array toFile:(NSString *)str{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistPath=[path stringByAppendingPathComponent: str];
    [array writeToFile:plistPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

//图片处理
- (NSString *)imageChange:(NSMutableArray *)imageArr{
    
    NSString *str = [NSString new];
    // 图片
    for (int i = 0; i < imageArr.count; i ++) {
    
        NSData *imageData = imageArr[i];
        UIImage *originImage;
        
        if ([imageData isKindOfClass:[NSData class]]) {
           originImage = [UIImage imageWithData:imageData];
        }else if ([imageData isKindOfClass:[UIImage class]]){
            originImage = imageArr[i];
        }else{
            return @"";
        }
        
        NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
        float fuck = (float)data.length/1024.0;

        //调整压缩比例
        float scale = 0.0;

        if (fuck > 130) {
            scale = 0.15;
        }else{
            scale = 1-(fuck/144.44);
        }
        NSData *data1 = UIImageJPEGRepresentation(originImage,scale);

        NSString *encodedImageStr = [data1 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

        if (i == 0) {
            str = [str stringByAppendingString:encodedImageStr];
        }else{
            str = [str stringByAppendingString:[NSString stringWithFormat:@";%@", encodedImageStr]];
        }
    }
    return str;
}

- (void)deleteSaveFileArr:(NSMutableArray *)array{
    
    if (array.count == 0) {
        return;
    }
    //文件名
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    for (NSString *strA in array) {
        BOOL roundsData = [[NSFileManager defaultManager] fileExistsAtPath:[self DeletLongSavePath:[NSString stringWithFormat:@"%@",strA]]];
        if (roundsData) {
            [fileManager removeItemAtPath:[self DeletLongSavePath:[NSString stringWithFormat:@"%@",strA]] error:nil];
        }
    }
}

// 获得缓存地址
- (NSString *)DeletLongSavePath:(NSString *)savePathName{
    NSString *pathStr = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", savePathName]];
    return pathStr;
}


//图片转换横data
- (NSMutableArray *)imagesArr:(NSMutableArray *)imageArr{
    
    if (imageArr.count == 0) {
        return nil;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (UIImage *images in imageArr) {
        
        NSData *imageData = UIImageJPEGRepresentation(images,1.0);
        [arr addObject:imageData];
    }
    return arr;
}

//删除本地的写文件的操作记录
- (void)deleateFileWriteRecordPath:(NSString *)str{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //文件名
    BOOL roundsData = [[NSFileManager defaultManager] fileExistsAtPath:[self DeletLongSavePath:[NSString stringWithFormat:@"%@",str]]];
    if (roundsData) {
        [fileManager removeItemAtPath:[self DeletLongSavePath:[NSString stringWithFormat:@"%@",str]] error:nil];
    }
}

@end



