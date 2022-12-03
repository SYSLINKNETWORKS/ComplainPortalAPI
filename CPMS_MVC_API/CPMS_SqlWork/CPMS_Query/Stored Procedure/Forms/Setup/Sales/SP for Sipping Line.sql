
USE MFI
GO

create proc ins_m_shli(@com_id char(2),@br_id char(3),@yr_id char(2),@shli_nam varchar(100),@shli_cp varchar(100),@shli_add varchar(250),@shli_pho varchar(100),@shli_mob varchar(100),@shli_fax varchar(100),@shli_eml varchar(100),@shli_web varchar(100),@shli_ntn varchar(100),@shli_stn varchar(100),@shli_act bit,@shli_typ char(1),@shli_id_out int output)
as
declare
@shli_id int
begin
	set @shli_id=(select max(shli_id)+1 from m_shli)
		if @shli_id is null
			begin
				set @shli_id=1
			end
	insert into m_shli
			(shli_id,shli_nam,shli_add,shli_cp,shli_pho,shli_mob,shli_fax, shli_eml,shli_web,shli_ntn,shli_stn,shli_act,shli_typ)
	values(@shli_id,@shli_nam,@shli_add,@shli_cp,@shli_pho,@shli_mob,@shli_fax,@shli_eml,@shli_web,@shli_ntn,@shli_stn,@shli_act,@shli_typ)

		set @shli_id_out=@shli_id

end	

go

--Update
create proc upd_m_shli(@com_id char(2),@br_id char(3),@yr_id char(2),@shli_id int,@shli_nam varchar(100),@shli_add varchar(250),@shli_cp varchar(100),@shli_pho varchar(100),@shli_mob varchar(100),@shli_fax varchar(100),@shli_eml varchar(100),@shli_web varchar(100),@shli_ntn varchar(100),@shli_stn varchar(100),@shli_act bit,@shli_typ char(1))
as
begin
	update m_shli set shli_nam=@shli_nam,shli_cp=@shli_cp,shli_add=@shli_add,shli_pho=@shli_pho,shli_mob=@shli_mob,shli_fax=@shli_fax,shli_eml=@shli_eml,shli_web=@shli_web,shli_ntn=@shli_ntn,@shli_stn=@shli_stn,shli_act=@shli_act, shli_typ=@shli_typ where shli_id=@shli_id


end	
go

--select * from m_shli
--exec del_m_shli '01','01',6
--Delete
create  proc del_m_shli(@com_id char(3),@br_id char(3),@shli_id int)
as
begin
			--Delete shliplier
			delete from m_shli where shli_id=@shli_id
end

GO
