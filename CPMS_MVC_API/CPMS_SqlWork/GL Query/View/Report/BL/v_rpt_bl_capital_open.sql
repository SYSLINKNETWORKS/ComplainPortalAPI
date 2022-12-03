--select sum(dvch_dr_amt-dvch_cr_amt) from t_dvch where left(acc_id,2)in ('05')
--select sum(acc_obal) from gl_br_acc where left(acc_id,2) in ('05')
--select * from v_rpt_bl_capital_open
--exec sp_rpt_bl '01','01'

alter proc sp_rpt_bl (@com_id char(2),@br_id char(2))
as
--Delete the empty table
delete from tmp_bl_rtg
--select * from tmp_bl_rtg
--Opening Partners Capital
insert into tmp_bl_rtg 
	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Partners Capital' as [acc_nam],'Capital and Liablities' as [acc_mnam],'C' as [Tag],1 as [MTag],1 AS [GMTAG],'T' as [FTag],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where gl_m_acc.acc_cid in ('01001001','01001002')
		and com_id=@com_id and br_id=@br_id

	 
union
--Transcation Partners Capital
select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,'Partners Capital' as [acc_nam],'Capital and Liablities' as [acc_mnam],'C' as [Tag],1 as [MTag],1 AS [GMTAG],'T' as [FTag],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jul],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Aug],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Sept],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Oct],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Nov],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Dec],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jan],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Feb],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Mar],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Apr],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [May],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jun]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.yr_id=t_dvch.yr_id
	and t_mvch.mvch_id=t_dvch.mvch_id
	and t_mvch.typ_id=t_dvch.typ_id
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	
	where 
	gl_m_acc.acc_cid in ('01001001','01001002') and mvch_app='Y'
	and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id
	group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,t_mvch.mvch_dt
	 
union
--Opening Profit / Loss
	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Accumulated Profit/Loss' as [acc_nam],'Capital and Liablities' as [acc_mnam],'APL' as [Tag],1 as [MTag],1 AS [GMTAG],'F' as [FTag],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where left(gl_m_acc.acc_id,2) in ('04','05')
		and com_id=@com_id and br_id=@br_id

	 
union
--Transcation Profit/ Loss
select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,'Accumulated Profit/Loss' as [acc_nam],'Capital and Liablities' as [acc_mnam],'APL' as [Tag],1 as [MTag],1 AS [GMTAG],'F' as [FTag],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jul],
		case when t_mvch.mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Aug],
		case when t_mvch.mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Sept],
		case when t_mvch.mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Oct],
		case when t_mvch.mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Nov],
		case when t_mvch.mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Dec],
		case when t_mvch.mvch_dt 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jan],
		case when t_mvch.mvch_dt 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Feb],
		case when t_mvch.mvch_dt 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Mar],
		case when t_mvch.mvch_dt 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Apr],
		case when t_mvch.mvch_dt 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [May],
		case when t_mvch.mvch_dt 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jun]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.yr_id=t_dvch.yr_id
	and t_mvch.mvch_id=t_dvch.mvch_id
	and t_mvch.typ_id=t_dvch.typ_id
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	
	where 
	left(gl_m_acc.acc_id,2) in ('04','05') and mvch_app='Y'
	and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id
	group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,t_mvch.mvch_dt
	 
----	 
union
--Opening Long Term Liablities 

	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Long Term Liabilities' as [acc_nam],'Capital and Liablities' as [acc_mnam],'LTL' as [Tag],2 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where 	left(gl_m_acc.acc_cid,5) in ('02001')
	and com_id=@com_id and br_id=@br_id

union
--Transaction Long Term Liablities
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,'Long Term Liabilities' as [acc_nam],'Capital and Liablities' as [acc_mnam],'LTL' as [Tag],2 as [MTag],1 AS [GMTAG],'F' as [FTag],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jul],
		case when t_mvch.mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Aug],
		case when t_mvch.mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Sept],
		case when t_mvch.mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Oct],
		case when t_mvch.mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Nov],
		case when t_mvch.mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Dec],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jan],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Feb],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Mar],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Apr],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [May],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jun]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.yr_id=t_dvch.yr_id
	and t_mvch.mvch_id=t_dvch.mvch_id
	and t_mvch.typ_id=t_dvch.typ_id
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	
	where left(gl_m_acc.acc_cid,5) in ('02001') and mvch_app='Y'
	and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id

	group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,t_mvch.mvch_dt
union
--Opening Long Term Deposits

	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Long Term Deposits' as [acc_nam],'Capital and Liabilities' as [acc_mnam],'LTD' as [Tag],3 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where 	left(gl_m_acc.acc_cid,5) in ('02002')
	and com_id=@com_id and br_id=@br_id

union
--Transaction Long Term Deposits
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,'Long Term Deposits' as [acc_nam],'Capital and Liabilities' as [acc_mnam],'LTD' as [Tag],3 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jul],
		case when t_mvch.mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Aug],
		case when t_mvch.mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Sept],
		case when t_mvch.mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Oct],
		case when t_mvch.mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Nov],
		case when t_mvch.mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Dec],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jan],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Feb],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Mar],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Apr],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [May],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jun]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.yr_id=t_dvch.yr_id
	and t_mvch.mvch_id=t_dvch.mvch_id
	and t_mvch.typ_id=t_dvch.typ_id
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	
	where 		left(gl_m_acc.acc_cid,5) in ('02002') and mvch_app='Y'
	and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id

	group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,t_mvch.mvch_dt
union 
--Opening Current Portion of Finance Lease

	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Current Portion of Finance Lease' as [acc_nam],'Current Liabilities' as [acc_mnam],'CPFL' as [Tag],4 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where 	left(gl_m_acc.acc_cid,8) in ('02003001','02003002')
	and com_id=@com_id and br_id=@br_id

union
--Transaction Current Portion of Finance Lease
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,'Current Portion of Finance Lease' as [acc_nam],'Current Liabilities' as [acc_mnam],'CPFL' as [Tag],4 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jul],
		case when t_mvch.mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Aug],
		case when t_mvch.mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Sept],
		case when t_mvch.mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Oct],
		case when t_mvch.mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Nov],
		case when t_mvch.mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Dec],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jan],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Feb],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Mar],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Apr],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [May],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jun]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.yr_id=t_dvch.yr_id
	and t_mvch.mvch_id=t_dvch.mvch_id
	and t_mvch.typ_id=t_dvch.typ_id
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	
	where 		left(gl_m_acc.acc_cid,8) in ('02003001','02003002') and mvch_app='Y'
	and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id

	group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,t_mvch.mvch_dt
	 		 	 

	 
union
--Opening Current Liabilities

	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Creditors, A/Exp. & O/Liab.' as [acc_nam],'Current Liabilities' as [acc_mnam],'CL' as [Tag],4 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where 	left(gl_m_acc.acc_cid,8) in ('02003003','02003004')
	and com_id=@com_id and br_id=@br_id

union
--Transaction Current Liabilities
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,'Creditors, A/Exp. & O/Liab.' as [acc_nam],'Current Liabilities' as [acc_mnam],'CL' as [Tag],4 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jul],
		case when t_mvch.mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Aug],
		case when t_mvch.mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Sept],
		case when t_mvch.mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Oct],
		case when t_mvch.mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Nov],
		case when t_mvch.mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Dec],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jan],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Feb],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Mar],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Apr],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [May],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jun]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.yr_id=t_dvch.yr_id
	and t_mvch.mvch_id=t_dvch.mvch_id
	and t_mvch.typ_id=t_dvch.typ_id
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	
	where 		left(gl_m_acc.acc_cid,8) in ('02003003','02003004') and mvch_app='Y'
	and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id

	group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,t_mvch.mvch_dt
	 	 
union
--Opening Taxation

	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Taxation' as [acc_nam],'Current Liabilities' as [acc_mnam],'TAX' as [Tag],4 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where 	left(gl_m_acc.acc_cid,8) in ('02003005')
	and com_id=@com_id and br_id=@br_id

union	 
-- Transaction Taxation
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,'Taxation' as [acc_nam],'Current Liabilities' as [acc_mnam],'TAX' as [Tag],4 as [MTag],1 as [GMTAG],'F' as [FTag],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jul],
		case when t_mvch.mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Aug],
		case when t_mvch.mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Sept],
		case when t_mvch.mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Oct],
		case when t_mvch.mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Nov],
		case when t_mvch.mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Dec],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jan],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Feb],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Mar],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Apr],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [May],
		case when t_mvch.mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [Jun]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.yr_id=t_dvch.yr_id
	and t_mvch.mvch_id=t_dvch.mvch_id
	and t_mvch.typ_id=t_dvch.typ_id
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id	
	where left(gl_m_acc.acc_cid,8) in ('02003005') and mvch_app='Y'
	and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id
	group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,t_mvch.mvch_dt

-----------------------------------------------------------------------------------------------------------
union
--Opening Fixed Assets
	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Tengible Fixed Assets (at cost)' as [acc_nam],'Assets' as [acc_mnam],'FA' as [Tag],5 as [MTag],2 as [GMTAG],'T' as [FTag],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where gl_m_acc.acc_cid in ('03001001','03001003')
		and com_id=@com_id and br_id=@br_id
union
--Transaction Fixed Assets
	select com_id,br_id,yr_id,t_dvch.acc_id,'Tengible Fixed Assets (at cost)' as [acc_nam],'Assets' as [acc_mnam],'FA' as [Tag],5 as [MTag],2 as [GMTAG],'T' as [FTag],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jul],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Aug],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Sept],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Oct],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Nov],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Dec],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jan],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Feb],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Mar],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Apr],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [May],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jun]
	from t_dvch
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	where 
	left(gl_m_acc.acc_cid,8) in ('03001001','03001003')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id
union
--Opening Accumulated Depriciation
	select com_id,br_id,yr_id,gl_br_acc.acc_id,'Less: Accumulated Depreciation' as [acc_nam],'Assets' as [acc_mnam],'AD' as [Tag],5 as [MTag],2 as [GMTAG],'T' as [FTag],
case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where gl_m_acc.acc_cid in ('03001002','03001004')
		and com_id=@com_id and br_id=@br_id
union 
--Transaction Accumulated Depriciation
	select com_id,br_id,yr_id,t_dvch.acc_id,'Less: Accumulated Depreciation' as [acc_nam],'Assets' as [acc_mnam],'AD' as [Tag],5 as [MTag],2 as [GMTAG],'T' as [FTag],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jul],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Aug],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Sept],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Oct],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Nov],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Dec],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jan],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Feb],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Mar],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Apr],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [May],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jun]
	from t_dvch
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	where 
	left(gl_m_acc.acc_cid,8) in ('03001002','03001004')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id
union

--Opening Long Term Deposits
	select com_id,br_id,yr_id,gl_m_acc.acc_id,'Long Term Deposits' as [acc_nam],'Assets' as [acc_mnam],'LTD' as [Tag],6 as [MTag],2 as [GMTAG],'T' as [FTag],
case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where gl_m_acc.acc_cid in ('')
		and com_id=@com_id and br_id=@br_id

union
--Transaction Long Term Deposits
	select com_id,br_id,yr_id,t_dvch.acc_id,'Long Term Deposits' as [acc_nam],'Assets' as [acc_mnam],'LTD' as [Tag],6 as [MTag],2 as [GMTAG],'T' as [FTag],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jul],
		case when mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Aug],
		case when mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Sept],
		case when mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Oct],
		case when mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Nov],
		case when mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Dec],
		case when mvch_dt 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jan],
		case when mvch_dt 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Feb],
		case when mvch_dt 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Mar],
		case when mvch_dt 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Apr],
		case when mvch_dt 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [May],
		case when mvch_dt 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jun]
	from t_dvch
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	where 
	left(gl_m_acc.acc_cid,8) in ('')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id
union
--Opening Long Term Inventments
	select com_id,br_id,yr_id,gl_m_acc.acc_id,'Long Term Inventments' as [acc_nam],'Assets' as [acc_mnam],'LTI' as [Tag],7 as [MTag],2 as [GMTAG],'T' as [FTag],
case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where gl_m_acc.acc_cid in ('')
		and com_id=@com_id and br_id=@br_id
union
--Transaction Long Term Inventments
	select com_id,br_id,yr_id,t_dvch.acc_id,'Long Term Inventments' as [acc_nam],'Assets' as [acc_mnam],'LTI' as [Tag],7 as [MTag],2 as [GMTAG],'T' as [FTag],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jul],
		case when mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Aug],
		case when mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Sept],
		case when mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Oct],
		case when mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Nov],
		case when mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Dec],
		case when mvch_dt 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jan],
		case when mvch_dt 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Feb],
		case when mvch_dt 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Mar],
		case when mvch_dt 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Apr],
		case when mvch_dt 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [May],
		case when mvch_dt 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jun]
	from t_dvch
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	where 
	left(gl_m_acc.acc_cid,8) in ('')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id
union
--Opening Trade Debtors
	select com_id,br_id,yr_id,gl_m_acc.acc_id,'Trade Debtors' as [acc_nam],'Current Assets' as [acc_mnam],'TDR' as [Tag],8 as [MTag],2 as [GMTAG],'F' as [FTag],
case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where gl_m_acc.acc_cid in ('03002001')
		and com_id=@com_id and br_id=@br_id

union
--Transaction Trade Debtors
	select com_id,br_id,yr_id,t_dvch.acc_id,'Trade Debtors' as [acc_nam],'Current Assets' as [acc_mnam],'TDR' as [Tag],8 as [MTag],2 as [GMTAG],'F' as [FTag],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jul],
		case when mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Aug],
		case when mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Sept],
		case when mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Oct],
		case when mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Nov],
		case when mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Dec],
		case when mvch_dt 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jan],
		case when mvch_dt 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Feb],
		case when mvch_dt 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Mar],
		case when mvch_dt 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Apr],
		case when mvch_dt 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [May],
		case when mvch_dt 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jun]
	from t_dvch
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	where 
	left(gl_m_acc.acc_cid,8) in ('03002001')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id
union
--Opening Deposites, Prepayments, & O/Rec.
	select com_id,br_id,yr_id,gl_m_acc.acc_id,'Deposites, Prepayments, & O/Rec.' as [acc_nam],'Current Assets' as [acc_mnam],'DPOR' as [Tag],8 as [MTag],2 as [GMTAG],'F' as [FTag],
case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jul],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Aug],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Sept],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Oct],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Nov],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Dec],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jan],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Feb],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Mar],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Apr],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [May],
		case when acc_dat 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then acc_obal else 0 end as [Jun]
	from gl_br_acc
	inner join gl_m_acc
	on gl_br_acc.acc_id=gl_m_acc.acc_id
	where gl_m_acc.acc_cid in ('03002002')
		and com_id=@com_id and br_id=@br_id
union

--Transaction Deposites, Prepayments, & O/Rec.
	select com_id,br_id,yr_id,t_dvch.acc_id,'Deposites, Prepayments, & O/Rec.' as [acc_nam],'Current Assets' as [acc_mnam],'DPOR' as [Tag],8 as [MTag],2 as [GMTAG],'F' as [FTag],
		case when mvch_dt 
			between '07/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '07/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jul],
		case when mvch_dt 
			between '08/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '08/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Aug],
		case when mvch_dt 
			between '09/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '09/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Sept],
		case when mvch_dt 
			between '10/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '10/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Oct],
		case when mvch_dt 
			between '11/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '11/30/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Nov],
		case when mvch_dt 
			between '12/01/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') and '12/31/'+(select yr_str_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Dec],
		case when mvch_dt 
			between '01/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '01/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jan],
		case when mvch_dt 
			between '02/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '02/28/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Feb],
		case when mvch_dt 
			between '03/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '03/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Mar],
		case when mvch_dt 
			between '04/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '04/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Apr],
		case when mvch_dt 
			between '05/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '05/31/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [May],
		case when mvch_dt 
			between '06/01/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') and '06/30/'+(select yr_end_yy from gl_m_yr where yr_ac='Y') then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jun]
	from t_dvch
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	where 
	left(gl_m_acc.acc_cid,8) in ('03002002')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id
-------------------------------------------------------------------------------------------------------------------------------------------------	 
--Selecting the record
	select tmp_bl_rtg.com_id,tmp_bl_rtg.br_id,tmp_bl_rtg.yr_id,acc_nam,acc_mnam,bl_tag,bl_mtag,bl_gmtag,yr_str_yy,yr_end_yy,sum(jul) as [Jul],sum(aug) as [Aug],sum(sept) as [Sept],sum(oct) as [Oct],sum(nov)  as [Nov],sum(dec) as [Dec],sum(jan) as [Jan],sum(feb) as [Feb],sum(mar) as [Mar],sum(apr) as [Apr],sum(may) as [May],sum(jun) as [Jun],bl_ftag,
		case BL_FTag when 'T' then sum(jun) else sum(jul)+sum(aug)+sum(sept)+sum(oct)+sum(nov)+sum(dec)+sum(jan)+sum(feb)+sum(mar)+sum(apr)+sum(may)+sum(jun) end as [Net]  from tmp_bl_rtg
		inner join gl_m_yr
		on tmp_bl_rtg.yr_id=gl_m_yr.yr_id
		group by tmp_bl_rtg.com_id,tmp_bl_rtg.br_id,tmp_bl_rtg.yr_id,acc_nam,acc_mnam,bl_tag,bl_mtag,bl_gmtag,yr_str_yy,yr_end_yy,BL_FTag
		
--select * from tmp_bl_rtg

go
--exec sp_rpt_bl '01','01'
--select sum(dvch_dr_Amt-dvch_cr_amt) from t_dvch  where mvch_dt between '12/01/2011' and '12/31/2011' and left(acc_id,2) in ('04')--,'05')
--select sum(acc_obal) from gl_br_acc
 
