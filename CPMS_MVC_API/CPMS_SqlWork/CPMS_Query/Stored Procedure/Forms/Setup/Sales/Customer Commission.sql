use meiji_rusk
go


create proc [dbo].[ins_m_cuscom] (@cuscom_dat datetime,@cuscom_com float,@cuscom_fr float,@cus_id int,@titm_id int,@cuscom_typ char(1),@cuscom_act bit )
as
declare 
@cuscom_id int
begin
	set @cuscom_id=(select max(cuscom_id) from m_cuscom)+1
		if @cuscom_id is null 
		begin
			set @cuscom_id=1
		end
	insert into m_cuscom (cuscom_id,cuscom_dat,cuscom_com,cuscom_fr,cuscom_typ,cuscom_act,titm_id,cus_id)
		  values (@cuscom_id,@cuscom_dat,@cuscom_com,@cuscom_fr,@cuscom_typ,@cuscom_act,@titm_id,@cus_id)


end
go


create proc [dbo].[del_m_cuscom](@cuscom_dat datetime,@cus_id int)
as
begin
delete from m_cuscom where	cus_id=@cus_id and cuscom_dat=@cuscom_dat

end
go



