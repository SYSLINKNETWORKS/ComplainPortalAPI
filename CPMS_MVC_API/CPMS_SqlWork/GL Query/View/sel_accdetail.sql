----Select Account Detail
ALTER view [dbo].[sel_accdetail]
as
select acc_nam from gl_m_acc where acc_id not in (select acc_id from gl_m_acc where acc_id in (select acc_cid from gl_m_acc))
GO

