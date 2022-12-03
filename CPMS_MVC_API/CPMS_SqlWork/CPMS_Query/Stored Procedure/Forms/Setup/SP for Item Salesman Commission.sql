USE NATHI
GO

--alter table t_itmsalcom add bd_id int,itmsub_id int
--alter table t_itmsalcom add constraint FK_titmsalcom_BDID foreign key (bd_id) references m_bd(bd_id)
--alter table t_itmsalcom add constraint FK_titmsalcom_ITMSUBID foreign key (itmsub_id) references m_itmsub(itmsub_id)

--alter table t_itmsalcom add cus_id int
--alter table t_itmsalcom add constraint FK_titmsalcom_CUSID foreign key (cus_id) references m_cus (cus_id)
--alter table t_itmsalcom add cuscat_id int
--alter table t_itmsalcom add constraint FK_titmsalcom_CUSCATID foreign key (cuscat_id) references m_cuscat (cuscat_id)

--alter table t_itmsalcom add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--select * from t_itmsalcom

--Insert
alter proc [dbo].[ins_t_itmsalcom](@titmsalcom_dat datetime,@titmsalcom_comm float,@titmsalcom_act bit,@titmsalcom_typ char(1),@emppro_macid int,@titm_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@titmsalcom_id int,
@log_dat datetime,
@emppro_id int
begin
set @log_dat=GETDATE()

	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	set @titmsalcom_id=(select max(titmsalcom_id)+1 from t_itmsalcom)
		if @titmsalcom_id is null
			begin
				set @titmsalcom_id=1
			end
			
			
	----Insert
	insert into t_itmsalcom(titmsalcom_id,titmsalcom_dat,titmsalcom_comm,titmsalcom_act,titmsalcom_typ,emppro_id,titm_id,log_act,log_dat,usr_id,log_ip )
			values(@titmsalcom_id,@titmsalcom_dat,@titmsalcom_comm,@titmsalcom_act,@titmsalcom_typ,@emppro_id,@titm_id,@log_act,@log_dat,@usr_id,@log_ip)
			
		set @log_newval= 'ID=' + cast(@titmsalcom_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Delete
alter proc [dbo].[del_t_itmsalcom](@titmsalcom_dat datetime,@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@emppro_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
		set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
		delete from t_itmsalcom where emppro_id=@emppro_id and titmsalcom_dat=@titmsalcom_dat
			
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		

