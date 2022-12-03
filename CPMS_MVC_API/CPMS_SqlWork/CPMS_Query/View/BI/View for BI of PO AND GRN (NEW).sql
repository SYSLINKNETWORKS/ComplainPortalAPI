USE zsons
GO

create view v_bi_po
as
select 
	t_mpo.mpo_id,mpo_dat,mpo_ddat,sup_nam,t_dpo.titm_id,titm_nam,dpo_qty,isnull(dgrn_qty,0) as [dgrn_qty],dpo_qty-isnull(dgrn_qty,0) as [bal_qty],sca_nam
	from t_mpo
	--Join with Detail PO
	inner join t_dpo
	on t_mpo.mpo_id=t_dpo.mpo_id
	--Join with Item
	inner join v_titm 
	on t_dpo.titm_id=v_titm.titm_id
	--Join with Supplier
	inner join m_sup
	on t_mpo.sup_id=m_sup.sup_id
	--lEFT JOIN WITH PO & GRN
	left join v_bi_po_grn
	on t_mpo.mpo_id=v_bi_po_grn.mpo_id
	and t_dpo.titm_id=v_bi_po_grn.titm_id

	where mpo_act=0 and dpo_st=0
	

go	
alter view v_bi_po_grn
as
select mpo_id,titm_id,sum(dgrn_qty) as [dgrn_qty] from t_mgrn
inner join t_dgrn
on t_mgrn.mgrn_id=t_dgrn.mgrn_id
group by mpo_id,titm_id
