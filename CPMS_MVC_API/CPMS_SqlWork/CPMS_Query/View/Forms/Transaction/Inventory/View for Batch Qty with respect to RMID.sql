USE MFI
go

alter view v_dfg_batqty
as
select miss_id_fg,SUM(dfg_batqty) as [dfg_batqty] from t_dfg inner join t_miss on t_dfg.miss_id_fg=t_miss.miss_id 
group by miss_id_fg


