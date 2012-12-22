CREATE OR REPLACE PACKAGE BODY &AnalyzeThisUser..getLastAnalyzedDate wrapped 
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
3
b
9200000
1
4
0 
57
2 :e:
1PACKAGE:
1BODY:
1GETLASTANALYZEDDATE:
1FUNCTION:
1GETDATE:
1P_OWNER:
1VARCHAR2:
1P_OBJECT_TYPE:
1P_OBJECT_NAME:
1P_PART_NAME:
1P_SUBPART_NAME:
1RETURN:
1DATE:
1L_LASTANALYZED:
1SETTABSUBPARTDATE:
1SETTABPARTDATE:
1SETTABDATE:
1SETINDSUBPARTDATE:
1SETINDPARTDATE:
1SETINDDATE:
1CHECKINPUT:
1DEBUG:
1F:
1Begin of inline procedure setTabSubpartDate:
1LAST_ANALYZED:
1DBA_TAB_SUBPARTITIONS:
1TABLE_OWNER:
1TABLE_NAME:
1PARTITION_NAME:
1SUBPARTITION_NAME:
1SELECT last_analyzed:n            into l_lastAnalyzed:n            from dba_t+
1ab_subpartitions:n            where table_owner = p_owner:n                  +
1and table_name = p_object_name:n                  and partition_name = p_part+
1_name:n                  and subpartition_name = p_subpart_name:
1End of inline procedure setTabSubpartDate:
1Begin of inline procedure setTabPartDate:
1DBA_TAB_PARTITIONS:
1SELECT last_analyzed:n            into l_lastAnalyzed:n            from dba_t+
1ab_partitions:n            where table_owner = p_owner:n                  and+
1 table_name = p_object_name:n                  and partition_name = p_part_na+
1me:
1End of inline procedure setTabPartDate:
1Begin of inline procedure setTabDate:
1DBA_TABLES:
1OWNER:
1SELECT last_analyzed:n            into l_lastAnalyzed:n            from dba_t+
1ables:n            where owner = p_owner:n                  and table_name = +
1p_object_name:
1End of inline procedure setTabDate:
1Begin of inline procedure setIndSubpartDate:
1DBA_IND_SUBPARTITIONS:
1INDEX_OWNER:
1INDEX_NAME:
1SELECT last_analyzed:n            into l_lastAnalyzed:n            from dba_i+
1nd_subpartitions:n            where index_owner = p_owner:n                  +
1and index_name = p_object_name:n                  and partition_name = p_part+
1_name:n                  and subpartition_name = p_subpart_name:
1End of inline procedure setIndSubpartDate:
1Begin of inline procedure setIndPartDate:
1DBA_IND_PARTITIONS:
1SELECT last_analyzed:n            into l_lastAnalyzed:n            from dba_i+
1nd_partitions:n            where index_owner = p_owner:n                  and+
1 index_name = p_object_name:n                  and partition_name = p_part_na+
1me:
1End of inline procedure setIndPartDate:
1Begin of inline procedure setIndDate:
1DBA_INDEXES:
1SELECT last_analyzed:n            into l_lastAnalyzed:n            from dba_i+
1ndexes:n            where owner = p_owner:n                  and index_name =+
1 p_object_name:
1End of inline procedure setIndDate:
1Begin of inline procedure checkInput:
1TABLE:
1INDEX:
1RAISE_APPLICATION_ERROR:
1-:
120002:
1p_object_type must be either set to TABLE or INDEX:
1IS NULL:
1p_owner must be set:
120003:
1p_object_name must be set:
1IS NOT NULL:
120004:
1when p_subpart_name is specified then p_part_name must also be set:
1End of inline procedure checkInput:
1Begin of function getDate:
1  input parameter p_owner %s:
1  input parameter p_object_type:: %s:
1  input parameter p_object_name:: %s:
1  input parameter p_part_name:: %s:
1  input parameter p_subpart_name:: %s:
1Check input parameter:
1retrieve last_analyzed_date:
1=:
1ELSIF:
1Returning l_lastAnalyzed:: %s:
1TO_CHAR:
1DD/MM/YYYY HH24::MI::SS:
1End of function getDate:
1NO_DATA_FOUND:
120001:
1table or index does not exists:
0

0
0
21e
2
0 :2 a0 97 a0 8d 8f a0 b0
3d 8f a0 b0 3d 8f a0 b0
3d 8f a0 b0 3d 8f a0 b0
3d b4 :2 a0 2c 6a a3 a0 1c
81 b0 9a b4 55 6a 9a b4
55 6a 9a b4 55 6a 9a b4
55 6a 9a b4 55 6a 9a b4
55 6a 9a b4 55 6a 9a b4
55 6a :2 a0 6b 6e a5 57 :b a0
12a :2 a0 6b 6e a5 57 b7 a4
a0 b1 11 68 4f 9a b4 55
6a :2 a0 6b 6e a5 57 :9 a0 12a
:2 a0 6b 6e a5 57 b7 a4 a0
b1 11 68 4f 9a b4 55 6a
:2 a0 6b 6e a5 57 :7 a0 12a :2 a0
6b 6e a5 57 b7 a4 a0 b1
11 68 4f 9a b4 55 6a :2 a0
6b 6e a5 57 :b a0 12a :2 a0 6b
6e a5 57 b7 a4 a0 b1 11
68 4f 9a b4 55 6a :2 a0 6b
6e a5 57 :9 a0 12a :2 a0 6b 6e
a5 57 b7 a4 a0 b1 11 68
4f 9a b4 55 6a :2 a0 6b 6e
a5 57 :7 a0 12a :2 a0 6b 6e a5
57 b7 a4 a0 b1 11 68 4f
9a b4 55 6a :2 a0 6b 6e a5
57 a0 4c :2 6e 5 48 a0 7e
51 b4 2e 6e a5 57 b7 19
3c a0 7e b4 2e a0 7e 51
b4 2e 6e a5 57 b7 19 3c
a0 7e b4 2e a0 7e 51 b4
2e 6e a5 57 b7 19 3c a0
7e b4 2e a0 7e b4 2e a0
7e 51 b4 2e 6e a5 57 b7
19 3c b7 19 3c :2 a0 6b 6e
a5 57 b7 a4 a0 b1 11 68
4f :2 a0 6b 6e a5 57 :2 a0 6b
6e a0 a5 57 :2 a0 6b 6e a0
a5 57 :2 a0 6b 6e a0 a5 57
:2 a0 6b 6e a0 a5 57 :2 a0 6b
6e a0 a5 57 :2 a0 6b 6e a5
57 a0 57 b3 :2 a0 6b 6e a5
57 a0 7e b4 2e a0 7e 6e
b4 2e a0 57 b3 a0 b7 a0
7e 6e b4 2e a0 57 b3 b7
:2 19 3c a0 b7 a0 7e b4 2e
a0 7e 6e b4 2e a0 57 b3
a0 b7 a0 7e 6e b4 2e a0
57 b3 b7 :2 19 3c b7 19 a0
7e 6e b4 2e a0 57 b3 a0
b7 a0 7e 6e b4 2e a0 57
b3 b7 :2 19 3c b7 :2 19 3c :2 a0
6b 6e :2 a0 6e a5 b a5 57
:2 a0 6b 6e a5 57 :2 a0 65 b7
:2 a0 7e 51 b4 2e 6e a5 57
b7 a6 9 a4 a0 b1 11 68
4f b1 b7 a4 11 a0 b1 56
4f 1d 17 b5 
21e
2
0 3 7 b 15 19 35 31
30 3d 4a 46 2d 52 5b 57
45 63 70 6c 42 78 81 7d
6b 89 68 8e 92 96 9a b3
a2 a6 ae a1 ba 9e ce d2
d6 ea eb ef f3 107 108 10c
110 124 125 129 12d 141 142 146
14a 15e 15f 163 167 17b 17c 180
184 198 199 19d 1a1 1a5 1a9 1ac
1b1 1b2 1b7 1bb 1bf 1c3 1c7 1cb
1cf 1d3 1d7 1db 1df 1e3 1ef 1f3
1f7 1fa 1ff 200 205 207 20b 20f
211 21d 221 223 237 238 23c 240
244 248 24b 250 251 256 25a 25e
262 266 26a 26e 272 276 27a 286
28a 28e 291 296 297 29c 29e 2a2
2a6 2a8 2b4 2b8 2ba 2ce 2cf 2d3
2d7 2db 2df 2e2 2e7 2e8 2ed 2f1
2f5 2f9 2fd 301 305 309 315 319
31d 320 325 326 32b 32d 331 335
337 343 347 349 35d 35e 362 366
36a 36e 371 376 377 37c 380 384
388 38c 390 394 398 39c 3a0 3a4
3a8 3b4 3b8 3bc 3bf 3c4 3c5 3ca
3cc 3d0 3d4 3d6 3e2 3e6 3e8 3fc
3fd 401 405 409 40d 410 415 416
41b 41f 423 427 42b 42f 433 437
43b 43f 44b 44f 453 456 45b 45c
461 463 467 46b 46d 479 47d 47f
493 494 498 49c 4a0 4a4 4a7 4ac
4ad 4b2 4b6 4ba 4be 4c2 4c6 4ca
4ce 4da 4de 4e2 4e5 4ea 4eb 4f0
4f2 4f6 4fa 4fc 508 50c 50e 522
523 527 52b 52f 533 536 53b 53c
541 1 545 54a 54f 553 556 55a
55d 560 561 566 56b 56c 571 573
577 57a 57e 581 582 587 58b 58e
591 592 597 59c 59d 5a2 5a4 5a8
5ab 5af 5b2 5b3 5b8 5bc 5bf 5c2
5c3 5c8 5cd 5ce 5d3 5d5 5d9 5dc
5e0 5e3 5e4 5e9 5ed 5f0 5f1 5f6
5fa 5fd 600 601 606 60b 60c 611
613 617 61a 61c 620 623 627 62b
62e 633 634 639 63b 63f 643 645
651 655 657 65b 65f 662 667 668
66d 671 675 678 67d 681 682 687
68b 68f 692 697 69b 69c 6a1 6a5
6a9 6ac 6b1 6b5 6b6 6bb 6bf 6c3
6c6 6cb 6cf 6d0 6d5 6d9 6dd 6e0
6e5 6e9 6ea 6ef 6f3 6f7 6fa 6ff
700 705 709 70e 70f 713 717 71a
71f 720 725 729 72c 72d 732 736
739 73e 73f 744 748 74d 74e 752
754 758 75b 760 761 766 76a 76f
770 772 776 77a 77d 781 783 787
78a 78b 790 794 797 79c 79d 7a2
7a6 7ab 7ac 7b0 7b2 7b6 7b9 7be
7bf 7c4 7c8 7cd 7ce 7d0 7d4 7d8
7db 7dd 7e1 7e5 7e8 7ed 7ee 7f3
7f7 7fc 7fd 801 803 807 80a 80f
810 815 819 81e 81f 821 825 829
82c 82e 832 836 839 83d 841 844
849 84d 851 856 857 859 85a 85f
863 867 86a 86f 870 875 879 87d
881 883 887 88b 88e 891 892 897
89c 89d 8a2 8a4 8a5 8aa 8ae 8b2
8b4 8c0 8c4 8c6 8c8 8ca 8ce 8da
8de 8e0 8e3 8e5 8e6 8ef 
21e
2
0 1 9 e 5 e b 25
:3 b 25 :3 b 25 :3 b 25 :3 b 25
:2 b :2 9 10 :2 5 9 :3 1d 9 13
0 :2 9 13 0 :2 9 13 0 :2 9
13 0 :2 9 13 0 :2 9 13 0
:2 9 13 0 :2 9 13 0 :2 9 d
:2 13 15 :2 d 14 :2 12 13 21 17
24 17 28 17 2b :2 d :2 13 15
:2 d :2 9 d :4 9 13 0 :2 9 d
:2 13 15 :2 d 14 :2 12 13 21 17
24 17 28 :2 d :2 13 15 :2 d :2 9
d :4 9 13 0 :2 9 d :2 13 15
:2 d 14 :2 12 13 1b 17 24 :2 d
:2 13 15 :2 d :2 9 d :4 9 13 0
:2 9 d :2 13 15 :2 d 14 :2 12 13
21 17 24 17 28 17 2b :2 d
:2 13 15 :2 d :2 9 d :4 9 13 0
:2 9 d :2 13 15 :2 d 14 :2 12 13
21 17 24 17 28 :2 d :2 13 15
:2 d :2 9 d :4 9 13 0 :2 9 d
:2 13 15 :2 d 14 :2 12 13 1b 17
24 :2 d :2 13 15 :2 d :2 9 d :4 9
13 0 :2 9 d :2 13 15 :2 d 10
1e 26 2f :2 10 11 29 2a :2 29
31 :2 11 :3 d :4 10 11 29 2a :2 29
31 :2 11 :3 d :4 10 11 29 2a :2 29
31 :2 11 :3 d :4 10 :4 14 15 2d 2e
:2 2d 35 :2 15 :3 11 :4 d :2 13 15 :2 d
:2 9 d :5 9 :2 f 11 :3 9 :2 f 11
31 :3 9 :2 f 11 38 :3 9 :2 f 11
38 :3 9 :2 f 11 36 :3 9 :2 f 11
39 :3 9 :2 f 11 :6 9 :2 f 11 :2 9
:4 c 10 1e 20 :2 1e :3 11 :2 d 13
21 23 :2 21 :3 11 :4 d :2 9 :4 f 10
1e 20 :2 1e :3 11 :2 d 13 21 23
:2 21 :3 11 :4 d :2 9 10 1e 20 :2 1e
:3 11 :2 d 13 21 23 :2 21 :3 11 :4 d
:5 9 :2 f 11 31 39 49 :2 31 :3 9
:2 f 11 :3 9 10 9 5 e d
25 26 :2 25 2d :2 d 1c :2 9 5
9 :9 5 :6 1 
21e
4
0 :3 1 :2 60 :4 61
:4 62 :4 63 :4 64 :4 65
61 :2 67 :2 60 :5 6b
6e 0 :2 6e 6f
0 :2 6f 70 0
:2 70 71 0 :2 71
72 0 :2 72 73
0 :2 73 74 0
:2 74 78 0 :2 78
:6 7e 7f 80 81
:2 82 :2 83 :2 84 :2 85
7f :6 86 :2 7c 88
:4 78 8b 0 :2 8b
:6 91 92 93 94
:2 95 :2 96 :2 97 92
:6 98 :2 8f 9a :4 8b
9d 0 :2 9d :6 a3
a4 a5 a6 :2 a7
:2 a8 a4 :6 a9 :2 a1
ab :4 9d ae 0
:2 ae :6 b4 b5 b6
b7 :2 b8 :2 b9 :2 ba
:2 bb b5 :6 bc :2 b2
be :4 ae c1 0
:2 c1 :6 c7 c8 c9
ca :2 cb :2 cc :2 cd
c8 :6 ce :2 c5 d0
:4 c1 d3 0 :2 d3
:6 d9 da db dc
:2 dd :2 de da :6 df
:2 d7 e1 :4 d3 e4
0 :2 e4 :6 ea :6 ec
:8 ee ed :2 ec :4 f2
:8 f4 f3 :2 f2 :4 f8
:8 fa f9 :2 f8 :4 fe
:4 100 :8 102 101 :2 100
ff :2 fe :6 106 :2 e8
108 :4 e4 :6 10e :7 10f
:7 110 :7 111 :7 112 :7 113
:6 115 :3 116 :6 118 :4 119
:5 11b :3 11d 11e 11c
:5 11e :3 120 11f 11c
:2 11b 122 11a :4 122
:5 124 :3 126 127 125
:5 127 :3 129 128 125
:2 124 123 11a :5 12c
:3 12e 12f 12d :5 12f
:3 131 130 12d :2 12c
12b :3 119 :b 135 :6 136
:3 137 10c 13a :8 13b
:3 13a 139 13d :8 60
144 :6 1 
8f1
4
:3 0 1 :3 0 2
:3 0 3 :6 0 1
:2 0 4 :3 0 5
:a 0 211 2 :7 0
5 42 0 3
7 :3 0 6 :7 0
8 7 :3 0 9
68 0 :2 7 :3 0
8 :7 0 c b
:3 0 7 :3 0 9
:7 0 10 f :3 0
d :2 0 b 7
:3 0 a :7 0 14
13 :3 0 7 :3 0
b :7 0 18 17
:3 0 c :3 0 d
:3 0 1a 1c 0
211 5 1d :5 0
13 d :3 0 20
:7 0 23 21 0
20f 0 e :6 0
f :a 0 27 3
:7 0 25 :2 0 27
24 26 0 20f
10 :a 0 2b 4
:8 0 29 :2 0 2b
28 2a 0 20f
11 :a 0 2f 5
:8 0 2d :2 0 2f
2c 2e 0 20f
12 :a 0 33 6
:8 0 31 :2 0 33
30 32 0 20f
13 :a 0 37 7
:8 0 35 :2 0 37
34 36 0 20f
14 :a 0 3b 8
:8 0 39 :2 0 3b
38 3a 0 20f
15 :a 0 3f 9
:8 0 3d :2 0 3f
3c 3e 0 20f
f :a 0 61 a
:8 0 41 :2 0 61
40 42 :2 0 16
:3 0 17 :3 0 44
45 0 18 :4 0
15 46 48 :2 0
5c 19 :3 0 e
:3 0 1a :3 0 1b
:3 0 6 :3 0 1c
:3 0 9 :3 0 1d
:3 0 a :3 0 1e
:3 0 b :4 0 1f
1 :8 0 5c 16
:3 0 17 :3 0 56
57 0 20 :4 0
17 58 5a :2 0
5c 19 60 :3 0
60 f :4 0 60
5f 5c 5d :6 0
61 2 0 40
42 60 20f :2 0
10 :a 0 82 b
:8 0 64 :2 0 82
63 65 :2 0 16
:3 0 17 :3 0 67
68 0 21 :4 0
1d 69 6b :2 0
7d 19 :3 0 e
:3 0 22 :3 0 1b
:3 0 6 :3 0 1c
:3 0 9 :3 0 1d
:3 0 a :4 0 23
1 :8 0 7d 16
:3 0 17 :3 0 77
78 0 24 :4 0
1f 79 7b :2 0
7d 21 81 :3 0
81 10 :4 0 81
80 7d 7e :6 0
82 2 0 63
65 81 20f :2 0
11 :a 0 a1 c
:8 0 85 :2 0 a1
84 86 :2 0 16
:3 0 17 :3 0 88
89 0 25 :4 0
25 8a 8c :2 0
9c 19 :3 0 e
:3 0 26 :3 0 27
:3 0 6 :3 0 1c
:3 0 9 :4 0 28
1 :8 0 9c 16
:3 0 17 :3 0 96
97 0 29 :4 0
27 98 9a :2 0
9c 29 a0 :3 0
a0 11 :4 0 a0
9f 9c 9d :6 0
a1 2 0 84
86 a0 20f :2 0
12 :a 0 c4 d
:8 0 a4 :2 0 c4
a3 a5 :2 0 16
:3 0 17 :3 0 a7
a8 0 2a :4 0
2d a9 ab :2 0
bf 19 :3 0 e
:3 0 2b :3 0 2c
:3 0 6 :3 0 2d
:3 0 9 :3 0 1d
:3 0 a :3 0 1e
:3 0 b :4 0 2e
1 :8 0 bf 16
:3 0 17 :3 0 b9
ba 0 2f :4 0
2f bb bd :2 0
bf 31 c3 :3 0
c3 12 :4 0 c3
c2 bf c0 :6 0
c4 2 0 a3
a5 c3 20f :2 0
13 :a 0 e5 e
:8 0 c7 :2 0 e5
c6 c8 :2 0 16
:3 0 17 :3 0 ca
cb 0 30 :4 0
35 cc ce :2 0
e0 19 :3 0 e
:3 0 31 :3 0 2c
:3 0 6 :3 0 2d
:3 0 9 :3 0 1d
:3 0 a :4 0 32
1 :8 0 e0 16
:3 0 17 :3 0 da
db 0 33 :4 0
37 dc de :2 0
e0 39 e4 :3 0
e4 13 :4 0 e4
e3 e0 e1 :6 0
e5 2 0 c6
c8 e4 20f :2 0
14 :a 0 104 f
:8 0 e8 :2 0 104
e7 e9 :2 0 16
:3 0 17 :3 0 eb
ec 0 34 :4 0
3d ed ef :2 0
ff 19 :3 0 e
:3 0 35 :3 0 27
:3 0 6 :3 0 2d
:3 0 9 :4 0 36
1 :8 0 ff 16
:3 0 17 :3 0 f9
fa 0 37 :4 0
3f fb fd :2 0
ff 41 103 :3 0
103 14 :4 0 103
102 ff 100 :6 0
104 2 0 e7
e9 103 20f :2 0
15 :a 0 160 10
:8 0 107 :2 0 160
106 108 :2 0 16
:3 0 17 :3 0 10a
10b 0 38 :4 0
45 10c 10e :2 0
15b 8 :3 0 39
:4 0 3a :4 0 47
:3 0 110 111 114
3b :3 0 3c :2 0
3d :2 0 4a 117
119 :3 0 3e :4 0
4c 116 11c :2 0
11e 4f 11f 115
11e 0 120 51
0 15b 6 :3 0
3f :2 0 53 122
123 :3 0 3b :3 0
3c :2 0 3d :2 0
55 126 128 :3 0
40 :4 0 57 125
12b :2 0 12d 5a
12e 124 12d 0
12f 5c 0 15b
9 :3 0 3f :2 0
5e 131 132 :3 0
3b :3 0 3c :2 0
41 :2 0 60 135
137 :3 0 42 :4 0
62 134 13a :2 0
13c 65 13d 133
13c 0 13e 67
0 15b b :3 0
43 :2 0 69 140
141 :3 0 a :3 0
3f :2 0 6b 144
145 :3 0 3b :3 0
3c :2 0 44 :2 0
6d 148 14a :3 0
45 :4 0 6f 147
14d :2 0 14f 72
150 146 14f 0
151 74 0 152
76 153 142 152
0 154 78 0
15b 16 :3 0 17
:3 0 155 156 0
46 :4 0 7a 157
159 :2 0 15b 7c
15f :3 0 15f 15
:4 0 15f 15e 15b
15c :6 0 160 2
0 106 108 15f
20f :2 0 16 :3 0
17 :3 0 162 163
0 47 :4 0 83
164 166 :2 0 200
16 :3 0 17 :3 0
168 169 0 48
:4 0 6 :3 0 85
16a 16d :2 0 200
16 :3 0 17 :3 0
16f 170 0 49
:4 0 8 :3 0 88
171 174 :2 0 200
16 :3 0 17 :3 0
176 177 0 4a
:4 0 9 :3 0 8b
178 17b :2 0 200
16 :3 0 17 :3 0
17d 17e 0 4b
:4 0 a :3 0 8e
17f 182 :2 0 200
16 :3 0 17 :3 0
184 185 0 4c
:4 0 b :3 0 91
186 189 :2 0 200
16 :3 0 17 :3 0
18b 18c 0 4d
:4 0 94 18d 18f
:2 0 200 15 :3 0
191 193 :2 0 200
0 16 :3 0 17
:3 0 194 195 0
4e :4 0 96 196
198 :2 0 200 b
:3 0 43 :2 0 98
19b 19c :3 0 8
:3 0 4f :2 0 39
:4 0 9c 19f 1a1
:3 0 f :3 0 1a3
1a5 :2 0 1a7 0
50 :3 0 9f 1b2
8 :3 0 4f :2 0
3a :4 0 a3 1a9
1ab :3 0 12 :3 0
1ad 1af :2 0 1b0
0 a6 1b1 1ac
1b0 0 1b3 1a2
1a7 0 1b3 a8
0 1b5 50 :3 0
ab 1e9 a :3 0
43 :2 0 ad 1b7
1b8 :3 0 8 :3 0
4f :2 0 39 :4 0
b1 1bb 1bd :3 0
10 :3 0 1bf 1c1
:2 0 1c3 0 50
:3 0 b4 1ce 8
:3 0 4f :2 0 3a
:4 0 b8 1c5 1c7
:3 0 13 :3 0 1c9
1cb :2 0 1cc 0
bb 1cd 1c8 1cc
0 1cf 1be 1c3
0 1cf bd 0
1d0 c0 1d1 1b9
1d0 0 1eb 8
:3 0 4f :2 0 39
:4 0 c4 1d3 1d5
:3 0 11 :3 0 1d7
1d9 :2 0 1db 0
50 :3 0 c7 1e6
8 :3 0 4f :2 0
3a :4 0 cb 1dd
1df :3 0 14 :3 0
1e1 1e3 :2 0 1e4
0 ce 1e5 1e0
1e4 0 1e7 1d6
1db 0 1e7 d0
0 1e8 d3 1ea
19d 1b5 0 1eb
0 1e8 0 1eb
d5 0 200 16
:3 0 17 :3 0 1ec
1ed 0 51 :4 0
52 :3 0 e :3 0
53 :4 0 d9 1f0
1f3 dc 1ee 1f5
:2 0 200 16 :3 0
17 :3 0 1f7 1f8
0 54 :4 0 df
1f9 1fb :2 0 200
c :3 0 e :3 0
1fe :2 0 200 e1
210 55 :3 0 3b
:3 0 3c :2 0 56
:2 0 ef 203 205
:3 0 57 :4 0 f1
202 208 :2 0 20a
f4 20c f6 20b
20a :2 0 20d f8
:2 0 210 5 :3 0
fa 210 20f 200
20d :6 0 211 1
0 5 1d 210
218 :3 0 216 0
216 :3 0 216 218
214 215 :6 0 219
:2 0 3 :3 0 10a
0 3 216 21c
:3 0 21b 219 21d
:8 0 
10c
4
:3 0 1 6 1
a 1 e 1
12 1 16 5
9 d 11 15
19 1 1f 1
47 1 59 3
49 55 5b 1
6a 1 7a 3
6c 76 7c 1
8b 1 99 3
8d 95 9b 1
aa 1 bc 3
ac b8 be 1
cd 1 dd 3
cf d9 df 1
ee 1 fc 3
f0 f8 fe 1
10d 2 112 113
1 118 2 11a
11b 1 11d 1
11f 1 121 1
127 2 129 12a
1 12c 1 12e
1 130 1 136
2 138 139 1
13b 1 13d 1
13f 1 143 1
149 2 14b 14c
1 14e 1 150
1 151 1 153
1 158 6 10f
120 12f 13e 154
15a 1 165 2
16b 16c 2 172
173 2 179 17a
2 180 181 2
187 188 1 18e
1 197 1 19a
1 1a0 2 19e
1a0 1 1a4 1
1aa 2 1a8 1aa
1 1ae 2 1b2
1b1 1 1b3 1
1b6 1 1bc 2
1ba 1bc 1 1c0
1 1c6 2 1c4
1c6 1 1ca 2
1ce 1cd 1 1cf
1 1d4 2 1d2
1d4 1 1d8 1
1de 2 1dc 1de
1 1e2 2 1e6
1e5 1 1e7 3
1e9 1d1 1ea 2
1f1 1f2 2 1ef
1f4 1 1fa d
167 16e 175 17c
183 18a 190 192
199 1eb 1f6 1fc
1ff 1 204 2
206 207 1 209
1 201 1 20c
f 22 27 2b
2f 33 37 3b
3f 61 82 a1
c4 e5 104 160
1 211 
1
4
0 
21c
0
1
14
10
16
0 1 2 2 2 2 2 2
2 2 2 2 2 2 2 2
0 0 0 0 
1f 2 0
e 2 0
e7 2 f
38 2 8
a3 2 d
30 2 6
106 2 10
3c 2 9
12 2 0
5 1 2
6 2 0
a 2 0
16 2 0
3 0 1
84 2 c
2c 2 5
40 2 a
24 2 3
63 2 b
28 2 4
c6 2 e
34 2 7
0

/
