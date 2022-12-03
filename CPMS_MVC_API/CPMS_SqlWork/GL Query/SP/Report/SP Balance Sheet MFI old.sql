USE MFI
go

--EXEC sp_rpt_bl '01','01','01','07/01/2012','06/30/2013',2

--SELECT * from t_dvch where left(acc_id,2)='01' and mvch_dt between '07/01/2012' and '08/31/2012'
alter proc sp_rpt_BL(@com_id char(2),@br_id char(2),@m_yr_id char(2),@dt1 datetime,@dt2 datetime,@cur_id int)
as
declare
@cur_id_local int,
@cur_rat float,
@cur_snm varchar(100)
begin
	set @cur_id_local=(select cur_id from m_cur where cur_id=@cur_id and cur_typ='S')
	if (@cur_id=@cur_id_local)
		begin	
			set @cur_rat=1
		end
	else
		begin
			set @cur_rat =(select isnull(currat_rat,1) from m_currat where currat_dat=(select MAX(currat_dat) from m_currat where cur_id=@cur_id and currat_dat <=@dt2) and cur_id=@cur_id)
		end
		set @cur_snm=(select cur_snm from m_cur where cur_id=@cur_id)
		
		--Capital
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],
		case when len(cid1.acc_id)=2 then cid1.acc_id else '' end as[cid1],case when len(cid1.acc_id)=2 then cid1.acc_nam else '' end as [cid_nam1],
		case when len(cid2.acc_id)=5 then cid2.acc_id else '' end as [cid2],case when len(cid2.acc_id)=5 then cid2.acc_nam else '' end as [cid_nam2],
		case when len(cid3.acc_id)=8 then cid3.acc_id else '' end as [cid3],case when len(cid3.acc_id)=8 then cid3.acc_nam else '' end  as [cid_nam3],
		case when len(cid4.acc_id)=11 then cid4.acc_id else '' end as [cid4],case when len(cid4.acc_id)=11 then cid4.acc_nam else '' end as [cid_nam4],
		case when len(cid5.acc_id)=14 then cid5.acc_id else '' end as [cid5],case when len(cid5.acc_id)=14 then cid5.acc_nam else '' end as [cid_nam5],
		case when len(cid6.acc_id)=17 then cid6.acc_id else '' end as [cid6],case when len(cid6.acc_id)=17 then cid6.acc_nam else '' end as [cid_nam6],
		case when len(cid7.acc_id)=20 then cid7.acc_id else '' end as [cid7],case when len(cid7.acc_id)=20 then cid7.acc_nam else '' end as [cid_nam7],
		gl_m_acc.acc_id as [acc_id],gl_m_acc.acc_nam as [acc_nam],
		isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),2),0) as [famt],1 as [GTAG],1 as [MTAG],1 as [STAG],1 as [TAG],1 AS [T],'ASSETS' as [subrmk],'ASSETS' as [masrmk] 
		from t_dvch
		inner join gl_m_acc
		on t_dvch.acc_id=gl_m_acc.acc_id 
		--First Level
		left join gl_m_acc cid1
		on left(gl_m_acc.acc_cid,2)=cid1.acc_id
		--Second Level
		left join gl_m_acc cid2
		on left(gl_m_acc.acc_cid,5)=cid2.acc_id
		--Third Level
		left join gl_m_acc cid3
		on left(gl_m_acc.acc_cid,8)=cid3.acc_id
		--Forth Level
		left join gl_m_acc cid4
		on left(gl_m_acc.acc_cid,11)=cid4.acc_id
		--Fifth Level
		left join gl_m_acc cid5
		on left(gl_m_acc.acc_cid,14)=cid5.acc_id
		--Six Level
		left join gl_m_acc cid6
		on left(gl_m_acc.acc_cid,17)=cid6.acc_id
		--Seven Level
		left join gl_m_acc cid7
		on left(gl_m_acc.acc_cid,20)=cid7.acc_id
		where left(gl_m_acc.acc_id,len('01'))='01' and gl_m_acc.com_id=@com_id and gl_m_acc.br_id=@br_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		and gl_m_acc.acc_cid not in ('01003')		
		group by 
		cid1.acc_id,cid1.acc_nam,
		cid2.acc_id,cid2.acc_nam,
		cid3.acc_id,cid3.acc_nam,
		cid4.acc_id,cid4.acc_nam,
		cid5.acc_id,cid5.acc_nam,
		cid6.acc_id,cid6.acc_nam,
		cid7.acc_id,cid7.acc_nam,
		gl_m_acc.acc_id,gl_m_acc.acc_nam
		having SUM(dvch_dr_amt-dvch_cr_amt)<>0
		union all
		--Profit / (Loss)
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],
		case when len(cid1.acc_id)=2 then cid1.acc_id else '' end as[cid1],case when len(cid1.acc_id)=2 then cid1.acc_nam else '' end as [cid_nam1],
		case when len(cid2.acc_id)=5 then cid2.acc_id else '' end as [cid2],case when len(cid2.acc_id)=5 then cid2.acc_nam else '' end as [cid_nam2],
		case when len(cid3.acc_id)=8 then cid3.acc_id else '' end as [cid3],case when len(cid3.acc_id)=8 then cid3.acc_nam else '' end  as [cid_nam3],
		case when len(cid4.acc_id)=11 then cid4.acc_id else '' end as [cid4],case when len(cid4.acc_id)=11 then cid4.acc_nam else '' end as [cid_nam4],
		case when len(cid5.acc_id)=14 then cid5.acc_id else '' end as [cid5],case when len(cid5.acc_id)=14 then cid5.acc_nam else '' end as [cid_nam5],
		case when len(cid6.acc_id)=17 then cid6.acc_id else '' end as [cid6],case when len(cid6.acc_id)=17 then cid6.acc_nam else '' end as [cid_nam6],
		case when len(cid7.acc_id)=20 then cid7.acc_id else '' end as [cid7],case when len(cid7.acc_id)=20 then cid7.acc_nam else '' end as [cid_nam7],
		gl_m_acc.acc_id as [acc_id],gl_m_acc.acc_nam as [acc_nam],
		isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),2),0) as [famt],1 as [GTAG],1 as [MTAG],1 as [STAG],1 as [TAG],1 AS [T],'ASSETS' as [subrmk],'ASSETS' as [masrmk] 
		from t_dvch
		inner join gl_m_acc
		on t_dvch.acc_id=gl_m_acc.acc_id 
		--First Level
		left join gl_m_acc cid1
		on left(gl_m_acc.acc_cid,2)=cid1.acc_id
		--Second Level
		left join gl_m_acc cid2
		on left(gl_m_acc.acc_cid,5)=cid2.acc_id
		--Third Level
		left join gl_m_acc cid3
		on left(gl_m_acc.acc_cid,8)=cid3.acc_id
		--Forth Level
		left join gl_m_acc cid4
		on left(gl_m_acc.acc_cid,11)=cid4.acc_id
		--Fifth Level
		left join gl_m_acc cid5
		on left(gl_m_acc.acc_cid,14)=cid5.acc_id
		--Six Level
		left join gl_m_acc cid6
		on left(gl_m_acc.acc_cid,17)=cid6.acc_id
		--Seven Level
		left join gl_m_acc cid7
		on left(gl_m_acc.acc_cid,20)=cid7.acc_id
		where left(gl_m_acc.acc_id,len('01'))='01' and gl_m_acc.com_id=@com_id and gl_m_acc.br_id=@br_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		and gl_m_acc.acc_cid in ('01003')
		group by 
		cid1.acc_id,cid1.acc_nam,
		cid2.acc_id,cid2.acc_nam,
		cid3.acc_id,cid3.acc_nam,
		cid4.acc_id,cid4.acc_nam,
		cid5.acc_id,cid5.acc_nam,
		cid6.acc_id,cid6.acc_nam,
		cid7.acc_id,cid7.acc_nam,
		gl_m_acc.acc_id,gl_m_acc.acc_nam
		having SUM(dvch_dr_amt-dvch_cr_amt)<>0
		--Profit / (Loss) Statement
		union all
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],
		case when len(cid1.acc_id)=2 then cid1.acc_id else '' end as[cid1],case when len(cid1.acc_id)=2 then cid1.acc_nam else '' end as [cid_nam1],
		case when len(cid2.acc_id)=5 then cid2.acc_id else '' end as [cid2],case when len(cid2.acc_id)=5 then cid2.acc_nam else '' end as [cid_nam2],
		case when len(cid3.acc_id)=8 then cid3.acc_id else '' end as [cid3],case when len(cid3.acc_id)=8 then cid3.acc_nam else '' end  as [cid_nam3],
		case when len(cid4.acc_id)=11 then cid4.acc_id else '' end as [cid4],case when len(cid4.acc_id)=11 then cid4.acc_nam else '' end as [cid_nam4],
		case when len(cid5.acc_id)=14 then cid5.acc_id else '' end as [cid5],case when len(cid5.acc_id)=14 then cid5.acc_nam else '' end as [cid_nam5],
		case when len(cid6.acc_id)=17 then cid6.acc_id else '' end as [cid6],case when len(cid6.acc_id)=17 then cid6.acc_nam else '' end as [cid_nam6],
		case when len(cid7.acc_id)=20 then cid7.acc_id else '' end as [cid7],case when len(cid7.acc_id)=20 then cid7.acc_nam else '' end as [cid_nam7],
		gl_m_acc.acc_id as [acc_id],gl_m_acc.acc_nam as [acc_nam],
		isnull(round((SUM(amount)/@cur_rat),2),0) as [famt],1 as [GTAG],1 as [MTAG],1 as [STAG],1 as [TAG],1 AS [T],'ASSETS' as [subrmk],'ASSETS' as [masrmk] 
		from v_pl_bl
		inner join gl_m_acc
		on v_pl_bl.acc_id=gl_m_acc.acc_id 
		--First Level
		left join gl_m_acc cid1
		on left(gl_m_acc.acc_cid,2)=cid1.acc_id
		--Second Level
		left join gl_m_acc cid2
		on left(gl_m_acc.acc_cid,5)=cid2.acc_id
		--Third Level
		left join gl_m_acc cid3
		on left(gl_m_acc.acc_cid,8)=cid3.acc_id
		--Forth Level
		left join gl_m_acc cid4
		on left(gl_m_acc.acc_cid,11)=cid4.acc_id
		--Fifth Level
		left join gl_m_acc cid5
		on left(gl_m_acc.acc_cid,14)=cid5.acc_id
		--Six Level
		left join gl_m_acc cid6
		on left(gl_m_acc.acc_cid,17)=cid6.acc_id
		--Seven Level
		left join gl_m_acc cid7
		on left(gl_m_acc.acc_cid,20)=cid7.acc_id
		where gl_m_acc.com_id=@com_id and gl_m_acc.br_id=@br_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2		
		group by 
		cid1.acc_id,cid1.acc_nam,
		cid2.acc_id,cid2.acc_nam,
		cid3.acc_id,cid3.acc_nam,
		cid4.acc_id,cid4.acc_nam,
		cid5.acc_id,cid5.acc_nam,
		cid6.acc_id,cid6.acc_nam,
		cid7.acc_id,cid7.acc_nam,
		gl_m_acc.acc_id,gl_m_acc.acc_nam
		having SUM(amount)<>0		
		UNION ALL
		--Libilities
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],
		case when len(cid1.acc_id)=2 then cid1.acc_id else '' end as[cid1],case when len(cid1.acc_id)=2 then cid1.acc_nam else '' end as [cid_nam1],
		case when len(cid2.acc_id)=5 then cid2.acc_id else '' end as [cid2],case when len(cid2.acc_id)=5 then cid2.acc_nam else '' end as [cid_nam2],
		case when len(cid3.acc_id)=8 then cid3.acc_id else '' end as [cid3],case when len(cid3.acc_id)=8 then cid3.acc_nam else '' end  as [cid_nam3],
		case when len(cid4.acc_id)=11 then cid4.acc_id else '' end as [cid4],case when len(cid4.acc_id)=11 then cid4.acc_nam else '' end as [cid_nam4],
		case when len(cid5.acc_id)=14 then cid5.acc_id else '' end as [cid5],case when len(cid5.acc_id)=14 then cid5.acc_nam else '' end as [cid_nam5],
		case when len(cid6.acc_id)=17 then cid6.acc_id else '' end as [cid6],case when len(cid6.acc_id)=17 then cid6.acc_nam else '' end as [cid_nam6],
		case when len(cid7.acc_id)=20 then cid7.acc_id else '' end as [cid7],case when len(cid7.acc_id)=20 then cid7.acc_nam else '' end as [cid_nam7],
		gl_m_acc.acc_id as [acc_id],gl_m_acc.acc_nam as [acc_nam],
		isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),2),0) as [famt],1 as [GTAG],1 as [MTAG],2 as [STAG],1 as [TAG],1 AS [T],'ASSETS' as [subrmk],'ASSETS' as [masrmk] 
		from t_dvch
		inner join gl_m_acc
		on t_dvch.acc_id=gl_m_acc.acc_id 
		--First Level
		left join gl_m_acc cid1
		on left(gl_m_acc.acc_cid,2)=cid1.acc_id
		--Second Level
		left join gl_m_acc cid2
		on left(gl_m_acc.acc_cid,5)=cid2.acc_id
		--Third Level
		left join gl_m_acc cid3
		on left(gl_m_acc.acc_cid,8)=cid3.acc_id
		--Forth Level
		left join gl_m_acc cid4
		on left(gl_m_acc.acc_cid,11)=cid4.acc_id
		--Fifth Level
		left join gl_m_acc cid5
		on left(gl_m_acc.acc_cid,14)=cid5.acc_id
		--Six Level
		left join gl_m_acc cid6
		on left(gl_m_acc.acc_cid,17)=cid6.acc_id
		--Seven Level
		left join gl_m_acc cid7
		on left(gl_m_acc.acc_cid,20)=cid7.acc_id
		where left(gl_m_acc.acc_id,len('02'))='02' and gl_m_acc.com_id=@com_id and gl_m_acc.br_id=@br_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		group by 
		cid1.acc_id,cid1.acc_nam,
		cid2.acc_id,cid2.acc_nam,
		cid3.acc_id,cid3.acc_nam,
		cid4.acc_id,cid4.acc_nam,
		cid5.acc_id,cid5.acc_nam,
		cid6.acc_id,cid6.acc_nam,
		cid7.acc_id,cid7.acc_nam,
		gl_m_acc.acc_id,gl_m_acc.acc_nam
		having SUM(dvch_dr_amt-dvch_cr_amt)<>0
		UNION ALL
		--Assets
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],
		case when len(cid1.acc_id)=2 then cid1.acc_id else '' end as[cid1],case when len(cid1.acc_id)=2 then cid1.acc_nam else '' end as [cid_nam1],
		case when len(cid2.acc_id)=5 then cid2.acc_id else '' end as [cid2],case when len(cid2.acc_id)=5 then cid2.acc_nam else '' end as [cid_nam2],
		case when len(cid3.acc_id)=8 then cid3.acc_id else '' end as [cid3],case when len(cid3.acc_id)=8 then cid3.acc_nam else '' end  as [cid_nam3],
		case when len(cid4.acc_id)=11 then cid4.acc_id else '' end as [cid4],case when len(cid4.acc_id)=11 then cid4.acc_nam else '' end as [cid_nam4],
		case when len(cid5.acc_id)=14 then cid5.acc_id else '' end as [cid5],case when len(cid5.acc_id)=14 then cid5.acc_nam else '' end as [cid_nam5],
		case when len(cid6.acc_id)=17 then cid6.acc_id else '' end as [cid6],case when len(cid6.acc_id)=17 then cid6.acc_nam else '' end as [cid_nam6],
		case when len(cid7.acc_id)=20 then cid7.acc_id else '' end as [cid7],case when len(cid7.acc_id)=20 then cid7.acc_nam else '' end as [cid_nam7],
		gl_m_acc.acc_id as [acc_id],gl_m_acc.acc_nam as [acc_nam],
		isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),2),0) as [famt],1 as [GTAG],2 as [MTAG],3 as [STAG],1 as [TAG],1 AS [T],'ASSETS' as [subrmk],'ASSETS' as [masrmk] 
		from t_dvch
		inner join gl_m_acc
		on t_dvch.acc_id=gl_m_acc.acc_id 
		--First Level
		left join gl_m_acc cid1
		on left(gl_m_acc.acc_cid,2)=cid1.acc_id
		--Second Level
		left join gl_m_acc cid2
		on left(gl_m_acc.acc_cid,5)=cid2.acc_id
		--Third Level
		left join gl_m_acc cid3
		on left(gl_m_acc.acc_cid,8)=cid3.acc_id
		--Forth Level
		left join gl_m_acc cid4
		on left(gl_m_acc.acc_cid,11)=cid4.acc_id
		--Fifth Level
		left join gl_m_acc cid5
		on left(gl_m_acc.acc_cid,14)=cid5.acc_id
		--Six Level
		left join gl_m_acc cid6
		on left(gl_m_acc.acc_cid,17)=cid6.acc_id
		--Seven Level
		left join gl_m_acc cid7
		on left(gl_m_acc.acc_cid,20)=cid7.acc_id
		where left(gl_m_acc.acc_id,len('03'))='03'  and gl_m_acc.com_id=@com_id and gl_m_acc.br_id=@br_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		group by 
		cid1.acc_id,cid1.acc_nam,
		cid2.acc_id,cid2.acc_nam,
		cid3.acc_id,cid3.acc_nam,
		cid4.acc_id,cid4.acc_nam,
		cid5.acc_id,cid5.acc_nam,
		cid6.acc_id,cid6.acc_nam,
		cid7.acc_id,cid7.acc_nam,
		gl_m_acc.acc_id,gl_m_acc.acc_nam
		having SUM(dvch_dr_amt-dvch_cr_amt)<>0


end
