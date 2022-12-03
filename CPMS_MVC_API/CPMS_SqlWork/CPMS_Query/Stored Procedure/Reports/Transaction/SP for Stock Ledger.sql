USE MEIJI_RUSK
GO
--select * from m_stk where mso_id is not null
--select * from m_stk
--update m_stk set stk_trat+stk_tratdiff=stk_currat*stk_rat+stk_ratdiff where stk_trat+stk_tratdiff=0 and stk_qty>0 
--select * from m_stk where stk_frm='t_itm' and itm_id=32
--select * from m_stk where itm_id=32 and stk_dat<='10/01/2012' and cur_id=1
--update m_stk set stk_currat=1 where stk_qty<>0 and stk_currat=0

--exec sp_rpt_inv '02','01/05/2015','05/17/2015'

alter proc sp_rpt_inv(@m_yr_id char(2),@dt1 datetime,@dt2 datetime)
as
--Opening from Item 
	SELECT 
		m_stk.com_id,m_stk.br_id,m_stk.m_yr_id,t_id,stk_dat,titm_reg,v_titm.itm_id,itm_nam,itmsubmas_id,itmsubmas_nam,v_titm.itmsub_id,itmsub_nam,m_stk.itm_id as [t_itm],
		v_titm.titm_nam_rpt as [titm_nam],'Opening' as [description],stk_qty as [opening],(stk_rat+stk_ratdiff)*stk_qty as [OpeningAmt],(stk_trat+stk_tratdiff)*stk_qty as [FOpeningAmt],0 as [Purchases],0 as [DebitNote],0 as [PurchaseDebitNote],0 as [Transfer],0 as [Sales],0 as [CreditNote],0 as [SalesCreditNote],stk_qty as [Bal],stk_rat+stk_ratdiff as [stk_rat],(stk_rat+stk_ratdiff)*stk_qty as [Amount],stk_trat+stk_tratdiff as [stk_trat],(stk_trat+stk_tratdiff)*stk_qty as [FAmount],
		stk_frm,m_stk.wh_id,wh_nam,v_titm.bd_id,v_titm.bd_nam,v_titm.titm_exp,m_stk.cur_id,cur_snm,m_stk.mso_id, mso_no,v_sca.sca_nam
		from m_stk
		inner join v_titm
		on m_stk.itm_id=v_titm.titm_id		
		left join m_wh
		on m_stk.wh_id=m_wh.wh_id		
		left join m_cur
		on m_stk.cur_id=m_cur.cur_id
		left join v_sca
		on v_titm.titm_id=v_sca.titm_id
		left join t_mso				
		on m_stk.mso_id=t_mso.mso_id
		where stk_frm='t_itm'
		and m_stk.m_yr_id=@m_yr_id
		
union all
--Opening`
	SELECT 
		m_stk.com_id,m_stk.br_id,m_stk.m_yr_id,t_id,stk_dat,titm_reg,v_titm.itm_id,v_titm.itm_nam,itmsubmas_id,itmsubmas_nam,itmsub_id,itmsub_nam,m_stk.itm_id as [t_itm],titm_nam_rpt,'Opening' as [description],stk_qty as [opening],(stk_rat+stk_ratdiff)*stk_qty as [OpeningAmt],(stk_trat+stk_tratdiff)*stk_qty as [FOpeningAmt],
		0 as [Purchases],0 as [DebitNote],0 as [PurchaseDebitNote],0 as [Transfer],0 as [Sales],0 as [CreditNote],0 as [SalesCreditNote],
		stk_qty as [Bal],stk_rat+stk_ratdiff as [stk_rat],(stk_rat+stk_ratdiff)*stk_qty as [Amount],stk_trat+stk_tratdiff as [stk_trat],(stk_trat+stk_tratdiff)*stk_qty as [FAmount],stk_frm,m_stk.wh_id,wh_nam,
		v_titm.bd_id,bd_nam,v_titm.titm_exp,m_stk.cur_id,cur_snm,m_stk.mso_id,mso_no,v_sca.sca_nam
		from m_stk
		inner join v_titm
		on m_stk.itm_id=v_titm.titm_id
		left join m_wh
		on m_stk.wh_id=m_wh.wh_id
		left join m_cur
		on m_stk.cur_id=m_cur.cur_id
		left join v_sca
		on v_titm.titm_id=v_sca.titm_id
		left join t_mso 
		on m_stk.mso_id=t_mso.mso_id		
		where stk_dat<@dt1
		and m_stk.m_yr_id=@m_yR_id
		and stk_frm not in ('SO','t_itm')
union all
--Transaction
--Purchase
	SELECT 
		m_stk.com_id,m_stk.br_id,m_stk.m_yr_id,t_id,stk_dat,titm_reg,v_titm.itm_id,itm_nam,itmsubmas_id,itmsubmas_nam,itmsub_id,itmsub_nam,m_stk.itm_id as [t_itm],titm_nam_rpt,'Purchase Bill # '+rtrim(cast(t_id as varchar(100))) + ' '+v_po_grn_qc_pb.sup_nam [description],0 as [opening],0 as [OpeningAmt],0 as [FOpeningAmt],stk_qty as [Purchases],0 as [DebitNote],0 as [PurchaseDebitNote],0 as [Transfer],0 as [Sales],0 as [CreditNote],0 as [SalesCreditNote],stk_qty as [Bal],stk_rat+stk_ratdiff as [stk_rat],(stk_rat+stk_ratdiff)*stk_qty as [Amount],stk_trat+stk_tratdiff as [stk_trat],(stk_trat+stk_tratdiff)*stk_qty as [FAmount],
		stk_frm,m_stk.wh_id,wh_nam,v_titm.bd_id,bd_nam,v_titm.titm_exp,m_stk.cur_id,cur_snm,'' as [mso_id],'' as [mso_no],v_sca.sca_nam
		from m_stk
		inner join v_titm
		on m_stk.itm_id=v_titm.titm_id		
		left join m_wh
		on m_stk.wh_id=m_wh.wh_id		
		left join m_cur
		on m_stk.cur_id=m_cur.cur_id
		left join v_po_grn_qc_pb
		on m_stk.t_id=v_po_grn_qc_pb.mgrn_id
		left join v_sca
		on v_titm.titm_id=v_sca.titm_id
		where stk_dat between @dt1 and @dt2
		and m_stk.m_yr_id=@m_yr_id
		and stk_frm<>'t_itm'
		and stk_frm='GRN'
union all
--Debit Note
	SELECT 
		m_stk.com_id,m_stk.br_id,m_stk.m_yr_id,t_id,stk_dat,titm_reg,v_titm.itm_id,itm_nam,itmsubmas_id,itmsubmas_nam,itmsub_id,itmsub_nam,m_stk.itm_id as [t_itm],titm_nam_rpt,stk_frm+' # '+rtrim(cast(t_id as varchar(100))) as  [description],0 as [opening],0 as [OpeningAmt],0 as [FOpeningAmt],0 as [Purchases],stk_qty as [DebitNote],0 as [PurchaseDebitNote],0 as [Transfer],0 as [Sales],0 as [CreditNote],0 as [SalesCreditNote],stk_qty as [Bal],stk_rat+stk_ratdiff as [stk_rat],(stk_rat+stk_ratdiff)*stk_qty as [Amount],stk_trat+stk_tratdiff as [stk_trat],(stk_trat+stk_tratdiff)*stk_qty as [FAmount],
		stk_frm,m_stk.wh_id,wh_nam,v_titm.bd_id,bd_nam,v_titm.titm_exp,m_stk.cur_id,cur_snm,'' as [mso_id],'' as [mso_no],v_sca.sca_nam
		from m_stk
		inner join v_titm
		on m_stk.itm_id=v_titm.titm_id		
		left join m_wh
		on m_stk.wh_id=m_wh.wh_id	
		left join m_cur
		on m_stk.cur_id=m_cur.cur_id
		left join v_sca
		on v_titm.titm_id=v_sca.titm_id
		where stk_dat between @dt1 and @dt2
		and m_stk.m_yr_id=@m_yr_id
		and stk_frm<>'t_itm'
		and stk_frm='DebitNote'
union all
--Transfer Note
	SELECT 
		m_stk.com_id,m_stk.br_id,m_stk.m_yr_id,t_id,stk_dat,titm_reg,v_titm.itm_id,itm_nam,itmsubmas_id,itmsubmas_nam,itmsub_id,itmsub_nam,m_stk.itm_id as [t_itm],titm_nam_rpt,case stk_frm when 'ITN' then 'Warehouse Transfer Note # ' +rtrim(CAST(t_id as CHAR(100))) when 'TransRM' then 'Raw Material # ' +rtrim(CAST(t_id as CHAR(100))) when 'TransclaimI' then 'Issue on Claim # ' +rtrim(CAST(t_id as CHAR(100)))when 'TransclaimR' then 'Receive on Claim # ' +rtrim(CAST(t_id as CHAR(100))) when 'TransRM' then stk_des when 'TransSF1' then 'Semi Finish 1 #' +rtrim(CAST(t_id as varchar(100))) when 'TransSF2M' then 'Semi Finish 2 #' +rtrim(CAST(t_id as varchar(100))) when 'TransSF2' then 'Semi Finish 2 #' +rtrim(CAST(t_id as varchar(100))) when 'TransFG' then 'Transfer Finish Goods #' +rtrim(CAST(t_id as varchar(100))) when 'ReturnRM' then 'Return Material # '+rtrim(cast(t_id as varchar(100))) when 'stk_dispose' then 'Disposal # '+rtrim(cast(t_id as varchar(100))) when 'stk_adj' then stk_des when 'stk_adjmon' then 'Adjustment # '+rtrim(cast(t_id as varchar(100)))  when 'stk_adjmonfg' then 'Finish Goods Adjustment # '+rtrim(cast(t_id as varchar(100))) when 'stk_gatepass' then stk_des when 'TransREPACK' then 'Re-Packing # '+rtrim(cast(t_id as varchar(100))) when 'TransMASTERREPACK' then 'Re-Packing # '+rtrim(cast(t_id as varchar(100))) end as  [description],0 as [opening],0 as [OpeningAmt],0 as [FOpeningAmt],0 as [Purchases],0 as [DebitNote],0 as [PurchaseDebitNote],stk_qty as [Transfer],0 as [Sales],0 as [CreditNote],0 as [SalesCreditNote],stk_qty as [Bal],stk_rat+stk_ratdiff as [stk_rat],(stk_rat+stk_ratdiff)*stk_qty as [Amount],stk_trat+stk_tratdiff as [stk_trat],(stk_trat+stk_tratdiff)*stk_qty as [FAmount],
		stk_frm,m_stk.wh_id,wh_nam,v_titm.bd_id,bd_nam,v_titm.titm_exp,m_stk.cur_id,cur_snm,m_stk.mso_id,t_mso.mso_no,v_sca.sca_nam
		from m_stk
		inner join v_titm
		on m_stk.itm_id=v_titm.titm_id		
		left join m_wh
		on m_stk.wh_id=m_wh.wh_id		
		left join m_cur
		on m_stk.cur_id=m_cur.cur_id
		left join t_mso
		on m_stk.mso_id=t_mso.mso_id
		left join v_sca
		on v_titm.titm_id=v_sca.titm_id
		where stk_dat between @dt1 and @dt2
		and m_stk.m_yr_id=@m_yr_id
		and stk_frm<>'t_itm'
		and stk_frm in ('ITN','TransclaimI','TransferRM','TransRM','TransFG','ReturnRM','stk_adjmon','stk_adjmonfg','stk_adj','stk_dispose','stk_gatepass','TransSF2M','TransSF1','TransSF2','TransREPACK','TransMASTERREPACK')
--union all
----Packing Material Adjustment
--	SELECT 
--		t_id,stk_dat,v_titm.itm_id,itm_nam,itmsubmas_id,itmsubmas_nam,itmsub_id,itmsub_nam,m_stk.itm_id as [t_itm],titm_nam_rpt,stk_des as  [description],0 as [opening],0 as [OpeningAmt],0 as [FOpeningAmt],0 as [Purchases],0 as [DebitNote],0 as [PurchaseDebitNote],stk_qty as [Transfer],0 as [Sales],0 as [CreditNote],0 as [SalesCreditNote],stk_qty as [Bal],stk_rat+stk_ratdiff as [stk_rat],(stk_rat+stk_ratdiff)*stk_qty as [Amount],stk_trat+stk_tratdiff as [stk_trat],(stk_trat+stk_tratdiff)*stk_qty as [FAmount],
--		stk_frm,m_stk.wh_id,wh_nam,v_titm.bd_id,bd_nam,v_titm.titm_exp,m_stk.cur_id,cur_snm,m_stk.mso_id,t_mso.mso_no,v_sca.sca_nam
--		from m_stk
--		inner join v_titm
--		on m_stk.itm_id=v_titm.titm_id		
--		left join m_wh
--		on m_stk.wh_id=m_wh.wh_id		
--		left join m_cur
--		on m_stk.cur_id=m_cur.cur_id
--		left join t_mso
--		on m_stk.mso_id=t_mso.mso_id
--		left join v_sca
--		on v_titm.titm_id=v_sca.titm_id
--		where stk_dat between @dt1 and @dt2
--		and m_stk.m_yr_id=@m_yr_id
--		and stk_frm<>'t_itm'
--		and stk_frm in ('stk_pkadj')
--		--union all
union all
--Sales
	SELECT 
		m_stk.com_id,m_stk.br_id,m_stk.m_yr_id,t_id,stk_dat,titm_reg,v_titm.itm_id,itm_nam,itmsubmas_id,itmsubmas_nam,itmsub_id,itmsub_nam,m_stk.itm_id as [t_itm],titm_nam_rpt,'Invoice # '+RTRIM(cast(minv_id as CHAR(100)))+ ' Customer '+cus_nam as [description],0 as [opening],0 as [OpeningAmt],0 as [FOpeningAmt],0 as [Purchases],0 as [DebitNote],0 as [PurchaseDebitNote],0 as [Transfer],stk_qty as [Sales],0 as [CreditNote],0 as [SalesCreditNote],stk_qty as [Bal],stk_rat+stk_ratdiff as [stk_rat],(stk_rat+stk_ratdiff)*stk_qty as [Amount],stk_trat+stk_tratdiff as [stk_trat],(stk_trat+stk_tratdiff)*stk_qty as [FAmount],
		stk_frm,m_stk.wh_id,wh_nam,v_titm.bd_id,bd_nam,v_titm.titm_exp,m_stk.cur_id,cur_snm,m_stk.mso_id,v_so_dc_inv.mso_no,v_sca.sca_nam
		from m_stk
		inner join v_titm
		on m_stk.itm_id=v_titm.titm_id		
		left join m_wh
		on m_stk.wh_id=m_wh.wh_id		
		left join m_cur
		on m_stk.cur_id=m_cur.cur_id
		left join v_so_dc_inv
		on m_stk.mso_id=v_so_dc_inv.mso_id
		left join v_sca
		on v_titm.titm_id=v_sca.titm_id
		where stk_dat between @dt1 and @dt2
		and m_stk.m_yr_id=@m_yr_id
		and stk_frm<>'t_itm'		
		and stk_frm ='DC'
union all
--Credit Note
	SELECT 
		m_stk.com_id,m_stk.br_id,m_stk.m_yr_id,t_id,stk_dat,titm_reg,v_titm.itm_id,itm_nam,itmsubmas_id,itmsubmas_nam,itmsub_id,itmsub_nam,m_stk.itm_id as [t_itm],titm_nam_rpt,stk_frm+' # '+rtrim(cast(t_id as varchar(100))) as [description],0 as [opening],0 as [OpeningAmt],0 as [FOpeningAmt],0 as [Purchases],0 as [DebitNote],0 as [PurchaseDebitNote],0 as [Transfer],0 as [Sales],stk_qty as [CreditNote],0 as [SalesCreditNote],stk_qty as [Bal],stk_rat+stk_ratdiff as [stk_rat],(stk_rat+stk_ratdiff)*stk_qty as [Amount],stk_trat+stk_tratdiff as [stk_trat],(stk_trat+stk_tratdiff)*stk_qty as [FAmount],
		stk_frm,m_stk.wh_id,wh_nam,v_titm.bd_id,bd_nam,v_titm.titm_exp,m_stk.cur_id,cur_snm,'' as [mso_id],'' as [mso_no],v_sca.sca_nam
		from m_stk
		inner join v_titm
		on m_stk.itm_id=v_titm.titm_id		
		left join m_wh
		on m_stk.wh_id=m_wh.wh_id		
		left join m_cur
		on m_stk.cur_id=m_cur.cur_id
		left join v_sca
		on v_titm.titm_id=v_sca.titm_id
		where stk_dat between @dt1 and @dt2
		and m_yr_id=@m_yr_id 
		and stk_frm<>'t_itm'
		and stk_frm ='CreditNote'

