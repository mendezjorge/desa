
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010294" is



  p_clie_prov             varchar2(1):= 'C';
  p_codi_tipo_empl_vend   number:= to_number(fa_busc_para ('p_codi_tipo_empl_vend'));
  p_codi_tipo_empl_recl   number:= to_number(fa_busc_para ('p_codi_tipo_empl_recl'));
  p_codi_tipo_empl_cobr   number:= to_number(fa_busc_para ('p_codi_tipo_empl_cobr'));
  
  p_fami_esen             varchar2(500):= ltrim(rtrim(fa_busc_para('p_fami_esen')));  
  p_codi_mone_mmnn        number:= to_number(fa_busc_para('p_codi_mone_mmnn'));
  p_codi_mone_dola        number:= to_number(fa_busc_para('p_codi_mone_dola'));
  
  p_codi_base             number:= pack_repl.fa_devu_codi_base; 
  
  p_indi_most_mens_sali  varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_most_mens_sali')));  
  p_form_cons_esta_clie  varchar2(500):= ltrim(rtrim(fa_busc_para('p_form_cons_esta_clie'))); 
  
 -- p_buzo_tipo_cont_labe  varchar2(500):= ltrim(rtrim(fa_busc_para('P_BUZO_TIPO_CONT_LABE'))); 
  
  






/****************   CARGAS DE DATOS ****************/
PROCEDURE pp_muestra_clas_clie(i_clpr_codi      in number,
                               u_clpr_clas_desc out varchar2) IS
  
BEGIN
  select clas1_desc
    into u_clpr_clas_desc
    from come_clie_clas_1 a, come_clie_prov b
   where a.clas1_codi = b.clpr_clie_clas1_codi
     and clpr_codi = i_clpr_codi;
exception
  when no_data_found then
		u_clpr_clas_desc := null;
END;


end I010294;
