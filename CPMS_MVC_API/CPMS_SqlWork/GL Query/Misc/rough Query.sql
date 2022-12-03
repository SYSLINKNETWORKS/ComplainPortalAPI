--select * from t_dvch
--delete from t_mvch
--update gl_br_acc set acc_obal=0

--select * from gl_m_acc  where acc_id not in ('01','02','03','04','05')
--select * from gl_br_acc where acc_id not in ('01','02','03','04','05')
--delete from gl_br_acc where acc_id not in ('01','02','03','04','05')
--delete from gl_m_acc where acc_id not in ('01','02','03','04','05')
--delete from gl_m_bk
--delete from gl_bk_chq
--select * from m_Sys
--delete from m_sys
--select * from gl_vch_typ
--update gl_vch_typ set acc_id = null
--delete from t_dvch where mvch_dt>='07/01/2009'
--delete from t_mvch where mvch_dt>='07/01/2009'
--update gl_br_acc set acc_obal=0 where left(acC_id,2) in ('04','05')

--update t_dvch set acc_id='04007' where  acc_id='01002003'

select * from rough.dbo.t_mvch where mvch_dt between '07/01/2009' and '07/31/2009'
select * from rough.dbo.t_dvch where mvch_dt between '07/01/2009' and '07/31/2009'



