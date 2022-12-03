USE NATHI
GO

--alter table t_itmrat add bd_id int,itmsub_id int
--alter table t_itmrat add constraint FK_TITMRAT_BDID foreign key (bd_id) references m_bd(bd_id)
--alter table t_itmrat add constraint FK_TITMRAT_ITMSUBID foreign key (itmsub_id) references m_itmsub(itmsub_id)

--alter table t_itmrat add cus_id int
--alter table t_itmrat add constraint FK_TITMRAT_CUSID foreign key (cus_id) references m_cus (cus_id)
--alter table t_itmrat add cuscat_id int
--alter table t_itmrat add constraint FK_TITMRAT_CUSCATID foreign key (cuscat_id) references m_cuscat (cuscat_id)

--alter table t_itmrat add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--select * from t_itmrat

--alter table t_itmrat add com_id char(2),br_id char(3),m_YR_id char(2)
--alter table t_itmrat add constraint FK_TITMRAT_COMID foreign key (com_id) references m_com(com_id)
--alter table t_itmrat add constraint FK_TITMRAT_BRID foreign key (br_id) references m_br(br_id)
--alter table t_itmrat add constraint FK_TITMRAT_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)
--UPDATE t_itmrat set com_id='01',br_id='02',m_yr_id='01'



--Insert
alter proc [dbo].[ins_t_itmrat](@com_id char(2),@br_id char(3),@m_yr_id char(2),@titmrat_dat datetime,@titmrat_wrat float,@titmrat_rrat float,@titmrat_act bit,@titmrat_typ char(1),@titm_id int,@itmqty_id int,@bd_id int,@itmsub_id int,@cuscat_id int,@cus_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@titmrat_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @titmrat_id=(select max(titmrat_id)+1 from t_itmrat)
		if @titmrat_id is null
			begin
				set @titmrat_id=1
			end
			if @itmsub_id=0
			begin
			set @itmsub_id=null
			end
			if @bd_id=0
			begin
			set @bd_id=null
			end
			if @cuscat_id=0
			begin
			set @cuscat_id=null
			end
			if @cus_id=0
			begin
			set @cus_id=null
			end
	----Delete
	--delete t_itmrat where titmrat_dat=@titmrat_dat and titmrat_typ=@titmrat_typ and titm_id=@titm_id and itmqty_id=@itmqty_id
	----Insert
	insert into t_itmrat(com_id,br_id,m_yr_id,titmrat_id,titmrat_dat,titmrat_wrat,titmrat_rrat,titmrat_act,titmrat_typ,titm_id,itmqty_id,itmsub_id,bd_id,cuscat_id,cus_id,log_act,log_dat,usr_id,log_ip )
			values(@com_id,@br_id,@m_yr_id,@titmrat_id,@titmrat_dat,@titmrat_wrat,@titmrat_rrat,@titmrat_act,@titmrat_typ,@titm_id,@itmqty_id,@itmsub_id,@bd_id,@cuscat_id,@cus_id,@log_act,@log_dat,@usr_id,@log_ip)
			
		set @log_newval= 'ID=' + cast(@titmrat_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO
----Update
--alter proc [dbo].[upd_t_itmrat](@com_id int,@br_id int,@titmrat_dat datetime,@titmrat_wrat float,@titmrat_rrat float,@titmrat_act bit,@titmrat_typ char(1),@titm_id int,@itmqty_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
--as
--declare
--@aud_act char(10)
--begin
--	set @aud_act='Update'
--	update t_itmrat set titmrat_wrat=@titmrat_wrat,titmrat_rrat=@titmrat_rrat,itmqty_id=@itmqty_id where titmrat_dat=@titmrat_dat and titmrat_typ=@titmrat_typ
			
--			--Audit
--		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

--end
--GO

--Delete
alter proc [dbo].[del_t_itmrat](@com_id char(2),@br_id char(3),@m_yR_id char(2),@titmrat_dat datetime,@cuscat_id int,@cus_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	if(@cus_id!=0)
		begin
			delete t_itmrat where com_id=@com_id and br_id=@br_id and titmrat_dat=@titmrat_dat and cus_id=@cus_id
		end
	else if (@cuscat_id!=0)
		begin
			delete t_itmrat where com_id=@com_id and br_id=@br_id and  titmrat_dat=@titmrat_dat and cuscat_id=@cuscat_id and cus_id is null
		end
	else 
		begin
			delete t_itmrat where com_id=@com_id and br_id=@br_id and  titmrat_dat=@titmrat_dat
		end
			
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		

