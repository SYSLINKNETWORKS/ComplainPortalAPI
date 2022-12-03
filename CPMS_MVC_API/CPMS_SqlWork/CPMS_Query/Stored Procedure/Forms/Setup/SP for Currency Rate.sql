use phm
go
--select * from m_currat

--alter table m_currat add currat_orat float
--update m_currat set currat_orat=0
--alter table m_currat add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)


--Insert
alter proc ins_m_currat(@currat_dat datetime,@cur_id int,@currat_rat float,@currat_orat float,@currat_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@currat_id_out int output)
as
declare
@currat_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @currat_id=(select max(currat_id)+1 from m_currat)
		if @currat_id is null
			begin
				set @currat_id=1
			end
	insert into m_currat(currat_id,currat_dat,cur_id,currat_rat,currat_orat,currat_typ,log_act,log_dat,usr_id,log_ip)
					values (@currat_id,@currat_dat,@cur_id,@currat_rat,@currat_orat,@currat_typ,@log_act,@log_dat,@usr_id,@log_ip)

	set @currat_id_out=@currat_id
	
	set @log_newval= 'ID=' + cast(@currat_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
go		

--Update
alter proc upd_m_currat(@currat_id int,@currat_dat datetime,@cur_id int,@currat_rat float,@currat_orat float,@currat_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_currat set currat_dat=@currat_dat,cur_id=@cur_id,currat_rat=@currat_rat,currat_orat=@currat_orat,currat_typ=@currat_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where currat_id=@currat_id
	
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		
go
--Delete
alter proc del_m_currat(@currat_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	delete m_currat where currat_id=@currat_id

	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		