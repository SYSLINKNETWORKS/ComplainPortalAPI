USE PAGEY
GO
--drop proc ins_m_prom_cus 
--drop proc del_m_prom_cus 

--Insert
create proc [dbo].[ins_m_prom_cus](@cus_id int,@prom_id int,@prom_cus_id_out int output)
as
declare
@prom_cus_id int
begin
	set @prom_cus_id=(select max(prom_cus_id)+1 from m_prom_cus)
		if @prom_cus_id is null
			begin
				set @prom_cus_id=1
			end
	insert into m_prom_cus(prom_cus_id,cus_id,prom_id )
			values(@prom_cus_id,@cus_id,@prom_id)
		set @prom_cus_id_out=@prom_cus_id

end
GO


--Delete
create proc [dbo].[del_m_prom_cus](@prom_id int)
as
begin
	delete m_prom_cus where prom_id=@prom_id
end
		

