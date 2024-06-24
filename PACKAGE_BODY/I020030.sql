
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020030" is

  TYPE R_BABMC IS RECORD(
    CHEQ_CODI                     NUMBER,
    CHEQ_MONE_CODI                NUMBER,
    CHEQ_BANC_CODI                NUMBER,
    CHEQ_NUME                     VARCHAR2(30),
    CHEQ_SERIE                    VARCHAR2(3),
    CHEQ_FECH_EMIS                DATE,
    CHEQ_FECH_VENC                DATE,
    CHEQ_IMPO_MONE                NUMBER,
    CHEQ_IMPO_MMNN                NUMBER,
    CHEQ_TIPO                     VARCHAR2(1),
    CHEQ_CLPR_CODI                NUMBER,
    CHEQ_ESTA                     VARCHAR2(1),
    CHEQ_NUME_CUEN                VARCHAR2(20),
    CHEQ_OBSE                     VARCHAR2(100),
    CHEQ_INDI_INGR_MANU           VARCHAR2(4),
    CHEQ_CUEN_CODI                NUMBER,
    CHEQ_TASA_MONE                NUMBER,
    CHEQ_TITU                     VARCHAR2(120),
    CHEQ_ORDE                     VARCHAR2(120),
    CHEQ_USER                     VARCHAR2(10),
    CHEQ_FECH_GRAB                DATE,
    CHEQ_BASE                     NUMBER,
    CHEQ_TACH_CODI                NUMBER,
    CHEQ_CAJA_CODI                NUMBER,
    CHEQ_ORPA_CODI                NUMBER,
    CHEQ_FECH_DEPO                DATE,
    CHEQ_FECH_RECH                DATE,
    CHEQ_INDI_TERC                VARCHAR2(1),
    CHEQ_INDI_DESC                VARCHAR2(1),
    CHEQ_SALD_MONE                NUMBER,
    CHEQ_SALD_MMNN                NUMBER,
    CHEQ_EMPL_CODI                NUMBER,
    CHEQ_INDI_DIA_DIFE            VARCHAR2(4),
    CHEQ_INDI_COBR                VARCHAR2(1),
    CHEQ_BANC_CODI_DESC           NUMBER,
    CHEQ_SUCU_CODI                NUMBER,
    CHEQ_CLPR_SUCU_NUME_ITEM      NUMBER,
    CHEQ_CLPR_CODI_ORIG           NUMBER,
    CHEQ_CLPR_SUCU_NUME_ITEM_ORIG NUMBER,
    CHEQ_INDI_CANC                VARCHAR2(1),
    CHEQ_TITU_NUME_CEDU           VARCHAR2(20),
    CHEQ_USER_REGI                VARCHAR2(20),
    CHEQ_FECH_REGI                DATE,
    CHEQ_USER_MODI                VARCHAR2(20),
    CHEQ_FECH_MODI                DATE,
    CHEQ_INDI_DESC_RECI           VARCHAR2(1),
    CHEQ_INDI_AUTO                VARCHAR2(1),
    CHEQ_CUEN_CODI_NEW            NUMBER,
    MON_CUEN_NEW                  NUMBER,
    cheq_fech_venc_orig           date
    
    );
  BABMC R_BABMC;

  PROCEDURE pp_actu_come_orde_pago_cheq(p_cheq_codi in number) IS
  BEGIN
    update come_orde_pago_cheq_deta
       set cheq_serie     = babmc.cheq_serie,
           cheq_nume      = babmc.cheq_nume,
           cheq_fech_emis = babmc.cheq_fech_emis,
           cheq_fech_venc = babmc.cheq_fech_venc,
           cheq_nume_cuen = babmc.cheq_nume_cuen,
           cheq_obse      = babmc.cheq_obse,
           cheq_orde      = babmc.cheq_orde,
           cheq_titu      = babmc.cheq_titu
     where cheq_codi = p_cheq_codi;
  END pp_actu_come_orde_pago_cheq;

  -------------------------------------------------------------------------------------------  

  procedure pp_camb_cuen_banc is
  begin
  
    if babmc.cheq_tipo = 'E' then
      if babmc.cheq_cuen_codi_new is not null then
        if babmc.cheq_cuen_codi_new <> babmc.cheq_cuen_codi then
          babmc.cheq_cuen_codi := babmc.cheq_cuen_codi_new;
        end if;
      end if;
    end if;
  
  end pp_camb_cuen_banc;

  -------------------------------------------------------------------------------------------  

  procedure pp_actu_cheq_emit(p_cheq_codi in number, p_fech_venc in date) is
    cursor c_moim is
      select mi.moim_movi_codi,
             mi.moim_nume_item,
             mi.moim_tipo,
             mi.moim_cuen_codi,
             mi.moim_dbcr,
             mi.moim_afec_caja,
             mi.moim_fech,
             mi.moim_impo_mone,
             mi.moim_impo_mmnn
        from come_movi_impo_deta mi
       where mi.moim_fech = p_fech_venc
         and mi.moim_movi_codi =
             (select movi_codi
                from come_movi m, come_movi_cheq mc
               where m.movi_codi = mc.chmo_movi_codi
                 and mc.chmo_cheq_codi = p_cheq_codi);
  
    v_moim_movi_codi number;
    v_moim_nume_item number;
    v_moim_tipo      varchar2(20);
    v_moim_cuen_codi number;
    v_moim_dbcr      varchar2(1);
    v_moim_afec_caja varchar2(1);
    v_moim_fech      date;
    v_moim_impo_mone number;
    v_moim_impo_mmnn number;
  
  begin
  
    if babmc.cheq_tipo = 'E' then
      if (babmc.cheq_fech_venc <> babmc.cheq_fech_venc_orig) or
         (babmc.cheq_cuen_codi <>
         nvl(babmc.cheq_cuen_codi_new, babmc.cheq_cuen_codi)) then
        for x in c_moim loop
        
          v_moim_movi_codi := x.moim_movi_codi;
          v_moim_nume_item := x.moim_nume_item;
          v_moim_tipo      := x.moim_tipo;
          v_moim_cuen_codi := nvl(babmc.cheq_cuen_codi_new,
                                  babmc.cheq_cuen_codi);
          v_moim_dbcr      := x.moim_dbcr;
          v_moim_afec_caja := x.moim_afec_caja;
          v_moim_fech      := babmc.cheq_fech_venc;
          v_moim_impo_mone := x.moim_impo_mone;
          v_moim_impo_mmnn := x.moim_impo_mmnn;
          delete come_movi_impo_deta
           where moim_movi_codi = v_moim_movi_codi
             and moim_nume_item = v_moim_nume_item;
        
          insert into come_movi_impo_deta
            (moim_movi_codi,
             moim_nume_item,
             moim_tipo,
             moim_cuen_codi,
             moim_dbcr,
             moim_afec_caja,
             moim_fech,
             moim_impo_mone,
             moim_impo_mmnn)
          values
            (v_moim_movi_codi,
             v_moim_nume_item,
             v_moim_tipo,
             v_moim_cuen_codi,
             v_moim_dbcr,
             v_moim_afec_caja,
             v_moim_fech,
             v_moim_impo_mone,
             v_moim_impo_mmnn);
        
        end loop;
      
      end if;
    end if;
  
  end pp_actu_cheq_emit;

  -------------------------------------------------------------------------------------------  

  procedure pp_definir_variables is
  
  begin
  
    BABMC.CHEQ_CODI                     := V('P73_CHEQ_CODI');
    BABMC.CHEQ_MONE_CODI                := V('P73_CHEQ_MONE_CODI');
    BABMC.CHEQ_BANC_CODI                := V('P73_CHEQ_BANC_CODI');
    BABMC.CHEQ_NUME                     := V('P73_CHEQ_NUME');
    BABMC.CHEQ_SERIE                    := V('P73_CHEQ_SERIE');
    BABMC.CHEQ_FECH_EMIS                := V('P73_CHEQ_FECH_EMIS');
    BABMC.CHEQ_FECH_VENC                := V('P73_CHEQ_FECH_VENC');
    BABMC.CHEQ_IMPO_MONE                := V('P73_CHEQ_IMPO_MONE');
    BABMC.CHEQ_IMPO_MMNN                := V('P73_CHEQ_IMPO_MMNN');
    BABMC.CHEQ_TIPO                     := V('P73_CHEQ_TIPO');
    BABMC.CHEQ_CLPR_CODI                := V('P73_CHEQ_CLPR_CODI');
    BABMC.CHEQ_ESTA                     := V('P73_CHEQ_ESTA');
    BABMC.CHEQ_NUME_CUEN                := V('P73_CHEQ_NUME_CUEN');
    BABMC.CHEQ_OBSE                     := V('P73_CHEQ_OBSE');
    BABMC.CHEQ_INDI_INGR_MANU           := V('P73_CHEQ_INDI_INGR_MANU');
    BABMC.CHEQ_CUEN_CODI                := V('P73_CHEQ_CUEN_CODI');
    BABMC.CHEQ_TASA_MONE                := V('P73_CHEQ_TASA_MONE');
    BABMC.CHEQ_TITU                     := V('P73_CHEQ_TITU');
    BABMC.CHEQ_ORDE                     := V('P73_CHEQ_ORDE');
    BABMC.CHEQ_USER                     := V('P73_CHEQ_USER');
    BABMC.CHEQ_FECH_GRAB                := V('P73_CHEQ_FECH_GRAB');
    BABMC.CHEQ_BASE                     := V('P73_CHEQ_BASE');
    BABMC.CHEQ_TACH_CODI                := V('P73_CHEQ_TACH_CODI');
    BABMC.CHEQ_CAJA_CODI                := V('P73_CHEQ_CAJA_CODI');
    BABMC.CHEQ_ORPA_CODI                := V('P73_CHEQ_ORPA_CODI');
    BABMC.CHEQ_FECH_DEPO                := V('P73_CHEQ_FECH_DEPO');
    BABMC.CHEQ_FECH_RECH                := V('P73_CHEQ_FECH_RECH');
    BABMC.CHEQ_INDI_TERC                := V('P73_CHEQ_INDI_TERC');
    BABMC.CHEQ_INDI_DESC                := V('P73_CHEQ_INDI_DESC');
    BABMC.CHEQ_SALD_MONE                := V('P73_CHEQ_SALD_MONE');
    BABMC.CHEQ_SALD_MMNN                := V('P73_CHEQ_SALD_MMNN');
    BABMC.CHEQ_EMPL_CODI                := V('P73_CHEQ_EMPL_CODI');
    BABMC.CHEQ_INDI_DIA_DIFE            := V('P73_CHEQ_INDI_DIA_DIFE');
    BABMC.CHEQ_INDI_COBR                := V('P73_CHEQ_INDI_COBR');
    BABMC.CHEQ_BANC_CODI_DESC           := V('P73_CHEQ_BANC_CODI_DESC');
    BABMC.CHEQ_SUCU_CODI                := V('P73_CHEQ_SUCU_CODI');
    BABMC.CHEQ_CLPR_SUCU_NUME_ITEM      := V('P73_CHEQ_CLPR_SUCU_NUME_ITEM');
    BABMC.CHEQ_CLPR_CODI_ORIG           := V('P73_CHEQ_CLPR_CODI_ORIG');
    BABMC.CHEQ_CLPR_SUCU_NUME_ITEM_ORIG := V('P73_CHEQ_CLPR_SUCU_NUME_ITEM_ORIG');
    BABMC.CHEQ_INDI_CANC                := V('P73_CHEQ_INDI_CANC');
    BABMC.CHEQ_TITU_NUME_CEDU           := V('P73_CHEQ_TITU_NUME_CEDU');
    BABMC.CHEQ_USER_REGI                := V('P73_CHEQ_USER_REGI');
    BABMC.CHEQ_FECH_REGI                := V('P73_CHEQ_FECH_REGI');
    BABMC.CHEQ_USER_MODI                := V('P73_CHEQ_USER_MODI');
    BABMC.CHEQ_FECH_MODI                := V('P73_CHEQ_FECH_MODI');
    BABMC.CHEQ_INDI_DESC_RECI           := V('P73_CHEQ_INDI_DESC_RECI');
    BABMC.CHEQ_INDI_AUTO                := V('P73_CHEQ_INDI_AUTO');
    BABMC.CHEQ_CUEN_CODI_NEW            := V('P73_CHEQ_CUEN_CODI_NEW');
    BABMC.MON_CUEN_NEW                  := V('P73_MON_CUEN_NEW');
  
  end pp_definir_variables;

  -------------------------------------------------------------------------------------------  

  procedure pp_actualizar is
  begin
    pp_definir_variables;
    --raise_application_error(-20010,'error'||babmc.cheq_banc_codi);
    if babmc.cheq_banc_codi is null then
      raise_application_error(-20010, 'Debe ingresar La Entidad Bancaria');
    end if;
  
    if babmc.cheq_serie is null then
      raise_application_error(-20010, 'Debe ingresar la Serie del Cheque');
    end if;
  
    if babmc.cheq_nume is null then
      raise_application_error(-20010, 'Debe ingresar el Numero del cheque');
    end if;
  
    if babmc.cheq_fech_emis is null then
      babmc.cheq_fech_emis := to_char(sysdate, 'dd-mm-yyyy');
    end if;
  
    if babmc.cheq_fech_venc is null then
      babmc.cheq_fech_venc := to_char(sysdate, 'dd-mm-yyyy');
    end if;
  
    if babmc.cheq_fech_venc < babmc.cheq_fech_emis then
      raise_application_error(-20010,
                              'La fecha de vencimiento del cheque no puede ser menor a la fecha de emisi¿n');
    end if;
  
    if babmc.cheq_cuen_codi_new is not null then
      if babmc.cheq_mone_codi <> babmc.MON_CUEN_NEW then
        raise_application_error(-20010,
                                'La cuenta Banc debe ser de la misma moneda con la q se ingreso originalmente');
      end if;
    end if;
  
    if babmc.cheq_fech_depo < babmc.cheq_fech_emis then
      raise_application_error(-20010,
                              'La fecha del rechazo del cheque no puede ser menor a la fecha de emisi¿n');
    end if;
  
    if babmc.cheq_codi is null then
      raise_application_error(-20010,
                              'Primero debe seleccionar un Registro');
    end if;
  
    update come_cheq
       set cheq_banc_codi      = babmc.cheq_banc_codi,
           cheq_nume           = babmc.cheq_nume,
           cheq_serie          = babmc.cheq_serie,
           cheq_fech_emis      = babmc.cheq_fech_emis,
           cheq_fech_venc      = babmc.cheq_fech_venc,
           cheq_nume_cuen      = babmc.cheq_nume_cuen,
           cheq_obse           = babmc.cheq_obse,
           cheq_cuen_codi      = babmc.cheq_cuen_codi,
           cheq_titu           = babmc.cheq_titu,
           cheq_fech_depo      = babmc.cheq_fech_depo,
           cheq_indi_cobr      = babmc.cheq_indi_cobr,
           cheq_banc_codi_desc = babmc.cheq_banc_codi_desc,
           cheq_indi_canc      = babmc.cheq_indi_canc,
           CHEQ_ORDE           = babmc.cheq_orde,
           cheq_user_modi      = gen_user,
           cheq_fech_modi      = sysdate
     where cheq_codi = babmc.cheq_codi;
  
    pp_actu_cheq_emit(babmc.cheq_codi, babmc.cheq_fech_venc_orig);
    pp_camb_cuen_banc;
    pp_actu_come_orde_pago_cheq(babmc.cheq_codi);
  
  end pp_actualizar;

  procedure pl_muestra_come_cuen_banc(p_cuen_codi      in number,
                                      p_cuen_mone_codi out number) is
  begin
    select cuen_mone_codi
      into p_cuen_mone_codi
      from come_cuen_banc, come_banc
     where cuen_banc_codi = banc_codi(+)
       and cuen_codi = p_cuen_codi;
  
  Exception
    when others then
      raise_application_error(-20010,
                              'Error al buscar Cuenta Bancaria! ' ||
                              sqlerrm);
  end pl_muestra_come_cuen_banc;

  -------------------------------------------------------------------------------------------  

  procedure pp_ejecutar_consulta_codi(s_codi in number) is
    V_CHEQ_CODI           VARCHAR2(200);
    V_CHEQ_BANC_CODI      VARCHAR2(200);
    V_CHEQ_SERIE          VARCHAR2(200);
    V_CHEQ_NUME           VARCHAR2(200);
    V_CHEQ_CLPR_CODI      VARCHAR2(200);
    V_CHEQ_CUEN_CODI      VARCHAR2(200);
    V_CHEQ_MONE_CODI      VARCHAR2(200);
    V_CHEQ_IMPO_MONE      VARCHAR2(200);
    V_CHEQ_TASA_MONE      VARCHAR2(200);
    V_CHEQ_IMPO_MMNN      VARCHAR2(200);
    V_CHEQ_FECH_EMIS      VARCHAR2(200);
    V_CHEQ_FECH_VENC      VARCHAR2(200);
    V_CHEQ_OBSE           VARCHAR2(200);
    V_CHEQ_ORDE           VARCHAR2(200);
    V_CHEQ_TITU           VARCHAR2(200);
    V_CHEQ_NUME_CUEN      VARCHAR2(200);
    V_CHEQ_INDI_COBR      VARCHAR2(200);
    V_CHEQ_ESTA           VARCHAR2(200);
    V_CHEQ_INDI_CANC      VARCHAR2(200);
    V_CHEQ_FECH_DEPO      VARCHAR2(200);
    V_CHEQ_TIPO           VARCHAR2(200);
    V_CHEQ_FECH_GRAB      VARCHAR2(200);
    V_CHEQ_TACH_CODI      VARCHAR2(200);
    V_CHEQ_CAJA_CODI      VARCHAR2(200);
    V_CHEQ_USER           VARCHAR2(200);
    V_CHEQ_FECH_RECH      VARCHAR2(200);
    V_CHEQ_INDI_TERC      VARCHAR2(200);
    V_CHEQ_INDI_DESC      VARCHAR2(200);
    V_CHEQ_INDI_DIA_DIFE  VARCHAR2(200);
    V_CHEQ_BANC_CODI_DESC VARCHAR2(200);
    V_CHEQ_SUCU_CODI      VARCHAR2(200);
    V_CHEQ_INDI_INGR_MANU VARCHAR2(200);
    V_CHEQ_TITU_NUME_CEDU VARCHAR2(200);
    V_CHEQ_INDI_AUTO      VARCHAR2(200);
  
  Begin
  
    select cheq_codi
      into v_cheq_codi
      from come_cheq
     where cheq_codi = s_codi
       and upper(cheq_esta) = 'I';
  
    select CHEQ_CODI,
           CHEQ_BANC_CODI,
           CHEQ_SERIE,
           CHEQ_NUME,
           CHEQ_CLPR_CODI,
           CHEQ_CUEN_CODI,
           CHEQ_MONE_CODI,
           CHEQ_IMPO_MONE,
           CHEQ_TASA_MONE,
           CHEQ_IMPO_MMNN,
           CHEQ_FECH_EMIS,
           CHEQ_FECH_VENC,
           CHEQ_OBSE,
           CHEQ_ORDE,
           CHEQ_TITU,
           CHEQ_NUME_CUEN,
           CHEQ_INDI_COBR,
           CHEQ_ESTA,
           CHEQ_INDI_CANC,
           CHEQ_FECH_DEPO,
           CHEQ_TIPO,
           CHEQ_FECH_GRAB,
           CHEQ_TACH_CODI,
           CHEQ_CAJA_CODI,
           CHEQ_USER,
           CHEQ_FECH_RECH,
           CHEQ_INDI_TERC,
           CHEQ_INDI_DESC,
           CHEQ_INDI_DIA_DIFE,
           CHEQ_BANC_CODI_DESC,
           CHEQ_SUCU_CODI,
           CHEQ_INDI_INGR_MANU,
           CHEQ_TITU_NUME_CEDU,
           CHEQ_INDI_AUTO
      into v_chEQ_CODI,
           v_chEQ_BANC_CODI,
           v_chEQ_SERIE,
           v_chEQ_NUME,
           v_chEQ_CLPR_CODI,
           v_chEQ_CUEN_CODI,
           v_chEQ_MONE_CODI,
           v_chEQ_IMPO_MONE,
           v_chEQ_TASA_MONE,
           v_chEQ_IMPO_MMNN,
           v_chEQ_FECH_EMIS,
           v_chEQ_FECH_VENC,
           v_chEQ_OBSE,
           v_chEQ_ORDE,
           v_chEQ_TITU,
           v_chEQ_NUME_CUEN,
           v_chEQ_INDI_COBR,
           v_chEQ_ESTA,
           v_chEQ_INDI_CANC,
           v_chEQ_FECH_DEPO,
           v_chEQ_TIPO,
           v_chEQ_FECH_GRAB,
           v_chEQ_TACH_CODI,
           v_chEQ_CAJA_CODI,
           v_chEQ_USER,
           v_chEQ_FECH_RECH,
           v_chEQ_INDI_TERC,
           v_chEQ_INDI_DESC,
           v_chEQ_INDI_DIA_DIFE,
           v_chEQ_BANC_CODI_DESC,
           v_chEQ_SUCU_CODI,
           v_chEQ_INDI_INGR_MANU,
           v_chEQ_TITU_NUME_CEDU,
           v_chEQ_INDI_AUTO
    
      from come_cheq
    
     where cheq_codi = s_codi;
  
    babmc.cheq_fech_venc_orig := V_CHEQ_FECH_VENC;
  
    setitem('P73_CHEQ_CODI', V_CHEQ_CODI);
    setitem('P73_CHEQ_BANC_CODI', V_CHEQ_BANC_CODI);
    setitem('P73_CHEQ_SERIE', V_CHEQ_SERIE);
    setitem('P73_CHEQ_NUME', V_CHEQ_NUME);
    setitem('P73_CHEQ_CLPR_CODI', V_CHEQ_CLPR_CODI);
    setitem('P73_CHEQ_CUEN_CODI', V_CHEQ_CUEN_CODI);
    setitem('P73_CHEQ_MONE_CODI', V_CHEQ_MONE_CODI);
    setitem('P73_CHEQ_IMPO_MONE', V_CHEQ_IMPO_MONE);
    setitem('P73_CHEQ_TASA_MONE', V_CHEQ_TASA_MONE);
    setitem('P73_CHEQ_IMPO_MMNN', V_CHEQ_IMPO_MMNN);
    setitem('P73_CHEQ_FECH_EMIS', V_CHEQ_FECH_EMIS);
    setitem('P73_CHEQ_FECH_VENC', V_CHEQ_FECH_VENC);
    setitem('P73_CHEQ_OBSE', V_CHEQ_OBSE);
    setitem('P73_CHEQ_ORDE', V_CHEQ_ORDE);
    setitem('P73_CHEQ_TITU', V_CHEQ_TITU);
    setitem('P73_CHEQ_NUME_CUEN', V_CHEQ_NUME_CUEN);
    setitem('P73_CHEQ_INDI_COBR', V_CHEQ_INDI_COBR);
    setitem('P73_CHEQ_ESTA', V_CHEQ_ESTA);
    setitem('P73_CHEQ_INDI_CANC', V_CHEQ_INDI_CANC);
    setitem('P73_CHEQ_FECH_DEPO', V_CHEQ_FECH_DEPO);
  
  Exception
    When no_data_found then
      raise_application_error(-20010,
                              'Cheque Inexistente o no se encuentra en estado "Ingresado"');
    When too_many_rows then
      raise_application_error(-20010,
                              'Existen dos cheques con el mismo Codigo, aviste a su administrador');
    
  End pp_ejecutar_consulta_codi;

  -------------------------------------------------------------------------------------------  

  procedure pp_send_mone_desc(i_mone_codi in number,
                              o_mone_desc out varchar2) is
  
  begin
    select t.mone_codi_alte || ' - ' || t.mone_desc || ' - ' ||
           t.mone_desc_abre descrip
      into o_mone_desc
      from come_mone t
     where t.mone_codi = i_mone_codi;
  end pp_send_mone_desc;

  -------------------------------------------------------------------------------------------  

  procedure pp_send_clpr_desc(i_clpr_codi in number,
                              o_clpr_desc out varchar2) is
  
  begin
    select w.clpr_codi_alte || ' - ' || w.clpr_desc descrip
      into o_clpr_desc
      from come_clie_prov w
     where w.clpr_codi = i_clpr_codi;
  end pp_send_clpr_desc;

end I020030;
