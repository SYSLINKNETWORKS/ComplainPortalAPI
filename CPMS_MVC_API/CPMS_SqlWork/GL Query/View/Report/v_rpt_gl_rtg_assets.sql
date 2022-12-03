--select * from v_rpt_bl_assets

alter view v_rpt_bl_assets
as
--Fixed Assets
	select com_id,br_id,yr_id,t_dvch.acc_id,'Tengible Fixed Assets (at cost)' as [acc_nam],'Assets' as [acc_mnam],'FA' as [Tag],3 as [MTag],2 as [GMTAG],
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
	left(gl_m_acc.acc_cid,8) in ('03001001','03001003')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id
union
--Accumulated Depriciation
	select com_id,br_id,yr_id,t_dvch.acc_id,'Less: Accumulated Depreciation' as [acc_nam],'Assets' as [acc_mnam],'AD' as [Tag],3 as [MTag],2 as [GMTAG],
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
	left(gl_m_acc.acc_cid,8) in ('03001002','03001004')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id
union
--Long Term Deposits
	select com_id,br_id,yr_id,t_dvch.acc_id,'Long Term Deposits' as [acc_nam],'Assets' as [acc_mnam],'LTD' as [Tag],4 as [MTag],2 as [GMTAG],
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
--Long Term Inventments
	select com_id,br_id,yr_id,t_dvch.acc_id,'Long Term Inventments' as [acc_nam],'Assets' as [acc_mnam],'LTI' as [Tag],5 as [MTag],2 as [GMTAG],
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
--Trade Debtors
	select com_id,br_id,yr_id,t_dvch.acc_id,'Trade Debtors' as [acc_nam],'Current Assets' as [acc_mnam],'TDR' as [Tag],6 as [MTag],2 as [GMTAG],
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
--Deposites, Prepayments, & O/Rec.
	select com_id,br_id,yr_id,t_dvch.acc_id,'Deposites, Prepayments, & O/Rec.' as [acc_nam],'Current Assets' as [acc_mnam],'DPOR' as [Tag],6 as [MTag],2 as [GMTAG],
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
UNION
--Cash and Bank Balances
	select com_id,br_id,yr_id,t_dvch.acc_id,'Cash and Bank Balances' as [acc_nam],'Current Assets' as [acc_mnam],'CBB' as [Tag],6 as [MTag],2 as [GMTAG],
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
	left(gl_m_acc.acc_cid,8) in ('03002003')
	group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id