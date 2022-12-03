USE NATHI
go


--select* from m_men where men_nam like '%gl%'

--select * from m_men where men_cid=19
--update m_men set men_view=1 where men_id=20
--select * from m_men where men_cid=20
--update m_men set men_view=1 where men_cid=20 and men_id<>2017
--Cost Center Pending
--About

--select * from m_men where module_id=11
--update m_men set module_id=2 where men_id in (52,53)
--select * from m_men inner join m_mensubcat on m_men.mensubcat_id=m_mensubcat.mensubcat_id inner join m_mencat on m_mensubcat.mencat_id=m_mencat.mencat_id where module_id=2 order by mensubcat_nam,mencat_nam
--update m_men set men_act=0 
--update m_men set men_act=1 where module_id=2
--update m_men set men_act=1 where module_id=11
--update m_men set men_act=1 where men_id in (1,19,28)
--alter table m_men add men_view bit
--update m_men set men_view=1
--alter table m_men add men_sot int
--alter table m_men add men_lvl char(1)
--update m_men set men_sot=0,men_view=0,men_lvl='D'

--ALTER table m_men add men_cid int
--alter table m_men add men_sot int
--alter table m_men alter column men_sot int

--update m_men set men_sot=0
--alter table m_men add men_lvl char(1) 
--update m_men set men_lvl='D'
--update m_men set men_typ='S',men_lvl='S' where men_id in (1,19,28)
--update m_men set men_ali='Setup' where men_id=1
--update m_men set men_ali='Transaction' where men_id=19
--update m_men set men_ali='Report' where men_id=28
update m_men set men_typ='U'
--Setup
update m_men set men_cid=null,men_sot=0,men_nam=null,men_ali='Setup',men_act=1,men_view=1,men_typ='S' where men_id=1
--Transaction
update m_men set men_cid=null,men_sot=0,men_nam=null,men_ali='Transaction',men_act=1,men_view=1,men_typ='S' where men_id=19
--Report
update m_men set men_cid=null,men_sot=0,men_nam=null,men_ali='Report',men_act=1,men_view=1,men_typ='S' where men_id=28


--Company
update m_men set men_cid=1,men_sot=1,men_nam='m_com',men_act=1,men_view=1 where men_id=2
--Branch
update m_men set men_cid=1,men_sot=2,men_nam='m_br',men_act=1,men_view=1 where men_id=3
--Security
--Setup
update m_men set men_cid=1,men_sot=3,men_nam=null,men_act=1,men_view=1 where men_id=4
	update m_men set men_cid=4,men_sot=1,men_nam='m_usrgp',men_act=1,men_view=1,module_id=11 where men_id=2006
	update m_men set men_cid=4,men_sot=2,men_nam='m_gpper',men_act=1,men_view=1,module_id=11 where men_id=2007
	update m_men set men_cid=4,men_sot=3,men_nam='n_usr',men_act=1,men_view=1 where men_id=7
	update m_men set men_cid=4,men_sot=4,men_nam='m_per',men_act=1,men_view=1 where men_id=8
	update m_men set men_cid=4,men_sot=5,men_nam='m_info',men_act=1,men_view=1,module_id=11 where men_id=2063
	
	update m_men set men_cid=4,men_sot=6,men_nam=null,men_ali='Menu',men_act=1,men_view=1,module_id=11 where men_id=2005
		update m_men set men_cid=2005,men_sot=1,men_nam='m_module',men_act=1,men_view=1,module_id=11 where men_id=2001
		update m_men set men_cid=2005,men_sot=2,men_nam='m_mencat',men_act=1,men_view=1,module_id=11 where men_id=2002
		update m_men set men_cid=2005,men_sot=3,men_nam='m_mensubcat',men_act=1,men_view=1,module_id=11 where men_id=2003
		update m_men set men_cid=2005,men_sot=4,men_nam='m_men',men_act=1,men_view=1,module_id=11 where men_id=2004
--Report
update m_men set men_cid=28,men_sot=1,men_nam='reportsecurity',men_act=1,men_view=0 where men_id=2014
update m_men set men_cid=2014,men_sot=1,men_nam='reportaudit',men_act=0,men_view=0 where men_id=2015

--GL
update m_men set men_cid=1,men_sot=4,men_nam=null,men_act=1,men_view=1 where men_id=13
	update m_men set men_cid=13,men_sot=1,men_nam='gl_m_acc',men_act=1,men_view=1 where men_id=15
	update m_men set men_cid=13,men_sot=2,men_nam=null,men_act=1,men_view=1,men_lvl='M' where men_id=9
		update m_men set men_cid=9,men_sot=1,men_nam='m_bktyp',men_act=1,men_view=1 where men_id=10
		update m_men set men_cid=9,men_sot=2,men_nam='bk_acc',men_act=1,men_view=1 where men_id=11
		update m_men set men_cid=9,men_sot=3,men_nam='m_bk_chq',men_act=1,men_view=1 where men_id=12
	update m_men set men_cid=13,men_sot=3,men_nam='m_dpt',men_act=1,men_view=1 where men_id=16
	update m_men set men_cid=13,men_sot=4,men_nam='gl_t_vob',men_act=1,men_view=1 where men_id=17
	update m_men set men_cid=13,men_sot=5,men_nam='gl_m_yr',men_act=1,men_view=1 where men_id=14
	update m_men set men_cid=13,men_sot=6,men_nam='m_pettycash',men_act=1,men_view=1 where men_id=84
	update m_men set men_cid=13,men_sot=7,men_nam='m_cur',men_act=1,men_view=1 where men_id=52
	update m_men set men_cid=13,men_sot=8,men_nam='m_currat',men_act=1,men_view=1 where men_id=53
	update m_men set men_cid=13,men_sot=9,men_nam=null,men_act=1,men_view=0 where men_id=2009
		update m_men set men_cid=2009,men_sot=1,men_nam='',men_act=1,men_view=0 where men_id=2010
		update m_men set men_cid=2009,men_sot=2,men_nam='',men_act=1,men_view=0 where men_id=2011
		update m_men set men_cid=2009,men_sot=3,men_nam='',men_act=1,men_view=0 where men_id=2012
		update m_men set men_cid=2009,men_sot=4,men_nam='',men_act=1,men_view=0 where men_id=2013

--GL Transaction
update m_men set men_cid=19,men_sot=2,men_nam=null where men_id=20
	update m_men set men_cid=20,men_sot=1,men_nam='gl_t_vcr' where men_id=21
	update m_men set men_cid=20,men_sot=2,men_nam='gl_t_vcp' where men_id=22
	update m_men set men_cid=20,men_sot=3,men_nam='gl_t_vbr' where men_id=23
	update m_men set men_cid=20,men_sot=4,men_nam='gl_t_vbp' where men_id=24
	update m_men set men_cid=20,men_sot=6,men_nam='gl_t_vjv' where men_id=25
	update m_men set men_cid=20,men_sot=7,men_nam='gl_vch_app' where men_id=26
	update m_men set men_cid=20,men_sot=8,men_nam='gl_bk_con' where men_id=70
	update m_men set men_cid=20,men_sot=9,men_nam='t_yearend'where men_id=27
	update m_men set men_cid=20,men_sot=10,men_nam='',men_act=0,men_view=0 where men_id=2017

--GL Report
update m_men set men_cid=28,men_sot=1,men_nam='rpt_frm_glc',men_act=1,men_view=1,mensubcat_id=7  where men_id=29
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=30
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=31
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=32
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=33
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=34
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=35
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=36
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=37
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=38
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=71
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=72
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=73
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=74
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=175
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=176
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=177
	update m_men set men_cid=29,men_act=1,men_view=0 where men_id=2016






--Item
update m_men set men_cid=1,men_sot=5,men_nam=null,men_act=1,men_view=1,module_id=14 where men_id=39
	update m_men set men_cid=39,men_sot=1,men_nam='m_itm',men_act=1,men_view=1,module_id=14 where men_id=42
	update m_men set men_cid=39,men_sot=2,men_nam='m_gergp',men_act=1,men_view=1,module_id=14 where men_id=2057
	update m_men set men_cid=39,men_sot=3,men_nam='m_ger',men_act=1,men_view=1,module_id=14 where men_id=2058
	update m_men set men_cid=39,men_sot=4,men_nam='m_stdcatmas',men_act=1,men_view=1,module_id=14 where men_id=970
	update m_men set men_cid=39,men_sot=5,men_nam='m_stdcat',men_act=1,men_view=1,module_id=14 where men_id=971
	update m_men set men_cid=39,men_sot=6,men_nam='m_itmsubmas',men_act=1,men_view=1,module_id=14 where men_id=86
	update m_men set men_cid=39,men_sot=7,men_nam='m_itmsub',men_act=1,men_view=1,module_id=14 where men_id=69
	update m_men set men_cid=39,men_sot=8,men_nam='m_bd',men_act=0,men_view=1,module_id=14 where men_id=41
	update m_men set men_cid=39,men_sot=9,men_nam='m_str',men_act=1,men_view=1,module_id=14 where men_id=2054
	update m_men set men_cid=39,men_sot=10,men_nam='m_sca',men_act=1,men_view=1,module_id=14 where men_id=40
	update m_men set men_cid=39,men_sot=11,men_nam='m_itmgp',men_act=1,men_view=1,module_id=14 where men_id=2056
	update m_men set men_cid=39,men_sot=12,men_nam='m_manf',men_act=1,men_view=1,module_id=14 where men_id=2055
	update m_men set men_cid=39,men_sot=13,men_nam='t_itm',men_act=1,men_view=1,module_id=14 where men_id=43
	update m_men set men_cid=39,men_sot=14,men_nam='m_itmqty',men_act=0,men_view=1,module_id=14 where men_id=85
	update m_men set men_cid=39,men_sot=16,men_nam='m_bd_rat',men_act=1,men_view=1,module_id=14 where men_id=973
	update m_men set men_cid=39,men_sot=17,men_nam='t_itmrat',men_act=1,men_view=1,module_id=14 where men_id=972

--Purchase
--Setup
update m_men set men_cid=1,men_sot=6,men_nam=null,men_act=1,men_view=1 where men_id=981
	update m_men set men_cid=981,men_sot=1,men_nam='m_supcat',men_act=1,men_view=1 where men_id=47
	update m_men set men_cid=981,men_sot=2,men_nam='m_sup',men_act=0,men_view=1 where men_id=992
	update m_men set men_cid=981,men_sot=3,men_nam='m_sup',men_act=1,men_view=1 where men_id=48
	update m_men set men_cid=981,men_sot=4,men_nam='m_vend',men_act=1,men_view=1 where men_id=2053
	update m_men set men_cid=981,men_sot=5,men_nam='m_pat',men_act=1,men_view=1,module_id =7 where men_id=505
	update m_men set men_cid=981,men_sot=6,men_nam='m_carr',men_act=1,men_view=1 where men_id=2050
	update m_men set men_cid=981,men_sot=7,men_nam='m_ind',men_act=1,men_view=1 where men_id=2042
	update m_men set men_cid=981,men_sot=8,men_nam='m_qcres',men_act=1,men_view=1 where men_id=2041
	update m_men set men_cid=981,men_sot=9,men_nam='m_exp',men_act=1,men_view=1 where men_id=2051
	update m_men set men_cid=981,men_sot=10,men_nam='m_prcat',men_act=1,men_view=1 where men_id=2052
--Transaction
update m_men set men_cid=19,men_sot=2,men_nam=null,men_act=1,men_view=1 where men_id=54
	update m_men set men_cid=54,men_sot=1,men_nam='t_pr',men_act=1,men_view=1 where men_id=55
	update m_men set men_cid=54,men_sot=2,men_nam='t_po',men_act=1,men_view=1 where men_id=56
	update m_men set men_cid=54,men_sot=3,men_nam='t_supadv',men_act=1,men_view=1 where men_id=57
	update m_men set men_cid=54,men_sot=4,men_nam='t_grn',men_act=1,men_view=1 where men_id=58
	update m_men set men_cid=54,men_sot=5,men_nam='t_qc',men_act=1,men_view=1 where men_id=2069
	update m_men set men_cid=54,men_sot=6,men_nam='t_pb',men_act=1,men_view=1 where men_id=59
	update m_men set men_cid=54,men_sot=7,men_nam='t_pay',men_act=1,men_view=1 where men_id=60
	update m_men set men_cid=54,men_sot=8,men_nam='t_dn',men_act=1,men_view=1 where men_id=61
	update m_men set men_cid=54,men_sot=9,men_nam='t_pur',men_act=0,men_view=1 where men_id=''
	update m_men set men_cid=54,men_sot=10,men_nam='t_purchase',men_act=0,men_view=1 where men_id=''
--Report
update m_men set men_cid=28,men_sot=2,men_nam='rpt_frm_purchase',men_act=1,men_view =1,mensubcat_id=7 where men_id=101
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=102
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=103
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=104
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=105
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=106
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=107
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=108
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=109
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=110
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=112
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=113
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=114
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=203
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=204
	update m_men set men_cid=101,men_act=1,men_view=0 where men_id=205


--Inventory
--Setup
update m_men set men_cid=1,men_sot=7,men_nam=null,men_act=1,men_view=1,module_id=3 where men_id=980
	update m_men set men_cid=980,men_sot=11,men_nam='m_wh',men_act=1,men_view=1,module_id=3 where men_id=51
	update m_men set men_cid=980,men_sot=15,men_nam='t_itmop_new',men_act=1,men_view=1,module_id=3 where men_id=44
--Transaction
update m_men set men_cid=19,men_sot=3,men_nam=null,men_act=1,men_view=1,module_id=3 where men_id=501
	update m_men set men_cid=501,men_sot=1,men_nam='t_whtn',men_act=1,men_view=1,module_id=3 where men_id=2072
	update m_men set men_cid=501,men_sot=2,men_nam='t_stkval',men_act=1,men_view=1,module_id=3 where men_id=2071
	update m_men set men_cid=501,men_sot=3,men_nam='t_adjmon',men_act=1,men_view=1,module_id=3 where men_id=2070
--Report
update m_men set men_cid=28,men_sot=3,men_nam='rpt_frm_stk',men_act=1,men_view =1,mensubcat_id=7 where men_id=401
	update m_men set men_cid=401,men_act=1,men_view=0 where men_id=402
	update m_men set men_cid=401,men_act=1,men_view=0 where men_id=403
	update m_men set men_cid=401,men_act=1,men_view=0 where men_id=405
	update m_men set men_cid=401,men_act=1,men_view=0 where men_id=407
	update m_men set men_cid=401,men_act=1,men_view=0 where men_id=408
	update m_men set men_cid=401,men_act=1,men_view=0 where men_id=409
	update m_men set men_cid=401,men_act=1,men_view=0 where men_id=414
	update m_men set men_cid=401,men_act=1,men_view=0 where men_id=415
--Sales
--Setup
update m_men set men_cid=1,men_sot=8,men_nam=null,men_act=1,men_view=1,module_id=8 where men_id=974
	update m_men set men_cid=974,men_sot=1,men_nam='m_cuscat',men_act=1,men_view=1,module_id=8 where men_id=49
	update m_men set men_cid=974,men_sot=2,men_nam='m_cussubcat',men_act=1,men_view=1,module_id=8 where men_id=2031
	update m_men set men_cid=974,men_sot=3,men_nam='m_cus',men_act=1,men_view=1,module_id=8 where men_id=50
	update m_men set men_cid=974,men_sot=4,men_nam='m_cusbk',men_act=1,men_view=1,module_id=8 where men_id=2019
	update m_men set men_cid=974,men_sot=5,men_nam='m_prom',men_act=1,men_view=1,module_id=8 where men_id=2060
	update m_men set men_cid=974,men_sot=6,men_nam='m_procat',men_act=1,men_view=1,module_id=8 where men_id=2061
	update m_men set men_cid=974,men_sot=7,men_nam='m_salbook',men_act=0,men_view=1,module_id=8 where men_id=2059
	update m_men set men_cid=974,men_sot=8,men_nam='m_salmanzone',men_act=1,men_view=1,module_id=8 where men_id=979
--Transaction
update m_men set men_cid=19,men_sot=4,men_nam=null,men_act=1,men_view=1 where men_id=62
	update m_men set men_cid=62,men_sot=1,men_nam='t_so',men_act=1,men_view=1 where men_id=63
	update m_men set men_cid=62,men_sot=2,men_nam='t_cusadv',men_act=1,men_view=1 where men_id=64
	update m_men set men_cid=62,men_sot=3,men_nam='t_dc',men_act=1,men_view=1 where men_id=65
	update m_men set men_cid=62,men_sot=4,men_nam='t_inv',men_act=1,men_view=1 where men_id=66
	update m_men set men_cid=62,men_sot=5,men_nam='t_rec',men_act=1,men_view=1 where men_id=67
	update m_men set men_cid=62,men_sot=6,men_nam='t_cn',men_act=1,men_view=1 where men_id=68
--Report
update m_men set men_cid=28,men_sot=4,men_nam='sales_criteria',men_act=1,men_view =1,mensubcat_id=7 where men_id=301
	update m_men set men_cid=301,men_act=1,men_view=0 where men_id=303
	update m_men set men_cid=301,men_act=1,men_view=0 where men_id=2021
	update m_men set men_cid=301,men_act=1,men_view=0 where men_id=2022

--DVR
--Setup
update m_men set men_cid=1,men_sot=9,men_nam=null,men_act=1,men_view=1 where men_id=2049
	update m_men set men_cid=2049,men_sot=1,men_nam='m_coun',men_act=1,men_view=1,module_id=13 where men_id=975
	update m_men set men_cid=2049,men_sot=2,men_nam='m_city',men_act=0,men_view=1,module_id=13 where men_id=976
	update m_men set men_cid=2049,men_sot=3,men_nam='m_zone',men_act=1,men_view=1,module_id=13 where men_id=978
	update m_men set men_cid=2049,men_sot=4,men_nam='m_region',men_act=1,men_view=1 where men_id=2048
	update m_men set men_cid=2049,men_sot=5,men_nam='m_territory',men_act=1,men_view=1 where men_id=2046
	update m_men set men_cid=2049,men_sot=6,men_nam='m_bricks',men_act=1,men_view=1 where men_id=2044
	update m_men set men_cid=2049,men_sot=7,men_nam='m_mso',men_act=1,men_view=1 where men_id=2045
	update m_men set men_cid=2049,men_sot=8,men_nam='m_spo_cusitm',men_act=1,men_view=1 where men_id=2047
	update m_men set men_cid=2049,men_sot=9,men_nam='m_hos',men_act=1,men_view=1,module_id=13 where men_id=2066
	update m_men set men_cid=2049,men_sot=10,men_nam='m_doccat',men_act=1,men_view=1,module_id=13 where men_id=2065
	update m_men set men_cid=2049,men_sot=11,men_nam='m_doc',men_act=1,men_view=1,module_id=13 where men_id=2064
	update m_men set men_cid=2049,men_sot=12,men_nam='m_patientcat',men_act=1,men_view=1,module_id=13 where men_id=2068
	update m_men set men_cid=2049,men_sot=13,men_nam='m_patient',men_act=1,men_view=1,module_id=13 where men_id=2067

--Payroll
--Setup
update m_men set men_cid=1,men_sot=10,men_nam=null,men_act=1,men_view=1,module_id=5 where men_id=801
	update m_men set men_cid=801,men_sot=1,men_nam='m_mac_com',men_act=1,men_view=1,module_id=5 where men_id=812
	update m_men set men_cid=801,men_sot=2,men_nam='mac',men_act=1,men_view=1,module_id=5 where men_id=813
	update m_men set men_cid=801,men_sot=3,men_nam='m_rosgp',men_act=1,men_view=1,module_id=5 where men_id=2026
	update m_men set men_cid=801,men_sot=4,men_nam='m_ros',men_act=1,men_view=1,module_id=5 where men_id=806
	update m_men set men_cid=801,men_sot=5,men_nam='m_all',men_act=1,men_view=1,module_id=5 where men_id=808
	update m_men set men_cid=801,men_sot=6,men_nam='m_dpath',men_act=0,men_view=1,module_id=5 where men_id=802
	update m_men set men_cid=801,men_sot=7,men_nam='m_emp_anl',men_act=1,men_view=1,module_id=5 where men_id=2027
	update m_men set men_cid=801,men_sot=8,men_nam='m_empcat',men_act=1,men_view=1,module_id=5 where men_id=810
	update m_men set men_cid=801,men_sot=9,men_nam='m_emp_sub',men_act=1,men_view=1,module_id=5 where men_id=811
	update m_men set men_cid=801,men_sot=10,men_nam='m_emppro',men_act=1,men_view=1,module_id=5 where men_id=809
	update m_men set men_cid=801,men_sot=11,men_nam='rosemp',men_act=1,men_view=1,module_id=5 where men_id=2028
	update m_men set men_cid=801,men_sot=12,men_nam='m_salary',men_act=1,men_view=1,module_id=5 where men_id=814
	update m_men set men_cid=801,men_sot=13,men_nam='m_inoutcat',men_act=1,men_view=1,module_id=5 where men_id=815
	update m_men set men_cid=801,men_sot=14,men_nam='m_loan',men_act=1,men_view=1,module_id=5 where men_id=807
	update m_men set men_cid=801,men_sot=15,men_nam='m_hr_termres',men_act=1,men_view=1,module_id=5 where men_id=2062
--Transaction
update m_men set men_cid=19,men_sot=5,men_nam=null,men_act=1,men_view=1 where men_id=901
	update m_men set men_cid=901,men_sot=1,men_nam='m_holi',men_act=1,men_view=1 where men_id=904
	update m_men set men_cid=901,men_sot=1,men_nam='t_impatt',men_act=2,men_view=1 where men_id=902
	update m_men set men_cid=901,men_sot=1,men_nam='t_inout',men_act=3,men_view=1 where men_id=911
	update m_men set men_cid=901,men_sot=1,men_nam='t_inout_multi',men_act=4,men_view=1 where men_id=2074
	update m_men set men_cid=901,men_sot=1,men_nam='t_inoutapp',men_act=5,men_view=1 where men_id=915
	update m_men set men_cid=901,men_sot=1,men_nam='m_abs',men_act=6,men_view=1 where men_id=907
	update m_men set men_cid=901,men_sot=1,men_nam='m_anl',men_act=7,men_view=1 where men_id=906
	update m_men set men_cid=901,men_sot=1,men_nam='m_bonus',men_act=8,men_view=1 where men_id=903
	update m_men set men_cid=901,men_sot=1,men_nam='t_adv',men_act=9,men_view=1 where men_id=905
	update m_men set men_cid=901,men_sot=1,men_nam='t_adv_multi',men_act=10,men_view=1 where men_id=2073
	update m_men set men_cid=901,men_sot=1,men_nam='t_mdptot',men_act=11,men_view=1 where men_id=913
	update m_men set men_cid=901,men_sot=1,men_nam='t_ddptot',men_act=12,men_view=1 where men_id=914
	update m_men set men_cid=901,men_sot=1,men_nam='t_nitot',men_act=13,men_view=1 where men_id=916
	update m_men set men_cid=901,men_sot=1,men_nam='t_nitapp',men_act=14,men_view=1 where men_id=915
	update m_men set men_cid=901,men_sot=1,men_nam='t_loan',men_act=15,men_view=1 where men_id=908
	update m_men set men_cid=901,men_sot=1,men_nam='t_rec_loan',men_act=16,men_view=1 where men_id=912
	update m_men set men_cid=901,men_sot=1,men_nam='t_employeesalary',men_act=17,men_view=1 where men_id=910



--Production
--Setup
update m_men set men_cid=1,men_sot=11,men_nam=null,men_ali='Production',men_act=1,men_view=1,module_id=6 where men_id=601
	update m_men set men_cid=601,men_sot=1,men_nam='m_receipe',men_act=1,men_view=1,module_id=6 where men_id=602
	update m_men set men_cid=601,men_sot=2,men_nam='m_stdbatqty',men_act=1,men_view=1,module_id=6 where men_id=603
	update m_men set men_cid=601,men_sot=2,men_nam='m_chlbk',men_act=1,men_view=1,module_id=6 where men_id=604
--Transaction
update m_men set men_cid=19,men_sot=6,men_nam=null,men_act=1,men_view=1,module_id=6 where men_id=2023
	update m_men set men_cid=2023,men_sot=1,men_nam='t_iss',men_act=1,men_view=1,module_id=6 where men_id=502
	update m_men set men_cid=2023,men_sot=1,men_nam='t_fg',men_act=1,men_view=1,module_id=6 where men_id=503
--Report


--Change Password
update m_men set men_cid=1,men_sot=12,men_nam='m_c_pwd',men_act=1,men_view=1,module_id=11 where men_id=2008
--Backup
update m_men set men_cid=1,men_sot=13,men_nam='m_backup',men_act=1,men_view=1,module_id=11 where men_id=82













