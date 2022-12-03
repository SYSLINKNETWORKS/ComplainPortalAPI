USE ZSons
GO


--Insert
alter proc ins_t_dinv_dc(@minv_id int,@mdc_id int)
as
declare
@dinv_dc_id int
begin
	set @dinv_dc_id=(select max(dinv_dc_id)+1 from t_dinv_dc)
		if @dinv_dc_id is null
			begin	
				set @dinv_dc_id=1
			end
	insert into t_dinv_dc(dinv_dc_id,minv_id,mdc_id)
			values(@dinv_dc_id,@minv_id,@mdc_id)
			
	update t_mdc set mdc_typ='S',mdc_act=1 where mdc_id=@mdc_id
	

end
		
go

--Delete
alter proc del_t_dinv_dc(@minv_id int)
as
declare
@mdc_id int
begin

	update t_mdc set mdc_typ='U',mdc_act=0 where mdc_id in (select mdc_id from t_dinv_dc where minv_id=@minv_id)
	--Delete Record
	delete from t_dinv_dc where minv_id=@minv_id
end