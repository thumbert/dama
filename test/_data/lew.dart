/// Data from https://www.itl.nist.gov/div898/handbook/datasets/LEW.DAT
/// This is Dataplot data file     LEW.DAT
/// Steel-concrete beam deflection
/// H. S. Lew (NBS Center for Building Technology)
/// Date--1969
/// Response Variable = deflection of beam from center point
/// Number of observations = 200
/// Number of variables per line image = 1
/// Order of variables per line image--
/// Response variable = deflection
///

List<num> lew() {
  var deflection = '''
    -213
  -564
   -35
   -15
   141
   115
  -420
  -360
   203
  -338
  -431
   194
  -220
  -513
   154
  -125
  -559
    92
   -21
  -579
   -52
    99
  -543
  -175
   162
  -457
  -346
   204
  -300
  -474
   164
  -107
  -572
    -8
    83
  -541
  -224
   180
  -420
  -374
   201
  -236
  -531
    83
    27
  -564
  -112
   131
  -507
  -254
   199
  -311
  -495
   143
   -46
  -579
   -90
   136
  -472
  -338
   202
  -287
  -477
   169
  -124
  -568
    17
    48
  -568
  -135
   162
  -430
  -422
   172
   -74
  -577
   -13
    92
  -534
  -243
   194
  -355
  -465
   156
   -81
  -578
   -64
   139
  -449
  -384
   193
  -198
  -538
   110
   -44
  -577
    -6
    66
  -552
  -164
   161
  -460
  -344
   205
  -281
  -504
   134
   -28
  -576
  -118
   156
  -437
  -381
   200
  -220
  -540
    83
    11
  -568
  -160
   172
  -414
  -408
   188
  -125
  -572
   -32
   139
  -492
  -321
   205
  -262
  -504
   142
   -83
  -574
     0
    48
  -571
  -106
   137
  -501
  -266
   190
  -391
  -406
   194
  -186
  -553
    83
   -13
  -577
   -49
   103
  -515
  -280
   201
   300
  -506
   131
   -45
  -578
   -80
   138
  -462
  -361
   201
  -211
  -554
    32
    74
  -533
  -235
   187
  -372
  -442
   182
  -147
  -566
    25
    68
  -535
  -244
   194
  -351
  -463
   174
  -125
  -570
    15
    72
  -550
  -190
   172
  -424
  -385
   198
  -218
  -536
    96''';

  var out = deflection.split('\n').map((e) {
    return num.parse(e.trim());
  }).toList();
  return out;
}