
----View for Profit / Loss Opening Balance
--select sum(dvch_dr_amt)+sum(dvch_cr_amt) from rpt_pl_obl where mvch_dt <='05/30/2009'
--select * from rpt_pl_obl where mvch_dt<='05/30/2009'
ALTER view [dbo].[rpt_pl_obl]
as
select gl_br_acc.com_id,gl_br_acc.br_id,gl_br_acc.yr_id,'' as [typ_id],'' as [mvch_id],gl_br_acc.acc_dat as [mvch_dt],dbo.funcpl() as [acc_id],'Profit/(Loss)' as [acc_nam],dbo.funcCPL() as [acc_cid],
		L1.acc_id as [L1_accid], L1.acc_nam as [L1_nam],
		L2.acc_id as [L2_accid], L2.acc_nam as [L2_nam],
		L3.acc_id as [L3_accid], L3.acc_nam as [L3_nam],
		L4.acc_id as [L4_accid], L4.acc_nam as [L4_nam],
		L5.acc_id as [L5_accid], L5.acc_nam as [L5_nam],
		L6.acc_id as [L6_accid], L6.acc_nam as [L6_nam],
		L7.acc_id as [L7_accid], L7.acc_nam as [L7_nam],
		0 as [acc_lvl],
		 case when sum(gl_br_acc.acc_obal)>=0 then sum(gl_br_acc.acc_obal) else 0 end as [dvch_dr_amt] ,
		 case when sum(gl_br_acc.acc_obal)<0 then sum(gl_br_acc.acc_obal) else 0 end as [dvch_cr_amt] ,
		'PL' as [Tag],2 as [Type],'O' AS [ID]  from gl_br_acc
	inner join gl_br_acc a
	on gl_br_acc.acc_id=a.acc_id
	--Level L1
	inner join gl_m_acc L1
	on left(dbo.funcCPL(),2)=L1.acc_id
	--Level L2
	inner join gl_m_acc L2
	on left(dbo.funcCPL(),5)=L2.acc_id
	--Level L3
	inner join gl_m_acc L3
	on left(dbo.funcCPL(),8)=L3.acc_id
	--Level L4
	inner join gl_m_acc L4
	on left(dbo.funcCPL(),11)=L4.acc_id
	--Level L5
	inner join gl_m_acc L5
	on left(dbo.funcCPL(),14)=L5.acc_id
	--Level L6
	inner join gl_m_acc L6
	on left(dbo.funcCPL(),17)=L6.acc_id
	--Level L7
	inner join gl_m_acc L7
	on left(dbo.funcCPL(),20)=L7.acc_id
	--Where Clause
	where (left(a.acc_id,2)) in ('04','05')
	--group by
	group by gl_br_acc.com_id,gl_br_acc.br_id,gl_br_acc.yr_id,gl_br_acc.acc_dat,
			L1.acc_id,L1.acc_nam,
			L2.acc_id,L2.acc_nam,
			L3.acc_id,L3.acc_nam,
			L4.acc_id,L4.acc_nam,
			L5.acc_id,L5.acc_nam,
			L6.acc_id,L6.acc_nam,
			L7.acc_id,L7.acc_nam
union
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.typ_id,t_mvch.mvch_id,t_mvch.mvch_dt,dbo.funcpl()  as [acc_id],'Profit/(Loss)' as [acc_nam],dbo.funcCPL() as [acc_cid],
		L1.acc_id as [L1_accid], L1.acc_nam as [L1_nam],
		L2.acc_id as [L2_accid], L2.acc_nam as [L2_nam],
		L3.acc_id as [L3_accid], L3.acc_nam as [L3_nam],
		L4.acc_id as [L4_accid], L4.acc_nam as [L4_nam],
		L5.acc_id as [L5_accid], L5.acc_nam as [L5_nam],
		L6.acc_id as [L6_accid], L6.acc_nam as [L6_nam],
		L7.acc_id as [L7_accid], L7.acc_nam as [L7_nam],
		'' as [acc_lvl],
		 case when (dvch_dr_amt-dvch_cr_amt)>=0 then dvch_dr_amt-dvch_cr_amt else 0 end as [dvch_dr_amt] ,
		 case when (dvch_dr_amt-dvch_cr_amt)<0 then dvch_dr_amt-dvch_cr_amt else 0 end as [dvch_cr_amt] ,
--		sum(dvch_dr_amt) as [dvch_dr_amt],
--		sum(dvch_cr_amt) as [dvch_cr_amt],
		'PL' as [Tag],2 as [Type],'T' as [Id] 
		from t_mvch
		--Join with Detail Voucher
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.typ_id=t_dvch.typ_id
		and t_mvch.mvch_id=t_dvch.mvch_id
		and t_mvch.mvch_dt=t_dvch.mvch_dt
		and t_mvch.yr_id=t_dvch.yr_id
	inner join gl_m_acc a
	on t_dvch.acc_id=a.acc_id
	--Level L1
	inner join gl_m_acc L1
	on left(dbo.funcCPL(),2)=L1.acc_id
	--Level L2
	inner join gl_m_acc L2
	on left(dbo.funcCPL(),5)=L2.acc_id
	--Level L3
	inner join gl_m_acc L3
	on left(dbo.funcCPL(),8)=L3.acc_id
	--Level L4
	inner join gl_m_acc L4
	on left(dbo.funcCPL(),11)=L4.acc_id
	--Level L5
	inner join gl_m_acc L5
	on left(dbo.funcCPL(),14)=L5.acc_id
	--Level L6
	inner join gl_m_acc L6
	on left(dbo.funcCPL(),17)=L6.acc_id
	--Level L7
	inner join gl_m_acc L7
	on left(dbo.funcCPL(),20)=L7.acc_id
	--Where Clause
	where (left(a.acc_id,2)) in ('04','05')
	and mvch_app='Y'
GO

