
USE MFI
GO


alter proc [dbo].[ins_m_path](@path_act bit,@path_path varchar(250),@path_tab_nam varchar(100),@path_tab_id varchar(100),@path_tab_tim varchar(100),@path_utab_nam varchar(100),@path_utab_id varchar(100),@path_utab_macid varchar(100),@path_utab_unam varchar(100),@path_typ char(1),@path_id_out int output)
as
declare
@path_id int
begin
	
	set @path_id=(select max(path_id)+1 from m_path)

	if (@path_id is null)
		begin	
			set @path_id=1
		end
	insert into m_path (path_id,path_act,path_path,path_tab_nam,path_tab_id,path_tab_tim,path_utab_nam,path_utab_id,path_utab_macid,path_utab_unam,path_typ)
	values
	(@path_id,@path_act,@path_path,@path_tab_nam,@path_tab_id,@path_tab_tim,@path_utab_nam,@path_utab_id,@path_utab_macid,@path_utab_unam,@path_typ)

	set @path_id_out=@path_id

end
GO

--Update
alter proc [dbo].[upd_m_path](@path_id int,@path_act bit,@path_path varchar(250),@path_tab_nam varchar(100),@path_tab_id varchar(100),@path_tab_tim varchar(100),@path_utab_nam varchar(100),@path_utab_id varchar(100),@path_utab_macid varchar(100),@path_utab_unam varchar(100),@path_typ char(1))
as
begin

	update m_path 
			set path_act=@path_act,path_path=@path_path ,path_tab_nam=@path_tab_nam,path_tab_id=@path_tab_id,path_tab_tim=@path_tab_tim,path_utab_nam=@path_utab_nam,path_utab_id=@path_utab_id,path_utab_macid=@path_utab_macid,path_utab_unam=@path_utab_unam,path_typ=@path_typ
			where path_id=@path_id 
end
GO

--Delete
alter proc [dbo].[del_m_path](@path_id int)
as
begin
	delete from m_path  where path_id=@path_id
end
GO

