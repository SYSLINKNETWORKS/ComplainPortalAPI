USE CPMS
GO

--alter table t_mcomp add mcomp_isstyp char(1)
alter view v_rpt_comp_pg
as
select t_mcomp.com_id as [Company_ID],com_nam as [Company_Name],t_mcomp.br_id as [Branch_ID],br_nam as [Branch_Name],
t_mcomp.mcomp_id as [Ticket],mcomp_dat as [Date],
mcomp_comp_by as [Complain_By],mcomp_comp as [Complain],
case mcomp_pr when 'L' then 'Low' when 'M' then 'Medium' when 'H' then 'High' end as [priority],
case mcomp_isstyp when 'B' then 'Bug/Fixes' when 'N' then 'New Requirement' when 'C' then 'Changes' end as [IssueType],
mcomp_rmk as [Remarks],
case	when (mcomp_can=1) then 'Cancel' 
		when (mcomp_can=0 and mcomp_ck=0) then 'Check' 
		when (mcomp_can=0 and mcomp_ck=1 and mcomp_app=0) then 'QC' 
		when (mcomp_can=0 and mcomp_ck=1 and mcomp_app=1 and mcomp_act=0) then 'Acknowledge' 		
		when (mcomp_can=0 and mcomp_ck=1 and mcomp_app=1 and mcomp_act=1) then 'Complete' 		
		end as [Status],
case	when (mcomp_can=0 and mcomp_ck=0) then datediff(day,mcomp_dat,getdate()) 
		when (mcomp_can=0 and mcomp_ck=1 and mcomp_app=0) then datediff(day,mcomp_dat_ck,getdate())
		when (mcomp_can=0 and mcomp_ck=1 and mcomp_app=1 and mcomp_act=0) then datediff(day,mcomp_dat_app,getdate()) 		
		end as [Status_Aging],

case when (mcomp_ck=1) then 'Yes' else 'No' end as [Checked],
isnull(mcomp_ck_rmk,'') as [Checked_Remarks],
case when mcomp_ck=1 then usr_ck.usr_nam else '' end as [Check_by],
mcomp_dat_ck as [Check_Date],
case when mcomp_ck=1 then datediff(day,mcomp_dat,mcomp_dat_ck) else datediff(day,mcomp_dat,getdate()) end as [Check_aging],

case when (mcomp_app=1) then 'Yes' else 'No' end as [QC],
isnull(mcomp_app_rmk,'') as [QC_Remarks],
case when mcomp_app=1 then usr_app.usr_nam else '' end as [QC_by],
mcomp_dat_app as [QC_Date],
case when mcomp_app=1 then datediff(day,mcomp_dat_ck,mcomp_dat_app) else datediff(day,mcomp_dat_ck,getdate()) end as [QC_aging],

case when (mcomp_act=1) then 'Yes' else 'No' end as [Acknowledge],
isnull(mcomp_act_rmk,'') as [Acknowledge_Remarks],
mcomp_dat_act as [Acknowledge_Date],
case when mcomp_act=1 then datediff(day,mcomp_dat_app,mcomp_dat_act) else datediff(day,mcomp_dat_app,getdate()) end as [Acknowledge_aging],

case when (mcomp_can=1) then 'Yes' else 'No' end as [Cancelled],
isnull(mcomp_can_rmk,'') as [Cancelled_Remarks],
mcomp_dat_can as [Cancelled_Date],

mcomp_att as [Attachment_Count],
t_mcomp.ins_dat as [Insert_Date]
from t_mcomp 
inner join m_com 
on t_mcomp.com_id=m_com.com_id 
inner join m_br 
on t_mcomp.br_id=m_br.br_id
left join new_usr usr_ck
on t_mcomp.usr_id_ck=usr_ck.usr_id
left join new_usr usr_app
on t_mcomp.usr_id_app=usr_app.usr_id




