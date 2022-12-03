USE ZSONS
GO

alter view v_rpt_sms
as
SELECT 
m_sms.com_id,m_sms.br_id,sms_id,sms_dat1,sms_dat,sms_cus,sms_txt,sms_typ,sms_mob,sms_min,sms_act,sms_st,sms_rmk,sms_sdat1,sms_sdat,sms_action,sms_cat,m_sms.men_id,men_nam 
FROM m_sms
left join m_men 
on m_sms.men_id=m_men.men_id

--alter table m_sms add sms_sdat1 as cast( CONVERT(VARCHAR(11), sms_sdat, 106) as datetime)