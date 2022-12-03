USE MFI
GO

--alter table m_stk add stk_batst bit default 0
--select * from m_stk 
--update m_stk set stk_batst=0

--Stock wise Batch
alter view v_stk_bat_dc
as
select m_stk.m_yr_id,m_stk.mso_id,mso_no,itm_id as [titm_id],stk_bat,sum(stk_qty) as [stk_qty],titm_maf,titm_exp,bd_id from m_stk inner join t_mso on m_stk.mso_id=t_mso.mso_id where  stk_batst=0 and stk_frm in ('TransFG','DC','CREDITNOTE') group by m_stk.m_yr_id,m_stk.mso_id,mso_no,itm_id,stk_bat,titm_maf,titm_exp,bd_id


--select * from v_stk_bat_dc where titm_id=630 and stk_bat=''
