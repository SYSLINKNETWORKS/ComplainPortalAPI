USE MFI
GO
alter proc sp_bk_con(@com_id char(2),@br_id char(3),@m_yr_id char(2),@dt1 datetime,@dt2 datetime)
as
begin
	--As per Ledger
	select t_dvch.acc_id as [Account],bk_nam as [Bank],t_mvch.cur_id,cur_snm,'' as mvch_pto,'' as [dvch_nar],sum(dvch_dr_famt-dvch_cr_famt) as [FBalance],sum(dvch_dr_amt-dvch_cr_amt) as [Balance],'As Per Ledger' as [Type],3 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.yr_id=t_dvch.yr_id and  t_mvch.mvch_id=t_dvch.mvch_id and t_mvch.typ_id=t_dvch.typ_id left join m_cur on t_mvch.cur_id=m_cur.cur_id inner join gl_m_bk on t_dvch.acc_id=gl_m_bk.acc_id where t_dvch.acc_id in (select acc_id from gl_m_bk) and t_mvch.mvch_dt between @dt1 and @dt2 and t_mvch.yr_id=@m_yr_id group by t_dvch.acc_id,t_mvch.cur_id,cur_snm,bk_nam
	union all
	--Paid & Un-Cleared Chq
	select t_dvch.acc_id as [Account],bk_nam as [Bank],t_mvch.cur_id,cur_snm,mvch_pto,dvch_nar,dvch_dr_famt-dvch_cr_famt as [FBalance],dvch_dr_amt-dvch_cr_amt as [Balance],'Unpresented Payments' as [Type], 4 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.yr_id=t_dvch.yr_id and  t_mvch.mvch_id=t_dvch.mvch_id and t_mvch.typ_id=t_dvch.typ_id left join m_cur on t_mvch.cur_id=m_cur.cur_id inner join gl_m_bk on t_dvch.acc_id=gl_m_bk.acc_id where t_dvch.acc_id in (select acc_id from gl_m_bk) and t_mvch.typ_id ='03' and t_mvch.mvch_dt between @dt1 and @dt2 and t_mvch.yr_id=@m_yr_id and mvch_chqst=0 
	union all
	--Received & Un-Cleared CHq
	select t_dvch.acc_id as [Account],bk_nam as [Bank],t_mvch.cur_id,cur_snm,mvch_pto,dvch_nar,dvch_dr_famt-dvch_cr_famt as [FBalance],dvch_dr_amt-dvch_cr_amt as [Balance],'Unpresented Deposits' as [Type], 5 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.yr_id=t_dvch.yr_id and  t_mvch.mvch_id=t_dvch.mvch_id and t_mvch.typ_id=t_dvch.typ_id left join m_cur on t_mvch.cur_id=m_cur.cur_id inner join gl_m_bk on t_dvch.acc_id=gl_m_bk.acc_id where t_dvch.acc_id in (select acc_id from gl_m_bk) and t_mvch.typ_id ='04' and t_mvch.mvch_dt between @dt1 and @dt2 and t_mvch.yr_id=@m_yr_id and mvch_chqst=0
	union all
	--Service Charges CHq
	select t_dvch.acc_id as [Account],bk_nam as [Bank],t_mvch.cur_id,cur_snm,mvch_pto,dvch_nar,dvch_dr_famt-dvch_cr_famt as [FBalance],dvch_dr_amt-dvch_cr_amt as [Balance],'Bank Charges' as [Type], 6 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.yr_id=t_dvch.yr_id and  t_mvch.mvch_id=t_dvch.mvch_id and t_mvch.typ_id=t_dvch.typ_id left join m_cur on t_mvch.cur_id=m_cur.cur_id inner join gl_m_bk on t_dvch.acc_id=gl_m_bk.acc_id where t_dvch.acc_id in (select acc_id from gl_m_bk) and t_mvch.typ_id ='05' and t_mvch.mvch_dt between @dt1 and @dt2 and t_mvch.yr_id=@m_yr_id and mvch_chqst=0
end

--exec sp_bk_con '01','01','01','07/01/2012','07/31/2012'
