USE MEIJI_RUSK
GO


Create view v_emppro_rosgp
as
--Time In
select emppro_id,tbldat_dat,m_rosgp.ros_id,ros_nam,rosgp_ota,rosgp_lat,rosgp_ear,rosgp_earot,
case datename(dw, tbldat_dat) 
	when 'Sunday' then rosgp_in_sun 
	when 'Monday' then rosgp_in_mon
	when 'Tuesday' then rosgp_in_tue 
	when 'Wednesday' then rosgp_in_wed 
	when 'Thursday' then rosgp_in_thu
	when 'Friday' then rosgp_in_fri 
	when 'Saturday' then rosgp_in_sat 
	end as [rosgp_in], 
case datename(dw, tbldat_dat) 
	when 'Sunday' then rosgp_out_sun 
	when 'Monday' then rosgp_out_mon
	when 'Tuesday' then rosgp_out_tue 
	when 'Wednesday' then rosgp_out_wed 
	when 'Thursday' then rosgp_out_thu
	when 'Friday' then rosgp_out_fri 
	when 'Saturday' then rosgp_out_sat 
		end as [rosgp_out] 
from  m_emppro
inner join m_rosgp 
on m_emppro.ros_id =m_rosgp.ros_id
inner join tbl_dat 
on rosgp_dat =(select MAX(rosgp_dat) from m_rosgp mrosgp where m_rosgp.ros_id=mrosgp.ros_id and mrosgp.rosgp_dat<=tbldat_dat)
inner join m_ros on m_rosgp.ros_id =m_ros.ros_id




--select * from m_rosgp where rosgp_dat =(select max(rosgp_dat) from m_rosgp mrosgp where mrosgp.rosgp_dat<='07/01/2014')

