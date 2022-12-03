USE MFI
GO
alter view v_dso_qty_sum
as
select mso_id,titm_id,itmqty_id,sum(dso_psoqty) as [dso_psoqty] from t_dso 
--where mso_id=10 group by mso_id,titm_id,itmqty_id

--select mso_id,itmqty_id,titm_id,bd_id,bd_id_stk,dso_maf,dso_bat,sum(dso_psoqty) as [dso_psoqty] from t_dso 
--where dso_bat<>''
--group by mso_id,itmqty_id,titm_id,bd_id,bd_id_stk,dso_bat,dso_maf
--select mso_id,itmqty_id,titm_id,bd_id,bd_id_stk,dso_maf,dso_bat,sum(dso_psoqty) as [dso_psoqty] from t_dso 
--where dso_bat<>''
--group by mso_id,itmqty_id,titm_id,bd_id,bd_id_stk,dso_bat,dso_maf





