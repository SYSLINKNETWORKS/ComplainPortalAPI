USE MFI
GO

--select * from m_mscfg

--Insert
alter proc [dbo].[ins_m_mscfg](@mscfg_dat datetime,@itmsub_id int,@mscfg_act bit,@mscfg_typ char(1),@m_yr_id char(2),@mscfg_id_out int output)
as
declare
@mscfg_id int
begin
	set @mscfg_id=(select max(mscfg_id)+1 from m_mscfg)
		if @mscfg_id is null
			begin
				set @mscfg_id=1
			end
	insert into m_mscfg(mscfg_id,mscfg_dat,mscfg_act,mscfg_typ,itmsub_id,m_yr_id)
			values(@mscfg_id,@mscfg_dat,@mscfg_act,@mscfg_typ,@itmsub_id,@m_yr_id)
		set @mscfg_id_out=@mscfg_id

end
GO

--Update
alter proc [dbo].[upd_m_mscfg](@mscfg_id int,@mscfg_dat datetime,@itmsub_id int,@mscfg_act bit,@mscfg_typ char(1))
as
begin
	update m_mscfg set mscfg_dat=@mscfg_dat,itmsub_id=@itmsub_id,mscfg_act=@mscfg_act,mscfg_typ=@mscfg_typ where mscfg_id=@mscfg_id
end
GO


--Delete
alter proc [dbo].[del_m_mscfg](@mscfg_id int)
as
begin
	exec del_m_dscfg @mscfg_id
	delete m_mscfg where mscfg_id=@mscfg_id
end
		

