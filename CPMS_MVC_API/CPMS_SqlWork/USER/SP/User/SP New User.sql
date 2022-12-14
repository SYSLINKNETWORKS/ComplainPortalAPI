USE CPMS
GO

--select * from new_usr
--insert into new_usr (usr_id,usr_no,usr_nam,usr_pwd,gp_id,com_id,br_id,usr_typ)
--values(1,1,'asattar','65-41-7B-70-A1-A7-BD-08-A6-18-9F-4D-30-9D-90-97-9C',1,1,1,'U')
-- alter table new_usr add usr_pos bit,usr_spr bit

--alter table new_usr add per_dt1 datetime,per_dt2 datetime
--update new_usr set per_dt1='07/01/2012',per_dt2='07/01/2017' where usr_id=3
--ALTER table new_usr add usr_no int
--update new_usr set usr_no=usr_id
--select distinct per_dt1 from m_per 


--alter table new_usr drop column gp_id
--alter table new_usr drop constraint FK_NEWUSR_GPID
--alter table new_usr add usr_act bit,usr_ckweb bit
--update new_usr set usr_act=1,usr_ckweb=0
--alter table new_usr add log_act char(1),log_dat datetime,log_ip varchar(100)
--alter table new_usr add emppro_id int,usr_id_log int
--alter table new_usr add usr_auth bit

--alter table new_usr add constraint FK_NEWUSR_EMPPRO foreign key (emppro_id) references m_emppro(emppro_id)

alter table new_usr add usr_key varchar(50)
alter table new_usr add usr_wanip varchar(50)
alter table new_usr add usr_header varchar(max)


----Insert New User
alter proc [dbo].[ins_new_usr] (@com_id char(2),@br_id char(3),@usr_nam varchar(100),@usr_pwd varchar (50),@usr_add varchar(100),@usr_pho varchar(100),@usr_mob varchar(100),@usr_eml varchar(100), @usr_typ char(1),@usr_act bit,@usr_ckbr bit,@usr_ckweb bit,@usr_ckper bit,@per_dt1 datetime,@per_dt2 datetime,@emppro_macid int,@log_act char(1),@usr_id_log int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@usr_id_out int output)
as
declare
@usr_id int,
@usr_no int,
@emppro_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	if(@emppro_macid=0)
		begin 
			set @emppro_id=null
		end
	else
		begin
			set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
		end

	set @usr_id=(select max(cast(usr_id as int)) from new_usr)+1
	if (@usr_id is null)
		begin
			set @usr_id=1
		end
	set @usr_no=(select max(usr_no) from new_usr where com_id=@com_id and br_id=@br_id)+1
		if (@usr_no is null)
			begin
				set @usr_no=1
			end
			
			
	insert into new_usr
	(usr_id,usr_no , usr_nam , usr_pwd , usr_add ,usr_pho , usr_mob , usr_eml , com_id , br_id , usr_typ, usr_ckbr,per_dt1,per_dt2 ,usr_act,usr_ckweb,emppro_id,log_act,log_dat,usr_id_log,log_ip)
	values
	(@usr_id,@usr_no , @usr_nam , @usr_pwd , @usr_add ,@usr_pho , @usr_mob , @usr_eml  , @com_id , @br_id , @usr_typ,@usr_ckbr,@per_dt1,@per_dt2,@usr_act,@usr_ckweb,@emppro_id,@log_act,@log_dat,@usr_id_log,@log_ip)

	set @usr_id_out=@usr_id
	
	set @log_newval= 'ID=' + cast(@usr_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id_log,@log_ip,@log_oldval,@log_newval,@log_dat

	
end
GO

----Update New User
alter proc [dbo].[upd_new_usr] (@com_id char(2),@br_id char(3),@usr_id int,@usr_nam varchar(100),@usr_pwd varchar (50),@usr_ckpwd bit,@usr_add varchar(100),@usr_pho varchar(100),@usr_mob varchar(100),@usr_eml varchar(100),@usr_ckper bit,@per_dt1 datetime,@per_dt2 datetime, @usr_typ char(1),@usr_act bit,@usr_ckbr bit,@usr_ckweb bit,@emppro_macid int,@log_act char(1),@usr_id_log int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@emppro_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
		if(@emppro_macid=0)
		begin 
			set @emppro_id=null
		end
	else
		begin
			set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
		end

	update new_usr set usr_nam=@usr_nam  , usr_add=@usr_add ,usr_pho=@usr_pho , usr_mob=@usr_mob , usr_eml=@usr_eml   , com_id=@com_id  , br_id=@br_id  , usr_typ=@usr_typ,usr_ckbr=@usr_ckbr,usr_act=@usr_act,usr_ckweb=@usr_ckweb,emppro_id=@emppro_id,log_act=@log_act,log_dat=@log_dat,usr_id_log=@usr_id_log,log_ip=@log_ip 
	where 
         usr_id=@usr_id
	--Change Password
	if (@usr_ckpwd=1)
	begin
		update new_usr set usr_pwd=@usr_pwd where usr_id=@usr_id
	end
	--Change Permission Date
	if (@usr_ckper=1)
		begin
			update new_usr set per_dt1=@per_dt1,per_dt2=@per_dt2 where usr_id=@usr_id
			update m_per set per_dt1=@per_dt1,per_dt2=@per_dt2 where usr_id=@usr_id
		end
	

		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id_log,@log_ip,@log_oldval,@log_newval,@log_dat
	
end
go

--Delete New User
alter proc [dbo].[del_new_usr] (@usr_id int,@log_act char(1),@usr_id_log int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	exec del_m_dusr @usr_id 
	update new_usr set log_act=@log_act where usr_id=@usr_id
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id_log,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO

