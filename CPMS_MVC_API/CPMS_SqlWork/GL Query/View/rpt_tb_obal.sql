----View for Trial Balance opening

ALTER view [dbo].[rpt_tb_obal]
as
	select com_id,br_id,acc_id,acc_dat as [Opening_Date],acc_obal from gl_br_acc
GO

