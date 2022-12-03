USE PHM
GO
--alter table m_mensubcat add mensubcat_col int,mensubcat_colnam varchar(250)
--alter table m_mensubcat drop column mensubcat_col
--alter table m_mensubcat drop column mensubcat_colnam

--Insert

alter proc [dbo].[ins_m_mensubcat](@mensubcat_nam varchar(250),@mensubcat_typ char(1),@mensubcat_act bit,@mencat_id int,@mensubcat_id_out int output)
as
declare
@mensubcat_id int
begin
	set @mensubcat_id=(select max(mensubcat_id)+1 from m_mensubcat)
		if @mensubcat_id is null
			begin
				set @mensubcat_id=1
			end
	insert into m_mensubcat(mensubcat_id,mensubcat_nam,mensubcat_typ,mensubcat_act,mencat_id)
					values (@mensubcat_id,@mensubcat_nam,@mensubcat_typ,@mensubcat_act,@mencat_id)

	set @mensubcat_id_out=@mensubcat_id
end

GO

--Update
alter proc [dbo].[upd_m_mensubcat](@mensubcat_id int,@mensubcat_nam varchar(250),@mensubcat_typ char(1),@mensubcat_act bit,@mencat_id int)
as
begin
	update m_mensubcat set mensubcat_nam=@mensubcat_nam,mensubcat_typ=@mensubcat_typ,mensubcat_act=@mensubcat_act,mencat_id=@mencat_id where mensubcat_id=@mensubcat_id
end

go	
		
--Delete
alter proc [dbo].[del_m_mensubcat](@mensubcat_id int)
as
begin
	delete m_mensubcat where mensubcat_id=@mensubcat_id
end
GO
--select * from m_mensubcat

