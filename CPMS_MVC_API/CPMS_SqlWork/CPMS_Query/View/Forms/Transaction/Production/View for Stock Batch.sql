USE [zsons]
GO

alter view [dbo].[v_stk_bat]
as
select m_yr_id,itm_id as [titm_id],stk_dat,sum(stk_qty) as [stk_qty] from m_stk where stk_frm in ('t_itm','GRN','DEBIT','TransRM') group by m_yr_id,itm_id,stk_dat



--select * from m_stk where stk_frm='TransferRM'
