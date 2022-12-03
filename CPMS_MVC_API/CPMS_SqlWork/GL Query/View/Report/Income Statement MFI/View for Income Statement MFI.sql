USE MFI
GO

alter view v_rpt_ic
as
--Revenue
select 
	com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id,gl_m_acc.acc_nam,ca.acc_id as [CAID],ca.acc_nam as [CANAME],mca.acc_id as [MCAID],mca.acc_nam as [MCANAME],dvch_dr_amt-dvch_cr_amt as [amount],1 as [SNO]
	from t_dvch
	--Join with COF
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	--Join with Control Account
	inner join gl_m_acc ca
	on gl_m_acc.acc_cid=ca.acc_id
	--Join with Master Control Account
	inner join gl_m_acc mca
	on left(gl_m_acc.acc_cid,2)=mca.acc_id
	where left(t_dvch.acc_id,2)='04'
union all
--Expense
select 
	com_id,br_id,yr_id,mvch_dt,t_dvch.acc_id,gl_m_acc.acc_nam,ca.acc_id as [CAID],ca.acc_nam as [CANAME],mca.acc_id as [MCAID],mca.acc_nam as [MCANAME],dvch_dr_amt-dvch_cr_amt as [amount],2 as [SNO]
	from t_dvch
	--Join with COF
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	--Join with Control Account
	inner join gl_m_acc ca
	on left(gl_m_acc.acc_cid,5)=ca.acc_id
	--Join with Master Control Account
	inner join gl_m_acc mca
	on left(gl_m_acc.acc_cid,5)=mca.acc_id
	where left(t_dvch.acc_id,2)='05'
