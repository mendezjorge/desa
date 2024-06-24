
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020222" is

  --p_form_impr_reci_adel        number:= to_number(fa_busc_para ('p_form_impr_reci_adel'));  
  --p_codi_tipo_empl_cobr        number:= to_number(fa_busc_para('p_codi_tipo_empl_cobr'));  
  p_cant_deci_mmnn number := to_number(fa_busc_para('p_cant_deci_mmnn'));
  p_indi_cont_corr_talo_reci   varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_cont_corr_talo_reci'))); 
  p_indi_rend_comp varchar2(1) := 'N';
  --p_clpr_indi_clie_prov        varchar2(1):= 'C';
  p_empr_codi      number := v('AI_EMPR_CODI');
  p_sucu_codi      number := v('AI_SUCU_CODI');
  p_codi_base      number := pack_repl.fa_devu_codi_base;
  p_movi_codi_auxi number;
  --p_codi_timo_extr_banc  number:= to_number(fa_busc_para ('p_codi_timo_extr_banc'));
  p_codi_mone_mmnn number := to_number(fa_busc_para('p_codi_mone_mmnn'));
  --p_codi_mone_mmee       number:= to_number(fa_busc_para ('p_codi_mone_mmee'));
  --p_cant_deci_mmee       number:= to_number(fa_busc_para ('p_cant_deci_mmee'));
  --p_codi_conc_extr_mone  number:= to_number(fa_busc_para ('p_codi_conc_extr_mone'));
  p_codi_impu_exen number := to_number(fa_busc_para('p_codi_impu_exen'));
  --p_codi_conc            number:= to_number(fa_busc_para ('p_codi_conc_cheq_cred'));
  p_codi_conc_canj_cheq number := to_number(fa_busc_para('p_codi_conc_canj_cheq'));
  p_codi_timo_canj_cheq number := to_number(fa_busc_para('p_codi_timo_canj_cheq'));
  p_indi_vali_repe_cheq varchar2(500) := ltrim(rtrim((fa_busc_para('p_indi_vali_repe_cheq'))));
  p_codi_timo_adle      number := to_number(fa_busc_para('p_codi_timo_adle'));
  p_codi_conc_adle      number := to_number(fa_busc_para('p_codi_conc_adle'));
  p_tica_codi           number;

  p_movi_codi      number;
  p_movi_codi_adel number;
  p_movi_dbcr      varchar2(100);
  v_cheq_codi      number;

  p_cuco_codi      number;
  p_cuco_codi_adel number;
  p_moim_nume_item number := 0;
  p_fech_inic      date;
  p_fech_fini      date;
  type t_bcab is record(
    filt_tipo_canj_cheq     varchar(2),
    movi_clpr_codi          number,
    impo_efec_mone          number,
    impo_efec_mone_sale     number,
    canj_mone_codi_sale     number,
    cuen_mone_codi          number,
    movi_tasa_mone          number,
    canj_tasa_mone_sale     number,
    sum_cheq_impo_mone      number,
    movi_fech_emis          date,
    movi_nume               number,
    sum_cheq_impo_mmnn      number,
    sum_cheq_impo_apli_mone number,
    impo_efec_mmnn          number,
    mone_codi               number,
    sucu_nume_item          number,
    cheq_sald_sal           number,
    movi_nume_adel          number,
    movi_empl_codi          number,
    movi_cuen_codi          number,
    cant_deci_mone_sale     number);
  bsel t_bcab;
  --  pa_devu_fech_habi(p_fech_inic,p_fech_fini);

  cursor BCHEQ_SAL is
    select c001 cheq_cuen_codi,
           c002 cuen_desc,
           c003 cuen_banc_codi,
           c004 banc_desc,
           c005 cheq_mone_codi,
           c006 mone_desc,
           c007 mone_desc_abre,
           c008 mone_cant_deci,
           c009 cheq_nume_cuen,
           c010 cheq_fech_emis,
           c011 cheq_fech_venc,
           c012 cheq_orde,
           c013 cheq_titu,
           c014 cheq_tasa_mone,
           c015 cheq_impo_mone,
           c016 cheq_impo_mmnn,
           decode(c017, 'N', 'No', 'Si') indi_terc,
           c018 cheq_obse,
           c019 cheq_esta,
           c020 cheq_clpr_codi,
           to_number(c021) cheq_sald_mone,
           to_number(c021) cheq_sald,
           c022 cheq_serie,
           c023 cheq_codi,
           c024 cheq_sald_nuev,
           c024 cheq_sald_mone_nuev,
           c025 cheq_impo_apli_mone,
           c026 cheq_impo_apli_mmnn,
           
           c027 cheq_impo_apli_efec_mone,
           c028 cheq_impo_apli_efec_mmnn,
           
           c029 cheq_impo_apli_cheq_mone,
           c030 cheq_impo_apli_cheq_mmnn,
           
           seq_id
      from apex_collections a
     where collection_name = 'BCHEQ_SALI';

  cursor che_entra is
    select taax_c001 cheq_serie,
           taax_c002 cheq_nume,
           taax_c003 cheq_cuen_codi,
           taax_c004 cheq_cuen_desc,
           taax_c005 cheq_mone_codi,
           taax_c006 cheq_mone_desc_abre,
           taax_c007 cheq_banc_codi,
           taax_c008 cheq_banc_codi_desc,
           taax_c009 cheq_nume_cuen,
           taax_c010 cheq_fech_emis,
           taax_c011 cheq_fech_venc,
           taax_c012 cheq_orde,
           taax_c013 cheq_titu,
           taax_c014 cheq_tasa_mone,
           taax_c015 cheq_impo_mone,
           to_number(taax_c014) *
           to_number(taax_c015,
                     '9999999999999D999',
                     'NLS_NUMERIC_CHARACTERS='',.''') cheq_impo_mmnn,
           taax_c016 cheq_indi_terc,
           taax_c017 cheq_obse,
           taax_c018 cheq_mone_desc,
           taax_seq,
           taax_c020 cheq_sald,
           taax_c022 cheq_impo_mone_sale,
           taax_c021 cheq_codi
      from come_tabl_auxi
     where taax_sess = v('app_session')
       and taax_user = v('app_user')
       and taax_c019 = 'E';

  procedure pp_ejec_regi_adel(i_indi in number) is
    V_RECI number;
    V_SALI number;
  begin
    pp_set_variable;
    -- este es de la misma tabla que cargamos cheque entrante 
  
    v_reci := bsel.sum_cheq_impo_mone;
    v_sali := bsel.cheq_sald_sal;
  
    if i_indi = 1 then
    
      /* pp_actualizar_registro(ii_movi_clpr_codi      => v('P29_MOVI_CLPR_CODI'),
      ii_sucu_codi           => v('AI_SUCU_CODI'),
      ii_cuen_mone_codi      => v('P29_CUEN_MONE_CODI'), --p29_cuen_mone_codi
      ii_movi_cuen_codi      => v('P29_MOVI_CUEN_CODI'),
      ii_movi_nume           => v('P29_MOVI_NUME'),
      ii_movi_fech_emis      => v('P29_MOVI_FECH_EMIS'),
      ii_movi_tasa_mone      => v('P29_MOVI_TASA_MONE'), --P29_MOVI_TASA_MONE
      ii_empr_codi           => v('AI_EMPR_CODI'),
      ii_sucu_nume_item      => v('P29_SUCU_NUME_ITEM'),
      ii_impo_efec_mone      => v('P29_IMPO_EFEC_MONE'), -- este es el monto total del dinero en si
      ii_impo_efec_mone_sale => v('P29_IMPO_EFEC_MONE_SALE'), -- este es el monto total en dinero no cheque entrante en mmnn
      ii_filt_tipo_canj_cheq => v('P29_FILT_TIPO_CANJ_CHEQ'),
      ii_canj_dife_mone_sale => v('P29_CANJ_DIFE_MONE_SALE'),
      ii_canj_mone_codi_sale => v('P29_CANJ_MONE_CODI_SALE'),
      ii_canj_tasa_mone_sale => v('P29_CANJ_MONE_CODI_SALE'),
      ii_cant_deci_mone_sale => v('P29_CANJ_CANT_DECI'), --p29_canj_cant_deci
      ii_cheq_codi           => v('P29_CHEQ_NUME_1')); --P29_CHEQ_NUME_1) is*/
   
      pp_actualizar_registro_1;
     
      pp_gene_come_movi_adel(ii_impo_efec_mone_sale     => v('P29_IMPO_EFEC_MONE'),
                             rr_sum_cheq_impo_mone_sale => v_reci,
                             ss_suma_cheq_sald          => v_sali,
                             ii_movi_clpr_codi          => v('P29_MOVI_CLPR_CODI'),
                             ii_canj_mone_codi_sale     =>  bsel.mone_codi,
                             ii_movi_nume               => v('P29_MOVI_NUME_ADEL'),
                             ii_movi_empl_codi          => v('P29_MOVI_EMPL_CODI'),
                             ii_movi_fech_emis          => v('P29_MOVI_FECH_EMIS'),
                             ii_sucu_nume_item          => v('P29_SUCU_NUME_ITEM'),
                             ii_movi_tasa_mone          => bsel.movi_tasa_mone,
                             ii_canj_tasa_mone_sale     => bsel.movi_tasa_mone,
                             ii_sucu_codi               => v('AI_SUCU_CODI'),
                             ii_empr_codi               => v('AI_EMPR_CODI'));
    
    else
    
      /* pp_actualizar_registro(ii_movi_clpr_codi      => v('P29_MOVI_CLPR_CODI'),
      ii_sucu_codi           => v('AI_SUCU_CODI'),
      ii_cuen_mone_codi      => v('P29_CUEN_MONE_CODI'), --p29_cuen_mone_codi
      ii_movi_cuen_codi      => v('P29_MOVI_CUEN_CODI'),
      ii_movi_nume           => v('P29_MOVI_NUME'),
      ii_movi_fech_emis      => v('P29_MOVI_FECH_EMIS'),
      ii_movi_tasa_mone      => v('P29_MOVI_TASA_MONE'), --P29_MOVI_TASA_MONE
      ii_empr_codi           => v('AI_EMPR_CODI'),
      ii_sucu_nume_item      => v('P29_SUCU_NUME_ITEM'),
      ii_impo_efec_mone      => v('P29_IMPO_EFEC_MONE'), -- este es el monto total del dinero en si
      ii_impo_efec_mone_sale => v('P29_IMPO_EFEC_MONE_SALE'), -- este es el monto total en dinero no cheque entrante en mmnn
      ii_filt_tipo_canj_cheq => v('P29_FILT_TIPO_CANJ_CHEQ'),
      ii_canj_dife_mone_sale => v('P29_CANJ_DIFE_MONE_SALE'),
      ii_canj_mone_codi_sale => v('P29_CANJ_MONE_CODI_SALE'),
      ii_canj_tasa_mone_sale => v('P29_CANJ_MONE_CODI_SALE'),
      ii_cant_deci_mone_sale => v('P29_CANJ_CANT_DECI'), --p29_canj_cant_deci
      ii_cheq_codi           => v('P29_CHEQ_NUME_1')); --P29_CHEQ_NUME_1) is*/
    
      pp_actualizar_registro_1;
    
    end if;
    
  begin
  -- Call the procedure
  I020222.pp_generar_reporte;
  end;

  end;

  /************* ACTUALIZAR REGISTROS **************/
  procedure pp_actualizar_registro(ii_movi_clpr_codi      in number,
                                   ii_sucu_codi           in number,
                                   ii_cuen_mone_codi      in number, --p29_cuen_mone_codi
                                   ii_movi_cuen_codi      in number,
                                   ii_movi_nume           in number,
                                   ii_movi_fech_emis      in date,
                                   ii_movi_tasa_mone      in number, --P29_MOVI_TASA_MONE
                                   ii_empr_codi           in number,
                                   ii_sucu_nume_item      in number,
                                   ii_impo_efec_mone      in number, -- este es el monto total del dinero en si
                                   ii_impo_efec_mone_sale in number, -- este es el monto total en dinero no cheque entrante en mmnn
                                   ii_filt_tipo_canj_cheq in varchar2,
                                   ii_canj_dife_mone_sale in number,
                                   ii_canj_mone_codi_sale in number,
                                   ii_canj_tasa_mone_sale in number,
                                   ii_cant_deci_mone_sale in number, --p29_canj_cant_deci
                                   ii_cheq_codi           in number) is
    --P29_CHEQ_NUME_1) is
  
    v_dife                    number;
    v_sum_cheq_impo_mone_sale number;
    v_suma_cheq_sald          number;
    v_sum_cheq_impo_mmnn      number;
    v_sali_tasa_cheq          number;
    v_reci_tasa_cheq          number;
    v_reci_mone_cheq          number;
  
  begin
    pp_set_variable; ----obtiene valor para la mastriz
    -- este es de la misma tabla que cargamos cheque entrante 
    select sum(taax_c015) cheq_impo_mone
      into v_sum_cheq_impo_mone_sale
      from come_tabl_auxi
     where taax_sess = v('APP_SESSION')
       and taax_user = gen_user
       and taax_c019 = 'E';
  
    -- determinamos el importe mmnn de cheque entrante  
    select sum(cheq_impo_mmnn)
      into v_sum_cheq_impo_mmnn
      from (select to_number(taax_c015) * to_number(taax_c014) cheq_impo_mmnn
              from come_tabl_auxi
             where taax_sess = v('APP_SESSION')
               and taax_user = gen_user
               and taax_c019 = 'E');
  
    -- este es el saldo del cheque saliente
    select nvl(fa_devu_cheq_sald_mone(c.cheq_codi), c.cheq_impo_mone) IMPORTE_FUNC,
           c.cheq_tasa_mone
      into v_suma_cheq_sald, v_sali_tasa_cheq
      from come_cheq c, come_cuen_banc cb, come_banc b, come_mone m
     where c.cheq_cuen_codi = cb.cuen_codi(+)
       and cb.cuen_banc_codi = b.banc_codi(+)
       and c.cheq_mone_codi = m.mone_codi(+)
       and c.cheq_codi = ii_cheq_codi;
  
    v_dife := (nvl(ii_impo_efec_mone_sale, 0) +
              nvl(v_sum_cheq_impo_mone_sale, 0)) - nvl(v_suma_cheq_sald, 0);
  
    /*  if nvl(v_dife, 0) > 0 then
      if fl_confirmar_reg('Existe diferencia de ' ||
                          rtrim(ltrim(to_char(v_dife, '9G999G999G999'))) ||
                          ' entre el importe entrante y el saliente. Se generara un Adelanto por ' ||
                          'esta diferencia. Desea continuar?') <>
         upper('confirmar') then
        raise salir;
      end if;
    end if;*/
  
    --pp_actualizar_come_movi;
    begin
      -- Call the procedure
      I020222.pp_actualizar_come_movi(i_movi_clpr_codi     => ii_movi_clpr_codi,
                                      i_sucu_codi          => ii_sucu_codi,
                                      i_cuen_mone_codi     => ii_cuen_mone_codi,
                                      i_movi_cuen_codi     => ii_movi_cuen_codi,
                                      i_movi_nume          => ii_movi_nume,
                                      i_movi_fech_emis     => ii_movi_fech_emis,
                                      i_movi_tasa_mone     => ii_movi_tasa_mone,
                                      i_empr_codi          => ii_empr_codi,
                                      i_sucu_nume_item     => ii_sucu_nume_item,
                                      i_sum_cheq_impo_mmnn => v_sum_cheq_impo_mmnn,
                                      i_impo_efec_mmnn     => ii_impo_efec_mone_sale,
                                      i_sum_cheq_impo_mone => v_sum_cheq_impo_mone_sale,
                                      i_impo_efec_mone     => ii_impo_efec_mone);
    end;
  
    --pp_actualizar_come_cheq;
    begin
      -- Call the procedure
      I020222.pp_actualizar_come_cheq(i_movi_clpr_codi => ii_movi_clpr_codi,
                                      i_sucu_nume_item => ii_sucu_nume_item,
                                      i_movi_fech_emis => ii_movi_fech_emis);
    end;
  
    /*
                          
                            
                                      i_cuen_mone_codi      in number,--p29_cuen_mone_codi
                                      i_movi_tasa_mone      in number,--P29_MOVI_TASA_MONE
                                      i_cant_deci_mone_sale in number,--p29_canj_cant_deci
                                      i_cheq_codi           in number --P29_CHEQ_NUME_1
    */
  
    select max(taax_c014), to_number(taax_c005) cheq_impo_mone
      into v_reci_tasa_cheq, v_reci_mone_cheq
      from come_tabl_auxi
     where taax_sess = v('APP_SESSION')
       and taax_user = gen_user
       and taax_c019 = 'E'
     group by taax_c005;
  
    /* begin
      I020222.pp_actualizar_cheq_canj(i_filt_tipo_canj_cheq => ii_filt_tipo_canj_cheq,
                                      i_movi_clpr_codi      => ii_movi_clpr_codi,
                                      p_impo_efec_mone      => ii_impo_efec_mone,
                                      p_impo_efec_mone_sale => ii_impo_efec_mone_sale,
                                      p_cheq_sald_nuev      => ii_canj_dife_mone_sale,
                                      p_sum_cheq_impo_mone  => v_sum_cheq_impo_mone_sale,
                                      p_reci_cheq_codi      => v_cheq_codi,
                                      p_reci_cheq_tasa_mone => v_reci_tasa_cheq,
                                      p_reci_cheq_mone_codi => v_reci_mone_cheq,
                                      p_cheq_sald           => v_suma_cheq_sald,
                                      p_cheq_tasa_mone      => v_sali_tasa_cheq,
                                      i_canj_mone_codi_sale => ii_canj_mone_codi_sale,
                                      i_canj_tasa_mone_sale => ii_canj_tasa_mone_sale,
                                      i_cuen_mone_codi      => ii_cuen_mone_codi,
                                      i_movi_tasa_mone      => ii_movi_tasa_mone,
                                      i_cant_deci_mone_sale => ii_cant_deci_mone_sale,
                                      i_cheq_codi           => ii_cheq_codi);
    end;*/
  
    pp_actualizar_cheq_canj_1;
  
    -- pp_actualizar_cheq_sali;
  
    /* if nvl(v_dife, 0) > 0 then
      p_movi_codi_auxi := p_movi_codi;
      show_window('win_adel');
      go_block('badel');
    else*/
    --pp_actualizar_come_movi_adel;
    --pp_actu_come_movi_cuot_adel;
    --pp_actualizar_moimpu_adel;
    --pp_actualizar_moco_adel;
    --end if;
  
    /*    commit_form;
        if not form_success then
          clear_form(no_validate, full_rollback);
          message('Registro no actualizado.');
          bell;
        else
          pp_llama_reporte;
          clear_form(no_validate);
          message('Registro actualizado.');
          bell;
        end if;
      
        if form_failure then
          
        end if;
      end if;
    exception
      when salir then
        null;**/
  end;

  procedure pp_actualizar_come_movi(i_movi_clpr_codi     in number,
                                    i_sucu_codi          in number,
                                    i_cuen_mone_codi     in number,
                                    i_movi_cuen_codi     in number,
                                    i_movi_nume          in number,
                                    i_movi_fech_emis     in date,
                                    i_movi_tasa_mone     in number,
                                    i_empr_codi          in number,
                                    i_sucu_nume_item     in number,
                                    i_sum_cheq_impo_mmnn in number,
                                    i_impo_efec_mmnn     in number,
                                    i_sum_cheq_impo_mone in number,
                                    i_impo_efec_mone     in number) is
  
    v_movi_codi                number(20);
    v_movi_timo_codi           number(10);
    v_movi_clpr_codi           number(20);
    v_movi_sucu_codi_orig      number(10);
    v_movi_cuen_codi           number(4);
    v_movi_mone_codi           number(4);
    v_movi_nume                number(20);
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(20);
    v_movi_codi_padr           number(20);
    v_movi_tasa_mone           number(20, 4);
    v_movi_tasa_mmee           number(20, 4);
    v_movi_grav_mmnn           number(20, 4);
    v_movi_exen_mmnn           number(20, 4);
    v_movi_iva_mmnn            number(20, 4);
    v_movi_grav_mmee           number(20, 4);
    v_movi_exen_mmee           number(20, 4);
    v_movi_iva_mmee            number(20, 4);
    v_movi_grav_mone           number(20, 4);
    v_movi_exen_mone           number(20, 4);
    v_movi_iva_mone            number(20, 4);
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number(20, 4);
    v_movi_sald_mmee           number(20, 4);
    v_movi_sald_mone           number(20, 4);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_empr_codi           number(2);
    v_movi_empl_codi           number(10);
    v_movi_fech_oper           date;
    v_movi_base                number(2);
    v_movi_clpr_sucu_nume_item number;
  
    v_moco_movi_codi number(20);
    v_moco_nume_item number(10);
    v_moco_conc_codi number(10);
    v_moco_cuco_codi number(10);
    v_moco_impu_codi number(10);
    v_moco_impo_mmnn number(20, 4);
    v_moco_impo_mmee number(20, 4);
    v_moco_impo_mone number(20, 4);
    v_moco_dbcr      varchar2(1);
    v_moco_base      number(2);
  
    v_moim_movi_codi number(20);
    v_moim_nume_item number(4);
    v_moim_tipo      varchar2(20);
    v_moim_cuen_codi number(4);
    v_moim_dbcr      varchar2(1);
    v_moim_afec_caja varchar2(1);
    v_moim_fech      date;
    v_moim_impo_mone number(20, 4);
    v_moim_impo_mmnn number(20, 4);
    v_moim_base      number(2);
    v_moim_cheq_codi number(20);
    v_moim_caja_codi number(20);
    v_moim_impo_mmee number(20, 4);
    v_moim_asie_codi number(20);
    v_moim_fech_oper date;
  
    v_moim_impu_codi number(10);
    --v_moim_movi_codi       number(20);
    --v_moim_impo_mmnn       number(20, 4);
    --v_moim_impo_mmee       number(20, 4);
    v_moim_impu_mmnn number(20, 4);
    v_moim_impu_mmee number(20, 4);
    --v_moim_impo_mone       number(20, 4);
    v_moim_impu_mone number(20, 4);
    --v_moim_base            number(2);
  
    v_tica_codi number;
  begin
  
    p_movi_codi           := fa_sec_come_movi;
    v_movi_timo_codi      := p_codi_timo_canj_cheq; --p_codi_timo_vari_debi;
    v_movi_clpr_codi      := i_movi_clpr_codi;
    v_movi_sucu_codi_orig := i_sucu_codi;
    v_movi_cuen_codi      := null;
    v_movi_mone_codi      := i_cuen_mone_codi; --p_codi_mone_mmnn;
    v_movi_nume           := i_movi_nume;
    v_movi_fech_emis      := i_movi_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := i_movi_TASA_MONE;
    v_movi_tasa_mmee      := null;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := nvl(i_sum_cheq_impo_mmnn, 0) +
                             nvl(i_impo_efec_mmnn, 0);
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := null;
    v_movi_exen_mmee      := null;
    v_movi_iva_mmee       := null;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := nvl(i_sum_cheq_impo_mone, 0) +
                             nvl(i_impo_efec_mone, 0);
    v_movi_iva_mone       := 0;
    v_movi_obse           := null;
    v_movi_sald_mmnn      := 0;
    v_movi_sald_mmee      := null;
    v_movi_sald_mone      := 0;
    v_movi_empr_codi      := i_empr_codi;
    v_movi_empl_codi      := null;
    v_movi_fech_oper      := i_movi_fech_emis;
    v_movi_base           := p_codi_base;
    --v_movi_emit_reci           := 'E';
    --v_movi_afec_sald           := 'C';
    --v_movi_dbcr                := 'D';
    v_movi_clpr_sucu_nume_item := i_sucu_nume_item;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
  
    pp_muestra_tipo_movi(p_codi_timo_canj_cheq, --p_codi_timo_vari_debi,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    p_movi_dbcr := v_movi_dbcr;
  
    I020222.pp_insert_come_movi(p_movi_codi,
                                v_movi_timo_codi,
                                v_movi_clpr_codi,
                                v_movi_sucu_codi_orig,
                                v_movi_cuen_codi,
                                v_movi_mone_codi,
                                v_movi_nume,
                                v_movi_fech_emis,
                                v_movi_fech_grab,
                                v_movi_user,
                                v_movi_codi_padr,
                                v_movi_tasa_mone,
                                v_movi_tasa_mmee,
                                v_movi_grav_mmnn,
                                v_movi_exen_mmnn,
                                v_movi_iva_mmnn,
                                v_movi_grav_mmee,
                                v_movi_exen_mmee,
                                v_movi_iva_mmee,
                                v_movi_grav_mone,
                                v_movi_exen_mone,
                                v_movi_iva_mone,
                                v_movi_obse,
                                v_movi_sald_mmnn,
                                v_movi_sald_mmee,
                                v_movi_sald_mone,
                                v_movi_emit_reci,
                                v_movi_afec_sald,
                                v_movi_dbcr,
                                v_movi_empr_codi,
                                v_movi_empl_codi,
                                v_movi_fech_oper,
                                v_movi_clpr_sucu_nume_item,
                                v_movi_base);
  
    v_moco_movi_codi := p_movi_codi;
    v_moco_nume_item := 1;
    v_moco_conc_codi := p_codi_conc_canj_cheq;
    v_moco_cuco_codi := p_cuco_codi;
    v_moco_impu_codi := p_codi_impu_exen;
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := null;
    v_moco_impo_mone := v_movi_exen_mone;
    --v_moco_dbcr           := 'C';
    v_moco_base := p_codi_base;
  
    I020222.pp_devu_dbcr_conc(v_moco_conc_codi, v_moco_dbcr);
  
    I020222.pp_insert_come_movi_conc_deta(v_moco_movi_codi,
                                          v_moco_nume_item,
                                          v_moco_conc_codi,
                                          v_moco_cuco_codi,
                                          v_moco_impu_codi,
                                          v_moco_impo_mmnn,
                                          v_moco_impo_mmee,
                                          v_moco_impo_mone,
                                          v_moco_dbcr,
                                          v_moco_base);
  
    v_moim_impu_codi := p_codi_impu_exen;
    v_moim_movi_codi := p_movi_codi;
    v_moim_impo_mmnn := v_movi_exen_mmnn;
    v_moim_impo_mmee := null;
    v_moim_impu_mmnn := 0;
    v_moim_impu_mmee := null;
    v_moim_impo_mone := v_movi_exen_mone;
    v_moim_impu_mone := 0;
    v_moim_base      := p_codi_base;
  
    i020222.pp_insert_come_movi_impu_deta(v_moim_impu_codi,
                                          v_moim_movi_codi,
                                          v_moim_impo_mmnn,
                                          v_moim_impo_mmee,
                                          v_moim_impu_mmnn,
                                          v_moim_impu_mmee,
                                          v_moim_impo_mone,
                                          v_moim_impu_mone,
                                          v_moim_base);
  
    if nvl(i_impo_efec_mmnn, 0) <> 0 then
      p_moim_nume_item := nvl(p_moim_nume_item, 0) + 1;
    
      v_moim_movi_codi := p_movi_codi;
      v_moim_nume_item := p_moim_nume_item;
      v_moim_tipo      := 'Efectivo';
      v_moim_cuen_codi := i_movi_cuen_codi;
      v_moim_dbcr      := p_movi_dbcr;
      v_moim_afec_caja := 'S';
      v_moim_fech      := i_movi_fech_emis;
      v_moim_impo_mone := i_impo_efec_mone; --v_movi_exen_mone;
      v_moim_impo_mmnn := i_impo_efec_mmnn; --v_movi_exen_mmnn;
      v_moim_base      := p_codi_base;
      v_moim_cheq_codi := null;
      v_moim_caja_codi := null;
      v_moim_impo_mmee := null;
      v_moim_asie_codi := null;
      v_moim_fech_oper := i_movi_fech_emis;
    
      pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                    v_moim_nume_item,
                                    v_moim_tipo,
                                    v_moim_cuen_codi,
                                    v_moim_dbcr,
                                    v_moim_afec_caja,
                                    v_moim_fech,
                                    v_moim_impo_mone,
                                    v_moim_impo_mmnn,
                                    v_moim_base,
                                    v_moim_cheq_codi,
                                    v_moim_caja_codi,
                                    v_moim_impo_mmee,
                                    v_moim_asie_codi,
                                    v_moim_fech_oper);
    end if;
  
  end;

  procedure pp_actualizar_come_cheq(i_movi_clpr_codi in number,
                                    i_sucu_nume_item in number,
                                    i_movi_fech_emis in date) is
  
    v_cheq_codi                number(20);
    v_cheq_mone_codi           number(4);
    v_cheq_banc_codi           number(4);
    v_cheq_nume                varchar2(30);
    v_cheq_serie               varchar2(3);
    v_cheq_fech_emis           date;
    v_cheq_fech_venc           date;
    v_cheq_impo_mone           number(20, 4);
    v_cheq_impo_mmnn           number(20, 4);
    v_cheq_tipo                varchar2(1);
    v_cheq_clpr_codi           number(20);
    v_cheq_esta                varchar2(1);
    v_cheq_nume_cuen           varchar2(20);
    v_cheq_obse                varchar2(100);
    v_cheq_indi_ingr_manu      varchar2(1);
    v_cheq_cuen_codi           number(4);
    v_cheq_tasa_mone           number(20, 4);
    v_cheq_titu                varchar2(60);
    v_cheq_orde                varchar2(60);
    v_cheq_user                varchar2(10);
    v_cheq_fech_grab           date;
    v_cheq_base                number(2);
    v_cheq_tach_codi           number(4);
    v_cheq_caja_codi           number(20);
    v_cheq_orpa_codi           number(20);
    v_cheq_fech_depo           date;
    v_cheq_fech_rech           date;
    v_cheq_indi_terc           varchar2(1);
    v_cheq_indi_desc           varchar2(1);
    v_cheq_clpr_sucu_nume_item number;
  
    v_chmo_movi_codi number(20);
    v_chmo_cheq_codi number(20);
    v_chmo_esta_ante varchar2(2);
    v_chmo_cheq_secu number(4);
    v_chmo_base      number(2);
  
    v_moim_movi_codi number(20);
    v_moim_nume_item number(4);
    v_moim_tipo      varchar2(20);
    v_moim_cuen_codi number(4);
    v_moim_dbcr      varchar2(1);
    v_moim_afec_caja varchar2(1);
    v_moim_fech      date;
    v_moim_impo_mone number(20, 4);
    v_moim_impo_mmnn number(20, 4);
    v_moim_base      number(2);
    v_moim_cheq_codi number(20);
    v_moim_caja_codi number(20);
    v_moim_impo_mmee number(20, 4);
    v_moim_asie_codi number(20);
    v_moim_fech_oper date;
  
    cursor c_det is
      select taax_c001 cheq_serie,
             taax_c002 cheq_nume,
             taax_c003 cheq_cuen_codi,
             taax_c004 cheq_cuen_desc,
             taax_c005 cheq_mone_codi,
             taax_c006 cheq_mone_desc_abre,
             taax_c007 cheq_banc_codi,
             taax_c008 cheq_banc_codi_desc,
             taax_c009 cheq_nume_cuen,
             taax_c010 cheq_fech_emis,
             taax_c011 cheq_fech_venc,
             taax_c012 cheq_orde,
             taax_c013 cheq_titu,
             decode(taax_c005,
                    1,
                    to_char(taax_c014, '999G999G999G999G990'),
                    to_char(taax_c014, '999G999G999G999G990D00')) cheq_tasa_mone,
             decode(taax_c005,
                    1,
                    to_number(taax_c015,
                              '9999999999999D999',
                              'NLS_NUMERIC_CHARACTERS='',.'''),
                    to_number(taax_c015,
                              '9999999999999D999',
                              'NLS_NUMERIC_CHARACTERS='',.''')) cheq_impo_mone,
             to_number(taax_c014) *
             to_number(taax_c015,
                       '9999999999999D999',
                       'NLS_NUMERIC_CHARACTERS='',.''') cheq_impo_mmnn,
             decode(taax_c016, 'N', 'No', 'Si') cheq_indi_terc,
             taax_c017 cheq_obse,
             taax_c018 cheq_mone_desc,
             taax_seq
        from come_tabl_auxi
       where taax_sess = v('APP_SESSION')
         and taax_user = gen_user
         and taax_c019 = 'E';
  begin
  
    for i in c_det loop
      if i.cheq_nume is not null then
        v_cheq_codi                := fa_sec_come_cheq;
        v_cheq_mone_codi           := i.cheq_mone_codi;
        v_cheq_banc_codi           := i.cheq_banc_codi;
        v_cheq_nume                := i.cheq_nume;
        v_cheq_serie               := i.cheq_serie;
        v_cheq_fech_emis           := i.cheq_fech_emis;
        v_cheq_fech_venc           := i.cheq_fech_venc;
        v_cheq_impo_mone           := i.cheq_impo_mone;
        v_cheq_impo_mmnn           := i.cheq_impo_mmnn;
        v_cheq_tipo                := 'R';
        v_cheq_clpr_codi           := i_movi_clpr_codi;
        v_cheq_esta                := 'I';
        v_cheq_nume_cuen           := i.cheq_nume_cuen;
        v_cheq_obse                := i.cheq_obse;
        v_cheq_indi_ingr_manu      := 'N';
        v_cheq_cuen_codi           := i.cheq_cuen_codi;
        v_cheq_tasa_mone           := i.cheq_tasa_mone;
        v_cheq_titu                := i.cheq_titu;
        v_cheq_orde                := i.cheq_orde;
        v_cheq_user                := gen_user;
        v_cheq_fech_grab           := sysdate;
        v_cheq_base                := p_codi_base;
        v_cheq_tach_codi           := null;
        v_cheq_caja_codi           := null;
        v_cheq_orpa_codi           := null;
        v_cheq_fech_depo           := null;
        v_cheq_fech_rech           := null;
        v_cheq_indi_terc           := i.cheq_indi_terc;
        v_cheq_indi_desc           := null;
        v_cheq_clpr_sucu_nume_item := i_sucu_nume_item;
      
        if v_cheq_clpr_sucu_nume_item = 0 then
          v_cheq_clpr_sucu_nume_item := null;
        end if;
      
        /*    i020222.pp_insert_come_cheq(v_cheq_codi,
        v_cheq_mone_codi,
        v_cheq_banc_codi,
        v_cheq_nume,
        v_cheq_serie,
        v_cheq_fech_emis,
        v_cheq_fech_venc,
        v_cheq_impo_mone,
        v_cheq_impo_mmnn,
        v_cheq_tipo,
        v_cheq_clpr_codi,
        v_cheq_esta,
        v_cheq_nume_cuen,
        v_cheq_obse,
        v_cheq_indi_ingr_manu,
        v_cheq_cuen_codi,
        v_cheq_tasa_mone,
        v_cheq_titu,
        v_cheq_orde,
        v_cheq_user,
        v_cheq_fech_grab,
        v_cheq_base,
        v_cheq_tach_codi,
        v_cheq_caja_codi,
        v_cheq_orpa_codi,
        v_cheq_fech_depo,
        v_cheq_fech_rech,
        v_cheq_indi_terc,
        v_cheq_indi_desc,
        v_cheq_clpr_sucu_nume_item);*/
      
        v_chmo_movi_codi := p_movi_codi;
        v_chmo_cheq_codi := v_cheq_codi;
        v_chmo_esta_ante := null;
        v_chmo_cheq_secu := 1;
        v_chmo_base      := p_codi_base;
      
        pp_insert_come_movi_cheq(v_chmo_movi_codi,
                                 v_chmo_cheq_codi,
                                 v_chmo_esta_ante,
                                 v_cheq_esta,
                                 v_chmo_cheq_secu,
                                 v_chmo_base);
      
        v_moim_movi_codi := p_movi_codi;
        p_moim_nume_item := nvl(p_moim_nume_item, 0) + 1;
        v_moim_nume_item := p_moim_nume_item;
      
        if i.cheq_fech_venc > i.cheq_fech_emis then
          v_moim_tipo := 'Cheq. Dif. Rec.';
        else
          v_moim_tipo := 'Cheq. Dia. Rec.';
        end if;
      
        v_moim_cuen_codi := i.cheq_cuen_codi;
        v_moim_dbcr      := p_movi_dbcr;
        v_moim_afec_caja := 'N';
        v_moim_fech      := i_movi_fech_emis;
        v_moim_impo_mone := i.cheq_impo_mone;
        v_moim_impo_mmnn := i.cheq_impo_mmnn;
        v_moim_base      := p_codi_base;
        v_moim_cheq_codi := v_cheq_codi;
        v_moim_caja_codi := null;
        v_moim_impo_mmee := null;
        v_moim_asie_codi := null;
        v_moim_fech_oper := i_movi_fech_emis;
      
        pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                      v_moim_nume_item,
                                      v_moim_tipo,
                                      v_moim_cuen_codi,
                                      v_moim_dbcr,
                                      v_moim_afec_caja,
                                      v_moim_fech,
                                      v_moim_impo_mone,
                                      v_moim_impo_mmnn,
                                      v_moim_base,
                                      v_moim_cheq_codi,
                                      v_moim_caja_codi,
                                      v_moim_impo_mmee,
                                      v_moim_asie_codi,
                                      v_moim_fech_oper);
      
        update come_tabl_auxi
           set taax_c021 = v_cheq_codi
         where taax_sess = v('APP_SESSION')
           and taax_user = gen_user
           and taax_c019 = 'E'
           and taax_seq = i.taax_seq;
      end if;
    
    end loop;
  end;

  procedure pp_actualizar_cheq_canj(i_filt_tipo_canj_cheq in varchar2,
                                    i_movi_clpr_codi      in number,
                                    p_impo_efec_mone      in number, -- importe mone dinero
                                    p_impo_efec_mone_sale in number, -- importe mone sale dinero
                                    p_cheq_sald_nuev      in number, -- es el importe de la diferencia P29_CANJ_DIFE_MONE_SALE
                                    p_sum_cheq_impo_mone  in number, --total de cheque entrante
                                    p_reci_cheq_codi      in number, --cheq codi del cheque entrante
                                    p_reci_cheq_tasa_mone in number, --tasa del cheque entrante
                                    p_reci_cheq_mone_codi in number, --moneda del cheque entrante
                                    p_cheq_sald           in number, --total del cheque saliente
                                    p_cheq_tasa_mone      in number, --tasa del cheque saliente
                                    i_canj_mone_codi_sale in number, --P29_CANJ_MONE_CODI_SALE
                                    i_canj_tasa_mone_sale in number, --P29_CANJ_TASA_MONE_SALE
                                    i_cuen_mone_codi      in number, --p29_cuen_mone_codi
                                    i_movi_tasa_mone      in number, --P29_MOVI_TASA_MONE
                                    i_cant_deci_mone_sale in number, --p29_canj_cant_deci
                                    i_cheq_codi           in number --P29_CHEQ_NUME_1
                                    ) is
  
    v_total_efectivo      number := 0;
    v_total_efectivo_sale number := 0;
    v_saldo_cheq          number := 0;
    v_impo_efec           number := 0;
    v_impo_efec_mmnn      number := 0;
    v_total_cheq          number := 0;
    v_total_cheq_sale     number := 0;
    v_impo_cheq           number := 0;
    v_impo_cheq_mmnn      number := 0;
  
    v_canj_movi_codi      number(20);
    v_canj_cheq_codi_sale number(20);
    v_canj_cheq_codi_entr number(20);
    v_canj_nume_item      number(5);
    v_canj_impo_efec_mone number(20, 4);
    v_canj_impo_efec_mmnn number(20, 4);
    v_canj_impo_cheq_mone number(20, 4);
    v_canj_impo_cheq_mmnn number(20, 4);
    v_canj_obse           varchar2(60);
    v_canj_base           number(2);
  
    v_canj_mone_codi_sale number(20);
    v_canj_tasa_mone_sale number(20, 4);
    v_canj_cheq_mone_sale number(20, 4);
    v_cant_efec_mone_sale number(20, 4);
  
    v_clpr_user_canj_cheq_judi varchar2(20);
    v_clpr_fech_canj_cheq_judi date;
    v_indi_canj_cheq_judi      varchar2(1);
  begin
  
    if i_filt_tipo_canj_cheq = 'J' then
      begin
        select clpr_user_canj_cheq_judi,
               clpr_fech_canj_cheq_judi,
               clpr_indi_canj_cheq_judi
          into v_clpr_user_canj_cheq_judi,
               v_clpr_fech_canj_cheq_judi,
               v_indi_canj_cheq_judi
          from come_clie_prov
         where clpr_codi = i_movi_clpr_codi;
      end;
    else
      v_clpr_user_canj_cheq_judi := null;
      v_clpr_fech_canj_cheq_judi := null;
    end if;
  
    --para efectivo
    v_total_efectivo      := nvl(p_impo_efec_mone, 0);
    v_total_efectivo_sale := nvl(p_impo_efec_mone_sale, 0);
  
    if v_total_efectivo > 0 then
    
      v_saldo_cheq := p_cheq_sald_nuev;
    
      if v_total_efectivo_sale >= v_saldo_cheq then
        v_impo_efec := v_saldo_cheq;
      
        if i_canj_mone_codi_sale = i_cuen_mone_codi then
          --Cuando la moneda de salida coincida con la moneda de la cuenta
          v_impo_efec_mmnn := round(v_impo_efec * i_movi_tasa_mone,
                                    p_cant_deci_mmnn);
        else
          --Si no coincide
          if i_canj_mone_codi_sale = p_codi_mone_mmnn then
            --Cuando la moneda de salida es Gs
            v_impo_efec_mmnn := round(v_impo_efec, p_cant_deci_mmnn);
            v_impo_efec      := round(v_impo_efec / i_movi_tasa_mone,
                                      p_cant_deci_mmnn);
          else
            --Cuando la moneda de salida es Moneda Extranjera
            v_impo_efec_mmnn := round(v_impo_efec * i_canj_tasa_mone_sale,
                                      p_cant_deci_mmnn);
            v_impo_efec      := round(v_impo_efec * i_canj_tasa_mone_sale,
                                      i_cant_deci_mone_sale);
          end if;
        end if;
      
        v_total_efectivo := v_total_efectivo - v_impo_efec;
        --    :bcheq_sali.cheq_sald_nuev := p_cheq_sald_nuev - v_impo_efec;
      
        v_canj_movi_codi      := p_movi_codi;
        v_canj_cheq_codi_sale := i_cheq_codi;
        v_canj_cheq_codi_entr := null;
        v_canj_nume_item      := v_canj_nume_item + 1;
        v_canj_impo_efec_mone := v_impo_efec;
        v_canj_impo_efec_mmnn := v_impo_efec_mmnn;
        v_canj_impo_cheq_mone := 0;
        v_canj_impo_cheq_mmnn := 0;
        v_canj_obse           := null;
        v_canj_base           := p_codi_base;
        v_canj_mone_codi_sale := i_canj_mone_codi_sale;
        v_canj_tasa_mone_sale := i_canj_tasa_mone_sale;
        v_canj_cheq_mone_sale := 0;
        v_cant_efec_mone_sale := v_saldo_cheq; --i_impo_efec_mone_sale;
      
        i020222.pp_insert_come_movi_cheq_canj(v_canj_movi_codi,
                                              v_canj_cheq_codi_sale,
                                              v_canj_cheq_codi_entr,
                                              v_canj_nume_item,
                                              v_canj_impo_efec_mone,
                                              v_canj_impo_efec_mmnn,
                                              v_canj_impo_cheq_mone,
                                              v_canj_impo_cheq_mmnn,
                                              v_canj_obse,
                                              v_clpr_user_canj_cheq_judi,
                                              v_clpr_fech_canj_cheq_judi,
                                              v_canj_base,
                                              v_canj_mone_codi_sale,
                                              v_canj_tasa_mone_sale,
                                              v_canj_cheq_mone_sale,
                                              v_cant_efec_mone_sale);
      else
      
        v_impo_efec      := v_total_efectivo;
        v_impo_efec_mmnn := round(v_impo_efec * i_movi_tasa_mone,
                                  p_cant_deci_mmnn);
        v_total_efectivo := 0;
        --:bcheq_sali.cheq_sald_nuev := :bcheq_sali.cheq_sald_nuev - v_total_efectivo_sale; -- v_impo_efec;
      
        v_canj_movi_codi      := p_movi_codi;
        v_canj_cheq_codi_sale := i_cheq_codi;
        v_canj_cheq_codi_entr := null;
        v_canj_nume_item      := v_canj_nume_item + 1;
        v_canj_impo_efec_mone := v_impo_efec;
        v_canj_impo_efec_mmnn := v_impo_efec_mmnn;
        v_canj_impo_cheq_mone := 0;
        v_canj_impo_cheq_mmnn := 0;
        v_canj_obse           := null;
        v_canj_base           := p_codi_base;
        v_canj_mone_codi_sale := i_canj_mone_codi_sale;
        v_canj_tasa_mone_sale := i_canj_tasa_mone_sale;
        v_canj_cheq_mone_sale := 0;
        v_cant_efec_mone_sale := p_impo_efec_mone_sale;
      
        pp_insert_come_movi_cheq_canj(v_canj_movi_codi,
                                      v_canj_cheq_codi_sale,
                                      v_canj_cheq_codi_entr,
                                      v_canj_nume_item,
                                      v_canj_impo_efec_mone,
                                      v_canj_impo_efec_mmnn,
                                      v_canj_impo_cheq_mone,
                                      v_canj_impo_cheq_mmnn,
                                      v_canj_obse,
                                      v_clpr_user_canj_cheq_judi,
                                      v_clpr_fech_canj_cheq_judi,
                                      v_canj_base,
                                      v_canj_mone_codi_sale,
                                      v_canj_tasa_mone_sale,
                                      v_canj_cheq_mone_sale,
                                      v_cant_efec_mone_sale);
      
      end if;
    
    end if;
  
    --para cheques
    v_total_cheq      := nvl(p_sum_cheq_impo_mone, 0);
    v_total_cheq_sale := nvl(p_sum_cheq_impo_mone, 0); --nvl(:bcheq_reci.sum_cheq_impo_mone_sale, 0);
    if v_total_cheq > 0 then
    
      v_impo_cheq := 0;
    
      if nvl(p_cheq_sald_nuev, 0) > 0 then
        if nvl(p_cheq_sald, 0) > 0 then
          --if nvl(:bcheq_reci.cheq_sald, 0) >= nvl(:bcheq_sali.cheq_sald_nuev, 0) then
          if nvl(p_sum_cheq_impo_mone, 0) >= nvl(p_cheq_sald_nuev, 0) then
            v_impo_cheq := nvl(p_cheq_sald_nuev, 0);
          
            -- pl_mm('v_impo_cheq 1 '||v_impo_cheq);
          
            if i_canj_mone_codi_sale = i_cuen_mone_codi then
              --Cuando la moneda de salida coincida con la moneda de la cuenta
              v_impo_cheq_mmnn := round(v_impo_cheq * p_cheq_tasa_mone,
                                        p_cant_deci_mmnn);
            else
              --Si no coincide
              if i_canj_mone_codi_sale = p_codi_mone_mmnn then
                --Cuando la moneda de salida es Gs
                v_impo_cheq_mmnn := round(v_impo_cheq, p_cant_deci_mmnn);
                v_impo_cheq      := round(v_impo_cheq / i_movi_tasa_mone,
                                          p_cant_deci_mmnn);
              else
                --Cuando la moneda de salida es Moneda Extranjera
                v_impo_cheq_mmnn := round(v_impo_cheq *
                                          i_canj_tasa_mone_sale,
                                          p_cant_deci_mmnn);
                v_impo_cheq      := round(v_impo_cheq *
                                          i_canj_tasa_mone_sale,
                                          i_cant_deci_mone_sale);
              end if;
            
            end if;
          
            v_canj_cheq_mone_sale := nvl(p_cheq_sald_nuev, 0); --:bcheq_reci.cheq_impo_mone_sale;
            --:bcheq_sali.cheq_sald_nuev := 0;
            --v_indi_next_record         := 'S';
            --:bcheq_reci.cheq_sald      := :bcheq_reci.cheq_sald - v_impo_cheq;
          
            v_canj_movi_codi      := p_movi_codi;
            v_canj_cheq_codi_sale := i_cheq_codi;
            v_canj_cheq_codi_entr := p_reci_cheq_codi;
            v_canj_nume_item      := v_canj_nume_item + 1;
            v_canj_impo_efec_mone := 0;
            v_canj_impo_efec_mmnn := 0;
            v_canj_impo_cheq_mone := v_impo_cheq;
            v_canj_impo_cheq_mmnn := v_impo_cheq_mmnn;
            v_canj_obse           := null;
            v_canj_base           := p_codi_base;
            v_canj_mone_codi_sale := i_canj_mone_codi_sale;
            v_canj_tasa_mone_sale := i_canj_tasa_mone_sale;
          
            v_cant_efec_mone_sale := 0;
          
            i020222.pp_insert_come_movi_cheq_canj(v_canj_movi_codi,
                                                  v_canj_cheq_codi_sale,
                                                  v_canj_cheq_codi_entr,
                                                  v_canj_nume_item,
                                                  v_canj_impo_efec_mone,
                                                  v_canj_impo_efec_mmnn,
                                                  v_canj_impo_cheq_mone,
                                                  v_canj_impo_cheq_mmnn,
                                                  v_canj_obse,
                                                  v_clpr_user_canj_cheq_judi,
                                                  v_clpr_fech_canj_cheq_judi,
                                                  v_canj_base,
                                                  v_canj_mone_codi_sale,
                                                  v_canj_tasa_mone_sale,
                                                  v_canj_cheq_mone_sale,
                                                  v_cant_efec_mone_sale);
          
          else
            --si el saldo del cheque nuevo es menor al saldo del cheque saliente
            v_impo_cheq := p_cheq_sald;
          
            if i_canj_mone_codi_sale = i_cuen_mone_codi then
              v_impo_cheq_mmnn := round(v_impo_cheq * p_reci_cheq_tasa_mone,
                                        p_cant_deci_mmnn);
            else
              if p_reci_cheq_mone_codi = p_codi_mone_mmnn then
                v_impo_cheq_mmnn := round(v_impo_cheq *
                                          i_canj_tasa_mone_sale,
                                          p_cant_deci_mmnn);
              else
                v_impo_cheq_mmnn := round(v_impo_cheq *
                                          p_reci_cheq_tasa_mone,
                                          p_cant_deci_mmnn);
              end if;
            end if;
          
            v_canj_movi_codi      := p_movi_codi;
            v_canj_cheq_codi_sale := i_cheq_codi;
            v_canj_cheq_codi_entr := p_reci_cheq_codi;
            v_canj_nume_item      := v_canj_nume_item + 1;
            v_canj_impo_efec_mone := 0;
            v_canj_impo_efec_mmnn := 0;
            v_canj_impo_cheq_mone := v_impo_cheq;
            v_canj_impo_cheq_mmnn := v_impo_cheq_mmnn;
            v_canj_obse           := null;
            v_canj_base           := p_codi_base;
            v_canj_mone_codi_sale := i_canj_mone_codi_sale;
            v_canj_tasa_mone_sale := i_canj_tasa_mone_sale;
            v_canj_cheq_mone_sale := p_sum_cheq_impo_mone;
            v_cant_efec_mone_sale := 0;
          
            pp_insert_come_movi_cheq_canj(v_canj_movi_codi,
                                          v_canj_cheq_codi_sale,
                                          v_canj_cheq_codi_entr,
                                          v_canj_nume_item,
                                          v_canj_impo_efec_mone,
                                          v_canj_impo_efec_mmnn,
                                          v_canj_impo_cheq_mone,
                                          v_canj_impo_cheq_mmnn,
                                          v_canj_obse,
                                          v_clpr_user_canj_cheq_judi,
                                          v_clpr_fech_canj_cheq_judi,
                                          v_canj_base,
                                          v_canj_mone_codi_sale,
                                          v_canj_tasa_mone_sale,
                                          v_canj_cheq_mone_sale,
                                          v_cant_efec_mone_sale);
          
          end if;
        end if;
      end if;
    end if;
  
    if i_filt_tipo_canj_cheq = 'J' then
      update come_clie_prov
         set clpr_indi_canj_cheq_judi = 'N'
       where clpr_codi = i_movi_clpr_codi;
    end if;
  
  end pp_actualizar_cheq_canj;

  procedure pp_actualizar_registro_1 is
    v_dife number;
    salir  exception;
  begin
    pp_set_variable; ----obtiene valor para la mastriz
  
    if (nvl(bsel.impo_efec_mone, 0) + nvl(bsel.sum_cheq_impo_mone, 0)) <= 0 then
      pl_me('El importe del canje debe ser mayor a cero, suma del importe efectivo mas los nuevos cheques  ');
    end if;
  
    --pp_validar_repe_cheq_sali;
    pp_calcular_saldo;
  
    if nvl(bsel.sum_cheq_impo_apli_mone, 0) <= 0 then
      pl_me('El importe Aplicado de cheques no puede ser igual a cero');
    end if;
  
    v_dife := (nvl(bsel.impo_efec_mone, 0) +
              nvl(bsel.sum_cheq_impo_mone, 0)) -
              nvl(bsel.sum_cheq_impo_apli_mone, 0);
  
    /* if nvl(v_dife, 0) > 0 then
     pl_me('El importe de efectivo mas los cheques ingresantes es mayor al importe de los cheques a canjear!!!');
     raise salir;
    end if;*/
    
    pp_actualizar_come_movi_1;
    
    pp_actualizar_come_cheq_1;
   -- raise_application_error(-20001,'dddd');
    pp_actualizar_cheq_canj_1;
  
  exception
    when salir then
      null;
  end pp_actualizar_registro_1;

  procedure pp_actualizar_come_movi_1 is
    v_movi_codi                number(20);
    v_movi_timo_codi           number(10);
    v_movi_clpr_codi           number(20);
    v_movi_sucu_codi_orig      number(10);
    v_movi_cuen_codi           number(4);
    v_movi_mone_codi           number(4);
    v_movi_nume                number(20);
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(20);
    v_movi_codi_padr           number(20);
    v_movi_tasa_mone           number(20, 4);
    v_movi_tasa_mmee           number(20, 4);
    v_movi_grav_mmnn           number(20, 4);
    v_movi_exen_mmnn           number(20, 4);
    v_movi_iva_mmnn            number(20, 4);
    v_movi_grav_mmee           number(20, 4);
    v_movi_exen_mmee           number(20, 4);
    v_movi_iva_mmee            number(20, 4);
    v_movi_grav_mone           number(20, 4);
    v_movi_exen_mone           number(20, 4);
    v_movi_iva_mone            number(20, 4);
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number(20, 4);
    v_movi_sald_mmee           number(20, 4);
    v_movi_sald_mone           number(20, 4);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_empr_codi           number(2);
    v_movi_empl_codi           number(10);
    v_movi_fech_oper           date;
    v_movi_base                number(2);
    v_movi_clpr_sucu_nume_item number;
  
    v_moco_movi_codi number(20);
    v_moco_nume_item number(10);
    v_moco_conc_codi number(10);
    v_moco_cuco_codi number(10);
    v_moco_impu_codi number(10);
    v_moco_impo_mmnn number(20, 4);
    v_moco_impo_mmee number(20, 4);
    v_moco_impo_mone number(20, 4);
    v_moco_dbcr      varchar2(1);
    v_moco_base      number(2);
  
    v_moim_movi_codi number(20);
    v_moim_nume_item number(4);
    v_moim_tipo      varchar2(20);
    v_moim_cuen_codi number(4);
    v_moim_dbcr      varchar2(1);
    v_moim_afec_caja varchar2(1);
    v_moim_fech      date;
    v_moim_impo_mone number(20, 4);
    v_moim_impo_mmnn number(20, 4);
    v_moim_base      number(2);
    v_moim_cheq_codi number(20);
    v_moim_caja_codi number(20);
    v_moim_impo_mmee number(20, 4);
    v_moim_asie_codi number(20);
    v_moim_fech_oper date;
  
    v_moim_impu_codi number(10);
    v_moim_impu_mmnn number(20, 4);
    v_moim_impu_mmee number(20, 4);
    v_moim_impu_mone number(20, 4);
  
    v_tica_codi number;
  begin
  
    v_movi_codi                := fa_sec_come_movi;
    p_movi_codi                := v_movi_codi;
    v_movi_timo_codi           := p_codi_timo_canj_cheq;
    v_movi_clpr_codi           := bsel.movi_clpr_codi;
    v_movi_sucu_codi_orig      := p_sucu_codi;
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := bsel.mone_codi;
    v_movi_nume                := bsel.movi_nume;
    v_movi_fech_emis           := bsel.movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := gen_user;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := BSEL.movi_TASA_MONE;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := nvl( /*bcheq_reci*/bsel.sum_cheq_impo_mmnn,
                                      0) + nvl(bsel.impo_efec_mmnn, 0);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := nvl( /*bcheq_reci*/bsel.sum_cheq_impo_mone,
                                      0) + nvl(bsel.impo_efec_mone, 0);
    v_movi_iva_mone            := 0;
    v_movi_obse                := null;
    v_movi_sald_mmnn           := 0;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := 0;
    v_movi_empr_codi           := p_empr_codi;
    v_movi_empl_codi           := null;
    v_movi_fech_oper           := bsel.movi_fech_emis;
    v_movi_base                := p_codi_base;
    v_movi_clpr_sucu_nume_item := bsel.sucu_nume_item;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
  
    pp_muestra_tipo_movi(p_codi_timo_canj_cheq, --:parameter.p_codi_timo_vari_debi,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    p_movi_dbcr := v_movi_dbcr;
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_cuen_codi,
                        v_movi_mone_codi,
                        v_movi_nume,
                        v_movi_fech_emis,
                        v_movi_fech_grab,
                        v_movi_user,
                        v_movi_codi_padr,
                        v_movi_tasa_mone,
                        v_movi_tasa_mmee,
                        v_movi_grav_mmnn,
                        v_movi_exen_mmnn,
                        v_movi_iva_mmnn,
                        v_movi_grav_mmee,
                        v_movi_exen_mmee,
                        v_movi_iva_mmee,
                        v_movi_grav_mone,
                        v_movi_exen_mone,
                        v_movi_iva_mone,
                        v_movi_obse,
                        v_movi_sald_mmnn,
                        v_movi_sald_mmee,
                        v_movi_sald_mone,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_empr_codi,
                        v_movi_empl_codi,
                        v_movi_fech_oper,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_base);
  
    v_moco_movi_codi := p_movi_codi;
    v_moco_nume_item := 1;
    v_moco_conc_codi := p_codi_conc_canj_cheq;
    v_moco_cuco_codi := p_cuco_codi;
    v_moco_impu_codi := p_codi_impu_exen;
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := null;
    v_moco_impo_mone := v_movi_exen_mone;
    v_moco_base      := p_codi_base;
  
    pp_devu_dbcr_conc(v_moco_conc_codi, v_moco_dbcr);
  
    pp_insert_come_movi_conc_deta(v_moco_movi_codi,
                                  v_moco_nume_item,
                                  v_moco_conc_codi,
                                  v_moco_cuco_codi,
                                  v_moco_impu_codi,
                                  v_moco_impo_mmnn,
                                  v_moco_impo_mmee,
                                  v_moco_impo_mone,
                                  v_moco_dbcr,
                                  v_moco_base);
  
    v_moim_impu_codi := p_codi_impu_exen;
    v_moim_movi_codi := p_movi_codi;
    v_moim_impo_mmnn := v_movi_exen_mmnn;
    v_moim_impo_mmee := null;
    v_moim_impu_mmnn := 0;
    v_moim_impu_mmee := null;
    v_moim_impo_mone := v_movi_exen_mone;
    v_moim_impu_mone := 0;
    v_moim_base      := p_codi_base;
  
    pp_insert_come_movi_impu_deta(v_moim_impu_codi,
                                  v_moim_movi_codi,
                                  v_moim_impo_mmnn,
                                  v_moim_impo_mmee,
                                  v_moim_impu_mmnn,
                                  v_moim_impu_mmee,
                                  v_moim_impo_mone,
                                  v_moim_impu_mone,
                                  v_moim_base);
  
    if nvl(bsel.impo_efec_mmnn, 0) > 0 then
      p_moim_nume_item := nvl(p_moim_nume_item, 0) + 1;
    
      v_moim_movi_codi := p_movi_codi;
      v_moim_nume_item := p_moim_nume_item;
      v_moim_tipo      := 'Efectivo';
      v_moim_cuen_codi := bsel.movi_cuen_codi;
      v_moim_dbcr      := p_movi_dbcr;
      v_moim_afec_caja := 'S';
      v_moim_fech      := bsel.movi_fech_emis;
      v_moim_impo_mone := bsel.impo_efec_mone; --v_movi_exen_mone;
      v_moim_impo_mmnn := bsel.impo_efec_mmnn; --v_movi_exen_mmnn;
      v_moim_base      := p_codi_base;
      v_moim_cheq_codi := null;
      v_moim_caja_codi := null;
      v_moim_impo_mmee := null;
      v_moim_asie_codi := null;
      v_moim_fech_oper := bsel.movi_fech_emis;
    
      pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                    v_moim_nume_item,
                                    v_moim_tipo,
                                    v_moim_cuen_codi,
                                    v_moim_dbcr,
                                    v_moim_afec_caja,
                                    v_moim_fech,
                                    v_moim_impo_mone,
                                    v_moim_impo_mmnn,
                                    v_moim_base,
                                    v_moim_cheq_codi,
                                    v_moim_caja_codi,
                                    v_moim_impo_mmee,
                                    v_moim_asie_codi,
                                    v_moim_fech_oper);
    
    end if;
  
  end pp_actualizar_come_movi_1;

  procedure pp_actualizar_come_cheq_1 is
    v_cheq_codi      number(20);
    v_cheq_mone_codi number(4);
    v_cheq_banc_codi number(4);
    v_cheq_nume      varchar2(30);
    v_cheq_serie     varchar2(3);
    v_cheq_fech_emis date;
    v_cheq_fech_venc date;
    v_cheq_impo_mone number(20, 4);
    v_cheq_impo_mmnn number(20, 4);
  
    v_cheq_sald_mone number(20, 4);
    v_cheq_sald_mmnn number(20, 4);
  
    v_cheq_tipo                varchar2(1);
    v_cheq_clpr_codi           number(20);
    v_cheq_esta                varchar2(1) := 'I';
    v_cheq_nume_cuen           varchar2(20);
    v_cheq_obse                varchar2(100);
    v_cheq_indi_ingr_manu      varchar2(1);
    v_cheq_cuen_codi           number(4);
    v_cheq_tasa_mone           number(20, 4);
    v_cheq_titu                varchar2(60);
    v_cheq_orde                varchar2(60);
    v_cheq_user                varchar2(10);
    v_cheq_fech_grab           date;
    v_cheq_base                number(2);
    v_cheq_tach_codi           number(4);
    v_cheq_caja_codi           number(20);
    v_cheq_orpa_codi           number(20);
    v_cheq_fech_depo           date;
    v_cheq_fech_rech           date;
    v_cheq_indi_terc           varchar2(1);
    v_cheq_indi_desc           varchar2(1);
    v_cheq_clpr_sucu_nume_item number;
  
    v_chmo_movi_codi number(20);
    v_chmo_cheq_codi number(20);
    v_chmo_esta_ante varchar2(2);
    v_chmo_cheq_secu number(4);
    v_chmo_base      number(2);
  
    v_moim_movi_codi number(20);
    v_moim_nume_item number(4);
    v_moim_tipo      varchar2(20);
    v_moim_cuen_codi number(4);
    v_moim_dbcr      varchar2(1);
    v_moim_afec_caja varchar2(1);
    v_moim_fech      date;
    v_moim_impo_mone number(20, 4);
    v_moim_impo_mmnn number(20, 4);
    v_moim_base      number(2);
    v_moim_cheq_codi number(20);
    v_moim_caja_codi number(20);
    v_moim_impo_mmee number(20, 4);
    v_moim_asie_codi number(20);
    v_moim_fech_oper date;
  
  begin
   
    for bcheq_reci in che_entra loop
    
      if bcheq_reci.cheq_nume is not null and
         nvl(bcheq_reci.cheq_impo_mone, 0) > 0 then
        v_cheq_codi := fa_sec_come_cheq;
        
       
        --- :bcheq_reci.cheq_codi := v_cheq_codi;
      
        v_cheq_mone_codi := bcheq_reci.cheq_mone_codi;
        v_cheq_banc_codi := bcheq_reci.cheq_banc_codi;
        v_cheq_nume      := bcheq_reci.cheq_nume;
        v_cheq_serie     := bcheq_reci.cheq_serie;
        v_cheq_fech_emis := bcheq_reci.cheq_fech_emis;
        v_cheq_fech_venc := bcheq_reci.cheq_fech_venc;
      
        v_cheq_impo_mone := bcheq_reci.cheq_impo_mone;
        v_cheq_impo_mmnn := bcheq_reci.cheq_impo_mmnn;
      
        v_cheq_sald_mone := bcheq_reci.cheq_impo_mone;
        v_cheq_sald_mmnn := bcheq_reci.cheq_impo_mmnn;
      
        v_cheq_tipo                := 'R';
        v_cheq_clpr_codi           := bsel.movi_clpr_codi;
        v_cheq_esta                := 'I';
        v_cheq_nume_cuen           := bcheq_reci.cheq_nume_cuen;
        v_cheq_obse                := bcheq_reci.cheq_obse;
        v_cheq_indi_ingr_manu      := 'N';
      
        v_cheq_cuen_codi           := bcheq_reci.cheq_cuen_codi;
        v_cheq_tasa_mone           := bcheq_reci.cheq_tasa_mone;
        v_cheq_titu                := bcheq_reci.cheq_titu;
        v_cheq_orde                := bcheq_reci.cheq_orde;
        v_cheq_user                := gen_user;
          
        v_cheq_fech_grab           := sysdate;
        v_cheq_base                := p_codi_base;
        
        v_cheq_tach_codi           := null;
        v_cheq_caja_codi           := null;
        v_cheq_orpa_codi           := null;
        v_cheq_fech_depo           := null;
        v_cheq_fech_rech           := null;
        -- raise_application_error(-20001,bcheq_reci.cheq_indi_terc);
        v_cheq_indi_terc           := bcheq_reci.cheq_indi_terc;
       
        v_cheq_indi_desc           := null;
        v_cheq_clpr_sucu_nume_item := bsel.sucu_nume_item;
      
        if v_cheq_clpr_sucu_nume_item = 0 then
          v_cheq_clpr_sucu_nume_item := null;
        end if;
        
          
        pp_insert_come_cheq(v_cheq_codi,
                            v_cheq_mone_codi,
                            v_cheq_banc_codi,
                            v_cheq_nume,
                            v_cheq_serie,
                            v_cheq_fech_emis,
                            v_cheq_fech_venc,
                            v_cheq_impo_mone,
                            v_cheq_impo_mmnn,
                            v_cheq_sald_mone,
                            v_cheq_sald_mmnn,
                            v_cheq_tipo,
                            v_cheq_clpr_codi,
                            v_cheq_esta,
                            v_cheq_nume_cuen,
                            v_cheq_obse,
                            v_cheq_indi_ingr_manu,
                            v_cheq_cuen_codi,
                            v_cheq_tasa_mone,
                            v_cheq_titu,
                            v_cheq_orde,
                            v_cheq_user,
                            v_cheq_fech_grab,
                            v_cheq_base,
                            v_cheq_tach_codi,
                            v_cheq_caja_codi,
                            v_cheq_orpa_codi,
                            v_cheq_fech_depo,
                            v_cheq_fech_rech,
                            v_cheq_indi_terc,
                            v_cheq_indi_desc,
                            v_cheq_clpr_sucu_nume_item);
      
        v_chmo_movi_codi := p_movi_codi;
        v_chmo_cheq_codi := v_cheq_codi;
        v_chmo_esta_ante := null;
        v_chmo_cheq_secu := 1;
        v_chmo_base      := p_codi_base;
      
        pp_insert_come_movi_cheq(v_chmo_movi_codi,
                                 v_chmo_cheq_codi,
                                 v_chmo_esta_ante,
                                 v_cheq_esta,
                                 v_chmo_cheq_secu,
                                 v_chmo_base);
      
        v_moim_movi_codi := p_movi_codi;
        p_moim_nume_item := nvl(p_moim_nume_item, 0) + 1;
        v_moim_nume_item := p_moim_nume_item;
      
        if bcheq_reci.cheq_fech_venc > bcheq_reci.cheq_fech_emis then
          v_moim_tipo := 'Cheq. Dif. Rec.';
        else
          v_moim_tipo := 'Cheq. Dia. Rec.';
        end if;
      
        v_moim_cuen_codi := bcheq_reci.cheq_cuen_codi;
        v_moim_dbcr      := p_movi_dbcr;
        v_moim_afec_caja := 'N';
        v_moim_fech      := bsel.movi_fech_emis;
        v_moim_impo_mone := bcheq_reci.cheq_impo_mone;
        v_moim_impo_mmnn := bcheq_reci.cheq_impo_mmnn;
        v_moim_base      := p_codi_base;
        v_moim_cheq_codi := v_cheq_codi;
        v_moim_caja_codi := null;
        v_moim_impo_mmee := null;
        v_moim_asie_codi := null;
        v_moim_fech_oper := bsel.movi_fech_emis;
      
        pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                      v_moim_nume_item,
                                      v_moim_tipo,
                                      v_moim_cuen_codi,
                                      v_moim_dbcr,
                                      v_moim_afec_caja,
                                      v_moim_fech,
                                      v_moim_impo_mone,
                                      v_moim_impo_mmnn,
                                      v_moim_base,
                                      v_moim_cheq_codi,
                                      v_moim_caja_codi,
                                      v_moim_impo_mmee,
                                      v_moim_asie_codi,
                                      v_moim_fech_oper);
      
        /******************************/
        update come_tabl_auxi
           set taax_c021 = v_cheq_codi
         where taax_sess = v('APP_SESSION')
           and taax_user = gen_user
           and taax_c019 = 'E'
           and taax_seq = bcheq_reci.taax_seq;
      
        /*****************************/
      end if;
    
    end loop;
  end pp_actualizar_come_cheq_1;

  /********************** Actualizacion de canje de cheque*******************************/

  procedure pp_actualizar_cheq_canj_1 is

  v_canj_movi_codi           number(20);
  v_canj_cheq_codi_sale      number(20);
  v_canj_nume_item           number(5);
  v_canj_impo_efec_mone      number(20, 4);
  v_canj_impo_efec_mmnn      number(20, 4);
  v_canj_impo_cheq_mone      number(20, 4);
  v_canj_impo_cheq_mmnn      number(20, 4);
  v_canj_obse                varchar2(2000);
  v_canj_base                number(2);
  v_canj_cheq_codi_entr      number(20);
  v_canj_user_auto_cheq_judi varchar2(20);
  v_canj_fech_auto_cheq_judi date;
  v_canj_mone_codi_sale      number(4);
  v_canj_tasa_mone_sale      number(20, 4);
  v_canj_cheq_mone_sale      number(20, 4);
  v_canj_efec_mone_sale      number(20, 4);

  v_clpr_user_canj_cheq_judi varchar2(20);
  v_clpr_fech_canj_cheq_judi date;
  v_indi_canj_cheq_judi      varchar2(1);

  v_tota_efec number(20, 4) := 0;
  v_sald_efec number(20, 4) := 0;

  type tr_cheq is record(
    cheq_codi           number(10),
    cheq_impo_mone      number(20, 4),
    cheq_sald_mone_apli number(20, 4));
  type tt_cheq is table of tr_cheq index by binary_integer;

  ta_cheq_entr tt_cheq;
  ta_cheq_sali tt_cheq;

  v_idx_entr number(10) := 0;
  v_idx_sali number(10) := 0;

  type tr_canj is record(
    canj_movi_codi      number(20),
    canj_nume_item      number(10),
    canj_cheq_codi_sale number(10),
    canj_cheq_codi_entr number(10),
    canj_impo_apli      number(20, 4),
    canj_impo_apli_efec number(20, 4),
    canj_impo_apli_cheq number(20, 4));

  type tt_canj is table of tr_canj index by binary_integer;

  ta_canj    tt_canj;
  v_idx_canj number(10) := 0;

  v_movi_codi number(20);
begin

  if bsel.filt_tipo_canj_cheq = 'J' then
    begin
      select clpr_user_canj_cheq_judi,
             clpr_fech_canj_cheq_judi,
             clpr_indi_canj_cheq_judi
        into v_clpr_user_canj_cheq_judi,
             v_clpr_fech_canj_cheq_judi,
             v_indi_canj_cheq_judi
        from come_clie_prov
       where clpr_codi = bsel.movi_clpr_codi;
    exception
      when others then
        v_clpr_user_canj_cheq_judi := null;
        v_clpr_fech_canj_cheq_judi := null;
      
    end;
  else
    v_clpr_user_canj_cheq_judi := null;
    v_clpr_fech_canj_cheq_judi := null;
  end if;

  v_movi_codi      := p_movi_codi;
  v_canj_nume_item := 0;
  v_tota_efec      := bsel.impo_efec_mone;
  v_sald_efec      := v_tota_efec;

 for bcheq_reci in che_entra loop
  if nvl(bcheq_reci.cheq_impo_mone, 0) > 0 then
    
      if nvl(bcheq_reci.cheq_impo_mone, 0) > 0 then
        v_idx_entr := v_idx_entr + 1;
        ta_cheq_entr(v_idx_entr).cheq_codi := bcheq_reci.cheq_codi;
        ta_cheq_entr(v_idx_entr).cheq_impo_mone := bcheq_reci.cheq_impo_mone;
        ta_cheq_entr(v_idx_entr).cheq_sald_mone_apli := ta_cheq_entr(v_idx_entr).cheq_impo_mone;
      end if;
    
   
  end if;
 end loop;
   for bcheq_sali in bcheq_sal loop
  if bcheq_sali.cheq_sald_mone > 0 then
    
      if bcheq_sali.cheq_sald_mone > 0 then
        v_idx_sali := v_idx_sali + 1;
        ta_cheq_sali(v_idx_sali).cheq_codi := bcheq_sali.cheq_codi;
        ta_cheq_sali(v_idx_sali).cheq_impo_mone := bcheq_sali.cheq_sald_mone;
        ta_cheq_sali(v_idx_sali).cheq_sald_mone_apli := ta_cheq_sali(v_idx_sali).cheq_impo_mone;
      end if;
     
  
  end if;
  end loop;
  --primero para efectivo
  v_idx_canj := 0;
  if v_sald_efec > 0 then
    for x in 1 .. ta_cheq_sali.count loop
      if ta_cheq_sali(x).cheq_sald_mone_apli > 0 then
        if v_sald_efec >= ta_cheq_sali(x).cheq_sald_mone_apli then
          v_idx_canj := v_idx_canj + 1;
          ta_canj(v_idx_canj).canj_movi_codi := v_movi_codi;
          ta_canj(v_idx_canj).canj_nume_item := v_idx_canj;
          ta_canj(v_idx_canj).canj_cheq_codi_sale := ta_cheq_sali(x).cheq_codi;
          ta_canj(v_idx_canj).canj_cheq_codi_entr := null; --efectivo
          ta_canj(v_idx_canj).canj_impo_apli := ta_cheq_sali(x).cheq_sald_mone_apli;
          v_sald_efec := v_sald_efec - ta_cheq_sali(x).cheq_sald_mone_apli;
          ta_canj(v_idx_canj).canj_impo_apli_efec := ta_canj(v_idx_canj).canj_impo_apli;
          ta_canj(v_idx_canj).canj_impo_apli_cheq := 0;
          ta_cheq_sali(x).cheq_sald_mone_apli := 0;
        else
          v_idx_canj := v_idx_canj + 1;
          ta_canj(v_idx_canj).canj_movi_codi := v_movi_codi;
          ta_canj(v_idx_canj).canj_nume_item := v_idx_canj;
          ta_canj(v_idx_canj).canj_cheq_codi_sale := ta_cheq_sali(x).cheq_codi;
          ta_canj(v_idx_canj).canj_cheq_codi_entr := null; --efectivo
          ta_canj(v_idx_canj).canj_impo_apli := v_sald_efec;
          v_sald_efec := 0;
          ta_canj(v_idx_canj).canj_impo_apli_efec := ta_canj(v_idx_canj).canj_impo_apli;
          ta_canj(v_idx_canj).canj_impo_apli_cheq := 0;
          ta_cheq_sali(x).cheq_sald_mone_apli := ta_cheq_sali(x).cheq_sald_mone_apli - ta_canj(v_idx_canj).canj_impo_apli;
        end if;
      end if;
      if v_sald_efec = 0 then
        exit;
      end if;
    end loop;
  end if;
  for x in 1 .. ta_cheq_sali.count loop
    if ta_cheq_sali(x).cheq_sald_mone_apli > 0 then
      for z in 1 .. ta_cheq_entr.count loop
        if ta_cheq_entr(z).cheq_sald_mone_apli > 0 then
          if ta_cheq_entr(z).cheq_sald_mone_apli >= ta_cheq_sali(x).cheq_sald_mone_apli then
            v_idx_canj := v_idx_canj + 1;
            ta_canj(v_idx_canj).canj_movi_codi := v_movi_codi;
            ta_canj(v_idx_canj).canj_nume_item := v_idx_canj;
            ta_canj(v_idx_canj).canj_cheq_codi_sale := ta_cheq_sali(x).cheq_codi;
            ta_canj(v_idx_canj).canj_cheq_codi_entr := ta_cheq_entr(z).cheq_codi;
            ta_canj(v_idx_canj).canj_impo_apli := ta_cheq_sali(x).cheq_sald_mone_apli;
            ta_canj(v_idx_canj).canj_impo_apli_efec := 0;
            ta_canj(v_idx_canj).canj_impo_apli_cheq := ta_canj(v_idx_canj).canj_impo_apli;
            ta_cheq_sali(x).cheq_sald_mone_apli := 0;
            ta_cheq_entr(z).cheq_sald_mone_apli := ta_cheq_entr(z).cheq_sald_mone_apli - ta_canj(v_idx_canj).canj_impo_apli;
            exit;
          else
            v_idx_canj := v_idx_canj + 1;
            ta_canj(v_idx_canj).canj_movi_codi := v_movi_codi;
            ta_canj(v_idx_canj).canj_nume_item := v_idx_canj;
            ta_canj(v_idx_canj).canj_cheq_codi_sale := ta_cheq_sali(x).cheq_codi;
            ta_canj(v_idx_canj).canj_cheq_codi_entr := ta_cheq_entr(z).cheq_codi;
            ta_canj(v_idx_canj).canj_impo_apli := ta_cheq_entr(z).cheq_sald_mone_apli;
            ta_cheq_entr(z).cheq_sald_mone_apli := 0;
            ta_canj(v_idx_canj).canj_impo_apli_efec := 0;
            ta_canj(v_idx_canj).canj_impo_apli_cheq := ta_canj(v_idx_canj).canj_impo_apli;
            ta_cheq_sali(x).cheq_sald_mone_apli := ta_cheq_sali(x).cheq_sald_mone_apli - ta_canj(v_idx_canj).canj_impo_apli;
          
          end if;
        end if;
      end loop;
    end if;
  end loop;
  v_canj_nume_item := 0;
  if ta_canj.count > 0 then
    for x in 1 .. ta_canj.count loop
      if nvl(ta_canj(x).canj_impo_apli, 0) > 0 then
        v_canj_movi_codi           := ta_canj(x).canj_movi_codi;
        v_canj_cheq_codi_sale      := ta_canj(x).canj_cheq_codi_sale;
        v_canj_nume_item           := nvl(v_canj_nume_item, 0) + 1;
        v_canj_impo_efec_mone      := ta_canj(x).canj_impo_apli_efec;
        v_canj_impo_efec_mmnn      := round(ta_canj(x).canj_impo_apli_efec *
                                             bsel.movi_tasa_mone,
                                            0);
        v_canj_impo_cheq_mone      := ta_canj(x).canj_impo_apli_cheq;
        v_canj_impo_cheq_mmnn      := round(ta_canj(x).canj_impo_apli_cheq *
                                             bsel.movi_tasa_mone,
                                            0);
        v_canj_obse                := null;
        v_canj_base                := 01;
        v_canj_cheq_codi_entr      := ta_canj(x).canj_cheq_codi_entr;
        v_canj_user_auto_cheq_judi := v_clpr_user_canj_cheq_judi;
        v_canj_fech_auto_cheq_judi := v_clpr_fech_canj_cheq_judi;
        v_canj_mone_codi_sale      := bsel.mone_codi;
        v_canj_tasa_mone_sale      := bsel.movi_tasa_mone;
        v_canj_cheq_mone_sale      := v_canj_impo_cheq_mone;
        v_canj_efec_mone_sale      := v_canj_impo_efec_mone;
      
        insert into come_movi_cheq_canj
          (canj_movi_codi,
           canj_cheq_codi_sale,
           canj_nume_item,
           canj_impo_efec_mone,
           canj_impo_efec_mmnn,
           canj_impo_cheq_mone,
           canj_impo_cheq_mmnn,
           canj_obse,
           canj_base,
           canj_cheq_codi_entr,
           canj_user_auto_cheq_judi,
           canj_fech_auto_cheq_judi,
           canj_mone_codi_sale,
           canj_tasa_mone_sale,
           canj_cheq_mone_sale,
           canj_efec_mone_sale)
        values
          (v_canj_movi_codi,
           v_canj_cheq_codi_sale,
           v_canj_nume_item,
           v_canj_impo_efec_mone,
           v_canj_impo_efec_mmnn,
           v_canj_impo_cheq_mone,
           v_canj_impo_cheq_mmnn,
           v_canj_obse,
           v_canj_base,
           v_canj_cheq_codi_entr,
           v_canj_user_auto_cheq_judi,
           v_canj_fech_auto_cheq_judi,
           v_canj_mone_codi_sale,
           v_canj_tasa_mone_sale,
           v_canj_cheq_mone_sale,
           v_canj_efec_mone_sale);
      end if;
    end loop;
  end if;

end pp_actualizar_cheq_canj_1;

-------------------------------------
  procedure pp_actualizar_come_movi_adel_1 is
    v_movi_codi                number(20);
    v_movi_timo_codi           number(10);
    v_movi_clpr_codi           number(20);
    v_movi_sucu_codi_orig      number(10);
    v_movi_cuen_codi           number(4);
    v_movi_mone_codi           number(4);
    v_movi_nume                number(20);
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(20);
    v_movi_codi_padr           number(20);
    v_movi_tasa_mone           number(20, 4);
    v_movi_tasa_mmee           number(20, 4);
    v_movi_grav_mmnn           number(20, 4);
    v_movi_exen_mmnn           number(20, 4);
    v_movi_iva_mmnn            number(20, 4);
    v_movi_grav_mmee           number(20, 4);
    v_movi_exen_mmee           number(20, 4);
    v_movi_iva_mmee            number(20, 4);
    v_movi_grav_mone           number(20, 4);
    v_movi_exen_mone           number(20, 4);
    v_movi_iva_mone            number(20, 4);
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number(20, 4);
    v_movi_sald_mmee           number(20, 4);
    v_movi_sald_mone           number(20, 4);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_empr_codi           number(2);
    v_movi_empl_codi           number(10);
    v_movi_fech_oper           date;
    v_movi_base                number(2);
    v_movi_clpr_sucu_nume_item number;
  
    v_tica_codi number;
    v_dife      number;
  begin
  
    -- se agrega esta condicion porque no se encuentra la razon por la que se limpia el parametro
    if p_movi_codi is null then
      p_movi_codi := p_movi_codi_auxi;
    end if;
  
    -- asignar valores....
    v_dife := (nvl(bsel.impo_efec_mone_sale, 0) +
              nvl(bsel.sum_cheq_impo_mone, 0)) - nvl(bsel.cheq_sald_sal, 0);
  
    v_movi_tasa_mone := BSEL.movi_tasa_mone;
    v_movi_exen_mmnn := round(v_dife * v_movi_tasa_mone, p_cant_deci_mmnn);
  
    v_movi_codi           := fa_sec_come_movi;
    p_movi_codi_adel      := v_movi_codi;
    v_movi_timo_codi      := p_codi_timo_adle;
    v_movi_clpr_codi      := BSEL.movi_clpr_codi;
    v_movi_sucu_codi_orig := p_sucu_codi;
    v_movi_cuen_codi      := null;
    v_movi_mone_codi      := BSEL.mone_codi;
    v_movi_nume           := BSEL.movi_nume_adel; --marce BSEL.movi_nume;
    v_movi_fech_emis      := BSEL.movi_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := user;
    v_movi_codi_padr      := p_movi_codi;
  
    v_movi_tasa_mmee := null;
    v_movi_grav_mmnn := 0;
  
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := v_dife;
    v_movi_iva_mone            := 0;
    v_movi_obse                := null;
    v_movi_sald_mmnn           := v_dife;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := v_dife;
    v_movi_empr_codi           := p_empr_codi;
    v_movi_empl_codi           := BSEL.movi_empl_codi; --marce null;
    v_movi_fech_oper           := BSEL.movi_fech_emis;
    v_movi_base                := p_codi_base;
    v_movi_clpr_sucu_nume_item := BSEL.sucu_nume_item;
  
    pp_muestra_tipo_movi(p_codi_timo_adle,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_cuen_codi,
                        v_movi_mone_codi,
                        v_movi_nume,
                        v_movi_fech_emis,
                        v_movi_fech_grab,
                        v_movi_user,
                        v_movi_codi_padr,
                        v_movi_tasa_mone,
                        v_movi_tasa_mmee,
                        v_movi_grav_mmnn,
                        v_movi_exen_mmnn,
                        v_movi_iva_mmnn,
                        v_movi_grav_mmee,
                        v_movi_exen_mmee,
                        v_movi_iva_mmee,
                        v_movi_grav_mone,
                        v_movi_exen_mone,
                        v_movi_iva_mone,
                        v_movi_obse,
                        v_movi_sald_mmnn,
                        v_movi_sald_mmee,
                        v_movi_sald_mone,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_empr_codi,
                        v_movi_empl_codi,
                        v_movi_fech_oper,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_base);
  
  end pp_actualizar_come_movi_adel_1;

  /***********************INICIAAAAR ****************/
  procedure pp_iniciar(o_tica_codi      out number,
                       o_cuco_codi      out number,
                       o_cuco_codi_adel out number) is
  begin
  
    ------limpiar tablas a utilizar
    delete from come_tabl_auxi
     where taax_sess = v('APP_SESSION')
       and taax_user = gen_user
       and taax_c019 = 'E';
    apex_collection.create_or_truncate_collection(p_collection_name => 'BCHEQ_SALI');
  
    begin
      select m.timo_tica_codi
        into p_tica_codi
        from come_tipo_movi m
       where m.timo_codi = p_codi_timo_canj_cheq;
    exception
      when no_data_found then
        raise_application_error(-20010,
                                'No existe el tipo de movimiento configurado en el parametro p_codi_timo_canj_cheq');
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
    begin
      select c.conc_cuco_codi
        into p_cuco_codi
        from come_conc c
       where c.conc_codi = p_codi_conc_canj_cheq;
    exception
      when no_data_found then
        null;
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
    begin
      select c.conc_cuco_codi
        into p_cuco_codi_adel
        from come_conc c
       where c.conc_codi = p_codi_conc_adle;
    exception
      when no_data_found then
        null;
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
    o_tica_codi      := p_tica_codi;
    o_cuco_codi      := p_cuco_codi;
    o_cuco_codi_adel := p_cuco_codi_adel;
  
  end pp_iniciar;

  /**************** INSERTTSSS **********************/
  procedure pp_manej_cheq_entr(v_indi      in varchar2,
                               v_taax_c001 in varchar2,
                               v_taax_c002 in varchar2,
                               v_taax_c003 in varchar2,
                               v_taax_c004 in varchar2,
                               v_taax_c005 in varchar2,
                               v_taax_c006 in varchar2,
                               v_taax_c007 in varchar2,
                               v_taax_c008 in varchar2,
                               v_taax_c009 in varchar2,
                               v_taax_c010 in varchar2 default sysdate,
                               v_taax_c011 in varchar2 default sysdate,
                               v_taax_c012 in varchar2,
                               v_taax_c013 in varchar2,
                               v_taax_c014 in varchar2,
                               v_taax_c015 in varchar2,
                               v_taax_c016 in varchar2,
                               v_taax_c017 in varchar2,
                               v_taax_c018 in varchar2,
                               v_taax_seq  in number) is
    v_cheq_impo_mmnn      number;
    v_cheq_impo_mone_sale number;
  begin
    
  

  
  
    if v_indi = 'I' then
    
      begin
        pp_set_variable;
        I020222.pp_validar_import_rec(p_cheq_impo_mone      => v_taax_c015,
                                      p_cheq_tasa_mone      => v_taax_c014,
                                      p_cheq_impo_mmnn      => v_cheq_impo_mmnn,
                                      p_cheq_impo_mone_sale => v_cheq_impo_mone_sale);
      end;
      
        if v_taax_c002 is null then
    raise_application_error(-20001,'Debe ingresar el Numero de Cheque Rec.!!!');
    end if;
    
    if v_taax_c003 is null then
    raise_application_error(-20001,'Debe ingresar la caja.');
    end if;
      if v_taax_c007 is null then
    raise_application_error(-20001,'Debe ingresar el banco.');
    end if;
    
   if v_taax_c009 is null then    
	 raise_application_error(-20001,'Debe ingresar el Numero de cuenta del Cheque');
   end if;
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_c011,
         taax_c012,
         taax_c013,
         taax_c014,
         taax_c015,
         taax_c016,
         taax_c017,
         taax_c018,
         taax_c019,
         taax_c020,
         taax_c021,
         taax_c022,
         taax_seq)
      values
        (v('APP_SESSION'),
         gen_user,
         v_taax_c001,
         v_taax_c002,
         v_taax_c003,
         v_taax_c004,
         v_taax_c005,
         v_taax_c006,
         v_taax_c007,
         v_taax_c008,
         v_taax_c009,
         nvl(v_taax_c010,sysdate),
         nvl(v_taax_c011,sysdate),
         v_taax_c012,
         v_taax_c013,
         v_taax_c014,
         v_taax_c015,
         v_taax_c016,
         v_taax_c017,
         v_taax_c018,
         'E',
         v_cheq_impo_mone_sale,
         v_cheq_impo_mone_sale,
         v_cheq_impo_mmnn,
         seq_come_tabl_auxi.nextval);
    
    elsif v_indi = 'D' then
    
      delete come_tabl_auxi where taax_seq = v_taax_seq;
    
    end if;
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_insert_come_movi(p_movi_codi                in number,
                                p_movi_timo_codi           in number,
                                p_movi_clpr_codi           in number,
                                p_movi_sucu_codi_orig      in number,
                                p_movi_cuen_codi           in number,
                                p_movi_mone_codi           in number,
                                p_movi_nume                in number,
                                p_movi_fech_emis           in date,
                                p_movi_fech_grab           in date,
                                p_movi_user                in varchar2,
                                p_movi_codi_padr           in number,
                                p_movi_tasa_mone           in number,
                                p_movi_tasa_mmee           in number,
                                p_movi_grav_mmnn           in number,
                                p_movi_exen_mmnn           in number,
                                p_movi_iva_mmnn            in number,
                                p_movi_grav_mmee           in number,
                                p_movi_exen_mmee           in number,
                                p_movi_iva_mmee            in number,
                                p_movi_grav_mone           in number,
                                p_movi_exen_mone           in number,
                                p_movi_iva_mone            in number,
                                p_movi_obse                in varchar2,
                                p_movi_sald_mmnn           in number,
                                p_movi_sald_mmee           in number,
                                p_movi_sald_mone           in number,
                                p_movi_emit_reci           in varchar2,
                                p_movi_afec_sald           in varchar2,
                                p_movi_dbcr                in varchar2,
                                p_movi_empr_codi           in number,
                                p_movi_empl_codi           in number,
                                p_movi_fech_oper           in date,
                                p_movi_clpr_sucu_nume_item in number,
                                p_movi_base                in number) is
  begin
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_cuen_codi,
       movi_mone_codi,
       movi_nume,
       movi_fech_emis,
       movi_fech_grab,
       movi_user,
       movi_codi_padr,
       movi_tasa_mone,
       movi_tasa_mmee,
       movi_grav_mmnn,
       movi_exen_mmnn,
       movi_iva_mmnn,
       movi_grav_mmee,
       movi_exen_mmee,
       movi_iva_mmee,
       movi_grav_mone,
       movi_exen_mone,
       movi_iva_mone,
       movi_obse,
       movi_sald_mmnn,
       movi_sald_mmee,
       movi_sald_mone,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_empr_codi,
       movi_empl_codi,
       movi_fech_oper,
       movi_clpr_sucu_nume_item,
       movi_base)
    values
      (p_movi_codi,
       p_movi_timo_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
       p_movi_cuen_codi,
       p_movi_mone_codi,
       p_movi_nume,
       p_movi_fech_emis,
       p_movi_fech_grab,
       p_movi_user,
       p_movi_codi_padr,
       p_movi_tasa_mone,
       p_movi_tasa_mmee,
       p_movi_grav_mmnn,
       p_movi_exen_mmnn,
       p_movi_iva_mmnn,
       p_movi_grav_mmee,
       p_movi_exen_mmee,
       p_movi_iva_mmee,
       p_movi_grav_mone,
       p_movi_exen_mone,
       p_movi_iva_mone,
       p_movi_obse,
       p_movi_sald_mmnn,
       p_movi_sald_mmee,
       p_movi_sald_mone,
       p_movi_emit_reci,
       p_movi_afec_sald,
       p_movi_dbcr,
       p_movi_empr_codi,
       p_movi_empl_codi,
       p_movi_fech_oper,
       p_movi_clpr_sucu_nume_item,
       p_movi_base);
  
  end;

  procedure pp_insert_come_movi_conc_deta(p_moco_movi_codi in number,
                                          p_moco_nume_item in number,
                                          p_moco_conc_codi in number,
                                          p_moco_cuco_codi in number,
                                          p_moco_impu_codi in number,
                                          p_moco_impo_mmnn in number,
                                          p_moco_impo_mmee in number,
                                          p_moco_impo_mone in number,
                                          p_moco_dbcr      in varchar2,
                                          p_moco_base      in number) is
  
  begin
    insert into come_movi_conc_deta
      (moco_movi_codi,
       moco_nume_item,
       moco_conc_codi,
       moco_cuco_codi,
       moco_impu_codi,
       moco_impo_mmnn,
       moco_impo_mmee,
       moco_impo_mone,
       moco_dbcr,
       moco_base)
    values
      (p_moco_movi_codi,
       p_moco_nume_item,
       p_moco_conc_codi,
       p_moco_cuco_codi,
       p_moco_impu_codi,
       p_moco_impo_mmnn,
       p_moco_impo_mmee,
       p_moco_impo_mone,
       p_moco_dbcr,
       p_moco_base);
  
  end;

  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi in number,
                                          p_moim_movi_codi in number,
                                          p_moim_impo_mmnn in number,
                                          p_moim_impo_mmee in number,
                                          p_moim_impu_mmnn in number,
                                          p_moim_impu_mmee in number,
                                          p_moim_impo_mone in number,
                                          p_moim_impu_mone in number,
                                          p_moim_base      in number) is
  begin
    insert into come_movi_impu_deta
      (moim_impu_codi,
       moim_movi_codi,
       moim_impo_mmnn,
       moim_impo_mmee,
       moim_impu_mmnn,
       moim_impu_mmee,
       moim_impo_mone,
       moim_impu_mone,
       moim_base)
    values
      (p_moim_impu_codi,
       p_moim_movi_codi,
       p_moim_impo_mmnn,
       p_moim_impo_mmee,
       p_moim_impu_mmnn,
       p_moim_impu_mmee,
       p_moim_impo_mone,
       p_moim_impu_mone,
       p_moim_base);
  
  end;

  procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi in number,
                                          p_moim_nume_item in number,
                                          p_moim_tipo      in varchar2,
                                          p_moim_cuen_codi in number,
                                          p_moim_dbcr      in varchar2,
                                          p_moim_afec_caja in varchar2,
                                          p_moim_fech      in date,
                                          p_moim_impo_mone in number,
                                          p_moim_impo_mmnn in number,
                                          p_moim_base      in number,
                                          p_moim_cheq_codi in number,
                                          p_moim_caja_codi in number,
                                          p_moim_impo_mmee in number,
                                          p_moim_asie_codi in number,
                                          p_moim_fech_oper in date) is
  begin
    insert into come_movi_impo_deta
      (moim_movi_codi,
       moim_nume_item,
       moim_tipo,
       moim_cuen_codi,
       moim_dbcr,
       moim_afec_caja,
       moim_fech,
       moim_impo_mone,
       moim_impo_mmnn,
       moim_base,
       moim_cheq_codi,
       moim_caja_codi,
       moim_impo_mmee,
       moim_asie_codi,
       moim_fech_oper)
    values
      (p_moim_movi_codi,
       p_moim_nume_item,
       p_moim_tipo,
       p_moim_cuen_codi,
       p_moim_dbcr,
       p_moim_afec_caja,
       p_moim_fech,
       p_moim_impo_mone,
       p_moim_impo_mmnn,
       p_moim_base,
       p_moim_cheq_codi,
       p_moim_caja_codi,
       p_moim_impo_mmee,
       p_moim_asie_codi,
       p_moim_fech_oper);
  
    if rtrim(ltrim(lower(p_moim_tipo))) = 'efectivo' then
      update come_movi
         set movi_cuen_codi = p_moim_cuen_codi
       where movi_codi = p_moim_movi_codi;
    end if;
  
  end;
  /*
  procedure pp_insert_come_cheq(p_cheq_codi                in number,
                                p_cheq_mone_codi           in number,
                                p_cheq_banc_codi           in number,
                                p_cheq_nume                in varchar2,
                                p_cheq_serie               in varchar2,
                                p_cheq_fech_emis           in date,
                                p_cheq_fech_venc           in date,
                                p_cheq_impo_mone           in number,
                                p_cheq_impo_mmnn           in number,
                                p_cheq_tipo                in varchar2,
                                p_cheq_clpr_codi           in number,
                                p_cheq_esta                in varchar2,
                                p_cheq_nume_cuen           in varchar2,
                                p_cheq_obse                in varchar2,
                                p_cheq_indi_ingr_manu      in varchar2,
                                p_cheq_cuen_codi           in number,
                                p_cheq_tasa_mone           in number,
                                p_cheq_titu                in varchar2,
                                p_cheq_orde                in varchar2,
                                p_cheq_user                in varchar2,
                                p_cheq_fech_grab           in date,
                                p_cheq_base                in number,
                                p_cheq_tach_codi           in number,
                                p_cheq_caja_codi           in number,
                                p_cheq_orpa_codi           in number,
                                p_cheq_fech_depo           in date,
                                p_cheq_fech_rech           in date,
                                p_cheq_indi_terc           in varchar2,
                                p_cheq_indi_desc           in varchar2,
                                p_cheq_clpr_sucu_nume_item in number) is
  begin
    insert into come_cheq
      (cheq_codi,
       cheq_mone_codi,
       cheq_banc_codi,
       cheq_nume,
       cheq_serie,
       cheq_fech_emis,
       cheq_fech_venc,
       cheq_impo_mone,
       cheq_impo_mmnn,
       cheq_tipo,
       cheq_clpr_codi,
       cheq_esta,
       cheq_nume_cuen,
       cheq_obse,
       cheq_indi_ingr_manu,
       cheq_cuen_codi,
       cheq_tasa_mone,
       cheq_titu,
       cheq_orde,
       cheq_user,
       cheq_fech_grab,
       cheq_base,
       cheq_tach_codi,
       cheq_caja_codi,
       cheq_orpa_codi,
       cheq_fech_depo,
       cheq_fech_rech,
       cheq_indi_terc,
       cheq_indi_desc,
       cheq_clpr_sucu_nume_item)
    values
      (p_cheq_codi,
       p_cheq_mone_codi,
       p_cheq_banc_codi,
       p_cheq_nume,
       p_cheq_serie,
       p_cheq_fech_emis,
       p_cheq_fech_venc,
       p_cheq_impo_mone,
       p_cheq_impo_mmnn,
       p_cheq_tipo,
       p_cheq_clpr_codi,
       p_cheq_esta,
       p_cheq_nume_cuen,
       p_cheq_obse,
       p_cheq_indi_ingr_manu,
       p_cheq_cuen_codi,
       p_cheq_tasa_mone,
       p_cheq_titu,
       p_cheq_orde,
       p_cheq_user,
       p_cheq_fech_grab,
       p_cheq_base,
       p_cheq_tach_codi,
       p_cheq_caja_codi,
       p_cheq_orpa_codi,
       p_cheq_fech_depo,
       p_cheq_fech_rech,
       p_cheq_indi_terc,
       p_cheq_indi_desc,
       p_cheq_clpr_sucu_nume_item);
  
  end;
  
  
  */

  procedure pp_insert_come_cheq(p_cheq_codi                in number,
                                p_cheq_mone_codi           in number,
                                p_cheq_banc_codi           in number,
                                p_cheq_nume                in varchar2,
                                p_cheq_serie               in varchar2,
                                p_cheq_fech_emis           in date,
                                p_cheq_fech_venc           in date,
                                p_cheq_impo_mone           in number,
                                p_cheq_impo_mmnn           in number,
                                p_cheq_sald_mone           in number,
                                p_cheq_sald_mmnn           in number,
                                p_cheq_tipo                in varchar2,
                                p_cheq_clpr_codi           in number,
                                p_cheq_esta                in varchar2,
                                p_cheq_nume_cuen           in varchar2,
                                p_cheq_obse                in varchar2,
                                p_cheq_indi_ingr_manu      in varchar2,
                                p_cheq_cuen_codi           in number,
                                p_cheq_tasa_mone           in number,
                                p_cheq_titu                in varchar2,
                                p_cheq_orde                in varchar2,
                                p_cheq_user                in varchar2,
                                p_cheq_fech_grab           in date,
                                p_cheq_base                in number,
                                p_cheq_tach_codi           in number,
                                p_cheq_caja_codi           in number,
                                p_cheq_orpa_codi           in number,
                                p_cheq_fech_depo           in date,
                                p_cheq_fech_rech           in date,
                                p_cheq_indi_terc           in varchar2,
                                p_cheq_indi_desc           in varchar2,
                                p_cheq_clpr_sucu_nume_item in number) is
  begin
    insert into come_cheq
      (cheq_codi,
       cheq_mone_codi,
       cheq_banc_codi,
       cheq_nume,
       cheq_serie,
       cheq_fech_emis,
       cheq_fech_venc,
       cheq_impo_mone,
       cheq_impo_mmnn,
       cheq_tipo,
       cheq_clpr_codi,
       cheq_esta,
       cheq_nume_cuen,
       cheq_obse,
       cheq_indi_ingr_manu,
       cheq_cuen_codi,
       cheq_tasa_mone,
       cheq_titu,
       cheq_orde,
       cheq_user,
       cheq_fech_grab,
       cheq_base,
       cheq_tach_codi,
       cheq_caja_codi,
       cheq_orpa_codi,
       cheq_fech_depo,
       cheq_fech_rech,
       cheq_indi_terc,
       cheq_indi_desc,
       cheq_clpr_sucu_nume_item,
       cheq_sald_mone,
       cheq_sald_mmnn)
    values
      (p_cheq_codi,
       p_cheq_mone_codi,
       p_cheq_banc_codi,
       p_cheq_nume,
       p_cheq_serie,
       p_cheq_fech_emis,
       p_cheq_fech_venc,
       p_cheq_impo_mone,
       p_cheq_impo_mmnn,
       p_cheq_tipo,
       p_cheq_clpr_codi,
       p_cheq_esta,
       p_cheq_nume_cuen,
       p_cheq_obse,
       p_cheq_indi_ingr_manu,
       p_cheq_cuen_codi,
       p_cheq_tasa_mone,
       p_cheq_titu,
       p_cheq_orde,
       p_cheq_user,
       p_cheq_fech_grab,
       p_cheq_base,
       p_cheq_tach_codi,
       p_cheq_caja_codi,
       p_cheq_orpa_codi,
       p_cheq_fech_depo,
       p_cheq_fech_rech,
       p_cheq_indi_terc,
       p_cheq_indi_desc,
       p_cheq_clpr_sucu_nume_item,
       p_cheq_sald_mone,
       p_cheq_sald_mmnn);
  
  exception
    when others then
      pl_me(sqlerrm);
  end pp_insert_come_cheq;

  procedure pp_insert_come_movi_cheq(p_chmo_movi_codi in number,
                                     p_chmo_cheq_codi in number,
                                     p_chmo_esta_ante in varchar2,
                                     p_chmo_cheq_esta in varchar2,
                                     p_chmo_cheq_secu in number,
                                     p_chmo_base      in number) is
  
  begin
    insert into come_movi_cheq
      (chmo_movi_codi,
       chmo_cheq_codi,
       chmo_esta_ante,
       chmo_cheq_esta,
       chmo_cheq_secu,
       chmo_base)
    values
      (p_chmo_movi_codi,
       p_chmo_cheq_codi,
       p_chmo_esta_ante,
       p_chmo_cheq_esta,
       p_chmo_cheq_secu,
       p_chmo_base);
  
  end;

  procedure pp_insert_come_movi_cheq_canj(p_canj_movi_codi           number,
                                          p_canj_cheq_codi_sale      number,
                                          p_canj_cheq_codi_entr      number,
                                          p_canj_nume_item           number,
                                          p_canj_impo_efec_mone      number,
                                          p_canj_impo_efec_mmnn      number,
                                          p_canj_impo_cheq_mone      number,
                                          p_canj_impo_cheq_mmnn      number,
                                          p_canj_obse                varchar2,
                                          p_clpr_user_canj_cheq_judi varchar2,
                                          p_clpr_fech_canj_cheq_judi date,
                                          p_canj_base                number,
                                          p_canj_mone_codi_sale      number,
                                          p_canj_tasa_mone_sale      number,
                                          p_canj_cheq_mone_sale      number,
                                          p_cant_efec_mone_sale      number) is
  begin
    insert into come_movi_cheq_canj
      (canj_movi_codi,
       canj_cheq_codi_sale,
       canj_cheq_codi_entr,
       canj_nume_item,
       canj_impo_efec_mone,
       canj_impo_efec_mmnn,
       canj_impo_cheq_mone,
       canj_impo_cheq_mmnn,
       canj_obse,
       canj_user_auto_cheq_judi,
       canj_fech_auto_cheq_judi,
       canj_base,
       CANJ_MONE_CODI_SALE,
       CANJ_TASA_MONE_SALE,
       CANJ_CHEQ_MONE_SALE,
       CANJ_EFEC_MONE_SALE)
    values
      (p_canj_movi_codi,
       p_canj_cheq_codi_sale,
       p_canj_cheq_codi_entr,
       p_canj_nume_item,
       p_canj_impo_efec_mone,
       p_canj_impo_efec_mmnn,
       p_canj_impo_cheq_mone,
       p_canj_impo_cheq_mmnn,
       p_canj_obse,
       p_clpr_user_canj_cheq_judi,
       p_clpr_fech_canj_cheq_judi,
       p_canj_base,
       p_canj_mone_codi_sale,
       p_canj_tasa_mone_sale,
       p_canj_cheq_mone_sale,
       p_cant_efec_mone_sale);
  
  end;

  /*************ADELANTO *******************************/
  procedure pp_insert_come_movi_cuot_adel(p_cuot_fech_venc in date,
                                          p_cuot_nume      in number,
                                          p_cuot_impo_mone in number,
                                          p_cuot_impo_mmnn in number,
                                          p_cuot_impo_mmee in number,
                                          p_cuot_sald_mone in number,
                                          p_cuot_sald_mmnn in number,
                                          p_cuot_sald_mmee in number,
                                          p_cuot_movi_codi in number) is
  begin
    insert into come_movi_cuot
      (cuot_fech_venc,
       cuot_nume,
       cuot_impo_mone,
       cuot_impo_mmnn,
       cuot_impo_mmee,
       cuot_sald_mone,
       cuot_sald_mmnn,
       cuot_sald_mmee,
       cuot_movi_codi,
       cuot_base)
    values
      (p_cuot_fech_venc,
       p_cuot_nume,
       p_cuot_impo_mone,
       p_cuot_impo_mmnn,
       p_cuot_impo_mmee,
       p_cuot_sald_mone,
       p_cuot_sald_mmnn,
       p_cuot_sald_mmee,
       p_cuot_movi_codi,
       p_codi_base);
  
  end;

  /**************** VALIDACIONES Y CONFIGURACIONES ***********************/
  procedure pp_busc_nume(p_movi_nume out number) is
  begin
    select nvl(max(m.movi_nume), 0) + 1
      into p_movi_nume
      from come_movi m
     where m.movi_timo_codi = p_codi_timo_canj_cheq;
  
  exception
    when no_data_found then
      p_movi_nume := 1;
    when others then
      raise_application_error(-20010,
                              ' ' || p_codi_timo_canj_cheq || sqlerrm);
  end;

  procedure pp_valida_fech(p_fech in date) is
  begin
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    if p_fech not between p_fech_inic and p_fech_fini then
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                              to_char(p_fech_fini, 'dd-mm-yyyy'));
    end if;
  end pp_valida_fech;

  procedure pp_valida_cliente(i_clpr_codi_alte      in number,
                              i_filt_tipo_canj_cheq in varchar2) is
  begin
    if i_clpr_codi_alte is not null then
      i020222.pp_validar_clpr_auto_cheq_judi('C',
                                             i_clpr_codi_alte,
                                             i_filt_tipo_canj_cheq);
    else
      raise_application_error(-20010, 'Debe indicar un cliente');
    end if;
  
  end pp_valida_cliente;

  procedure pp_validar_clpr_auto_cheq_judi(i_indi_clpr           in varchar2,
                                           i_clpr_codi_alte      in number,
                                           i_filt_tipo_canj_cheq in varchar2) is
    v_count number;
  
  begin
    select count(*)
      into v_count
      from come_clie_prov cp
     where cp.clpr_indi_clie_prov = i_indi_clpr
       and cp.clpr_codi_alte = i_clpr_codi_alte
       and ((clpr_indi_canj_cheq_judi = 'S' and i_filt_tipo_canj_cheq = 'J') or
           (i_filt_tipo_canj_cheq = 'R'));
  
    if v_count = 0 then
      if i_filt_tipo_canj_cheq = 'J' then
        raise_application_error(-20010,
                                'El Cliente no esta Autorizado para canje de Cheques Judiciales!');
      else
        raise_application_error(-20010, 'Cliente Inexistente');
      end if;
    end if;
  exception
    when no_data_found then
      if i_filt_tipo_canj_cheq = 'J' then
        raise_application_error(-20010,
                                'El Cliente no esta Autorizado para canje de Cheques Judiciales!');
      else
        raise_application_error(-20010, 'Cliente Inexistente');
      end if;
  end pp_validar_clpr_auto_cheq_judi;

  procedure pp_muestra_sub_cuenta(p_clpr_codi      in number,
                                  p_sucu_nume_item in number,
                                  p_sucu_desc      out char) is
  begin
    if p_sucu_nume_item = 0 then
      p_sucu_desc := 'Cuenta Principal';
    else
      select sucu_desc
        into p_sucu_desc
        from come_clpr_sub_cuen
       where sucu_clpr_codi = p_clpr_codi
         and sucu_nume_item = p_sucu_nume_item;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'SubCuenta inexistente');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_muestra_sub_cuenta;

  procedure pl_muestra_come_cuen_banc(p_cuen_codi      in number,
                                      p_cuen_desc      out char,
                                      p_cuen_mone_codi out number,
                                      p_banc_codi      out number,
                                      p_banc_desc      out char,
                                      p_cuen_nume      out char) is
  begin
    select cuen_desc, cuen_mone_codi, banc_codi, banc_desc, cuen_nume
      into p_cuen_desc,
           p_cuen_mone_codi,
           p_banc_codi,
           p_banc_desc,
           p_cuen_nume
      from come_cuen_banc, come_banc
     where cuen_banc_codi = banc_codi(+)
       and cuen_codi = p_cuen_codi;
  
  exception
    when no_data_found then
      p_cuen_desc := null;
      p_banc_codi := null;
      p_banc_desc := null;
      raise_application_error(-20010, 'Cuenta Bancaria Inexistente');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pl_muestra_come_cuen_banc;

  procedure pp_busca_tasa_mone(p_mone_codi in number,
                               p_fech_emis in date,
                               p_mone_coti out number,
                               p_tica_codi in number) is
  begin
    if p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
    else
    
      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = p_mone_codi
         and coti_fech = p_fech_emis
         and coti_tica_codi = p_tica_codi;
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
    when too_many_rows then
      raise_application_error(-20010,
                              'Cotizacion duplicada para la moneda ' ||
                              p_mone_codi || ' en fecha ' ||
                              to_char(p_fech_emis, 'dd-mm-yyyy'));
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_vali_mone(i_mone_codi      in number,
                         o_movi_cant_deci out number,
                         o_mone_desc      out varchar2,
                         o_mone_abre      out varchar2) is
  
  begin
  
    begin
      select m.mone_cant_deci, m.mone_desc, m.mone_desc_abre
        into o_movi_cant_deci, o_mone_desc, o_mone_abre
        from come_mone m
       where m.mone_codi = i_mone_codi;
    exception
      when no_data_found then
        raise_application_error(-20010, 'Moneda inexistente');
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
  end pp_vali_mone;

  procedure pp_busca_tasa_mone_canj(p_mone_codi in number,
                                    p_fech_emis in date,
                                    p_mone_coti out number,
                                    p_tica_codi in number) is
  begin
    if p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
    else
    
      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = p_mone_codi
         and coti_fech = p_fech_emis
         and coti_tica_codi = p_tica_codi;
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
    when too_many_rows then
      raise_application_error(-20010,
                              'Cotizacion duplicada para la moneda ' ||
                              p_mone_codi || ' en fecha ' ||
                              to_char(p_fech_emis, 'dd-mm-yyyy'));
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_vali_mone_canj(i_mone_codi      in number,
                              o_movi_cant_deci out number,
                              o_mone_desc      out varchar2) is
  
  begin
  
    begin
      select m.mone_cant_deci, m.mone_desc
        into o_movi_cant_deci, o_mone_desc
        from come_mone m
       where m.mone_codi = i_mone_codi;
    exception
      when no_data_found then
        raise_application_error(-20010, 'Moneda inexistente');
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
  end pp_vali_mone_canj;

  procedure pp_valida_cheque(i_cheq_serie          in varchar2,
                             i_cheq_banc_codi      in number,
                             i_cheq_nume           in varchar,
                             o_cheq_codi           out number,
                             o_cheq_indi_ingr_manu out varchar2,
                             o_cheq_esta           out varchar2) is
  
    --v_where               char(100);
    v_cheq_codi           number;
    v_cheq_indi_ingr_manu varchar2(1);
    v_cheq_esta           varchar2(1);
  
  begin
    select cheq_codi, nvl(cheq_indi_ingr_manu, 'N'), cheq_esta
      into v_cheq_codi, v_cheq_indi_ingr_manu, v_cheq_esta
      from come_cheq
     where cheq_serie = i_cheq_serie
       and cheq_banc_codi = i_cheq_banc_codi
       and cheq_nume = i_cheq_nume
       and cheq_tipo = 'R';
  
    raise_application_error(-20010, 'Nro. de cheque existente!');
  
  exception
    when no_data_found then
      null;
  end;

  procedure pp_vali_nume_cheq_banc(p_cheq_nume      in char,
                                   p_cheq_serie     in char,
                                   p_cheq_banc_codi in number) is
    v_banc_desc varchar2(60);
  begin
    select banc_desc
      into v_banc_desc
      from come_cheq, come_banc
     where cheq_banc_codi = banc_codi
       and rtrim(ltrim(cheq_nume)) = rtrim(ltrim(p_cheq_nume))
       and rtrim(ltrim(cheq_serie)) = rtrim(ltrim(p_cheq_serie))
       and cheq_banc_codi = p_cheq_banc_codi;
  
    if nvl(upper(p_indi_vali_repe_cheq), 'S') = 'S' then
      raise_application_error(-20010,
                              'Atencion!!! Cheque existente... Numero' ||
                              p_cheq_nume || ' Serie' || p_cheq_serie ||
                              ' Banco ' || v_banc_desc);
    else
      raise_application_error(-20010,
                              'Atencion!!! Cheque existente... Numero' ||
                              p_cheq_nume || ' Serie' || p_cheq_serie ||
                              ' Banco ' || v_banc_desc);
    end if;
  
  exception
    when no_data_found then
      null;
    when too_many_rows then
      if nvl(upper(p_indi_vali_repe_cheq), 'S') = 'S' then
        raise_application_error(-20010,
                                'Atencion!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      else
        raise_application_error(-20010,
                                'Atencion!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      end if;
    
  end pp_vali_nume_cheq_banc;

  procedure pp_actu_tota_canj(i_impo_efec_mone_sale in number,
                              o_canj_tota_mone_sale out number) is
  
    v_sum_cheq_impo number := 0;
  
  begin
  
    select sum(taax_c015) cheq_impo_mone
      into v_sum_cheq_impo
      from come_tabl_auxi
     where taax_sess = v('APP_SESSION')
       and taax_user = gen_user
       and taax_c019 = 'E';
  
    o_canj_tota_mone_sale := nvl(i_impo_efec_mone_sale, 0) +
                             v_sum_cheq_impo;
  
  exception
    when no_data_found then
      v_sum_cheq_impo       := 0;
      o_canj_tota_mone_sale := nvl(i_impo_efec_mone_sale, 0) +
                               v_sum_cheq_impo;
    
  end pp_actu_tota_canj;

  procedure pp_muestra_tipo_movi(p_timo_codi      in number,
                                 p_timo_afec_sald out char,
                                 p_timo_emit_reci out char,
                                 p_timo_dbcr      out char,
                                 p_tica_codi      out number) is
  begin
  
    select timo_afec_sald, timo_emit_reci, timo_dbcr, timo_tica_codi
      into p_timo_afec_sald, p_timo_emit_reci, p_timo_dbcr, p_tica_codi
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
  exception
    when no_data_found then
      p_timo_afec_sald := null;
      p_timo_emit_reci := null;
      p_timo_dbcr      := null;
      raise_application_error(-20010, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Tipo de Movimiento duplicado');
    when others then
      raise_application_error(-20010,
                              'Error al momento de buscar nro de movimeinto: ' ||
                              sqlcode);
  end;

  procedure pp_devu_dbcr_conc(p_conc_codi in number, p_dbcr out varchar2) is
  begin
    select conc_dbcr
      into p_dbcr
      from come_conc
     where conc_codi = p_conc_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Concepto ' || p_conc_codi || ' inexistente!');
  end;

  /**************** REPORTE *************************/
  procedure pp_generar_reporte is
    v_where      varchar2(1000) := ' ';
    v_where_adel varchar2(1000) := ' ';
    salir        exception;
  
    v_sql varchar2(20000);
    --v_cant_regi number := 0;
    v_para varchar2(500);
    v_cont varchar2(500);
    v_repo varchar2(500);
  
  begin
  
    ---v_where      := ' and m.movi_codi =  60474501';
    ---v_where_adel := ' and ma.movi_codi_padr = 60474501';
  
      if p_movi_codi is not null then
      v_where      := v_where     ||' and m.movi_codi = ' ||to_char(p_movi_codi);
      v_where_adel := v_where_adel||' and ma.movi_codi_padr = ' ||to_char(p_movi_codi);
    end if;
  
    v_sql := '
insert into come_tabl_auxi (taax_sess ,
                            taax_user ,
                            taax_seq  ,
                            taax_c001 ,
                            taax_c002 ,
                            taax_c003 ,
                            taax_c004 ,
                            taax_c005 ,
                            taax_c006 ,
                            taax_c007 ,
                            taax_c008 ,
                            taax_c009 ,
                            taax_c010 ,
                            taax_c011 ,
                            taax_c012 ,
                            taax_c013 ,
                            taax_c014 ,
                            taax_c015 ,
                            taax_c016 ,
                            taax_c017 ,
                            taax_c018 ,
                            taax_c019 ,
                            taax_c020 ,
                            taax_c021 ,
                            taax_c022 ,
                            taax_c023 ,
                            taax_c024 )
                      
select ' || v('APP_SESSION') || ',
       gen_user,
       seq_come_tabl_auxi.nextval,
       cp.clpr_codi_alte,
       cp.clpr_desc,
       b.banc_desc,
       s.cheq_serie cheq_serie_sali,
       s.cheq_nume cheq_nume_sali,
       s.cheq_impo_mone cheq_impo_mone_sali,
       s.cheq_fech_emis cheq_fech_emis_sali,
       s.cheq_fech_venc cheq_fech_venc_sali,
       s.cheq_esta cheq_esta_sali,
       decode(k.canj_cheq_codi_entr, null, ''Efectivo'', ''Cheque'') canj_tipo,
       m.movi_nume,
       m.movi_fech_emis,
       e.cheq_serie cheq_serie_entr,
       e.cheq_nume cheq_nume_entr,
       nvl(e.cheq_impo_mone, k.canj_impo_efec_mone) cheq_impo_mone_entr,
       e.cheq_fech_emis cheq_fech_emis_entr,
       e.cheq_fech_venc cheq_fech_venc_entr,
       e.cheq_esta cheq_esta_entr,
       nvl(s.cheq_sald_mone, s.cheq_impo_mone) cheq_sald_mone_sali,
       m.movi_grav_mone + m.movi_exen_mone + m.movi_iva_mone movi_tota_mone,
       come_adel.movi_nume adel_nume,
       come_adel.movi_exen_mone adel_impo,
       come_adel.movi_fech_emis adel_fech_emis,
       ''REPORTE''
  from come_movi m,
       come_movi_cheq_canj k,
       come_cheq s,
       come_cheq e,
       come_clie_prov cp,
       come_banc b,
       (select ma.movi_codi_padr,
               ma.movi_nume,
               ma.movi_exen_mone,
               ma.movi_fech_emis
          from come_movi ma
         where ma.movi_timo_codi = 29 ' || v_where_adel ||
             ') come_adel
 where m.movi_clpr_codi = cp.clpr_codi
   and s.cheq_banc_codi = b.banc_codi
   and k.canj_movi_codi = m.movi_codi
   and k.canj_cheq_codi_sale = s.cheq_codi
   and k.canj_cheq_codi_entr = e.cheq_codi(+)
   and m.movi_codi = come_adel.movi_codi_padr(+) ' || v_where;
  
    insert into come_concat
      (otro, campo1)
    values
      ('este es el puto reporte', v_sql);
    commit;
    execute immediate v_sql;
  
   -- v_cont := 'p_app_session:p_app_user';
   -- v_para := v('APP_SESSION') || ':' || gen_user;
    v_repo := 'I020222';
    v_cont := 'p_app_session:p_app_user';
    v_para := v('APP_SESSION') || ':' || gen_user;
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_para, gen_user, v_repo, 'pdf', v_cont);
  
    commit;
  
  exception
    when salir then
      null;
  end;

  /**************** ADELANTOS ****************/
  procedure pp_gene_come_movi_adel(ii_impo_efec_mone_sale     in number,
                                   rr_sum_cheq_impo_mone_sale in number,
                                   ss_suma_cheq_sald          in number,
                                   ii_movi_clpr_codi          in number,
                                   ii_canj_mone_codi_sale     in number,
                                   ii_movi_nume               in number,
                                   ii_movi_empl_codi          in number,
                                   ii_movi_fech_emis          in date,
                                   ii_sucu_nume_item          in number,
                                   ii_movi_tasa_mone          in number,
                                   ii_canj_tasa_mone_sale     in number,
                                   ii_sucu_codi               in number,
                                   ii_empr_codi               in number) is
    salir exception;
  begin
    -- pp_actualizar_come_movi_adel;
    begin
      i020222.pp_actualizar_come_movi_adel(i_impo_efec_mone_sale     => ii_impo_efec_mone_sale,
                                           r_sum_cheq_impo_mone_sale => rr_sum_cheq_impo_mone_sale,
                                           s_suma_cheq_sald          => ss_suma_cheq_sald,
                                           i_movi_clpr_codi          => ii_movi_clpr_codi,
                                           i_canj_mone_codi_sale     => ii_canj_mone_codi_sale,
                                           i_movi_nume               => ii_movi_nume,
                                           i_movi_empl_codi          => ii_movi_empl_codi,
                                           i_movi_fech_emis          => ii_movi_fech_emis,
                                           i_sucu_nume_item          => ii_sucu_nume_item,
                                           i_canj_tasa_mone_sale     => ii_canj_tasa_mone_sale,
                                           i_sucu_codi               => ii_sucu_codi,
                                           i_empr_codi               => ii_empr_codi);
    
    end;
  
    --pp_actu_come_movi_cuot_adel;
    begin
      pp_actu_come_movi_cuot_adel(i_impo_efec_mone     => ii_impo_efec_mone_sale,
                                  r_sum_cheq_impo_mone => rr_sum_cheq_impo_mone_sale,
                                  s_suma_cheq_sald     => ss_suma_cheq_sald,
                                  i_movi_fech_emis     => ii_movi_fech_emis,
                                  i_movi_tasa_mone     => ii_movi_tasa_mone);
    
    end;
    -- pp_actualizar_moimpu_adel;
    begin
      pp_actualizar_moimpu_adel(i_impo_efec_mone     => ii_impo_efec_mone_sale,
                                r_sum_cheq_impo_mone => rr_sum_cheq_impo_mone_sale,
                                s_suma_cheq_sald     => ss_suma_cheq_sald,
                                i_movi_tasa_mone     => ii_movi_tasa_mone);
    
    end;
    -- pp_actualizar_moco_adel;
    begin
      pp_actualizar_moco_adel(i_impo_efec_mone     => ii_impo_efec_mone_sale,
                              r_sum_cheq_impo_mone => rr_sum_cheq_impo_mone_sale,
                              s_suma_cheq_sald     => ss_suma_cheq_sald,
                              i_movi_tasa_mone     => ii_movi_tasa_mone);
    
    end;
  
    pp_actu_secu;
    --pp_llama_reporte;
  
    /* pl_impr_reci(p_movi_codi_adel,
                      p_form_impr_reci_adel,
                      null,
                      null);
    */
  
  exception
    when salir then
      null;
  end;

  procedure pp_actualizar_come_movi_adel(i_impo_efec_mone_sale     in number,
                                         r_sum_cheq_impo_mone_sale in number,
                                         s_suma_cheq_sald          in number,
                                         i_movi_clpr_codi          in number,
                                         i_canj_mone_codi_sale     in number,
                                         i_movi_nume               in number,
                                         i_movi_empl_codi          in number,
                                         i_movi_fech_emis          in date,
                                         i_sucu_nume_item          in number,
                                         i_canj_tasa_mone_sale     in number,
                                         i_sucu_codi               in number,
                                         i_empr_codi               in number) is
  
    --v_movi_codi                number(20);
    v_movi_timo_codi           number(10);
    v_movi_clpr_codi           number(20);
    v_movi_sucu_codi_orig      number(10);
    v_movi_cuen_codi           number(4);
    v_movi_mone_codi           number(4);
    v_movi_nume                number(20);
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(20);
    v_movi_codi_padr           number(20);
    v_movi_tasa_mone           number(20, 4);
    v_movi_tasa_mmee           number(20, 4);
    v_movi_grav_mmnn           number(20, 4);
    v_movi_exen_mmnn           number(20, 4);
    v_movi_iva_mmnn            number(20, 4);
    v_movi_grav_mmee           number(20, 4);
    v_movi_exen_mmee           number(20, 4);
    v_movi_iva_mmee            number(20, 4);
    v_movi_grav_mone           number(20, 4);
    v_movi_exen_mone           number(20, 4);
    v_movi_iva_mone            number(20, 4);
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number(20, 4);
    v_movi_sald_mmee           number(20, 4);
    v_movi_sald_mone           number(20, 4);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_empr_codi           number(2);
    v_movi_empl_codi           number(10);
    v_movi_fech_oper           date;
    v_movi_base                number(2);
    v_movi_clpr_sucu_nume_item number;
  
    v_tica_codi number;
    v_dife      number;
  begin
  
    -- asignar valores....
  
    v_dife := (nvl(i_impo_efec_mone_sale, 0) +
              nvl(r_sum_cheq_impo_mone_sale, 0)) - nvl(s_suma_cheq_sald, 0);
  
    v_movi_tasa_mone := i_canj_tasa_mone_sale;
    v_movi_exen_mmnn := round(v_dife * v_movi_tasa_mone, p_cant_deci_mmnn);
  
    p_movi_codi_adel      := fa_sec_come_movi;
    v_movi_timo_codi      := p_codi_timo_adle;
    v_movi_clpr_codi      := i_movi_clpr_codi;
    v_movi_sucu_codi_orig := i_sucu_codi;
    v_movi_cuen_codi      := null;
    v_movi_mone_codi      := i_canj_mone_codi_sale;
    v_movi_nume           := i_movi_nume; --marce i_movi_nume;
    v_movi_fech_emis      := i_movi_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := p_movi_codi;
  
    v_movi_tasa_mmee := null;
    v_movi_grav_mmnn := 0;
  
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := v_dife;
    v_movi_iva_mone            := 0;
    v_movi_obse                := null;
    v_movi_sald_mmnn           := v_dife;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := v_dife;
    v_movi_empr_codi           := i_empr_codi;
    v_movi_empl_codi           := i_movi_empl_codi; --marce null;
    v_movi_fech_oper           := i_movi_fech_emis;
    v_movi_base                := p_codi_base;
    v_movi_clpr_sucu_nume_item := i_sucu_nume_item;
  
    pp_muestra_tipo_movi(p_codi_timo_adle,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    pp_insert_come_movi(p_movi_codi_adel,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_cuen_codi,
                        v_movi_mone_codi,
                        v_movi_nume,
                        v_movi_fech_emis,
                        v_movi_fech_grab,
                        v_movi_user,
                        v_movi_codi_padr,
                        v_movi_tasa_mone,
                        v_movi_tasa_mmee,
                        v_movi_grav_mmnn,
                        v_movi_exen_mmnn,
                        v_movi_iva_mmnn,
                        v_movi_grav_mmee,
                        v_movi_exen_mmee,
                        v_movi_iva_mmee,
                        v_movi_grav_mone,
                        v_movi_exen_mone,
                        v_movi_iva_mone,
                        v_movi_obse,
                        v_movi_sald_mmnn,
                        v_movi_sald_mmee,
                        v_movi_sald_mone,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_empr_codi,
                        v_movi_empl_codi,
                        v_movi_fech_oper,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_base);
  
  end;

  procedure pp_actu_come_movi_cuot_adel(i_impo_efec_mone     in number,
                                        r_sum_cheq_impo_mone in number,
                                        s_suma_cheq_sald     in number,
                                        i_movi_fech_emis     in date,
                                        i_movi_tasa_mone     in number) is
    v_cuot_fech_venc date;
    v_cuot_nume      number;
    v_cuot_impo_mone number;
    v_cuot_impo_mmnn number;
    v_cuot_impo_mmee number;
    v_cuot_sald_mone number;
    v_cuot_sald_mmnn number;
    v_cuot_sald_mmee number;
    v_cuot_movi_codi number;
  
    v_dife number;
  begin
    v_dife := (nvl(i_impo_efec_mone, 0) + nvl(r_sum_cheq_impo_mone, 0)) -
              nvl(s_suma_cheq_sald, 0);
  
    --Generar una cuota con f. de venc igual a la fecha del documento  
    v_cuot_fech_venc := i_movi_fech_emis;
    v_cuot_nume      := 1;
    v_cuot_impo_mone := v_dife;
    v_cuot_impo_mmnn := round(v_dife * i_movi_tasa_mone, p_cant_deci_mmnn);
    v_cuot_impo_mmee := null;
    v_cuot_sald_mone := v_cuot_impo_mone;
    v_cuot_sald_mmnn := v_cuot_impo_mmnn;
    v_cuot_sald_mmee := null;
    v_cuot_movi_codi := p_movi_codi_adel;
  
    pp_insert_come_movi_cuot_adel(v_cuot_fech_venc,
                                  v_cuot_nume,
                                  v_cuot_impo_mone,
                                  v_cuot_impo_mmnn,
                                  v_cuot_impo_mmee,
                                  v_cuot_sald_mone,
                                  v_cuot_sald_mmnn,
                                  v_cuot_sald_mmee,
                                  v_cuot_movi_codi);
  
  end;

  procedure pp_actualizar_moimpu_adel(i_impo_efec_mone     in number,
                                      r_sum_cheq_impo_mone in number,
                                      s_suma_cheq_sald     in number,
                                      i_movi_tasa_mone     in number) is
    v_moim_impu_codi number(10);
    v_moim_movi_codi number(20);
    v_moim_impo_mmnn number(20, 4);
    v_moim_impo_mmee number(20, 4);
    v_moim_impu_mmnn number(20, 4);
    v_moim_impu_mmee number(20, 4);
    v_moim_impo_mone number(20, 4);
    v_moim_impu_mone number(20, 4);
    v_moim_base      number(2);
  
    v_dife number;
  
  begin
    v_dife := (nvl(i_impo_efec_mone, 0) + nvl(r_sum_cheq_impo_mone, 0)) -
              nvl(s_suma_cheq_sald, 0);
  
    v_moim_impu_codi := p_codi_impu_exen;
    v_moim_movi_codi := p_movi_codi_adel;
    v_moim_impo_mmnn := round(v_dife * i_movi_tasa_mone, p_cant_deci_mmnn);
    v_moim_impo_mmee := null;
    v_moim_impu_mmnn := 0;
    v_moim_impu_mmee := null;
    v_moim_impo_mone := v_dife;
    v_moim_impu_mone := 0;
    v_moim_base      := p_codi_base;
  
    pp_insert_come_movi_impu_deta(v_moim_impu_codi,
                                  v_moim_movi_codi,
                                  v_moim_impo_mmnn,
                                  v_moim_impo_mmee,
                                  v_moim_impu_mmnn,
                                  v_moim_impu_mmee,
                                  v_moim_impo_mone,
                                  v_moim_impu_mone,
                                  v_moim_base);
  
  end;

  procedure pp_actualizar_moco_adel(i_impo_efec_mone     in number,
                                    r_sum_cheq_impo_mone in number,
                                    s_suma_cheq_sald     in number,
                                    i_movi_tasa_mone     in number) is
    v_moco_movi_codi number(20);
    v_moco_nume_item number(10);
    v_moco_conc_codi number(10);
    v_moco_cuco_codi number(10);
    v_moco_impu_codi number(10);
    v_moco_impo_mmnn number(20, 4);
    v_moco_impo_mmee number(20, 4);
    v_moco_impo_mone number(20, 4);
    v_moco_dbcr      varchar2(1);
    v_moco_base      number(2);
  
    v_dife number;
  
  begin
    v_dife := (nvl(i_impo_efec_mone, 0) + nvl(r_sum_cheq_impo_mone, 0)) -
              nvl(s_suma_cheq_sald, 0);
  
    v_moco_movi_codi := p_movi_codi_adel;
    v_moco_nume_item := 1;
    v_moco_conc_codi := p_codi_conc_adle;
    v_moco_cuco_codi := p_cuco_codi_adel;
    v_moco_impu_codi := p_codi_impu_exen;
    v_moco_impo_mmnn := round(v_dife * i_movi_tasa_mone, p_cant_deci_mmnn);
    v_moco_impo_mmee := null;
    v_moco_impo_mone := v_dife;
  
    v_moco_base := p_codi_base;
  
    pp_devu_dbcr_conc(v_moco_conc_codi, v_moco_dbcr);
  
    pp_insert_come_movi_conc_deta(v_moco_movi_codi,
                                  v_moco_nume_item,
                                  v_moco_conc_codi,
                                  v_moco_cuco_codi,
                                  v_moco_impu_codi,
                                  v_moco_impo_mmnn,
                                  v_moco_impo_mmee,
                                  v_moco_impo_mone,
                                  v_moco_dbcr,
                                  v_moco_base);
  end;

  procedure pp_carga_secu(p_secu_nume_cobr out number) is
  begin
  
    select nvl(secu_nume_cobr, 0) + 1
      into p_secu_nume_cobr
      from come_secu
     where secu_codi =
           (select peco_secu_codi from come_pers_comp where peco_codi = 1);
  
  Exception
    When no_data_found then
      raise_application_error(-20010,
                              'Codigo de Secuencia de Cobranzas inexistente');
    
  end;

  procedure pp_vali_nume_comp(i_movi_nume in out number) is
   
    v_nume_comp      number;
   
   
    v_nume_libr      number;
    v_count          number;
  begin
    if p_indi_rend_comp = 'N' then
      begin
        select tare_reci_desd
          into v_nume_comp
          from come_talo_reci
         where tare_codi = v('P123_MOVI_TARE_CODI'); -- :badel.movi_tare_codi;
      
        pp_veri_nume_libr(v_nume_libr);
        if nvl(v_nume_libr, -1) <> -1 then
          i_movi_nume := v_nume_libr;
          v_nume_comp := v_nume_libr;
        end if;
      
        pp_vali_nume_libr(v_nume_comp);
      
        if i_movi_nume <> v_nume_comp then
          i_movi_nume := v_nume_comp;
        end if;
        --verificar si ese numero ya fue rendido o no.
        begin
          select count(*)
            into v_count
            from come_movi_anul, come_tipo_movi
           where anul_timo_codi = timo_codi
             and timo_tico_codi = 5
             and anul_nume = i_movi_nume;
          if v_count > 0 then
            raise_application_error(-20010,
                                    'El comprobante ya ha sido Anulado. Verifique el numero de comprobante.');
          end if;
        
          select count(*)
            into v_count
            from come_movi m, come_tipo_movi t
           where m.movi_timo_codi = t.timo_codi
             and t.timo_tico_codi = 5
             and m.movi_nume = i_movi_nume;
          if v_count > 0 then
            raise_application_error(-20010,
                                    'El comprobante ya ha sido rendido. Verifique el numero de comprobante.');
          end if;
        end;
        --comparar fechas
        begin
          --verificamos si las fechas a rendir comprobantes estan vigentes o no.
          if p_indi_rend_comp = 'N' then
            pp_veri_fech_rend_comp;
          end if;
        end;
        --end if;
      end;
      pp_veri_nume_libr(v_nume_comp);
      if nvl(v_nume_comp, -1) <> -1 then
        i_movi_nume := v_nume_comp;
      end if;
    
      pp_vali_nume_libr(i_movi_nume);
    
    end if;
  end;

  procedure pp_veri_nume_libr(p_movi_nume out number) is
    v_nume number;
    v_indi varchar2(1);
    cursor c_compr is
      select m.movi_nume
        from come_movi m, come_tipo_movi t, come_talo_reci r
       where m.movi_timo_codi = t.timo_codi
         and r.tare_codi = v('P123_MOVI_TARE_CODI') --:badel.movi_tare_codi
         and t.timo_tico_codi = 5
         and m.movi_nume >= r.tare_reci_desd
         and m.movi_nume <= r.tare_reci_hast
      union
      select a.anul_nume movi_nume
        from come_movi_anul a, come_tipo_movi t, come_talo_reci r
       where a.anul_timo_codi = t.timo_codi
         and r.tare_codi = v('P123_MOVI_TARE_CODI') --:badel.movi_tare_codi
         and t.timo_tico_codi = 5
         and a.anul_nume >= r.tare_reci_desd
         and a.anul_nume <= r.tare_reci_hast
       order by 1;
  begin
    select r.tare_reci_desd - 1
      into v_nume
      from come_talo_reci r
     where r.tare_codi = v('P123_MOVI_TARE_CODI'); --:badel.movi_tare_codi;
  
    v_indi := 'N';
    for k in c_compr loop
      v_nume := v_nume + 1;
      if v_nume < k.movi_nume then
        v_indi := 'S';
        exit;
      end if;
    end loop;
  
    if v_indi = 'S' then
      p_movi_nume := v_nume;
    else
      p_movi_nume := -1;
    end if;
  end;
  procedure pp_vali_nume_libr(p_movi_nume in out number) is
    v_nume      number;
    v_nume_hast number;
    v_indi      varchar2(1);
  
  begin
    v_indi := 'N';
    v_nume := p_movi_nume;
  
    begin
      select m.movi_nume
        into v_nume
        from come_movi m, come_tipo_movi t, come_talo_reci r
       where m.movi_timo_codi = t.timo_codi
         and r.tare_codi = v('P123_MOVI_TARE_CODI') --:badel.movi_tare_codi
         and t.timo_tico_codi = 5
         and m.movi_nume >= r.tare_reci_desd
         and m.movi_nume <= r.tare_reci_hast
         and m.movi_nume = v_nume;
    
      v_indi := 'S';
      v_nume := v_nume + 1;
    exception
      when no_data_found then
        null;
      when too_many_rows then
        v_indi := 'S';
        v_nume := v_nume + 1;
    end;
  
    begin
      select a.anul_nume
        into v_nume
        from come_movi_anul a, come_tipo_movi t, come_talo_reci r
       where a.anul_timo_codi = t.timo_codi
         and r.tare_codi = v('P123_MOVI_TARE_CODI') --:badel.movi_tare_codi
         and t.timo_tico_codi = 5
         and a.anul_nume >= r.tare_reci_desd
         and a.anul_nume <= r.tare_reci_hast
         and a.anul_nume = v_nume;
    
      v_indi := 'S';
      v_nume := v_nume + 1;
    exception
      when no_data_found then
        null;
      when too_many_rows then
        v_indi := 'S';
        v_nume := v_nume + 1;
    end;
  
    begin
      select resa_nume_comp
        into v_nume
        from come_reci_salt_auto, come_talo_reci
       where resa_tare_codi = v('P123_MOVI_TARE_CODI') --:badel.movi_tare_codi
         and resa_tare_codi = tare_codi
         and resa_esta = 'A'
         and resa_nume_comp = v_nume;
    
      v_indi := 'S';
      v_nume := v_nume + 1;
    exception
      when no_data_found then
        null;
      when too_many_rows then
        v_indi := 'S';
        v_nume := v_nume + 1;
    end;
  
    select r.tare_reci_hast
      into v_nume_hast
      from come_talo_reci r
     where r.tare_codi = v('P123_MOVI_TARE_CODI'); --:badel.movi_tare_codi;
  
    if v_nume > v_nume_hast then
      pl_me('Ya no quedan numeros libres en el talonario');
    end if;
  
    while v_indi = 'S' loop
      v_indi := 'N';
    
      begin
        select m.movi_nume
          into v_nume
          from come_movi m, come_tipo_movi t, come_talo_reci r
         where m.movi_timo_codi = t.timo_codi
           and r.tare_codi = v('P123_MOVI_TARE_CODI') --:badel.movi_tare_codi
           and t.timo_tico_codi = 5
           and m.movi_nume >= r.tare_reci_desd
           and m.movi_nume <= r.tare_reci_hast
           and m.movi_nume = v_nume;
      
        v_indi := 'S';
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          null;
        when too_many_rows then
          v_indi := 'S';
          v_nume := v_nume + 1;
      end;
    
      begin
        select a.anul_nume
          into v_nume
          from come_movi_anul a, come_tipo_movi t, come_talo_reci r
         where a.anul_timo_codi = t.timo_codi
           and r.tare_codi = v('P123_MOVI_TARE_CODI') -- :badel.movi_tare_codi
           and t.timo_tico_codi = 5
           and a.anul_nume >= r.tare_reci_desd
           and a.anul_nume <= r.tare_reci_hast
           and a.anul_nume = v_nume;
      
        v_indi := 'S';
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          null;
        when too_many_rows then
          v_indi := 'S';
          v_nume := v_nume + 1;
      end;
    
      begin
        select resa_nume_comp
          into v_nume
          from come_reci_salt_auto, come_talo_reci
         where resa_tare_codi = v('P123_MOVI_TARE_CODI') --:badel.movi_tare_codi
           and resa_tare_codi = tare_codi
           and resa_esta = 'A'
           and resa_nume_comp = v_nume;
      
        v_indi := 'S';
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          null;
        when too_many_rows then
          v_indi := 'S';
          v_nume := v_nume + 1;
      end;
    
      if v_nume > v_nume_hast then
        v_indi := 'X';
      end if;
    end loop;
  
    if v_indi = 'X' then
      pl_me('Ya no quedan numeros libres en el talonario');
    end if;
  
    p_movi_nume := v_nume;
  end;
  PROCEDURE pp_veri_fech_rend_comp IS
    cursor c_comp_pend is
      select round(trunc(resa_fech_rend) - trunc(sysdate)) saldo_dias,
             resa_nume_comp
        from come_reci_salt_auto
       where resa_tare_codi = v('P123_MOVI_TARE_CODI') --:badel.movi_tare_codi
         and resa_esta = 'A';
  BEGIN
    for r in c_comp_pend loop
      if r.saldo_dias < 0 then
        pl_me('Existe(n) comprobante(s) que aun no fue(ron) rendido(s). Se debe modificar fecha en que se rendira cuenta.');
      end if;
    end loop;
  END pp_veri_fech_rend_comp;

  procedure pp_set_variable is
   
  begin
  
    bsel.filt_tipo_canj_cheq := v('P29_FILT_TIPO_CANJ_CHEQ');
    bsel.movi_clpr_codi      := v('P29_MOVI_CLPR_CODI');
    bsel.impo_efec_mone      := v('P29_IMPO_EFEC_MONE');
    bsel.impo_efec_mone_sale := v('P29_IMPO_EFEC_MONE_SALE');
    bsel.canj_mone_codi_sale := v('P29_CANJ_MONE_CODI_SALE');
    bsel.cuen_mone_codi      := v('P29_CUEN_MONE_CODI');
    bsel.movi_tasa_mone      := v('P29_MOVI_TASA_MONE');
    bsel.canj_tasa_mone_sale := v('P29_CANJ_TASA_MONE_SALE');
    bsel.cant_deci_mone_sale := v('p29_canj_cant_deci');
  
    bsel.movi_fech_emis := v('P29_MOVI_FECH_EMIS');
    bsel.movi_nume      := v('P29_MOVI_NUME');
    bsel.impo_efec_mmnn := v('P29_IMPO_EFEC_MMNN');
    bsel.mone_codi      := v('P29_CUEN_MONE_CODI');
    bsel.sucu_nume_item := v('P29_SUCU_NUME_ITEM');
    bsel.movi_cuen_codi := v('P29_MOVI_CUEN_CODI');
    bsel.movi_nume_adel := v('P29_MOVI_NUME_ADEL');
    bsel.movi_empl_codi := v('P29_EMPL_CODI_ALTE');
  
    -- este es de la misma tabla que cargamos cheque entrante 
    BEGIN
    
      select sum(taax_c015) cheq_impo_mone,
             SUM(to_number(taax_c015) * to_number(taax_c014)) cheq_impo_mmnn
        into bsel.sum_cheq_impo_mone, bsel.sum_cheq_impo_mmnn
        from come_tabl_auxi
       where taax_sess = v('APP_SESSION')
         and taax_user = gen_user
         and taax_c019 = 'E';
    exception
      when others then
        null;
    END;
  
    ----obstener los totales
    select sum(c025) cheq_impo_apli_mone, sum(c021) cheq_sald
      into bsel.sum_cheq_impo_apli_mone, bsel.cheq_sald_sal
      from apex_collections a
     where collection_name = 'BCHEQ_SALI';
  
  end pp_set_variable;

  procedure pp_mostrar_cheq_codi(p_cheq_codi           in number,
                                 p_canj_mone_codi_sale in number,
                                 p_movi_clpr_codi      in number) is
    v_cheq_clpr_codi      number;
    v_indi_canj_cheq_judi varchar2(1) := 'N';
    v_existe              number;
    cursor c is
      select c.cheq_cuen_codi,
             cb.cuen_desc cheq_cuen_desc,
             cb.cuen_banc_codi cheq_banc_codi,
             b.banc_desc cheq_banc_desc,
             c.cheq_mone_codi,
             m.mone_desc cheq_mone_desc,
             m.mone_desc_abre cheq_mone_desc_abre,
             nvl(m.mone_cant_deci, 0) cheq_mone_cant_deci,
             c.cheq_nume_cuen,
             c.cheq_fech_emis,
             c.cheq_fech_venc,
             c.cheq_orde,
             c.cheq_titu,
             c.cheq_tasa_mone,
             c.cheq_impo_mone,
             c.cheq_impo_mmnn,
             c.cheq_indi_terc,
             c.cheq_obse,
             c.cheq_esta,
             c.cheq_clpr_codi,
             nvl(fa_devu_cheq_sald_mone(c.cheq_codi), c.cheq_impo_mone) cheq_sald,
             cheq_serie,
             cheq_nume,
             cheq_codi
        from come_cheq c, come_cuen_banc cb, come_banc b, come_mone m
       where c.cheq_cuen_codi = cb.cuen_codi(+)
         and cb.cuen_banc_codi = b.banc_codi(+)
         and c.cheq_mone_codi = m.mone_codi(+)
         and c.cheq_codi = p_cheq_codi;
  
  begin
    if p_movi_clpr_codi is null then
      raise_application_error(-20001,
                              'Favor seleccionar un Cliente primero..');
    end if;
    for bcheq_sali in c loop
    
      /* if apex_collection.collection_exists(p_collection_name => 'BCHEQ_SALI') then
      apex_collection.delete_collection(p_collection_name => 'BCHEQ_SALI');
      end if;*/
    
      select count(*)
        into v_existe
        from apex_collections a
       where collection_name = 'BCHEQ_SALI'
         and c023 = bcheq_sali.cheq_codi;
    
      if v_existe > 0 then
        raise_application_error(-20001,
                                'El Cheque con serie ' ||
                                bcheq_sali.cheq_serie || ' y nro ' ||
                                bcheq_sali.CHEQ_NUME ||
                                '. No puede ingresarse. 
        Asegurese de no introducir el mismo cheque!');
      end if;
    
      apex_collection.add_member(p_collection_name => 'BCHEQ_SALI',
                                 p_c001            => bcheq_sali.cheq_cuen_codi,
                                 p_c002            => bcheq_sali.cheq_cuen_desc,
                                 p_c003            => bcheq_sali.cheq_banc_codi,
                                 p_c004            => bcheq_sali.cheq_banc_desc,
                                 p_c005            => bcheq_sali.cheq_mone_codi,
                                 p_c006            => bcheq_sali.cheq_mone_desc,
                                 p_c007            => bcheq_sali.cheq_mone_desc_abre,
                                 p_c008            => bcheq_sali.cheq_mone_cant_deci,
                                 p_c009            => bcheq_sali.cheq_nume_cuen,
                                 p_c010            => bcheq_sali.cheq_fech_emis,
                                 p_c011            => bcheq_sali.cheq_fech_venc,
                                 p_c012            => bcheq_sali.cheq_orde,
                                 p_c013            => bcheq_sali.cheq_titu,
                                 p_c014            => bcheq_sali.cheq_tasa_mone,
                                 p_c015            => bcheq_sali.cheq_impo_mone,
                                 p_c016            => bcheq_sali.cheq_impo_mmnn,
                                 p_c017            => bcheq_sali.cheq_indi_terc,
                                 p_c018            => bcheq_sali.cheq_obse,
                                 p_c019            => bcheq_sali.cheq_esta,
                                 p_c020            => bcheq_sali.cheq_clpr_codi, --v_cheq_clpr_codi,
                                 p_c021            => bcheq_sali.cheq_sald,
                                 p_c022            => bcheq_sali.cheq_serie,
                                 p_c023            => bcheq_sali.cheq_codi,
                                 p_c024            => bcheq_sali.cheq_sald, ---cheq_sald_nuev
                                 p_c025            => NULL,
                                 p_c026            => NULL,
                                 p_c027            => NULL,
                                 p_c028            => NULL,
                                 p_c029            => NULL,
                                 p_c031            => bcheq_sali.cheq_nume);
    
      if v_cheq_clpr_codi <> p_movi_clpr_codi then
        raise_application_error(-20001,
                                'El cheque no corresponde al cliente seleccionado');
      end if;
    
      if bcheq_sali.cheq_esta = 'D' then
        raise_application_error(-20001,
                                'No se puede Canjear el cheque porque se encuentra en estado D= Depositado');
      end if;
    
      if bcheq_sali.cheq_esta = 'I' then
        raise_application_error(-20001,
                                'No se puede Canjear el cheque porque se encuentra en estado I= Ingresado');
      end if;
    
      if bcheq_sali.cheq_esta = 'J' then
        begin
          select clpr_indi_canj_cheq_judi
            into v_indi_canj_cheq_judi
            from come_clie_prov
           where clpr_codi = p_movi_clpr_codi;
        
          if nvl(v_indi_canj_cheq_judi, 'N') = 'N' then
            raise_application_error(-20001,
                                    'No se puede Canjear el cheque porque se encuentra en estado J= Judicial y el Cliente no esta autorizado.');
          end if;
        end;
      end if;
    
      if bcheq_sali.cheq_esta not in ('R', 'C', 'J') then
        raise_application_error(-20001,
                                'Para poder canjear el cheque debe estar en estado R= Rechazado, C= Canjeado o J= Judicial(Clientes autorizados).');
      end if;
    
      if bcheq_sali.cheq_sald <= 0 then
        raise_application_error(-20001, 'El cheque no posee saldo');
      end if;
    
      if p_canj_mone_codi_sale <> bcheq_sali.cheq_mone_codi then
        raise_application_error(-20001,
                                'La Caja seleccionada debe ser de la moneda saliente seleccionada en la cabecera.');
      end if;
    
    end loop;
  exception
    when no_data_found then
      raise_application_error(-20001, 'Cheque inexistente');
    when too_many_rows then
      null;
      -- raise_application_error(-20001,'Existe mas de un cheque con ese nro. Presione F9 para desplegar lista de valores');
  end pp_mostrar_cheq_codi;

  procedure pp_actualizar_member_coll(p_seq         in number,
                                      p_attr_number in number,
                                      p_value       in varchar2) is
  begin
    apex_collection.update_member_attribute(p_collection_name => 'BCHEQ_SALI',
                                            p_seq             => p_seq,
                                            p_attr_number     => p_attr_number,
                                            p_attr_value      => p_value);
  end pp_actualizar_member_coll;
  /*
  procedure pp_calcular_saldo is
    v_indi_next_record varchar2(1) := 'N';
    v_total_efectivo   number := 0;
    v_saldo_cheq       number := 0;
    v_saldo_cheq_nvo   number := 0;
    v_impo_efec        number := 0;
    v_total_cheq       number := 0;
    v_impo_cheq        number := 0;
    v_count            number := 0;
  
  begin
  
    pp_set_variable;
  
    --para efectivo
    v_total_efectivo := nvl(bsel.impo_efec_mone_sale,
                           v('P29_IMPO_EFEC_MONE'));
  
    if v_total_efectivo > 0 then
      -- go_block('bcheq_sali');
      --first_record;
    
      for bcheq_sali in bcheq_sal loop
      
        v_saldo_cheq := bcheq_sali.cheq_sald;
        if v_total_efectivo >= v_saldo_cheq then
          v_impo_efec      := v_saldo_cheq;
          v_total_efectivo := v_total_efectivo - v_impo_efec;
          --bcheq_sali.cheq_sald_nuev := bcheq_sali.cheq_sald_nuev - v_impo_efec;
         
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            24,
                                            (bcheq_sali.cheq_sald - v_impo_efec));
        else
          v_impo_efec      := v_total_efectivo;
          v_total_efectivo := 0;
          -- :bcheq_sali.cheq_sald_nuev := :bcheq_sali.cheq_sald_nuev - v_impo_efec;
        
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            24,
                                            (bcheq_sali.cheq_sald -
                                            v_impo_efec));
          exit;
        end if;
      end loop;
    
    end if;
  
    --para cheques
    select sum(taax_c015) cheq_impo_mone
      into v_total_cheq --v_sum_cheq_impo_mone_sale
      from come_tabl_auxi
     where taax_sess = v('APP_SESSION')
       and taax_user = gen_user
       and taax_c019 = 'E';
    --- v_total_cheq := nvl(:bcheq_reci.sum_cheq_impo_mone_sale, 0);
  
    if v_total_cheq > 0 then
      for bcheq_reci in che_entra loop
       
        v_impo_cheq := 0;
       
        for bcheq_sali in bcheq_sal loop
          if nvl(bcheq_sali.cheq_sald_nuev, 0) > 0 then
          --RAISE_APPLICATION_ERROR(-20001,bcheq_reci.cheq_sald);
            if nvl(bcheq_reci.cheq_sald, 0) > 0 then
            --  RAISE_APPLICATION_ERROR(-20001,bcheq_sali.cheq_sald_nuev);
              if nvl(bcheq_reci.cheq_sald, 0) >= nvl(bcheq_sali.cheq_sald_nuev, 0) then
              
                v_impo_cheq := nvl(bcheq_sali.cheq_sald_nuev, 0);
                I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 24, 0);
                v_indi_next_record := 'S';
                --bcheq_reci.cheq_sald      := bcheq_reci.cheq_sald - v_impo_cheq;
          update  come_tabl_auxi
          set taax_c020=(bcheq_reci.cheq_sald - v_impo_cheq)
        
     where taax_sess = v('APP_SESSION')
       and taax_user = gen_user
       and taax_c019 = 'E';
            
              
              else
                --si el saldo del cheque nuevo es menor al saldo del cheque saliente
                v_impo_cheq := bcheq_reci.cheq_sald;
                --bcheq_reci.cheq_sald       := 0;
               update  come_tabl_auxi
              set taax_c020=0
              where taax_sess = v('APP_SESSION')
              and taax_user = gen_user
              and taax_c019 = 'E';
              
                I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                                  24,
                                                  (bcheq_sali.cheq_sald_nuev -
                                                  v_impo_cheq));
                --bcheq_sali.cheq_sald_nuev  := bcheq_sali.cheq_sald_nuev - v_impo_cheq;
                v_indi_next_record := 'N';
              
              
              
              end if;
            
            else
              --si el saldo de los cheques nuevos en el puntero = 0 
              
              --go_block('bcheq_sali'); --volver al bloque de cheques salientes
              v_indi_next_record := 'N';
            end if;
          else
            --si el saldo del cheque salinete del puntero = 0 --ir al sigte registro
            v_indi_next_record := 'S';
          end if;
        
          v_count := v_count + 1;
        
    
        
        end loop;
      end loop;
    end if;
  
  end pp_calcular_saldo;
  */

  -----nuevo calcular saldo
  procedure pp_calcular_saldo is
   
    v_total_efectivo           number := 0;
    v_saldo_cheq               number := 0;
 
    v_impo_efec                number := 0;
    v_total_cheq               number := 0;
    v_impo_cheq                number := 0;
   
    v_cheq_impo_apli_efec_mone number;
    v_cheq_impo_apli_efec_mmnn number;
    v_cheq_impo_apli_mone      number;
    v_cheq_impo_apli_mmnn      number;
    v_cheq_impo_apli_cheq_mone number;
    v_cheq_impo_apli_cheq_mmnn number;
  
  begin
    pp_set_variable;
    ---si o si debe existir cheques salientes, se inicializa en el campo nuevo saldo el saldo del cheque, que viene de come_cheq, cheq_sald_mone
  
    for bcheq_sali in bcheq_sal loop
    
      I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                        24,
                                        bcheq_sali.cheq_sald); ---cheq_sald_mone_nuev
      I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 25, 0); ---cheq_impo_apli_mone
      I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 26, 0); ---cheq_impo_apli_mmnn
      I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 27, 0); --cheq_impo_apli_efec_mone
      I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 28, 0); --cheq_impo_apli_efec_mmnn
      I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 29, 0); ----cheq_impo_apli_cheq_mone
      I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 30, 0); ----cheq_impo_apli_cheq_mmnn
    
    end loop;
  
    --para efectivo
    v_total_efectivo := nvl(bsel.impo_efec_mone, 0);
  
    if v_total_efectivo > 0 then
      for bcheq_sali in bcheq_sal loop
        v_saldo_cheq := bcheq_sali.cheq_sald_mone_nuev;
        if v_total_efectivo >= v_saldo_cheq then
          v_impo_efec      := v_saldo_cheq;
          v_total_efectivo := v_total_efectivo - v_impo_efec;
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            24,
                                            bcheq_sali.cheq_sald_mone_nuev -
                                            v_impo_efec);
        
          v_cheq_impo_apli_efec_mone := v_impo_efec;
          v_cheq_impo_apli_efec_mmnn := round(v_impo_efec *
                                              nvl(bsel.movi_tasa_mone, 1),
                                              0);
          v_cheq_impo_apli_mone      := nvl(v_cheq_impo_apli_efec_mone, 0) +
                                        nvl(bcheq_sali.cheq_impo_apli_cheq_mone,
                                            0);
          v_cheq_impo_apli_mmnn      := nvl(v_cheq_impo_apli_efec_mmnn, 0) +
                                        nvl(bcheq_sali.cheq_impo_apli_cheq_mmnn,
                                            0);
          -------------------
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            25,
                                            v_cheq_impo_apli_mone); ---cheq_impo_apli_mone
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            26,
                                            v_cheq_impo_apli_mmnn); ---cheq_impo_apli_mmnn
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            27,
                                            v_cheq_impo_apli_efec_mone); --cheq_impo_apli_efec_mone
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            28,
                                            v_cheq_impo_apli_efec_mmnn); --cheq_impo_apli_efec_mmnn
        
        else
          v_impo_efec      := v_total_efectivo;
          v_total_efectivo := 0;
          --:bcheq_sali.cheq_sald_mone_nuev := :bcheq_sali.cheq_sald_mone_nuev - v_impo_efec;
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            24,
                                            bcheq_sali.cheq_sald_mone_nuev -
                                            v_impo_efec);
          v_cheq_impo_apli_efec_mone := v_impo_efec;
          v_cheq_impo_apli_efec_mmnn := round(v_impo_efec *
                                              nvl(bsel.movi_tasa_mone, 1),
                                              0);
        
          v_cheq_impo_apli_mone := nvl(v_cheq_impo_apli_efec_mone, 0) +
                                   nvl(bcheq_sali.cheq_impo_apli_cheq_mone,
                                       0);
          v_cheq_impo_apli_mmnn := nvl(v_cheq_impo_apli_efec_mmnn, 0) +
                                   nvl(bcheq_sali.cheq_impo_apli_cheq_mmnn,
                                       0);
        
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            25,
                                            v_cheq_impo_apli_mone); ---cheq_impo_apli_mone
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            26,
                                            v_cheq_impo_apli_mmnn); ---cheq_impo_apli_mmnn
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            27,
                                            v_cheq_impo_apli_efec_mone); --cheq_impo_apli_efec_mone
          I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                            28,
                                            v_cheq_impo_apli_efec_mmnn); --cheq_impo_apli_efec_mmnn
        
          exit;
        end if;
      
      end loop;
    
    else
    
    
    
      for bcheq_sali in bcheq_sal loop
        v_cheq_impo_apli_efec_mone := 0;
        v_cheq_impo_apli_efec_mmnn := 0;
        v_cheq_impo_apli_mone      := nvl(v_cheq_impo_apli_efec_mone, 0) +
                                      nvl(bcheq_sali.cheq_impo_apli_cheq_mone,
                                          0);
        v_cheq_impo_apli_mmnn      := nvl(v_cheq_impo_apli_efec_mmnn, 0) +
                                      nvl(bcheq_sali.cheq_impo_apli_cheq_mmnn,
                                          0);
        I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                          25,
                                          v_cheq_impo_apli_mone); ---cheq_impo_apli_mone 
        I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                          26,
                                          v_cheq_impo_apli_mmnn); ---cheq_impo_apli_mmnn
        I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                          27,
                                          v_cheq_impo_apli_efec_mone); --cheq_impo_apli_efec_mone
        I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                          28,
                                          v_cheq_impo_apli_efec_mmnn); --cheq_impo_apli_efec_mmnn 
      
      end loop;
    end if;
  
    --para cheques
    select sum(taax_c015) cheq_impo_mone
      into bsel.sum_cheq_impo_mone
      from come_tabl_auxi
     where taax_sess = v('APP_SESSION')
       and taax_user = gen_user
       and taax_c019 = 'E';
  
    
    v_total_cheq := nvl(bsel.sum_cheq_impo_mone, 0);
  
    if v_total_cheq > 0 then
   
      v_impo_cheq := 0;
      for bcheq_sali in bcheq_sal loop
        if nvl(bcheq_sali.cheq_sald_mone_nuev, 0) > 0 then
          if nvl(v_total_cheq, 0) >= nvl(bcheq_sali.cheq_sald_mone_nuev, 0) then
              
            v_impo_cheq := nvl(bcheq_sali.cheq_sald_mone_nuev, 0);
            -- bcheq_sali.cheq_sald_mone_nuev           := 0;  
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 24, 0);
          
            v_cheq_impo_apli_cheq_mone := v_impo_cheq;
            v_cheq_impo_apli_cheq_mmnn := round(v_impo_cheq *
                                                nvl(bsel.movi_tasa_mone, 1),
                                                0);
          --V_cheq_impo_apli_cheq_mone
          
            v_cheq_impo_apli_mone := nvl(v_cheq_impo_apli_efec_mone, 0) +
                                     nvl(bcheq_sali.cheq_impo_apli_cheq_mone,
                                         0);
            v_cheq_impo_apli_mmnn := nvl(v_cheq_impo_apli_efec_mmnn, 0) +
                                     nvl(bcheq_sali.cheq_impo_apli_cheq_mmnn,
                                         0);
          
            v_total_cheq := v_total_cheq - v_impo_cheq;
          
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              25,
                                              v_cheq_impo_apli_mone); ---cheq_impo_apli_mone
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              26,
                                              v_cheq_impo_apli_mmnn); ---cheq_impo_apli_mmnn
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              29,
                                              v_cheq_impo_apli_cheq_mone); ----cheq_impo_apli_cheq_mone
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              30,
                                              v_cheq_impo_apli_cheq_mmnn); ----cheq_impo_apli_cheq_mmnn
          
          
         --  RAISE_APPLICATION_ERROR(-20001, bcheq_sali.seq_id);
          else
              
            --si el saldo del cheque nuevo es menor al saldo del cheque saliente
            v_impo_cheq  := v_total_cheq;
            v_total_cheq := 0;
            --bcheq_sali.cheq_sald_mone_nuev           := bcheq_sali.cheq_sald_mone_nuev - v_impo_cheq;
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              24,
                                              bcheq_sali.cheq_sald_mone_nuev - v_impo_cheq);
            v_cheq_impo_apli_cheq_mone := v_impo_cheq;
            v_cheq_impo_apli_cheq_mmnn := round(v_impo_cheq *
                                                nvl(bsel.movi_Tasa_mone, 1),
                                                0);
          
            v_cheq_impo_apli_mone := nvl(bcheq_sali.cheq_impo_apli_efec_mone,
                                         0) +
                                     nvl(v_cheq_impo_apli_cheq_mone, 0);
            v_cheq_impo_apli_mmnn := nvl(bcheq_sali.cheq_impo_apli_efec_mmnn,
                                         0) +
                                     nvl(v_cheq_impo_apli_cheq_mmnn, 0);
          
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              25,
                                              v_cheq_impo_apli_mone); ---cheq_impo_apli_mone
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              26,
                                              v_cheq_impo_apli_mmnn); ---cheq_impo_apli_mmnn
            --I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 27, v_cheq_impo_apli_efec_mone);--cheq_impo_apli_efec_mone
            --I020222.pp_actualizar_member_coll(bcheq_sali.seq_id, 28,v_cheq_impo_apli_efec_mmnn);--cheq_impo_apli_efec_mmnn
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              29,
                                              v_cheq_impo_apli_cheq_mone); ----cheq_impo_apli_cheq_mone
            I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                              30,
                                              v_cheq_impo_apli_cheq_mmnn); ----cheq_impo_apli_cheq_mmnn
          
          end if;
        
        end if;
      
      end loop;
    
    else
      ---si total de cheques entrantes es igual a cero
      for bcheq_sali in bcheq_sal loop
        v_cheq_impo_apli_cheq_mone := 0;
        v_cheq_impo_apli_cheq_mmnn := 0;
      
        v_cheq_impo_apli_mone := nvl(bcheq_sali.cheq_impo_apli_efec_mone, 0) +
                                 nvl(v_cheq_impo_apli_cheq_mone, 0);
        v_cheq_impo_apli_mmnn := nvl(bcheq_sali.cheq_impo_apli_efec_mmnn, 0) +
                                 nvl(v_cheq_impo_apli_cheq_mmnn, 0);
      
        I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                          25,
                                          v_cheq_impo_apli_mone); ---cheq_impo_apli_mone 
        I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                          26,
                                          v_cheq_impo_apli_mmnn); ---cheq_impo_apli_mmnn
        I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                          29,
                                          v_cheq_impo_apli_cheq_mone); ----cheq_impo_apli_cheq_mone
        I020222.pp_actualizar_member_coll(bcheq_sali.seq_id,
                                          30,
                                          v_cheq_impo_apli_cheq_mmnn); ----cheq_impo_apli_cheq_mmnn
      
      
      
      end loop;
    
    end if; --si total de cheques es mayor a cero
  
  end pp_calcular_saldo;

  procedure pp_validar_import_rec(p_cheq_impo_mone      in number,
                                  p_cheq_tasa_mone      in number,
                                  p_cheq_impo_mmnn      out number,
                                  p_cheq_impo_mone_sale out number) is
  begin
  
    if nvl(p_cheq_impo_mone, 0) <= 0 then
      raise_application_error(-20001,
                              'Debe ingresar el un valor mayor a cero para el importe del cheque');
    end if;
  
    if bsel.canj_mone_codi_sale = bsel.cuen_mone_codi then
      if nvl(bsel.canj_mone_codi_sale, p_codi_mone_mmnn) = p_codi_mone_mmnn then
        p_cheq_impo_mmnn      := round(nvl(p_cheq_impo_mone, 0),
                                       p_cant_deci_mmnn);
        p_cheq_impo_mone_sale := round(nvl(p_cheq_impo_mone, 0),
                                       nvl(bsel.cant_deci_mone_sale, 1));
      else
        p_cheq_impo_mmnn      := round((nvl(p_cheq_impo_mone, 0) *
                                       nvl(p_cheq_tasa_mone, 1)),
                                       p_cant_deci_mmnn);
        p_cheq_impo_mone_sale := round(nvl(p_cheq_impo_mone, 0),
                                       nvl(bsel.cant_deci_mone_sale, 1));
      end if;
    else
      if nvl(bsel.canj_mone_codi_sale, p_codi_mone_mmnn) = p_codi_mone_mmnn then
        p_cheq_impo_mone_sale := round((nvl(p_cheq_impo_mone, 0) *
                                       nvl(p_cheq_tasa_mone, 1)),
                                       nvl(bsel.cant_deci_mone_sale, 1));
        p_cheq_impo_mmnn      := round(p_cheq_impo_mone_sale,
                                       nvl(bsel.cant_deci_mone_sale, 1));
      else
        p_cheq_impo_mone_sale := round((nvl(p_cheq_impo_mone, 0) /
                                       nvl(bsel.canj_tasa_mone_sale, 1)),
                                       nvl(bsel.cant_deci_mone_sale, 1));
        p_cheq_impo_mmnn      := round(nvl(p_cheq_impo_mone, 0),
                                       nvl(bsel.cant_deci_mone_sale, 1));
      end if;
    end if;
  
  end pp_validar_import_rec;

  procedure pp_borrar_collection(i_seq in number) as
  begin
    apex_collection.delete_member(p_collection_name => 'BCHEQ_SALI',
                                  p_seq             => i_seq);
    apex_collection.resequence_collection(p_collection_name => 'BCHEQ_SALI');
  
  end pp_borrar_collection;

  procedure pp_muestra_come_empl(p_empl_empr_codi in number,
                                 p_emti_tiem_codi in number,
                                 p_empl_codi_alte in varchar2,
                                 p_empl_desc      out varchar2,
                                 p_empl_codi      out number) is
  begin
    select e.empl_desc, e.empl_codi
      into p_empl_desc, p_empl_codi
      from come_empl e, come_empl_tiem t
     where e.empl_codi = t.emti_empl_codi
       and t.emti_tiem_codi = p_emti_tiem_codi
       and e.empl_empr_codi = p_empl_empr_codi
       and nvl(empl_esta, 'A') = 'A'
       and ltrim(rtrim(lower(e.empl_codi_alte))) =
           ltrim(rtrim(lower(p_empl_codi_alte)));
  
  exception
    when no_data_found then
      p_empl_desc := null;
      p_empl_codi := null;
      pl_me('Empleado inexistente o no es del tipo requerido o no se encuentra Activo');
    when others then
      pl_me(sqlerrm);
  end pp_muestra_come_empl;
  
procedure pp_vali_nume_dupl(p_movi_nume_adel in number) is
  v_count   number;
begin
    select count(*)
      into v_count
      from come_movi
     where movi_nume = p_movi_nume_adel
       and movi_timo_codi = p_codi_timo_adle;
  
  if v_count > 0 then
    pl_me('Documento Existente. Favor verifique.');
  end if;
end;
  procedure pp_actu_secu is
  begin
    update come_secu
       set secu_nume_adle = bsel.movi_nume_adel
     where secu_codi = (select f.user_secu_codi
                          from segu_user f
                         where user_login = gen_user);
  
  Exception
  
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_actu_secu;

  procedure pp_devu_nume_comp(p_movi_empl_codi      in number,
                              p_movi_nume_adel      out number,
                              p_tico_indi_vali_nume out varchar2,
                              p_movi_tare_codi_adel out number,
                              p_ind_numero_dupli    out varchar2) is
    v_tare_reci_desd number;
    v_tare_reci_hast number;
    v_movi_tico_codi number;
  
  begin
    begin
      select timo_tico_codi,
             nvl(tico_indi_vali_nume, 'N') tico_indi_vali_nume
        into v_movi_tico_codi, p_tico_indi_vali_nume
        from come_tipo_movi, come_tipo_comp
       where timo_codi = p_codi_timo_adle
         and tico_codi(+) = timo_tico_codi;
    exception
      when no_data_found then
        pl_me('Debe relacionar el tipo de Comprobante al tipo de movimiento ' ||
              p_codi_timo_adle);
    end;
  
    select nvl(tare_ulti_nume, 0) + 1,
           tare_codi,
           tare_reci_desd,
           tare_reci_hast
      into p_movi_nume_adel,
           p_movi_tare_codi_adel,
           v_tare_reci_desd,
           v_tare_reci_hast
      from come_talo_reci
     where tare_esta = 'A'
       and tare_tico_codi = v_movi_tico_codi
       and tare_empl_codi = p_movi_empl_codi;
  
    if p_movi_nume_adel > v_tare_reci_hast then
      p_movi_nume_adel := v_tare_reci_desd;
    end if;
    p_ind_numero_dupli := 'N';
  exception
    when no_data_found then
      pl_me('El cobrador no tiene un talonario activo. Asigne un talonario al cobrador seleccionado.');
    when too_many_rows then
      p_ind_numero_dupli := 'S';
      p_movi_nume_adel   := NULL;
      --pp_devu_nume_comp_dupl;
  end pp_devu_nume_comp;

  procedure pp_devu_nume_comp_dupl(p_movi_tare_codi in number,
                                   p_movi_nume_adel out number) is
    v_tare_reci_desd number;
    v_tare_reci_hast number;
  begin
  
    -- if :badel.movi_tare_codi is null then
    -- pl_me('Debe seleccionar uno de los talonarios de la lista de valores');
    -- else
  
    select nvl(tare_ulti_nume, 0) + 1, tare_reci_desd, tare_reci_hast
      into p_movi_nume_adel, v_tare_reci_desd, v_tare_reci_hast
      from come_talo_reci
     where tare_codi = p_movi_tare_codi;
  
    if p_movi_nume_adel > v_tare_reci_hast then
      p_movi_nume_adel := v_tare_reci_desd;
    end if;
    -- end if;
  
  exception
    when no_data_found then
      pl_me('Debe seleccionar uno de los talonarios de la lista de valores');
  end pp_devu_nume_comp_dupl;

  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;

end I020222;
