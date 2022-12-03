

USE phm
GO

--select * from t_itmfg

--Insert
alter proc ins_t_itmfg(@titm_id_fg int,@titm_id int,@titmfg_typ char(1))
as
begin
		insert into t_itmfg(titm_id_fg,titm_id,titmfg_typ)
			values (@titm_id_fg,@titm_id,@titmfg_typ)
	

end
go



--Delete
alter proc del_t_itmfg(@titm_id int)
as
begin
	--Delete record	
	delete t_itmfg where titm_id=@titm_id
end
		
