
----View for Select account
ALTER view [dbo].[sel_gl_acc] 
as
	select com_id,br_id,gl_m_acc.acc_id as [ID],gl_m_acc.acc_nam as [Name],acc_des+' - ('+acc_cid+')' as [Control Account],acc_oid as [Old Account],acc_dm as [Master/ Detail],acc_typ 
from gl_m_acc 
--where br_id=@br_id
--order by gl_m_acc.acc_id
GO


