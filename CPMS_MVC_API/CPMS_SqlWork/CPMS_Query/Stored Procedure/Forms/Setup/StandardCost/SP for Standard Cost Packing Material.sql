USE MFI
GO

--select * from m_mscpk

--Insert
alter proc [dbo].[ins_m_mscpk](@mscpk_dat datetime,@mscpk_rat float,@mscpk_act bit,@mscpk_typ char(1),@titm_id int)
as
declare
@mscpk_id int
begin
	set @mscpk_id=(select MAX(mscpk_id)+1 from m_mscpk)
	if (@mscpk_id is null)
		begin
			set @mscpk_id=1
		end
		
	insert into m_mscpk(mscpk_id,mscpk_dat,mscpk_rat,mscpk_act,mscpk_typ,titm_id)
			values(@mscpk_id,@mscpk_dat,@mscpk_rat,@mscpk_act,@mscpk_typ,@titm_id)

end
GO



--delete
alter proc [dbo].[del_m_mscpk](@mscpk_dat datetime,@itmsub_id int,@bd_id int)
as
begin
	if (@itmsub_id<>0 and @bd_id<>0)
		begin
			delete m_mscpk where mscpk_dat=@mscpk_dat and titm_id in (select titm_id from t_itm where itmsub_id=@itmsub_id and bd_id=@bd_id)
		end
	else if (@itmsub_id<>0)
		begin
			delete m_mscpk where mscpk_dat=@mscpk_dat and titm_id in (select titm_id from t_itm where itmsub_id=@itmsub_id)
		end
	else if (@bd_id<>0)
		begin
			delete m_mscpk where mscpk_dat=@mscpk_dat and titm_id in (select titm_id from t_itm where bd_id=@bd_id)
		end
	else
		begin
			delete m_mscpk where mscpk_dat=@mscpk_dat
		end
end
GO
