----View for Update Master Voucher
ALTER view [dbo].[v_upd_mvch]
as
select 
		mvch_id,mvch_dt,mvch_pto,br_id,com_id,t_mvch.dpt_id,dpt_nam,typ_id,yr_id,mvch_cb,mvch_ref,mvch_typ,mvch_app 
		from t_mvch
		--Join with department
		inner join m_dpt
		on t_mvch.dpt_id=m_dpt.dpt_id
GO

