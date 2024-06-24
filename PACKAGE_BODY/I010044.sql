
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010044" is

  procedure PP_GENERA_CODI_ALTE(o_situ_codi_alte out number,
                                o_situ_codi      out number) is
  begin
    select NVL(max(to_number(situ_codi)), 0) + 1,
           NVL(max(to_number(situ_codi_alte)), 0) + 1
      into o_situ_codi, o_situ_codi_alte
      from come_situ_clie
     where situ_empr_codi = V('AI_EMPR_CODI');
  
  exception
    when others then
      null;
    
  end;

  procedure pp_actualizar_registro(p_indi                in varchar2,
                                   p_situ_codi           in come_situ_clie.situ_codi%type,
                                   p_situ_codi_alte      in come_situ_clie.situ_codi_alte%type,
                                   p_situ_desc           in come_situ_clie.situ_desc%type,
                                   p_situ_dias_atra_desd in come_situ_clie.situ_dias_atra_desd%type,
                                   p_situ_dias_atra_hast in come_situ_clie.situ_dias_atra_hast%type,
                                   p_situ_clsi_codi      in come_situ_clie.situ_clsi_codi%type,
                                   p_situ_nume_orde      in come_situ_clie.situ_nume_orde%type,
                                   p_situ_colo           in come_situ_clie.situ_colo%type,
                                   p_situ_indi_auma      in come_situ_clie.situ_indi_auma%type,
                                   p_situ_indi_fact      in come_situ_clie.situ_indi_fact%type,
                                   p_situ_indi_segu_cobr in come_situ_clie.situ_indi_segu_cobr%type,
                                   p_situ_empr_codi      in come_situ_clie.situ_empr_codi%type,
                                   p_situ_dpto_recl      in come_situ_clie.situ_dpto_recl%type) as
  begin
  
    -- ALTA
    if p_indi = 'N' then
      insert into come_situ_clie
        (situ_codi_alte,
         situ_codi,
         situ_desc,
         situ_dias_atra_desd,
         situ_dias_atra_hast,
         situ_clsi_codi,
         situ_nume_orde,
         situ_colo,
         situ_indi_auma,
         situ_indi_fact,
         situ_indi_segu_cobr,
         situ_user_regi,
         situ_fech_regi,
         situ_empr_codi,
         situ_dpto_recl)
      values
        (p_situ_codi_alte,
         p_situ_codi,
         p_situ_desc,
         p_situ_dias_atra_desd,
         p_situ_dias_atra_hast,
         p_situ_clsi_codi,
         p_situ_nume_orde,
         p_situ_colo,
         p_situ_indi_auma,
         p_situ_indi_fact,
         p_situ_indi_segu_cobr,
         gen_user,
         sysdate,
         p_situ_empr_codi,
         p_situ_dpto_recl);
    
    elsif p_indi = 'D' then
      -- BAJA
      delete from come_situ_clie where situ_codi = p_situ_codi;
    elsif p_indi = 'U' then
      -- MODIFICACION
      update come_situ_clie
         set situ_desc           = p_situ_desc,
             situ_dias_atra_desd = p_situ_dias_atra_desd,
             situ_dias_atra_hast = p_situ_dias_atra_hast,
             situ_clsi_codi      = p_situ_clsi_codi,
             situ_nume_orde      = p_situ_nume_orde,
             situ_colo           = p_situ_colo,
             situ_indi_auma      = p_situ_indi_auma,
             situ_indi_fact      = p_situ_indi_fact,
             situ_indi_segu_cobr = p_situ_indi_segu_cobr,
             situ_user_modi      = gen_user,
             situ_fech_modi      = sysdate,
             situ_dpto_recl      =p_situ_dpto_recl
       where situ_codi = p_situ_codi;
    
    end if;
  
  exception
    when NO_DATA_FOUND then
      -- Codigo para manejar el error de que no se encontro ningun registro con el ID especificado
     raise_application_error(-20010, 'No se encontro ningun registro con el ID especificado');
      rollback;
  end;

end I010044;
