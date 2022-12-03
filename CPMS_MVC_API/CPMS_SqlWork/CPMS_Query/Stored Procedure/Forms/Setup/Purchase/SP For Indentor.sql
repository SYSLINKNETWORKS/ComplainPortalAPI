USE phm
GO


--alter table m_ind add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)




create proc ins_m_ind(@ind_nam varchar(100),@ind_add varchar(250),@ind_pho varchar(100),@ind_mob varchar(100),@ind_fax varchar(100),@ind_eml varchar(100),@ind_web varchar(100),@ind_act bit,@ind_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@ind_id_out int output)
as
declare
@ind_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	set @ind_id=(select max(ind_id)+1 from m_ind)
		if @ind_id is null
			begin
				set @ind_id=1
			end	


	insert into m_ind
			(ind_id,ind_nam,ind_add,ind_pho,ind_mob,ind_fax, ind_eml,ind_web,ind_act,ind_typ,log_act,log_dat,usr_id,log_ip)
		 values(@ind_id,@ind_nam,@ind_add,@ind_pho,@ind_mob,@ind_fax,@ind_eml,@ind_web,@ind_act,@ind_typ,@log_act,@log_dat,@usr_id,@log_ip)

		set @ind_id_out=@ind_id
		
		
		set @log_newval= 'ID=' + cast(@ind_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
end	
go

--Update
create proc upd_m_ind(@ind_id int,@ind_nam varchar(100),@ind_add varchar(250),@ind_pho varchar(100),@ind_mob varchar(100),@ind_fax varchar(100),@ind_eml varchar(100),@ind_web varchar(100),@ind_act bit,@ind_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	update m_ind set ind_nam=@ind_nam,ind_add=@ind_add,ind_pho=@ind_pho,ind_mob=@ind_mob,ind_fax=@ind_fax,ind_eml=@ind_eml,ind_web=@ind_web,ind_act=@ind_act,ind_typ=@ind_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where ind_id=@ind_id
--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end	
go
--Delete
create  proc del_m_ind(@ind_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin	
set @log_dat=GETDATE()
	--Delete indier	
	update m_ind set log_act=@log_act  where ind_id=@ind_id
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end

GO
