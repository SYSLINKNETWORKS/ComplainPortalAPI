USE PAGEY
GO


--lot_id int,lot_nam varchar(250),lot_typ char(1),lot_act bit
--alter table m_lot add sup_id int
--alter table m_lot add itm_sn int
--alter table m_lot add itm_qty int
--alter table m_lot add dgrn_id int
----alter table m_lot add titm_shrnam char(10) 
--alter table m_lot drop column mgrn_id 
--alter table m_lot drop fk_lot_mgrnid



alter proc ins_m_lot(@lot_nam varchar(1000),@lot_act bit,@lot_typ char(1),@lot_id_out int output)
as
declare
@lot_id int
begin
set @lot_id =(select max(lot_id)+1 from m_lot)
		if (@lot_id is null)
			begin
				set @lot_id=1
			end
insert into m_lot
		(lot_id,lot_nam,lot_act,lot_typ)
	values(@lot_id,@lot_nam,@lot_act,@lot_typ)
	
	set @lot_id_out=@lot_id
				
end
go

alter proc del_m_lot(@lot_id int)
as
begin

delete from m_lot where lot_id=@lot_id


end
go



