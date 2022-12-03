USE phm
go

--Insert
alter proc [dbo].[ins_m_ddoc](@ddoc_con varchar(100),@ddoc_timfrm datetime,@ddoc_timto datetime,@mdoc_id int,@hos_id int,@log_act char(1),@usr_id int,@log_ip varchar(100))
as
declare
@ddoc_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @ddoc_id=(select max(ddoc_id)+1 from m_ddoc)
		if @ddoc_id is null
			begin
				set @ddoc_id=1
			end
	insert into m_ddoc(ddoc_id,ddoc_con,ddoc_timfrm,ddoc_timto,mdoc_id,hos_id,log_act,log_dat,usr_id,log_ip)
			values(@ddoc_id,@ddoc_con,@ddoc_timfrm,@ddoc_timto,@mdoc_id,@hos_id,@log_act,@log_dat,@usr_id,@log_ip)
		
end
GO

----Update
--alter proc [dbo].[upd_m_ddoc](@ddoc_id int,@ddoc_nam varchar(250),@ddoc_act bit,@ddoc_typ char(1),@ddoc_pho varchar(100),@ddoc_mob varchar(100),@ddoc_fax varchar(100),@ddoc_eml varchar(100),@doccat_id int,@spo_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
--as
--declare
--@log_dat datetime
--begin
--set @log_dat=GETDATE()
--	update m_ddoc set ddoc_nam=@ddoc_nam,ddoc_act=@ddoc_act,ddoc_typ=@ddoc_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where ddoc_id=@ddoc_id
	
--	--Audit
--exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

--end
--GO


--Delete
alter proc [dbo].[del_m_ddoc](@mdoc_id int,@log_act char(1),@usr_id int,@log_ip varchar(100))
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_ddoc set log_act=@log_act where mdoc_id=@mdoc_id	

end
		

