USE MFI
go
alter view v_miss
as
select mso_id,titm_id,titm_id_patti,sum(miss_nob) as [miss_nob] from t_miss where miss_typ<>'G' group by mso_id,titm_id,titm_id_patti 

