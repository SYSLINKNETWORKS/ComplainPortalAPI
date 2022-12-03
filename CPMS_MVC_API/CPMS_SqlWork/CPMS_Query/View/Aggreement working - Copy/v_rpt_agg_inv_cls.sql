USE ZSons
go

--alter view v_rpt_Agg_inv_cls
--as
select 
	magg_id,magg_no,magg_dat,v_rpt_agg_cls.cus_id,cus_nam,magg_datfrm,magg_datto,magg_rmk,magg_amt,magg_ckamt,
	v_rpt_agg_cls.bd_id,bd_nam,v_rpt_agg_cls.itmsub_id,itmsub_nam,
	dagg_perval,dagg_amt,dagg_amt1,dagg_amt2,dagg_amt3,
	[Target],isnull(sum(dinv_namt),0) as [dinv_namt],
	--case when isnull(sum(dinv_namt),0)>=[target] then dagg_amt else 0 end as [achievement] ,
	0 as [achievement],
	case when isnull(sum(dinv_namt),0) between dagg_amt1 and dagg_amt-1 then dagg_amt1 else 0 end as [achievement1], 
	case when isnull(sum(dinv_namt),0) between dagg_amt2 and dagg_amt1-1 then dagg_amt2 else 0 end as [achievement2],
	case when isnull(sum(dinv_namt),0) between dagg_amt3 and dagg_amt2-1 then dagg_amt3 else 0 end as [achievement3], 
	case when isnull(sum(dinv_namt),0) between dagg_amt4 and dagg_amt3-1 then dagg_amt4 else 0 end as [achievement4] 
	from v_rpt_agg_cls
	left join v_rpt_agg_inv
	on v_rpt_agg_cls.cus_id=v_rpt_agg_inv.cus_id
	and v_rpt_agg_cls.bd_id=v_rpt_agg_inv.bd_id
	and v_rpt_agg_cls.itmsub_id=v_rpt_agg_inv.itmsub_id
	and minv_dat between magg_datfrm and magg_datto
where magg_id=2
	group by magg_id,magg_no,magg_dat,v_rpt_agg_cls.cus_id,cus_nam,magg_datfrm,magg_datto,magg_rmk,magg_amt,magg_ckamt,
	v_rpt_agg_cls.bd_id,bd_nam,v_rpt_agg_cls.itmsub_id,itmsub_nam,
	dagg_perval,dagg_amt,dagg_amt1,dagg_amt2,dagg_amt3,dagg_amt4,[Target]
--SELECT * FROM m_cus where cus_id=5
