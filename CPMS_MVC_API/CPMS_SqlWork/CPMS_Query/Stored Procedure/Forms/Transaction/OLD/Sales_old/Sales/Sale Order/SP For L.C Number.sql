USE PAGEY
GO

create proc ins_m_lc(@lc_nam varchar(250),@lc_typ char(1),@lc_id_out int output)
as
declare
@lc_id int
begin
set @lc_id =(select max(lc_id)+1 from m_lc)
		if (@lc_id is null)
			begin
				set @lc_id=1
			end
insert into m_lc
		(lc_id,lc_nam,lc_typ)
	values(@lc_id,@lc_nam,@lc_typ)
	
	set @lc_id_out=@lc_id
				
end
go

create proc del_m_lc(@lc_id int)
as
begin

delete from m_lc where lc_id=@lc_id


end
go



