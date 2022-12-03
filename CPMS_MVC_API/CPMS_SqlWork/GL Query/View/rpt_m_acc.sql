USE ZSONS
GO
--View for Master Account
alter view [dbo].[rpt_m_acc]
as
select 
		'01' as [com_id],'01' as [br_id],(select yr_id from gl_m_yr where yr_ac='Y') as [yr_id],gl_m_acc.acc_id,gl_m_acc.acc_nam,acc_lvl,acc_dm,isnull(v_rpt_acc_obal.acc_fobal,0) as [acc_fobal],isnull(v_rpt_acc_obal.acc_obal,0) as [acc_obal],cur_id,cur_snm
		from gl_m_acc
		left join v_rpt_acc_obal
		on gl_m_acc.com_id=v_rpt_acc_obal.com_id 
		and gl_m_acc.acc_no=v_rpt_acc_obal.acc_no
		and v_rpt_acc_obal.yr_id=(select yr_id from gl_m_yr where yr_ac='Y')
GO


--select count(*) from gl_m_acc





