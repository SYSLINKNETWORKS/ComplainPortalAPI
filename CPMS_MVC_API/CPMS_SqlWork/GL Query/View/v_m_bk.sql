USE phm
GO
--alter table gl_m_bk add cur_id int
--update gl_m_bk set cur_id=(select cur_id from m_cur where cur_typ='S')
----View for Bank Account
alter view [dbo].[v_m_bk]
as
select 
	bk_id as [ID],gl_m_bk.cur_id as [Currency ID],rtrim(cur_snm) as [Currency],bk_act as [Active],gl_m_bk.bktyp_id as [Account Type ID],rtrim(bktyp_nam) as [Account Type],bk_nam as [Name],bk_title as [Title of Account],bk_cp as [Contact Person],bk_add as [Address],bk_pho as [Phone],bk_fax as [Fax], bk_eml as [Email], bk_web as [Web], bk_acc as [Account No],bk_chq as [Cheque No.], bk_lev as [No. of Leaves], acc_id as [GL Account ID],bk_typ as [Type],log_act 
	from gl_m_bk
	--Join with Chart of Account
	inner join gl_m_acc
	on gl_m_bk.com_id =gl_m_acc.com_id 
	and gl_m_bk.acc_no =gl_m_acc.acc_no
	--Join with Bank type
	inner join gl_m_bktyp
	on gl_m_bk.bktyp_id=gl_m_bktyp.bktyp_id
	--Join with Currency
	inner join m_cur
	on gl_m_bk.cur_id=m_cur.cur_id
GO

