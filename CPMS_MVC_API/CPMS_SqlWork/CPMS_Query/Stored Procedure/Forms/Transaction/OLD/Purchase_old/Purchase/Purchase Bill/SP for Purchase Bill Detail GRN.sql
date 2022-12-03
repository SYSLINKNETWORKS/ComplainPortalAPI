--select * from t_dpb_grn where mgrn_id=24
--select * from t_mpb where mpb_id=27
--select * from t_dpb where mpb_id=27
--update t_mpb set mpb_st=0 where mpb_id=27
--alter table t_dpb_grn drop column mgrn_id
--alter table t_dpb_grn add constraint FK_Dpbgrn_MQCID foreign key (mqc_id) references t_mqc (mqc_id)
--alter table t_dpb_grn add mqc_id int
--select * from t_dpb_grn
--select * from t_mpb
USE phm
GO
--Insert
alter proc ins_t_dpb_grn(@mpb_id int,@mqc_id int,@m_yr_id char(2))
as
declare
@dpb_grn_id int,
@dpb_rat float,
@titm_id int,
@mpb_rat float,
@cur_id int,
@mpb_can bit,
@itmqty_id float,
@stk_stdsiz float,
@sca_met float
begin
	set @mpb_can=(select mpb_can from t_mpb where mpb_id=@mpb_id)
	set @dpb_grn_id=(select max(dpb_grn_id)+1 from t_dpb_grn)
		if @dpb_grn_id is null
			begin	
				set @dpb_grn_id=1
			end
	insert into t_dpb_grn(dpb_grn_id,mpb_id,mqc_id,m_yr_id)
			values(@dpb_grn_id,@mpb_id,@mqc_id,@m_yr_id)
	--GRN STATUS
	if (@mpb_can=0)
		begin
			update t_mqc set mqc_act=1,mqc_typ='S' where mqc_id=@mqc_id
			
		end
	--Stock	
	declare grn_cursor CURSOR for
			select dpb_amt/dpb_qty ,titm_id,itmqty_id,dpb_stdsiz,cur_id,mpb_rat,isnull(sca_met,1) as [sca_met] from t_mpb inner join  t_dpb on t_mpb.mpb_id=t_dpb.mpb_id left join m_sca on t_dpb.sca_id=m_sca.sca_id where t_mpb.mpb_id=@mpb_id
				open grn_cursor 
					fetch next  from grn_cursor 
					into @dpb_rat,@titm_id,@itmqty_id,@stk_stdsiz,@cur_id,@mpb_rat,@sca_met
				while @@fetch_status =0
					begin
						if (@sca_met=0)
							begin
								set @sca_met=1
							end
						set @dpb_rat=ROUND(@dpb_rat/@sca_met,2)
						update m_stk set stk_rat=@dpb_rat,cur_id=@cur_id,stk_currat=@mpb_rat where t_id =@mqc_id and itm_id=@titm_id and itmqty_id =@itmqty_id and stk_stdsiz =@stk_stdsiz and stk_frm='grn' 
						fetch next  from grn_cursor 
						into @dpb_rat,@titm_id,@itmqty_id,@stk_stdsiz,@cur_id,@mpb_rat,@sca_met
					end
				close grn_cursor
				deallocate grn_cursor
		end
		
go

--Delete
alter proc del_t_dpb_grn(@mpb_id int)
as
declare
@mqc_id int
begin
	declare grn_cursor CURSOR for
			select mqc_id from t_dpb_grn where mpb_id=@mpb_id
				open grn_cursor 
					fetch next  from grn_cursor 
					into @mqc_id
				while @@fetch_status =0
					begin
						update m_stk set stk_rat=0 where t_id =@mqc_id and stk_frm='grn' 
						update t_mqc set mqc_act=0,mqc_typ='U' where mqc_id=@mqc_id
						fetch next  from grn_cursor 
						into @mqc_id
					end
				close grn_cursor
				deallocate grn_cursor
		--Delete Record
	delete from t_dpb_grn where mpb_id=@mpb_id
end
