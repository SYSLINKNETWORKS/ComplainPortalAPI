USE ZSons
GO

alter proc sp_rpt_att(@dt1 datetime)
as
begin

--declare
--@dt1 datetime
--set @dt1='09/01/2012'


select userid,emppro_macid,emppro_nam,right(convert(varchar, min(rosgp_in), 100),7) as [In Time],right(convert(varchar, min(rosgp_out), 100),7) as [Out Time],
case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/01/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/01/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in1], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/01/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out1], 
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/02/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/02/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in2], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/02/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out2], 
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/03/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(	
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/03/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in3], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/03/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out3], 
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/04/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(		
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/04/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in4], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/04/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out4], 
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/05/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(		
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/05/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in5], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/05/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out5], 
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/06/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(		
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/06/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in6], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/06/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out6], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/07/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(		
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/07/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in7], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/07/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out7], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/08/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/08/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in8], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/08/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out8], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/09/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/09/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in9], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/09/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out9],	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/10/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/10/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in10], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/10/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out10], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/11/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/11/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in11], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/11/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out11], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/12/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/12/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in12], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/12/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out12],	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/13/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/13/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in13], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/13/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out13], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/14/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/14/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in14], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/14/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out14], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/15/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/15/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in15], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/15/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out15], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/16/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/16/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in16], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/16/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out16], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/17/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/17/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in17], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/17/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out17], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/18/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/18/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in18], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/18/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out18], 	
				
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/19/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/19/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in19], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/19/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out19], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/20/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/20/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in20], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/20/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out20], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/21/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/21/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in21], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/21/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out21], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/22/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/22/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in22], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/22/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out22], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/23/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/23/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in23], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/23/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out23], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/24/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/24/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in24], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/24/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out24], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/25/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/25/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in25], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/25/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out25], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/26/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/26/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in26], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/26/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out26], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/27/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/27/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in27], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/27/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out27], 	
	
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/28/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/28/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end as [in28], 
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/28/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end as [out28], 	
	
	case when datepart(mm,@dt1)<>2 then
	(
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/29/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/29/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end
	)end as [in29], 
	
	case when datepart(mm,@dt1)<>2 then
	(
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/29/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end
	)end as [out29], 	
	
	case when datepart(mm,@dt1)<>2 then
	(
	case datename(weekday,cast(cast(datepart(mm,@dt1) as char(2))+'/30/'+cast(datepart(yyyy,@dt1) as char(4))as datetime)) when 'Sunday' then	'Sun' else(			
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/30/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)end 
	)end as [in30],
	
	case when datepart(mm,@dt1)<>2 then
	(
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/30/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end
	)end as [out30], 	
	
	case datepart(mm,@dt1) when 1 then
	(
	case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)
	when 3 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)
	when 5 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)
	when 7 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)
	when 8 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)
	when 10 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)
	when 12 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then intime end)
	end as [in31],
	
	case datepart(mm,@dt1) when 1 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end)
	when 3 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end)
	when 5 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end)
	when 7 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end)
	when 8 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end)
	when 10 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end)
	when 12 then
	(case DDate when cast(datepart(mm,@dt1) as char(2))+'/31/'+cast(datepart(yyyy,@dt1) as char(4)) then outtime end)
	end as [out31]
	
	
	
	
	from v_att inner join m_emppro on v_att.userid=m_emppro.emppro_userid left join m_rosgp on m_rosgp.rosgp_id=m_emppro.ros_id
	where emppro_st=1 and emppro_attexp =0
	group by userid,emppro_macid,emppro_nam,ddate,intime,outtime


	--select rosgp_id as [ID],rosgp_nam as [Name],right(convert(varchar, min(rosgp_in), 100),7) as [In Time],right(convert(varchar, min(rosgp_out), 100),7) as [Out Time] from m_rosgp where rosgp_typ<>'S' group by rosgp_id,rosgp_nam

end
	
	--group by v_att.userid,m_emppro.emppro_nam,v_att.ddate