USE Zsons
GO


--Insert
alter proc [dbo].[ins_m_dcs](@dcs_per float,@cs_id int,@mcs_id int)
as
declare
@dcs_id int
begin
	set @dcs_id=(select max(dcs_id)+1 from m_dcs)
		if @dcs_id is null
			begin
				set @dcs_id=1
			end
	insert into m_dcs(dcs_id,dcs_per,cs_id,mcs_id)
			values(@dcs_id,@dcs_per,@cs_id,@mcs_id)

end
GO

--Delete
alter proc [dbo].[del_m_dcs](@mcs_id int)
as
begin
	delete m_dcs where mcs_id=@mcs_id
end
		