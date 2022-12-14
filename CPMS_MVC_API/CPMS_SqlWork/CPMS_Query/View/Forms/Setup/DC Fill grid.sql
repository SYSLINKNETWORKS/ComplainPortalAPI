--drop view v_dg_sal
use MEIJI
go

ALTER view [dbo].[v_dg_sal]
as
select itm_det.det_id,det_nam as [Name],0 as [Desp. (A)],0 as [Desp. (B)],0 as [Total Desp.],0 as [Return],0 as [Unsold],0 as [Sold],pri_rat as [Rate],0.00 as [Sale Amount],isnull(com_com,0.00) as [Comm. %],isnull(com_fr,0.00) as [Flat_Rate],0.00 as [Comm. Amount],itm_det.itm_id,itm_nam,pri_dat,com_dt,cus_id,sot_dat,sot_no  from itm_det
		--Join with Item Price
		inner join itm_pri
		on itm_det.det_id=itm_pri.det_id
		--Join with Customer Commission
		inner join cus_com
		on itm_det.det_id=cus_com.det_id
		--Join with Item master
		inner join m_itm
		on itm_det.itm_id=m_itm.itm_id
		--Join with item sort
		inner join itm_sot
		on itm_det.det_id=itm_sot.det_id
		where det_act=1
		
--		where 
--			pri_dat=(select max(pri_dat) from itm_pri where pri_dat<='01/14/2009 00:00:00.000')
--		and com_dt= (select max(com_dt) from cus_com where com_dt<='01/14/2009 00:00:00.000')
--		and cus_id='01'
GO


-----Update DC GRID VIEW
ALTER view [dbo].[v_upd_dsal]
as
SELECT     t_dsal.det_id,t_msal.m_yr_id, det_nam AS [Name], dsal_dspa AS [Desp. (A)],dsal_dspb AS [Desp. (B)], 0 AS [Total Desp.], 
                      dsal_ret AS [Return], dsal_usol AS [Unsold], 0 AS [Sold], pri_rat AS [Rate], 0.00 AS [Sale Amount], 
                      com_com AS [Comm. %], 0.00 AS [Comm. Amount], pri_dat, com_dt, t_msal.mcus_id,t_msal.dcus_id, t_dsal.msal_id,msal_no, 
                     itm_det.itm_id,itm_sot.sot_dat,sot_no
FROM         t_dsal 
						--Sale Master
	   					inner JOIN	t_msal 
						on t_dsal.msal_id=t_msal.msal_id 
						and t_dsal.m_yr_id=t_msal.m_yr_id 
						--Item Detail
						inner join itm_det 
						ON t_dsal.det_id = itm_det.det_id 
						--Customer Commission						
						inner JOIN cus_com 
						ON itm_det.det_id = cus_com.det_id 
						and t_msal.dcus_id=cus_com.cus_id
						and t_msal.comm_dt=cus_com.com_dt
						--Item Master
						inner JOIN m_itm 
						ON itm_det.itm_id = m_itm.itm_id
						--Item Sort
						left join itm_sot
						on itm_det.det_id=itm_sot.det_id
						--and t_msal.sot_dat=itm_sot.sot_dat
GO

--select * from v_upd_dsal where msal_id=00309
--select * from t_msal where msal_no=6315
--select * from v_upd_dsal where pri_dat=(select max(pri_dat) from itm_pri where pri_dat<='05/22/2009') and com_dt= (select max(com_dt) from cus_com where com_dt<='05/22/2009' and cus_id=49 ) and mcus_id=2 and msal_id=309 and sot_dat=(select max(sot_dat) from itm_sot where sot_dat<='05/22/2009') order by sot_no
--select * from itm_sot
