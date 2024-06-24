
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010144" is

  procedure pp_abm_feriado(v_ind            in varchar2,
                           v_feri_empr_codi in number,
                           v_feri_fech      in date,
                           v_feri_desc      in varchar2,
                           v_feri_cont_anho in varchar2,
                           v_feri_base      in number,
                           v_feri_user_regi in varchar2,
                           v_feri_fech_regi in date) is
  begin
  
    if v_ind = 'I' then
      I010144.pp_validar_fecha(v_feri_fech);
      insert into come_feri
        (feri_empr_codi,
         feri_fech,
         feri_desc,
         feri_cont_anho,
         feri_base,
         feri_user_regi,
         feri_fech_regi)
      values
        (v_feri_empr_codi,
         v_feri_fech,
         v_feri_desc,
         v_feri_cont_anho,
         v_feri_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_feri
         set feri_empr_codi = v_feri_empr_codi,
             feri_desc      = v_feri_desc,
             feri_cont_anho = v_feri_cont_anho,
             feri_base      = v_feri_base,
             feri_user_modi = gen_user,
             feri_fech_modi = sysdate
       where feri_fech = v_feri_fech;
    
    elsif v_ind = 'D' then
    
      delete come_feri where feri_fech = v_feri_fech;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_feriado;

  ---------------------------------------------------------------------------------------------------   

  procedure pp_validar_fecha(v_feri_fech in date) is
    v_count number;
  begin
    select count(*)
      into v_count
      from come_feri
     where feri_fech = v_feri_fech;
    if v_count > 0 then
      raise_application_error(-20010,
                              'El feriado para esta fecha ya fue registrado.!');
    end if;
  end pp_validar_fecha;

end I010144;
