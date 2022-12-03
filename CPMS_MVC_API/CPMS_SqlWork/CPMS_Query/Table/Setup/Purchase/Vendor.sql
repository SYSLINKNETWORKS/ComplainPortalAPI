USE phm
GO

--select * from m_sup

create table m_supeva
(
supeva_sno int identity (1001,1),
supeva_id int,
supeva_act bit,
supeva_app bit,
supeva_stdat datetime,
supeva_nam varchar(250),
supeva_cp varchar(250),
supeva_add varchar(1000),
terr_id int,
supeva_pho varchar(100),
supeva_mob varchar(100),
supeva_fax varchar(100),
supeva_eml varchar(100),
supeva_lic varchar(100),
supeva_exp datetime,
supeva_iso bit,
supeva_qm bit,
supeva_inspec char(2),
supeva_ckass bit,
supeva_skill char(1),
supeva_ncp varchar(250),
supeva_cus1 varchar(250),
supeva_cus2 varchar(250),
supeva_perinfo varchar(250),
supeva_pos varchar(250),
supeva_qrs varchar(250),
supeva_otdel varchar(250),
supeva_asalsrv varchar(250),
supeva_suprply bit,
supeva_mrktrep bit,
supeva_supprowrk bit,
supeva_supqua bit,
supeva_starea bit,
supeva_manqua bit,
supeva_supstnd bit,
supeva_vistper varchar(250),
supeva_vistdat datetime,
supeva_rmk varchar(1000),
supeva_appby varchar(250),
supeva_typ char(1)
)


--Constrants
--Not Null
alter table m_supeva alter column supeva_id int not null

--Primary Key
alter table m_supeva add constraint PK_MSUPEVA_SUPEVAID primary key (supeva_id)

--Foreign Key
alter table m_supeva add constraint FK_STERR_terrID foreign key (terr_id) references s_terr (terr_id)


----Unique
--alter table m_sup add constraint UQ_MSUP_SUPNAM Unique (sup_nam)


