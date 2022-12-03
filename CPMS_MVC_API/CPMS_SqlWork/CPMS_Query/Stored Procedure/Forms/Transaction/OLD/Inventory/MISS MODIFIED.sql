USE MFI
GO
--exec ins_t_miss_mod 253,88,'07/12/2012',25.62,630,6,1
--exec del_t_miss '01','01',6114,'','',1,''
--select * from t_dso where mso_id=4 and titm_id=630








--exec ins_t_miss_mod 345
--select * from t_dfg where mso_id=18 and titm_id=814 and miss_id_fg not in (select miss_id from t_miss where miss_typ='U')
--exec ins_t_miss_mod 340
--select * from t_miss where miss_id=340
--select * from t_diss where miss_id=340
--alter table t_miss add miss_rmk varchar(250)
alter proc [dbo].[ins_t_miss_mod](@miss_id int)
as
declare
@com_id char(2),@br_id char(3),@m_yr_id char(2),
@mso_batact bit,
@aud_act char(10),
@cus_id int,
@bd_id int,
@miss_act bit,
@miss_ckso bit,
@miss_typ char(1),
@aud_frmnam varchar(250),
@aud_des varchar(1000),
@usr_id int,
@aud_ip char(100),
@titm_id_patti int,
@mso_id int,
@dso_batact bit,
@miss_nob float,
@miss_dat datetime,
@mso_no int,
@mbat_id int,
@mfg_dat datetime,
@titm_id int,
@diss_qty float,
@dbat_qty float,
@titm_id_rm int
begin	
declare cur_titmmfg cursor for
--		select top 1 titm_id  from  t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id where miss_id_fg=6114--@miss_id and mfg_typ<>'M'
		select titm_id  from  t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id where miss_id_fg=@miss_id and mfg_typ<>'M'
		OPEN cur_titmmfg
			FETCH NEXT FROM cur_titmmfg
			INTO @titm_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
			set @dso_batact =0
			set @aud_act='Insert'
			set @mso_id=(select distinct mso_id from t_dfg where titm_id=@titm_id and miss_id_fg=@miss_id)
			set @mfg_dat=(select min (mfg_dat) from t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id where mso_id=@mso_id and titm_id=@titm_id and miss_id_Fg=@miss_id)
			set @miss_nob =(select sum(dfg_batqty) from t_dfg where mso_id=@mso_id and titm_id=@titm_id and miss_id_fg=@miss_id)
			set @miss_dat=@mfg_dat
			set @com_id='01'
			set @br_id='01'
			set @m_yr_id ='01'
			set @cus_id=(select distinct cus_id from t_mso where mso_id=@mso_id)
			set @miss_act=1
			set @miss_ckso=1
			set @miss_typ='U'
			set @aud_frmnam='transactionrawmaterialtransfernote'
			set @aud_des=''
			set @usr_id=1
			set @aud_ip=''			
			set @titm_id_patti =0
			set @bd_id=(select distinct  bd_id from t_dso where mso_id=@mso_id and titm_id=@titm_id)
			set @mbat_id=(select top 1 m_mbat.mbat_id from m_mbat inner join m_dbat_fg on m_mbat.mbat_id=m_dbat_fg.mbat_id  inner join m_dbat_cus on m_mbat.mbat_id=m_dbat_cus.mbat_id
			where m_dbat_fg.titm_id=@titm_id and cus_id=@cus_id and mbat_dat=(select max(mbat_dat) from m_mbat inner join m_dbat_fg on m_mbat.mbat_id=m_dbat_fg.mbat_id  inner join m_dbat_cus on m_mbat.mbat_id=m_dbat_cus.mbat_id
			where m_dbat_fg.titm_id=@titm_id and cus_id=@cus_id and mbat_dat<=@mfg_dat))
			

	insert into t_miss(miss_id,miss_dat,miss_nob,titm_id,titm_id_patti,mbat_id,miss_act,miss_ckso,mso_id,miss_typ,cus_id,bd_id,miss_st,miss_rmk )
			values(@miss_id,@miss_dat,@miss_nob,@titm_id,@titm_id_patti,@mbat_id,@miss_act,@miss_ckso,@mso_id,'U',@cus_id,@bd_id,1,'Manual')
		begin
			update t_dso set dso_batact=1 where mso_id=@mso_id and titm_id=@titm_id
		end
		
				update t_mso set mso_act=0 where mso_id=@mso_id				
		--declare @miss_id int
declare  missmfg  cursor for
		select titm_id,dbat_qty from m_dbat where mbat_id=5
		OPEN missmfg
			FETCH NEXT FROM missmfg
			INTO @titm_id_rm,@dbat_qty
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @diss_qty=@miss_nob*@dbat_qty
					exec ins_t_diss @com_id,@br_id,@m_yr_id,'',@diss_qty,@diss_qty,@titm_id_rm,@miss_id,5,'U',0,'','',@usr_id,'','',''
					FETCH NEXT FROM missmfg
					INTO @titm_id_rm,@dbat_qty
				end
				CLOSE missmfg
				DEALLOCATE missmfg

			--Voucher
			exec sp_voucher_iss @com_id,@br_id,@m_yr_id,@miss_id,@usr_id,'',''

					
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
					FETCH NEXT FROM cur_titmmfg
					INTO @titm_id
				end
				CLOSE cur_titmmfg
				DEALLOCATE cur_titmmfg
end
GO

----select * from t_miss where miss_rmk='Manual'
declare @miss_id int
declare  cur_missmfg  cursor for
		select distinct miss_id_fg from t_dfg where miss_id_fg not in (select miss_id from t_miss where miss_typ='U') and miss_id_fg=6114
		OPEN cur_missmfg
			FETCH NEXT FROM cur_missmfg
			INTO @miss_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
					EXEC ins_t_miss_mod @miss_id
					FETCH NEXT FROM cur_missmfg
					INTO @misS_id
				end
				CLOSE cur_missmfg
				DEALLOCATE cur_missmfg
--		select * from t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id where miss_id_fg not in (select miss_id from t_miss where miss_typ='U') and miss_id_fg!=6114

	--declare @miss_id int
	--declare  cur_delmis  cursor for
	--	select miss_id from t_miss where miss_rmk='Manual' and miss_id=185
	--	OPEN cur_delmis
	--		FETCH NEXT FROM cur_delmis
	--		INTO @miss_id
	--			WHILE @@FETCH_STATUS = 0
	--			BEGIN
	--				exec del_t_miss '01','01',@miss_id,'','',1,''

					
	--				FETCH NEXT FROM cur_delmis
	--				INTO @misS_id
	--			end
	--			CLOSE cur_delmis
	--			DEALLOCATE cur_delmis

--alter table t_dfg add constraint FK_DFG_MISSIDFG foreign key (miss_id_fg) references t_miss(miss_id)
--alter table t_dfg add constraint FK_DFG_MISSID foreign key (miss_id) references t_miss(miss_id)
--select * from t_miss where miss_rmk='Manual'
--select * from t_miss where mbat_id is null
--select * from t_itm where titm_id=862

--select * from t_mso where mso_id=14
--select * from t_dso where mso_id=10 and titm_id=862

--select * from m_cus where cus_id=16

--select * from t_dfg where miss_id_fg=730
--update t_miss set mbat_id=37 where miss_id=859
--update t_miss set mbat_id=65 where miss_id=730
select t_dso.mso_id,t_dso.titm_id,sum(dso_prod) -sum(dfg_qty) from t_dso
left join v_fg on t_dso.mso_id=v_fg.mso_id and t_dso.titm_id=v_fg.titm_id
 where t_dso.mso_id=18 and dso_prod<>0 group by t_dso.mso_id,t_dso.titm_id
select mso_id,titm_id,sum(dfg_qty) from v_fg where mso_id=18 and titm_id=935 group by mso_id,titm_id








