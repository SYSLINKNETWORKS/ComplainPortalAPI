USE meiji_rusk
GO


alter view v_att
as
--Time In
select userid,
min(checktime) as [Inn],max(checktime) as [Out],
checkdate as [DDate],datename(dw, checkdate) as [WEEDKDAY],m_rosgp.ros_id,ros_nam,rosgp_ota,rosgp_lat,rosgp_ear,rosgp_earot,
right(convert(varchar, min(checktime), 100),7) as [intime],
right(convert(varchar, max(checktime), 100),7) as [outtime],
case datename(dw, checkdate) 
	when 'Sunday' then rosgp_in_sun 
	when 'Monday' then rosgp_in_mon
	when 'Tuesday' then rosgp_in_tue 
	when 'Wednesday' then rosgp_in_wed 
	when 'Thursday' then rosgp_in_thu
	when 'Friday' then rosgp_in_fri 
	when 'Saturday' then rosgp_in_sat 
	end as [rosgp_in], 
case datename(dw, checkdate) 
	when 'Sunday' then rosgp_out_sun 
	when 'Monday' then rosgp_out_mon
	when 'Tuesday' then rosgp_out_tue 
	when 'Wednesday' then rosgp_out_wed 
	when 'Thursday' then rosgp_out_thu
	when 'Friday' then rosgp_out_fri 
	when 'Saturday' then rosgp_out_sat 
		end as [rosgp_out] 
from checkinout 
inner join m_emppro
on checkinout.USERID =m_emppro.emppro_macid
inner join m_rosgp 
on m_emppro.ros_id =m_rosgp.ros_id
and rosgp_dat =(select MAX(rosgp_dat) from m_rosgp mrosgp where m_rosgp.ros_id=mrosgp.ros_id and mrosgp.rosgp_dat<=checkdate)
inner join m_ros on m_rosgp.ros_id =m_ros.ros_id
where check_app=1 and check_night=0
--and checkdate between '07/01/2014' and '07/10/2014' and USERID=6
group by checkdate,userid,m_rosgp.ros_id,ros_nam,rosgp_ota,rosgp_lat,rosgp_ear,rosgp_earot,
rosgp_in_sun,rosgp_out_sun,
rosgp_in_mon,rosgp_out_mon,
rosgp_in_tue,rosgp_out_tue,
rosgp_in_wed,rosgp_out_wed,
rosgp_in_thu,rosgp_out_thu,
rosgp_in_fri,rosgp_out_fri,
rosgp_in_sat,rosgp_out_sat



--select * from m_rosgp where rosgp_dat =(select max(rosgp_dat) from m_rosgp mrosgp where mrosgp.rosgp_dat<='07/01/2014')

