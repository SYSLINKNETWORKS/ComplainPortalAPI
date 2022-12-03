--delete from t_mvch where typ_id=5 and mvch_id in (select jvvch_id from t_msal)
--delete from t_mvch where typ_id=2 and mvch_id in (select crvch_id from t_msal)
--delete from t_dvch where typ_id=5 and mvch_id in (select jvvch_id from t_msal)
--delete from t_dvch where typ_id=2 and mvch_id in (select crvch_id from t_msal)
----Master Voucher
declare @com_id char(2),@br_id char(4),@mvch_dt datetime,@mvch_pto varchar(20),@dpt_id char(2),@typ_id varchar(2),@m_yr_id char(2),@mvch_app char(1),@mvch_cb char(1),@mvch_ref varchar(100),@mvch_typ char(1),@mvch_oldvoucherno char(12)
declare  mvch  cursor for
		--Sumarize DO Data
		select com_id,br_id,mvch_dt,mvch_pto,dpt_id,typ_id,'02',mvch_app,mvch_cb,mvch_ref,mvch_typ,mvch_id 
			from rough.dbo.t_mvch 
			where mvch_dt>='07/01/2009'
	OPEN mvch
		FETCH NEXT FROM mvch
		INTO @com_id,@br_id ,@mvch_dt,@mvch_pto,@dpt_id,@typ_id,@m_yr_id,@mvch_app ,@mvch_cb,@mvch_ref,@mvch_typ,@mvch_oldvoucherno
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec meiji.dbo.ins_t_mvch @com_id,@br_id ,@mvch_dt,@mvch_pto,@dpt_id,@typ_id,@m_yr_id,@mvch_app ,@mvch_cb,@mvch_ref,@mvch_typ,@mvch_oldvoucherno,''
				FETCH NEXT FROM mvch
				INTO @com_id,@br_id ,@mvch_dt,@mvch_pto,@dpt_id,@typ_id,@m_yr_id,@mvch_app ,@mvch_cb,@mvch_ref,@mvch_typ,@mvch_oldvoucherno
	end
	CLOSE mvch
	DEALLOCATE mvch
	GO

--Detail Voucher
declare @com_id char(2),@br_id char(3),@mvch_id varchar(12),@mvch_dt datetime,@dvch_row int,@acc_id char(20),@dvch_nar nvarchar(1000),@dvch_dr_amt float,@dvch_cr_amt float,@typ_id char(2),@m_yr_id char(2)
declare  dvch  cursor for
		
		select rough.dbo.t_dvch.com_id,rough_meiji.dbo.t_dvch.br_id,meiji.dbo.t_mvch.mvch_id,rough_meiji.dbo.t_dvch.mvch_dt,dvch_row,acc_id,dvch_nar,dvch_dr_amt ,dvch_cr_amt,rough_meiji.dbo.t_dvch.typ_id ,'02'
			from rough.dbo.t_dvch 
			inner join meiji.dbo.t_mvch 
			on rough.dbo.t_dvch.mvch_id=meiji.dbo.t_mvch.mvch_oldvoucherno
			and rough.dbo.t_dvch.typ_id=meiji.dbo.t_mvch.typ_id
			
			where rough_meiji.dbo.t_dvch.mvch_dt>='07/01/2009'

	OPEN dvch
		FETCH NEXT FROM dvch
		INTO @com_id,@br_id,@mvch_id,@mvch_dt,@dvch_row,@acc_id,@dvch_nar,@dvch_dr_amt ,@dvch_cr_amt,@typ_id ,@m_yr_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec ins_t_dvch @com_id,@br_id,@mvch_id,@mvch_dt,@dvch_row,@acc_id,@dvch_nar,@dvch_dr_amt ,@dvch_cr_amt,@typ_id ,@m_yr_id
				FETCH NEXT FROM dvch
				INTO @com_id,@br_id,@mvch_id,@mvch_dt,@dvch_row,@acc_id,@dvch_nar,@dvch_dr_amt ,@dvch_cr_amt,@typ_id ,@m_yr_id
	end
	CLOSE dvch
	DEALLOCATE dvch
	GO

------DC JV Voucher Update
--declare @mvch_id char(12),@jvvch_id char(12)
--declare  dcvch  cursor for
--			select mvch_id,jvvch_id
--				from t_msal 
--				inner join t_mvch
--				on t_msal.jvvch_id=t_mvch.mvch_oldvoucherno
--			where msal_dat >='07/01/2009'
--			and typ_id=05							
--	OPEN dcvch
--		FETCH NEXT FROM dcvch
--		INTO @mvch_id,@jvvch_id
--			WHILE @@FETCH_STATUS = 0
--			BEGIN
--				update t_msal set jvvch_id=@mvch_id where jvvch_id=@jvvch_id
--				FETCH NEXT FROM dcvch
--				INTO @mvch_id,@jvvch_id
--	end
--	CLOSE dcvch
--	DEALLOCATE dcvch
--	GO

----DC Cash Receive Voucher Update
--declare @mvch_id char(12),@crvch_id char(12)
--declare  dcvch  cursor for
--			select mvch_id,crvch_id
--				from t_msal 
--				inner join t_mvch
--				on t_msal.crvch_id=t_mvch.mvch_oldvoucherno
--			where msal_dat >='07/01/2009'
--			and typ_id=02							
--	OPEN dcvch
--		FETCH NEXT FROM dcvch
--		INTO @mvch_id,@crvch_id
--			WHILE @@FETCH_STATUS = 0
--			BEGIN
--				update t_msal set crvch_id=@mvch_id where crvch_id=@crvch_id
--				FETCH NEXT FROM dcvch
--				INTO @mvch_id,@crvch_id
--	end
--	CLOSE dcvch
--	DEALLOCATE dcvch
--	GO


--delete from t_dvch where mvch_dt>='07/01/2009'
--select * from t_msal where msal_dat>='07/01/2009' and crvch_id is not null
--delete from t_dvch where mvch_id in (select jvvch_id from t_msal where msal_dat>='07/01/2009') and typ_id='05'
--delete from t_mvch where mvch_id in (select jvvch_id from t_msal where msal_dat>='07/01/2009') and typ_id='05'
--delete from t_dvch where mvch_id in (select crvch_id from t_msal where msal_dat>='07/01/2009') and typ_id='02'
--delete from t_mvch where mvch_id in (select crvch_id from t_msal where msal_dat>='07/01/2009') and typ_id='02'
--select * from t_rec
select sum(dvch_Dr_amt)-sum(dvch_cr_Amt) from t_dvch where mvch_dt>= '07/01/2009' and typ_id='02'