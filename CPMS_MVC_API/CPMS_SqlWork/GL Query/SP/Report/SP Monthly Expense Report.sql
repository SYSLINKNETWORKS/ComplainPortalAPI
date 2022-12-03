USE meiji_rusk
go
--exec sp_rpt_exp  '01','01'

ALTER proc sp_rpt_exp(@com_id char(2),@m_yr_id char(2))
as
select 
	t_mvch.com_id,t_mvch.br_id,mvch_tax, t_dvch.acc_no,gl_m_acc.acc_id,gl_m_acc.acc_nam,controlaccount.acc_id as [controlaccountid],controlaccount.acc_nam as [Controlaccount],(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) as [YearStart],(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) as [YearEnd],
	t_mvch.cur_id,cur_snm,
	case when t_mvch.mvch_chqdat between '07/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '07/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FJul],
	case when t_mvch.mvch_chqdat between '08/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '08/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FAug],
	case when t_mvch.mvch_chqdat between '09/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '09/30/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FSept],
	case when t_mvch.mvch_chqdat between '10/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '10/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FOct],
	case when t_mvch.mvch_chqdat between '11/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '11/30/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FNov],
	case when t_mvch.mvch_chqdat between '12/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '12/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FDec],
	case when t_mvch.mvch_chqdat between '01/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '01/31/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FJan],
	case when t_mvch.mvch_chqdat between '02/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and DateAdd(day, -1,'03/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id)) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FFeb],
	case when t_mvch.mvch_chqdat between '03/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '03/31/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FMar],
	case when t_mvch.mvch_chqdat between '04/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '04/30/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FApr],
	case when t_mvch.mvch_chqdat between '05/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '05/31/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FMay],
	case when t_mvch.mvch_chqdat between '06/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '06/30/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_famt-dvch_cr_famt),0) else 0 end as [FJun],
	
	--Local Currency
	case when t_mvch.mvch_chqdat between '07/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '07/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jul],
	case when t_mvch.mvch_chqdat between '08/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '08/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Aug],
	case when t_mvch.mvch_chqdat between '09/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '09/30/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Sept],
	case when t_mvch.mvch_chqdat between '10/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '10/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Oct],
	case when t_mvch.mvch_chqdat between '11/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '11/30/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Nov],
	case when t_mvch.mvch_chqdat between '12/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '12/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Dec],	
	case when t_mvch.mvch_chqdat between '01/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '01/31/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jan],
	case when t_mvch.mvch_chqdat between '02/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and DateAdd(day, -1,'03/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id)) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Feb],
	case when t_mvch.mvch_chqdat between '03/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '03/31/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Mar],
	case when t_mvch.mvch_chqdat between '04/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '04/30/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Apr],
	case when t_mvch.mvch_chqdat between '05/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '05/31/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [May],
	case when t_mvch.mvch_chqdat between '06/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '06/30/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then isnull(sum(dvch_dr_amt-dvch_cr_amt),0) else 0 end as [Jun],
	
	--Tag
	case when t_mvch.mvch_chqdat between '07/01/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) and '12/31/'+(select yr_str_yy from gl_m_yr where yr_id=@m_yr_id) then 0  when t_mvch.mvch_chqdat between '01/01/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) and '06/30/'+(select yr_end_yy from gl_m_yr where yr_id=@m_yr_id) then 1 end as [TAG]
	
	from t_mvch
	--Join with Detail Voucher
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	--Join with COF
	inner join gl_m_acc 
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	--Join with COF Control
	inner join gl_m_Acc controlaccount
	on gl_m_acc.com_id=controlaccount.com_id
	and gl_m_acc.acc_cid=controlaccount.acc_id
	--Left Join with Currency
	left join m_cur
	on t_mvch.cur_id=m_cur.cur_id
where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id
group by t_mvch.com_id,t_mvch.br_id,mvch_tax,t_dvch.acc_no,gl_m_acc.acc_id,gl_m_acc.acc_nam,controlaccount.acc_id,controlaccount.acc_nam,t_mvch.mvch_chqdat,t_mvch.cur_id,cur_snm

