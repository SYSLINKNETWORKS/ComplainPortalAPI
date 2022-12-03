USE ZSons
GO

--exec sp_daily_att '10/07/2013'

alter proc sp_daily_att(@dt datetime)
as
--Actual Attendance
select userid,[inn],[out],ddate,min(intime) as [intime],max(outtime) as [outtime],cast(0 as bit) as [absent],0 as [hrmk],'Present' as [RMK] from v_rpt_attendance_man inner join m_emppro on v_rpt_attendance_man.userid=m_emppro.emppro_userid where emppro_st=1 and ddate=@dt and check_typ='S' and check_night=0 group by userid,[inn],[out],ddate
--Manual Attendance
union all
select userid,[inn],[out],ddate,min(intime) as [intime],max(outtime) as [outtime],cast(0 as bit) as [absent],1 as [hrmk],'ManualAttendance' as [RMK] from v_rpt_attendance_man inner join m_emppro on v_rpt_attendance_man.userid=m_emppro.emppro_userid where emppro_st=1 and ddate=@dt and check_typ='U' and check_night=0 group by userid,[inn],[out],ddate
--Night
union all
select userid,nightinn as [inn],nightout as [out],nithrs_dat,min(nightintime) as [intime],max(nightouttime) as [outtime],cast(0 as bit) as [absent],2 as [hrmk],'Night Shift' as [RMK] from v_nithrs inner join m_emppro on v_nithrs.userid=m_emppro.emppro_userid where emppro_st=1 and nithrs_dat=@dt group by userid,nightinn,nightout,nithrs_dat
--Absent
union all
select emppro_userid,'','',@dt,'','',cast(1 as bit) as [absent],3 as [hrmk],'Absent' as [RMK] from m_emppro where emppro_st=1 and emppro_reg=0 and emppro_userid not in (select userid from v_rpt_attendance_man where ddate=@dt and check_night<>1) and emppro_attexp=0

--select * from v_rpt_attendance_man
--where userid=11 and ddate='10/06/2013'

