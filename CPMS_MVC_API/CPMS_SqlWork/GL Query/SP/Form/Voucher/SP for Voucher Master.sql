USE PAGEY
go
--alter table t_mvch add usr_id char(2)

--exec ins_t_mvch'01','01','03/06/2012','03/06/2012','received from abc','01','03','03','Y','B','REMARKS','U',123123,'03/06/2012',1,0,'','','','','',''
--select * from t_mvch where mvch_dt='03/06/2012'
--select * from t_mvch where mvch_dt='03/06/2012' and typ_id='03'
--alter table t_mvch add mvch_po bit
--alter table t_mvch add mvch_no int
--alter table t_mvch alter column mvch_no int not null
--alter table t_mvch add mvch_can bit,mvch_del bit
--update t_mvch set mvch_can=0,mvch_del=0


--alter table t_mvch add constraint PK_COMID_BRID_MVCHNO primary key(com_id,br_id,mvch_no)
--sp_help t_mvch




----Insert Master Voucher

ALTER proc [dbo].[ins_t_mvch](@com_id char(2),@br_id char(3),@yr_id char(2),@mvch_dat datetime,@mvch_tdat datetime,@mvch_pto varchar(20),@dpt_id char(2),@typ_id varchar(2),@mvch_app char(1),@mvch_cb char(1),@mvch_ref varchar(100),@mvch_typ char(1),@mvch_chq float,@mvch_chqdat datetime,@mvch_po bit,@mvch_chqst bit,@cur_id int,@mvch_rat float,@mvch_can bit,@mvch_cktax bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),
@mvch_oldvoucherno char(12),@mvch_id_out varchar(12) output,@mvch_no_out int output)
as
declare
@mvch_no		int,
@mvch_id		char(12),
@yy				char(4),
@mm				char(2),
@dd				char(2),
@aud_act		char(10)
begin
	set @aud_act='Insert'
--binding the date
set @mm=(select datepart(mm,@mvch_dat))
set @dd=(select datepart (dd,@mvch_dat))
set @yy=(select datepart(yy,@mvch_dat))
		If (len(@mm)=2)			set @mm=(select datepart(mm,@mvch_dat)) 	else if (len(@mm)=1)	set @mm='0'+ cast((select datepart(mm,@mvch_dat)) as char(1)) 
		If (len(@dd)=2)			set @dd=(select datepart(dd,@mvch_dat)) 	else if (len(@dd)=1)	set @dd='0'+ cast((select datepart(dd,@mvch_dat)) as char(1)) 

		set @mvch_id=dbo.autonumber((select LEFT(max(mvch_id),3) from t_mvch where mvch_dt=@mvch_dat and typ_id=@typ_id and com_id=@com_id and yr_id=@yr_id and mvch_tax=@mvch_cktax) ,3)
			set @mvch_id=rtrim(@mvch_id)+'-'+@yy+@mm+@dd			
			
			set @mvch_no=(select MAX(mvch_no)+1 from t_mvch where com_id=@com_id and br_id=@br_id)
			if (@mvch_no is null)
				begin
					set @mvch_no=1
				end
			
			if (@mvch_can =1)
				begin
					set @mvch_app='N'
				end

		--inserting value in master voucher
		insert into t_mvch
		(com_id,br_id,yr_id,mvch_no,mvch_id,mvch_dt,mvch_tdat,mvch_pto,mvch_cb,mvch_ref,mvch_app,dpt_id,typ_id,mvch_typ,mvch_chq,mvch_chqdat,mvch_chqcldat,mvch_po,mvch_chqst,cur_id,mvch_rat,mvch_oldvoucherno,usr_id,mvch_can,mvch_tax,mvch_del)
		values
		(@com_id,@br_id,@yr_id,@mvch_no,@mvch_id,@mvch_dat,@mvch_tdat,@mvch_pto,@mvch_cb,@mvch_ref,@mvch_app,@dpt_id,@typ_id,@mvch_typ,@mvch_chq,@mvch_chqdat,@mvch_chqdat,@mvch_po,@mvch_chqst,@cur_id,@mvch_rat,@mvch_oldvoucherno,@usr_id,@mvch_can,@mvch_cktax,0)

		--update the chq no
		if (@mvch_cb='B' and @typ_id='04' and @mvch_po=0)
			begin
				update gl_bk_chq set chq_act=0 where chq_no=rtrim(cast(@mvch_chq as int))		
			end
		--return @vch
		set @mvch_id_out=@mvch_id
		set @mvch_no_out=@mvch_no
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO
--sp_help t_mvch
--alter table t_mvch alter column mvch_chq int


----Update Master Voucher
ALTER proc [dbo].[upd_t_mvch](@com_id char(2),@br_id char(3),@yr_id char(2),@mvch_no int,@mvch_dat datetime,@typ_id char(2),@mvch_app char(1),@mvch_pto varchar(20),@dpt_id char(2),@mvch_cb char(1),@mvch_ref varchar(100),@mvch_chq float,@mvch_chqdat datetime,@mvch_po bit,@mvch_chqst bit,@cur_id int,@mvch_rat float,@mvch_typ char(1),@mvch_can bit,@mvch_cktax bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_cb_old char(1),
@mvch_chq_old int,
@mvch_id char(12)
begin
	set @aud_act='Update'
	set @mvch_cb_old=(select mvch_cb from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no )
	set @mvch_chq_old=(select mvch_chq from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no )
	set @mvch_id=(select mvch_id from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no)
			if (@mvch_can =1)
				begin
					set @mvch_app='N'
				end

update t_mvch 
		set mvch_id=@mvch_id,mvch_dt=@mvch_dat,mvch_pto =@mvch_pto,dpt_id=@dpt_id,mvch_app=@mvch_app,mvch_cb=@mvch_cb,typ_id=@typ_id,mvch_ref=@mvch_ref,mvch_chq=@mvch_chq,mvch_chqdat=@mvch_chqdat,mvch_po=@mvch_po,mvch_chqst=@mvch_chqst,cur_id=@cur_id,mvch_rat=@mvch_rat,mvch_typ=@mvch_typ,usr_id=@usr_id ,mvch_can=@mvch_can,mvch_tax=@mvch_cktax,mvch_del=0
		where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no

		--update the chq no
		update gl_bk_chq set chq_act=1 where chq_no=rtrim(cast(@mvch_chq_old as int))		
		if (@mvch_cb_old='B' and @typ_id='04' and @mvch_po=0)
			begin
				update gl_bk_chq set chq_act=0 where chq_no=rtrim(cast(@mvch_chq as int))		
			end

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Delete Voucher
ALTER proc [dbo].[del_t_vch](@com_id char(2),@br_id char(3),@yr_id char(2),@mvch_no int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_cb_old char(1),
@typ_id char(2),
@mvch_chq int
begin
set @aud_act='Delete'
set @mvch_cb_old=(select mvch_cb from t_mvch where mvch_no=@mvch_no)
set @typ_id =(select typ_id from t_mvch where mvch_no=@mvch_no)
set @mvch_chq=(select mvch_chq from t_mvch where mvch_no=@mvch_no)
if (@mvch_cb_old='B' and @typ_id='04')
			begin
				update gl_bk_chq set chq_act=0 where chq_no=rtrim(cast(@mvch_chq as int))		
			end
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no 
				delete from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end


GO
--select * from tbl_aud1 order by aud_dat


