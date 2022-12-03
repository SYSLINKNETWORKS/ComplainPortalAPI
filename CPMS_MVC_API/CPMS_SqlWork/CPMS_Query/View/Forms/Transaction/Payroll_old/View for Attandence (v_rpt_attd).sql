USE ZSONS
GO

alter view v_attd
as
--Time In
select userid,emppro_macid,
min(checktime) as [Inn],max(checktime) as [Out],
checkdate,
right(convert(varchar, min(checktime), 100),7) as [intime],
right(convert(varchar, max(checktime), 100),7) as [outtime],
	cast(
			case 
			Datename(dw,checkdate) 
			when 'Monday' then 
				case when rosgp_ck_mon =1 then rosgp_in_mon else null end
			when 'Tuesday' then 
				case when rosgp_ck_tue =1 then rosgp_in_tue else null end
			when 'Wednesday' then 
				case when rosgp_ck_wed =1 then rosgp_in_wed else null end
			when 'Thursday' then 
				case when rosgp_ck_thu =1 then rosgp_in_thu else null end
			when 'Friday' then
				case when rosgp_ck_fri =1 then rosgp_in_fri else null end
			when 'Saturday' then 
				case when rosgp_ck_sat =1 then rosgp_in_sat else null end
			when 'Sunday' then 
				case when rosgp_ck_sun =1 then rosgp_in_sun else null end
			else null 
			end 
	as datetime) as [rosgp_in],
	cast(
			case 
			Datename(dw,checkdate) 
			when 'Monday' then 
				case when rosgp_ck_mon =1 then rosgp_out_mon else null end
			when 'Tuesday' then 
				case when rosgp_ck_tue =1 then rosgp_out_tue else null end
			when 'Wednesday' then 
				case when rosgp_ck_wed =1 then rosgp_out_wed else null end
			when 'Thursday' then 
				case when rosgp_ck_thu =1 then rosgp_out_thu else null end
			when 'Friday' then
				case when rosgp_ck_fri =1 then rosgp_out_fri else null end
			when 'Saturday' then 
				case when rosgp_ck_sat =1 then rosgp_out_sat else null end
			when 'Sunday' then 
				case when rosgp_ck_sun =1 then rosgp_out_sun else null end
			else null 
			end 
	as datetime) as [rosgp_out],
	datediff(minute,min(checktime),max(checktime)) as [check_min],
	Datename(dw,checkdate) as [Day],
	rosgp_lat,rosgp_ear,rosgp_ota,
	ros_nam
from checkinout 
inner join m_emppro
on m_emppro.emppro_macid=checkinout.userid
inner join m_rosemp
on m_emppro.emppro_id=m_rosemp.emppro_id
and rosemp_dat=(select max(rosemp_Dat) from m_rosemp mrosemp where mrosemp.emppro_id=m_rosemp.emppro_id and mrosemp.rosemp_dat<=checkdate)
inner join m_rosgp
on m_rosemp.ros_id=m_rosgp.ros_id
inner join m_ros 
on m_rosemp.ros_id=m_ros.ros_id
and rosgp_dat=(select max(mrosgp.rosgp_dat) from m_rosgp mrosgp where m_rosgp.ros_id=mrosgp.ros_id and mrosgp.rosgp_dat<=checkdate)
--where emppro_macid=1031 --and checkdate>'11/15/2013'
--and Datename(dw,checkdate) ='Monday'
group by userid,emppro_macid,
checkdate,userid,rosgp_ck_mon,rosgp_in_mon,rosgp_ck_tue,rosgp_in_tue,rosgp_ck_wed,rosgp_in_wed,rosgp_ck_thu,rosgp_in_thu,rosgp_ck_fri,rosgp_in_fri,rosgp_ck_sat,rosgp_in_sat,rosgp_ck_sun,rosgp_in_sun,
rosgp_out_mon,rosgp_out_tue,rosgp_out_wed,rosgp_out_thu,rosgp_out_fri,rosgp_out_sat,rosgp_out_sun,
rosgp_lat,rosgp_ear,rosgp_ota,ros_nam


	





