
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010038" is

  procedure pp_actualizar_registro(i_indi                     in varchar2,
                                   i_tipo                     in varchar2,
                                   v_lide_list_codi           in come_list_prec_conc_deta.lide_list_codi%type,
                                   v_lide_conc_codi           in come_list_prec_conc_deta.lide_conc_codi%type,
                                   v_lide_prec                in come_list_prec_conc_deta.lide_prec%type,
                                   v_lide_vige                in come_list_prec_conc_deta.lide_vige%type,
                                   v_lide_indi_vali_prec_mini in come_list_prec_conc_deta.lide_indi_vali_prec_mini%type,
                                   v_lide_maxi_porc_deto      in come_list_prec_conc_deta.lide_maxi_porc_deto%type,
                                   v_lide_prec_segu           in come_list_prec_conc_deta.lide_prec_segu%type,
                                   v_lide_mone_codi           in come_list_prec_conc_deta.lide_mone_codi%type,
                                   v_lide_user_regi           in come_list_prec_conc_deta.lide_user_regi%type,
                                   v_lide_fech_regi           in come_list_prec_conc_deta.lide_fech_regi%type,
                                   v_lide_base                in come_list_prec_conc_deta.lide_base%type,
                                   v_lide_ulti_porc_aume      in come_list_prec_conc_deta.lide_ulti_porc_aume%type,
                                   
                                   
                                   v_lide_coba_codi_barr      in come_list_prec_deta.lide_coba_codi_barr%type,
                                   v_lide_prec_ante           in come_list_prec_deta.lide_prec_ante%type,
                                   v_lide_medi_codi           in come_list_prec_deta.lide_prec_ante%type,
                                   v_lide_indi_copr_ulco      in come_list_prec_deta.lide_indi_copr_ulco%type,
                                   v_lide_prod_codi           in come_list_prec_deta.lide_prod_codi%type
                                   
                                   
                                   ) is
  begin
  
    if i_tipo = 'C' then
    
      if i_indi = 'N' then
      
        insert into come_list_prec_conc_deta
          (lide_list_codi,
           lide_conc_codi,
           lide_prec,
           lide_vige,
           lide_indi_vali_prec_mini,
           lide_maxi_porc_deto,
           lide_prec_segu,
           lide_mone_codi,
           lide_user_regi,
           lide_fech_regi,
           lide_base,
           lide_ulti_porc_aume)
        values
          (v_lide_list_codi,
           v_lide_conc_codi,
           v_lide_prec,
           v_lide_vige,
           v_lide_indi_vali_prec_mini,
           v_lide_maxi_porc_deto,
           v_lide_prec_segu,
           v_lide_mone_codi,
           gen_user,
           sysdate,
           v_lide_base,
           v_lide_ulti_porc_aume);
      
      elsif i_indi = 'U' then
      
        update come_list_prec_conc_deta
           set lide_list_codi           = v_lide_list_codi,
               lide_conc_codi           = v_lide_conc_codi,
               lide_prec                = v_lide_prec,
               lide_vige                = v_lide_vige,
               lide_indi_vali_prec_mini = v_lide_indi_vali_prec_mini,
               lide_maxi_porc_deto      = v_lide_maxi_porc_deto,
               lide_prec_segu           = v_lide_prec_segu,
               lide_mone_codi           = v_lide_mone_codi,
               lide_user_modi           = gen_user,
               lide_fech_modi           = sysdate,
               lide_base                = v_lide_base,
               lide_ulti_porc_aume      = v_lide_ulti_porc_aume
         where lide_list_codi = v_lide_list_codi
           and lide_conc_codi = v_lide_conc_codi;
           
      elsif i_indi = 'D' then 
        
        delete come_list_prec_conc_deta
         where lide_list_codi = v_lide_list_codi
           and lide_conc_codi = v_lide_conc_codi;        
      
      end if;
    
    elsif i_tipo = 'P' then
    
      if i_indi = 'N' then
        insert into come_list_prec_deta
          (lide_list_codi,
           lide_prod_codi,
           lide_prec,
           lide_vige,
           lide_indi_vali_prec_mini,
           lide_maxi_porc_deto,
           lide_base,
           lide_prec_segu,
           lide_mone_codi,
           lide_medi_codi,
           lide_user_regi,
           lide_fech_regi,
           lide_ulti_porc_aume,
           lide_indi_copr_ulco,
           lide_prec_ante,
           lide_coba_codi_barr)
        values
          (v_lide_list_codi,
           v_lide_prod_codi,
           v_lide_prec,
           v_lide_vige,
           v_lide_indi_vali_prec_mini,
           v_lide_maxi_porc_deto,
           v_lide_base,
           v_lide_prec_segu,
           v_lide_mone_codi,
           v_lide_medi_codi,
           gen_user,
           sysdate,
           v_lide_ulti_porc_aume,
           v_lide_indi_copr_ulco,
           v_lide_prec_ante,
           v_lide_coba_codi_barr);
      
      elsif i_indi = 'U' then
        update come_list_prec_deta
           set lide_list_codi           = v_lide_list_codi,
               lide_prod_codi           = v_lide_prod_codi,
               lide_prec                = v_lide_prec,
               lide_vige                = v_lide_vige,
               lide_indi_vali_prec_mini = v_lide_indi_vali_prec_mini,
               lide_maxi_porc_deto      = v_lide_maxi_porc_deto,
               lide_base                = v_lide_base,
               lide_prec_segu           = v_lide_prec_segu,
               lide_mone_codi           = v_lide_mone_codi,
               lide_medi_codi           = v_lide_medi_codi,
               lide_user_modi           = gen_user,
               lide_fech_modi           = sysdate,
               lide_ulti_porc_aume      = v_lide_ulti_porc_aume,
               lide_indi_copr_ulco      = v_lide_indi_copr_ulco,
               lide_prec_ante           = v_lide_prec_ante,
               lide_coba_codi_barr      = v_lide_coba_codi_barr
         where lide_list_codi = v_lide_list_codi
           and lide_prod_codi = v_lide_prod_codi
           and lide_medi_codi = v_lide_medi_codi;
      
      elsif i_indi = 'D' then 
      
        delete come_list_prec_deta
         where lide_list_codi = v_lide_list_codi
           and lide_prod_codi = v_lide_prod_codi
           and lide_medi_codi = v_lide_medi_codi;
        
      
      end if;
    
    end if;
  
  end;

end I010038;
