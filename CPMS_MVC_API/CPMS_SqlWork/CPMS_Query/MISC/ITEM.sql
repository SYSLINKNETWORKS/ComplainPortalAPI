USE PAGEY
GO
--delete from t_itmfg
delete from t_itmrat
delete from m_bd_rat
delete from t_itmqty
delete from t_itm
---select * from m_itmsub
--delete from m_itmsub
--delete from m_itmsubmas
--delete from m_itmqty
select * from t_itmrat
update t_itmrat set titmrat_rrat =(select traderate from primeagencies.dbo.itemmaster inner join t_itm on ItemMaster.ItemId=t_itm.titm_idold where  t_itm.titm_id=t_itmrat.titm_id )



declare @com_id int,@br_id int,
@titm_nam varchar(100),@itm_id int,@itmsub_id int,@stdcat_id int,@bd_id int,@titm_bar varchar(100),@sca_id int,@inner_titm_qty float,@inner_sca_id int,@master_titm_qty float,@master_sca_id int,@man_sca_id int,@man_qty float,@titm_mlvl float,@titm_rlvl float,@titm_prat float,@titm_srat float,@titm_act bit,@titm_cm float,@ck_bth bit,@ck_fill bit,@titm_img_ck bit,@titm_ckscr bit,@titm_idold varchar(1000),@packing float,
@titm_id int,@titmrat_dat datetime,@itmqty_id int
	declare  titm1  cursor for			
			SELECT Itemid,CompanyID,rtrim(ItemName),Packing,CostRate,TradeRate FROM primeagencies.dbo.itemmaster  
		OPEN titm1
			FETCH NEXT FROM titm1
			INTO @titm_idold,@bd_id,@titm_nam,@packing,@titm_prat,@titm_srat
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @com_id='01'
					set @br_id='01'
					set @titm_mlvl=0 
					set @titm_rlvl=0 
					set @sca_id=1
					SET @bd_id=(select bd_id from m_bd where bd_idold=@bd_id)
					set @itm_id=1
					set @itmsub_id=1
					set @stdcat_id=1
					set @titm_bar=''
					set @inner_titm_qty=@packing
					set @inner_sca_id=2
					set @master_titm_qty=1
					set @master_sca_id=2
					set @man_sca_id=1
					set @man_qty=0
					set @titm_bar=''
					set @titmrat_dat='07/01/2013'
					set @itmqty_id=1

					--Item Detail
					exec ins_t_itm @titm_nam ,@itm_id ,@itmsub_id ,@stdcat_id ,@bd_id ,@titm_bar ,@sca_id ,@inner_titm_qty ,@inner_sca_id ,@master_titm_qty ,
					@master_sca_id ,@man_sca_id ,@man_qty ,@titm_mlvl ,@titm_rlvl ,@titm_prat ,@titm_srat ,1,0,0 ,0,0 ,0,null,null,'U',@titm_idold,@titm_id_out=@titm_id output							

					--Item Siz
					exec ins_t_itmqty @itmqty_id ,@titm_id ,'U',''
					
					--Item Rate
					exec ins_t_itmrat @com_id ,@br_id ,@titmrat_dat ,@titm_prat ,@titm_srat ,1,'U',@titm_id ,@itmqty_id,@bd_id,@itmsub_id,'','','',''
					
					FETCH NEXT FROM titm1
					INTO @titm_idold,@bd_id,@titm_nam,@packing,@titm_prat,@titm_srat
		end
		CLOSE titm1
		DEALLOCATE titm1
		GO

