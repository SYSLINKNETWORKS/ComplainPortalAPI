USE ZSons
GO
----View for Transactional Opening Balance
ALTER view [dbo].[rpt_t_obl]
as
select 
	t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.typ_id,t_mvch.mvch_id,t_mvch.mvch_dt,a.acc_id,a.acc_nam,a.acc_cid,mvch_tax,
		a.acc_lvl,
		L1.acc_id as [L1_accid], L1.acc_nam as [L1_nam],
		L2.acc_id as [L2_accid], L2.acc_nam as [L2_nam],
		L3.acc_id as [L3_accid], L3.acc_nam as [L3_nam],
		L4.acc_id as [L4_accid], L4.acc_nam as [L4_nam],
		L5.acc_id as [L5_accid], L5.acc_nam as [L5_nam],
		L6.acc_id as [L6_accid], L6.acc_nam as [L6_nam],
		L7.acc_id as [L7_accid], L7.acc_nam as [L7_nam],
		case when (dvch_dr_amt-dvch_cr_amt)>=0 then dvch_dr_amt-dvch_cr_amt else 0 end as [dvch_dr_amt],
		case when (dvch_dr_amt-dvch_cr_amt)<0 then  dvch_dr_amt-dvch_cr_amt else 0 end as [dvch_cr_amt],
		'ALE' as [Tag],(case when left(a.acc_id,2)='01' then 1 else 2 end) as [Type],'T' as [Identity] 

		from t_mvch
		--Join with Detail Voucher
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Join with Chart of Account
		inner join gl_m_acc a
		on t_dvch.acc_no=a.acc_no
	--Level L1
	inner join gl_m_acc L1
	on left(a.acc_cid,2)=L1.acc_id
	--Level L2
	inner join gl_m_acc L2
	on left(a.acc_cid,5)=L2.acc_id
	--Level L3
	inner join gl_m_acc L3
	on left(a.acc_cid,8)=L3.acc_id
	--Level L4
	inner join gl_m_acc L4
	on left(a.acc_cid,11)=L4.acc_id
	--Level L5
	inner join gl_m_acc L5
	on left(a.acc_cid,14)=L5.acc_id
	--Level L6
	inner join gl_m_acc L6
	on left(a.acc_cid,17)=L6.acc_id
	--Level L7
	inner join gl_m_acc L7
	on left(a.acc_cid,20)=L7.acc_id
		--Where
		where LEFT(gl_m_acc.acc_id,2) in ('01','02','03')
		and mvch_app='Y'

union

select 
	com_id,br_id,yr_id,'' as [typ_id],'' as [mvch_id],acc_dat as [mvch_dt],a.acc_id,a.acc_nam,a.acc_cid,mvch_tax,
		a.acc_lvl,
		L1.acc_id as [L1_accid], L1.acc_nam as [L1_nam],
		L2.acc_id as [L2_accid], L2.acc_nam as [L2_nam],
		L3.acc_id as [L3_accid], L3.acc_nam as [L3_nam],
		L4.acc_id as [L4_accid], L4.acc_nam as [L4_nam],
		L5.acc_id as [L5_accid], L5.acc_nam as [L5_nam],
		L6.acc_id as [L6_accid], L6.acc_nam as [L6_nam],
		L7.acc_id as [L7_accid], L7.acc_nam as [L7_nam],
		case when (acc_obal)>=0 then acc_obal else 0 end as [dvch_dr_amt],
		case when (acc_obal)<0 then  acc_obal else 0 end as [dvch_cr_amt],
		'ALE' as [Tag],(case when left(a.acc_id,2)='01' then 1 else 2 end) as [Type],'O' as [Identity] 

		from gl_m_acc a 
		--Join with Opening Balance
		inner join gl_br_acc
		on gl_br_acc.acc_id=a.acc_id
	--Level L1
	inner join gl_m_acc L1
	on left(a.acc_cid,2)=L1.acc_id
	--Level L2
	inner join gl_m_acc L2
	on left(a.acc_cid,5)=L2.acc_id
	--Level L3
	inner join gl_m_acc L3
	on left(a.acc_cid,8)=L3.acc_id
	--Level L4
	inner join gl_m_acc L4
	on left(a.acc_cid,11)=L4.acc_id
	--Level L5
	inner join gl_m_acc L5
	on left(a.acc_cid,14)=L5.acc_id
	--Level L6
	inner join gl_m_acc L6
	on left(a.acc_cid,17)=L6.acc_id
	--Level L7
	inner join gl_m_acc L7
	on left(a.acc_cid,20)=L7.acc_id
		--Where
		where left(a.acc_id,2) in ('01','02','03')

--select acc_id,sum(dvch_dr_amt),sum(dvch_cr_amt) from rpt_t_obl where mvch_dt<='05/01/2009' group by acc_id
--select * from rpt_t_obl where mvch_dt<='05/01/2009'
GO


