USE meiji_rusk
GO

alter view v_cus
as
select 
com_id,br_id,m_cus.cur_id,cur_snm,cur_nam,m_cus.cuscat_id as [cuscat_id],'['+rtrim(cast(m_cus.cuscat_id as char(100)))+']-'+rtrim(cuscat_nam) as [cuscat_nam],
cus_id,cus_id as [ID], 
--'['+rtrim(cast(cus_id as varchar(100))) + ']-'+rtrim(cus_nam)+'-'+RTRIM(brk_nam)+'-'+RTRIM(terr_nam)+'-'+rtrim(reg_nam)+'-'+RTRIM(zone_nam)+'-'+RTRIM(coun_nam) 
'['+rtrim(cast(cus_id as varchar(100))) + ']-'+rtrim(cus_nam) as [cus_nam], 
rtrim(cus_nam) as [cus_nam_rpt],
m_cus.brk_id,brk_nam,m_brk.terr_id,terr_nam,m_terr.reg_id,reg_nam,m_reg.zone_id,zone_nam,m_zone.coun_id,coun_nam,
cus_nam as [cus_nam1],cus_cp,cus_add,cus_adddc,cus_ckadddc,cus_pho,cus_mob,cus_fax,cus_eml,cus_web,cus_ntn,cus_stn,cus_cnic,cus_creday,cus_amtltd,cus_act,cus_typ,cus_app 
from m_cus 
left join m_cur on m_cus.cur_id=m_cur.cur_id 
left join m_cuscat on m_cus.cuscat_id=m_cuscat.cuscat_id 
left join m_brk on m_cus.brk_id =m_brk.brk_id 
left join m_terr on m_brk.terr_id=m_terr.terr_id 
left join m_reg on m_terr.reg_id=m_reg.reg_id 
left join m_zone on m_reg.zone_id=m_zone.zone_id 
left join m_coun on m_zone.coun_id=m_coun.coun_id
                                    