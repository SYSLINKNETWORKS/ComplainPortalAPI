USE MFI
GO

--select * from m_mscexp

--Insert
alter proc [dbo].[ins_m_mscexp](@mscexp_dat datetime,@itmsub_id int,@mscexp_act bit,@mscexp_typ char(1),@m_yr_id char(2),@mscexp_id_out int output)
as
declare
@mscexp_id int
begin
	set @mscexp_id=(select max(mscexp_id)+1 from m_mscexp)
		if @mscexp_id is null
			begin
				set @mscexp_id=1
			end
	insert into m_mscexp(mscexp_id,mscexp_dat,mscexp_act,mscexp_typ,itmsub_id,m_yr_id)
			values(@mscexp_id,@mscexp_dat,@mscexp_act,@mscexp_typ,@itmsub_id,@m_yr_id)
		set @mscexp_id_out=@mscexp_id

end
GO

--Update
alter proc [dbo].[upd_m_mscexp](@mscexp_id int,@mscexp_dat datetime,@itmsub_id int,@mscexp_act bit,@mscexp_typ char(1))
as
begin
	update m_mscexp set mscexp_dat=@mscexp_dat,itmsub_id=@itmsub_id,mscexp_act=@mscexp_act,mscexp_typ=@mscexp_typ where mscexp_id=@mscexp_id
end
GO


--Delete
alter proc [dbo].[del_m_mscexp](@mscexp_id int)
as
begin
	exec del_m_dscfg @mscexp_id
	delete m_mscexp where mscexp_id=@mscexp_id
end
		

