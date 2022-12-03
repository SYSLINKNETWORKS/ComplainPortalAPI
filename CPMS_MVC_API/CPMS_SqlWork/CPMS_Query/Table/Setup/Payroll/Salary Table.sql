USE MFI
GO

--drop table m_sal

create table m_sal
(
msal_sno int identity(1,1001),
msal_id int,
msal_dat datetime,
msal_pamt float,
msal_val float,
msal_amt float,
emppro_id int,
msal_typ char(1)
)

--Constraint
--Not Null
alter table m_sal alter column msal_id int not null

--Primary key
alter table m_sal add constraint PK_MSAL_MSALID primary key (msal_id )

--Foreign key
alter table m_sal add constraint FK_MSAL_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)
