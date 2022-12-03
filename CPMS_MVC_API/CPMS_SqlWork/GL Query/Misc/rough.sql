--select * from m_sys
--update m_sys set bk_acc_id=null,cus_acc=null,ful_acc=null,com_acc=null,misc_acc=null,sale_acc=null,cng_acc=null,cash_acc=null,pl_acc=null
--update gl_vch_typ set acc_id=null
--delete from gl_br_acc where acc_id not in ('01','02','03','04','05')
--delete from gl_m_acc where acc_id not in ('01','02','03','04','05')

--select * from gl_m_acc
--update gl_m_acc set acc_nam='Equity' where acc_id=02
--update gl_m_acc set acc_nam='Liabilities' where acc_id=03



declare @per_view char(1),@per_new char(1),@per_upd char(1), @per_del char(1),@per_print char(1),@men_id int,@usr_id char(2)
--set @usr_id=(select usr_id from new_usr)
declare  mDC  cursor for
		--Sumarize DO Data
		 select men_id from m_men
	OPEN mDC
		FETCH NEXT FROM mDC
		INTO @men_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
--			print @men_id
			exec ins_m_per  'Y','Y','Y','Y','Y',@men_id,'01' 
				FETCH NEXT FROM mDC
		INTO @men_id
	end
	CLOSE mDC
	DEALLOCATE mDC
	GO
--select * from meiji.dbo.m_per where usr_id=18
--select * from m_per
--select * from meiji.dbo.gl_m_yr
[ins_m_acc](@com_id char(2),@br_id varchar(2),@yr_id char(2),@acc_nam varchar(100),@acc_cid varchar(20),@acc_oid varchar(20),@acc_obal money,@acc_typ char(1),@acc_id_out varchar(20) output)
	exec ins_m_acc '01','01','01','Assets',Null,'',0,'S',''
	exec ins_m_acc '01','01','01','Equity',Null,'',0,'S',''
	exec ins_m_acc '01','01','01','Liabilities',Null,'',0,'S',''
	exec ins_m_acc '01','01','01','Revenue',Null,'',0,'S',''
	exec ins_m_acc '01','01','01','Expenses',Null,'',0,'S',''
select * from gl_br_acc
select * from gl_m_acc
update gl_br_acc set acc_dat='07/01/2009' 
select * from m_sys
select * from gl_m_acc
insert into m_sys (sys_id,bk_acc_id) values(1,'01001003')
