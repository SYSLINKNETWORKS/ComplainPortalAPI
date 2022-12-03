use zsons
go

alter view v_rpt_cuspro
as
select  
cus_id,cus_nam,cus_cp,cus_add,cus_pho,cus_mob,cus_fax,cus_eml,cus_web,cus_ntn,cus_stn,cus_act,cus_creday,cus_amtltd,cus_typ,cus_st,cus_app,cus_cnic,com_id,br_id,
m_cus.cuscat_id,cuscat_nam,
m_cus.cussubcat_id,cussubcat_nam,
m_cus.cur_id,cur_nam,cur_snm,
m_cus.zone_id,zone_nam,
cus_sms,cus_smsest,cus_smsso,cus_smsadv,cus_smsdc,cus_smsinv,cus_smsrec,cus_smscre,cus_ckweb

from m_cus
left join m_cuscat on m_cus.cuscat_id=m_cuscat.cuscat_id
left join m_cussubcat on m_cus.cussubcat_id=m_cussubcat.cussubcat_id
left join m_cur on m_cus.cur_id=m_cur.cur_id
left join m_zone on m_cus.zone_id=m_zone.zone_id

where m_cus.zone_id=2
--cus_sms=1 and
--m_cus.cussubcat_id=1



