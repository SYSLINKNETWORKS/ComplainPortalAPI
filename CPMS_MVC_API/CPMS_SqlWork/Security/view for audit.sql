USE ZSons
go

alter view v_rpt_aud
as
select 
tbl_aud1.com_id,tbl_aud1.br_id,br_nam,aud_dat,DATEADD(dd, 0, DATEDIFF(dd, 0, aud_dat)) as [aud_dat_search],
m_men.module_id,module_nam,m_mensubcat.mencat_id,mencat_nam,m_men.mensubcat_id,mensubcat_nam,men_nam,men_ali,aud_des,
tbl_aud1.usr_id,usr_nam,aud_act,aud_ip,SUBSTRING(aud_ip,CHARINDEX('IP', aud_ip)+3,LEN(aud_ip)) as [IP],SUBSTRING(aud_ip,1,CHARINDEX(' IP', aud_ip)) AS [PC_NAME] 
from tbl_aud1
inner join m_br 
on tbl_aud1.br_id=m_br.br_id
inner join new_usr
on tbl_aud1.usr_id=new_usr.usr_id
left join m_men 
on m_men.men_nam=tbl_aud1.aud_frmnam
left join m_module
on m_men.module_id=m_module.module_id
left join m_mensubcat
on m_men.mensubcat_id=m_mensubcat.mensubcat_id
left join m_mencat
on m_mensubcat.mencat_id=m_mencat.mencat_id

