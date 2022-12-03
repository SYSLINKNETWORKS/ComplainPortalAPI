alter view v_taxrat
as
select 
taxrat_id,taxrat_dat,taxrat_nam,case taxrat_nam when 'G' then 'G.S.T' when 'I' then 'Income Tax' when 'W' then 'W.H.T' when 'F' then 'F.E.D' end as [Tax]
from m_taxrat 
