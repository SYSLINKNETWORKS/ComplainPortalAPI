----View for Select Master Account
ALTER view [dbo].[sel_accmaster]
as
select acc_nam from gl_m_acc where acc_id in (select acc_cid from gl_m_acc)
GO
