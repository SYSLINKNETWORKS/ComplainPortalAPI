use meiji_rusk

create view [dbo].[v_dc]
as
select t_mdc.mdc_id,mso_id,titm_id,sum(ddc_qty) as [ddc_qty] from t_mdc inner join t_ddc on t_mdc.mdc_id=t_ddc.mdc_id group by t_mdc.mdc_id,mso_id,titm_id
