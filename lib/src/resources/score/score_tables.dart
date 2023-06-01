
class ScoreTables{

  ///코드 테이블
  List<List<String>> strMeterKeyChordTable = [
    ["C",  "Db",   "D",   "Eb",   "E",   "F",  "F#",   "G",  "Ab",   "A",  "Bb",   "B"], ///MAJOR
    ["Cm", "C#m",  "Dm",  "Ebm",  "Em",  "Fm", "F#m",  "Gm", "G#m",  "Am", "Bbm",  "Bm"] ///minor
  ];

  ///Float 갯수 : -n   ,    Sharp 갯수 : n
  List<List<int>> strSharpFlatSuTable = [
    [0,    -5,     2,     -3,     4,    -1,     6,     1,    -4,     3,    -2,     5],  ///MAJOR
    [-3,     4,    -1,     -6,     1,    -4,     3,    -2,     5,     0,    -5,     2]  ///minor
  ];

  ///이명동음
  List<List<String>> strEnharmonicKeyChord = [
    [ "C#", "Db" ],
    [ "D#", "Eb" ],
    [ "F#", "Gb" ],
    [ "G#", "Ab" ],
    [ "A#", "Bb" ],
    [ "B#", "C"  ],
    [ "Cb", "B"  ],
    [ "E#", "F"  ],
    [ "Fb", "E"  ]
  ];

}