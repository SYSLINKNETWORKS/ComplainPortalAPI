--select * from v_rpt_pl order by acc_id


alter view v_rpt_pl
as
	select com_id,br_id,yr_id,t_dvch.acc_id,acc_nam,'RevenueExpense' as [Tag],
--gl_br_acc.com_id,gl_br_acc.br_id,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,cid.acc_nam as [ControlName],mvch_dt,acc_obal,
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
gl_m_acc.acc_cid in ((select rev_exp_acc from m_sys ),(select exp_acc from m_sys))
group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id,acc_nam
union
	select com_id,br_id,yr_id,t_dvch.acc_id,acc_nam,'Expense' as [Tag],
--gl_br_acc.com_id,gl_br_acc.br_id,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,cid.acc_nam as [ControlName],mvch_dt,acc_obal,
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
left(gl_m_acc.acc_cid,5) in ('05002','05003','05004')
group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id,acc_nam

--select * from gl_m_acc where acc_id='02003003001001003'
--select * from gl_m_acc where acc_id=(select exp_acc from m_sys)

