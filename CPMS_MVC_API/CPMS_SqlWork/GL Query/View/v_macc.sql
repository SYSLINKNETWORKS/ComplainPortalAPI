USE zsons
GO
----View for Master Account

ALTER view [dbo].[v_macc]
as
select 
		a.com_id,a.br_id,a.acc_no,a.acc_id as [ID],a.acc_nam as [Name],a.cur_id,cur_snm as [Currency],a.acc_des+'-{'+rtrim(a.acc_id)+'}' as [Description],a.acc_oid as [Old Account ID],a.acc_cid as [Control ID],b.acc_no as [ControlNo],b.acc_nam as [Control Name],a.acc_lvl as [Level],a.acc_dm as [Master/Detail],a.acc_typ,a.acc_act as [Active] 
	from gl_m_acc a 
	--Self join 
	left join gl_m_acc b 
	on a.acc_cid=b.acc_id
	--Left Join with Currency
	left join m_cur 
	on a.cur_id=m_cur.cur_id
	where a.acc_del=0

--select * from v_macc where 
--select yr_id,yr_str_dt,yr_end_dt from gl_m_yr where yr_ac='Y'
GO
