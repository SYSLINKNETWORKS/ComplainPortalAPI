--select * from m_Stk where stk_frm='grn' and stk_trat=0
--update m_stk set stk_currat=1  where stk_frm='TRANSRM' and stk_CURRAT=0


--select round(dpb_amt/dpb_qty,4) ,t_dgrn.titm_id,t_mpb.cur_id,t_mpb.mpb_rat from m_stk inner join t_dgrn on m_stk.t_id=t_dgrn.mgrn_id and m_stk.itm_id=t_dgrn.titm_id inner join t_dpb_grn on t_dgrn.mgrn_id=t_dpb_grn.mgrn_id inner join t_dpb on t_dpb_grn.mpb_id=t_dpb.mpb_id and t_dgrn.titm_id=t_dpb.titm_id inner join t_mpb on t_dpb.mpb_id=t_mpb.mpb_id where stk_frm='grn' and stk_trat=0 and t_dgrn.mgrn_id=33 and t_dgrn.titm_id=185

	--Stock	
	declare @dpb_rat float,@titm_id int,@mpb_rat float,@cur_id int,@mgrn_id int
	declare grn_cursor CURSOR for
			select t_dgrn.mgrn_id,round(dpb_amt/dpb_qty,4) ,t_dgrn.titm_id,t_mpb.cur_id,t_mpb.mpb_rat from m_stk inner join t_dgrn on m_stk.t_id=t_dgrn.mgrn_id and m_stk.itm_id=t_dgrn.titm_id inner join t_dpb_grn on t_dgrn.mgrn_id=t_dpb_grn.mgrn_id inner join t_dpb on t_dpb_grn.mpb_id=t_dpb.mpb_id and t_dgrn.titm_id=t_dpb.titm_id inner join t_mpb on t_dpb.mpb_id=t_mpb.mpb_id where stk_frm='grn' and stk_trat=0
				open grn_cursor 
					fetch next  from grn_cursor 
					into @mgrn_id,@dpb_rat,@titm_id,@cur_id,@mpb_rat
				while @@fetch_status =0
					begin
						update m_stk set stk_rat=@dpb_rat,cur_id=@cur_id,stk_currat=@mpb_rat where t_id =@mgrn_id and itm_id=@titm_id and stk_frm='grn' 
						fetch next  from grn_cursor 
						into @mgrn_id,@dpb_rat,@titm_id,@cur_id,@mpb_rat
					end
				close grn_cursor
				deallocate grn_cursor


