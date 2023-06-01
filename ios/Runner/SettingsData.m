//
//  SettingsData.m
//  Runner
//
//  Created by elf-rec on 2022/08/05.
//

#import <Foundation/Foundation.h>
#import "SettingsData.h"

@implementation SettingsData

//데이터 초기화
- (void) initData
{
    self.nTrans1 = [NSNumber numberWithInt: 0];
    self.nOctave1 = [NSNumber numberWithInt: 0];
    self.nTrans2 = [NSNumber numberWithInt: 0];
    self.nOctave2 = [NSNumber numberWithInt: 0];
    self.nTrans3 = [NSNumber numberWithInt: 0];
    self.nOctave3 = [NSNumber numberWithInt: 0];
    self.nDisplayChord = [NSNumber numberWithInt: 0];
    self.nDisplayLyrics = [NSNumber numberWithInt: 0];
    self.nLyricsType = [NSNumber numberWithInt: 0];
    self.nLyricsCommandments = [NSNumber numberWithInt: 0];
    self.nCommandmentsType = [NSNumber numberWithInt: 0];
    self.nHapjooChord = [NSNumber numberWithInt: 0];
    self.nPrintType = [NSNumber numberWithInt: 0];
    
    self.bChordHelper = [NSNumber numberWithBool: false];
    self.bChordFixed = [NSNumber numberWithBool: false];
}

//데이터 set
- (void) setData: (NSDictionary*) data
{
    self.nTrans1 = data[@"Trans1"];
    self.nOctave1 = data[@"Octave1"];
    self.nTrans2 = data[@"Trans2"];
    self.nOctave2 = data[@"Octave2"];
    self.nTrans3 = data[@"Trans3"];
    self.nOctave3 = data[@"Octave3"];
    self.nDisplayChord = data[@"DisplayChord"];
    self.nDisplayLyrics = data[@"DisplayLyrics"];
    self.nLyricsType = data[@"LyricsType"];
    self.nLyricsCommandments = data[@"LyricsCommandments"];
    self.nCommandmentsType = data[@"CommandmentsType"];
    self.nHapjooChord = data[@"HapjooChord"];
    self.nPrintType = data[@"PrintType"];
    
    self.bChordHelper = data[@"ChordHelper"];
    self.bChordFixed = data[@"ChordFixed"];
}

@end
