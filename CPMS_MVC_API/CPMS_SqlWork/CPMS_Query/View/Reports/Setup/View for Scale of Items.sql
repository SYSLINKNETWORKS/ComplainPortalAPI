USE MFI
GO

create view v_sca
AS
select titm_id,
case itm_cat when 'F' then inn.sca_nam when 'P' then man.sca_nam when 'G' then m_sca.sca_nam when 'O' then m_sca.sca_nam when 'E' then man.sca_nam end as [sca_nam]
from t_itm
inner join m_itm
on t_itm.itm_id=m_itm.itm_id
left join m_sca
on t_itm.sca_id=m_sca.sca_id
left join m_sca inn
on t_itm.inner_sca_id=inn.sca_id
left join m_sca man
on t_itm.man_sca_id=man.sca_id
