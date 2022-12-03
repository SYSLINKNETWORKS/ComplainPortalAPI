USE MFI
GO
alter view v_dis
as
select m_stk.mso_id,mso_no,itm_id,titm_exp,m_stk.bd_id,bd_nam,m_stk.wh_id,wh_nam,stk_qty from m_stk
	inner join t_mso
	on m_stk.mso_id=t_mso.mso_id
	left join m_bd
	on m_stk.bd_id=m_bd.bd_id
	left join m_wh
	on m_stk.wh_id=m_wh.wh_id
	 where stk_frm='stk_dispose'

--select * from v_dis
