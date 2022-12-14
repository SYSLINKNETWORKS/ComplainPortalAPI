USE zsons
GO

--ALTER table t_dvch add dvch_dr_eamt float,dvch_cr_eamt float
--update t_dvch set dvch_dr_eamt=0,dvch_cr_eamt=0
--select * from t_dvch where typ_id='05' and mvch_id='002-20130521'
----Insert Detail Voucher
--update t_dvch set acc_no=(select acC_no from gl_m_acc where acc_id=t_dvch.acc_id)

--select * from t_dvch 
--alter table t_dvch drop column acC_id


--alter table t_dvch drop constraint FK_COMID_BRID_MVCHID_TYPID_YRID
--alter table t_dvch add constraint FK_COMID_BRID_MVCHID foreign key (com_id,br_id,mvch_no) references t_mvch (com_id,br_id,mvch_no)
--alter table t_dvch add constraint FK_COMID_ACCNO foreign key (com_id,acc_no) references gl_m_acc(com_id,acc_no)


--select isnull(currat_rat,1) from m_currat where cur_id=(select isnull(cur_id,1) from gl_br_acc where acc_id='03001001001025' and yr_id='01') and currat_dat =(select max(currat_dat) from m_currat where cur_id=(select isnull(cur_id,1) from gl_br_acc where acc_id='03001001001025' and yr_id='01'))

ALTER proc [dbo].[ins_t_dvch](@com_id char(2),@br_id char(3),@mvch_no int,@dvch_row int,@acc_no int,@dvch_nar nvarchar(1000),
@dvch_dr_famt float,@dvch_cr_famt float)
as
declare
@mvch_rat float,
@dvch_dr_amt float,
@dvch_cr_amt float,
@dvch_currat float,
@mvch_curid int,
@dvch_curid int
begin
		set @mvch_rat=(select mvch_rat from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no)
		set @mvch_curid=(select cur_id from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no)
		set @dvch_curid=(select cur_id from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no)
		set @dvch_dr_amt=@dvch_dr_famt*@mvch_rat
		set @dvch_cr_amt=@dvch_cr_famt*@mvch_rat
	--Insert	
	insert into t_dvch
		(com_id,br_id,mvch_no,dvch_row,acc_no,dvch_nar,dvch_dr_famt,dvch_cr_famt,dvch_dr_amt,dvch_cr_amt)
	values
		(@com_id,@br_id,@mvch_no,@dvch_row,@acc_no,@dvch_nar,@dvch_dr_famt,@dvch_cr_famt,@dvch_dr_amt,@dvch_cr_amt)
end
GO

--Delete Voucher
alter proc [dbo].[del_t_dvch](@com_id char(2),@br_id char(3),@mvch_no int)
as
	delete from t_dvch
		where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
GO

