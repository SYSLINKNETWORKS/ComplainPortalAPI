USE NATHI
GO
--drop table t_itmsalcom
create table t_itmsalcom
(
titmsalcom_sno	int identity(1001,1),
titmsalcom_id	int,
titmsalcom_dat datetime,
titmsalcom_comm float,
titmsalcom_typ char(1),
titmsalcom_act bit,
log_act char(1),
log_dat datetime,
usr_id int,
log_ip varchar(100),
titm_id int,
emppro_id int
)


--Constraint
--Not Null
alter table t_itmsalcom alter column titmsalcom_id int not null

--Primary Key
alter table t_itmsalcom add constraint PK_titmsalcom_titmsalcomid primary key (titmsalcom_id)

--Foreign key
alter table t_itmsalcom add constraint FK_titmsalcom_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)
alter table t_itmsalcom add constraint FK_titmsalcom_TITMID foreign key (titm_id) references t_itm(titm_id)

