create view [dbo].[v_so]
as
select mso_id,titm_id,sum(dso_qty) as [dso_qty] from t_dso group by mso_id,titm_id
GO
