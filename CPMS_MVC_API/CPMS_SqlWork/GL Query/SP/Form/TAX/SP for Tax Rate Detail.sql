USE ZSons
GO

--Insert

create proc [dbo].[ins_m_dtaxrat](@dtaxrat_per float,@taxrat_id int)
as
declare
@dtaxrat_id int
begin
	set @dtaxrat_id=(select max(dtaxrat_id)+1 from m_dtaxrat)
		if @dtaxrat_id is null
			begin
				set @dtaxrat_id=1
			end
	insert into m_dtaxrat(dtaxrat_id,dtaxrat_per,taxrat_id)
			values(@dtaxrat_id,@dtaxrat_per,@taxrat_id)


end
GO


--Delete
create proc [dbo].[del_m_dtaxrat](@taxrat_id int)
as
begin
	
	delete m_dtaxrat where taxrat_id=@taxrat_id 
end
	