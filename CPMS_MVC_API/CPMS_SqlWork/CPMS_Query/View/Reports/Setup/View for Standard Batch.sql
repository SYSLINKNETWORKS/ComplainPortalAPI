USE MFI
GO

alter view v_rpt_stdbat
as
select 
	t_itm.itm_id,itm_nam,t_itm.itmsub_id,itmsub_nam,m_batqty.titm_id,titm_nam,batqty_dat,case batqty_ck when 0 then m_sca.sca_nam else inn.sca_nam end as [sca_nam],itmqty_nam,batqty_mqty,batqty_qty,batqty_ck,case ck_bth when 0 then m_sca.sca_nam else 'GMS' end as [Pcs],ck_bth,inner_titm_qty,inner_sca_id,master_titm_qty,master_sca_id
	from m_batqty
	inner join m_itmqty
	on m_batqty.itmqty_id=m_itmqty.itmqty_id
	inner join t_itm
	on m_batqty.titm_id=t_itm.titm_id
	inner join m_itm
	on t_itm.itm_id=m_itm.itm_id
	left join m_itmsub
	on t_itm.itmsub_id=m_itmsub.itmsub_id
	left join m_bd
	on t_itm.bd_id=m_bd.bd_id
	left join m_sca
	on t_itm.sca_id=m_sca.sca_id
	left join m_sca inn
	on t_itm.inner_sca_id=inn.sca_id
	
--	where t_itm.titm_id=105
