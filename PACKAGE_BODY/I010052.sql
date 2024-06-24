
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010052" is

  type r_parameter is record(
    
    p_codi_base  number := pack_repl.fa_devu_codi_base,
    p_orden_codi varchar2(60) := 'desc',
    p_orden_desc varchar2(60) := 'asc',
    p_empr_codi  number := v('AI_EMPR_CODI'));

  parameter r_parameter;

  procedure pp_abm_talo_cheq_emit(v_ind            in varchar2,
                                  v_tach_empr_codi in number,
                                  v_tach_codi      in number,
                                  v_tach_codi_alte in number,
                                  v_tach_cuen_codi in number,
                                  v_tach_cheq_desd in number,
                                  v_tach_cheq_hast in number,
                                  v_tach_cant      in number,
                                  v_tach_seri      in varchar2,
                                  v_tach_ulti_nume in number,
                                  v_tach_esta      in varchar2,
                                  v_tach_tipo_cheq in varchar2,
                                  v_tach_cheq_libr in number,
                                  v_tach_base      in number,
                                  v_tach_user_regi in varchar2,
                                  v_tach_fech_regi in date) is
  
  begin
  
    null;
  
  end pp_abm_talo_cheq_emit;

  ------------------------------------------------------------------------------------------

  procedure pp_actualizar_registro(i_ind                 in varchar2,
                                   i_tach_empr_codi      in number,
                                   i_tach_codi           in number,
                                   i_tach_codi_alte      in number,
                                   i_tach_cuen_codi      in number,
                                   i_tach_cheq_desd      in number,
                                   i_tach_cheq_hast      in number,
                                   i_tach_cant           in number,
                                   i_tach_seri           in varchar2,
                                   i_tach_ulti_nume      in number,
                                   i_tach_esta           in varchar2,
                                   i_tach_tipo_cheq      in varchar2,
                                   i_tach_cheq_libr      in number,
                                   i_tach_base           in number,
                                   i_tach_user_regi      in varchar2,
                                   i_tach_fech_regi      in date,
                                   i_tach_cuen_codi_alte in number,
                                   i_banc_codi           in number) is
    v_tach_base number;
    
  begin
  
    v_tach_base := parameter.p_codi_base;
  
    pp_validar_ulti_nume(i_tach_ulti_nume,
                         i_tach_cheq_desd,
                         i_tach_cheq_hast);
  
    if i_tach_cuen_codi_alte is not null then
      if i_banc_codi is null then
        raise_application_error(-20010,'Debe seleccionar una cuenta bancaria relacionada a un banco');
      end if;
    else
      raise_application_error(-20010,'Debe especificar la cuenta bancaria');
    end if;
  
    if i_tach_cheq_desd is null then
      raise_application_error(-20010,'Debe ingresar el primer cheque del talonario');
    end if;
  
    if i_tach_cheq_hast is null then
      raise_application_error(-20010,'Debe ingresar el ultimo cheque del talonario');
    end if;
  
    if i_tach_seri is null then
      raise_application_error(-20010,'Debe ingresar la serie del talonario');
    end if;
  
    if i_tach_ulti_nume is null then
      raise_application_error(-20010,'Debe ingresar el Ultimo numero de cheque ingresado');
    end if;
  
    if i_ind = 'I' then
    
      insert into come_talo_cheq
        (tach_empr_codi,
         tach_codi,
         tach_codi_alte,
         tach_cuen_codi,
         tach_cheq_desd,
         tach_cheq_hast,
         tach_cant,
         tach_seri,
         tach_ulti_nume,
         tach_esta,
         tach_tipo_cheq,
         tach_cheq_libr,
         tach_base,
         tach_user_regi,
         tach_fech_regi)
      values
        (i_tach_empr_codi,
         i_tach_codi,
         i_tach_codi_alte,
         i_tach_cuen_codi,
         i_tach_cheq_desd,
         i_tach_cheq_hast,
         i_tach_cant,
         i_tach_seri,
         i_tach_ulti_nume,
         i_tach_esta,
         i_tach_tipo_cheq,
         i_tach_cheq_libr,
         v_tach_base,
         gen_user,
         sysdate);
    
    elsif i_ind = 'U' then
    
      update come_talo_cheq
         set tach_empr_codi = i_tach_empr_codi,
             tach_codi_alte = i_tach_codi_alte,
             tach_cuen_codi = i_tach_cuen_codi,
             tach_cheq_desd = i_tach_cheq_desd,
             tach_cheq_hast = i_tach_cheq_hast,
             tach_cant      = i_tach_cant,
             tach_seri      = i_tach_seri,
             tach_ulti_nume = i_tach_ulti_nume,
             tach_esta      = i_tach_esta,
             tach_tipo_cheq = i_tach_tipo_cheq,
             tach_cheq_libr = i_tach_cheq_libr,
             tach_base      = v_tach_base,
             tach_user_modi = gen_user,
             tach_fech_modi = sysdate
       where tach_codi = i_tach_codi;
    end if;
  
  end pp_actualizar_registro;
  
  ------------------------------------------------------------------------------------------

  procedure pp_validar_ulti_nume(i_tach_ulti_nume in number,
                                 i_tach_cheq_desd in number,
                                 i_tach_cheq_hast in number) is
  begin
  
    if i_tach_ulti_nume not between (i_tach_cheq_desd - 1) and
       i_tach_cheq_hast then
      raise_application_error(-20010,
                              'El ultimo numero no corresponde al talonario');
    end if;
  
  end pp_validar_ulti_nume;

  ------------------------------------------------------------------------------------------
  
  procedure pp_borrar_registro(i_tach_codi in number) is
  
  begin
  
    update come_talo_cheq
       set tach_base = parameter.p_codi_base
     where tach_codi = i_tach_codi;
    pp_validar_borrado(i_tach_codi);
  
    delete come_talo_cheq where tach_codi = i_tach_codi;
  
  end pp_borrar_registro;

  ------------------------------------------------------------------------------------------
  
  procedure pp_validar_borrado(i_tach_codi in number) is
    v_count number;
  
  begin
    select count(*)
      into v_count
      from come_cheq
     where cheq_tach_codi = i_tach_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,'Existen' || '  ' || v_count || ' ' || 'cheques emitidos de esta chequera, no puede ser eliminada');
    end if;
  
  end pp_validar_borrado;
  
  ------------------------------------------------------------------------------------------

  procedure pp_muestra_come_cuen_banc(p_cuen_codi      in number,
                                      p_banc_codi      out number,
                                      p_cuen_nume      out char,
                                      p_cuen_codi_alte out char) is
  begin
    select banc_codi, cuen_nume, cuen_codi_alte
      into p_banc_codi, p_cuen_nume, p_cuen_codi_alte
      from come_cuen_banc, come_banc
     where cuen_banc_codi = banc_codi(+)
       and cuen_codi = p_cuen_codi
       and cuen_empr_codi = parameter.p_empr_codi;
  
  Exception
    when no_data_found then
      raise_application_error(-20010, 'Cuenta Bancaria Inexistente');
    
  end pp_muestra_come_cuen_banc;

end I010052;
