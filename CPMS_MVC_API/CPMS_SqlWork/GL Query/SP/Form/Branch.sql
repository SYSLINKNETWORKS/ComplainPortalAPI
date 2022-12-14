USE meiji_rusk 
GO


--ALTER table m_br add br_folderid varchar(max)
--update m_br set br_folderid='0BxvGBERF1Ys-OF9mS3lVSTF1VU0' where br_id='01'
--select * from m_br

----Insert Branch

alter proc [dbo].[ins_m_br](@br_nam varchar(100),@br_add varchar(100),@br_pho varchar(100),
					@br_mob varchar(100),@br_fax varchar(100),@br_eml varchar(100),
					@br_web varchar(100),@com_id char(2),@br_typ char(1),@br_folderid varchar(max),@br_id_out char(2) output)
as
declare @br_id char(3)
begin
set @br_id=dbo.autonumber((select max(br_id) from m_br),2)
insert into m_br(br_id,br_nam,br_add,br_pho,br_mob,br_fax,br_eml,br_web,com_id,br_typ,br_folderid)
  values(@br_id,@br_nam,@br_add,@br_pho,@br_mob,@br_fax,@br_eml,@br_web,@com_id,@br_typ,@br_folderid)
 set @br_id_out=@br_id

end
GO
----Update Branch

alter proc [dbo].[upd_m_br](@br_id char(3),@br_nam varchar(100),@br_add varchar(100),@br_pho varchar(100),
					@br_mob varchar(100),@br_fax varchar(100),@br_eml varchar(100),
					@br_web varchar(100),@com_id char(2),@br_typ char(1),@br_folderid varchar(max))
as
begin
update m_br set br_nam=@br_nam,br_add=@br_add,br_pho=@br_pho,br_mob=@br_mob,br_fax=@br_fax,br_eml=@br_eml,
		br_web=@br_web,com_id=@com_id,br_typ=@br_typ,br_folderid=@br_folderid
where br_id=@br_id
end
GO


----Delete the Branch
alter proc [dbo].[del_m_br] (@br_id char(3))
as
begin
delete from m_br where br_id=@br_id
end
GO

