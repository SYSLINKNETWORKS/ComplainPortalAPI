--alter view v_rpt_bl_capital_sum
--as
--select 
--	 com_id, br_id, yr_id,acc_id, acc_nam, acc_mnam, tag, mtag, gmtag,
--	isnull(sum(v_rpt_bl_capital.jul),0) as [Jul],
--	isnull(sum(v_rpt_bl_capital.aug),0) as [Aug],
--	isnull(sum(v_rpt_bl_capital.sept),0) as [Sept],
--	isnull(sum(v_rpt_bl_capital.Oct),0) as [Oct],
--	isnull(sum(v_rpt_bl_capital.Nov),0) as [Nov],
--	isnull(sum(v_rpt_bl_capital.Dec),0) as [Dec],
--	isnull(sum(v_rpt_bl_capital.Jan),0) as [Jan],
--	isnull(sum(v_rpt_bl_capital.Feb),0) as [Feb],
--	isnull(sum(v_rpt_bl_capital.Mar),0) as [Mar],
--	isnull(sum(v_rpt_bl_capital.Apr),0) as [Apr],
--	isnull(sum(v_rpt_bl_capital.May),0) as [May],
--	isnull(sum(v_rpt_bl_capital.Jun),0) as [Jun]
--	from v_rpt_bl_capital
--	group by com_id,br_id,yr_id,acc_id,acc_nam,acc_mnam,tag,mtag,gmtag

--select sum(jul) from v_rpt_bl_capital_open where mtag=2 and gmtag=1
--select sum(jul) from v_rpt_bl_capital_sum where mtag=2 and gmtag=1



	select 
		v_rpt_bl_capital_open.com_id,v_rpt_bl_capital_open.br_id,v_rpt_bl_capital_open.yr_id,v_rpt_bl_capital_open.acc_nam, v_rpt_bl_capital_open.acc_mnam, v_rpt_bl_capital_open.tag, v_rpt_bl_capital_open.mtag, v_rpt_bl_capital_open.gmtag,
		sum(v_rpt_bl_capital_open.jul+isnull(v_rpt_bl_capital_sum.jul,0)) as [Jul],
		sum(v_rpt_bl_capital_open.aug+isnull(v_rpt_bl_capital_sum.aug,0)) as [Aug],
		sum(v_rpt_bl_capital_open.sept+isnull(v_rpt_bl_capital_sum.sept,0)) as [Sept],
		sum(v_rpt_bl_capital_open.oct+isnull(v_rpt_bl_capital_sum.oct,0)) as [Oct],
		sum(v_rpt_bl_capital_open.nov+isnull(v_rpt_bl_capital_sum.nov,0)) as [Nov],
		sum(v_rpt_bl_capital_open.dec+isnull(v_rpt_bl_capital_sum.dec,0)) as [Dec],
		sum(v_rpt_bl_capital_open.jan+isnull(v_rpt_bl_capital_sum.jan,0)) as [Jan],
		sum(v_rpt_bl_capital_open.feb+isnull(v_rpt_bl_capital_sum.feb,0)) as [Feb],
		sum(v_rpt_bl_capital_open.mar+isnull(v_rpt_bl_capital_sum.mar,0)) as [Mar],
		sum(v_rpt_bl_capital_open.apr+isnull(v_rpt_bl_capital_sum.apr,0)) as [Apr],
		sum(v_rpt_bl_capital_open.may+isnull(v_rpt_bl_capital_sum.may,0)) as [May],
		sum(v_rpt_bl_capital_open.jun+isnull(v_rpt_bl_capital_sum.jun,0)) as [Jun]
		from v_rpt_bl_capital_open
		left join v_rpt_bl_capital_sum
		on v_rpt_bl_capital_open.com_id=v_rpt_bl_capital_sum.com_id
		and v_rpt_bl_capital_open.br_id=v_rpt_bl_capital_sum.br_id
		and v_rpt_bl_capital_open.yr_id=v_rpt_bl_capital_sum.yr_id
		and v_rpt_bl_capital_open.acc_id=v_rpt_bl_capital_sum.acc_id
--where v_rpt_bl_capital_open.mtag=2 and v_rpt_bl_capital_open.gmtag=1
	group by 		v_rpt_bl_capital_open.com_id,v_rpt_bl_capital_open.br_id,v_rpt_bl_capital_open.yr_id,v_rpt_bl_capital_open.acc_nam, v_rpt_bl_capital_open.acc_mnam, v_rpt_bl_capital_open.tag, v_rpt_bl_capital_open.mtag, v_rpt_bl_capital_open.gmtag
	
