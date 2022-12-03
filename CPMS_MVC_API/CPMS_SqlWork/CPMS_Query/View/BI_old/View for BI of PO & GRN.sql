USE MFI
GO
--View for BI PO & GRN
CREATE view v_bi_po_grn
as
select mpo_id,titm_id,sum(dgrn_qty) as [dgrn_qty] from t_mgrn inner join t_dgrn on t_mgrn.mgrn_id=t_dgrn.mgrn_id group by mpo_id,titm_id

SELECT v_rpt_po.mpo_id as [ID],mpo_dat as [Date],sup_nam as [Supplier],titm_nam+' '+isnull(bd_nam,'') as [Item],rtrim(cast((dpo_qty-isnull(dgrn_qty,0)) as varchar(100)))+' '+sca_nam as [Qty]" +
                        " from v_rpt_po"+
                        " left join v_bi_po_grn"+
                        " on v_rpt_po.mpo_id=v_bi_po_grn.mpo_id"+
                        " and v_rpt_po.titm_id=v_bi_po_grn.titm_id" +
                        " where mpo_act=0 and mpo_dat<='" + dt_exp.Value.ToShortDateString() + "'" +
                        " order by mpo_dat

