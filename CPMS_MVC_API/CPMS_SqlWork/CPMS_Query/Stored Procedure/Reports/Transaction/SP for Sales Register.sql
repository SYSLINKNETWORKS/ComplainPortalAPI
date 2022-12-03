USE zsons
GO

--drop view v_rpt_dinv


alter proc sp_sal_reg
as
select 
	t_minv.com_id,t_minv.br_id,t_minv.minv_id,minv_no,minv_taxid,minv_dat,minv_cktax,t_mso.emppro_id,emppro_macid,emppro_nam,
	t_minv.cus_id,cus_nam,cuscat_id,cuscat_nam,cussubcat_id,cussubcat_nam,zone_id,zone_nam,
	minv_amt,minv_disamt,minv_gstamt,minv_fedamt,minv_freamt,minv_namt,t_minv.mdc_id,dinv_tax,itm_id,itm_nam,itmsubmas_id,itmsubmas_nam,itmsub_id,itmsub_nam,bd_id,bd_nam,t_dinv.titm_id,t_dinv.itmqty_id,itmqty_nam,dinv_stdsiz,titm_nam,minv_rat,dinv_rat ,dinv_qty,m_sca.sca_nam,dinv_amt,dinv_disamt,dinv_othamt,dinv_gstper,dinv_gstamt ,dinv_fedper,dinv_fedamt,dinv_namt,t_minv.cur_id,m_cur.cur_snm
	from t_minv
	inner join t_dinv
	on t_minv.minv_id=t_dinv.minv_id
	inner join v_titm
	on t_dinv.titm_id=v_titm.titm_id
	inner join v_cus
	on t_minv.cus_id=v_cus.cus_id
	left join m_cur
	on t_minv.cur_id=m_cur.cur_id
	left join m_itmqty
	on t_dinv.itmqty_id=m_itmqty.itmqty_id
	left join m_sca
	on t_dinv.sca_id=m_sca.sca_id
	left join t_mdc
	on t_dinv.mdc_id=t_mdc.mdc_id
	left join t_mso
	on t_mdc.mso_id=t_mso.mso_id
	left join m_emppro
	on t_mso.emppro_id=m_emppro.emppro_id

