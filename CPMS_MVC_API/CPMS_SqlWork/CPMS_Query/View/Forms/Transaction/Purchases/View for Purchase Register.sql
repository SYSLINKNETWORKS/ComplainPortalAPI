--select * from tmp_grn
create proc sp_rpt_pur_reg
as

delete from tmp_grn
insert into tmp_grn (mgrn_id,mgrn_dat,mpo_id,mpo_dat,sup_id,sup_nam,sup_dc,wh_id,wh_nam,itm_id,itm_nam,titm_id,titm_nam,titm_bar,dgrn_exp,bd_id,bd_nam,dgrn_qty,dgrn_acc,dgrn_nqty,mpb_rat,dgrn_rat,dgrn_amt,dgrn_disamt)

select t_mgrn.mgrn_id,mgrn_dat,t_mgrn.mpo_id,mpo_dat,t_mpo.sup_id,sup_nam,sup_dc,t_mgrn.wh_id,wh_nam,t_itm.itm_id,itm_nam,t_dgrn.titm_id,titm_nam,titm_bar,dgrn_exp,t_itm.bd_id,bd_nam,dgrn_qty,dgrn_acc,dgrn_nqty,0,0,0,0 from t_mgrn
	--Join with Detail GRN
	inner join t_dgrn
	on t_mgrn.mgrn_id=t_dgrn.mgrn_id
	--Join with Master PO
	inner join t_mpo
	on t_mgrn.mpo_id=t_mpo.mpo_id
	--Join with Supplier
	inner join m_sup
	on t_mpo.sup_id=m_sup.sup_id
	--Join with Item Detail
	inner join t_itm 
	on t_dgrn.titm_id=t_itm.titm_id
	--Join with Item Category
	inner join m_itm
	on t_itm.itm_id=m_itm.itm_id
	--Left Join Brand
	left join m_bd
	on t_itm.bd_id=m_bd.bd_id
	--Left Join with Warehouse
	left join m_wh
	on t_mgrn.wh_id=m_wh.wh_id

	update tmp_grn set dgrn_rat=(select isnull( avg (dpb_rat),0) from t_dpb inner join t_dpb_grn on t_dpb.mpb_id=t_dpb_grn.mpb_id where t_dpb_grn.mgrn_id=tmp_grn.mgrn_id and t_dpb.titm_id=tmp_grn.titm_id )
	update tmp_grn set dgrn_amt=dgrn_qty*dgrn_rat
	update tmp_grn set dgrn_disamt=(select isnull( avg (dpb_disamt),0) from t_dpb inner join t_dpb_grn on t_dpb.mpb_id=t_dpb_grn.mpb_id where t_dpb_grn.mgrn_id=tmp_grn.mgrn_id and t_dpb.titm_id=tmp_grn.titm_id )
	update tmp_grn set mpb_rat=(select isnull(avg(mpb_rat),0) from t_mpb inner join t_dpb_grn on t_mpb.mpb_id=t_dpb_grn.mpb_id where t_dpb_grn.mgrn_id=tmp_grn.mgrn_id)
	update tmp_grn set cur_id=(select distinct cur_id from t_mpb inner join t_dpb_grn on t_mpb.mpb_id=t_dpb_grn.mpb_id where t_dpb_grn.mgrn_id=tmp_grn.mgrn_id)
	update tmp_grn set cur_id=(select cur_id from m_cur where cur_typ='S') where cur_id is null
	update tmp_grn set cur_snm=(select cur_snm from m_cur where cur_id=tmp_grn.cur_id)

select * from tmp_grn

go
--	
--drop table tmp_grn
--create table tmp_grn
--(
--mgrn_id int,
--mgrn_dat datetime,
--mpo_id int,
--mpo_dat datetime,
--sup_id int,
--sup_nam varchar(250),
--sup_dc varchar(100),
--wh_id int,
--wh_nam varchar(250),
--itm_id int,
--itm_nam varchar(250),
--titm_id int,
--titm_nam varchar(250),
--titm_bar varchar(1000),
--dgrn_exp datetime,
--cur_id int,
--cur_snm varchar(100),
--bd_id int,
--bd_nam varchar(250),
--dgrn_qty float default 0,
--dgrn_acc float default 0,
--dgrn_nqty float default 0,
--mpb_rat float  default 1,
--dgrn_rat float default 0,
--dgrn_amt float default 0,
--dgrn_disamt float default 0,
--dgrn_namt as dgrn_amt-dgrn_disamt,
--dgrn_trat as dgrn_rat*mpb_rat,
--dgrn_tamt as dgrn_amt*mpb_rat,
--dgrn_tdisamt as dgrn_disamt*mpb_rat,
--dgrn_ntamt as (dgrn_amt-dgrn_disamt)*mpb_rat
--)
