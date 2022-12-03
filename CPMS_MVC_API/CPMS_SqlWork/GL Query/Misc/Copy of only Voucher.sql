--SELECT * from GLT01 --where doc_no='010001'
--SELECT * from GLT02 --where doc_no='010001'
--select * from GLT01 
--select count(*) from t_mvch
--select count(*) from t_dvch
--select count(*) from db_kvtcold.dbo.t_mvch
--select count(*) from db_kvtcold.dbo.t_dvch
--select * from db_kvtcold.dbo.t_dvch where acc_id not in (select acc_id from gl_m_acc)
--select * from db_kvtcold.dbo.gl_m_acc where acc_id ='05019004'
--select * from gl_m_acc where acc_nam like '%utility%'
--select * from gl_m_acc where left(acc_id,5)='05019'
--delete from gl_m_acc where acc_id='05019'
--select * from gl_br_acc where acc_id ='05019'
--delete from t_dvch
--delete from t_mvch
--select * from t_mvch where mvch_dt between '07/01/08' and '06/30/09'
--select * from t_dvch where mvch_dt between '07/01/08' and '06/30/09'
--delete from t_mvch where mvch_dt between '07/01/08' and '06/30/09'

----Master Voucher
declare @mvch_dt datetime,@mvch_pto varchar(100),@dpt_id char(2),@typ_id char(2),@mvch_app char(1),@mvch_id char(12),@mvch_oldvoucherno char(12),@yr_id char(2),@mvch_cb char(2)
declare  insvoucher  cursor for
	select mvch_id,dateadd(year,-1,mvch_Dt),mvch_pto,dpt_id,typ_id,'01',mvch_app,mvch_cb from db_kvtcold.dbo.t_mvch where mvch_dt <='01/31/2010' --between '07/01/2009' and '07/31/2009'
	OPEN insvoucher
		FETCH NEXT FROM insvoucher
		INTO @mvch_oldvoucherno,@mvch_dt,@mvch_pto,@dpt_id,@typ_id,@yr_id,@mvch_app,@mvch_cb
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec ins_t_mvch '01','01',@mvch_dt ,@mvch_pto,@dpt_id,@typ_id,@yr_id,@mvch_app,@mvch_cb,'','U',@mvch_oldvoucherno,''
--				print @mvch_id
--				print @mvch_oldvoucherno
--				print @mvch_dt
--				print @mvch_pto
--				print @dpt_id
--				print @typ_id
--				print @mvch_app
--				print 'Finish Record'
--				print '-------------'
		
			FETCH NEXT FROM insvoucher
			INTO @mvch_oldvoucherno,@mvch_dt,@mvch_pto,@dpt_id,@typ_id,@yr_id,@mvch_app,@mvch_cb
	end
	CLOSE insvoucher
	DEALLOCATE insvoucher
	GO

select dateadd(year,-1,'01/31/2010'),datepart(year,'01/31/2010')-1

--SELECT * from GLT01 where doc_no='010001'
--SELECT * from GLT02 where doc_no='010001'
--SELECT * from meiji.dbo.t_mvch
--select * from meiji.dbo.t_dvch
--delete from gl.dbo.t_dvch



--declare  insdetailvoucher  cursor for
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010001' and code is not null  and GLT01.doc_date='07/01/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010001' and code is not null  and GLT01.doc_date='07/11/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010002' and code is not null  and GLT01.doc_date='07/10/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010002' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010003' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010003' and code is not null  and GLT01.doc_date='07/15/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010004' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010004' and code is not null  and GLT01.doc_date='07/13/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010004' and code is not null  and GLT01.doc_date='07/19/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010005' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010005' and code is not null  and GLT01.doc_date='07/13/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010005' and code is not null  and GLT01.doc_date='07/21/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010006' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010006' and code is not null  and GLT01.doc_date='07/19/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010006' and code is not null  and GLT01.doc_date='07/25/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010007' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010007' and code is not null  and GLT01.doc_date='07/29/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010007' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010008' and code is not null  and GLT01.doc_date='07/11/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010008' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010008' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010008' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010009' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010009' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010010' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010010' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010011' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010011' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010012' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010012' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010013' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010013' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010014' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010014' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010015' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010015' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010016' and code is not null  and GLT01.doc_date='07/12/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010016' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010017' and code is not null  and GLT01.doc_date='07/28/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010017' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010018' and code is not null  and GLT01.doc_date='07/21/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010018' and code is not null  and GLT01.doc_date='07/31/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010019' and code is not null  and GLT01.doc_date='07/30/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010020' and code is not null  and GLT01.doc_date='07/14/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010021' and code is not null  and GLT01.doc_date='07/15/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010022' and code is not null  and GLT01.doc_date='07/29/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010023' and code is not null  and GLT01.doc_date='07/10/2006'
--		select GLT01.Nature,GLT01.DOC_NO,GLT01.Doc_Date,code,DB_CR,Amount,Narration from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010024' and code is not null  and GLT01.doc_date='07/12/2006'
--		select distinct GLT01.Doc_Date from GLT01 inner join GLT02 on GLT01.Doc_no =GLT02.Doc_no and GLT01.Nature=GLT02.Nature where GLT01.DOC_NO='010024' and code is not null 

----Detail Voucher
--delete from t_dvch

declare @mvch_id char(12),@mvch_dat datetime,@acc_id char(20),@acc_nam varchar(100),@dvch_row int,@dvch_dr_amt float,@dvch_cr_amt float,@dvch_amt float,@DB_DRCR char(1),@dvch_nar nvarchar(1000),@mvch_dr_amt float,@mvch_cr_amt float,@typ_id char(2),@yr_id char(2)
			declare  insdetailvoucher  cursor for
				select mvch_id,dateadd(year,-1,mvch_Dt),dvch_row,acc_id,dvch_nar,dvch_dr_amt,dvch_cr_amt,typ_id,'01' from db_kvtcold.dbo.t_dvch where mvch_dt<='01/31/2010' --where acc_id not in (select acc_id from gl_m_acc)
 			OPEN insdetailvoucher
				FETCH NEXT FROM insdetailvoucher
				INTO @mvch_id,@mvch_dat,@dvch_row,@acc_id,@dvch_nar,@mvch_dr_amt,@mvch_cr_amt,@typ_id,@yr_id
					WHILE @@FETCH_STATUS = 0
					BEGIN
						--print @mvch_id
						set @mvch_id=(select mvch_id from t_mvch where mvch_oldvoucherno=@mvch_id and typ_id=@typ_id and yr_id=@yr_id)
						if (@acc_id='05019004')
							begin
								set @acc_id='05042001'
							end
						--print @mvch_id
						exec ins_t_dvch '01','01',@mvch_id ,@mvch_dat,@dvch_row,@acc_id,@dvch_nar,@mvch_dr_amt,@mvch_cr_amt,@typ_id,@yr_id
						FETCH NEXT FROM insdetailvoucher
						INTO @mvch_id,@mvch_dat,@dvch_row,@acc_id,@dvch_nar,@mvch_dr_amt,@mvch_cr_amt,@typ_id,@yr_id
			end
			CLOSE insdetailvoucher
			DEALLOCATE insdetailvoucher
			GO

--select * from t_dvch where acc_id='05033003'
--update t_dvch set acc_id= '05069013' where acc_id='05030'
--select * from gl_m_acc where acc_id='05030'

