//
//  ServerData.m
//  Runner
//
//  Created by elf-rec on 2022/08/05.
//

#import <Foundation/Foundation.h>
#import "ServerData.h"


@implementation ServerData;

//데이터 초기화
- (void) initData{
    self.strMode = @"";
    self.strPort = @"";
    self.strIpAddress = @"";
    self.strSSID = @"";
    self.strDUID = @"";
    self.strASID = @"";
    self.strBuyTransPosList = @"";
    self.strMainKey = @"";
    self.strManKey = @"";
    self.strWomanKey = @"";
    self.strUserId = @"";
    self.strTag = @"";
    self.strMemberId = @"";
    self.strScorePrice = @"";
    self.strscPrintScoreTransPos = @"";
    self.strscPrintScoreTransPos2 = @"";
    self.strscPrintScoreTransPos3 = @"";
    
    self.nSongNo = [NSNumber numberWithInt: -1];
    self.nCountryMode = [NSNumber numberWithInt: -1];
    self.nScoreType = [NSNumber numberWithInt: -1];
    self.nFileDataType = [NSNumber numberWithInt: -1];
    self.nViewJeonKanjoo = [NSNumber numberWithInt: -1];
    self.nSubType = [NSNumber numberWithInt: -1];
    self.nDispNumber = [NSNumber numberWithInt: -1];
    
    self.bIsPreViewScore = [NSNumber numberWithBool: false];
}

//데이터 set
- (void) setData : (NSDictionary*) data
{
    self.strMode = data[@"mode"];
    self.strPort = data[@"Port"];
    self.strIpAddress = data[@"IpAddress"];
    self.strSSID = data[@"SSID"];
    self.strDUID = data[@"DUID"];
    self.strASID = data[@"ASID"];
    self.strBuyTransPosList = data[@"strBuyTransPosList"];
    self.strMainKey = data[@"strMainKey"];
    self.strManKey = data[@"strMankey"];
    self.strWomanKey = data[@"strWomanKey"];
    self.strMainTempo = data[@"strMainTempo"];
    self.strUserId = data[@"strUserId"];
    self.strTag = data[@"strTag"];
    self.strMemberId = data[@"strMemberId"];
    self.strScorePrice = data[@"nScorePrice"];
    self.strscPrintScoreTransPos = data[@"scPrintScoreTransPos"];
    self.strscPrintScoreTransPos2 = data[@"scPrintScoreTransPos2"];
    self.strscPrintScoreTransPos3 = data[@"scPrintScoreTransPos3"];
    
    self.nSongNo = data[@"SongNo"];
    self.nCountryMode = data[@"NCountryMode"];
    self.nScoreType = data[@"nScoreType"];
    self.nFileDataType = data[@"nFileDataType"];
    self.nViewJeonKanjoo = data[@"nViewJeonKanjoo"];
    self.nSubType = data[@"nSubType"];
    self.nDispNumber = data[@"DispNumber"];
    
    self.bIsPreViewScore = data[@"blsPreViewScore"];
    
}

@end
