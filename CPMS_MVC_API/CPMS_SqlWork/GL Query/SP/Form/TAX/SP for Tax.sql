USE ZSONS
GO
--alter table m_tax add acc_no int,tax_psb char(1),tax_pr char(1),tax_pbinv char(1)

--update m_tax set tax_psb=
--alter table m_sys add acc_taxpayable int,acc_taxreceivable int
--update m_sys set acc_taxpayable=1874,acc_taxreceivable=1878
--select * from gl_m_acc where acc_id='03002006'
--select * from gl_m_acc where acc_id='02003005'

--Insert
alter proc [dbo].[ins_m_tax](@com_id char(2),@br_id char(3),@tax_nam varchar(250),@tax_snm varchar(10),@tax_act bit,@tax_psb char(1),@tax_pr char(1),@tax_pbinv char(1),@tax_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@tax_id_out int output)
as
declare
@cur_id int,
@tax_id int,
@acc_cno int,
@acc_no int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @tax_id=(select max(tax_id)+1 from m_tax)
		if @tax_id is null
			begin
				set @tax_id=1
			end

	insert into m_tax(tax_id,tax_nam,tax_snm,acc_no,tax_psb,tax_pr,tax_pbinv,tax_act,tax_typ)
			values(@tax_id,@tax_nam,@tax_snm,@acc_no,@tax_psb,@tax_pr,@tax_pbinv,@tax_act,@tax_typ)
		set @tax_id_out=@tax_id

	----GL Account	
	if (@tax_pr='P')
		begin
			set @acc_cno=(select acc_taxpayable from m_sys)
		end
	else if (@tax_pr='R')
		begin
			set @acc_cno=(select acc_taxreceivable from m_sys)
		end
	exec ins_m_acc @com_id ,@br_id,@cur_id,@tax_nam ,@acc_cno,'','S',@tax_act,@aud_frmnam ,@aud_des,@usr_id ,@aud_ip,'',@acc_no_out=@acc_no output
	update m_tax set acc_no=@acc_no where tax_id=@tax_id

	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip


end
GO

--Update
alter proc [dbo].[upd_m_tax](@com_id char(2),@br_id char(3),@tax_id int,@tax_nam varchar(250),@tax_snm varchar(10),@tax_psb char(1),@tax_pr char(1),@tax_pbinv char(1),@tax_act bit,@tax_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@tax_pr_old char(1),
@acc_no int
begin
	if (@tax_pr_old!=@tax_pr)
		begin
			print @tax_pr
		end
	update m_tax set tax_nam=@tax_nam,tax_snm=@tax_snm,tax_act=@tax_act,acc_no=@acc_no,tax_psb=@tax_psb,tax_pr=@tax_pr,tax_pbinv=@tax_pbinv,tax_typ=@tax_typ where tax_id=@tax_id
end
GO


--Delete
alter proc [dbo].[del_m_tax](@tax_id int)
as
begin
	delete m_tax where tax_id=@tax_id
end