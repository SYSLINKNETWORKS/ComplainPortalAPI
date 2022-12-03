USE phm
GO


--alter table m_carr add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)




alter proc ins_m_carr(@carr_nam varchar(100),@carr_add varchar(250),@carr_pho varchar(100),@carr_mob varchar(100),@carr_fax varchar(100),@carr_eml varchar(100),@carr_web varchar(100),@carr_act bit,@carr_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@carr_id_out int output)
as
declare
@carr_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	set @carr_id=(select max(carr_id)+1 from m_carr)
		if @carr_id is null
			begin
				set @carr_id=1
			end	


	insert into m_carr
			(carr_id,carr_nam,carr_add,carr_pho,carr_mob,carr_fax, carr_eml,carr_web,carr_act,carr_typ,log_act,log_dat,usr_id,log_ip)
		 values(@carr_id,@carr_nam,@carr_add,@carr_pho,@carr_mob,@carr_fax,@carr_eml,@carr_web,@carr_act,@carr_typ,@log_act,@log_dat,@usr_id,@log_ip)

		set @carr_id_out=@carr_id
		
		
		set @log_newval= 'ID=' + cast(@carr_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
end	
go

--Update
alter proc upd_m_carr(@carr_id int,@carr_nam varchar(100),@carr_add varchar(250),@carr_pho varchar(100),@carr_mob varchar(100),@carr_fax varchar(100),@carr_eml varchar(100),@carr_web varchar(100),@carr_act bit,@carr_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	update m_carr set carr_nam=@carr_nam,carr_add=@carr_add,carr_pho=@carr_pho,carr_mob=@carr_mob,carr_fax=@carr_fax,carr_eml=@carr_eml,carr_web=@carr_web,carr_act=@carr_act,carr_typ=@carr_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where carr_id=@carr_id
--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end	
go
--Delete
alter  proc del_m_carr(@carr_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin	
set @log_dat=GETDATE()
	--Delete carrier	
	update m_carr set log_act=@log_act  where carr_id=@carr_id
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end

GO
