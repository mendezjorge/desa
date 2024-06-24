
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010040" is

  procedure pp_muestra_moneda(p_mone_codi      in number,
                              p_empresa        in number,
                              p_mone_desc      out varchar2,
                              p_mone_desc_abre out varchar2,
                              p_mone_cant_deci out number) is
  
    p_codi_mone_mmee varchar2(1000) := general_skn.fl_busca_parametro('p_codi_mone_mmee');
    p_codi_mone_mmnn varchar2(1000) := general_skn.fl_busca_parametro('p_codi_mone_mmnn');
  begin
    select mone_desc, mone_desc_abre, mone_cant_deci
      into p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi
       and mone_empr_codi = p_empresa;
  
    if p_mone_codi not in (p_codi_mone_mmee, p_codi_mone_mmnn) then
      raise_application_error(-20001,
                              'El codigo de moneda no puede ser distinto a ' ||
                              p_codi_mone_mmee || ' o ' || p_codi_mone_mmnn);
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Moneda Inexistente!');
    when others then
      raise_application_error(-20001, 'Error pp_muestra_moneda' || sqlerrm);
  end pp_muestra_moneda;
  
  
  procedure pp_validar_cliente(p_cpmo_clpr_codi      in number,
                               p_cpmo_limi_cred_mone in number,
                               p_cpmo_tasa_mone      in number,
                               p_prom_dias_atra      out varchar2,
                               p_clpr_cali_clie      out varchar2,
                               p_cpmo_limi_cred_mmnn out number) is
  begin
  
    begin
      select c.clpr_prom_dias_atra, c.clpr_cali_clie
        into p_prom_dias_atra, p_clpr_cali_clie
        from come_clie_prov c
       where c.clpr_codi = p_cpmo_clpr_codi;
    exception
      when others then
        null;
    end;
   -- Raise_application_error(-20001,p_cpmo_limi_cred_mone);
    p_cpmo_limi_cred_mmnn := nvl(p_cpmo_limi_cred_mone, 0) *
                             nvl(p_cpmo_tasa_mone, 0);
                            
    exception when others then
      raise_Application_error(-20001,'pp_validar_cliente '||sqlerrm);
  
  end pp_validar_cliente;

  procedure pp_cargar_saldos(p_clpr_codi      in number,
                             p_cpmo_sald_gs   out number,
                             p_cpmo_sald_usd  out number,
                             p_cpmo_sald_cons out number) is
  begin
    select sum(decode(m.movi_mone_codi, 1, c.cuot_sald_mone, 0)) saldo_gs,
           sum(decode(m.movi_mone_codi, 2, c.cuot_sald_mone, 0)) saldo_usd,
           sum(c.cuot_sald_mmnn) saldo_cons
      into p_cpmo_sald_gs, p_cpmo_sald_usd, p_cpmo_sald_cons
      from come_movi_cuot c, come_movi m, come_clie_prov cp
     where m.movi_clpr_codi = cp.clpr_codi
       and c.cuot_movi_codi = m.movi_codi
       and cp.clpr_codi = p_clpr_codi;
  exception when others then
      raise_Application_error(-20001,'pp_cargar_saldos '||sqlerrm);
  end pp_cargar_saldos;

  procedure pp_cargar_cheq_pend_2(p_clpr_codi      in number,
                                  p_mone_codi      in number,
                                  p_cpmo_saldo     in number,
                                  p_tota_cheq_pend out number,
                                  p_tota_cheq_desc out number,
                                  p_tota_cheq_rech out number,
                                  p_tota_cheq_judi out number,
                                  p_tota_deuda out number) is
  
    cursor c_cheq is
      select cheq_nume,
             cheq_impo_mone,
             cheq_esta,
             decode(cheq_esta,
                    'I',
                    'Pendiente',
                    'R',
                    'Rechazado',
                    'J',
                    'Judicial',
                    'Otros') esta,
             cheq_banc_codi,
             cheq_titu,
             cheq_nume_cuen,
             banc_desc,
             cheq_fech_emis,
             cheq_fech_venc,
             nvl(cheq_sald_mone, cheq_impo_mone) cheq_sald_mone
      
        from come_cheq, come_banc
       where cheq_clpr_codi = p_clpr_codi
         and cheq_mone_codi = p_mone_codi
         and banc_codi = cheq_banc_codi
         and cheq_tipo = 'R'
         and ((cheq_esta = 'R' and nvl(cheq_sald_mone, cheq_impo_mone) > 0) or
             cheq_esta = 'I' or cheq_esta = 'J')
      union
      select cheq_nume,
             cheq_impo_mone,
             cheq_esta,
             decode(cheq_esta, 'D', 'Descontado', 'Otros') esta,
             cheq_banc_codi,
             cheq_titu,
             cheq_nume_cuen,
             banc_desc,
             cheq_fech_emis,
             cheq_fech_venc,
             nvl(cheq_sald_mone, 0) cheq_sald_mone
        from come_cheq, come_banc
       where cheq_clpr_codi = p_clpr_codi
         and cheq_mone_codi = p_mone_codi
         and banc_codi = cheq_banc_codi
         and cheq_esta = 'D'
         and nvl(cheq_indi_desc, 'N') = 'S'
         and cheq_tipo = 'R'
         and cheq_fech_venc + 3 > trunc(sysdate)
       order by 8;
  
    v_cheq_pend      number := 0;
    v_cheq_desc      number := 0;
    v_cheq_rech      number := 0;
    v_cheq_judi      number := 0;
    v_sald_cheq_rech number := 0;
    v_sald_cheq_judi number := 0;
  begin
    --go_block('bcheq');
    --first_record;
  
    for x in c_cheq loop
      if x.cheq_esta = 'D' then
        v_cheq_desc := v_cheq_desc + x.cheq_impo_mone;
      elsif x.cheq_esta = 'R' then
        v_cheq_rech      := v_cheq_rech + x.cheq_impo_mone;
        v_sald_cheq_rech := v_sald_cheq_rech + x.cheq_sald_mone;
      elsif x.cheq_esta = 'J' then
        v_cheq_judi      := v_cheq_judi + x.cheq_impo_mone;
        v_sald_cheq_judi := v_sald_cheq_judi + x.cheq_sald_mone;
      else
        v_cheq_pend := v_cheq_pend + x.cheq_impo_mone;
      end if;
    
    end loop;
  
    p_tota_cheq_pend := v_cheq_pend;
    p_tota_cheq_desc := v_cheq_desc;
    p_tota_cheq_rech := nvl(v_sald_cheq_rech, 0);
    p_tota_cheq_judi := nvl(v_cheq_judi, 0);
    p_tota_deuda:=nvl(p_cpmo_saldo,0) + nvl(p_tota_cheq_pend,0) + nvl(p_tota_cheq_desc,0) + nvl(p_tota_cheq_rech,0)+ nvl(p_tota_cheq_judi,0);
  
  exception when others then
    raise_application_error(-20001,'Error en pp_cargar_cheq_pend_2 '||sqlerrm);
  end pp_cargar_cheq_pend_2;

  procedure pp_validar_datos(p_cpmo_mone_codi      in number,
                             p_clpr_codi           in number,
                             p_cpmo_limi_cred_mone in number,
                             p_cpmo_tasa_mone      in number) is
  begin
    if p_cpmo_mone_codi is null then
      raise_application_error(-20001, 'Debe ingresar el c?digo de moneda');
    end if;
  
    if p_clpr_codi is null then
      raise_application_error(-20001, 'Debe ingresar el Cliente.!');
    end if;
  
    if p_cpmo_limi_cred_mone is null then
      raise_application_error(-20001, 'Debe ingresar el limite de credito');
    end if;
  
    if p_cpmo_limi_cred_mone < 0 then
      raise_application_error(-20001,
                              'El limite de credito debe ser igual o mayor a cero');
    end if;
    if p_cpmo_tasa_mone is null then
      raise_application_error(-20001,
                              'Debe ingresar la cotizacion de la moneda');
    end if;
  
    if p_cpmo_tasa_mone <= 0 then
      raise_application_error(-20001,
                              'Debe ingresar un valor mayor a cero');
    end if;

    
  end pp_validar_datos;
  
  procedure pp_actualizar_registro(p_cpmo_limi_cred_mone in number,
                                   p_cpmo_mone_codi in number,
                                   p_cpmo_tasa_mone in number,
                                   p_cpmo_clpr_codi in number,
                                   p_cpmo_empr_codi in number) is
  begin
    update come_clie_prov_mone
       set cpmo_limi_cred_mone = p_cpmo_limi_cred_mone,
           cpmo_limi_cred_mmnn = round((p_cpmo_limi_cred_mone *
                                       p_cpmo_tasa_mone),
                                       0),
           cpmo_tasa_mone      = p_cpmo_tasa_mone,
           cpmo_user_modi      = gen_user,
           cpmo_fech_modi      = sysdate
     where cpmo_mone_codi = p_cpmo_mone_codi
       and cpmo_clpr_codi = p_cpmo_clpr_codi;
    if sql%rowcount = 0 then
      insert into come_clie_prov_mone
        (cpmo_mone_codi,
         cpmo_clpr_codi,
         cpmo_limi_cred_mone,
         cpmo_limi_cred_mmnn,
         cpmo_tasa_mone,
         cpmo_base,
         cpmo_user_regi,
         cpmo_fech_regi,
         cpmo_empr_codi)
      values
        (p_cpmo_mone_codi,
         p_cpmo_clpr_codi,
         p_cpmo_limi_cred_mone,
         round((p_cpmo_limi_cred_mone *
                                       p_cpmo_tasa_mone),
                                       0),
         p_cpmo_tasa_mone,
         1,
         gen_user,
         sysdate,
         p_cpmo_empr_codi);
    end if;
 

   exception when others then
    raise_application_error(-20001,'Error '||sqlerrm);
  end pp_actualizar_registro;
 
procedure pp_imprimir_reportes(p_cliente in number,
                              p_moneda in number) is
 
  v_parametros   CLOB;
  v_contenedores CLOB;


 begin
   

   V_CONTENEDORES :='p_cod_cliente:p_moneda';
   V_PARAMETROS :=p_cliente||':'||p_moneda;


DELETE FROM COME_PARAMETROS_REPORT  WHERE USUARIO = gen_user;

INSERT INTO COME_PARAMETROS_REPORT
  (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
VALUES
  (V_PARAMETROS,GEN_USER, 'I010040', 'pdf', V_CONTENEDORES);

commit;
 
 end pp_imprimir_reportes;
 
end i010040;
