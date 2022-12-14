

----Insert Bank Type
ALTER proc [dbo].[ins_m_bktyp](@bktyp_nam varchar(100),@bktyp_typ char(1),@bktyp_id_out char(2) output)
as
declare
@bktyp_id			char(2)
begin
set @bktyp_id =(select max(bktyp_id) from gl_m_bktyp)
	--autonumber
	set @bktyp_id =dbo.autonumber(@bktyp_id,(select col_length('gl_m_bktyp','bktyp_id')))
	insert into gl_m_bktyp (bktyp_id,bktyp_nam,bktyp_typ)
	values
	(@bktyp_id,@bktyp_nam,@bktyp_typ)
	set @bktyp_id_out=@bktyp_id
end
GO


----UPdate bank Type

ALTER proc [dbo].[upd_m_bktyp](@bktyp_id char(2),@bktyp_nam varchar(100),@bktyp_typ char(1))
as
update gl_m_bktyp 
		set bktyp_nam=@bktyp_nam ,bktyp_typ=@bktyp_typ
		where bktyp_id=@bktyp_id
GO



--Delete Bank Type
ALTER proc [dbo].[del_m_bktyp](@bktyp_id char(2))
as
delete from gl_m_bktyp  
		where bktyp_id=@bktyp_id
GO
