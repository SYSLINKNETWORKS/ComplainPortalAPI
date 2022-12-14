
USE zsons
GO
--exec sp_rpt_cb '12/26/2013','06/30/2014','02'


ALTER proc [dbo].[sp_rpt_cb] (@dt1 datetime,@dt2 datetime,@yr_id char(2))
as
declare @acc_len int
--Opening Cash
begin
	set @acc_len=(select len(acc_id) from m_sys inner join gl_m_acc on m_sys.cashmaster_acc=gl_m_acc.acc_no)
	select 
		com_id,br_id,yr_id,typ_id,typ_nam,typ_snm,mvch_id,mvch_dt,'' as [mvch_pto],dvch_nar,mvch_ref,acc_no,acc_id,acc_nam,cur_id,cur_snm,0 as [dvch_dr_famt],0 as [dvch_cr_famt],sum(fbalance) as [FOBalance],0 as [dvch_dr_amt],0 as [dvch_cr_amt],sum(balance) as [OBalance],0 as [FTBalance],sum(fbalance) as [FBalance],0 as [TBalance],sum(balance) as [Balance],tag, 'C' as [MTag], 
		mvch_tax
		from tb_obal	
		where mvch_dt<@dt1
		and left(acc_id,@acc_len)=(select acc_id from m_sys inner join gl_m_acc on m_sys.cashmaster_acc=gl_m_acc.acc_no)
		--and acc_id='01002005004' 
		and yr_id=@yr_id
		--Group By	
		group by com_id,br_id,yr_id,typ_id,typ_nam,typ_snm,mvch_id,mvch_dt,mvch_cb,mvch_ref,dvch_nar,acc_no,acc_id,acc_nam,tag,cur_id,cur_snm,mvch_tax
union all
--Transaction Cash
select 
	t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.typ_id,typ_snm,typ_nam,t_mvch.mvch_id,t_mvch.mvch_dt,mvch_pto,dvch_nar,mvch_ref,t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,t_mvch.cur_id,cur_snm,dvch_dr_famt,dvch_cr_famt,0 as [FOBalance],dvch_dr_amt,dvch_cr_amt,0 as [OBalance],dvch_dr_famt-dvch_cr_famt  as [FTBalance],dvch_dr_famt-dvch_cr_famt  as [FBalance],dvch_dr_amt-dvch_cr_amt  as [TBalance],dvch_dr_amt-dvch_cr_amt  as [Balance],'T' as [Tag],'C' as [MTag],
	mvch_tax
		from t_mvch
		--Inner Join Voucher Details
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Inner Join Voucher Type
		inner join gl_vch_typ
		on t_mvch.typ_id=gl_vch_typ.typ_id
		--Inner Join with Chart of Accounts	
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no
		--Left join m_cur
		left join m_cur
		on t_mvch.cur_id=m_cur.cur_id
		--Where Clause
		where mvch_app='Y'
		--and gl_m_acc.acc_id='01002005004' 
		and left(gl_m_acc.acc_id,@acc_len)=(select acc_id from m_sys inner join gl_m_acc on m_sys.cashmaster_acc=gl_m_acc.acc_no)
		and acc_dm='D'
		and t_mvch.mvch_dt between @dt1 and @dt2
UNION all
--Bank Opening
	select 
		com_id,br_id,yr_id,typ_id,typ_nam,typ_snm,mvch_id,mvch_dt,'' as [mvch_pto],dvch_nar,mvch_ref,acc_no,acc_id,acc_nam,cur_id,cur_snm,0 as [dvch_dr_famt],0 as [dvch_cr_famt],sum(fbalance) as [FOBalance],0 as [dvch_dr_amt],0 as [dvch_cr_amt],sum(balance) as [OBalance],0 as [FTBalance],sum(fbalance) as [FBalance],0 as [TBalance],sum(balance) as [Balance],tag, 'B' as [MTag], 
		mvch_tax
		from tb_obal
	where mvch_dt<@dt1
	and acc_no in (select acc_no from gl_m_bk)
	and yr_id=@yr_id
		--Group By	
		group by com_id,br_id,yr_id,typ_id,typ_nam,typ_snm,mvch_id,mvch_dt,mvch_cb,mvch_ref,dvch_nar,acc_no,acc_id,acc_nam,tag,cur_id,cur_snm,mvch_tax
--SELECT * from gl_br_acc where acc_id='01001001002001'      
union all
--Transaction Bank
	select 
	t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.typ_id,typ_snm,typ_nam,t_mvch.mvch_id,t_mvch.mvch_dt,mvch_pto,dvch_nar,mvch_ref,t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,t_mvch.cur_id,cur_snm,dvch_dr_famt,dvch_cr_famt,0 as [FOBalance],dvch_dr_amt,dvch_cr_amt,0 as [OBalance],dvch_dr_famt-dvch_cr_famt  as [FTBalance],dvch_dr_famt-dvch_cr_famt  as [FBalance],dvch_dr_amt-dvch_cr_amt  as [TBalance],dvch_dr_amt-dvch_cr_amt  as [Balance],'T' as [Tag],'B' as [MTag],
	mvch_tax
		from t_mvch
		--Inner Join Voucher Details
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Inner Join Voucher Type
		inner join gl_vch_typ
		on t_mvch.typ_id=gl_vch_typ.typ_id
		--Inner Join with Chart of Accounts	
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no
		--Left join m_cur
		left join m_cur
		on t_mvch.cur_id=m_cur.cur_id
		--Where Clause
		where mvch_app='Y'
		and  gl_m_acc.acc_no in (select acc_no from gl_m_bk)
		and acc_dm='D'
		and t_mvch.mvch_dt between @dt1 and @dt2
		and t_mvch.yr_id=@yr_id
end

GO

