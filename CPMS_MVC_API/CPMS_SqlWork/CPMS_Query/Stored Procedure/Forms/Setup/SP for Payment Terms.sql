USE phm
GO
--Insert
alter proc [dbo].[ins_m_pat](@pat_nam varchar(1000),@pat_act bit,@pat_typ char(1),@pat_id_out int output)
as
declare
@pat_id int
begin
	set @pat_id=(select max(pat_id)+1 from m_pat)
		if @pat_id is null
			begin
				set @pat_id=1
			end
	insert into m_pat(pat_id,pat_nam,pat_act,pat_typ )
			values(@pat_id,@pat_nam,@pat_act,@pat_typ)
		
		set @pat_id_out =@pat_id

end
GO

create proc [dbo].[upd_m_pat](@pat_id int,@pat_nam varchar(1000),@pat_act bit,@pat_typ char(1))
as
begin
	update m_pat set pat_nam=@pat_nam,pat_act=@pat_act,pat_typ=@pat_typ where pat_id=@pat_id
		
		

end
GO

--Delete
alter proc [dbo].[del_m_pat] (@pat_id int)
as
begin
	delete m_pat where pat_id=@pat_id
end
		

--select * from m_pat
