USE MFI
go
create view v_stkadjmon_bat
as
select itm_id,wh_id,SUM(stk_qty) as [stk_qty] from m_stk 
--where mso_id=1 and itm_id=100 and wh_id=1 and stk_bat='6609-1P'
group by itm_id,wh_id
