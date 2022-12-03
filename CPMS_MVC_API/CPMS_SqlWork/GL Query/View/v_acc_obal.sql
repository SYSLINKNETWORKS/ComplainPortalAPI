--View for Account Opening Balance

ALTER view [dbo].[v_acc_obal]
as
select s_no,com_id,br_id,acc_id,acc_oid,acc_obal,yr_id,
	case when (acc_obal>=1) then acc_obal else 0 end as [acc_ODR],
	case when (acc_obal<1) then acc_obal else 0 end as [acc_OCR]
 from gl_br_acc
GO

