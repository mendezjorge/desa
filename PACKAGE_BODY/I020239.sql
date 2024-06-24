
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020239" is

  type t_cab is record(
    anul_codi      come_cheq_anul.anul_codi%type,
    anul_empr_codi come_cheq_anul.anul_empr_codi%type,
    anul_sucu_codi come_cheq_anul.anul_sucu_codi%type,
    anul_mone_codi come_cheq_anul.anul_mone_codi%type,
    anul_banc_codi come_cheq_anul.anul_banc_codi%type,
    anul_nume      come_cheq_anul.anul_nume%type,
    anul_serie     come_cheq_anul.anul_serie%type,
    anul_fech_emis come_cheq_anul.anul_fech_emis%type,
    anul_nume_cuen come_cheq_anul.anul_nume_cuen%type,
    anul_cuen_codi come_cheq_anul.anul_cuen_codi%type,
    anul_moti_anul come_cheq_anul.anul_moti_anul%type,
    anul_user_regi come_cheq_anul.anul_user_regi%type,
    anul_fech_regi come_cheq_anul.anul_fech_regi%type,
    anul_user_modi come_cheq_anul.anul_user_modi%type,
    anul_fech_modi come_cheq_anul.anul_fech_modi%type,
    anul_base      come_cheq_anul.anul_base%type);

  bcab t_cab;

  procedure pp_set_variable is
  begin
  
    bcab.anul_codi      := v('P84_ANUL_CODI');
    bcab.anul_empr_codi := v('AI_EMPR_CODI');
    bcab.anul_sucu_codi := v('P84_ANUL_SUCU_CODI');
    bcab.anul_mone_codi := v('P84_ANUL_MONE_CODI');
    bcab.anul_banc_codi := v('P84_ANUL_BANC_CODI');
    bcab.anul_nume      := v('P84_ANUL_NUME');
    bcab.anul_serie     := v('P84_ANUL_SERIE');
    bcab.anul_fech_emis := v('P84_ANUL_FECH_EMIS');
    bcab.anul_nume_cuen := v('P84_ANUL_NUME_CUEN');
    bcab.anul_cuen_codi := v('P84_ANUL_CUEN_CODI');
    bcab.anul_moti_anul := v('P84_ANUL_MOTI_ANUL');
    bcab.anul_base      := pack_repl.fa_devu_codi_base;
  
  end;

  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010,
                            dbms_utility.format_error_backtrace || ' ' ||
                            v_mensaje);
  end pl_me;

  procedure pp_mostrar_cuen_banc(p_cuen_codi in number,
                                 p_cuen_desc out varchar2,
                                 p_cuen_nume out varchar2,
                                 p_banc_codi out number,
                                 p_banc_desc out varchar2,
                                 p_mone_codi out number,
                                 p_mone_desc out varchar2) is
  begin
    select c.cuen_desc,
           c.cuen_nume,
           b.banc_codi,
           b.banc_desc,
           m.mone_codi,
           m.mone_desc
      into p_cuen_desc,
           p_cuen_nume,
           p_banc_codi,
           p_banc_desc,
           p_mone_codi,
           p_mone_desc
      from come_cuen_banc c, come_banc b, come_mone m
     where c.cuen_banc_codi = b.banc_codi(+)
       and c.cuen_mone_codi = m.mone_codi(+)
       and nvl(c.cuen_indi_caja_banc, 'B') = 'B'
       and c.cuen_codi = p_cuen_codi;
  
  exception
    when no_data_found then
      pl_me('Cuenta inexistente o no es un banco');
    when others then
      pl_me(sqlerrm);
  end;
  procedure pp_validar_nro is
    v_count number;
  begin
    select count(*)
      into v_count
      from come_cheq c
     where nvl(c.cheq_tipo, 'E') = 'E'
       and c.cheq_serie = bcab.anul_serie
       and c.cheq_nume = bcab.anul_nume
       and c.cheq_cuen_codi = bcab.anul_cuen_codi;
  
    if v_count > 0 then
      pl_me('Ya existe un cheque vigente en el sistema con esta serie, numero y cuenta, favor verifique!!');
    end if;
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_actualizar_registros(p_tipo_operacion in varchar2) is
  
  begin
  
    pp_set_variable;
  
    if p_tipo_operacion = 'I' then
      -- Insertar
      insert into come_cheq_anul
        (anul_codi,
         anul_empr_codi,
         anul_sucu_codi,
         anul_mone_codi,
         anul_banc_codi,
         anul_nume,
         anul_serie,
         anul_fech_emis,
         anul_nume_cuen,
         anul_cuen_codi,
         anul_moti_anul,
         anul_user_regi,
         anul_fech_regi,
         anul_base)
      values
        (bcab.anul_codi,
         bcab.anul_empr_codi,
         bcab.anul_sucu_codi,
         bcab.anul_mone_codi,
         bcab.anul_banc_codi,
         bcab.anul_nume,
         bcab.anul_serie,
         bcab.anul_fech_emis,
         bcab.anul_nume_cuen,
         bcab.anul_cuen_codi,
         bcab.anul_moti_anul,
         gen_user,
         sysdate,
         bcab.anul_base);
    
    elsif p_tipo_operacion = 'U' then
      -- Actualizar
      update come_cheq_anul
         set anul_empr_codi = bcab.anul_empr_codi,
             anul_sucu_codi = bcab.anul_sucu_codi,
             anul_mone_codi = bcab.anul_mone_codi,
             anul_banc_codi = bcab.anul_banc_codi,
             anul_nume      = bcab.anul_nume,
             anul_serie     = bcab.anul_serie,
             anul_fech_emis = bcab.anul_fech_emis,
             anul_nume_cuen = bcab.anul_nume_cuen,
             anul_cuen_codi = bcab.anul_cuen_codi,
             anul_moti_anul = bcab.anul_moti_anul,
             anul_user_modi = gen_user,
             anul_fech_modi = sysdate,
             anul_base      = bcab.anul_base
       where anul_codi = bcab.anul_codi;
    
    elsif p_tipo_operacion = 'D' then
      -- Eliminar
      delete from come_cheq_anul where anul_codi = bcab.anul_codi;
    
    else
      -- Operación no válida
      pl_me('Tipo de operación no válido: ' || p_tipo_operacion);
    end if;
  
  end;
end I020239;
