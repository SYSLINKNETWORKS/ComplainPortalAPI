USE MEIJI
GO

--alter table m_drv add drv_add varchar(250)
--alter table m_drv add drv_mob varchar(250)
--alter table m_drv add drv_sal float

--Insert
alter proc ins_m_drv(@drv_nam varchar(250),@drv_typ char(1),@drv_act bit,@drv_add varchar(250),@drv_mob varchar(250),@drv_sal float,@drv_id_out int output)
as
declare
@drv_id int
begin
	set @drv_id=(select max(drv_id)+1 from m_drv)
		if @drv_id is null
			begin
				set @drv_id=1
			end
	insert into m_drv(drv_id,drv_nam,drv_typ,drv_act,drv_add,drv_mob,drv_sal)
					values (@drv_id,@drv_nam,@drv_typ,@drv_act,@drv_add,@drv_mob,@drv_sal)

	set @drv_id_out=@drv_id
end
go		

--Update
alter proc upd_m_drv(@drv_id int,@drv_nam varchar(250),@drv_typ char(1),@drv_act bit,@drv_add varchar(250),@drv_mob varchar(250),@drv_sal float)
as
begin
	update m_drv set drv_nam=@drv_nam,drv_typ=@drv_typ,drv_act=@drv_act,drv_add=@drv_add,drv_mob=@drv_mob,drv_sal=@drv_sal where drv_id=@drv_id
end
		
go
--Delete
alter proc del_m_drv(@drv_id int)
as
begin
	delete m_drv where drv_id=@drv_id
end
		