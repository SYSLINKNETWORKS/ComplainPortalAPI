----Insert Deparment
ALTER proc [dbo].[ins_dpt](@dpt_nam varchar(100),@dpt_typ char(1),@dpt_id_out char(2) output)
as
declare 
@dpt_id char(2)
begin
	set @dpt_id =dbo.autonumber((select max(dpt_id) from m_dpt),2)
	insert into 
	m_dpt(dpt_id,dpt_nam,dpt_typ)
		values
	(@dpt_id,@dpt_nam,@dpt_typ)
	set @dpt_id_out=@dpt_id
end
GO


----Update Department

ALTER proc [dbo].[upd_dpt](@dpt_id char(2), @dpt_nam varchar(100),@dpt_typ char(1))
as
update m_dpt set dpt_nam=@dpt_nam ,dpt_typ=@dpt_typ
		where dpt_id=@dpt_id
GO

----Delete the Department
ALTER proc [dbo].[del_dpt](@dpt_id char(2))
as
delete from m_dpt 
		where dpt_id=@dpt_id
GO
