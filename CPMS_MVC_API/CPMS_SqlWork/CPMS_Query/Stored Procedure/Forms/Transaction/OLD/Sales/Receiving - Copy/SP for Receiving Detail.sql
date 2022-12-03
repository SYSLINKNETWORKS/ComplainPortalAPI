USE NATHI
GO

--alter table t_drec add drec_roff bit ,drec_inper float,drec_intax float,drec_namt float
--update t_drec set drec_roff=0,drec_inper=0,drec_intax=0,drec_namt=drec_amt
--alter table t_drec add drec_gstwhtper float,drec_gstwhtamt float
--update t_drec set drec_gstwhtper=0,drec_gstwhtamt=0


--Insert the record
alter  proc sp_ins_drec(@drec_roff bit,@drec_amt float,@drec_inper float,@drec_intax float,@drec_gstwhtper float,@drec_gstwhtamt float,@drec_namt float,@drec_epl float,@drec_bal float,@minv_id int,@mrec_id int,@row_id int)
as
declare
	@drec_id int,
	@dinv_amount float,
	@drec_amount float,
	@mrec_cktax bit,
	@mrec_can bit
begin
	set @mrec_can=(select mrec_can from t_mrec where mrec_id=@mrec_id)
	set @mrec_cktax=(select mrec_cktax from t_mrec where mrec_id=@mrec_id)
	set @drec_id =(select max(drec_id)+1 from t_drec )
		if @drec_id is null
			begin
				set @drec_id=1
			end
	if (@mrec_cktax=0)
		begin
			set @drec_inper =0
			set @drec_intax=0
			set @drec_gstwhtper=0
			set @drec_gstwhtamt=0
			set @drec_namt=@drec_amt
		end
	--Insert Record
	insert into t_drec (drec_id,drec_roff,drec_amt,drec_inper,drec_intax,drec_gstwhtper,drec_gstwhtamt,drec_namt,drec_epl,minv_id,mrec_id)
				values(@drec_id,@drec_roff,@drec_amt,@drec_inper,@drec_intax,@drec_gstwhtper,@drec_gstwhtamt,@drec_namt,@drec_epl,@minv_id,@mrec_id)
	
	--Status of Bill
	--set @dinv_amount=(select sum(minv_namt) from t_minv where minv_id=@minv_id)
	--set @drec_amount=(select sum(drec_amt) from t_drec where mrec_id=@mrec_id and minv_id=@minv_id)
	--set @drec_amount=@drec_amount+isnull((select distinct isnull(cusadv_amt,0) from v_cusadv where minv_id=@minv_id),0)
	--if (@dinv_amount=@drec_amount)
	if (@drec_bal=0 and @mrec_can=0)
		begin
			update t_dinv set dinv_st=1 where minv_id=@minv_id
			update t_minv set minv_act=1,minv_typ='S' where minv_id=@minv_id
		end
	--set @dinv_amount=(select sum(dinv_amt) from t_dinv where dinv_st=1 and minv_id=@minv_id)
	--set @drec_amount=(select sum(drec_amt) from t_drec where mrec_id=@mrec_id)
	--set @drec_amount=@drec_amount+isnull((select distinct isnull(cusadv_amt,0) from v_cusadv where minv_id=@minv_id),0)

	--if (@dinv_amount=@drec_amount)
	--	begin
	--		update t_minv set minv_act=1,minv_typ='S' where minv_id=@minv_id
	--	end

	--Voucher
	if (@row_id=1)
		begin
			exec sp_voucher_rec @mrec_id
		end
end
go

--Delete Record
alter  proc sp_del_drec(@mrec_id int)
as
begin
	update t_dinv set dinv_st=0 where minv_id in (select minv_id from t_drec where mrec_id=@mrec_id)
	update t_minv set minv_act=0,minv_typ='U' where minv_id in (select minv_id from t_drec where mrec_id=@mrec_id)
	delete from t_drec where mrec_id =@mrec_id
end