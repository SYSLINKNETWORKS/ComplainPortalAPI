USe MEIJI_RUSK
GO

/****** Object:  StoredProcedure [dbo].[rpt_sal_daily]    Script Date: 08/07/2015 12:19:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--drop table tmp_sal_daily
--create table tmp_sal_daily
--(
--DC int,
--m_yr_id char(2),
--sec_id int,
--sec_nam varchar(100),
--cus_id int,
--cus_nam varchar(250),
--drv_id int,
--drv_nam varchar(250),
--mso_rmk varchar(250),
--bread_desp_amount float,
--rusk_desp_amount float,
--wr_desp_amount float,
--[return] float,
--unsold float,
--msal_comm float,
--fuel float,
--misc_amount float,
--cash_received float,

--pbal float
--)


--ES float,
--mso_salamt float,
--mso_salrmk varchar(255),

--exec rpt_sal_daily '01','08/01/2015','08/08/2015'

--Drop proc rpt_sal_daily
--go
ALTER proc [dbo].[rpt_sal_daily](@m_yr_id char(2),@dt1 datetime,@dt2 datetime)
as
begin
	
	select 
	t_mso.com_id,t_mso.br_id,mso_no as [DC],t_mso.mso_dat,t_mso.m_yr_id,t_mso.sec_id,sec_nam,t_mso.cus_id,cus_nam,t_mso.drv_id,drv_nam,mso_rmk,
			isnull(sum(case when v_titm.itm_id=1 then (dso_despa+dso_despb)*titmrat_rrat end),0) as [Bread_Desp_Amount],
			isnull(sum(case when v_titm.itm_id=10 then (dso_despa+dso_despb)*titmrat_rrat end),0) as [Rusk_Desp_Amount],
			isnull(sum(case when v_titm.itm_id=11 then (dso_despa+dso_despb)*titmrat_rrat end),0) as [CAKE_Desp_Amount],
			sum(dso_ret*titmrat_rrat) as [Return],sum(dso_usola+dso_usolb*titmrat_rrat) AS [Unsold],sum((dso_despa+dso_despb-(dso_ret+dso_usola+dso_usolb))*(titmrat_rrat*(cuscom_com/100))) as [msal_comm],mso_fueamt as [Fuel],mso_cashrec as [Cash_received],mso_cashrec as [E/S],--mso_salamt,mso_salrmk
			m_cus.cus_id,outstanding as [previous balance],mso_misamt as [misc_amount]
		from t_mso
		--Join with Sector
		left join m_sec
		on t_mso.sec_id=m_sec.sec_id
		----Join with Detail Customer
		inner join m_cus
		on t_mso.cus_id=m_cus.cus_id
		----Join with Driver 
		left join m_Drv
		on t_mso.drv_id=m_drv.drv_id
		----Detail Sales
		inner join t_dso
		on t_mso.mso_id=t_dso.mso_id
		---and t_mso.m_yr_id=t_dso.m_yr_id
		---Item Price		
		left join t_itmrat
		on t_dso.titm_id=t_itmrat.titm_id 
		and titmrat_dat=(select max(titmrat_dat) from t_itmrat titmrat where t_itmrat.titm_id=titmrat.titm_id and  titmrat.titmrat_dat<=t_mso.mso_dat)		
		----Detail Item
		inner join v_titm
		on t_dso.titm_id=v_titm.titm_id		
		----Join with commission table
		left join m_cuscom
		on t_dso.titm_id=m_cuscom.titm_id
		and t_mso.mso_dat=m_cuscom.cuscom_dat		
		and m_cus.cus_id=m_cuscom.cus_id
		--Balance
		left join v_so_acc_bal_m		
		on v_so_acc_bal_m.yr_id=@m_yr_id 
		and t_mso.com_id=v_so_acc_bal_m.com_id
		and v_so_acc_bal_m.acc_no =m_cus.acc_no 
		----Daily Receiving Date wise
		--left join rpt_sal_daily_rec
		--on t_mso.cus_id=rpt_sal_daily_rec.cus_id
		--and t_mso.mso_dat=rpt_sal_daily_rec.mrec_dat
		where mso_dat between @dt1 and @dt2 
--Group by
	group by t_mso.com_id,t_mso.br_id,mso_no,t_mso.mso_dat,t_mso.m_yr_id,t_mso.sec_id,sec_nam,t_mso.cus_id,cus_nam,mso_fueamt,mso_cashrec,t_mso.drv_id,drv_nam,mso_rmk,m_cus.cus_id,mso_misamt,outstanding

end

go
--Total Credit
alter view v_so_acc_bal_m
as
select 
com_id,yr_id,acc_no,
isnull(SUM(outstanding),0)+isnull(SUM(bankoutstanding),0) + isnull(SUM(unrealizechq),0) as [outstanding]
from v_so_acc_bal 
 group by com_id,yr_id,acc_no
 
---Daily Receiving
go
alter view rpt_sal_daily_rec
as
select cus_id,mrec_dat,sum(drec_namt) as [drec_namt] from
t_mrec 
inner join t_drec 
on t_mrec.mrec_id=t_drec.mrec_id
group by cus_id,mrec_dat

GO


