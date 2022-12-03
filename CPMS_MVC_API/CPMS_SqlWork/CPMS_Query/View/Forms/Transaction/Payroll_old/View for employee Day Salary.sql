use MFI
GO

create view v_emp_daysal
as
select emppro_id,emp_sal_dat,(emppro_actemp_sal/emp_sal_days)/(select rosgp_wh from m_emppro inner join m_rosgp on m_emppro.ros_id=m_rosgp.rosgp_id where m_emppro.emppro_id=emp_sal.emppro_id) as daysal from emp_sal
