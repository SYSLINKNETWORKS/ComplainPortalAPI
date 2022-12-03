USE MFI
GO

create view v_emp_ot
as


select emppro_id,ddate,(case when max(out)>cast(convert(varchar, max(out), 101) +' '+right(convert(varchar, m_rosgp.rosgp_out, 100),7) as datetime) then cast(DATEDIFF(mi,cast(convert(varchar, max(out), 101) +' '+right(convert(varchar, m_rosgp.rosgp_out, 100),7) as datetime),max(out)) as float) else 0 end)/60 as [overtime],userid from v_att inner join m_emppro on v_att.userid=m_emppro.emppro_userid inner join m_rosgp on m_emppro.ros_id=m_rosgp.rosgp_id where emppro_ot=1 group by rosgp_out,userid,ddate,emppro_id
