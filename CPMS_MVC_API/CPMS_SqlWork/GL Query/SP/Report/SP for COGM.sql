USE ZSONS
go
--EXEC sp_rpt_cogs '01','01','07/06/2012','07/06/2012',2
--alter table m_sys add acc_purdis char(20)
--update m_sys set acc_purdis='05005002'

alter proc sp_rpt_cogs(@com_id char(2),@m_yr_id char(2),@dt1 datetime,@dt2 datetime,@cur_id int)
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
		
	--COGS
	--Direct Material
	--Purchase opening ONLY WIP
	select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],gl_m_acc.acc_id,right(acc_nam,len(acc_nam)-18) +' Opening Stock' as [acc_nam],isnull(round((SUM(dvch_dr_amt)/@cur_rat),4),0) as [famt],isnull(round(SUM(dvch_dr_amt-dvch_cr_amt),4),0) as [amt],1 as [GTAG],1 as [PTAG],1 as [MTAG],1 as [STAG],1 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk],0 as [famt1],0 as [amt1],0 as [famt2],0 as [amt2],isnull(round((SUM(dvch_dr_amt)/@cur_rat),2),0) as [famt3],isnull(round(SUM(dvch_dr_amt-dvch_cr_amt),4),0) as [amt3],mvch_tax
	from gl_m_acc
	left join t_dvch
	on gl_m_acc.com_id =t_dvch.com_id 
	and gl_m_acc.acc_no=t_dvch.acc_no
	left join t_mvch
	on t_dvch.com_id =t_mvch.com_id
	and t_dvch.br_id=t_mvch.br_id 
	and t_dvch.mvch_no=t_mvch.mvch_no 
	and mvch_dt between @dt1 and @dt2 and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id
	where left(acc_cid,len('03002004'))='03002004' and gl_m_acc.acc_id in ('03002004008')  
	group by gl_m_acc.acc_id,acc_nam,mvch_tax
	union all
	--Purchase opening Expect WIP
	select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],acc_id,right(acc_nam,len(acc_nam)-18) +' Opening Stock' as [acc_nam],isnull(round((SUM(dvch_dr_amt)/@cur_rat),4),0) as [famt],round(SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt],1 as [GTAG],2 as [PTAG],2 as [MTAG],2 as [STAG],2 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,0 as [famt1],0 as [amt1],isnull(round((SUM(dvch_dr_amt)/@cur_rat),4),0) as [famt2],round(SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where left(acc_cid,len('03002004'))='03002004' and acc_id not in ('03002004001','03002004008') and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	group by acc_id,acc_nam,mvch_tax
	union all
	--Add Purchase
	select @cur_snm,@cur_rat as [cur_rat],'05001' as [acc_id],'Add: Purchases' as [acc_nam],isnull(round((SUM(isnull(dvch_dr_amt,0))/@cur_rat),4),0) as [famt],round(SUM(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)),4) as [amt],1 as [GTAG],2 as [PTAG],2 as [MTAG],2 as [STAG],3 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,isnull(round((SUM(isnull(dvch_dr_amt,0))/@cur_rat),4),0) as [famt1],round(SUM(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)),4) as [amt1],0 as [famt2],0 as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where left(acc_cid,len('05001')) in ('05001') and acc_cid not in ((select wip_acc from m_sys),(select wip_ret_acc from m_sys),(select wip_ret_acc from m_sys)) and acc_id not in (select fg_acc from m_sys)  and gl_m_acc.com_id=@com_id  and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2	
	group by mvch_tax
	union all	
	--Less Closing Other Purchases
	select @cur_snm,@cur_rat as [cur_rat],'05005' as [acc_id],'Add: '+acc_nam as [acc_nam],isnull(round((SUM(isnull(dvch_dr_amt,0))/@cur_rat),4),0) as [famt],round(SUM(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)),4) as [amt],1 as [GTAG],2 as [PTAG],2 as [MTAG],2 as [STAG],3 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,isnull(round((SUM(isnull(dvch_dr_amt,0))/@cur_rat),4),0) as [famt1],round(SUM(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)),4) as [amt1],0 as [famt2],0 as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where left(acc_cid,len('05005')) = '05005' and acc_id not in (select acc_purdis from m_sys) and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	group by acc_id,acc_nam,mvch_tax
	union all
	--Less Purchase Return
	select @cur_snm,@cur_rat as [cur_rat],acc_id as [acc_id],'Less: Purchases Return' as [acc_nam],isnull(-round((SUM(dvch_cr_amt)/@cur_rat),4),0) as [famt],round(SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt],1 as [GTAG],2 as [PTAG],2 as [MTAG],2 as [STAG],3 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,isnull(-round((SUM(dvch_cr_amt)/@cur_rat),4),0) as [famt1],round(SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt1],0 as [famt2],0 as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where acc_id in ((select pur_ret_acc from m_sys))  and gl_m_acc.com_id=@com_id  and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	group by acc_id	,mvch_tax
	union all
	--Less Closing Opening
	select @cur_snm,@cur_rat as [cur_rat],itmacc.acc_id,'Less :'+right(itmacc.acc_nam,len(itmacc.acc_nam)-8) +' Closing Stock' as [acc_nam],isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],round(SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt],1 as [GTAG],2 as [PTAG],2 as [MTAG],3 as [STAG],4 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt1],round(SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt1],0 as [famt2],0 as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	inner join m_itm
	on gl_m_acc.acc_id=m_itm.oacc_id
	inner join gl_m_acc itmacc
	on m_itm.cacc_id=itmacc.acc_id 
	where left(gl_m_acc.acc_cid,len('03002004')) ='03002004' and gl_m_acc.acc_cid not in (select wipo_acc from m_sys) and gl_m_acc.acc_id not in ('03002004001',(select fg_acc from m_sys)) and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	group by itmacc.acc_id,itmacc.acc_nam,mvch_tax
	union all
	--Less Closing Purchases
	select @cur_snm,@cur_rat as [cur_rat],acc_id,'Less :'+right(acc_nam,len(acc_nam)-8) +' Closing Stock' as [acc_nam],isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],-SUM(dvch_dr_amt-dvch_cr_amt) as [amt],1 as [GTAG],2 as [PTAG],2 as [MTAG],3 as [STAG],4 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt1],-SUM(dvch_dr_amt-dvch_cr_amt) as [amt1],0 as [famt2],0 as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where left(acc_cid,len('05001')) = '05001' and gl_m_acc.acc_cid not in ((select wip_acc from m_sys),(select wip_ret_acc from m_sys)) and acc_id not in ((select pur_ret_acc from m_sys),(select fg_acc from m_sys)) and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	group by acc_id,acc_nam,mvch_tax
	union all
	--Less Closing Other Purchases
	select @cur_snm,@cur_rat as [cur_rat],acc_id,'Less : '+acc_nam as [acc_nam],isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],-SUM(dvch_dr_amt-dvch_cr_amt) as [amt],1 as [GTAG],2 as [PTAG],2 as [MTAG],3 as [STAG],4 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt1],-SUM(dvch_dr_amt-dvch_cr_amt) as [amt1],0 as [famt2],0 as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where left(acc_cid,len('05005')) = '05005' and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2 and acc_id not in (select acc_purdis from m_sys) 
	group by acc_id,acc_nam,mvch_tax
	union all
	--Less Purchase Discount
	select @cur_snm,@cur_rat as [cur_rat],acc_id as [acc_id],'Less: '+acc_nam as [acc_nam],(round(SUM(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)),4)) as [famt],(round(SUM(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)),4)) as [amt],1 as [GTAG],2 as [PTAG],2 as [MTAG],3 as [STAG],4 as [TAG],' DIRECT MATERIAL' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,(round(SUM(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)),4)) as [famt1],(round(SUM(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)),4)) as [amt1],0 as [famt2],0 as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where acc_id in (select acc_purdis from m_sys) and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	group by acc_id,acc_nam	,mvch_tax
	union all
	--Direct Labour
	select @cur_snm,@cur_rat as [cur_rat],acc_id,acc_nam,isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],SUM(dvch_dr_amt-dvch_cr_amt) as [amt],1 as [GTAG],2 as [PTAG],3 as [MTAG],4 as [STAG],5 as [TAG],'DIRECT LABOUR' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,0 as [famt1],0 as [amt1],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt2],SUM(dvch_dr_amt-dvch_cr_amt) as [amt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where left(acc_cid,len('05006'))='05006' and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	group by acc_id,acc_nam,mvch_tax
	union all
	--FACTORY OVERHEAD
	select @cur_snm,@cur_rat as [cur_rat],acc_id,acc_nam,isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],round(SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt],1 AS [GTAG],2 as [PTAG],3 as [MTAG],5 as [STAG],6 as [TAG],'FACTORY OVERHEAD' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,0 as [famt1],0 as [amt1],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt2],round(SUM(dvch_dr_amt-dvch_cr_amt),0) as [famt2],0 as [famt3],0 as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where left(acc_cid,len('05007'))='05007' and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	group by acc_id,acc_nam,mvch_tax
	union all
	--Closing Work in Process
	select @cur_snm,@cur_rat as [cur_rat],acc_cid,'LESS: CLOSING STOCK OF GOODS IN PROCESS' AS [acc_nam],isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],round(-SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt],2 AS [GTAG],3 as [PTAG],4 as [MTAG],6 as [STAG],7 as [TAG],'Work-in-process Closing' as [subrmk],'COST OF GOODS MANUFACTURED' as [masrmk] ,0 as [famt1],0 as [amt1],0 as [famt2],0 as [amt2],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt3],round(-SUM(dvch_dr_amt-dvch_cr_amt),0) as [amt3],mvch_tax
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.com_id=gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no
	where acc_cid=(select wip_acc from m_sys) and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
	GROUP by acc_cid,mvch_tax
end





