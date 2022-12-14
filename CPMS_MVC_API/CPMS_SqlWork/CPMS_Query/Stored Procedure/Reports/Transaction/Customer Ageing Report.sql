USE NATHI
GO
--exec sp_rpt_cus_age 0,'06/30/2015','01'

alter proc [dbo].[sp_rpt_cus_age](@cus_id int,@date datetime,@m_yr_id char(2))
as
begin
	if @cus_id=0 
		begin
			select 
				com_id,br_id,minv_id,v_rpt_cus_age.cus_id,minv_dat,v_rpt_cus_age.cur_id,v_rpt_cus_age.cur_snm,dateadd(dd,cus_creday,minv_dat) as [CredayDate],
				case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date)between 0 and 15 then dinv_amt else 0 end  as [F0-15 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 16 and 30 then dinv_amt else 0 end  as [F16-30 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 31 and 45 then dinv_amt else 0 end  as [F31-45 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 46 and 60 then dinv_amt else 0 end  as [F46-60 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date)>60 then dinv_amt else 0 end  as [FAbove 60 days],dinv_amt,
				case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 0 and 15 then dinv_tamt else 0 end  as [0-15 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 16 and 30 then dinv_tamt else 0 end  as [16-30 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 31 and 45 then dinv_tamt else 0 end  as [31-45 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 46 and 60 then dinv_tamt else 0 end  as [46-60 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date)>60 then dinv_tamt else 0 end  as [Above 60 days],dinv_tamt
					from v_rpt_cus_age
					inner join v_cus
					on v_rpt_cus_age.cus_id=v_cus.cus_id
			where minv_dat<=@date
		end
	else
		begin
			select 
				com_id,br_id,minv_id,v_rpt_cus_age.cus_id,cus_nam,cuscat_id,cuscat_nam,minv_dat,v_rpt_cus_age.cur_id,v_rpt_cus_age.cur_snm,dateadd(dd,cus_creday,minv_dat) as [CredayDate],
					case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date)between 0 and 15 then dinv_amt else 0 end  as [F0-15 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 16 and 30 then dinv_amt else 0 end  as [F16-30 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 31 and 45 then dinv_amt else 0 end  as [F31-45 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 46 and 60 then dinv_amt else 0 end  as [F46-60 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date)>60 then dinv_amt else 0 end  as [FAbove 60 days],dinv_amt,
					case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date)between 0 and 15 then dinv_tamt else 0 end  as [0-15 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 16 and 30 then dinv_tamt else 0 end  as [16-30 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 31 and 45 then dinv_tamt else 0 end  as [31-45 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date) between 46 and 60 then dinv_tamt else 0 end  as [46-60 days],case  when datediff(dd,dateadd(dd,cus_creday,minv_dat),@date)>60 then dinv_tamt else 0 end  as [Above 60 days],dinv_tamt
					from v_rpt_cus_age
					inner join v_cus
					on v_rpt_cus_age.cus_id=v_cus.cus_id
			where minv_dat<=@date and v_rpt_cus_age.cus_id=@cus_id
		end
	end
--
--select * from t_minv where minv_id=116
--select * from v_rpt_cus_age where cus_id=35
--select * from t_dpay where minv_id=116

--alter view v_rpt_cus_age
--as
--select t_minv.minv_id,minv_dat,t_minv.cur_id,cur_snm,cus_id,minv_namt-(isnull(dpay_famt,0)+isnull(cusadv_famt,0)+isnull(ddn_famt,0)) as  [dinv_amt] ,minv_ntamt-(isnull(dpay_amt,0)+isnull(cusadv_amt,0)+isnull(ddn_amt,0)) as [dinv_tamt] from t_minv inner join t_dinv on t_minv.minv_id=t_dinv.minv_id
----Payment
--left join v_rpt_pay_minv
--on t_minv.minv_id=v_rpt_pay_minv.minv_id
----Advance Payment
--left join v_rpt_cusadv_minv
--on t_minv.minv_id=v_rpt_cusadv_minv.minv_id
----Debit Note
--left join v_rpt_dn_minv
--on t_minv.minv_id=v_rpt_dn_minv.minv_id
----Currency
--left join m_cur
--on t_minv.cur_id=m_cur.cur_id
--group by t_minv.minv_id,minv_dat,t_minv.cur_id,cur_snm,cus_id,dpay_famt,dpay_amt,cusadv_famt,cusadv_amt,ddn_amt,ddn_famt,minv_namt,minv_ntamt
--having (sum(minv_namt)-(isnull(dpay_famt,0)+isnull(cusadv_famt,0)+isnull(ddn_famt,0)))<>0
