--select * from t_dinv_dc
--select * from t_minv
--select * from m_stk
--Insert
alter proc ins_t_dinv_dc(@minv_id int,@mdc_id int,@m_yr_id char(2))
as
declare
@dinv_dc_id int,
@dinv_rat float,
@titm_id int
begin
	set @dinv_dc_id=(select max(dinv_dc_id)+1 from t_dinv_dc)
		if @dinv_dc_id is null
			begin	
				set @dinv_dc_id=1
			end
	insert into t_dinv_dc(dinv_dc_id,minv_id,mdc_id,m_yr_id)
			values(@dinv_dc_id,@minv_id,@mdc_id,@m_yr_id)
	--dc STATUS
	update t_mdc set mdc_act=1 where mdc_id=@mdc_id

	--Stock	
	declare dc_cursor CURSOR for
			select dinv_rat,titm_id from t_dinv where minv_id=@minv_id
				open dc_cursor 
					fetch next  from dc_cursor 
					into @dinv_rat,@titm_id
				while @@fetch_status =0
					begin
						update m_stk set stk_rat=@dinv_rat where t_id =@mdc_id and itm_id=@titm_id and stk_frm='DC' 
						fetch next  from dc_cursor 
						into @dinv_rat,@titm_id
					end
				close dc_cursor
				deallocate dc_cursor
end
		
go

--Delete
alter proc del_t_dinv_dc(@minv_id int)
as
declare
@mdc_id int
begin
--Stock	
	declare dc_cursor CURSOR for
			select mdc_id from t_dinv_dc where minv_id=@minv_id
				open dc_cursor 
					fetch next  from dc_cursor 
					into @mdc_id
				while @@fetch_status =0
					begin
						update m_stk set stk_rat=0 where t_id =@mdc_id and stk_frm='DC' 
						fetch next  from dc_cursor 
						into @mdc_id
					end
				close dc_cursor
				deallocate dc_cursor
	--Delete Record
	delete from t_dinv_dc where minv_id=@minv_id
end