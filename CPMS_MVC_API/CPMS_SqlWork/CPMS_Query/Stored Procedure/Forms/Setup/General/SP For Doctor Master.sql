USE phm
go

--Insert
alter proc [dbo].[ins_m_mdoc](@mdoc_nam varchar(250),@mdoc_act bit,@mdoc_typ char(1),@mdoc_pho varchar(100),@mdoc_mob varchar(100),@mdoc_fax varchar(100),@mdoc_eml varchar(100),@doccat_id int,@spo_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mdoc_id_out int output)
as
declare
@mdoc_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @mdoc_id=(select max(mdoc_id)+1 from m_mdoc)
		if @mdoc_id is null
			begin
				set @mdoc_id=1
			end
	insert into m_mdoc(mdoc_id,mdoc_nam,mdoc_act,mdoc_typ,mdoc_pho,mdoc_mob,mdoc_fax,mdoc_eml,doccat_id,spo_id,log_act,log_dat,usr_id,log_ip)
			values(@mdoc_id,@mdoc_nam,@mdoc_act,@mdoc_typ,@mdoc_pho,@mdoc_mob,@mdoc_fax,@mdoc_eml,@doccat_id,@spo_id,@log_act,@log_dat,@usr_id,@log_ip)
		set @mdoc_id_out=@mdoc_id
		
		set @log_newval= 'ID=' + cast(@mdoc_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
alter proc [dbo].[upd_m_mdoc](@mdoc_id int,@mdoc_nam varchar(250),@mdoc_act bit,@mdoc_typ char(1),@mdoc_pho varchar(100),@mdoc_mob varchar(100),@mdoc_fax varchar(100),@mdoc_eml varchar(100),@doccat_id int,@spo_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_mdoc set mdoc_nam=@mdoc_nam,mdoc_act=@mdoc_act,mdoc_typ=@mdoc_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where mdoc_id=@mdoc_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
alter proc [dbo].[del_m_mdoc](@mdoc_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_mdoc set log_act=@log_act where mdoc_id=@mdoc_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

