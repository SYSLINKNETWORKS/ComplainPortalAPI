use zsons
go

alter view v_rpt_sal_inc
as
select  
m_sal.emppro_id,emppro_macid,m_emppro.memp_sub_id,memp_sub_nam,m_emppro.dpt_id,dpt_nam,emppro_nam ,
isnull((select max(msal_amt) from m_sal msal where msal.emppro_id=m_sal.emppro_id and msal.msal_dat<m_sal.msal_dat),emppro_sal) as [msal_pamt],msal_per,case msal_val when 1 then 0 else msal_val end as [msal_val],msal_amt,msal_dat 
from m_sal
inner join m_emppro on m_sal.emppro_id=m_emppro.emppro_id
inner join m_dpt on m_emppro.dpt_id=m_dpt.dpt_id  
left join m_emp_sub on m_emppro.memp_sub_id=m_emp_sub.memp_sub_id 
where msal_typ='U' and msal_val>1
--group by m_sal.emppro_id,emppro_macid,m_emppro.memp_sub_id,memp_sub_nam,m_emppro.dpt_id,dpt_nam,emppro_nam,emppro_sal,msal_dat,msal_per,msal_val 

