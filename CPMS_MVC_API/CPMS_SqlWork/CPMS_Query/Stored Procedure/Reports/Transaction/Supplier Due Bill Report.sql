USE ZSONS
GO
--exec sp_rpt_sup_due 0,'06/30/2014','01'
--select datediff(dd,'08/3/2011','09/15/2011')

create proc [dbo].[sp_rpt_sup_due](@sup_id int,@date datetime,@m_yr_id char(2))
as
begin
	if @sup_id=0 
		begin
			select 
				mpb_id,v_rpt_sup_age.sup_id,sup_nam,supcat_id,mpb_dat,v_rpt_sup_age.cur_id,cur_snm,sup_creday,dateadd(dd,sup_creday,mpb_dat) as [CredayDate],
				case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date)between 0 and 15 then dpb_amt else 0 end  as [F0-15 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 16 and 30 then dpb_amt else 0 end  as [F16-30 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 31 and 45 then dpb_amt else 0 end  as [F31-45 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 46 and 60 then dpb_amt else 0 end  as [F46-60 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date)>60 then dpb_amt else 0 end  as [FAbove 60 days],dpb_amt,
				case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 0 and 15 then dpb_tamt else 0 end  as [0-15 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 16 and 30 then dpb_tamt else 0 end  as [16-30 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 31 and 45 then dpb_tamt else 0 end  as [31-45 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 46 and 60 then dpb_tamt else 0 end  as [46-60 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date)>60 then dpb_tamt else 0 end  as [Above 60 days],dpb_tamt
					from v_rpt_sup_age
					inner join m_sup
					on v_rpt_sup_age.sup_id=m_sup.sup_id
			where dateadd(dd,sup_creday,mpb_dat)<=@date
		end
	else
		begin
			select 
				mpb_id,v_rpt_sup_age.sup_id,sup_nam,supcat_id,mpb_dat,v_rpt_sup_age.cur_id,cur_snm,sup_creday,dateadd(dd,sup_creday,mpb_dat) as [CredayDate],
					case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date)between 0 and 15 then dpb_amt else 0 end  as [F0-15 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 16 and 30 then dpb_amt else 0 end  as [F16-30 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 31 and 45 then dpb_amt else 0 end  as [F31-45 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 46 and 60 then dpb_amt else 0 end  as [F46-60 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date)>60 then dpb_amt else 0 end  as [FAbove 60 days],dpb_amt,
					case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date)between 0 and 15 then dpb_tamt else 0 end  as [0-15 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 16 and 30 then dpb_tamt else 0 end  as [16-30 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 31 and 45 then dpb_tamt else 0 end  as [31-45 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date) between 46 and 60 then dpb_tamt else 0 end  as [46-60 days],case  when datediff(dd,dateadd(dd,sup_creday,mpb_dat),@date)>60 then dpb_tamt else 0 end  as [Above 60 days],dpb_tamt
					from v_rpt_sup_age
					inner join m_sup
					on v_rpt_sup_age.sup_id=m_sup.sup_id
			where dateadd(dd,sup_creday,mpb_dat)<=@date and v_rpt_sup_age.sup_id=@sup_id
		end
	end
--
--select * from t_mpb where mpb_id=116
--select * from v_rpt_sup_age where sup_id=35
--select * from t_dpay where mpb_id=116

--alter view v_rpt_sup_age
--as
--select t_mpb.mpb_id,mpb_dat,t_mpb.cur_id,cur_snm,sup_id,mpb_namt-(isnull(dpay_famt,0)+isnull(supadv_famt,0)+isnull(ddn_famt,0)) as  [dpb_amt] ,mpb_ntamt-(isnull(dpay_amt,0)+isnull(supadv_amt,0)+isnull(ddn_amt,0)) as [dpb_tamt] from t_mpb inner join t_dpb on t_mpb.mpb_id=t_dpb.mpb_id
----Payment
--left join v_rpt_pay_mpb
--on t_mpb.mpb_id=v_rpt_pay_mpb.mpb_id
----Advance Payment
--left join v_rpt_supadv_mpb
--on t_mpb.mpb_id=v_rpt_supadv_mpb.mpb_id
----Debit Note
--left join v_rpt_dn_mpb
--on t_mpb.mpb_id=v_rpt_dn_mpb.mpb_id
----Currency
--left join m_cur
--on t_mpb.cur_id=m_cur.cur_id
--group by t_mpb.mpb_id,mpb_dat,t_mpb.cur_id,cur_snm,sup_id,dpay_famt,dpay_amt,supadv_famt,supadv_amt,ddn_amt,ddn_famt,mpb_namt,mpb_ntamt
--having (sum(mpb_namt)-(isnull(dpay_famt,0)+isnull(supadv_famt,0)+isnull(ddn_famt,0)))<>0
