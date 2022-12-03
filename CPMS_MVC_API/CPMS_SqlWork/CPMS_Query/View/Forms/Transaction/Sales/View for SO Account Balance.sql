USE NATHI
GO

alter view v_so_acc_bal
as
--Outstanding of CP,CR,JV
select	
	t_mvch.com_id,t_mvch.yr_id,acc_no,SUM(dvch_dr_amt-dvch_cr_amt) as [Outstanding],0 as [Bankoutstanding],0 as [unrealizechq],0 as [SOAMT]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	where typ_id in ('01','02','05','06') and mvch_can=0 and mvch_del=0	
	group by t_mvch.com_id,t_mvch.yr_id,acc_no
union all
----Bank Outstanding excluding unrealized chqs
--select	
--	t_mvch.com_id,t_mvch.yr_id,acc_no,0 as [Outstanding],SUM(dvch_dr_amt-dvch_cr_amt) as [Bankoutstanding],0 as [unrealizechq],0 as [SOAMT]
--	from t_mvch
--	inner join t_dvch
--	on t_mvch.com_id =t_dvch.com_id 
--	and t_mvch.br_id=t_dvch.br_id
--	and t_mvch.mvch_no=t_dvch.mvch_no 
--	where typ_id in ('03','04')	and mvch_chqst=0 and mvch_can=0 and mvch_del=0
--	group by t_mvch.com_id,t_mvch.yr_id,acc_no
--union all
--Unrealized Chq
select	
	t_mvch.com_id,t_mvch.yr_id,acc_no,0 as [Outstanding],0 as [Bankoutstanding],SUM(dvch_dr_amt-dvch_cr_amt) as [unrealizechq],0 as [SOAMT]
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	where typ_id in ('03','04') and mvch_can=0 and mvch_del=0
	group by t_mvch.com_id,t_mvch.yr_id,acc_no
--union all
----SO AMT
--select	
--	t_mso.com_id,t_mso.m_yr_id,acc_no,0 as [Outstanding],0 as [Bankoutstanding],0 as [unrealizechq],SUM(mso_namt-mso_pamt) as [SOAMT]
--	from t_mso
--	inner join m_cus
--	on t_mso.com_id=m_cus.com_id 
--	and t_mso.cus_id=m_cus.cus_id
--	where mso_soapp =1 and mso_can =0 and t_mso.log_act<>'D'
--	group by t_mso.com_id,t_mso.m_yr_id,acc_no

	
