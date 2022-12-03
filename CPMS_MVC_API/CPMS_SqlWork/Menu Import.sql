delete from m_gpper 
delete from m_per
delete from m_men
delete from m_module
delete from m_mensubcat
delete from m_mencat 


insert  m_module(module_id,module_nam,module_typ,module_act)
select module_id,module_nam,module_typ,module_act from phm.dbo.m_module

insert m_mencat
select mencat_id,mencat_nam,mencat_typ,mencat_act from phm.dbo.m_mencat

insert m_mensubcat
select mensubcat_id,mensubcat_nam,mensubcat_typ,mensubcat_act,mencat_id from phm.dbo.m_mensubcat

insert m_men (men_id,men_nam,men_category,men_typ,men_ali,men_arc,mensubcat_id,module_id,men_qry,men_act,men_whr,men_odb,men_sms,men_ckweb,men_url,men_cid,men_view,men_sot,men_lvl)
select men_id,men_nam,men_category,men_typ,men_ali,men_arc,mensubcat_id,module_id,men_qry,men_act,men_whr,men_odb,men_sms,men_ckweb,men_url,men_cid,men_view,men_sot,men_lvl from phm.dbo.m_men

insert m_gpper
select gpper_id,gpper_view,gpper_new,gpper_upd,gpper_del,gpper_print,usrgp_id,men_id,gpper_tax,gpper_app from phm.dbo.m_gpper where usrgp_id=1

insert m_per
select per_id,per_view,per_new,per_upd,per_del,per_print,usr_id,men_id,per_dt1,per_dt2,per_tax,per_app from phm.dbo.m_per where usr_id=1
