//
//  ServerData.h
//  Runner
//
//  Created by elf-rec on 2022/08/05.
//

#ifndef ServerData_h
#define ServerData_h

@interface ServerData : NSObject;

@property NSString* strMode;
@property NSString* strPort;
@property NSString* strIpAddress;
@property NSString* strSSID;
@property NSString* strDUID;
@property NSString* strASID;
@property NSString* strBuyTransPosList;
@property NSString* strMainKey;
@property NSString* strManKey;
@property NSString* strWomanKey;
@property NSString* strMainTempo;
@property NSString* strUserId;
@property NSString* strTag;
@property NSString* strMemberId;
@property NSString* strScorePrice;
@property NSString* strscPrintScoreTransPos;
@property NSString* strscPrintScoreTransPos2;
@property NSString* strscPrintScoreTransPos3;

@property NSNumber* nSongNo;
@property NSNumber* nCountryMode;
@property NSNumber* nScoreType;
@property NSNumber* nFileDataType;
@property NSNumber* nViewJeonKanjoo;
@property NSNumber* nSubType;
@property NSNumber* nDispNumber;

@property NSNumber* bIsPreViewScore;

- (void) initData;
- (void) setData : (NSDictionary*) data;

@end


#endif /* ServerData_h */
