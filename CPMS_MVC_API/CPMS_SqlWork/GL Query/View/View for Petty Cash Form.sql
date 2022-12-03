USE ZSons
GO

create view v_gl_m_pc
as
select distinct com_id,br_id, acc_no_cash from gl_m_pc

