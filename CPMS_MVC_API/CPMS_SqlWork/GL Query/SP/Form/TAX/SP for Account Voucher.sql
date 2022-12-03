USE ZSons
GO


--alter table t_mvch add mvch_tax bit default 0
--update t_mvch set mvch_tax=0

--alter table t_mvch add mvch_taxmark bit default 0,mvch_no_tax int
--update t_mvch set mvch_taxmark=0,mvch_no_tax=0

alter proc sp_upd_taxaccvch(@com_id char(2),@br_id char(3),@mvch_no int)
as
begin
	update t_mvch set mvch_taxmark=1 where com_id=@com_id and mvch_no=@mvch_no
--Master Voucher Cursor Open
declare @mvch_no_new int,@yr_id char(2),@mvch_dat datetime,@mvch_tdat datetime,@mvch_pto varchar(20),@dpt_id char(2),@typ_id varchar(2),@mvch_app char(1),@mvch_cb char(1),@mvch_ref varchar(100),@mvch_typ char(1),@mvch_chq float,@mvch_chqdat datetime,@mvch_po bit,@mvch_chqst bit,@cur_id int,@mvch_rat float,@mvch_can bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mvch_oldvoucherno char(12),@mvch_no_out int,
@dvch_row int,@acc_no int,@dvch_nar nvarchar(1000),@dvch_dr_famt float,@dvch_cr_famt float

	declare  mvch1  cursor for			
		select mvch_no ,yr_id ,mvch_dt ,mvch_tdat ,mvch_pto ,dpt_id ,typ_id ,mvch_app ,mvch_cb ,mvch_ref ,mvch_typ ,mvch_chq ,mvch_chqdat ,mvch_po,mvch_chqst ,cur_id ,mvch_rat ,mvch_can ,'' ,'' ,'' ,''   from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
		OPEN mvch1
			FETCH NEXT FROM mvch1
			INTO @mvch_oldvoucherno,@yr_id ,@mvch_dat ,@mvch_tdat ,@mvch_pto ,@dpt_id ,@typ_id ,@mvch_app ,@mvch_cb ,@mvch_ref ,@mvch_typ ,@mvch_chq ,@mvch_chqdat ,@mvch_po,@mvch_chqst ,@cur_id ,@mvch_rat ,@mvch_can ,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip
				WHILE @@FETCH_STATUS = 0
				BEGIN
					exec ins_t_mvch @com_id ,@br_id ,@yr_id ,@mvch_dat ,@mvch_tdat ,@mvch_pto ,@dpt_id ,@typ_id ,@mvch_app ,@mvch_cb ,@mvch_ref ,@mvch_typ ,@mvch_chq ,@mvch_chqdat ,@mvch_po,@mvch_chqst ,@cur_id ,@mvch_rat ,@mvch_can,1 ,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip ,@mvch_oldvoucherno ,'',@mvch_no_out =@mvch_no_new output
					update t_mvch set mvch_no_tax=@mvch_no_new where com_id=@com_id and mvch_no=@mvch_no
						--Detail Voucher Cursor
						declare  dvch1  cursor for			
							select dvch_row,acc_no,dvch_nar,dvch_dr_famt,dvch_cr_famt from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
							OPEN dvch1
								FETCH NEXT FROM dvch1
								INTO @dvch_row,@acc_no,@dvch_nar,@dvch_dr_famt,@dvch_cr_famt
									WHILE @@FETCH_STATUS = 0
									BEGIN
										exec ins_t_dvch @com_id ,@br_id ,@mvch_no_new ,@dvch_row ,@acc_no ,@dvch_nar ,@dvch_dr_famt ,@dvch_cr_famt 
							
										FETCH NEXT FROM dvch1
										INTO @dvch_row,@acc_no,@dvch_nar,@dvch_dr_famt,@dvch_cr_famt											
											
							end
							CLOSE dvch1
							DEALLOCATE dvch1
						--Detail Voucher Cursor Close


				
					FETCH NEXT FROM mvch1
			INTO @mvch_oldvoucherno,@yr_id ,@mvch_dat ,@mvch_tdat ,@mvch_pto ,@dpt_id ,@typ_id ,@mvch_app ,@mvch_cb ,@mvch_ref ,@mvch_typ ,@mvch_chq ,@mvch_chqdat ,@mvch_po,@mvch_chqst ,@cur_id ,@mvch_rat ,@mvch_can ,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip
						
						
		end
		CLOSE mvch1
		DEALLOCATE mvch1

		--Master Voucher Courcor Closed
end

GO

go
alter proc sp_del_taxaccvch(@com_id char(2),@br_id char(3),@acc_id char(20),@dt1 datetime,@dt2 datetime)
as
begin
	--update t_mvch set mvch_taxmark=0 where  com_id=@com_id and mvch_typ='U' and mvch_no in 
	--(
	--	select mvch_no from t_dvch where com_id=t_mvch.com_id and acc_no in (select acc_no from gl_m_acc where LEFT(acc_id,len(@acc_id))=@acc_id)
	--)
	--Master Voucher Cursor Open for delete
declare @mvch_no int,@mvch_no_tax int,@yr_id char(2),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100)
	declare  mvch_del  cursor for			
							select t_mvch.br_id,t_mvch.mvch_no,mvch_no_tax,t_mvch.yr_id,'','','','' from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_mvch.com_id=gl_m_acc.com_id and t_dvch.acc_no=gl_m_acc.acc_no where t_mvch.com_id=@com_id and left(acc_id,len(@acc_id))=@acc_id and mvch_dt between @dt1 and @dt2
							OPEN mvch_del
								FETCH NEXT FROM mvch_del
								INTO @br_id,@mvch_no,@mvch_no_tax ,@yr_id ,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip
									WHILE @@FETCH_STATUS = 0
									BEGIN
										exec del_t_vch @com_id ,@br_id ,@yr_id ,@mvch_no_tax ,'','','',''
										update t_mvch set mvch_taxmark=0,mvch_no_tax=null where com_id=@com_id and mvch_no=@mvch_no
							
										FETCH NEXT FROM mvch_del
										INTO @br_id,@mvch_no,@mvch_no_tax ,@yr_id ,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip											
											
							end
							CLOSE mvch_del
							DEALLOCATE mvch_del
							--Voucher Cursor Del Close
end

GO

