USE MFI
GO
--select * from t_pat

alter proc [dbo].[ins_t_pat](@pat_id int,@tpat_ck bit,@mpso_id int,@cus_id int,@tpat_id_out int output)
as
declare
@tpat_id int
begin
	set @tpat_id=(select max(tpat_id)+1 from t_pat)
		if @tpat_id is null
			begin
				set @tpat_id=1
			end
	insert into t_pat(tpat_id,pat_id,tpat_ck,mpso_id,cus_id)
			values(@tpat_id,@pat_id,@tpat_ck,@mpso_id,@cus_id)
		set @tpat_id_out=@tpat_id

end
GO

--Update


--alter proc [dbo].[upd_m_pat](@pat_id int,@cus_id int,@pat_nam varchar(1000),@pat_act bit,@pat_typ char(1))
--as
--begin
--	update m_pat set cus_id=@cus_id, pat_nam=@pat_nam,pat_act=@pat_act,pat_typ=@pat_typ where pat_id=@pat_id
--end
--GO


--Delete
alter proc [dbo].[del_t_pat](@cus_id int,@mpso_id int)
as
begin
	delete t_pat where cus_id=@cus_id and mpso_id=@mpso_id
end
		

