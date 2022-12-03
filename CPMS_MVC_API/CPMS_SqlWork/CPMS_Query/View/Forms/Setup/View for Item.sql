USE MEIJI_RUSK
go

--select * from m_bd


alter view v_titm
as
select t_itm.com_id,t_itm.br_id,t_itm.titm_id,t_itm.titm_bar as [titm_barid],
case when titm_ckbar=1 then
	case when len(t_itm.titm_bar)=1 then '00000000000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=2 then '0000000000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=3 then '000000000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=4 then '00000000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=5 then '0000000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=6 then '000000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=7 then '00000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=8 then '0000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=9 then '000'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=10 then '00'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	when len(t_itm.titm_bar)=11 then '0'+rtrim(cast(t_itm.titm_bar as varchar(12))) 
	
end
else t_itm.titm_bar end [titm_bar],
'['+rtrim(cast(titm_id as varchar(100))) + ']-'+rtrim(titm_nam) as [titm_nam],
rtrim(titm_nam) as [titm_nam_rpt],
upper(rtrim(titm_reg)+' '+rtrim(titm_nam))  as [titm_nam1],
inner_titm_qty,m_sca.sca_snm as [sca_nam],t_itm.itmsub_id,rtrim(itmsubmas_nam)+'-'+rtrim(itmsub_nam) as [itmsub_nam],m_itmsub.itmsubmas_id,itmsubmas_nam,t_itm.itmgp_id,itmgp_nam,
master_titm_qty,inn.sca_snm as [inner_sca_nam],mas.sca_snm as [master_sca_nam],str_nam as [Strength],titm_reg,titm_dat,titm_exp,titm_renewdat,
titm_prat,titm_cl,titm_cw,titm_ch,titm_space,t_itm.bd_id,bd_nam,t_itm.ger_id,rtrim(bd_nam)+ ' '+rtrim(ger_nam) as [ger_nam],t_itm.man_id,man_nam,dosage.sca_snm as [Dosage],
t_itm.itm_id,itm_nam,titm_rlvl,titm_mlvl,itm_cat,
inn.sca_ckcon,case inn.sca_met when 0 then 1 else inn.sca_met end as [sca_met],
--case itm_cat when 'F' then inn.sca_id else m_sca.sca_id end as [Scale_ID],
--case itm_cat when 'F' then inn.sca_snm else m_sca.sca_snm end as [Scale],
m_sca.sca_id as [Scale_ID],
m_sca.sca_snm as [Scale],
man_sca_id,man.sca_nam as [Scale_Man],man_qty,
titm_act,t_itm.log_act,titm_inn_wei
from t_itm 
left join m_itm
on t_itm.itm_id=m_itm.itm_id
left join m_itmsub
on t_itm.itmsub_id=m_itmsub.itmsub_id
left join m_itmsubmas
on m_itmsub.itmsubmas_id=m_itmsubmas.itmsubmas_id
left join m_itmgp
on t_itm.itmgp_id=m_itmgp.itmgp_id
left join m_ger 
on t_itm.ger_id=m_ger.ger_id
left join m_bd 
on t_itm.bd_id=m_bd.bd_id
left join m_man 
on t_itm.man_id=m_man.man_id
left join m_sca
on t_itm.sca_id=m_sca.sca_id
left join m_sca inn
on t_itm.inner_sca_id=inn.sca_id
left join m_sca mas
on t_itm.master_sca_id=mas.sca_id
left join m_sca man
on t_itm.man_sca_id=man.sca_id
left join m_str 
on t_itm.str_id=m_str.str_id
left join m_sca dosage
on t_itm.sca_id_dos=dosage.sca_id
left join m_sca pack
on t_itm.sca_id_pack =pack.sca_id



