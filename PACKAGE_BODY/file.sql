
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010268" is

  procedure pp_actualiza_registro(p_indi             in varchar2,
                                  p_tico_codi           in come_tipo_comp.tico_codi%type,
                                  p_tico_desc           in come_tipo_comp.tico_desc%type,
                                  p_tico_indi_vali_nume in come_tipo_comp.tico_indi_vali_nume%type,
                                  p_tico_indi_habi_timb in come_tipo_comp.tico_indi_habi_timb%type,
                                  p_tico_indi_vali_timb in come_tipo_comp.tico_indi_vali_timb%type,
                                  p_tico_indi_timb_auto in come_tipo_comp.tico_indi_timb_auto%type,
                                  p_tico_codi_form_hchk in come_tipo_comp.tico_codi_form_hchk%type,
                                  p_tico_tipo_docu_hchk in come_tipo_comp.tico_tipo_docu_hchk%type,
                                  p_tico_indi_timb      in come_tipo_comp.tico_indi_timb%type) as
  begin
    
    if p_indi = 'N' then
      
      insert into come_tipo_comp
        (tico_codi,
         tico_desc,
         tico_indi_vali_nume,
         tico_indi_habi_timb,
         tico_indi_vali_timb,
         tico_indi_timb_auto,
         tico_codi_form_hchk,
         tico_tipo_docu_hchk,
         tico_indi_timb,
         tico_user_regi,
         tico_fech_regi)
      values
        (p_tico_codi,
         p_tico_desc,
         p_tico_indi_vali_nume,
         p_tico_indi_habi_timb,
         p_tico_indi_vali_timb,
         p_tico_indi_timb_auto,
         p_tico_codi_form_hchk,
         p_tico_tipo_docu_hchk,
         p_tico_indi_timb,
         gen_user,
         sysdate);
         
    elsif p_indi = 'U' then
      
      update come_tipo_comp
         set tico_desc           = p_tico_desc,
             tico_indi_vali_nume = p_tico_indi_vali_nume,
             tico_indi_habi_timb = p_tico_indi_habi_timb,
             tico_indi_vali_timb = p_tico_indi_vali_timb,
             tico_indi_timb_auto = p_tico_indi_timb_auto,
             tico_codi_form_hchk = p_tico_codi_form_hchk,
             tico_tipo_docu_hchk = p_tico_tipo_docu_hchk,
             tico_indi_timb      = p_tico_indi_timb,
             tico_user_modi      = gen_user,
             tico_fech_modi      = sysdate
       where tico_codi = p_tico_codi;
       
    elsif p_indi = 'D' then
      
      delete from come_tipo_comp where tico_codi = p_tico_codi;
      
    else
      RAISE_APPLICATION_ERROR(-20001, 'Tipo de operación no válido');
    end if;
    
    commit;
    
  exception
    when others then
      rollback;
      raise;
  end;


procedure pp_genera_codigo(o_Tico_codi out number) is
begin

select NVL(max(tico_codi), 0) + 1 into o_Tico_codi from come_tipo_comp;

end;

end I010268;
