
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010188" is

  procedure pp_abm_desp(v_ind            in varchar2,
                        v_desp_codi      in number,
                        v_desp_desc      in varchar2,
                        v_desp_tele      in varchar2,
                        v_desp_pers_cont in varchar2,
                        v_desp_dire      in varchar2,
                        v_desp_base      in number,
                        v_desp_empr_codi in number,
                        v_desp_codi_alte in number,
                        v_desp_user_regi in varchar2,
                        v_desp_fech_regi in date) is
    x_desp_codi      number;
    x_desp_codi_alte number;
  begin
  
    if v_ind = 'I' then
      select nvl(max(desp_codi), 0) + 1, nvl(max(desp_codi_alte), 0) + 1
        into x_desp_codi, x_desp_codi_alte
        from come_desp;
      insert into come_desp
        (desp_codi,
         desp_desc,
         desp_tele,
         desp_pers_cont,
         desp_dire,
         desp_base,
         desp_empr_codi,
         desp_codi_alte,
         desp_user_regi,
         desp_fech_regi)
      values
        (x_desp_codi,
         v_desp_desc,
         v_desp_tele,
         v_desp_pers_cont,
         v_desp_dire,
         v_desp_base,
         v_desp_empr_codi,
         x_desp_codi_alte,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_desp
         set desp_desc      = v_desp_desc,
             desp_tele      = v_desp_tele,
             desp_pers_cont = v_desp_pers_cont,
             desp_dire      = v_desp_dire,
             desp_base      = v_desp_base,
             desp_empr_codi = v_desp_empr_codi,
             desp_codi_alte = v_desp_codi_alte,
             desp_user_modi = gen_user,
             desp_fech_modi = sysdate
       where desp_codi = v_desp_codi;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_desp;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_desp_codi in number) is
  begin
  
    I010188.pp_validar_borrado(v_desp_codi);
    delete come_desp where desp_codi = v_desp_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_desp_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_desp_impo
     where deim_desp_codi = v_desp_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'registro/s que tienen asignados despacho. primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

end I010188;
