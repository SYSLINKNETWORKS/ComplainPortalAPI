USE ZSONS
GO

alter view v_titm_receipe
as
select titm_id as [ID], titm_nam as [Item],bd_nam as [Brand],titm_bar as [BarCode],sca_nam as [Scale] from t_itm  inner join m_itm on t_itm.itm_id=m_itm.itm_id left join m_bd on t_itm.bd_id=m_bd.bd_id left join m_sca on t_itm.man_sca_id=m_sca.sca_id where titm_act<>0 and itm_cat in ('P','G')  union all select titm_id as [ID], titm_nam as [Item],bd_nam as [Brand],titm_bar as [BarCode],sca_nam as [Scale]  from t_itm  inner join m_itm on t_itm.itm_id=m_itm.itm_id left join m_bd on t_itm.bd_id=m_bd.bd_id left join m_sca on t_itm.man_sca_id=m_sca.sca_id where titm_act<>0 and itm_cat in ('P','E')

