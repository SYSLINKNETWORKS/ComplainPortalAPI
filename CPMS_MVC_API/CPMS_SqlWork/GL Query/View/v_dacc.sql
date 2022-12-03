----View for Detail Account
ALTER view [dbo].[v_dacc]
as
	select com_id,br_id,gl_m_acc.acc_id,yr_id,acc_des+'-{'+rtrim(gl_m_acc.acc_id)+'}' as [acc_nam] from gl_m_acc inner join gl_br_acc on gl_m_acc.acc_id=gl_br_acc.acc_id where acc_dm='D'
GO
