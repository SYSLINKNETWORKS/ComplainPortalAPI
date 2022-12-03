USE phm
GO
--alter table t_dsupadv add dsupadv_gstwhtper float,dsupadv_gstwhtamt float
--update t_dsupadv set dsupadv_gstwhtper=0,dsupadv_gstwhtamt=0

--Insert
alter  proc sp_ins_dsupadv(@com_id char(2),@br_id char(3),@m_yr_id char(2),@dsupadv_amt float,@dsupadv_gstwhtper float,@dsupadv_gstwhtamt float,@bal float,@mpb_id int,@supadv_id int)
as
declare
@dsupadv_id int
begin
	set @dsupadv_id=(select max(dsupadv_id)+1 from t_dsupadv )
		if @dsupadv_id is null
			begin
				set @dsupadv_id=1
			end

	--Inserting the record
	insert into t_dsupadv (dsupadv_id,dsupadv_amt,dsupadv_gstwhtper,dsupadv_gstwhtamt,mpb_id,supadv_id)
	values(@dsupadv_id,@dsupadv_amt,@dsupadv_gstwhtper,@dsupadv_gstwhtamt,@mpb_id,@supadv_id)	
	
	if (@bal=0)
		begin
			update t_mpb set mpb_st=1 where mpb_id=@mpb_id
		end	
			
		
end
go

--Delete
alter  proc sp_del_dsupadv(@com_id char(2),@br_id char(3),@m_yr_id char(2),@supadv_id int)
as
begin

	update t_mpb set mpb_st=0 where mpb_id in (select mpb_id from t_dsupadv where dsupadv_amt<>0 )	
	delete from t_dsupadv where supadv_id=@supadv_id

end


