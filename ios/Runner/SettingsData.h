//
//  SettingsData.h
//  Runner
//
//  Created by elf-rec on 2022/08/05.
//

#ifndef SettingsData_h
#define SettingsData_h

@interface SettingsData : NSObject;

@property NSNumber* nTrans1;
@property NSNumber* nOctave1;
@property NSNumber* nTrans2;
@property NSNumber* nOctave2;
@property NSNumber* nTrans3;
@property NSNumber* nOctave3;
@property NSNumber* nDisplayChord;
@property NSNumber* nDisplayLyrics;
@property NSNumber* nLyricsType;
@property NSNumber* nLyricsCommandments;
@property NSNumber* nCommandmentsType;
@property NSNumber* nHapjooChord;
@property NSNumber* nPrintType;

@property NSNumber* bChordHelper;
@property NSNumber* bChordFixed;

- (void) initData;
- (void) setData : (NSDictionary*) data;

@end

#endif /* SettingsData_h */
