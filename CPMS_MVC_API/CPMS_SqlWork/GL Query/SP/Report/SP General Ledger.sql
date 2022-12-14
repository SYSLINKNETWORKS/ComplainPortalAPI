USE meiji_rusk
GO

--select * from gl_m_acc where acc_cid='05007001'
--select  * from t_mvch inner join t_dvch on t_mvch.com_id=t_Dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no where acc_no in (select acc_no from gl_m_acc where acc_cid='05007001')
--select * from gl_br_acc
--select dateadd(day,1,'07/01/2011')
--exec sp_rpt_gl '01/01/2015','12/31/2015','01','05007001001'
----SP General Ledger
alter proc [dbo].[sp_rpt_GL] (@dt1 datetime,@dt2 datetime,@yr_id char(2),@acc_id char(20))
as
begin
select 
		t_mvch.com_id,t_mvch.br_id,t_mvch.mvch_tax,t_mvch.cur_id,cur_snm,'' as [typ_id],'' as [typ_nam],'' as [typ_snm],'' as [mvch_id],'' as [mvch_dt],'' as [mvch_cb],''as [mvch_ref],'' as [mvch_chq],'' as [mvch_chqdat],'' as [mvch_po],'' as [mvch_pto],'' as [dvch_nar],avg(mvch_rat) as [mvch_rat],
		0 as [opening_dvch_dr_famt],
		0 as [opening_dvch_cr_famt],
		sum(dvch_dr_famt - dvch_cr_famt) as [Opening_fbalance],
		0 as [opening_dvch_dr_amt],
		0 as [opening_dvch_cr_amt],
		sum(dvch_dr_amt - dvch_cr_amt) as [opening_balance],
		0 as [dvch_dr_amt],
		0 as [dvch_cr_amt],
		0 as [balance],
		0 as [dvch_dr_famt],
		0 as [dvch_cr_famt],
		0 as [fbalance],
		sum(dvch_dr_famt - dvch_cr_famt) as [Gfbalance],
		sum(dvch_dr_amt - dvch_cr_amt) as [Gbalance],
		t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,
		cast (1 as bit) as [mvch_chqst],'O' as [Tag]
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
		--Left Join Currency
		left join m_cur 
		on t_mvch.cur_id=m_cur.cur_id
		--Where Clause 
		where  t_mvch.yr_id=@yr_id
		and mvch_app='Y'
		and t_mvch.typ_id='06'
		and left(gl_m_acc.acc_id,LEN(@acc_id))=@acc_id
		and t_mvch.mvch_can=0
		and t_mvch.mvch_del=0
group by t_mvch.com_id,t_mvch.br_id,mvch_tax,t_mvch.cur_id,cur_snm,t_dvch.acc_no,gl_m_acc.acc_id,acc_nam
union all
select 
--		t_mvch.com_id,t_mvch.br_id,t_mvch.cur_id,cur_snm,t_mvch.typ_id,typ_nam,typ_snm,t_mvch.mvch_id,t_mvch.mvch_dt,mvch_cb,mvch_ref,mvch_chq,mvch_chqdat,mvch_chqst,mvch_po,mvch_pto,dvch_nar,dvch_dr_famt as [dvch_dr_famt],dvch_cr_famt as [dvch_cr_famt],dvch_dr_famt - dvch_cr_famt as [fbalance],dvch_dr_amt as [dvch_dr_amt],dvch_cr_amt as [dvch_cr_amt],dvch_dr_amt - dvch_cr_amt as [balance],t_dvch.acc_id,acc_nam,'O' as [Tag]
		t_mvch.com_id,t_mvch.br_id,t_mvch.mvch_tax,t_mvch.cur_id,cur_snm,'' as [typ_id],'' as [typ_nam],'' as [typ_snm],'' as [mvch_id],'' as [mvch_dt],'' as [mvch_cb],''as [mvch_ref],'' as [mvch_chq],'' as [mvch_chqdat],'' as [mvch_po],'' as [mvch_pto],'' as [dvch_nar],avg(mvch_rat) as [mvch_rat],
		0 as [opening_dvch_dr_famt],
		0 as [opening_dvch_cr_famt],
		sum(dvch_dr_famt - dvch_cr_famt) as [Opening_fbalance],
		0 as [opening_dvch_dr_amt],
		0 as [opening_dvch_cr_amt],
		sum(dvch_dr_amt - dvch_cr_amt) as [opening_balance],
		0 as [dvch_dr_amt],
		0 as [dvch_cr_amt],
		0 as [balance],
		0 as [dvch_dr_famt],
		0 as [dvch_cr_famt],
		0 as [fbalance],
		sum(dvch_dr_famt - dvch_cr_famt) as [Gfbalance],
		sum(dvch_dr_amt - dvch_cr_amt) as [Gbalance],
		t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,
		1 as [mvch_chqst],'O' as [Tag]
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
		--Left Join Currency
		left join m_cur 
		on t_mvch.cur_id=m_cur.cur_id
		--Where Clause 
		where t_mvch.mvch_chqdat < @dt1  and t_mvch.yr_id=@yr_id
		and mvch_app='Y'
		and t_mvch.typ_id<>'06'
		and left(gl_m_acc.acc_id,LEN(@acc_id))=@acc_id
		and t_mvch.mvch_can=0
		and t_mvch.mvch_del=0
	group by t_mvch.com_id,t_mvch.br_id,mvch_tax,t_mvch.cur_id,cur_snm,t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,mvch_chqst
union all
--Transactions
--		t_mvch.com_id,t_mvch.br_id,t_mvch.cur_id,cur_snm,t_mvch.typ_id,typ_nam,typ_snm,t_mvch.mvch_id,t_mvch.mvch_dt,mvch_cb,mvch_ref,mvch_chq,mvch_chqdat,mvch_chqst,mvch_po,mvch_pto,dvch_nar,dvch_dr_famt as [dvch_dr_famt],dvch_cr_famt as [dvch_cr_famt],dvch_dr_famt - dvch_cr_famt as [fbalance],dvch_dr_amt as [dvch_dr_amt],dvch_cr_amt as [dvch_cr_amt],dvch_dr_amt - dvch_cr_amt as [balance],t_dvch.acc_id,acc_nam,'T' as [Tag]
	select 
		t_mvch.com_id,t_mvch.br_id,t_mvch.mvch_tax,t_mvch.cur_id,cur_snm,t_mvch.typ_id,typ_nam,typ_snm,t_mvch.mvch_id,t_mvch.mvch_dt,mvch_cb,mvch_ref,mvch_chq,mvch_chqdat,mvch_po,mvch_pto,dvch_nar,mvch_rat,
		0 as [opening_dvch_dr_famt],
		0 as [opening_dvch_cr_famt],
		0 as [opening_fbalance],
		0 as [opening_dvch_dr_amt],
		0 as [opening_dvch_cr_amt],
		0 as [opening_balance],
		dvch_dr_amt as [dvch_dr_amt],
		dvch_cr_amt as [dvch_cr_amt],
		dvch_dr_amt - dvch_cr_amt as [balance],
		dvch_dr_famt as [dvch_dr_famt],
		dvch_cr_famt as [dvch_cr_famt],
		dvch_dr_famt - dvch_cr_famt as [fbalance],
		dvch_dr_famt - dvch_cr_famt as [Gfbalance],
		dvch_dr_amt - dvch_cr_amt as [Gbalance],
		t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,
		case when t_mvch.typ_id in ('03','04') then mvch_chqst else 1 end as [mvch_chqst],'T' as [Tag]
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
		--Left Join Currency
		left join m_cur 
		on t_mvch.cur_id=m_cur.cur_id
		--Where Clause 
		where t_mvch.mvch_chqdat between @dt1 and @dt2 and t_mvch.yr_id=@yr_id
		and mvch_app='Y'
		and t_mvch.typ_id<>'06'
		and left(gl_m_acc.acc_id,LEN(@acc_id))=@acc_id
		and t_mvch.mvch_can=0
		and t_mvch.mvch_del=0

end
GO

