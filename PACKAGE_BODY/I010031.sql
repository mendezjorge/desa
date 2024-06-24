
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010031" is

  procedure pl_muestra_come_stoc_oper(p_oper_codi      in number,
                                      p_oper_desc      out char,
                                      p_oper_desc_abre out char,
                                      p_suma_rest      out char,
                                      p_afec_cost_prom out char) is
  begin
  
    select oper_desc,
           oper_desc_abre,
           oper_stoc_suma_rest,
           oper_stoc_afec_cost_prom
      into p_oper_desc, p_oper_desc_abre, p_suma_rest, p_afec_cost_prom
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  
  exception
    when no_data_found then
      p_oper_desc_abre := null;
      p_oper_desc      := null;
      p_suma_rest      := null;
      p_afec_cost_prom := null;
      raise_application_error(-20010, 'Operacion de Stock Inexistente!');
    when others then
      raise_application_error(-20010,
                              ' Error al momento de mostra operador stock');
  end;

  procedure pp_actualizar_registro(p_indi                     in varchar2,
                                   p_timo_codi                come_tipo_movi.timo_codi%type,
                                   p_timo_codi_oper           come_tipo_movi.timo_codi_oper%type,
                                   p_timo_desc                come_tipo_movi.timo_desc%type,
                                   p_timo_afec_sald           come_tipo_movi.timo_afec_sald%type,
                                   p_timo_dbcr                come_tipo_movi.timo_dbcr%type,
                                   p_timo_emit_reci           come_tipo_movi.timo_emit_reci%type,
                                   p_timo_calc_iva            come_tipo_movi.timo_calc_iva%type,
                                   p_timo_suma_rest_clpr      come_tipo_movi.timo_suma_rest_clpr%type,
                                   p_timo_desc_abre           come_tipo_movi.timo_desc_abre%type,
                                   p_timo_indi_libr_iva       come_tipo_movi.timo_indi_libr_iva%type,
                                   p_timo_ingr_dbcr_vari      come_tipo_movi.timo_ingr_dbcr_vari%type,
                                   p_timo_ingr_cheq_dbcr_vari come_tipo_movi.timo_ingr_cheq_dbcr_vari%type,
                                   p_timo_indi_adel           come_tipo_movi.timo_indi_adel%type,
                                   p_timo_indi_ncr            come_tipo_movi.timo_indi_ncr%type,
                                   p_timo_indi_sald           come_tipo_movi.timo_indi_sald%type,
                                   p_timo_indi_caja           come_tipo_movi.timo_indi_caja%type,
                                   p_timo_dbcr_caja           come_tipo_movi.timo_dbcr_caja%type,
                                   p_timo_base                come_tipo_movi.timo_base%type,
                                   p_timo_tica_codi           come_tipo_movi.timo_tica_codi%type,
                                   p_timo_indi_reci_canc      come_tipo_movi.timo_indi_reci_canc%type,
                                   p_timo_indi_excl_sald_clpr come_tipo_movi.timo_indi_excl_sald_clpr%type,
                                   p_timo_tico_codi           come_tipo_movi.timo_tico_codi%type,
                                   p_timo_indi_apli_adel_fopa come_tipo_movi.timo_indi_apli_adel_fopa%type,
                                   p_timo_codi_alte           come_tipo_movi.timo_codi_alte%type,
                                   p_timo_empr_codi           come_tipo_movi.timo_empr_codi%type,
                                   p_timo_indi_clpr           come_tipo_movi.timo_indi_clpr%type,
                                   p_timo_indi_deud_canc      come_tipo_movi.timo_indi_deud_canc%type,
                                   p_timo_dbcr_vale           come_tipo_movi.timo_dbcr_vale%type,
                                   p_timo_indi_cont_cred      come_tipo_movi.timo_indi_cont_cred%type,
                                   p_timo_indi_re90_iva       come_tipo_movi.timo_indi_re90_iva%type,
                                   p_timo_re90_codi           come_tipo_movi.timo_re90_codi%type,
                                   p_timo_re90_tipo           come_tipo_movi.timo_re90_tipo%type,
                                   p_timo_indi_re90_ire       come_tipo_movi.timo_indi_re90_ire%type,
                                   p_timo_indi_re90_irp_rsp   come_tipo_movi.timo_indi_re90_irp_rsp%type,
                                   p_timo_tipd_cod            come_tipo_movi.timo_tipd_cod%type) is
  begin
  
    if p_indi = 'U' then
    
      update come_tipo_movi
         set timo_codi_oper           = p_timo_codi_oper,
             timo_desc                = p_timo_desc,
             timo_afec_sald           = p_timo_afec_sald,
             timo_dbcr                = p_timo_dbcr,
             timo_emit_reci           = p_timo_emit_reci,
             timo_calc_iva            = p_timo_calc_iva,
             timo_suma_rest_clpr      = p_timo_suma_rest_clpr,
             timo_desc_abre           = p_timo_desc_abre,
             timo_indi_libr_iva       = p_timo_indi_libr_iva,
             timo_ingr_dbcr_vari      = p_timo_ingr_dbcr_vari,
             timo_ingr_cheq_dbcr_vari = p_timo_ingr_cheq_dbcr_vari,
             timo_indi_adel           = p_timo_indi_adel,
             timo_indi_ncr            = p_timo_indi_ncr,
             timo_indi_sald           = p_timo_indi_sald,
             timo_indi_caja           = p_timo_indi_caja,
             timo_dbcr_caja           = p_timo_dbcr_caja,
             timo_base                = p_timo_base,
             timo_tica_codi           = p_timo_tica_codi,
             timo_indi_reci_canc      = p_timo_indi_reci_canc,
             timo_indi_excl_sald_clpr = p_timo_indi_excl_sald_clpr,
             timo_tico_codi           = p_timo_tico_codi,
             timo_user_modi           = gen_user,
             timo_fech_modi           = sysdate,
             timo_indi_apli_adel_fopa = p_timo_indi_apli_adel_fopa,
             timo_codi_alte           = p_timo_codi_alte,
             timo_empr_codi           = p_timo_empr_codi,
             timo_indi_clpr           = p_timo_indi_clpr,
             timo_indi_deud_canc      = p_timo_indi_deud_canc,
             timo_dbcr_vale           = p_timo_dbcr_vale,
             timo_indi_cont_cred      = p_timo_indi_cont_cred,
             timo_indi_re90_iva       = p_timo_indi_re90_iva,
             timo_re90_codi           = p_timo_re90_codi,
             timo_re90_tipo           = p_timo_re90_tipo,
             timo_indi_re90_ire       = p_timo_indi_re90_ire,
             timo_indi_re90_irp_rsp   = p_timo_indi_re90_irp_rsp,
             timo_tipd_cod            = p_timo_tipd_cod
       where timo_codi = p_timo_codi;
    elsif p_indi = 'N' then
    
      insert into come_tipo_movi
        (timo_codi,
         timo_codi_oper,
         timo_desc,
         timo_afec_sald,
         timo_dbcr,
         timo_emit_reci,
         timo_calc_iva,
         timo_suma_rest_clpr,
         timo_desc_abre,
         timo_indi_libr_iva,
         timo_ingr_dbcr_vari,
         timo_ingr_cheq_dbcr_vari,
         timo_indi_adel,
         timo_indi_ncr,
         timo_indi_sald,
         timo_indi_caja,
         timo_dbcr_caja,
         timo_tica_codi,
         timo_indi_reci_canc,
         timo_indi_excl_sald_clpr,
         timo_tico_codi,
         timo_user_regi,
         timo_fech_regi,
         timo_indi_apli_adel_fopa,
         timo_codi_alte,
         timo_empr_codi,
         timo_indi_clpr,
         timo_indi_deud_canc,
         timo_dbcr_vale,
         timo_indi_cont_cred,
         timo_indi_re90_iva,
         timo_re90_codi,
         timo_re90_tipo,
         timo_indi_re90_ire,
         timo_indi_re90_irp_rsp,
         timo_tipd_cod,
         timo_base)
      values
        (p_timo_codi,
         p_timo_codi_oper,
         p_timo_desc,
         p_timo_afec_sald,
         p_timo_dbcr,
         p_timo_emit_reci,
         p_timo_calc_iva,
         p_timo_suma_rest_clpr,
         p_timo_desc_abre,
         p_timo_indi_libr_iva,
         p_timo_ingr_dbcr_vari,
         p_timo_ingr_cheq_dbcr_vari,
         p_timo_indi_adel,
         p_timo_indi_ncr,
         p_timo_indi_sald,
         p_timo_indi_caja,
         p_timo_dbcr_caja,
         p_timo_tica_codi,
         p_timo_indi_reci_canc,
         p_timo_indi_excl_sald_clpr,
         p_timo_tico_codi,
         gen_user,
         sysdate,
         p_timo_indi_apli_adel_fopa,
         p_timo_codi_alte,
         p_timo_empr_codi,
         p_timo_indi_clpr,
         p_timo_indi_deud_canc,
         p_timo_dbcr_vale,
         p_timo_indi_cont_cred,
         p_timo_indi_re90_iva,
         p_timo_re90_codi,
         p_timo_re90_tipo,
         p_timo_indi_re90_ire,
         p_timo_indi_re90_irp_rsp,
         p_timo_tipd_cod,
         pack_repl.fa_devu_codi_base);
    
    elsif p_indi = 'D' then
    
      delete from come_tipo_movi where timo_codi = p_timo_codi;
    else
      raise_application_error(-20010, 'Operación no reconocida');
    end if;
  
  end pp_actualizar_registro;

  procedure pp_genera_codi(o_timo_codi out number) is
  
  begin
    select nvl(max(timo_codi), 0) + 1 into o_timo_codi from come_tipo_movi;
  
  end;

  procedure pp_cargar_forma_pago(p_timo_codi      in number,
                                 i_timo_emit_reci in varchar2,
                                 i_timo_dbcr      in varchar2) is
    cursor cv_fp is
      select fopa_desc, fopa_codi from come_form_pago order by fopa_codi;
  
    v_count number := 0;
    v_marc  char(1);
    
    v_tifo_suma_rest   varchar2(50);
    v_tifo_dbcr        varchar2(50);
    
    v_fopa_valo        varchar2(50);
    v_fopa_desc        varchar2(50);
    v_s_marc           varchar2(50);
    
  begin
  
  
  
  delete from come_tabl_auxi where taax_sess = v('APP_SESSION');
  
    for r in cv_fp loop
    
      select count(*)
        into v_count
        from come_timo_form_pago
       where tifo_timo_codi = p_timo_codi
         and tifo_fopa_codi = to_number(r.fopa_codi);
    
      if v_count = 0 then
        v_marc := 'N';
      else
        v_marc := 'S';
      end if;
    
      begin
        select nvl(tifo_suma_rest,
                   decode(i_timo_emit_reci,
                          'E',
                          decode(i_timo_dbcr, 'D', 'S', 'R'),
                          decode(i_timo_dbcr, 'C', 'S', 'R'))),
               tifo_dbcr
          into v_tifo_suma_rest, v_tifo_dbcr
          from come_timo_form_pago
         where tifo_timo_codi = p_timo_codi
           and tifo_fopa_codi = r.fopa_codi;
      exception
        when others then
          v_tifo_dbcr := i_timo_dbcr;
        
          if i_timo_emit_reci = 'E' then
            if i_timo_dbcr = 'D' then
              v_tifo_suma_rest := 'S';
            else
              v_tifo_suma_rest := 'R';
            end if;
          else
            if i_timo_dbcr = 'C' then
              v_tifo_suma_rest := 'S';
            else
              v_tifo_suma_rest := 'R';
            end if;
          end if;
        
      end;
    
      v_fopa_valo := r.fopa_codi;
      v_fopa_desc := r.fopa_desc;
      v_s_marc    := v_marc;
    
      insert into come_tabl_auxi
        (taax_user,
         taax_sess,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005)
      values
        (gen_user,
         v('APP_SESSION'),
         seq_come_tabl_auxi.nextval,
         v_tifo_suma_rest,
         v_tifo_dbcr,
         v_fopa_valo,
         v_fopa_desc,
         v_s_marc);
    
    end loop;
  
  end;

end i010031;
