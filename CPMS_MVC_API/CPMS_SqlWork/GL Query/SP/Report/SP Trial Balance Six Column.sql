
USE ZSONS
GO

--exec sp_rpt_tb_six '01/01/2013','06/30/2013','01'
--select * from tb_obal order by acc_nam

----SP General Ledger
alter proc [dbo].[sp_rpt_tb_six] (@dt1 datetime,@dt2 datetime,@yr_id char(2))
as
begin
--Opening Balance
	select 
		t_mvch.com_id,t_mvch.br_id,mvch_tax,t_dvch.acc_no,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam as [controlname],case when sum(dvch_dr_famt-dvch_cr_famt)>=0 then sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [op_dr_famt],case when sum(dvch_dr_famt-dvch_cr_famt)<0 then sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [op_cr_famt],case when sum(dvch_dr_amt-dvch_cr_amt)>=0 then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [op_dr_amt],case when sum(dvch_dr_amt-dvch_cr_amt)<0 then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [op_cr_amt],0 as [dvch_dr_famt],0 as [dvch_cr_famt],0 as [dvch_dr_amt],0 as [dvch_cr_amt],case when sum(dvch_dr_famt - dvch_cr_famt)>=0 then sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [closing_dr_famt],case when sum(dvch_dr_amt - dvch_cr_amt)>=0 then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [closing_dr_amt],case when sum(dvch_dr_famt-dvch_cr_famt)<0 then -sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [closing_cr_famt],case when sum(dvch_dr_amt-dvch_cr_amt)<0 then -sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [closing_cr_amt],t_mvch.cur_id,cur_snm,'O' as [Tag]
		from t_mvch
		--Join with Detail Voucher
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Join with Type ID
		inner join gl_vch_typ
		on t_mvch.typ_id=gl_vch_typ.typ_id
		--Join with account
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id
		and t_dvch.acc_no=gl_m_acc.acc_no
		--Join with account for control account name
		inner join gl_m_acc controlaccount
		on gl_m_acc.com_id=controlaccount.com_id 
		and gl_m_acc.acc_cid=controlaccount.acc_id
		--Left join m_cur
		left join m_cur
		on t_mvch.cur_id=m_cur.cur_id
		--Where Clause 
		where  t_mvch.yr_id=@yr_id
		and mvch_app='Y'
		and t_mvch.typ_id='06'
group by t_mvch.com_id,t_mvch.br_id,mvch_tax,t_dvch.acc_no,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam,t_mvch.cur_id,cur_snm
union all
	select 
		t_mvch.com_id,t_mvch.br_id,mvch_tax,t_dvch.acc_no,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam as [controlname],case when sum(dvch_dr_famt-dvch_cr_famt)>=0 then sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [op_dr_famt],case when sum(dvch_dr_famt-dvch_cr_famt)<0 then sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [op_cr_famt],case when sum(dvch_dr_amt-dvch_cr_amt)>=0 then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [op_dr_amt],case when sum(dvch_dr_amt-dvch_cr_amt)<0 then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [op_cr_amt],0 as [dvch_dr_famt],0 as [dvch_cr_famt],0 as [dvch_dr_amt],0 as [dvch_cr_amt],case when sum(dvch_dr_famt - dvch_cr_famt)>=0 then sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [closing_dr_famt],case when sum(dvch_dr_amt - dvch_cr_amt)>=0 then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [closing_dr_amt],case when sum(dvch_dr_famt-dvch_cr_famt)<0 then -sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [closing_cr_famt],case when sum(dvch_dr_amt-dvch_cr_amt)<0 then -sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [closing_cr_amt],t_mvch.cur_id,cur_snm,'O' as [Tag]
		from t_mvch
		--Join with Detail Voucher
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Join with Type ID
		inner join gl_vch_typ
		on t_mvch.typ_id=gl_vch_typ.typ_id
		--Join with account
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id
		and t_dvch.acc_no=gl_m_acc.acc_no
		--Join with account for control account name
		inner join gl_m_acc controlaccount
		on gl_m_acc.com_id=controlaccount.com_id
		and gl_m_acc.acc_cid=controlaccount.acc_id
		--Left Join m_cur
		left join m_cur
		on t_mvch.cur_id=m_cur.cur_id
		--Where Clause 
		where t_mvch.mvch_dt< @dt1 and t_mvch.yr_id=@yr_id
		and mvch_app='Y'
		and t_mvch.typ_id<>'06'
group by t_mvch.com_id,t_mvch.br_id,mvch_tax,t_dvch.acc_no,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam,t_mvch.cur_id,cur_snm
union all
--Transactions
	select 
		t_mvch.com_id,t_mvch.br_id,mvch_tax,t_dvch.acc_no,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam,0 as [op_dr_famt],0 as [op_cr_famt],0 as [op_dr_amt],0 as [op_cr_amt],sum(dvch_dr_famt) as [dvch_dr_famt],sum(dvch_cr_famt) as [dvch_cr_famt],sum(dvch_dr_amt) as [dvch_dr_amt],sum(dvch_cr_amt) as [dvch_cr_amt],case when sum(dvch_dr_famt - dvch_cr_famt)>=0 then sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [closing_dr_famt],case when sum(dvch_dr_amt - dvch_cr_amt)>=0 then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [closing_dr_amt],case when sum(dvch_dr_famt-dvch_cr_famt)<0 then -sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [closing_cr_famt],case when sum(dvch_dr_amt-dvch_cr_amt)<0 then -sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [closing_cr_amt],t_mvch.cur_id,cur_snm,'T' as [Tag]
		from t_mvch
		--Join with Detail Voucher
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Join with Type ID
		inner join gl_vch_typ
		on t_mvch.typ_id=gl_vch_typ.typ_id
		--Join with account
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id
		and t_dvch.acc_no=gl_m_acc.acc_no
		--Join with account for control account name
		inner join gl_m_acc controlaccount
		on gl_m_acc.com_id=controlaccount.com_id		
		and gl_m_acc.acc_cid=controlaccount.acc_id
		--Left join m_cur
		left join m_cur
		on t_mvch.cur_id=m_cur.cur_id
		--Where Clause 
		where t_mvch.mvch_dt between @dt1 and @dt2 and t_mvch.yr_id=@yr_id
		and mvch_app='Y'
		and t_mvch.typ_id<>'06'
group by t_mvch.com_id,t_mvch.br_id,mvch_tax,t_dvch.acc_no,gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam,t_mvch.cur_id,cur_snm
end
GO

