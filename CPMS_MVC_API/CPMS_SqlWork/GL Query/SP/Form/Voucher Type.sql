----Insert Voucher Type
ALTER proc [dbo].[ins_vch_typ](@com_id char(2),@br_id varchar(3),@typ_cat char(2),@typ_nam varchar(50),@typ_snm char(3),@acc_id char(20),@typ_id_out varchar(2) output)
as
declare
@vch_typ_id char(2)
begin
--for auto number
set @vch_typ_id=(select max(typ_id) from gl_vch_typ) 
set @vch_typ_id=dbo.autonumber(@vch_typ_id,2)
--for inserting
	insert into 
		gl_vch_typ (typ_id,typ_nam,typ_snm,typ_cat,acc_id,br_id,com_id)
	values
		(@vch_typ_id,@typ_nam,@typ_snm,@typ_cat,@acc_id,@br_id,@com_id)
--returning the id
	set @typ_id_out =@vch_typ_id
end
GO

----Update Voucher Type
ALTER proc [dbo].[upd_vch_typ](@com_id char(2),@br_id char(3),@typ_id char(2),@typ_cat char(2),@typ_nam varchar(50),@typ_snm char(3),@acc_id char(20))
as
update gl_vch_typ set 
				typ_cat =@typ_cat , typ_nam=@typ_nam, typ_snm=@typ_snm, acc_id=@acc_id	
		where com_id=@com_id and br_id=@br_id and typ_id=@typ_id
GO



----Delete Voucher Type
ALTER proc [dbo].[del_vch_typ](@com_id char(2),@br_id char(3),@typ_id varchar(2))
as
delete from gl_vch_typ 
	where com_id=@com_id and	br_id=@br_id and typ_id=@typ_id
GO






