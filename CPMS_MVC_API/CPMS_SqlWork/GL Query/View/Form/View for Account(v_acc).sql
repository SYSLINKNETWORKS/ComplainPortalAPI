USE phm
go

ALTER view v_acc 
as
select gl_m_acc.com_id,gl_m_acc.br_id,gl_m_acc.acc_no,gl_m_acc.acc_id,rtrim(gl_m_acc.acc_id) as [ID],'['+rtrim(cast(gl_m_acc.acc_id as varchar(100))) + ']-'+rtrim(gl_m_acc.acc_nam) as [acc_nam],rtrim(gl_m_acc.acc_nam) as [acc_nam_rpt],'['+rtrim(cast(gl_m_acc.acc_id as varchar(100))) + ']-'+rtrim(gl_m_acc.acc_des) as [acc_des],
gl_m_acc.acc_typ,
gl_m_acc.acc_act,
case gl_m_acc.acc_act when 1 then 'Active' else 'In-Active' end as [acc_active],
gl_m_acc.acc_del,
gl_m_acc.acc_lvl,gl_m_Acc.acc_dm,case gl_m_acc.acc_dm when 'M' then 'Master' when 'D' then 'Detail' end as [acc_masterdetail],
gl_m_acc.cur_id,m_cur.cur_snm,m_cur.cur_nam,
gl_m_acc.acc_oid as [acc_oldid],
gl_m_acc.acc_cno,
gl_m_acc.acc_cid,
'['+rtrim(cast(gl_m_acc_con.acc_id as char(100)))+']-'+gl_m_acc_con.acc_nam as [acc_cnam] 
from gl_m_acc 
left join m_cur on gl_m_acc.cur_id=m_cur.cur_id 
left join gl_m_acc gl_m_acc_con on gl_m_acc.com_id=gl_m_acc_con.com_id and gl_m_acc.acc_cno=gl_m_acc_con.acc_no

