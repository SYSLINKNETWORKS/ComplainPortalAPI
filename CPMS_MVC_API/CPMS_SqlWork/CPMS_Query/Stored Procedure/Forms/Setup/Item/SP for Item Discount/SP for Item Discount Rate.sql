USE NTHA
GO


--alter table m_bd_rat drop column cus_id
--alter table m_bd_rat drop constraint FK_bdRAT_CUSID foreign key (cus_id) references m_cus (cus_id)
--alter table m_bd_rat drop column cuscat_id
--alter table m_bd_rat drop constraint FK_bdRAT_CUSCATID foreign key (cuscat_id) references m_cuscat (cuscat_id)

--alter table m_bd_rat add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--alter table m_bd_rat add memp_sub_id int
--alter table m_bd_rat add emppro_id int
--alter table m_bd_rat add constraint FK_bdRAT_mempsubID foreign key (memp_sub_id) references m_emp_sub (memp_sub_id)
--alter table m_bd_rat add constraint FK_bdRAT_empproID foreign key (emppro_id) references m_emppro (emppro_id)
--alter table m_bd_rat add bd_rat_amt float

--alter table m_bd_rat drop column bd_mas_dis
--alter table m_bd_rat drop column bd_disrat

--Insert
alter proc [dbo].[ins_m_bd_rat](@bd_rat_dat datetime,@itmsub_id int,@bd_id int,@titm_id int,@itmqty_id int,@bd_rat_typ char(1),@bd_rat_act bit,@memp_sub_id int,@emppro_id int,@bd_rat_amt float,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@bd_rat_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @bd_rat_id=(select max(bd_rat_id)+1 from m_bd_rat)
		if @bd_rat_id is null
			begin
				set @bd_rat_id=1
			end
			if(@itmsub_id=0)
			begin
			set @itmsub_id=null
			end
			if(@bd_id=0)
			begin
			set @bd_id=null
			end
			if(@emppro_id=0)
			begin
			set @emppro_id=null
			end
			if(@memp_sub_id=0)
			begin
			set @memp_sub_id=null
			end
		insert into m_bd_rat (bd_rat_id,bd_rat_dat,itmsub_id,bd_id,titm_id,itmqty_id,bd_rat_act,bd_rat_typ,emppro_id,memp_sub_id,bd_rat_amt,log_act,log_dat,usr_id,log_ip)
				values (@bd_rat_id,@bd_rat_dat,@itmsub_id,@bd_id,@titm_id,@itmqty_id,@bd_rat_act,@bd_rat_typ,@emppro_id,@memp_sub_id,@bd_rat_amt,@log_act,@log_dat,@usr_id,@log_ip)
				
				set @log_newval= 'ID=' + cast(@bd_rat_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
				
end
GO

--Delete
alter proc [dbo].[del_m_bd_rat](@bd_rat_dat datetime,@memp_sub_id int,@emppro_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare 
@log_dat datetime
begin
set @log_dat=GETDATE()
	if(@emppro_id!=0)
		begin
			delete from m_bd_rat where bd_rat_dat=@bd_rat_dat and emppro_id=@emppro_id
		end
	else if (@memp_sub_id!=0)
		begin
			delete m_bd_rat where bd_rat_dat=@bd_rat_dat and memp_sub_id=@memp_sub_id and emppro_id is null
		end
	else 
		begin
			delete from m_bd_rat where bd_rat_dat=@bd_rat_dat
		end
	 
	
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
					
end


		

