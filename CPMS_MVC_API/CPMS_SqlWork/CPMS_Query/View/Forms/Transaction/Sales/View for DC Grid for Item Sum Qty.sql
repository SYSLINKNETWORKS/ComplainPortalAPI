USE PHM
GO
alter view [dbo].[v_so_qty]
as
select mso_id,titm_id,sum(dso_appqty) as [dso_qty] from t_dso group by mso_id,titm_id
GO

--select * from t_dso where mso_id=1
