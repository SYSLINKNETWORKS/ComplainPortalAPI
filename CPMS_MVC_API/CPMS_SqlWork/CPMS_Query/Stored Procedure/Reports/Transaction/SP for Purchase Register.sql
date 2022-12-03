USE zsons
GO

alter view v_rpt_dpb
as
select dpb_tax,t_dpb.mpb_id,titm_id,sum(dpb_qty) as [dpb_qty],
--case when mpb_con='-' then sum(dpb_amt)-(((mpb_disamt+mpb_othamt+mpb_desamt+mpb_fre)/sum(dpb_qty))*sum(dpb_qty)) else sum(dpb_amt)+(((mpb_fre/sum(dpb_qty))/sum(dpb_qty)))-(((mpb_disamt+mpb_othamt+mpb_desamt)/sum(dpb_qty))*sum(dpb_qty))  end as [dpb_amt],
--case when mpb_con='-' then sum(dpb_namt)-(((mpb_disamt+mpb_othamt+mpb_desamt+mpb_fre)/sum(dpb_qty))*sum(dpb_qty)) else sum(dpb_namt)+(((mpb_fre/sum(dpb_qty))/sum(dpb_qty)))-(((mpb_disamt+mpb_othamt+mpb_desamt)/sum(dpb_qty))*sum(dpb_qty)) end  as [dpb_namt],
--case when mpb_con='-' then sum(dpb_ntamt)-(((mpb_disamt+mpb_othamt+mpb_desamt+mpb_fre)/sum(dpb_qty))*sum(dpb_qty)) else sum(dpb_ntamt)+(((mpb_fre/sum(dpb_qty))/sum(dpb_qty)))-(((mpb_disamt+mpb_othamt+mpb_desamt)/sum(dpb_qty))*sum(dpb_qty)) end as [dpb_ntamt],
sum(dpb_amt) as [dpb_amt],
sum(dpb_namt) as [dpb_namt],
sum(dpb_ntamt) as [dpb_ntamt],
sum(dpb_disamt) as [dpb_disamt],sum(dpb_tdisamt) as [dpb_tdisamt],sum(dpb_othamt) as [dpb_othamt],sum(dpb_tothamt) as [dpb_tothamt] 
from t_mpb
inner join t_dpb
on t_mpb.mpb_id=t_dpb.mpb_id
group by mpb_disamt,mpb_fre,t_dpb.mpb_id,titm_id,mpb_othamt,mpb_desamt,mpb_con,dpb_tax


go
alter proc sp_pur_reg
as
select 
	t_mpb.com_id,t_mpb.br_id,t_mpb.mpb_id,mpb_taxid,mpb_dat,mpb_cktax,m_sup.supcat_id,supcat_nam,t_mpb.sup_id,sup_nam,sup_bill,dpb_tax,t_itm.itm_id,itm_nam,m_itmsub.itmsubmas_id,itmsubmas_nam,t_itm.itmsub_id,itmsub_nam,t_itm.bd_id,bd_nam,t_dgrn.titm_id,titm_nam,mpb_rat,dgrn_exp,(dpb_amt/dpb_qty) as [dpb_rat],mpb_rat*(dpb_amt/dpb_qty) as [dpb_trat],dgrn_qty,sca_nam,(dpb_amt/dpb_qty)*dgrn_qty as [dpb_amt],(dpb_disamt/dpb_qty)*dgrn_qty  as [dpb_disamt],(dpb_othamt/dpb_qty)*dgrn_qty as [dpb_othamt],(dpb_namt/dpb_qty)*dgrn_qty as [dpb_namt],(mpb_rat*(dpb_amt/dpb_qty))*dgrn_qty as [dpb_tamt],(dpb_tdisamt/dpb_qty)*dgrn_qty as [dpb_tdisamt],(dpb_tothamt/dpb_qty)*dgrn_qty as [dpb_tothamt],(dpb_ntamt/dpb_qty)*dgrn_qty as [dpb_ntamt],t_mpb.cur_id,cur_snm
	from t_mgrn
	inner join t_dgrn
	on t_mgrn.mgrn_id=t_dgrn.mgrn_id
	inner join t_itm
	on t_dgrn.titm_id=t_itm.titm_id
	inner join m_itm
	on t_itm.itm_id=m_itm.itm_id
	inner join t_dpb_grn
	on t_mgrn.mgrn_id=t_dpb_grn.mgrn_id
	inner join t_mpb
	on t_dpb_grn.mpb_id=t_mpb.mpb_id
	inner join v_rpt_dpb
	on t_mpb.mpb_id=v_rpt_dpb.mpb_id
	and t_dgrn.titm_id=v_rpt_dpb.titm_id
	inner join m_sup
	on t_mpb.sup_id=m_sup.sup_id
	left join m_supcat
	on m_sup.supcat_id=m_supcat.supcat_id
	left join m_itmsub
	on t_itm.itmsub_id=m_itmsub.itmsub_id
	left join m_itmsubmas
	on m_itmsub.itmsubmas_id=m_itmsubmas.itmsubmas_id
	left join m_bd
	on t_itm.bd_id=m_bd.bd_id
	left join m_sca
	on t_itm.sca_id=m_sca.sca_id
	left join m_cur
	on t_mpb.cur_id=m_cur.cur_id
	

