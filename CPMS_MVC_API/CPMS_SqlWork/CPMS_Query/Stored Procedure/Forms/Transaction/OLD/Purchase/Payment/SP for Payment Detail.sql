USE PHM
GO

--select * from t_dpb where mpb_id=9

--exec sp_ins_dpay 513,0,103,37,'01',1
--exec sp_del_dpay 37
--alter table t_dpay add dpay_roff bit ,dpay_whper float,dpay_whtax float,dpay_namt float
--update t_dpay set dpay_roff=0,dpay_whper=0,dpay_whtax=0,dpay_namt=dpay_amt

--alter table t_dpay add dpay_gstwhtper float,dpay_gstwhtamt float
--update t_dpay set dpay_gstwhtper=0,dpay_gstwhtamt=0

--select * from t_dpay



--Insert the record
alter  proc sp_ins_dpay(@dpay_famt float,@dpay_roff bit,@dpay_whper float,@dpay_whtax float,@dpay_gstwhtper float,@dpay_gstwhtamt float,@dpay_namt float,@dpay_epl float,@dpay_bal float,@mpb_id int,@mpay_id int,@m_yr_id char(2),@row_id int)
as
declare
	@dpay_id int,
	@dpb_amount float,
	@dpay_amount float,
	@dpay_amt float,
	@mpay_rat float,
	@mpay_can bit,
	@mpay_cktax bit
begin
	set @mpay_rat=(select mpay_rat from t_mpay where mpay_id=@mpay_id)
	set @dpay_amt=@dpay_famt*@mpay_rat
	set @mpay_can=(select mpay_can from t_mpay where mpay_id=@mpay_id)
	set @mpay_cktax=(select mpay_cktax from t_mpay where mpay_id=@mpay_id)

	set @dpay_id =(select max(dpay_id)+1 from t_dpay )
		if @dpay_id is null
			begin
				set @dpay_id=1
			end
	--Insert Record
	insert into t_dpay (dpay_id,dpay_famt,dpay_amt,dpay_roff,dpay_whper,dpay_whtax,dpay_gstwhtper,dpay_gstwhtamt,dpay_namt,dpay_epl,mpb_id,mpay_id,m_yr_id)
				values(@dpay_id,@dpay_famt,@dpay_famt,@dpay_roff,@dpay_whper,@dpay_whtax,@dpay_gstwhtper,@dpay_gstwhtamt,@dpay_namt,@dpay_epl,@mpb_id,@mpay_id,@m_yr_id)
	
	
	if (@dpay_bal=0 and @mpay_can=0)
		begin
			update t_dpb set dpb_st=1 where mpb_id=@mpb_id
			update t_mpb set mpb_st=1 where mpb_id=@mpb_id
		end
end
go

--sp_del_dpay 37

--Delete Record
alter  proc sp_del_dpay(@mpay_id int)
as
begin
	update t_dpb set dpb_st=0 where mpb_id in (select mpb_id from t_dpay where mpay_id=@mpay_id and dpay_amt<>0)
	update t_mpb set mpb_st=0 where mpb_id in (select mpb_id from t_dpay where mpay_id=@mpay_id)
	delete from t_dpay where mpay_id =@mpay_id
end

