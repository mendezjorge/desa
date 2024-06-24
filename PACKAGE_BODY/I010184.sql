
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010184" is

  procedure pp_abm_ejer_fisc(v_ind                 in varchar2,
                             v_ejer_codi           in number,
                             v_ejer_desc           in varchar2,
                             v_ejer_fech_inic      in date,
                             v_ejer_fech_fina      in date,
                             v_ejer_gana_cuco_codi in number,
                             v_ejer_perd_cuco_codi in number,
                             v_ejer_gaan_cuco_codi in number,
                             v_ejer_pean_cucu_codi in number,
                             v_ejer_cuco_dife_mmnn in number,
                             v_ejer_cuco_dife_mmee in number,
                             v_ejer_desc_cier_patr in varchar2,
                             v_ejer_desc_cier_resu in varchar2,
                             v_ejer_desc_reap_patr in varchar2,
                             v_ejer_base           in number,
                             v_ejer_asie_aper      in number,
                             v_ejer_asie_cier      in number,
                             v_ejer_empr_codi      in number,
                             v_ejer_codi_alte      in number,
                             v_ejer_user_regi      in varchar2,
                             v_ejer_fech_regi      in date) is
    x_ejer_codi      number;
    x_ejer_codi_alte number;
  begin
  
    if v_ind = 'I' then
      --I010184.pp_valida_fech(p_fech => v_ejer_fech_inic);
      --I010184.pp_valida_fech(p_fech => v_ejer_fech_fina);
      select nvl(max(ejer_codi), 0) + 1, nvl(max(to_number(ejer_codi_alte)), 0) + 1
        into x_ejer_codi, x_ejer_codi_alte
        from come_ejer_fisc;
      insert into come_ejer_fisc
        (ejer_codi,
         ejer_desc,
         ejer_fech_inic,
         ejer_fech_fina,
         ejer_gana_cuco_codi,
         ejer_perd_cuco_codi,
         ejer_gaan_cuco_codi,
         ejer_pean_cucu_codi,
         ejer_cuco_dife_mmnn,
         ejer_cuco_dife_mmee,
         ejer_desc_cier_patr,
         ejer_desc_cier_resu,
         ejer_desc_reap_patr,
         ejer_base,
         ejer_asie_aper,
         ejer_asie_cier,
         ejer_empr_codi,
         ejer_codi_alte,
         ejer_user_regi,
         ejer_fech_regi)
      values
        (x_ejer_codi,
         v_ejer_desc,
         v_ejer_fech_inic,
         v_ejer_fech_fina,
         v_ejer_gana_cuco_codi,
         v_ejer_perd_cuco_codi,
         v_ejer_gaan_cuco_codi,
         v_ejer_pean_cucu_codi,
         v_ejer_cuco_dife_mmnn,
         v_ejer_cuco_dife_mmee,
         v_ejer_desc_cier_patr,
         v_ejer_desc_cier_resu,
         v_ejer_desc_reap_patr,
         v_ejer_base,
         v_ejer_asie_aper,
         v_ejer_asie_cier,
         v_ejer_empr_codi,
         x_ejer_codi_alte,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
      --I010184.pp_valida_fech(p_fech => v_ejer_fech_inic);
      --I010184.pp_valida_fech(p_fech => v_ejer_fech_fina);
      update come_ejer_fisc
         set ejer_desc           = v_ejer_desc,
             ejer_fech_inic      = v_ejer_fech_inic,
             ejer_fech_fina      = v_ejer_fech_fina,
             ejer_gana_cuco_codi = v_ejer_gana_cuco_codi,
             ejer_perd_cuco_codi = v_ejer_perd_cuco_codi,
             ejer_gaan_cuco_codi = v_ejer_gaan_cuco_codi,
             ejer_pean_cucu_codi = v_ejer_pean_cucu_codi,
             ejer_cuco_dife_mmnn = v_ejer_cuco_dife_mmnn,
             ejer_cuco_dife_mmee = v_ejer_cuco_dife_mmee,
             ejer_desc_cier_patr = v_ejer_desc_cier_patr,
             ejer_desc_cier_resu = v_ejer_desc_cier_resu,
             ejer_desc_reap_patr = v_ejer_desc_reap_patr,
             ejer_base           = v_ejer_base,
             ejer_asie_aper      = v_ejer_asie_aper,
             ejer_asie_cier      = v_ejer_asie_cier,
             ejer_empr_codi      = v_ejer_empr_codi,
             ejer_codi_alte      = v_ejer_codi_alte,
             ejer_user_modi      = gen_user,
             ejer_fech_modi      = sysdate
      
       where ejer_codi = v_ejer_codi;
    
    elsif v_ind = 'D' then
    
      delete come_ejer_fisc where ejer_codi = v_ejer_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_ejer_fisc;

  ----------------------------------------------------------------------------------------------

  procedure pp_valida_fech(p_fech in date) is
    p_fech_inic date;
    p_fech_fini date;
  begin
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
    if p_fech not between p_fech_inic and p_fech_fini then
    
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                              to_char(p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end;

end I010184;
