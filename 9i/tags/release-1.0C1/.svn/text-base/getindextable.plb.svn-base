CREATE OR REPLACE PACKAGE BODY &AnalyzeThisUser..getindexTable wrapped 
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
50
2 :e:
1PACKAGE:
1BODY:
1GETINDEXTABLE:
1GETTABLEINFO:
1P_IND_OWNER:
1VARCHAR2:
1P_IND_NAME:
1P_IND_PART_NAME:
1P_IND_SUBPART_NAME:
1P_TAB_OWNER:
1OUT:
1P_TAB_NAME:
1P_TAB_PART_NAME:
1P_TAB_SUBPART_NAME:
1L_TABLE_OWNER:
1DBA_INDEXES:
1TABLE_OWNER:
1TYPE:
1L_TABLE_NAME:
1TABLE_NAME:
1L_LOCALITY:
1DBA_PART_INDEXES:
1LOCALITY:
1CHECKINPUT:
1GETPARTINFO:
1GETNOPARTINFO:
1DEBUG:
1F:
1Begin of inline procedure checkInput:
1IS NULL:
1RAISE_APPLICATION_ERROR:
1-:
120002:
1p_ind_owner must be set:
120003:
1p_ind_name must be set:
1IS NOT NULL:
1when p_ind_subpart_name is specified then p_ind_part_name must also be set:
1End of inline procedure checkInput:
1Begin of inline procedure getPartInfo:
1Retrieving table info for index %s.%s:
1IND:
1PIN:
1OWNER:
1INDEX_NAME:
1SELECT ind.table_owner, ind.table_name, pin.locality:n            into l_tabl+
1e_owner, l_table_name, l_locality:n            from dba_indexes ind, dba_part+
1_indexes pin:n            where pin.owner = ind.owner:n                  and +
1pin.index_name = ind.index_name:n                  and ind.owner = p_ind_owne+
1r:n                  and ind.index_name = p_ind_name:
1Retrieved table_owner:: %s, table_name:: %s, l_locality:: %s:
1End of inline procedure getPartInfo:
1NO_DATA_FOUND:
1Index could not be found:
120001:
1getPartInfo:: Index does not exists or is not partitioned:
1Begin of inline procedure getNoPartInfo:
1SELECT ind.table_owner, ind.table_name:n            into l_table_owner, l_tab+
1le_name:n            from dba_indexes ind:n            where ind.owner = p_in+
1d_owner:n                  and ind.index_name = p_ind_name:
1Retrieved table_owner:: %s and table_name:: %s:
1End of inline procedure getNoPartInfo:
1Index could not be found in dba_indexes:
1getNoPartInfo:: Index does not exists:
1Begin of procedure getTableInfo:
1  input parameter p_ind_owner %s:
1  input parameter p_ind_name:: %s:
1  input parameter p_ind_part_name:: %s:
1  input parameter p_ind_subpart_name:: %s:
1Check the input parameters:
1Finished checking the input parameters:
1If the index is partitioned:
1Get the table info for a partitioned index:
1Finished getting the table info for a partitioned index:
1setting the output variablen:
1If it partitioned index is a local index:
1=:
1LOCAL:
1Setting the output variabelen for local partitioned indexes:
1Get the table info for nonpartitioned indexes:
1Finished getting the table info for partitioned indexes:
1  output param p_tab_owner:: %s:
1  output param p_tab_name:: %s:
1  output param p_tab_part_name:: %s:
1  output param p_tab_subpart_name:: %s:
1End of procedure getTableInfo:
0

0
0
205
2
0 :2 a0 97 9a 8f a0 b0 3d
8f a0 b0 3d 8f a0 4d b0
3d 8f a0 4d b0 3d 96 :2 a0
b0 54 96 :2 a0 b0 54 96 :2 a0
b0 54 96 :2 a0 b0 54 b4 55
6a a3 :2 a0 6b :2 a0 f 1c 81
b0 a3 :2 a0 6b :2 a0 f 1c 81
b0 a3 :2 a0 6b :2 a0 f 1c 81
b0 9a b4 55 6a 9a b4 55
6a 9a b4 55 6a 9a b4 55
6a :2 a0 6b 6e a5 57 a0 7e
b4 2e a0 7e 51 b4 2e 6e
a5 57 b7 19 3c a0 7e b4
2e a0 7e 51 b4 2e 6e a5
57 b7 19 3c a0 7e b4 2e
a0 7e b4 2e a0 7e 51 b4
2e 6e a5 57 b7 19 3c b7
19 3c :2 a0 6b 6e a5 57 b7
a4 a0 b1 11 68 4f 9a b4
55 6a :2 a0 6b 6e a5 57 :2 a0
6b 6e :2 a0 a5 57 :1b a0 12a :2 a0
6b 6e :3 a0 a5 57 :2 a0 6b 6e
a5 57 b7 :3 a0 6b 6e a5 57
a0 7e 51 b4 2e 6e a5 57
b7 a6 9 a4 a0 b1 11 68
4f 9a b4 55 6a :2 a0 6b 6e
a5 57 :2 a0 6b 6e :2 a0 a5 57
:e a0 12a :2 a0 6b 6e :2 a0 a5 57
:2 a0 6b 6e a5 57 b7 :3 a0 6b
6e a5 57 a0 7e 51 b4 2e
6e a5 57 b7 a6 9 a4 a0
b1 11 68 4f :2 a0 6b 6e a5
57 :2 a0 6b 6e a0 a5 57 :2 a0
6b 6e a0 a5 57 :2 a0 6b 6e
a0 a5 57 :2 a0 6b 6e a0 a5
57 :2 a0 6b 6e a5 57 a0 57
b3 :2 a0 6b 6e a5 57 :2 a0 6b
6e a5 57 a0 7e b4 2e :2 a0
6b 6e a5 57 a0 57 b3 :2 a0
6b 6e a5 57 :2 a0 6b 6e a5
57 :2 a0 d :2 a0 d :2 a0 6b 6e
a5 57 a0 7e 6e b4 2e :2 a0
6b 6e a5 57 :2 a0 d :2 a0 d
b7 19 3c b7 :2 a0 6b 6e a5
57 a0 57 b3 :2 a0 6b 6e a5
57 :2 a0 6b 6e a5 57 :2 a0 d
:2 a0 d b7 :2 19 3c :2 a0 6b 6e
a0 a5 57 :2 a0 6b 6e a0 a5
57 :2 a0 6b 6e a0 a5 57 :2 a0
6b 6e a0 a5 57 :2 a0 6b 6e
a5 57 b7 a4 a0 b1 11 68
4f b1 b7 a4 11 a0 b1 56
4f 1d 17 b5 
205
2
0 3 7 b 15 31 2d 2c
39 46 42 29 4e 58 53 57
41 60 6d 69 3e 68 75 86
7e 82 65 8d 9a 92 96 7d
a1 b2 aa ae 7a b9 c6 be
c2 a9 cd a6 d2 d6 103 de
e2 e6 e9 ed f1 f6 fe dd
130 10e 112 da 116 11a 11e 123
12b 10d 15d 13b 13f 10a 143 147
14b 150 158 13a 164 137 178 17c
180 194 195 199 19d 1b1 1b2 1b6
1ba 1ce 1cf 1d3 1d7 1db 1df 1e2
1e7 1e8 1ed 1f1 1f4 1f5 1fa 1fe
201 204 205 20a 20f 210 215 217
21b 21e 222 225 226 22b 22f 232
235 236 23b 240 241 246 248 24c
24f 253 256 257 25c 260 263 264
269 26d 270 273 274 279 27e 27f
284 286 28a 28d 28f 293 296 29a
29e 2a1 2a6 2a7 2ac 2ae 2b2 2b6
2b8 2c4 2c8 2ca 2de 2df 2e3 2e7
2eb 2ef 2f2 2f7 2f8 2fd 301 305
308 30d 311 315 316 31b 31f 323
327 32b 32f 333 337 33b 33f 343
347 34b 34f 353 357 35b 35f 363
367 36b 36f 373 377 37b 37f 383
387 393 397 39b 39e 3a3 3a7 3ab
3af 3b0 3b5 3b9 3bd 3c0 3c5 3c6
3cb 3cd 3d1 3d5 3d9 3dc 3e1 3e2
3e7 3eb 3ee 3f1 3f2 3f7 3fc 3fd
402 404 405 40a 40e 412 414 420
424 426 43a 43b 43f 443 447 44b
44e 453 454 459 45d 461 464 469
46d 471 472 477 47b 47f 483 487
48b 48f 493 497 49b 49f 4a3 4a7
4ab 4af 4bb 4bf 4c3 4c6 4cb 4cf
4d3 4d4 4d9 4dd 4e1 4e4 4e9 4ea
4ef 4f1 4f5 4f9 4fd 500 505 506
50b 50f 512 515 516 51b 520 521
526 528 529 52e 532 536 538 544
548 54a 54e 552 555 55a 55b 560
564 568 56b 570 574 575 57a 57e
582 585 58a 58e 58f 594 598 59c
59f 5a4 5a8 5a9 5ae 5b2 5b6 5b9
5be 5c2 5c3 5c8 5cc 5d0 5d3 5d8
5d9 5de 5e2 5e7 5e8 5ec 5f0 5f3
5f8 5f9 5fe 602 606 609 60e 60f
614 618 61b 61c 621 625 629 62c
631 632 637 63b 640 641 645 649
64c 651 652 657 65b 65f 662 667
668 66d 671 675 679 67d 681 685
689 68d 690 695 696 69b 69f 6a2
6a7 6a8 6ad 6b1 6b5 6b8 6bd 6be
6c3 6c7 6cb 6cf 6d3 6d7 6db 6dd
6e1 6e4 6e6 6ea 6ee 6f1 6f6 6f7
6fc 700 705 706 70a 70e 711 716
717 71c 720 724 727 72c 72d 732
736 73a 73e 742 746 74a 74c 750
754 757 75b 75f 762 767 76b 76c
771 775 779 77c 781 785 786 78b
78f 793 796 79b 79f 7a0 7a5 7a9
7ad 7b0 7b5 7b9 7ba 7bf 7c3 7c7
7ca 7cf 7d0 7d5 7d7 7db 7df 7e1
7ed 7f1 7f3 7f5 7f7 7fb 807 80b
80d 810 812 813 81c 
205
2
0 1 9 e f b 29 :3 b
29 :3 b 29 3d :3 b 29 3d :3 b
21 29 :3 b 21 29 :3 b 21 29
:3 b 21 29 :2 b 9 :2 5 9 1d
29 1d :2 35 :3 1d :2 9 1d 29 1d
:2 34 :3 1d :2 9 1d 2e 1d :2 37 :3 1d
9 13 0 :2 9 13 0 :2 9 13
0 :2 9 13 0 :2 9 d :2 13 15
:2 d :4 10 11 29 2a :2 29 31 :2 11
:3 d :4 10 11 29 2a :2 29 31 :2 11
:3 d :4 10 :4 14 15 2d 2e :2 2d 35
:2 15 :3 11 :4 d :2 13 15 :2 d :2 9 d
:4 9 13 0 :2 9 d :2 13 15 :3 d
:2 13 15 3e 4b :2 d 14 18 25
29 35 39 12 21 2f 12 1e
23 34 13 17 1f 23 17 1b
28 2c 17 1b 23 17 1b 28
:2 d :2 13 15 52 61 6f :3 d :2 13
15 :2 d 9 12 11 :2 17 19 :3 11
29 2a :2 29 31 :2 11 :3 d 9 d
:4 9 13 0 :2 9 d :2 13 15 :3 d
:2 13 15 3e 4b :2 d 14 18 25
29 12 21 12 1e 13 17 1f
17 1b 28 :2 d :2 13 15 45 54
:3 d :2 13 15 :2 d 9 12 11 :2 17
19 :3 11 29 2a :2 29 31 :2 11 :3 d
9 d :5 9 :2 f 11 :3 9 :2 f 11
35 :3 9 :2 f 11 35 :3 9 :2 f 11
3a :3 9 :2 f 11 3d :3 9 :2 f 11
:6 9 :2 f 11 :3 9 :2 f 11 :2 9 :4 c
d :2 13 15 :6 d :2 13 15 :3 d :2 13
15 :3 d 1c :2 d 1b :2 d :2 13 15
:2 d 10 1b 1d :2 1b 11 :2 17 19
:3 11 24 :2 11 27 11 :3 d 9 d
:2 13 15 :6 d :2 13 15 :3 d :2 13 15
:3 d 1c :2 d 1b d :5 9 :2 f 11
33 :3 9 :2 f 11 32 :3 9 :2 f 11
37 :3 9 :2 f 11 3a :3 9 :2 f 11
:2 9 :2 5 9 :9 5 :6 1 
205
4
0 :3 1 5f :4 60
:4 61 :5 62 :5 63 :5 64
:5 65 :5 66 :5 67 60
:2 5f :a 6c :a 6d :a 6e
71 0 :2 71 72
0 :2 72 73 0
:2 73 78 0 :2 78
:6 7e :4 81 :8 83 82
:2 81 :4 87 :8 89 88
:2 87 :4 8d :4 8f :8 91
90 :2 8f 8e :2 8d
:6 95 :2 7c 97 :4 78
9a 0 :2 9a :6 a0
:8 a2 :6 a4 :3 a5 :4 a6
:4 a7 :4 a8 :3 a9 :3 aa
a4 :9 ac :6 ae 9e
b1 :6 b3 :8 b4 b2
:2 b1 b0 b6 :4 9a
b9 0 :2 b9 :6 bf
:8 c1 :4 c3 :2 c4 :2 c5
:3 c6 :3 c7 c3 :8 c9
:6 cb bd ce :6 d0
:8 d1 cf :2 ce cd
d3 :4 b9 :6 d8 :7 d9
:7 da :7 db :7 dc :6 df
:3 e0 :6 e1 :6 e4 :4 e5
:6 e8 :3 e9 :6 ea :6 ec
:3 ed :3 ee :6 f1 :5 f2
:6 f5 :3 f6 :3 f7 f3
:2 f2 e6 :6 fd :3 fe
:6 ff :6 101 :3 102 :3 103
fb :3 e5 :7 107 :7 108
:7 109 :7 10a :6 10b :2 d6
10e :8 5f 110 :6 1

81e
4
:3 0 1 :3 0 2
:3 0 3 :6 0 1
:2 0 4 :a 0 1f8
2 :7 0 5 3e
0 3 6 :3 0
5 :7 0 7 6
:6 0 7 6 :3 0
7 :7 0 b a
:3 0 6 :4 0 8
:7 0 10 e f
:2 0 b 7a 0
9 6 :3 0 9
:7 0 15 13 14
:2 0 f a6 0
d b :3 0 6
:3 0 a :6 0 1a
19 :3 0 b :3 0
6 :3 0 c :6 0
1f 1e :3 0 13
:2 0 11 b :3 0
6 :3 0 d :6 0
24 23 :3 0 b
:3 0 6 :3 0 e
:6 0 29 28 :3 0
2b :2 0 1f8 4
2c :2 0 39 3a
0 1c 10 :3 0
11 :2 0 4 2f
30 0 12 :3 0
12 :2 0 1 31
33 :3 0 34 :7 0
37 35 0 1f6
0 f :6 0 43
44 0 1e 10
:3 0 14 :2 0 4
12 :3 0 12 :2 0
1 3b 3d :3 0
3e :7 0 41 3f
0 1f6 0 13
:9 0 20 16 :3 0
17 :2 0 4 12
:3 0 12 :2 0 1
45 47 :3 0 48
:7 0 4b 49 0
1f6 0 15 :6 0
18 :a 0 4f 3
:7 0 4d :2 0 4f
4c 4e 0 1f6
19 :a 0 53 4
:8 0 51 :2 0 53
50 52 0 1f6
1a :a 0 57 5
:8 0 55 :2 0 57
54 56 0 1f6
18 :a 0 a1 6
:8 0 59 :2 0 a1
58 5a :2 0 1b
:3 0 1c :3 0 5c
5d 0 1d :4 0
22 5e 60 :2 0
9c 5 :3 0 1e
:2 0 24 63 64
:3 0 1f :3 0 20
:2 0 21 :2 0 26
67 69 :3 0 22
:4 0 28 66 6c
:2 0 6e 2b 6f
65 6e 0 70
2d 0 9c 7
:3 0 1e :2 0 2f
72 73 :3 0 1f
:3 0 20 :2 0 23
:2 0 31 76 78
:3 0 24 :4 0 33
75 7b :2 0 7d
36 7e 74 7d
0 7f 38 0
9c 9 :3 0 25
:2 0 3a 81 82
:3 0 8 :3 0 1e
:2 0 3c 85 86
:3 0 1f :3 0 20
:2 0 21 :2 0 3e
89 8b :3 0 26
:4 0 40 88 8e
:2 0 90 43 91
87 90 0 92
45 0 93 47
94 83 93 0
95 49 0 9c
1b :3 0 1c :3 0
96 97 0 27
:4 0 4b 98 9a
:2 0 9c 4d a0
:3 0 a0 18 :4 0
a0 9f 9c 9d
:6 0 a1 2 0
58 5a a0 1f6
:2 0 19 :a 0 f7
7 :8 0 a4 :2 0
f7 a3 a5 :2 0
1b :3 0 1c :3 0
a7 a8 0 28
:4 0 53 a9 ab
:2 0 e0 1b :3 0
1c :3 0 ad ae
0 29 :4 0 5
:3 0 7 :3 0 55
af b3 :2 0 e0
2a :3 0 11 :3 0
2a :3 0 14 :3 0
2b :3 0 17 :3 0
f :3 0 13 :3 0
15 :3 0 10 :3 0
2a :3 0 16 :3 0
2b :3 0 2b :3 0
2c :3 0 2a :3 0
2c :3 0 2b :3 0
2d :3 0 2a :3 0
2d :3 0 2a :3 0
2c :3 0 5 :3 0
2a :3 0 2d :3 0
7 :4 0 2e 1
:8 0 e0 1b :3 0
1c :3 0 d1 d2
0 2f :4 0 f
:3 0 13 :3 0 15
:3 0 59 d3 d8
:2 0 e0 1b :3 0
1c :3 0 da db
0 30 :4 0 5e
dc de :2 0 e0
60 f6 31 :3 0
1b :3 0 1c :3 0
e2 e3 0 32
:4 0 66 e4 e6
:2 0 f0 1f :3 0
20 :2 0 33 :2 0
68 e9 eb :3 0
34 :4 0 6a e8
ee :2 0 f0 6d
f2 70 f1 f0
:2 0 f3 72 :2 0
f6 19 :4 0 f6
f5 e0 f3 :6 0
f7 2 0 a3
a5 f6 1f6 :2 0
1a :a 0 13f 8
:8 0 fa :2 0 13f
f9 fb :2 0 1b
:3 0 1c :3 0 fd
fe 0 35 :4 0
74 ff 101 :2 0
128 1b :3 0 1c
:3 0 103 104 0
29 :4 0 5 :3 0
7 :3 0 76 105
109 :2 0 128 2a
:3 0 11 :3 0 2a
:3 0 14 :3 0 f
:3 0 13 :3 0 10
:3 0 2a :3 0 2a
:3 0 2c :3 0 5
:3 0 2a :3 0 2d
:3 0 7 :4 0 36
1 :8 0 128 1b
:3 0 1c :3 0 11a
11b 0 37 :4 0
f :3 0 13 :3 0
7a 11c 120 :2 0
128 1b :3 0 1c
:3 0 122 123 0
38 :4 0 7e 124
126 :2 0 128 80
13e 31 :3 0 1b
:3 0 1c :3 0 12a
12b 0 39 :4 0
86 12c 12e :2 0
138 1f :3 0 20
:2 0 33 :2 0 88
131 133 :3 0 3a
:4 0 8a 130 136
:2 0 138 8d 13a
90 139 138 :2 0
13b 92 :2 0 13e
1a :4 0 13e 13d
128 13b :6 0 13f
2 0 f9 fb
13e 1f6 :2 0 1b
:3 0 1c :3 0 141
142 0 3b :4 0
94 143 145 :2 0
1f3 1b :3 0 1c
:3 0 147 148 0
3c :4 0 5 :3 0
96 149 14c :2 0
1f3 1b :3 0 1c
:3 0 14e 14f 0
3d :4 0 7 :3 0
99 150 153 :2 0
1f3 1b :3 0 1c
:3 0 155 156 0
3e :4 0 8 :3 0
9c 157 15a :2 0
1f3 1b :3 0 1c
:3 0 15c 15d 0
3f :4 0 9 :3 0
9f 15e 161 :2 0
1f3 1b :3 0 1c
:3 0 163 164 0
40 :4 0 a2 165
167 :2 0 1f3 18
:3 0 169 16b :2 0
1f3 0 1b :3 0
1c :3 0 16c 16d
0 41 :4 0 a4
16e 170 :2 0 1f3
1b :3 0 1c :3 0
172 173 0 42
:4 0 a6 174 176
:2 0 1f3 8 :3 0
25 :2 0 a8 179
17a :3 0 1b :3 0
1c :3 0 17c 17d
0 43 :4 0 aa
17e 180 :2 0 1b1
19 :3 0 182 184
:2 0 1b1 0 1b
:3 0 1c :3 0 185
186 0 44 :4 0
ac 187 189 :2 0
1b1 1b :3 0 1c
:3 0 18b 18c 0
45 :4 0 ae 18d
18f :2 0 1b1 a
:3 0 f :3 0 191
192 0 1b1 c
:3 0 13 :3 0 194
195 0 1b1 1b
:3 0 1c :3 0 197
198 0 46 :4 0
b0 199 19b :2 0
1b1 15 :3 0 47
:2 0 48 :4 0 b4
19e 1a0 :3 0 1b
:3 0 1c :3 0 1a2
1a3 0 49 :4 0
b7 1a4 1a6 :2 0
1ae d :3 0 8
:3 0 1a8 1a9 0
1ae e :3 0 9
:3 0 1ab 1ac 0
1ae b9 1af 1a1
1ae 0 1b0 bd
0 1b1 bf 1ce
1b :3 0 1c :3 0
1b2 1b3 0 4a
:4 0 c8 1b4 1b6
:2 0 1cd 1a :3 0
1b8 1ba :2 0 1cd
0 1b :3 0 1c
:3 0 1bb 1bc 0
4b :4 0 ca 1bd
1bf :2 0 1cd 1b
:3 0 1c :3 0 1c1
1c2 0 45 :4 0
cc 1c3 1c5 :2 0
1cd a :3 0 f
:3 0 1c7 1c8 0
1cd c :3 0 13
:3 0 1ca 1cb 0
1cd ce 1cf 17b
1b1 0 1d0 0
1cd 0 1d0 d5
0 1f3 1b :3 0
1c :3 0 1d1 1d2
0 4c :4 0 a
:3 0 d8 1d3 1d6
:2 0 1f3 1b :3 0
1c :3 0 1d8 1d9
0 4d :4 0 c
:3 0 db 1da 1dd
:2 0 1f3 1b :3 0
1c :3 0 1df 1e0
0 4e :4 0 d
:3 0 de 1e1 1e4
:2 0 1f3 1b :3 0
1c :3 0 1e6 1e7
0 4f :4 0 e
:3 0 e1 1e8 1eb
:2 0 1f3 1b :3 0
1c :3 0 1ed 1ee
0 50 :4 0 e4
1ef 1f1 :2 0 1f3
e6 1f7 :3 0 1f7
4 :3 0 f6 1f7
1f6 1f3 1f4 :6 0
1f8 1 0 4
2c 1f7 1ff :3 0
1fd 0 1fd :3 0
1fd 1ff 1fb 1fc
:6 0 200 :2 0 3
:3 0 100 0 3
1fd 203 :3 0 202
200 204 :8 0 
102
4
:3 0 1 5 1
9 1 d 1
12 1 17 1
1c 1 21 1
26 :2 8 c 11
16 1b 20 25
2a 1 2e 1
38 1 42 1
5f 1 62 1
68 2 6a 6b
1 6d 1 6f
1 71 1 77
2 79 7a 1
7c 1 7e 1
80 1 84 1
8a 2 8c 8d
1 8f 1 91
1 92 1 94
1 99 5 61
70 7f 95 9b
1 aa 3 b0
b1 b2 4 d4
d5 d6 d7 1
dd 5 ac b4
d0 d9 df 1
e5 1 ea 2
ec ed 2 e7
ef 1 e1 1
f2 1 100 3
106 107 108 3
11d 11e 11f 1
125 5 102 10a
119 121 127 1
12d 1 132 2
134 135 2 12f
137 1 129 1
13a 1 144 2
14a 14b 2 151
152 2 158 159
2 15f 160 1
166 1 16f 1
175 1 178 1
17f 1 188 1
18e 1 19a 1
19f 2 19d 19f
1 1a5 3 1a7
1aa 1ad 1 1af
8 181 183 18a
190 193 196 19c
1b0 1 1b5 1
1be 1 1c4 6
1b7 1b9 1c0 1c6
1c9 1cc 2 1ce
1cf 2 1d4 1d5
2 1db 1dc 2
1e2 1e3 2 1e9
1ea 1 1f0 f
146 14d 154 15b
162 168 16a 171
177 1d0 1d7 1de
1e5 1ec 1f2 9
36 40 4a 4f
53 57 a1 f7
13f 1 1f8 
1
4
0 
203
0
1
14
8
13
0 1 2 2 2 2 2 2
0 0 0 0 0 0 0 0
0 0 0 0 
5 2 0
a3 2 7
50 2 4
9 2 0
58 2 6
4c 2 3
38 2 0
26 2 0
2e 2 0
21 2 0
1c 2 0
17 2 0
d 2 0
12 2 0
42 2 0
4 1 2
3 0 1
f9 2 8
54 2 5
0

/
