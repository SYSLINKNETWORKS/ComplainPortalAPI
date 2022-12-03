USE MFI
GO

--select * from m_dscfg_acc

--Insert
alter proc [dbo].[ins_m_dscfg_acc](@acc_id char(20),@sccat_id int,@mscexp_id int)
as
declare
@dscfgacc_id int
begin
	set @dscfgacc_id=(select max(dscfgacc_id)+1 from m_dscfg_acc)
		if @dscfgacc_id is null
			begin
				set @dscfgacc_id=1
			end
	insert into m_dscfg_acc(dscfgacc_id,acc_id,sccat_id,mscexp_id )
			values(@dscfgacc_id,@acc_id,@sccat_id,@mscexp_id)

end
GO



