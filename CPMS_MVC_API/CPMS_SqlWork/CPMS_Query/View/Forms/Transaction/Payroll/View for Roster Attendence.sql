USE MFI
GO

CREATE view v_ros_att
as
select rosgp_id as [ID],rosgp_nam as [Name],right(convert(varchar, min(rosgp_in), 100),7) as [InTime],right(convert(varchar, min(rosgp_out), 100),7) as [OutTime] from m_rosgp where rosgp_typ<>'S' group by rosgp_id,rosgp_nam

