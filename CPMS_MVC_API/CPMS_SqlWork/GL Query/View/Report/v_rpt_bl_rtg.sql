--select * from v_rpt_bl

alter view v_rpt_bl
as
	select com_id,br_id,yr_id,t_dvch.acc_id,acc_nam,
--gl_br_acc.com_id,gl_br_acc.br_id,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,cid.acc_nam as [ControlName],mvch_dt,acc_obal,
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
gl_m_acc.acc_cid in ('01001001','01001002')--,'01001003','02001001001','02002','02003001','02003002','02003003001001001','02003003001001002','02003003001001003','02003003001001004','02003001002','02003003002001','02003003002002','02003003002003','02003003002004','02003003001','02003004','02003005','03001001','03001002','03001003','03001004','03002001','03002002001','03002002001003','03002002002','03002002003','')
group by com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id,acc_nam
