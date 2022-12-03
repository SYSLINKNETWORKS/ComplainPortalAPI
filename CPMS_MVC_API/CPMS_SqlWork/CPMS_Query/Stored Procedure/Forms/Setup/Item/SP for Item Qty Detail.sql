

USE MFI
GO


--Insert
alter proc ins_t_itmqty(@itmqty_id int,@titm_id int,@titmqty_typ char(1),@titmqty_id_out int output)
as
declare
@titmqty_id int
begin
		set @titmqty_id=(select max(titmqty_id)+1 from t_itmqty)
		if @titmqty_id is null
			begin
				set @titmqty_id=1
			end
		
		insert into t_itmqty(titmqty_id,itmqty_id,titm_id,titmqty_typ)
			values (@titmqty_id,@itmqty_id,@titm_id,@titmqty_typ)
	
		set @titmqty_id_out=@titmqty_id

end
go



--Delete
alter proc del_t_itmqty(@titm_id int)
as
begin
	--Delete record	
	delete t_itmqty where titm_id=@titm_id
end
		
