
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010189" is

  procedure pp_abm_desp_impo(v_ind                 in varchar2,
                             v_deim_codi           in number,
                             v_deim_desp_codi      in number,
                             v_deim_movi_codi      in number,
                             v_deim_nume           in number,
                             v_deim_tipo           in varchar2,
                             v_deim_depo_codi      in number,
                             v_deim_fech_ingr_stoc in date,
                             v_deim_tasa_mmee      in number,
                             v_deim_base           in number,
                             v_deim_obse           in varchar2,
                             v_deim_user           in varchar2,
                             v_deim_fech_grab      in date,
                             v_deim_indi_iva_incl  in varchar2,
                             v_deim_empr_codi      in number,
                             v_deim_codi_alte      in number,
                             v_deim_user_regi      in varchar2,
                             v_deim_fech_regi      in date) is
    x_deim_nume number;
    x_deim_codi number;
    x_deim_codi_alte number;
    
  begin
    if v_ind = 'I' then
      select nvl(max(deim_nume), 0) + 1
        into x_deim_nume
        from come_desp_impo;
      x_deim_codi := fa_sec_come_desp_impo;
      x_deim_codi_alte := x_deim_codi;
      insert into come_desp_impo
        (deim_codi,
         deim_desp_codi,
         deim_movi_codi,
         deim_nume,
         deim_tipo,
         deim_depo_codi,
         deim_fech_ingr_stoc,
         deim_tasa_mmee,
         deim_base,
         deim_obse,
         deim_user,
         deim_fech_grab,
         deim_indi_iva_incl,
         deim_empr_codi,
         deim_codi_alte,
         deim_user_regi,
         deim_fech_regi)
      values
        (x_deim_codi,
         v_deim_desp_codi,
         v_deim_movi_codi,
         x_deim_nume,
         v_deim_tipo,
         v_deim_depo_codi,
         v_deim_fech_ingr_stoc,
         v_deim_tasa_mmee,
         v_deim_base,
         v_deim_obse,
         v_deim_user,
         v_deim_fech_grab,
         v_deim_indi_iva_incl,
         v_deim_empr_codi,
         x_deim_codi_alte,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_desp_impo
         set deim_desp_codi = v_deim_desp_codi,
             deim_movi_codi = v_deim_movi_codi,
             deim_nume      = v_deim_nume,
             deim_tipo      = v_deim_tipo,
             deim_depo_codi = v_deim_depo_codi,
             deim_fech_ingr_stoc = v_deim_fech_ingr_stoc,
             deim_tasa_mmee = v_deim_tasa_mmee,
             deim_base      = v_deim_base,
             deim_obse      = v_deim_obse,
             deim_user      = gen_user,
             deim_fech_grab = sysdate,
             deim_indi_iva_incl = v_deim_indi_iva_incl,
             deim_empr_codi = v_deim_empr_codi,
             deim_codi_alte = v_deim_codi_alte,
             deim_user_modi = gen_user,
             deim_fech_modi = sysdate
       where deim_codi = v_deim_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_desp_impo;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_deim_codi in number) is
  begin
  
    I010189.pp_validar_borrado(v_deim_codi);
    delete come_desp_impo where deim_codi = v_deim_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_deim_codi in number) is
    v_count number(4);
  begin
    --validar que el despacho posea importaciones  
    select count(*)
      into v_count
      from come_impo
     where impo_deim_codi = v_deim_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'No se puede eliminar el despacho porque posee importaciones asociadas');
    end if;
  
  end pp_validar_borrado;

end I010189;
