USE zsons
GO
--alter table t_dcusadv add dcusadv_gstwhtper float,dcusadv_gstwhtamt float
--update t_dcusadv set dcusadv_gstwhtper=0,dcusadv_gstwhtamt=0

--Insert
alter  proc sp_ins_dcusadv(@dcusadv_amt float,@dcusadv_gstwhtper float,@dcusadv_gstwhtamt float,@bal float,@minv_id int,@cusadv_id int)
as
declare
@dcusadv_id int,
@cusadv_taxid int
begin
	set @dcusadv_id=(select max(dcusadv_id)+1 from t_dcusadv )
		if @dcusadv_id is null
			begin
				set @dcusadv_id=1
			end

	--Inserting the record
	insert into t_dcusadv (dcusadv_id,dcusadv_amt,dcusadv_gstwhtper,dcusadv_gstwhtamt,minv_id,cusadv_id)
	values(@dcusadv_id,@dcusadv_amt,@dcusadv_gstwhtper,@dcusadv_gstwhtamt,@minv_id,@cusadv_id)	
	
	if (@bal=0)
		begin
			update t_minv set minv_act=1 where minv_id=@minv_id
		end	
			
		
end
go

--Delete
alter  proc sp_del_dcusadv(@cusadv_id int)
as
begin

	update t_minv set minv_act=0 where minv_id in (select minv_id from t_dcusadv where dcusadv_amt<>0 )	
	delete from t_dcusadv where cusadv_id=@cusadv_id

end


