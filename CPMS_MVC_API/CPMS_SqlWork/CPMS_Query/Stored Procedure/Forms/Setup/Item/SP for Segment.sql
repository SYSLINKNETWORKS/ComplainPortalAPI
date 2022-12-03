USE phm
GO

--Insert
alter proc [dbo].[ins_m_seg](@seg_nam varchar(250),@seg_act bit,@seg_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@seg_id_out int output)
as
declare
@seg_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @seg_id=(select max(seg_id)+1 from m_seg)
		if @seg_id is null
			begin
				set @seg_id=1
			end
		insert into m_seg(seg_id,seg_nam,seg_act,seg_typ,log_act,log_dat,usr_id,log_ip)
			values(@seg_id,@seg_nam,@seg_act,@seg_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @seg_id_out=@seg_id
		
		set @log_newval= 'ID=' + cast(@seg_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO

--Upadte
alter proc [dbo].[upd_m_seg](@seg_id int,@seg_nam varchar(250),@seg_act bit,@seg_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
		update m_seg set seg_nam=@seg_nam,seg_act=@seg_act,seg_typ=@seg_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip 
		where seg_id=@seg_id
	
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat  
end
GO

--Delete
alter proc [dbo].[del_m_seg](@seg_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_seg set log_act=@log_act where seg_id=@seg_id
	
	--Audit
	exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end