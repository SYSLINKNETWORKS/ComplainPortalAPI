USE PHM
GO

--declare @com_id char(2),@m_yr_id char(2),@dt1 datetime,@dt2 datetime
--set @com_id='01'
--set @m_yr_id='01'
--set @dt1='03/15/2014'
--set @dt2='06/30/2014'
--go
--exec sp_gl_cashflow '01','01','07/31/2013','06/30/2014'

alter proc sp_gl_cashflow (@com_id char(2),@m_yr_id char(2),@dt1 datetime,@dt2 datetime)
as
--Cash Flow from Operationg Expense
select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0) as [amt],'Cash received from customers' as [Account], 1 as [Tag],1 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and left(acc_id,(select len(acc_id) from m_sys inner join gl_m_acc on m_sys.cus_acc=gl_m_acc.acc_no)) in (select acc_id from m_sys inner join gl_m_acc on m_sys.cus_acc=gl_m_acc.acc_no)
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
union all	
--Supplier
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Cash paid for Supplier' as [Account], 2 as [Tag],1 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and left(acc_id,(select len(acc_id) from m_sys inner join gl_m_acc on m_sys.sup_acc=gl_m_acc.acc_no)) in (select acc_id from m_sys inner join gl_m_acc on m_sys.sup_acc=gl_m_acc.acc_no)
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
union all	
--Wages and Other Operating Expenses
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Cash paid for wages and other operating expenses' as [Account], 3 as [Tag],1 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and left(acc_id,5) in ('05006','05007')
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
union all	
--Others --Expenses
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Others' as [Account], 4 as [Tag],1 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and left(acc_id,2) in ('05') and LEFT(acc_id,5) not in ('05001','05004','05006','05007')
	and typ_id in ('01','02')	
	group by t_mvch.com_id,mvch_tax
union all	
--Others --Revenue
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Others' as [Account], 4 as [Tag],1 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and left(acc_id,2) in ('04') 
	and typ_id in ('01','02')	
	group by t_mvch.com_id,mvch_tax
--Cash flow from Investing Activities
union all	
--Cash from sale of capital assets
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Cash from sale of capital assets' as [Account], 1 as [Tag],2 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and left(acc_id,5) in ('03001')
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
union all
--Cash from disposition of business segments
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Cash from disposition of business segments' as [Account], 2 as [Tag],2 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and LEFT(acc_id,2) in ('01')
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
union all
--Other -02
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Others' as [Account], 3 as [Tag],2 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and LEFT(acc_id,8) not in ('02003001') and LEFT(acc_id,2) in ('02')
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
union all
--Other -03
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Others' as [Account], 3 as [Tag],2 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and LEFT(acc_id,8) not in ('03001001','03002001','03002003','03002004') and LEFT(acc_id,2) in ('03')
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
--Cash flow from Financial Activities
union all	
--Cash flows from financing activities					
	select 
	t_mvch.com_id,isnull(SUM(dvch_cr_amt-dvch_dr_amt),0),'Others' as [Account], 1 as [Tag],3 as [GTAG],1 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt between @dt1 and @dt2
	and mvch_can=0 and mvch_app='Y'
	and left(acc_id,5) in ('05004')
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
--Cash balance at the beginning of the period				
union all	
--Cash balance at the beginning of the period Opening Voucher									
	select 
	t_mvch.com_id,isnull(SUM(dvch_dr_amt-dvch_cr_amt),0),'Cash balance at the beginning of the period' as [Account], 1 as [Tag],4 as [GTAG],2 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_can=0
	and left(acc_cid,(select len(acc_id) from m_sys inner join gl_m_acc glmacc on m_sys.cash_acc =glmacc.acc_no)) in (select acc_id from m_sys inner join gl_m_acc glmacc on m_sys.cash_acc =glmacc.acc_no)
	and typ_id in ('06')
	group by t_mvch.com_id,mvch_tax
union all	
--Cash balance at the beginning of the period Till Date								
	select 
	t_mvch.com_id,isnull(SUM(dvch_dr_amt-dvch_cr_amt),0),'Cash balance at the beginning of the period' as [Account], 1 as [Tag],4 as [GTAG],2 AS [MTAG],1 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt<@dt1
	and mvch_can=0 and mvch_app='Y'
	and left(acc_cid,(select len(acc_id) from m_sys inner join gl_m_acc glmacc on m_sys.cash_acc =glmacc.acc_no)) in (select acc_id from m_sys inner join gl_m_acc glmacc on m_sys.cash_acc =glmacc.acc_no)
	and typ_id in ('01','02')
	group by t_mvch.com_id,mvch_tax
union all	
--AS PER LEDGER
	select 
	t_mvch.com_id,-isnull(SUM(dvch_dr_amt-dvch_cr_amt),0),'AS PER LEDGER' as [Account], 1 as [Tag],5 as [GTAG],3 AS [MTAG],2 AS [KTAG],mvch_tax
	from 
	t_mvch 
	inner join t_dvch
	on t_mvch.com_id=t_Dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id 
	and mvch_dt <= @dt2
	and mvch_can=0 and mvch_app='Y'
	and left(acc_id,(select len(acc_id) from m_sys inner join gl_m_acc glmacc on m_sys.cash_acc =glmacc.acc_no)) = (select acc_id from m_sys inner join gl_m_acc glmacc on m_sys.cash_acc =glmacc.acc_no)
	and t_mvch.typ_id in ('01','02','06')
	group by t_mvch.com_id,mvch_tax
--exec sp_gl_cashflow '01','01','07/31/2013','06/30/2014'
