USE Zsons
GO


--Insert
alter proc [dbo].[ins_m_mcs](@com_id char(2),@br_id char(3),@mcs_dat datetime,@mcs_act bit,@mcs_typ char(1),@acc_id char(20),@mcs_id_out int output)
as
declare
@mcs_id int

begin
	set @mcs_id=(select max(mcs_id)+1 from m_mcs)
		if @mcs_id is null
			begin
				set @mcs_id=1
			end
	insert into m_mcs(com_id,br_id,mcs_id,mcs_dat,mcs_act,mcs_typ,acc_id)
			values(@com_id,@br_id,@mcs_id,@mcs_dat,@mcs_act,@mcs_typ,@acc_id)

	set @mcs_id_out=@mcs_id

end
GO

use zsons
go
alter proc [dbo].[upd_m_mcs](@com_id char(2),@br_id char(3),@mcs_id int,@mcs_dat datetime,@mcs_act bit,@mcs_typ char(1),@acc_id char(20))
as
begin
	update m_mcs set com_id=@com_id,br_id=@br_id, mcs_dat=@mcs_dat,mcs_act=@mcs_act,mcs_typ=@mcs_typ, acc_id=@acc_id where mcs_id=@mcs_id
end
go

--Delete
alter proc [dbo].[del_m_mcs](@mcs_id int)
as
begin
	--Delete Detail Record
	exec [del_m_dcs] @mcs_id
	--Master Record
	delete m_mcs where mcs_id=@mcs_id
end
		