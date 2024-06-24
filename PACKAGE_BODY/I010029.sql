
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010029" is

  procedure pp_validaciones(p_cuen_codi      in number,
                            p_cuen_desc      in varchar2,
                            p_cuen_mone_codi in number,
                            p_cuen_indi_caja_banc in varchar2) is
  begin
    /*if p_cuen_codi is null then
      raise_application_error(-20001,
                              'Debe ingresar el c¿digo de la Cuenta Bancaria');
    end if;*/
  
    if p_cuen_desc is null then
      raise_application_error(-20001,
                              'Debe ingresar la descripci¿n de la Cuenta Bancaria');
    end if;
  
    if p_cuen_mone_codi is null then
      raise_application_error(-20001,
                              'Debe ingresar el Codigo de la Moneda');
    end if;
    
    	if p_cuen_indi_caja_banc = 'B' then
		  raise_application_error(-20001,'Debe ingresar la Cta. Contable para operaciones con cheque');
	  end if;
  
  end pp_validaciones;

  procedure pp_actualiza_user_firm is
  
    v_firm_codi number := 0;
  
  begin
  
    /*go_block('babmc_user');
    first_record;
    loop
      if :babmc_user.s_habilitado <> :babmc_user.s_estado_orig
      and :babmc_user.user_codi is not null then
        if  :babmc_user.s_habilitado = upper('s')  then
          
           pp_genera_codi_firm(v_firm_codi);
            
          insert into come_cuen_banc_firm (firm_codi, firm_cuen_codi, firm_user_codi, firm_user_regi, firm_fech_regi)
                                   values (v_firm_codi, :babmc.cuen_codi, :babmc_user.user_codi, user, sysdate);
        else
    
          delete come_cuen_banc_firm
          where firm_cuen_codi = :babmc.cuen_codi
           and firm_user_codi = :babmc_user.user_codi;
           
        end if;
      end if;
           
    end loop;*/
  
    null;
  
  end;

  procedure pp_actualizar_registro(p_ind_oper                  in varchar2,
                                   p_cuen_codi                 in number,
                                   p_cuen_indi_auto_cheq_firm  in varchar2,
                                   p_cuen_indi_dife_dia_pred   in varchar2,
                                   p_cuen_dife_foch_codi       in varchar2,
                                   p_cuen_empr_codi            in varchar2,
                                   p_cuen_codi_alte            in varchar2,
                                   p_cuen_limi_pres            in varchar2,
                                   p_cuen_limi_cheq_paga_deto  in varchar2,
                                   p_cuen_banc_codi            in number,
                                   p_cuen_nume                 in number,
                                   p_cuen_titu                 varchar2,
                                   p_cuen_sobr                 varchar2,
                                   p_cuen_mone_codi            in number,
                                   p_cuen_sald                 in number,
                                   p_cuen_desc                 varchar2,
                                   p_cuen_foch_codi            in number,
                                   p_cuen_efec_cuco_codi       in number,
                                   p_cuen_cheq_cuco_codi       in number,
                                   p_cuen_cheq_adepo_cuco_codi in number,
                                   p_cuen_cheq_ingr_cuco_codi  in number,
                                   p_cuen_indi_caja_banc       in varchar2,
                                   p_cuen_indi_cier_caja       varchar2) is
  v_cuen_codi number;
  v_cuen_codi_alte number;
  
  begin
  
    pp_validaciones(p_cuen_codi, p_cuen_desc, p_cuen_mone_codi,
    p_cuen_indi_caja_banc);
    --insert
    case p_ind_oper
      when 'I' then
        raise_application_error(-20001,'Codi alte: '||p_cuen_codi_alte);
        
        --Codigo
        select nvl(max(cuen_codi),0)+1
          into v_cuen_codi
	        from come_cuen_banc;
          
        --Codigo alternativo
        select nvl(max(cuen_codi_alte),0)+1
          into v_cuen_codi_alte
	        from come_cuen_banc
         where cuen_empr_codi = fa_empresa;
                              
        insert into come_cuen_banc
          (cuen_codi,
           cuen_banc_codi,
           cuen_nume,
           cuen_titu,
           cuen_sobr,
           cuen_mone_codi,
           cuen_sald,
           cuen_desc,
           cuen_foch_codi,
           cuen_base,
           cuen_efec_cuco_codi,
           cuen_cheq_cuco_codi,
           cuen_cheq_adepo_cuco_codi,
           cuen_cheq_ingr_cuco_codi,
           cuen_indi_caja_banc,
           cuen_indi_cier_caja,
           cuen_user_regi,
           cuen_fech_regi,
           cuen_indi_dife_dia_pred,
           cuen_dife_foch_codi,
           cuen_empr_codi,
           cuen_codi_alte,
           cuen_limi_pres,
           cuen_limi_cheq_paga_deto,
           cuen_indi_auto_cheq_firm)
        values
          (v_cuen_codi,--p_cuen_codi,
           p_cuen_banc_codi,
           p_cuen_nume,
           p_cuen_titu,
           p_cuen_sobr,
           p_cuen_mone_codi,
           p_cuen_sald,
           p_cuen_desc,
           p_cuen_foch_codi,
           1,
           p_cuen_efec_cuco_codi,
           p_cuen_cheq_cuco_codi,
           p_cuen_cheq_adepo_cuco_codi,
           p_cuen_cheq_ingr_cuco_codi,
           p_cuen_indi_caja_banc,
           p_cuen_indi_cier_caja,
           fa_user,
           sysdate,
           p_cuen_indi_dife_dia_pred,
           p_cuen_dife_foch_codi,
           p_cuen_empr_codi,
           v_cuen_codi_alte,--p_cuen_codi_alte,
           p_cuen_limi_pres,
           p_cuen_limi_cheq_paga_deto,
           p_cuen_indi_auto_cheq_firm);
      when 'U' then
        update come_cuen_banc
           set cuen_banc_codi            = p_cuen_banc_codi,
               cuen_nume                 = p_cuen_nume,
               cuen_titu                 = p_cuen_titu,
               cuen_sobr                 = p_cuen_sobr,
               cuen_mone_codi            = p_cuen_mone_codi,
               cuen_sald                 = p_cuen_sald,
               cuen_desc                 = p_cuen_desc,
               cuen_foch_codi            = p_cuen_foch_codi,
               cuen_efec_cuco_codi       = p_cuen_efec_cuco_codi,
               cuen_cheq_cuco_codi       = p_cuen_cheq_cuco_codi,
               cuen_cheq_adepo_cuco_codi = p_cuen_cheq_adepo_cuco_codi,
               cuen_cheq_ingr_cuco_codi  = p_cuen_cheq_ingr_cuco_codi,
               cuen_indi_caja_banc       = p_cuen_indi_caja_banc,
               cuen_indi_cier_caja       = p_cuen_indi_cier_caja,
               cuen_user_modi            = fa_user,
               cuen_fech_modi            = sysdate,
               cuen_indi_dife_dia_pred   = p_cuen_indi_dife_dia_pred,
               cuen_dife_foch_codi       = p_cuen_dife_foch_codi,
               cuen_empr_codi            = p_cuen_empr_codi,
               cuen_codi_alte            = p_cuen_codi_alte,
               cuen_limi_pres            = p_cuen_limi_pres,
               cuen_limi_cheq_paga_deto  = p_cuen_limi_cheq_paga_deto,
               cuen_indi_auto_cheq_firm  = p_cuen_indi_auto_cheq_firm
         where cuen_codi = p_cuen_codi;
      
      when 'D' then
        delete come_cuen_banc where cuen_codi = p_cuen_codi;
      
    end case;
  
  end pp_actualizar_registro;

end I010029;
