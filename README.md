# BER-TLV parser and builder


## Parsing

    NSString * hex =
        /*            0  1  2  3   4  5  6  7     8  9  a  b   c  d  e  f      0123 4567  89ab  cdef */
        /*    0 */ @"e1 35 9f 1e  08 31 36 30    32 31 34 33  37 ef 12 df" // .5.. .160  2143  7...
        /*   10 */ @"0d 08 4d 30  30 30 2d 4d    50 49 df 7f  04 31 2d 32" // ..M0 00-M  PI..  .1-2
        /*   20 */ @"32 ef 14 df  0d 0b 4d 30    30 30 2d 54  45 53 54 4f" // 2... ..M0  00-T  ESTO
        /*   30 */ @"53 df 7f 03  36 2d 35                               " // S... 6-5
    ;
    NSData *data = [HexUtil parse:hex];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlv *tlv = [parser parseConstructed:data];

    NSLog(@"\n%@", [tlv dump:@"  "]);


The output is:

    + [E1]
       - [9F1E] 3136303231343337
       + [EF]
           - [DF0D] 4D3030302D4D5049
           - [DF7F] 312D3232
       + [EF]
           - [DF0D] 4D3030302D544553544F53
           - [DF7F] 362D35


## Building

     BerTlvBuilder *builder = [[BerTlvBuilder alloc] initWithTemplate:TAG_E0];
     for(int i=0; i<5; i++) {
         [builder addHex:@"F9128478E28F860D8424000008514C8F" tag:TAG_86];
     }

     BerTlvs *tlvs = builder.buildTlvs;

     NSLog(@"data is\n%@", [builder.buildTlvs dump:@"  "]);

The output is:

       + [E0]
         - [86] F9128478E28F860D8424000008514C8F
         - [86] F9128478E28F860D8424000008514C8F
         - [86] F9128478E28F860D8424000008514C8F
         - [86] F9128478E28F860D8424000008514C8F
         - [86] F9128478E28F860D8424000008514C8F


