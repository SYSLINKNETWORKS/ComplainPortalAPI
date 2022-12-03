USE ZSons
go
alter view v_rpt_pc
as
select 
t_mpc.com_id,t_mpc.br_id,t_mpc.yR_id,mvch_tax,t_mpc.mpc_no,mpc_dat,mpc_dc,case mpc_dc when 1 then 'Yes' else 'No' end  as [dayclose],mpc_rmk,dpc_id ,dpc_nar,dpc_amt,dpc_set,case dpc_set when 1 then 'Yes' when 0 then 'No' end as [settle],t_dpc.acc_no,acc_id,acC_nam,usr_nam,mvch_id,CASE dpc_set when 1 then dpc_amt else 0 end as [dpc_setamt],case dpc_set when 0 then dpc_amt else 0 end as [dpc_unsetamt] 
from 
t_mpc 
--Inner JOin with Detail Petty Cash
inner join t_dpc on t_mpc.mpc_no=t_dpc.mpc_no
--Inner join with COF
inner join gl_m_acc 
on t_dpc.com_id=gl_m_acc.com_id 
and t_dpc.acc_no=gl_m_acc.acc_no
--Left join t_mvch
left join t_mvch
on t_mpc.com_id=t_mvch.com_id 
and t_mpc.br_id=t_mvch.br_id
and t_mpc.mvch_no=t_mvch.mvch_no
--Left Join the User
left join new_usr 
on t_mpc.ins_usr_id =new_usr.usr_id 


                          
