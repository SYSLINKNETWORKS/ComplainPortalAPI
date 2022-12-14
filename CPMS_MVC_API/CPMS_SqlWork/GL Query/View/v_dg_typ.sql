----View for Voucher Type
create view [dbo].[v_dg_typ]
as
select gl_vch_typ.com_id,gl_vch_typ.br_id as [br_id],typ_id,typ_nam as [Name],typ_snm as [Short Name],
	case	when typ_cat='Dr' Then 'Debit Voucher' 
			when typ_cat= 'Cr' then 'Credit Voucher' 
			when typ_cat='JV' then 'Journal Voucher'
	else '' end 
	as [Category], ID as [Account ID],[Name] as [Account Name],typ_typ 
	from gl_vch_typ
	--Join with View of Master Account
	left join v_macc
	on gl_vch_typ.acc_id=v_macc.ID
GO

