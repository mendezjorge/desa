
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020234" is

type r_parameter is record(
  p_indi_impr_cheq_emit                 varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),
  p_codi_timo_adle                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_timo_adle')),                        
  p_codi_timo_adlr                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_timo_adlr')),  
  p_codi_conc_adle                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_conc_adle')),                        
  p_codi_conc_adlr                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_conc_adlr')),                        
  p_indi_most_mens_sali                 varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
  p_empr_codi                           varchar2(100) := V('AI_EMPR_CODI'),   
  p_sucu_codi                           varchar2(100) := V('AI_SUCU_CODI'), 

  p_indi_vali_repe_cheq                 varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'))), 
  p_codi_impu_exen                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_impu_exen')),   
  p_codi_mone_mmnn                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmnn')),  
  p_codi_mone_mmee                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmee')),
  p_cant_deci_porc                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_cant_deci_porc')),   
  p_cant_deci_mmnn                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn')),   
  p_cant_deci_mmee                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmee')),   
  p_cant_deci_cant                      varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_cant_deci_cant')),   
  p_codi_timo_pgncrr                    varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_timo_pgncrr')),                        
  p_codi_timo_pgncre                    varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_timo_pgncre')),  
  p_codi_conc_pgncrr                    varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_conc_pgncrr')),                        
  p_codi_conc_pgncre                    varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_conc_pgncre')),                        

  p_emit_reci                           varchar2(100) ,
  p_clie_prov                           varchar2(100) :='C',
  p_codi_conc                           varchar2(100) ,

  p_fech_inic                           varchar2(100) ,
  p_fech_fini                           varchar2(100) ,

  p_codi_base                           varchar2(100) := pack_repl.fa_devu_codi_base,

  p_indi_cont_corr_talo_reci            varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_cont_corr_talo_reci'))), 
  p_codi_prov_espo                      varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_prov_espo')),
  p_form_impr_reci                      varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_reci'))),
  p_form_cons_esta_clie                 varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_cons_esta_clie'))),
  p_form_cons_esta_prov                 varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_cons_esta_prov'))),
  p_indi_rend_comp                      varchar2(100) := 'N',
  p_para_inic_adel                      varchar2(100),
  p_desc_mone_mmee                      varchar2(100),
  p_indi_carg_deta                      varchar2(100),
  p_codi_timo                           varchar2(100),
  p_validar_cheques                     varchar2(100),
  p_validar_tarjeta                     varchar2(100),
  p_para_inic                           varchar2(100),
  p_peco_codi                           varchar2(100) :=1
 );
  
  parameter r_parameter;
  
cursor g_cur_bdet is
select SEQ_ID,
       c001 movi_nume,
       c002 mone_codi,
       c003 movi_fech_emis,
       c004 cuot_fech_venc,
       c005 cuot_impo_mone,
       c006 cuot_sald_mone,
       c007 cuot_movi_codi,
       c008 cuot_tasa_mone,
       c009 clpr_codi,
       c010 clpr_codi_alte,
       c011 s_movi_iva_mone,
       c012 s_marca,
       c013 impo_pago,--monto,
       c014 saldo
  from apex_collections
 where collection_name = 'DETALLE';
 
 
cursor g_cur_bfp is
SELECT SEQ_ID,
       C001     PAGO_TIPO,
       C002     PAGO_TIPO_ANT,
       C003     PAGO_DESC,
       C004     PAGO_COBR_INDI,
       C005     MONE_CODI,
       C006     MONE_DESC,
       C007     MONE_CANT_DECI,
       C008     MONE_DESC_ABRE,
       C009     CUEN_INDI_CAJA_BANC,
       C010     PAGO_CUEN_CODI,
       C011     PAGO_CUEN_DESC,
       C012     PAGO_IMPO_MONE,
       C013     PAGO_IMPO_MMNN,
       C014     PAGO_IMPO_MOVI,
       C015     PAGO_COTI,
      ----------------------------
       C016     CHEQ_SERIE,
       C017     CHEQ_INDI_TERC,
       C018     CHEQ_NUME,
       C019     CHEQ_IMPO_MONE,
       C020     CHEQ_CUEN_CODI,
       C021     CHEQ_MONE_CODI,
       C022     CHEQ_BANC_CODI,
       C023     CHEQ_NUME_CUEN,
       C024     CHEQ_TITU,
       to_date(C025)     CHEQ_FECH_EMIS,
       to_date(C026)     CHEQ_FECH_VENC
  FROM APEX_COLLECTIONS
  WHERE COLLECTION_NAME = 'DETA_PAGO';


 type r_bcab is record( 
      p_emit_reci                  varchar2(300),
      p_cant_deci_mmnn             varchar2(300),
      buscar                       varchar2(300),
      p_clie_prov                  varchar2(300),
      movi_sucu_codi_orig          varchar2(300),
      indi_carg_deta               varchar2(300),
      movi_sucu_desc_orig          varchar2(300),
      movi_mone_cant_deci          varchar2(300),
      movi_clpr_codi               varchar2(300),
      s_clpr_codi_alte             varchar2(300),
      movi_codi                    varchar2(300),
      movi_clpr_desc               varchar2(300),
      movi_codi_adel               varchar2(300),
      movi_fech_emis               varchar2(300),
      movi_timo_codi               varchar2(300),
      movi_fech_oper               varchar2(300),
      movi_timo_desc               varchar2(300),
      movi_nume                    varchar2(300),
      movi_timo_desc_abre          varchar2(300),
      movi_tico_codi               varchar2(300),
      movi_mone_codi               varchar2(300),
      timo_indi_apli_adel_fopa     varchar2(300),
      tica_codi                    varchar2(300),
      timo_tica_codi               varchar2(300),
      s_dife                       varchar2(300),
      timo_dbcr_caja               varchar2(300),
      movi_tare_codi               varchar2(300),
      movi_mone_desc_abre          varchar2(300),
      clpr_prov_retener            varchar2(300),
      tica_desc                    varchar2(300),
      movi_clpr_ruc                varchar2(300),
      movi_clpr_tele               varchar2(300),
      movi_clpr_dire               varchar2(300),
      movi_mone_desc               varchar2(300),
      movi_tasa_mone               number,
      movi_cuen_nume               varchar2(300),
      movi_tasa_mmee               number,
      movi_fech_grab               varchar2(300),
      s_impo_efec                  varchar2(300),
      movi_grav_mmnn               number,
      movi_iva_mmnn                number,
      movi_exen_mone               number,
      movi_grav_mmee               number,
      movi_exen_mmnn               number,
      movi_exen_mmee               number,
      s_impo_cheq                  varchar2(100),
      movi_iva_mmee                number,
      movi_grav_mone               number,
      movi_obse                    varchar2(300),
      movi_iva_mone                number,
      movi_sald_mone               number,
      movi_sald_mmee               number,
      movi_sald_mmnn               number,
      movi_afec_sald               varchar2(100),
      movi_dbcr                    varchar2(300),
      movi_user                    varchar2(300),
      movi_emit_reci               varchar2(300),
      clpr_indi_clie_prov          varchar2(100),
      s_impo_tarj                  varchar2(300),
      s_impo_adel                  varchar2(300),
      sum_impo_pago                number,
      movi_empr_codi               number
  );
   bcab r_bcab; 

procedure pp_iniciar (p_clpr_indi_clie_prov        out varchar2,
                      P_movi_sucu_codi_orig        out number,
                      p_movi_sucu_desc_orig        out varchar2,
                      p_movi_emit_reci             out varchar2,
                      p_indi_carg_deta             out varchar2,
                      p_movi_timo_codi             out varchar2,
                      p_tica_codi                  out varchar2,
                      p_movi_tico_codi             out varchar2,
                      p_timo_indi_apli_adel_fopa   out varchar2,
                      p_timo_tica_codi             out varchar2, 
                      p_timo_dbcr_caja             out varchar2,
                      p_tica_desc                  out varchar2,
                      p_emit_reci                  out varchar2,
                      p_clie_prov                  out varchar2)is
                      
                      
begin  
         
--RAISE_aPPLICATION_ERROR(-20001,rtrim(ltrim(upper(V('P_PARA_INIC')))) );

    parameter.p_emit_reci  := 'E';
    parameter.p_clie_prov  := 'C';
    p_emit_reci  := 'E';
    p_clie_prov  := 'C';
    parameter.p_codi_conc  := parameter.p_codi_conc_pgncre;
    parameter.p_codi_timo  := parameter.p_codi_timo_pgncre;
   -- set_item_property('bfp.pago_tipo',lov_name,'lov_fp_emit');
 


-- pp_muestra_clpr_label;
   if nvl(parameter.p_emit_reci, 'E') = 'E' then 
   	  p_clpr_indi_clie_prov := 'C';
   else
   	  p_clpr_indi_clie_prov := 'P';
   end if;	     
  
   if nvl(parameter.p_clie_prov, 'C') = 'C' then
    -- :bcab.clpr_label := 'Cliente';
     parameter.p_para_inic_adel :='AC';
   else
  --   :bcab.clpr_label := 'Proveedor';
     parameter.p_para_inic_adel :='AP';
   end if;	
 

   --I020234.pp_muestra_desc_mone ( parameter.p_codi_mone_mmee,  parameter.p_desc_mone_mmee,  parameter.p_cant_deci_mmee);
 
  
   p_movi_sucu_codi_orig :=  parameter.p_sucu_codi;

   p_movi_emit_reci := parameter.p_emit_reci;    

   p_indi_carg_deta := 'N';
 

  
 --RAISE_APPLICATION_ERROR(-20001, parameter.p_emit_reci);
  p_movi_timo_codi := parameter.p_codi_timo;
 

 --  pp_muestra_tipo_movi;
    I020234.pp_muestra_tipo_movi(p_movi_timo_codi           ,
                                p_tica_codi                 ,
                                p_movi_tico_codi            ,
                                p_timo_indi_apli_adel_fopa  ,
                                p_timo_tica_codi            , 
                                p_timo_dbcr_caja            );
   
 
   pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
  
   if p_movi_sucu_codi_orig is not null then
     I020234.pp_buscar_sucu(p_movi_sucu_codi_orig, p_movi_sucu_desc_orig);
  end if;
 
if p_movi_timo_codi is not null then

   if p_tica_codi is not null then
     I020234.pp_muestra_tipo_camb(p_tica_codi, p_tica_desc);
   else
   	 raise_application_error(-20001,'Debe asignar un tipo de cambio al tipo de Movimiento');
   end if;	
end if;   


end pp_iniciar;

/*

procedure pp_buscar_formato_cheque (p_cuen_banc      in number,                                    
                                    FormatoImpresion out number,
                                    Impresora        out varchar2) is
  v_impresora      text_io.file_type;
  v_Path_Impresora varchar2(50) := null;
      
Begin                           
	
	
  select  fc.foch_codi         , i.impr_ubic
  into    FormatoImpresion     , Impresora
  from come_pers_comp pc, 
     come_impr i,
     come_cuen_peco cp,     
     come_cuen_banc cb,
     come_form_cheq fc    
	where cp.cupe_peco_codi = pc.peco_codi
	and   cp.cupe_impr_codi = i.impr_codi
	and   cb.cuen_codi      = cp.cupe_cuen_codi
	and   cb.cuen_foch_codi = fc.foch_codi(+)
	and pc.peco_codi        = parameter.p_peco_codi     
	and cp.cupe_cuen_codi   = p_cuen_banc;  
  v_Path_Impresora  := impresora;
  
  if formatoimpresion is null then
    raise_application_error(-20001,'Debe asignar un formato de impresi?n de cheque!');  
  end if;  
  
    if impresora is null then
      raise_application_error(-20001,'Debe asignar una direcci?n de impresora!');
    else  
      declare
        impresoranoregistrada exception;
        pragma exception_init(impresoranoregistrada, -302000);
        v_alert number;
        salir exception;
        begin
        v_impresora := text_io.fopen(v_Path_Impresora, 'W'); --abrir puerto de impresora
        text_io.fclose(v_impresora); --cerrar impresora
      exception
        when impresoranoregistrada then
          impresora := null;
          raise_application_error(-20001,'No se podr? imprimir el cheque.la impresora que desea utilizar no se encuentra. verifique los datos de la configuracion de cuentas bancarias');
        when salir then
          null;
      end;
   end if;
  
  
exception
  when no_data_found then
    formatoimpresion := null;
    impresora        := null;

end;


procedure pp_impr_cheq_emit is                                                         
  cursor c_cheq_emit  (p_movi_codi in number) is
    select c.cheq_codi, c.cheq_cuen_codi
      from come_movi m, come_movi_cheq mc, come_cheq c
     where m.movi_codi = mc.chmo_movi_codi
       and c.cheq_codi   = mc.chmo_cheq_codi
       and m.movi_codi   = p_movi_codi
       and rtrim(ltrim(c.cheq_tipo)) = 'E';

  v_impresora      text_io.file_type;
  v_path_impresora varchar2(60);
  v_cheq_codi      number;
  v_form_impr      number;
begin                                                
     for x in c_cheq_emit (bcab.movi_codi) loop
       pp_buscar_formato_cheque(x.cheq_cuen_codi, v_form_impr, v_Path_Impresora);
       if v_form_impr is not null and v_path_impresora is not null then
          v_impresora := text_io.fopen(v_Path_Impresora, 'W'); --abrir puerto de impresora     
          v_cheq_codi := x.cheq_codi;              
          pl_imprimir_cheque(v_impresora, v_cheq_codi, v_form_impr);          
          text_io.fclose(v_impresora); --cerrar impresora
        end if;  
     end loop;       
   text_io.fclose(v_impresora); --cerrar impresora
end pp_impr_cheq_emit; 
*/
procedure pp_actu_secu  is
begin        
	
	if rtrim(ltrim(upper(parameter.p_para_inic))) = rtrim(ltrim(upper('C'))) then  
    update come_secu
       set secu_nume_cobr = bcab.movi_nume
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  end if;
  
end;  


procedure pp_insert_movi_conc_deta_adel  (         
p_moco_movi_codi in number,               
p_moco_nume_item in number,
p_moco_conc_codi in number,
p_moco_cuco_codi in number,
p_moco_impu_codi in number,
p_moco_impo_mmnn in number,
p_moco_impo_mmee in number,
p_moco_impo_mone in number,
p_moco_dbcr      in varchar2, 
p_moco_tiim_codi in number,
p_moco_impo_codi in number,
p_moco_ceco_codi in number) is
                        
begin               
  insert into come_movi_conc_deta (
  moco_movi_codi ,
  moco_nume_item ,
  moco_conc_codi ,
  moco_cuco_codi ,
  moco_impu_codi ,
  moco_impo_mmnn ,
  moco_impo_mmee ,
  moco_impo_mone ,
  moco_dbcr      ,
  moco_tiim_codi , 
  moco_impo_codi ,
  moco_ceco_codi ,
  moco_base     ,
  moco_impo_mone_ii,
  moco_impo_mmnn_ii, 
  moco_exen_mone, 
  moco_exen_mmnn  ) values (
  p_moco_movi_codi ,
  p_moco_nume_item ,
  p_moco_conc_codi ,
  p_moco_cuco_codi ,
  p_moco_impu_codi ,
  p_moco_impo_mmnn ,
  p_moco_impo_mmee ,
  p_moco_impo_mone ,
  p_moco_dbcr      ,
  p_moco_tiim_codi ,
  p_moco_impo_codi ,
  p_moco_ceco_codi ,
  parameter.p_codi_base,
  p_moco_impo_mone,
  p_moco_impo_mmnn,
  p_moco_impo_mone,
  p_moco_impo_mmnn);
  

end ;

procedure pp_inse_movi_impu_deta_adel (            
p_moim_impu_codi in number,   
p_moim_movi_codi in number,
p_moim_impo_mmnn in number,
p_moim_impo_mmee in number,
p_moim_impu_mmnn in number,
p_moim_impu_mmee in number,
p_moim_impo_mone in number,
p_moim_impu_mone in number
) is                                          
begin
	
  insert into come_movi_impu_deta g (
  moim_impu_codi,
  moim_movi_codi,
  moim_impo_mmnn,
  moim_impo_mmee,
  moim_impu_mmnn,
  moim_impu_mmee,
  moim_impo_mone,
  moim_impu_mone, 
  moim_exen_mmnn, 
  moim_exen_mone,
   moim_impo_mone_ii, 
   moim_impo_mmnn_ii,
  moim_base) values (
  p_moim_impu_codi , 
  p_moim_movi_codi ,
  p_moim_impo_mmnn ,
  p_moim_impo_mmee ,
  p_moim_impu_mmnn ,
  p_moim_impu_mmee ,
  p_moim_impo_mone ,
  p_moim_impu_mone ,
  p_moim_impo_mmnn ,
  p_moim_impu_mone ,
  p_moim_impu_mone ,
   p_moim_impo_mmnn ,  
  parameter.p_codi_base );
 end pp_inse_movi_impu_deta_adel; 
  
procedure pp_insert_come_movi_cuot_adel (             
p_cuot_fech_venc    in date     ,  
p_cuot_nume         in number   ,
p_cuot_impo_mone    in number   ,
p_cuot_impo_mmnn    in number   ,
p_cuot_impo_mmee    in number   ,
p_cuot_sald_mone    in number   ,
p_cuot_sald_mmnn    in number   ,
p_cuot_sald_mmee    in number   ,
p_cuot_movi_codi    in number   
) is
begin
  
  insert into come_movi_cuot (
  cuot_fech_venc    ,
  cuot_nume         ,
  cuot_impo_mone    ,
  cuot_impo_mmnn    ,
  cuot_impo_mmee    ,
  cuot_sald_mone    ,
  cuot_sald_mmnn    ,
  cuot_sald_mmee    ,
  cuot_movi_codi    , 
  cuot_base)  
  values (
  p_cuot_fech_venc    ,
  p_cuot_nume         ,
  p_cuot_impo_mone    ,
  p_cuot_impo_mmnn    ,
  p_cuot_impo_mmee    ,
  p_cuot_sald_mone    ,
  p_cuot_sald_mmnn    ,
  p_cuot_sald_mmee    ,
  p_cuot_movi_codi    ,
  parameter.p_codi_base
  );
  
  
end pp_insert_come_movi_cuot_adel;

procedure pp_insert_come_movi_adel (              
p_movi_codi                       in  number  ,
p_movi_timo_codi                  in  number  ,
p_movi_clpr_codi                  in  number  ,
p_movi_sucu_codi_orig             in  number  ,
p_movi_depo_codi_orig             in  number  ,
p_movi_sucu_codi_dest             in  number  ,
p_movi_depo_codi_dest             in  number  ,
p_movi_oper_codi                  in  number  ,
p_movi_cuen_codi                  in  number  ,
p_movi_mone_codi                  in  number  ,
p_movi_nume                       in  number  ,
p_movi_fech_emis                  in  date  ,
p_movi_fech_grab                  in  date  ,
p_movi_user                       in  varchar2  ,
p_movi_codi_padr                  in  number  ,
p_movi_tasa_mone                  in  number  ,
p_movi_tasa_mmee                  in  number  ,
p_movi_grav_mmnn                  in  number  ,
p_movi_exen_mmnn                  in  number  ,
p_movi_iva_mmnn                   in  number  ,
p_movi_grav_mmee                  in  number  ,
p_movi_exen_mmee                  in  number  ,
p_movi_iva_mmee                   in  number  ,
p_movi_grav_mone                  in  number  ,
p_movi_exen_mone                  in  number  ,
p_movi_iva_mone                   in  number  ,
p_movi_obse                       in  varchar2  ,
p_movi_sald_mmnn                  in  number  ,
p_movi_sald_mmee                  in  number  ,
p_movi_sald_mone                  in  number  ,
p_movi_stoc_suma_rest             in  varchar2  ,
p_movi_clpr_dire                  in  varchar2  ,
p_movi_clpr_tele                  in  varchar2  ,
p_movi_clpr_ruc                   in  varchar2  ,
p_movi_clpr_desc                  in  varchar2  ,
p_movi_emit_reci                  in  varchar2  ,
p_movi_afec_sald                  in  varchar2  ,
p_movi_dbcr                       in  varchar2  ,
p_movi_stoc_afec_cost_prom        in  varchar2  ,
p_movi_empr_codi                  in  number  ,
p_movi_clave_orig                 in  number  ,
p_movi_clave_orig_padr            in  number  ,
p_movi_indi_iva_incl              in  varchar2  ,
p_movi_empl_codi                  in  number, 
p_movi_nume_timb                  in varchar2 ,
p_movi_fech_oper                  in date, 
p_movi_fech_venc_timb             in date,
p_movi_codi_rete                  in number,
p_movi_excl_cont                  in varchar2

) is
begin
  insert into come_movi (
  movi_codi                        ,
  movi_timo_codi                   ,
  movi_clpr_codi                   ,
  movi_sucu_codi_orig              ,
  movi_depo_codi_orig              ,
  movi_sucu_codi_dest              ,
  movi_depo_codi_dest              ,
  movi_oper_codi                   ,
  movi_cuen_codi                   ,
  movi_mone_codi                   ,
  movi_nume                        ,
  movi_fech_emis                   ,
  movi_fech_grab                   ,
  movi_user                        ,
  movi_codi_padr                   ,
  movi_tasa_mone                   ,
  movi_tasa_mmee                   ,
  movi_grav_mmnn                   ,
  movi_exen_mmnn                   ,
  movi_iva_mmnn                    ,
  movi_grav_mmee                   ,
  movi_exen_mmee                   ,
  movi_iva_mmee                    ,
  movi_grav_mone                   ,
  movi_exen_mone                   ,
  movi_iva_mone                    ,
  movi_obse                        ,
  movi_sald_mmnn                   ,
  movi_sald_mmee                   ,
  movi_sald_mone                   ,
  movi_stoc_suma_rest              ,
  movi_clpr_dire                   ,
  movi_clpr_tele                   ,
  movi_clpr_ruc                    ,
  movi_clpr_desc                   ,
  movi_emit_reci                   ,
  movi_afec_sald                   ,
  movi_dbcr                        ,
  movi_stoc_afec_cost_prom         ,
  movi_empr_codi                   ,
  movi_clave_orig                  , 
  movi_clave_orig_padr             ,
  movi_indi_iva_incl               ,
  movi_empl_codi                   ,
  movi_base                  ,
  movi_fech_oper         ) values (
  p_movi_codi                       ,
  p_movi_timo_codi                  ,
  p_movi_clpr_codi                  ,
  p_movi_sucu_codi_orig             ,
  p_movi_depo_codi_orig             ,
  p_movi_sucu_codi_dest             ,
  p_movi_depo_codi_dest             ,
  p_movi_oper_codi                  ,
  p_movi_cuen_codi                  ,
  p_movi_mone_codi                  ,
  p_movi_nume                       ,
  p_movi_fech_emis                  ,
  sysdate,--p_movi_fech_grab                  ,
  p_movi_user                       ,
  p_movi_codi_padr                  ,
  p_movi_tasa_mone                  ,
  p_movi_tasa_mmee                  ,
  p_movi_grav_mmnn                  ,
  p_movi_exen_mmnn                  ,
  p_movi_iva_mmnn                   ,
  p_movi_grav_mmee                  ,
  p_movi_exen_mmee                  ,
  p_movi_iva_mmee                   ,
  p_movi_grav_mone                  ,
  p_movi_exen_mone                  ,
  p_movi_iva_mone                   ,
  p_movi_obse                       ,
  p_movi_sald_mmnn                  ,
  p_movi_sald_mmee                  ,
  p_movi_sald_mone                  ,
  p_movi_stoc_suma_rest             ,
  p_movi_clpr_dire                  ,
  p_movi_clpr_tele                  ,
  p_movi_clpr_ruc                   ,
  p_movi_clpr_desc                  ,
  p_movi_emit_reci                  ,
  p_movi_afec_sald                  ,
  p_movi_dbcr                       ,
  p_movi_stoc_afec_cost_prom        ,
  p_movi_empr_codi                  ,
  p_movi_clave_orig                 ,
  p_movi_clave_orig_padr            ,
  p_movi_indi_iva_incl              ,
  p_movi_empl_codi                  ,
  parameter.p_codi_base            ,
  p_movi_fech_oper
  );
  
  


end pp_insert_come_movi_adel;




  



procedure pp_actualiza_come_movi_adel is
  v_movi_codi                number;
  v_movi_timo_codi           number;
  v_movi_clpr_codi           number;
  v_movi_sucu_codi_orig      number;
  v_movi_depo_codi_orig      number;
  v_movi_sucu_codi_dest      number;
  v_movi_depo_codi_dest      number;
  v_movi_oper_codi           number;
  v_movi_cuen_codi           number;
  v_movi_mone_codi           number;
  v_movi_nume                number;
  v_movi_fech_emis           date;
  v_movi_fech_grab           date;
  v_movi_user                varchar2(20);
  v_movi_codi_padr           number;
  v_movi_tasa_mone           number;
  v_movi_tasa_mmee           number;
  v_movi_grav_mmnn           number;
  v_movi_exen_mmnn           number;
  v_movi_iva_mmnn            number;
  v_movi_grav_mmee           number;
  v_movi_exen_mmee           number;
  v_movi_iva_mmee            number;
  v_movi_grav_mone           number;
  v_movi_exen_mone           number;
  v_movi_iva_mone            number;
  v_movi_obse                varchar2(2000);
  v_movi_sald_mmnn           number;
  v_movi_sald_mmee           number;
  v_movi_sald_mone           number;
  v_movi_stoc_suma_rest      varchar2(1);
  v_movi_clpr_dire           varchar2(100);
  v_movi_clpr_tele           varchar2(50);
  v_movi_clpr_ruc            varchar2(20);
  v_movi_clpr_desc           varchar2(80);
  v_movi_emit_reci           varchar2(1);
  v_movi_afec_sald           varchar2(3);
  v_movi_dbcr                varchar2(10);
  v_movi_stoc_afec_cost_prom varchar2(1);
  v_movi_empr_codi           number;
  v_movi_clave_orig          number;
  v_movi_clave_orig_padr     number;
  v_movi_indi_iva_incl       varchar2(1);
  v_movi_empl_codi           number;
  v_movi_nume_timb           varchar2(20);
  v_movi_fech_venc_timb      date;
  v_movi_fech_oper           date;
  v_movi_excl_cont           varchar2(1);
  v_movi_impo_reca           number;
  v_movi_afec_sald1           varchar2(3000);
  
    --variables para moco
  v_moco_movi_codi number;
  v_moco_nume_item number;
  v_moco_conc_codi number;
  v_moco_cuco_codi number;
  v_moco_impu_codi number;
  v_moco_impo_mmnn number;
  v_moco_impo_mmee number;
  v_moco_impo_mone number;
  v_moco_dbcr      varchar2(1);
v_moim_cuen_codi number;
begin
  bcab.movi_timo_codi := parameter.p_codi_timo_adle;
	--verificar ultimo numero
 -- I020234.pp_carga_secu(bcab.movi_nume, bcab.movi_timo_codi);
  --- asignar valores....
 -- i020103.pp_buscar_nume(bcab.movi_nume);
  

  bcab.movi_codi      := fa_sec_come_movi;
  
 
 -- bcab.movi_timo_codi := parameter.p_codi_timo;
     -- raise_application_error(-20001,bcab.movi_timo_codi); 
  general_skn.pl_muestra_come_tipo_movi(bcab.movi_timo_codi,
                                        bcab.movi_timo_desc,
                                        bcab.movi_timo_desc_abre,
                                        bcab.movi_afec_sald,
                                        bcab.movi_dbcr);
          --raise_application_error (-20001,LENGTH(bcab.movi_afec_sald ));                                 
      --bcab.movi_afec_sald := v_movi_afec_sald1;    
      
    --     raise_application_error (-20001,LENGTH(v_movi_afec_sald1 ));   
    
    /*
        begin
   select  distinct c006 o_moim_cuen_codi
      into v_moim_cuen_codi
      from apex_collections_full
     where collection_name = 'FORMA_PAGO'
       and c001 in (1,5)
       and c049 = v('P31_APP_ID_ORIG')
       and c050 = v('P31_PAGE_ID_ORIG'); 
   end; */
                                  
  bcab.movi_fech_grab := sysdate;
  bcab.movi_user      := gen_user;
  bcab.movi_emit_reci := bcab.p_emit_reci;---
  bcab.movi_tasa_mmee := 0;
  bcab.movi_grav_mmnn := 0;
  bcab.movi_iva_mmnn  := 0;
  bcab.movi_grav_mmee := 0;
  bcab.movi_exen_mmee := round((bcab.s_dife * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
  bcab.movi_iva_mmee  := 0;
  bcab.movi_grav_mone := 0;
  bcab.movi_iva_mone  := 0;
  bcab.movi_sald_mmnn := round((bcab.s_dife * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
  bcab.movi_sald_mmee := 0;
  bcab.movi_sald_mone := round((bcab.s_dife * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);

  v_movi_codi           := bcab.movi_codi;
  v_movi_timo_codi      := bcab.movi_timo_codi;
  v_movi_clpr_codi      := bcab.movi_clpr_codi;
  v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
  v_movi_depo_codi_orig := null;
  v_movi_sucu_codi_dest := null;
  v_movi_depo_codi_dest := null;
  v_movi_oper_codi      := null;
  v_movi_cuen_codi      := null;
  v_movi_mone_codi      := bcab.movi_mone_codi;
  v_movi_nume           := bcab.movi_nume;
  v_movi_fech_emis      := bcab.movi_fech_emis;
  v_movi_fech_oper      := bcab.movi_fech_oper;
  v_movi_fech_grab      := bcab.movi_fech_grab;
  v_movi_user           := bcab.movi_user;
  v_movi_codi_padr      := null;
  v_movi_tasa_mone      := bcab.movi_tasa_mone;
  v_movi_tasa_mmee      :=  bcab.movi_tasa_mone;
  v_movi_grav_mmnn      := bcab.movi_grav_mmnn;
  v_movi_exen_mmnn      := round((bcab.s_dife * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
  v_movi_iva_mmnn       := bcab.movi_iva_mmnn;
  v_movi_grav_mmee      := null;
  v_movi_exen_mmee      := null;
  v_movi_iva_mmee       := null;
  v_movi_grav_mone      := null;
  v_movi_exen_mone      := bcab.s_dife;
  v_movi_iva_mone       := null;
  v_movi_obse           := bcab.movi_obse;
  v_movi_sald_mmnn      := round((bcab.s_dife * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
  v_movi_sald_mmee      := 0;
  v_movi_sald_mone      := bcab.s_dife;
  v_movi_stoc_suma_rest := null;

  v_movi_clpr_dire := null;
  v_movi_clpr_tele := null;
  v_movi_clpr_ruc  := null;

  v_movi_clpr_desc := bcab.movi_clpr_desc;



  v_movi_emit_reci := bcab.movi_emit_reci;
  v_movi_afec_sald := bcab.movi_afec_sald;

   
 v_movi_dbcr      := replace(bcab.movi_dbcr,'');
 

  v_movi_stoc_afec_cost_prom := null;
  v_movi_empr_codi           := parameter.p_empr_codi;
  v_movi_clave_orig          := null;
  v_movi_clave_orig_padr     := null;
  v_movi_indi_iva_incl       := null;
  v_movi_empl_codi           := null;

  v_movi_nume_timb      := null;
  v_movi_fech_venc_timb := null;
  v_movi_impo_reca      := 0;
  

  pp_insert_come_movi_adel(v_movi_codi,
                      v_movi_timo_codi,
                      v_movi_clpr_codi,
                      v_movi_sucu_codi_orig,
                      v_movi_depo_codi_orig,
                      v_movi_sucu_codi_dest,
                      v_movi_depo_codi_dest,
                      v_movi_oper_codi,
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
                      v_movi_stoc_suma_rest,
                      v_movi_clpr_dire,
                      v_movi_clpr_tele,
                      v_movi_clpr_ruc,
                      v_movi_clpr_desc,
                      v_movi_emit_reci,
                      v_movi_afec_sald,
                      v_movi_dbcr,
                      v_movi_stoc_afec_cost_prom,
                      v_movi_empr_codi,
                      v_movi_clave_orig,
                      v_movi_clave_orig_padr,
                      v_movi_indi_iva_incl,
                      v_movi_empl_codi,
                      null,
                      null,
                      v_movi_fech_oper,
                      null,
                      null);
                      
   pp_insert_come_movi_cuot_adel (  v_movi_fech_emis,
                                    1,
                                    v_movi_exen_mone,
                                    v_movi_exen_mmnn,
                                    null,--p_cuot_impo_mmee
                                    v_movi_exen_mone,
                                    v_movi_exen_mmnn,
                                    null,--p_cuot_sald_mmee
                                    v_movi_codi 
) ;            
        
 pp_inse_movi_impu_deta_adel (            
                  1,   
                  v_movi_codi,
                  v_movi_exen_mmnn,
                  null,--p_moim_impo_mmee in number,
                  v_movi_exen_mmnn,
                  null,--p_moim_impu_mmee in number,
                  v_movi_exen_mone,
                  v_movi_exen_mone
                  );            
                                        
----actualizar moco.... 
  v_moco_movi_codi := bcab.movi_codi;
  v_moco_nume_item := 0;
  v_moco_conc_codi := parameter.p_codi_conc_adle;--p_codi_conc;
  v_moco_dbcr      := bcab.movi_dbcr;
  v_moco_nume_item := v_moco_nume_item + 1;
  v_moco_cuco_codi := null;
  v_moco_impu_codi := parameter.p_codi_impu_exen;
  v_moco_impo_mmnn :=  round((bcab.s_dife * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
  v_moco_impo_mmee := 0;
  v_moco_impo_mone :=bcab.s_dife;

  pp_insert_movi_conc_deta_Adel(v_moco_movi_codi,
                                 v_moco_nume_item,
                                 v_moco_conc_codi,
                                 v_moco_cuco_codi,
                                 v_moco_impu_codi,
                                 v_moco_impo_mmnn,
                                 v_moco_impo_mmee,
                                 v_moco_impo_mone,
                                 v_moco_dbcr,
                                 null,
                                 null,
                                 null);
                           
                           
end pp_actualiza_come_movi_adel;




procedure pp_insert_come_movi_cheq (p_chmo_movi_codi in number,            
                                    p_chmo_cheq_codi in number,
                                    p_chmo_esta_ante in varchar2  ,
                                    p_chmo_cheq_secu in number) is

begin
  insert into come_movi_cheq (
  chmo_movi_codi ,
	chmo_cheq_codi ,
	chmo_esta_ante ,
	chmo_cheq_secu ,
	chmo_base      )  values (
  p_chmo_movi_codi ,
	p_chmo_cheq_codi ,
	p_chmo_esta_ante ,
	p_chmo_cheq_secu ,
	parameter.p_codi_base); 
    
end pp_insert_come_movi_cheq;



----de aca a arriba todo a delanto


procedure pp_insert_come_cheq  (  p_cheq_codi               number    ,
                                  p_cheq_mone_codi          number    ,
                                  p_cheq_banc_codi          number    ,
                                  p_cheq_nume               number    ,
                                  p_cheq_serie              varchar2  ,
                                  p_cheq_fech_emis          date      ,
                                  p_cheq_fech_venc          date      ,
                                  p_cheq_impo_mone          number    ,
                                  p_cheq_impo_mmnn          number    ,
                                  p_cheq_tipo               varchar2  ,
                                  p_cheq_clpr_codi          number    ,
                                  p_cheq_esta               varchar2  ,
                                  p_cheq_nume_cuen          varchar2  ,
                                  p_cheq_user               varchar2  ,
                                  p_cheq_fech_grab          date      ,
                                  p_cheq_cuen_codi          number    ,
                                  p_cheq_indi_ingr_manu     varchar2  ,
                                  p_cheq_orde               varchar2  ,
                                  p_cheq_tasa_mone          number    ,
                                  p_cheq_tach_codi          number ,
                                  p_cheq_titu               varchar2 ,
                                  p_cheq_indi_terc           varchar2) is

begin
  insert into come_cheq (
  cheq_codi               ,
  cheq_mone_codi          ,
  cheq_banc_codi          ,
  cheq_nume               ,
  cheq_serie              ,
  cheq_fech_emis          ,
  cheq_fech_venc          ,
  cheq_impo_mone          ,
  cheq_impo_mmnn          ,
  cheq_tipo               ,
  cheq_clpr_codi          ,
  cheq_esta               ,
  cheq_nume_cuen          ,
  cheq_user               ,
  cheq_fech_grab          ,
  cheq_cuen_codi          ,
  cheq_indi_ingr_manu     ,
  cheq_orde               ,
  cheq_tasa_mone          ,
  cheq_tach_codi          ,
  cheq_base               ,
  cheq_titu      ,
  cheq_indi_terc     ) values (
  p_cheq_codi               ,
  p_cheq_mone_codi          ,
  p_cheq_banc_codi          ,
  p_cheq_nume               ,
  p_cheq_serie              ,
  p_cheq_fech_emis          ,
  p_cheq_fech_venc          ,
  p_cheq_impo_mone          ,
  p_cheq_impo_mmnn          ,
  p_cheq_tipo               ,
  p_cheq_clpr_codi          ,
  p_cheq_esta               ,
  p_cheq_nume_cuen          ,
  GEN_USER               ,
  sysdate          ,
  p_cheq_cuen_codi          ,
  p_cheq_indi_ingr_manu     ,
  p_cheq_orde               ,
  p_cheq_tasa_mone          ,
  p_cheq_tach_codi          ,
  parameter.p_codi_base   ,
  p_cheq_titu ,
  p_cheq_indi_terc);
  
end pp_insert_come_cheq;


---Actualiza los cheques emitidos, en caso q sea un pago a un proveedor, y se utiliz? una
---cuenta  bancaria externa

procedure pp_actualiza_cheque_emit(p_cheq_codi out number, p_seq_id in number) is
  v_cheq_codi               number      ;
  v_cheq_mone_codi          number      ;
  v_cheq_banc_codi          number      ;
  v_cheq_nume               number  ;
  v_cheq_serie              varchar2(3) ;
  v_cheq_nume_cuen          varchar2(20)  ;
  v_cheq_fech_emis          varchar2(20)        ;
  v_cheq_fech_venc          varchar2(20)        ;
  v_cheq_impo_mone          number      ;
  v_cheq_impo_mmnn          number      ;
  v_cheq_tipo               varchar2(1) ;     
  v_cheq_clpr_codi          number      ;
  v_cheq_esta               varchar2(1) ;
  v_cheq_fech_grab          date;
  v_cheq_user               varchar2(10);
  v_cheq_cuen_codi          number;
  v_cheq_indi_ingr_manu     varchar2(1):= 'N';
  v_cheq_orde               varchar2(60);
  v_cheq_tasa_mone          number;
  v_cheq_tach_codi          number;
  
  v_chmo_movi_codi          number;
  v_chmo_cheq_codi          number;
  v_chmo_esta_ante          varchar2(1);
  v_chmo_cheq_secu          number;
              

cursor g_cur_bfp2 is
select seq_id,
       c001     pago_tipo,
       c002     pago_tipo_ant,
       c003     pago_desc,
       c004     pago_cobr_indi,
       c005     mone_codi,
       c006     mone_desc,
       c007     mone_cant_deci,
       c008     mone_desc_abre,
       c009     cuen_indi_caja_banc,
       c010     pago_cuen_codi,
       c011     pago_cuen_desc,
       c012     pago_impo_mone,
       c013     pago_impo_mmnn,
       c014     pago_impo_movi,
       c015     pago_coti,
      ----------------------------
       c016     cheq_serie,
       c017     cheq_indi_terc,
       c018     cheq_nume,
       c019     cheq_impo_mone,
       c020     cheq_cuen_codi,
       c021     cheq_mone_codi,
       c022     cheq_banc_codi,
       c023     cheq_nume_cuen,
       c024     cheq_titu,
       c025     cheq_fech_emis,
       c026    cheq_fech_venc
  from apex_collections
  where collection_name = 'DETA_PAGO'
    and seq_id = p_seq_id;
begin
 
     for bfp in g_cur_bfp2 loop
      v_cheq_tipo               := 'E'; --emitido       
      v_cheq_clpr_codi          := bcab.movi_clpr_codi;
      v_cheq_esta               := 'I'; --ingresado        
      v_cheq_user               := substr(gen_user,1,10);
      v_cheq_fech_grab          := sysdate;       
      v_chmo_movi_codi          := bcab.movi_codi;
      v_cheq_orde               := nvl(bfp.cheq_titu, substr(bcab.movi_clpr_desc,1,60));         
      v_cheq_mone_codi          := bfp.cheq_mone_codi;  
      v_cheq_nume_cuen          := bfp.cheq_nume_cuen;
      v_cheq_cuen_codi          := bfp.cheq_cuen_codi;       
      v_cheq_banc_codi          := bfp.cheq_banc_codi; 
      v_cheq_codi               := fa_sec_come_cheq;
    
      p_cheq_codi               := v_cheq_codi; --- envia el valor para insertar en come_movi_impo_deta       
     --  raise_application_error(-20001,'ddkkd');  
      v_cheq_nume               := bfp.cheq_nume;  
   
      v_cheq_serie              := bfp.cheq_serie;  
       --  RAISE_APPLICATION_ERROR(-20001, bfp.cheq_fech_emis);  
      v_cheq_fech_emis          := bfp.cheq_fech_emis;  
      v_cheq_fech_venc          := bfp.cheq_fech_venc;   
        
      v_cheq_impo_mone          := bfp.pago_impo_mone;  
    
      v_cheq_impo_mmnn          := round((bfp.pago_impo_mone* bfp.pago_coti), parameter.p_cant_deci_mmnn);             
      v_cheq_tasa_mone          := bfp.pago_coti;
      v_cheq_tach_codi          := null;--:bcheq_emit.cheq_tach_codi;
      
      v_chmo_cheq_codi          := v_cheq_codi;
      v_chmo_esta_ante          := null; --pq no tiene estado anterior..., o sea es el primier mov. dl chque
      v_chmo_cheq_secu          := 1; --tendr? la secuencia 1 pq es el movimiento q dio origen al cheque...
     
     end loop;
     
   
           
      pp_insert_come_cheq  (

        v_cheq_codi          ,
        v_cheq_mone_codi     ,
        v_cheq_banc_codi     ,
        v_cheq_nume          ,
        v_cheq_serie         ,
        v_cheq_fech_emis     ,
        v_cheq_fech_venc     ,
        v_cheq_impo_mone     ,
        v_cheq_impo_mmnn     ,
        v_cheq_tipo          ,
        v_cheq_clpr_codi     ,
        v_cheq_esta          ,
        v_cheq_nume_cuen     ,
        v_cheq_user          ,
        v_cheq_fech_grab     ,
        v_cheq_cuen_codi     ,
        v_cheq_indi_ingr_manu,
        v_cheq_orde          ,
        v_cheq_tasa_mone     ,
        v_cheq_tach_codi ,
        null ,
        null) ;         
      pp_insert_come_movi_cheq (              
        v_chmo_movi_codi ,
        v_chmo_cheq_codi ,
        v_chmo_esta_ante ,
        v_chmo_cheq_secu );
end pp_actualiza_cheque_emit;
---Acualiza los cheques recibidos, en caso q sea un pago a un proveedor, y se utiliz? una
---cuenta bancaria externa
             
procedure pp_actualiza_cheque_reci(p_cheq_codi out number, p_seq_id number) is
v_cheq_codi               number      ;
v_cheq_mone_codi          number      ;
v_cheq_banc_codi          number      ;
v_cheq_nume               number      ;
v_cheq_nume_cuen          varchar2(20);
v_cheq_serie              varchar2(3) ;
v_cheq_fech_emis          date        ;    
v_cheq_fech_venc          date        ;
v_cheq_impo_mone          number      ;
v_cheq_impo_mmnn          number      ;
v_cheq_tipo               varchar2(1) ;
v_cheq_clpr_codi          number      ;
v_cheq_esta               varchar2(1) ;
v_cheq_orde               varchar2(60);
v_cheq_tasa_mone          number;
v_cheq_fech_grab          date;
v_cheq_user               varchar2(10);
v_cheq_cuen_codi          number;
v_cheq_indi_ingr_manu     varchar2(1):= 'N';
v_cheq_titu               varchar2(60);

v_chmo_movi_codi          number;
v_chmo_cheq_codi          number;
v_chmo_esta_ante          varchar2(1);
v_chmo_cheq_secu          number;
v_cheq_indi_terc          varchar2(1);            


cursor g_cur_bfp2 is
select seq_id,
       c001     pago_tipo,
       c002     pago_tipo_ant,
       c003     pago_desc,
       c004     pago_cobr_indi,
       c005     mone_codi,
       c006     mone_desc,
       c007     mone_cant_deci,
       c008     mone_desc_abre,
       c009     cuen_indi_caja_banc,
       c010     pago_cuen_codi,
       c011     pago_cuen_desc,
       c012     pago_impo_mone,
       c013     pago_impo_mmnn,
       c014     pago_impo_movi,
       c015     pago_coti,
      ----------------------------
       c016     cheq_serie,
       c017     cheq_indi_terc,
       c018     cheq_nume,
       c019     cheq_impo_mone,
       c020     cheq_cuen_codi,
       c021     cheq_mone_codi,
       c022     cheq_banc_codi,
       c023     cheq_nume_cuen,
       c024     cheq_titu,
       c025     cheq_fech_emis,
       c026     cheq_fech_venc
  from apex_collections
  where collection_name = 'DETA_PAGO'
    and seq_id = p_seq_id;
begin
 
     for bfp in g_cur_bfp2 loop
        v_cheq_tipo               := 'R'; --Recibido       
        v_cheq_clpr_codi          := bcab.movi_clpr_codi;          
        v_cheq_esta               := 'I'; --ingresado             
        v_cheq_user               := substr(gen_user,1,10);
        v_cheq_fech_grab          := sysdate;
        v_chmo_movi_codi          := bcab.movi_codi;
        v_cheq_cuen_codi          := bfp.cheq_cuen_codi;       
        v_cheq_mone_codi          := bfp.cheq_mone_codi;  
        v_cheq_tasa_mone          := bfp.pago_coti;
        v_cheq_codi               := fa_sec_come_cheq;
        p_cheq_codi               := v_cheq_codi;----- envia el valor para insertar en come_movi_impo_deta
        v_cheq_nume               := bfp.cheq_nume;  
        v_cheq_serie              := bfp.cheq_serie;  
        v_cheq_nume_cuen          := bfp.cheq_nume_cuen;               
        v_cheq_banc_codi          := bfp.cheq_banc_codi;       
        v_cheq_fech_emis          := bfp.cheq_fech_emis;  
        v_cheq_fech_venc          := bfp.cheq_fech_venc;    
        v_cheq_impo_mone          := bfp.pago_impo_mone;  
        v_cheq_impo_mmnn          := round((bfp.pago_impo_mone* bfp.pago_coti), parameter.p_cant_deci_mmnn);             
     
        v_chmo_cheq_codi          := v_cheq_codi;
        v_chmo_esta_ante          := null; --pq no tiene estado anterior..., o sea es el primier mov. dl chque
        v_chmo_cheq_secu          := 1; --tendr? la secuencia 1 pq es el movimiento q dio origen al cheque...
        v_cheq_titu               :=bfp.cheq_titu;
        v_cheq_indi_terc          :=bfp.cheq_indi_terc; 
        
      end loop;
        
        pp_insert_come_cheq  (
            v_cheq_codi          ,
            v_cheq_mone_codi     ,
            v_cheq_banc_codi     ,
            v_cheq_nume          ,
            v_cheq_serie         ,
            v_cheq_fech_emis     ,
            v_cheq_fech_venc     ,
            v_cheq_impo_mone     ,
            v_cheq_impo_mmnn     ,    
            v_cheq_tipo          ,
            v_cheq_clpr_codi     ,
            v_cheq_esta          ,
            v_cheq_nume_cuen     ,
            v_cheq_user          ,
            v_cheq_fech_grab     ,
            v_cheq_cuen_codi     ,
            v_cheq_indi_ingr_manu,
            v_cheq_orde, 
            v_cheq_tasa_mone     ,
            null,
            v_cheq_titu,
            v_cheq_indi_terc) ;
        
        pp_insert_come_movi_cheq (
            v_chmo_movi_codi ,
            v_chmo_cheq_codi ,
            v_chmo_esta_ante ,
            v_chmo_cheq_secu );
end;

procedure pp_insert_come_movi_impo_deta  (  p_moim_movi_codi in number,        
                                            p_moim_nume_item in number,                   
                                            p_moim_tipo      in varchar2,
                                            p_moim_cuen_codi in number,
                                            p_moim_dbcr      in varchar2,
                                            p_moim_afec_caja in varchar2,
                                            p_moim_fech      in date,
                                            p_moim_impo_mone in number,
                                            p_moim_impo_mmnn in number,
                                            p_moim_fech_oper in date,
                                            p_moim_cheq_codi in number,
                                            p_moim_tarj_cupo_codi in number,
                                            p_moim_form_pago  in number

                                            ) is
begin                  
  insert into come_movi_impo_deta (
    moim_movi_codi ,
    moim_nume_item ,
    moim_tipo      ,
    moim_cuen_codi ,
    moim_dbcr      ,
    moim_afec_caja ,
    moim_fech      ,
    moim_impo_mone ,
    moim_impo_mmnn ,
    moim_base       ,
    moim_fech_oper,
    moim_cheq_codi,
    moim_tarj_cupo_codi,
    moim_form_pago) values (
    
    p_moim_movi_codi ,
    p_moim_nume_item ,
    p_moim_tipo      ,
    p_moim_cuen_codi ,
    p_moim_dbcr      ,
    p_moim_afec_caja ,
    p_moim_fech      ,
    p_moim_impo_mone ,
    p_moim_impo_mmnn ,
    parameter.p_codi_base,
    p_moim_fech_oper,
    p_moim_cheq_codi,
    p_moim_tarj_cupo_codi,
    p_moim_form_pago);
  
end pp_insert_come_movi_impo_deta;


procedure pp_actualizar_moimpo is
  v_moim_movi_codi  number;
  v_moim_nume_item  number := 0;
  v_moim_tipo       varchar2(20);
  v_moim_cuen_codi  number;
  v_moim_dbcr       varchar2(1);
  v_moim_afec_caja  varchar2(1);
  v_moim_fech       date;
  v_moim_impo_mone  number;
  v_moim_impo_mmnn  number;
  v_moim_fech_oper  date;   
  v_moim_cheq_codi  number;
  v_moim_tarj_cupo_codi number; 
  v_moim_form_pago  number;
begin
  --cobranzas a clientes..............  
  
  if bcab.p_emit_reci = 'E' then
       v_moim_movi_codi := bcab.movi_codi;      
       
       for bfp in g_cur_bfp  loop
           
            v_moim_nume_item := v_moim_nume_item + 1;
            v_moim_cuen_codi := bfp.pago_cuen_codi;
            v_moim_dbcr      := bfp.pago_cobr_indi;
              
            if bfp.pago_tipo in ('1') then
                  v_moim_tarj_cupo_codi := null;
                  v_moim_cheq_codi      := null;
                  v_moim_afec_caja := 'S';
                  v_moim_fech      := bcab.movi_fech_emis;
                  v_moim_fech_oper := bcab.movi_fech_oper;
                  v_moim_tipo      := 'Efectivo';
            elsif bfp.pago_tipo in ('2') then
                  v_moim_tarj_cupo_codi := null;
                  v_moim_cheq_codi      := null;
                  pp_actualiza_cheque_reci(v_moim_cheq_codi, bfp.seq_id);
                  v_moim_fech      := bfp.cheq_fech_emis; 
                  v_moim_fech_oper := bfp.cheq_fech_emis;
                  if bfp.cheq_fech_venc > bfp.cheq_fech_emis then --cheq. dif           
                      v_moim_tipo      := 'Cheq. Dif. Rec.';
                      v_moim_afec_caja := 'N';
                   else --cheque dia
                      v_moim_tipo      := 'Cheq. Dia. Rec.';
                      v_moim_afec_caja := 'N';
                  end if;
             elsif bfp.pago_tipo in ('4') then
                    v_moim_tarj_cupo_codi := null;
                    v_moim_cheq_codi      := null;
                       
                    pp_actualiza_cheque_emit(v_moim_cheq_codi, bfp.seq_id);
                    
                    v_moim_fech      := bfp.cheq_fech_emis; 
                    v_moim_fech_oper := bfp.cheq_fech_emis;
                     if bfp.cheq_fech_venc > bfp.cheq_fech_emis then --cheq. dif 
                        v_moim_tipo      := 'Cheq. Dif. Emit.';
                        v_moim_afec_caja := 'S';
                     else --cheque dia
                        v_moim_tipo      := 'Cheq. Dia. Emit.';
                        v_moim_afec_caja := 'S';
                     end if;
                  
              elsif bfp.pago_tipo in ('5') then 
                      v_moim_tarj_cupo_codi := null;
                      v_moim_cheq_codi      := null;
                      v_moim_afec_caja := 'S';
                      v_moim_fech      := bcab.movi_fech_emis;
                      v_moim_fech_oper := bcab.movi_fech_oper;
                      v_moim_tipo      := 'Vuelto';
              end if;
         
            v_moim_impo_mone := bfp.pago_impo_mone;
            v_moim_impo_mmnn := round(bfp.pago_impo_mmnn, parameter.p_cant_deci_mmnn);        
            v_moim_form_pago := to_number(bfp.pago_tipo);
          
            pp_insert_come_movi_impo_deta (
              v_moim_movi_codi ,
              v_moim_nume_item ,
              v_moim_tipo      ,
              v_moim_cuen_codi ,
              v_moim_dbcr      ,
              v_moim_afec_caja ,
              v_moim_fech      ,
              v_moim_impo_mone ,
              v_moim_impo_mmnn , 
              v_moim_fech_oper ,
              v_moim_cheq_codi ,
              v_moim_tarj_cupo_codi,
              v_moim_form_pago   
              );
       
       end loop;
  end if;
  --pagos a proveedores.........  
  if bcab.p_emit_reci = 'R' then    
       v_moim_movi_codi := bcab.movi_codi;
     
      for bfp in g_cur_bfp  loop         
       
            v_moim_nume_item := v_moim_nume_item + 1;
            v_moim_cuen_codi := bfp.pago_cuen_codi;
            v_moim_dbcr      := bfp.pago_cobr_indi;
            if bfp.pago_tipo in ('1') then
                v_moim_tarj_cupo_codi := null;
                v_moim_cheq_codi      := null;
                v_moim_afec_caja := 'S';
                v_moim_fech      := bcab.movi_fech_emis;
                v_moim_fech_oper := bcab.movi_fech_oper;
                v_moim_tipo      := 'Efectivo';
            elsif bfp.pago_tipo in ('2') then
              v_moim_tarj_cupo_codi := null;
              v_moim_cheq_codi      := null;
              pp_actualiza_cheque_reci(v_moim_cheq_codi, bfp.seq_id);
              v_moim_fech      := bfp.cheq_fech_emis; 
              v_moim_fech_oper := bfp.cheq_fech_emis;
              if bfp.cheq_fech_venc > bfp.cheq_fech_emis then --cheq. dif           
                v_moim_tipo      := 'Cheq. Dif. Rec.';
                v_moim_afec_caja := 'N'; --no afecta caja porque recien lo hace cuando se realiza el deposito del cheque
              else --cheque dia
                v_moim_tipo      := 'Cheq. D?a. Rec.';
                v_moim_afec_caja := 'N';--no afecta caja porque recien lo hace cuando se realiza el deposito del cheque
              end if;
            elsif bfp.pago_tipo in ('4') then
              v_moim_tarj_cupo_codi := null;
              v_moim_cheq_codi      := null;
              pp_actualiza_cheque_emit(v_moim_cheq_codi,bfp.seq_id );
              v_moim_fech      := bfp.cheq_fech_venc;
              v_moim_fech_oper := bfp.cheq_fech_venc;
              if bfp.cheq_fech_venc > bfp.cheq_fech_emis then --cheq. dif 
                v_moim_tipo      := 'Cheq. Dif. Emit.';
                v_moim_afec_caja := 'S';
              else --cheque dia
                v_moim_tipo      := 'Cheq. D?a. Emit.';
                v_moim_afec_caja := 'S';
              end if;
            elsif bfp.pago_tipo in ('5') then 
                v_moim_tarj_cupo_codi := null;
                v_moim_cheq_codi      := null;
                v_moim_afec_caja := 'S';
                v_moim_fech      := bcab.movi_fech_emis;
                v_moim_fech_oper := bcab.movi_fech_oper;
                v_moim_tipo      := 'Vuelto';
            end if;         
            
            v_moim_impo_mone := bfp.pago_impo_mone;
            v_moim_impo_mmnn := round(bfp.pago_impo_mmnn, parameter.p_cant_deci_mmnn);        
            v_moim_form_pago := to_number(bfp.pago_tipo);
            
            pp_insert_come_movi_impo_deta (
              v_moim_movi_codi ,
              v_moim_nume_item ,
              v_moim_tipo      ,
              v_moim_cuen_codi ,
              v_moim_dbcr      ,
              v_moim_afec_caja ,
              v_moim_fech      ,
              v_moim_impo_mone ,
              v_moim_impo_mmnn ,
              v_moim_fech_oper ,
              v_moim_cheq_codi ,
              null,--v_moim_tarj_cupo_codi,
              v_moim_form_pago
              );
     
       end loop;
        
  end if;
end;

procedure pp_insert_movi_conc_deta  (         
p_moco_movi_codi in number,               
p_moco_nume_item in number,
p_moco_conc_codi in number,
p_moco_cuco_codi in number,
p_moco_impu_codi in number,
p_moco_impo_mmnn in number,
p_moco_impo_mmee in number,
p_moco_impo_mone in number,
p_moco_dbcr      in varchar2, 
p_moco_tiim_codi in number,
p_moco_impo_codi in number,
p_moco_ceco_codi in number) is
                        
begin               
  insert into come_movi_conc_deta (
  moco_movi_codi ,
  moco_nume_item ,
  moco_conc_codi ,
  moco_cuco_codi ,
  moco_impu_codi ,
  moco_impo_mmnn ,
  moco_impo_mmee ,
  moco_impo_mone ,
  moco_dbcr      ,
  moco_tiim_codi , 
  moco_impo_codi ,
  moco_ceco_codi ,
  moco_base  ,
  moco_impo_mone_ii,
  moco_impo_mmnn_ii, 
  moco_exen_mone, 
  moco_exen_mmnn    ) values (
  p_moco_movi_codi ,
  p_moco_nume_item ,
  p_moco_conc_codi ,
  p_moco_cuco_codi ,
  p_moco_impu_codi ,
  p_moco_impo_mmnn ,
  p_moco_impo_mmee ,
  p_moco_impo_mone ,
  p_moco_dbcr      ,
  p_moco_tiim_codi ,
  p_moco_impo_codi ,
  p_moco_ceco_codi ,
  parameter.p_codi_base,
  p_moco_impo_mone,
  p_moco_impo_mmnn,
  p_moco_impo_mone,
  p_moco_impo_mmnn
  );
  

end ;

procedure pp_actualizar_moco is

  --variables para moco
  v_moco_movi_codi number;
  v_moco_nume_item number;
  v_moco_conc_codi number;
  v_moco_cuco_codi number;
  v_moco_impu_codi number;
  v_moco_impo_mmnn number;
  v_moco_impo_mmee number;
  v_moco_impo_mone number;
  v_moco_dbcr      varchar2(1);

begin

  ----actualizar moco.... 
  v_moco_movi_codi := bcab.movi_codi;
  v_moco_nume_item := 0;
  v_moco_conc_codi := parameter.p_codi_conc;
  v_moco_dbcr      := bcab.movi_dbcr;
  v_moco_nume_item := v_moco_nume_item + 1;
  v_moco_cuco_codi := null;
  v_moco_impu_codi := parameter.p_codi_impu_exen;
  v_moco_impo_mmnn := round((bcab.sum_impo_pago * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
  v_moco_impo_mmee := 0;
  v_moco_impo_mone := bcab.sum_impo_pago;

  pp_insert_movi_conc_deta(v_moco_movi_codi,
                           v_moco_nume_item,
                           v_moco_conc_codi,
                           v_moco_cuco_codi,
                           v_moco_impu_codi,
                           v_moco_impo_mmnn,
                           v_moco_impo_mmee,
                           v_moco_impo_mone,
                           v_moco_dbcr,
                           null,
                           null,
                           null);
end pp_actualizar_moco;


procedure pp_insertar_cance is
  v_saldo number;
begin                

  for bdet in g_cur_bdet loop
     if bdet.s_marca = 'S' then
       if bdet.impo_pago > 0 then
         
        
       
       v_saldo := round(((nvl(bcab.movi_tasa_mone,0)-nvl(bdet.cuot_tasa_mone,0))*bdet.impo_pago),0);
       
       if v_saldo < 0 then
         v_saldo := 0;
       end if;
       
       
          insert into come_movi_cuot_canc(
           canc_movi_codi       ,  
           canc_cuot_movi_codi  ,
           canc_cuot_fech_venc  ,
           canc_fech_pago       ,  
           canc_impo_mone       ,  
           canc_impo_mmnn       ,  
           canc_impo_mmee       ,
           canc_base            , 
           canc_impo_dife_camb  )  
           values (
           bcab.movi_codi,
           bdet.cuot_movi_codi,       
           bdet.cuot_fech_venc,
           bcab.movi_fech_emis,
           bdet.impo_pago,                
           round((bdet.impo_pago * bcab.movi_tasa_mone),0),0,
           parameter.p_codi_base, 
           v_saldo
           
           );               
       end if;
     end if;
  end loop;  
end pp_insertar_cance;


procedure pp_insert_come_movi (              
p_movi_codi                       in  number  ,
p_movi_timo_codi                  in  number  ,
p_movi_clpr_codi                  in  number  ,
p_movi_sucu_codi_orig             in  number  ,
p_movi_depo_codi_orig             in  number  ,
p_movi_sucu_codi_dest             in  number  ,
p_movi_depo_codi_dest             in  number  ,
p_movi_oper_codi                  in  number  ,
p_movi_cuen_codi                  in  number  ,
p_movi_mone_codi                  in  number  ,
p_movi_nume                       in  number  ,
p_movi_fech_emis                  in  date  ,
p_movi_fech_grab                  in  date  ,
p_movi_user                       in  varchar2  ,
p_movi_codi_padr                  in  number  ,
p_movi_tasa_mone                  in  number  ,
p_movi_tasa_mmee                  in  number  ,
p_movi_grav_mmnn                  in  number  ,
p_movi_exen_mmnn                  in  number  ,
p_movi_iva_mmnn                   in  number  ,
p_movi_grav_mmee                  in  number  ,
p_movi_exen_mmee                  in  number  ,
p_movi_iva_mmee                   in  number  ,
p_movi_grav_mone                  in  number  ,
p_movi_exen_mone                  in  number  ,
p_movi_iva_mone                   in  number  ,
p_movi_obse                       in  varchar2  ,
p_movi_sald_mmnn                  in  number  ,
p_movi_sald_mmee                  in  number  ,
p_movi_sald_mone                  in  number  ,
p_movi_stoc_suma_rest             in  varchar2  ,
p_movi_clpr_dire                  in  varchar2  ,
p_movi_clpr_tele                  in  varchar2  ,
p_movi_clpr_ruc                   in  varchar2  ,
p_movi_clpr_desc                  in  varchar2  ,
p_movi_emit_reci                  in  varchar2  ,
p_movi_afec_sald                  in  varchar2  ,
p_movi_dbcr                       in  varchar2  ,
p_movi_stoc_afec_cost_prom        in  varchar2  ,
p_movi_empr_codi                  in  number  ,
p_movi_clave_orig                 in  number  ,
p_movi_clave_orig_padr            in  number  ,
p_movi_indi_iva_incl              in  varchar2  ,
p_movi_empl_codi                  in  number, 
p_movi_nume_timb                  in varchar2 ,
p_movi_fech_oper                  in date, 
p_movi_fech_venc_timb             in date,
p_movi_codi_rete                  in number,
p_movi_excl_cont                  in varchar2
) is
begin
  
  insert into come_movi (
  movi_codi                        ,
  movi_timo_codi                   ,
  movi_clpr_codi                   ,
  movi_sucu_codi_orig              ,
  movi_depo_codi_orig              ,
  movi_sucu_codi_dest              ,
  movi_depo_codi_dest              ,
  movi_oper_codi                   ,
  movi_cuen_codi                   ,
  movi_mone_codi                   ,
  movi_nume                        ,
  movi_fech_emis                   ,
  movi_fech_grab                   ,
  movi_user                        ,
  movi_codi_padr                   ,
  movi_tasa_mone                   ,
  movi_tasa_mmee                   ,
  movi_grav_mmnn                   ,
  movi_exen_mmnn                   ,
  movi_iva_mmnn                    ,
  movi_grav_mmee                   ,
  movi_exen_mmee                   ,
  movi_iva_mmee                    ,
  movi_grav_mone                   ,
  movi_exen_mone                   ,
  movi_iva_mone                    ,
  movi_obse                        ,
  movi_sald_mmnn                   ,
  movi_sald_mmee                   ,
  movi_sald_mone                   ,
  movi_stoc_suma_rest              ,
  movi_clpr_dire                   ,
  movi_clpr_tele                   ,
  movi_clpr_ruc                    ,
  movi_clpr_desc                   ,
  movi_emit_reci                   ,
  movi_afec_sald                   ,
  movi_dbcr                        ,
  movi_stoc_afec_cost_prom         ,
  movi_empr_codi                   ,
  movi_clave_orig                  , 
  movi_clave_orig_padr             ,
  movi_indi_iva_incl               ,
  movi_empl_codi                   ,                   
  movi_base                        , 
  movi_nume_timb                   ,
  movi_fech_oper                   ,
  movi_fech_venc_timb              ,
  movi_codi_rete                   ,
  movi_excl_cont ) values (
  
  p_movi_codi                       ,
  p_movi_timo_codi                  ,
  p_movi_clpr_codi                  ,
  p_movi_sucu_codi_orig             ,
  p_movi_depo_codi_orig             ,
  p_movi_sucu_codi_dest             ,
  p_movi_depo_codi_dest             ,
  p_movi_oper_codi                  ,
  p_movi_cuen_codi                  ,
  p_movi_mone_codi                  ,
  p_movi_nume                       ,
  p_movi_fech_emis                  ,
  SYSDATE                  ,
  p_movi_user                       ,
  p_movi_codi_padr                  ,
  p_movi_tasa_mone                  ,
  p_movi_tasa_mmee                  ,
  p_movi_grav_mmnn                  ,
  p_movi_exen_mmnn                  ,
  p_movi_iva_mmnn                   ,
  p_movi_grav_mmee                  ,
  p_movi_exen_mmee                  ,
  p_movi_iva_mmee                   ,
  p_movi_grav_mone                  ,
  p_movi_exen_mone                  ,
  p_movi_iva_mone                   ,
  p_movi_obse                       ,
  p_movi_sald_mmnn                  ,
  p_movi_sald_mmee                  ,
  p_movi_sald_mone                  ,
  p_movi_stoc_suma_rest             ,
  p_movi_clpr_dire                  ,
  p_movi_clpr_tele                  ,
  p_movi_clpr_ruc                   ,
  p_movi_clpr_desc                  ,
  p_movi_emit_reci                  ,
  p_movi_afec_sald                  ,
  p_movi_dbcr                       ,
  p_movi_stoc_afec_cost_prom        ,
  p_movi_empr_codi                  ,
  p_movi_clave_orig                 ,
  p_movi_clave_orig_padr            ,
  p_movi_indi_iva_incl              ,
  p_movi_empl_codi                  ,
  parameter.p_codi_base            ,
  p_movi_nume_timb                  ,
  p_movi_fech_oper                  ,
  p_movi_fech_venc_timb             ,
  p_movi_codi_rete                  ,
  p_movi_excl_cont
  );

end;

procedure pp_actualiza_come_movi is
  v_movi_codi                number;
  v_movi_timo_codi           number;
  v_movi_clpr_codi           number;
  v_movi_sucu_codi_orig      number;
  v_movi_depo_codi_orig      number;
  v_movi_sucu_codi_dest      number;
  v_movi_depo_codi_dest      number;
  v_movi_oper_codi           number;
  v_movi_cuen_codi           number;
  v_movi_mone_codi           number;
  v_movi_nume                number;
  v_movi_fech_emis           date;
  v_movi_fech_grab           date;
  v_movi_user                varchar2(20);
  v_movi_codi_padr           number;
  v_movi_tasa_mone           number;
  v_movi_tasa_mmee           number;
  v_movi_grav_mmnn           number;
  v_movi_exen_mmnn           number;
  v_movi_iva_mmnn            number;
  v_movi_grav_mmee           number;
  v_movi_exen_mmee           number;
  v_movi_iva_mmee            number;
  v_movi_grav_mone           number;
  v_movi_exen_mone           number;
  v_movi_iva_mone            number;
  v_movi_obse                varchar2(2000);
  v_movi_sald_mmnn           number;
  v_movi_sald_mmee           number;
  v_movi_sald_mone           number;
  v_movi_stoc_suma_rest      varchar2(1);
  v_movi_clpr_dire           varchar2(100);
  v_movi_clpr_tele           varchar2(50);
  v_movi_clpr_ruc            varchar2(20);
  v_movi_clpr_desc           varchar2(80);
  v_movi_emit_reci           varchar2(1);
  v_movi_afec_sald           varchar2(3);
  v_movi_dbcr                varchar2(10);
  v_movi_stoc_afec_cost_prom varchar2(1);
  v_movi_empr_codi           number;
  v_movi_clave_orig          number;
  v_movi_clave_orig_padr     number;
  v_movi_indi_iva_incl       varchar2(1);
  v_movi_empl_codi           number;
  v_movi_nume_timb           varchar2(20);
  v_movi_fech_venc_timb      date;
  v_movi_fech_oper           date;
  v_movi_excl_cont           varchar2(1);
  v_movi_impo_reca           number;
  v_movi_afec_sald1           varchar2(3000);
  
  v_moim_cuen_codi number;
begin

	--verificar ultimo numero
  I020234.pp_carga_secu(bcab.movi_nume, bcab.movi_timo_codi);
  --- asignar valores....

  bcab.movi_codi      := fa_sec_come_movi;
  
 
 -- bcab.movi_timo_codi := parameter.p_codi_timo;
     -- raise_application_error(-20001,bcab.movi_timo_codi); 
  general_skn.pl_muestra_come_tipo_movi(bcab.movi_timo_codi,
                                        bcab.movi_timo_desc,
                                        bcab.movi_timo_desc_abre,
                                        bcab.movi_afec_sald,
                                        bcab.movi_dbcr);
          --raise_application_error (-20001,LENGTH(bcab.movi_afec_sald ));                                 
      --bcab.movi_afec_sald := v_movi_afec_sald1;    
      
    --     raise_application_error (-20001,LENGTH(v_movi_afec_sald1 ));   
               
  bcab.movi_fech_grab := sysdate;
  bcab.movi_user      := gen_user;
  bcab.movi_emit_reci := bcab.p_emit_reci;
  bcab.movi_tasa_mmee := 0;
  bcab.movi_grav_mmnn := 0;
  bcab.movi_iva_mmnn  := 0;
  bcab.movi_grav_mmee := 0;
  bcab.movi_exen_mmee := round((bcab.sum_impo_pago * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);-- 0;
  bcab.movi_iva_mmee  := 0;
  bcab.movi_grav_mone := 0;
  bcab.movi_iva_mone  := 0;
  bcab.movi_sald_mmnn := 0;
  bcab.movi_sald_mmee := 0;
  bcab.movi_sald_mone := 0;

  v_movi_codi           := bcab.movi_codi;
  v_movi_timo_codi      := bcab.movi_timo_codi;
  v_movi_clpr_codi      := bcab.movi_clpr_codi;
  v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
  v_movi_depo_codi_orig := null;
  v_movi_sucu_codi_dest := null;
  v_movi_depo_codi_dest := null;
  v_movi_oper_codi      := null;
  v_movi_cuen_codi      := null;
  v_movi_mone_codi      := bcab.movi_mone_codi;
  v_movi_nume           := bcab.movi_nume;
  v_movi_fech_emis      := bcab.movi_fech_emis;
  v_movi_fech_oper      := bcab.movi_fech_oper;
  v_movi_fech_grab      := bcab.movi_fech_grab;
  v_movi_user           := bcab.movi_user;
  v_movi_codi_padr      := null;
  v_movi_tasa_mone      := bcab.movi_tasa_mone;
  v_movi_tasa_mmee      := bcab.movi_tasa_mone;--null;
  v_movi_grav_mmnn      := bcab.movi_grav_mmnn;
  v_movi_exen_mmnn      := round((bcab.sum_impo_pago * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
  v_movi_iva_mmnn       := bcab.movi_iva_mmnn;
  v_movi_grav_mmee      := null;
  v_movi_exen_mmee      := null;
  v_movi_iva_mmee       := null;
  v_movi_grav_mone      := null;
  v_movi_exen_mone      := bcab.sum_impo_pago;
  v_movi_iva_mone       := null;
  v_movi_obse           := bcab.movi_obse;
  v_movi_sald_mmnn      := round((bcab.sum_impo_pago * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
  v_movi_sald_mmee      := 0;
  v_movi_sald_mone      := round((bcab.sum_impo_pago * bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);--0;
  v_movi_stoc_suma_rest := null;

  v_movi_clpr_dire := null;
  v_movi_clpr_tele := null;
  v_movi_clpr_ruc  := null;

  v_movi_clpr_desc := bcab.movi_clpr_desc;



  v_movi_emit_reci := bcab.movi_emit_reci;
  v_movi_afec_sald := bcab.movi_afec_sald;

   
 v_movi_dbcr      := replace(bcab.movi_dbcr,'');
 

  v_movi_stoc_afec_cost_prom := null;
  v_movi_empr_codi           := parameter.p_empr_codi;
  v_movi_clave_orig          := null;
  v_movi_clave_orig_padr     := null;
  v_movi_indi_iva_incl       := null;
  v_movi_empl_codi           := null;

  v_movi_nume_timb      := null;
  v_movi_fech_venc_timb := null;
  v_movi_impo_reca      := 0;
  
  

  pp_insert_come_movi(v_movi_codi,
                      v_movi_timo_codi,
                      v_movi_clpr_codi,
                      v_movi_sucu_codi_orig,
                      v_movi_depo_codi_orig,
                      v_movi_sucu_codi_dest,
                      v_movi_depo_codi_dest,
                      v_movi_oper_codi,
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
                      v_movi_stoc_suma_rest,
                      v_movi_clpr_dire,
                      v_movi_clpr_tele,
                      v_movi_clpr_ruc,
                      v_movi_clpr_desc,
                      v_movi_emit_reci,
                      v_movi_afec_sald,
                      v_movi_dbcr,
                      v_movi_stoc_afec_cost_prom,
                      v_movi_empr_codi,
                      v_movi_clave_orig,
                      v_movi_clave_orig_padr,
                      v_movi_indi_iva_incl,
                      v_movi_empl_codi,
                      v_movi_nume_timb,
                      v_movi_fech_venc_timb,
                      v_movi_fech_oper,
                      v_movi_impo_reca,
                      v_movi_excl_cont);

end pp_actualiza_come_movi;




procedure pp_valida_nume_cheq1 (p_cheq_nume in varchar2, p_cheq_serie in varchar2, p_cheq_banc_codi in number) is
v_banc_desc varchar2(60);
begin  
	
  select  banc_desc
  into    v_banc_desc
  from come_cheq, come_banc
  where cheq_banc_codi = banc_codi
  and rtrim(ltrim(cheq_nume)) = rtrim(ltrim(p_cheq_nume))
  and rtrim(ltrim(cheq_serie)) = rtrim(ltrim(p_cheq_serie))
  and cheq_banc_codi = p_cheq_banc_codi;
  
  if parameter.p_indi_vali_repe_cheq = 'S' then
     apex_application.g_print_success_message :='Atenci?n!!! Cheque existente... Numero'||p_cheq_nume||' Serie'||p_cheq_serie||' Banco '||v_banc_desc;
  else
    raise_application_error(-20001,'Atenci?n!!! Cheque existente... Numero'||p_cheq_nume||' Serie'||p_cheq_serie||' Banco '||v_banc_desc);
  end if;  	
  
Exception         
	  When no_data_found then
	    null;     
	  When too_many_rows then
	    if parameter.p_indi_vali_repe_cheq = 'S' then
        apex_application.g_print_success_message :='Atenci?n!!! Cheque existente... Numero'||p_cheq_nume||' Serie'||p_cheq_serie||' Banco '||v_banc_desc;
      else
        raise_application_error(-20001,'Atenci?n!!! Cheque existente... Numero'||p_cheq_nume||' Serie'||p_cheq_serie||' Banco '||v_banc_desc);
      end if;  	
  
end pp_valida_nume_cheq1;

procedure pp_valida_cheques is
begin        
  if parameter.p_indi_vali_repe_cheq = 'S' then
    if bcab.p_emit_reci  = 'E' then      
       for bfp in g_cur_bfp loop
         if bfp.pago_tipo in ('4') then
           pp_valida_nume_cheq1(bfp.cheq_nume, bfp.cheq_serie, bfp.cheq_banc_codi);   
         end if;
       end loop;  
    end if;    
    
    if  bcab.p_emit_reci  = 'R' then  
     for bfp in g_cur_bfp loop
         if bfp.pago_tipo in ('2') then
           pp_valida_nume_cheq1(bfp.cheq_nume, bfp.cheq_serie, bfp.cheq_banc_codi);   
         end if;
       
       end loop;  
    end if;
  end if;
end pp_valida_cheques;



/*
PROCEDURE pp_valida_campo_marcado IS
  v_count number := 0;
BEGIN
  go_block('bdet');
  first_record;
  loop
    if lower(:bdet.s_marca) = 'x' then
      v_count := v_count + 1;
      exit;
    elsif :system.last_record = 'TRUE' then
      exit;
    else
      next_record;
    end if;
  end loop;
  if nvl(v_count,0) = 0 then
    pl_me('No existe comprobante marcado para su cancelacion. Favor, seleccione el(los) documento(s) a cancelar.');
  end if;
    
END;*\

\*PROCEDURE pp_valida_forma_pago IS
  v_count number := 0;
BEGIN
  go_block('bfp');
  first_record;
  loop
    if :bfp.pago_tipo is not null then
      v_count := v_count + 1;
      exit;
    elsif :system.last_record = 'TRUE' then
      exit;
    else
      next_record;
    end if;
  end loop;
  if nvl(v_count,0) = 0 then
    pl_me('No existe Forma de pago para su cancelacion.');
  end if;
  
END;
*/


procedure pp_valida_importes is
begin  
  --Validacion de importes para recibos emitidos, (Cobranzas a clientes)
 if parameter.p_emit_reci = 'E'  then
   if (nvl(bcab.s_impo_efec,0) +
        nvl(bcab.s_impo_cheq,0) + 
        nvl(bcab.s_impo_tarj,0)) <> (nvl(bcab.movi_exen_mone,0)) then
         raise_application_error(-20001, 'El importe del documento menos la retencion debe ser igual al importe cobrado.');
   end if;
 end if; 
  --Validacion de importes para recibos Recidos, (Pago a Proveedores)
 if parameter.p_emit_reci = 'R'  then
  if (nvl(bcab.s_impo_efec,0) +
        nvl(bcab.s_impo_cheq,0) + 
        nvl(bcab.s_impo_tarj,0)) <> (nvl(bcab.movi_exen_mone,0)) then
         raise_application_error(-20001,'El importe del documento menos la retencion debe ser igual al importe a pagar.');
  end if;
 end if;
end pp_valida_importes;

procedure pp_set_variables is
  
begin
  
  BCAB.P_EMIT_RECI              := V('P110_P_EMIT_RECI');
  BCAB.P_CANT_DECI_MMNN         := V('P110_P_CANT_DECI_MMNN');
  BCAB.BUSCAR                   := V('P110_BUSCAR');
  BCAB.P_CLIE_PROV              := V('P110_P_CLIE_PROV');
    
  BCAB.MOVI_SUCU_CODI_ORIG      := V('P110_MOVI_SUCU_CODI_ORIG');
  BCAB.INDI_CARG_DETA           := V('P110_INDI_CARG_DETA');
  BCAB.MOVI_SUCU_DESC_ORIG      := V('P110_MOVI_SUCU_DESC_ORIG');
  BCAB.MOVI_MONE_CANT_DECI      := V('P110_MOVI_MONE_CANT_DECI');
 
  BCAB.MOVI_CLPR_CODI           := V('P110_MOVI_CLPR_CODI');
   
  BCAB.S_CLPR_CODI_ALTE         := V('P110_S_CLPR_CODI_ALTE');
  
  BCAB.MOVI_CODI                := V('P110_MOVI_CODI');

  BCAB.MOVI_CLPR_DESC           := V('P110_MOVI_CLPR_DESC');
  BCAB.MOVI_CODI_ADEL           := V('P110_MOVI_CODI_ADEL');
  BCAB.MOVI_FECH_EMIS           := V('P110_MOVI_FECH_EMIS');
  BCAB.MOVI_TIMO_CODI           := V('P110_MOVI_TIMO_CODI');
  BCAB.MOVI_FECH_OPER           := V('P110_MOVI_FECH_OPER');
  BCAB.MOVI_TIMO_DESC           := V('P110_MOVI_TIMO_DESC');
  BCAB.MOVI_NUME                := V('P110_MOVI_NUME');
   
  BCAB.MOVI_TIMO_DESC_ABRE      := V('P110_MOVI_TIMO_DESC_ABRE');
  BCAB.MOVI_TICO_CODI           := V('P110_MOVI_TICO_CODI');
  BCAB.MOVI_MONE_CODI           := V('P110_MOVI_MONE_CODI');
  BCAB.TIMO_INDI_APLI_ADEL_FOPA := V('P110_TIMO_INDI_APLI_ADEL_FOPA');
  BCAB.TICA_CODI                := V('P110_TICA_CODI');
  BCAB.TIMO_TICA_CODI           := V('P110_TIMO_TICA_CODI');
  BCAB.S_DIFE                   := nvl(V('P110_S_DIFE'),0);
 
  BCAB.TIMO_DBCR_CAJA           := V('P110_TIMO_DBCR_CAJA');
  BCAB.MOVI_TARE_CODI           := V('P110_MOVI_TARE_CODI');
      
  BCAB.MOVI_MONE_DESC_ABRE      := V('P110_MOVI_MONE_DESC_ABRE');
--  raise_application_error(-20001,'El importe'|| V('P110_MOVI_MONE_DESC_ABRE'));
  BCAB.CLPR_PROV_RETENER        := V('P110_CLPR_PROV_RETENER');
  BCAB.TICA_DESC                := V('P110_TICA_DESC');

  BCAB.MOVI_CLPR_RUC            := V('P110_MOVI_CLPR_RUC');
  BCAB.MOVI_CLPR_TELE           := V('P110_MOVI_CLPR_TELE');
  BCAB.MOVI_CLPR_DIRE           := V('P110_MOVI_CLPR_DIRE');
  BCAB.MOVI_MONE_DESC           := V('P110_MOVI_MONE_DESC');
  BCAB.MOVI_TASA_MONE           := nvl(V('P110_MOVI_TASA_MONE'),0);
  BCAB.MOVI_CUEN_NUME           := V('P110_MOVI_CUEN_NUME');
  BCAB.MOVI_TASA_MMEE           := nvl(V('P110_MOVI_TASA_MMEE'),0);
  BCAB.MOVI_FECH_GRAB           := V('P110_MOVI_FECH_GRAB');
  BCAB.S_IMPO_EFEC              := V('P110_S_IMPO_EFEC');
  BCAB.MOVI_GRAV_MMNN           := nvl(V('P110_MOVI_GRAV_MMNN'),0);
  BCAB.MOVI_IVA_MMNN            := nvl(V('P110_MOVI_IVA_MMNN'),0);
  BCAB.MOVI_EXEN_MONE           := nvl(V('P110_MOVI_EXEN_MONE'),0);
  BCAB.MOVI_GRAV_MMEE           := nvl(V('P110_MOVI_GRAV_MMEE'),0);
  BCAB.MOVI_EXEN_MMNN           := nvl(V('P110_MOVI_EXEN_MMNN'),0);
  BCAB.MOVI_EXEN_MMEE           := nvl(V('P110_MOVI_EXEN_MMEE'),0);
  BCAB.S_IMPO_CHEQ              := nvl(V('P110_S_IMPO_CHEQ'),0);
  BCAB.MOVI_IVA_MMEE            := nvl(V('P110_MOVI_IVA_MMEE'),0);
  BCAB.MOVI_GRAV_MONE           := nvl(V('P110_MOVI_GRAV_MONE'),0);
  BCAB.MOVI_OBSE                := V('P110_MOVI_OBSE');
  BCAB.MOVI_IVA_MONE            := nvl(V('P110_MOVI_IVA_MONE'),0);
  BCAB.MOVI_SALD_MONE           := nvl(V('P110_MOVI_SALD_MONE'),0);
  BCAB.MOVI_SALD_MMEE           := nvl(V('P110_MOVI_SALD_MMEE'),0);
  BCAB.MOVI_SALD_MMNN           := nvl(V('P110_MOVI_SALD_MMNN'),0);
  BCAB.MOVI_AFEC_SALD           := V('P110_MOVI_AFEC_SALD');
  BCAB.MOVI_DBCR                := V('P110_MOVI_DBCR');
  BCAB.MOVI_USER                := V('P110_MOVI_USER');
  BCAB.MOVI_EMIT_RECI           := V('P110_MOVI_EMIT_RECI');
  BCAB.CLPR_INDI_CLIE_PROV      := V('P110_CLPR_INDI_CLIE_PROV');
  BCAB.S_IMPO_TARJ              := V('P110_S_IMPO_TARJ');
  BCAB.S_IMPO_ADEL              := V('P110_S_IMPO_ADEL');
  BCAB.MOVI_EMPR_CODI           := parameter.p_empr_codi;
  
  
end pp_set_variables;

procedure pp_actualiza_registro is
  salir exception;
  
v_clie_dife     number;
v_mone_dife     number;
v_cant_elegida  number;
v_total         number;
v_impo_pago     number;
begin

  
   pp_set_variables;


    parameter.p_emit_reci  := 'E';
    parameter.p_clie_prov  := 'C';
    parameter.p_codi_conc  := parameter.p_codi_conc_pgncre;
    parameter.p_codi_timo  := parameter.p_codi_timo_pgncre;
  



   if nvl(parameter.p_clie_prov, 'C') = 'C' then
     parameter.p_para_inic_adel :='AC';
   else
     parameter.p_para_inic_adel :='AP';
   end if;	
 

  

 
   pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
  



  if bcab.movi_fech_emis is null then
    raise_application_error(-20001,'Debe ingresar la fecha del recibo!.');
  end if;

  if bcab.movi_sucu_codi_orig is null then
    raise_application_error(-20001, 'La sucursal no puede quedar vacia');
  end if;
  if bcab.movi_fech_emis is null then
    raise_application_error(-20001, 'La fecha no puede quedar vacia');
  end if;
  if bcab.movi_fech_oper is null then
    raise_application_error(-20001, 'El fecha oper. no puede quedar vacio');
  end if;
  if bcab.movi_nume is null then
    raise_application_error(-20001,  'El nro. recibo no puede quedar vacio');
  end if;
  if bcab.movi_mone_codi is null then
    raise_application_error(-20001, 'La moneda no puede quedar vacia');
  end if;
  if bcab.tica_codi is null then
    raise_application_error(-20001,  'El tipo cambio no puede quedar vacio');
  end if;

  if bcab.movi_tasa_mone is null then
    raise_application_error(-20001, 'La tasa no puede quedar vacia');
  end if;
  if bcab.movi_tasa_mmee is null then
    raise_application_error(-20001, 'El tasa mmee no puede quedar vacia');
  end if;
  
  if bcab.movi_exen_mmnn is null then
    raise_application_error(-20001,' El importe mmee no puede quedar vacio');
  end if;

   if bcab.movi_exen_mmnn <= 0then 
    raise_application_error(-20001,' El importe debe ser mayor a 0');
 end if;
 
  -- go_block('bdet');
  if bcab.s_dife < 0 then
   raise_application_error(-20001,'Existe diferencia entre el importe del recibo y el detalle de cuotas canceladas');
  end if;
   
 select nvl(sum(case
                    when bcab.movi_clpr_codi <> c009 then
                   1
                    else
                     0
                  end),
            0) clie_dife,
        nvl(count(c012), 0) cant_elegida,
        nvl(sum(case
                    when bcab.movi_mone_codi <> c002 then
                      1
                    else
                     0
                  end),
            0) mone_dife,
            nvl(sum(c013),0)
   into v_clie_dife, v_cant_elegida, v_mone_dife, v_impo_pago
   from apex_collections
  where collection_name = 'DETALLE'
    and c012 = 'S';
-- raise_application_error(-20001,  bcab.movi_clpr_codi||'--'||v_impo_pago);
  select nvl(sum(c014), 0) pago_impo_movi
   into v_total
   from apex_collections
  where collection_name = 'DETA_PAGO';

 v_total := BCAB.S_IMPO_EFEC +BCAB.S_IMPO_CHEQ    ;          

  bcab.sum_impo_pago := v_total;
 
  if v_clie_dife >0 then
    raise_application_error(-20001,'Atencion ! El codigo de cliente ha cambiado, debe cancelar la operacion !!');
  end if;
  
  
  if v_mone_dife > 0 then
    raise_application_error(-20001,'La moneda de las cuotas a cancelar no coincide con la moneda seleccionada en la cabecera');
  end if;
 
  if v_impo_pago <= 0 then
    raise_application_error(-20001,'El pago debe asignarse por lo menos a un documento!');
  end if;
  
 if v_total <= 0 then
   raise_application_error(-20001,'Tiene que cargar el importe del pago.');
  end if;
  
  ---verifica saldo distinto de cero.
  if (bcab.movi_exen_mone - v_total) <> 0 then
   raise_application_error(-20001,'Existe una diferencia en montos. Saldo distinto a 0(cero).');
  end if;
  ---
  
  
--------------pp_valida_campo_marcado
  if v_cant_elegida <= 0 then
    raise_application_error(-20001,'No existe comprobante marcado para su cancelacion. Favor, seleccione el(los) documento(s) a cancelar.!');
  end if;
  ----pp_valida_forma_pago
  if v_total <= 0 then
     raise_application_error(-20001,'No existe Forma de pago para su cancelacion.');
  end if;
 
 bcab.sum_impo_pago := v_total-bcab.s_dife;

  pp_valida_importes;
  pp_valida_cheques;
      
 
  pp_actualiza_come_movi;
   
  pp_insertar_cance;

  pp_actualizar_moco;
  --pp_actualizar_moimpu;
 ----pp_actualizar_moimpo;-------------se cambia por forma de pago
 
 
 
  pack_fpago.pl_fp_actualiza_moimpo(i_movi_clpr_codi      => bcab.movi_clpr_codi,
                                            i_movi_clpr_desc      => bcab.movi_clpr_desc,
                                            i_movi_clpr_ruc       => bcab.movi_clpr_ruc,
                                            i_movi_codi           => bcab.movi_codi,
                                            i_movi_dbcr           => bcab.movi_dbcr,
                                            i_movi_emit_reci      => bcab.movi_emit_reci,
                                            i_movi_empr_codi      => bcab.movi_empr_codi,
                                            i_movi_fech_emis      => bcab.movi_fech_emis,
                                            i_movi_fech_oper      => bcab.movi_fech_oper,
                                            i_movi_mone_cant_deci => bcab.movi_mone_cant_deci,
                                            i_movi_sucu_codi_orig => bcab.movi_sucu_codi_orig,
                                            i_movi_tasa_mone      => bcab.movi_tasa_mone,
                                            i_movi_timo_codi      => bcab.movi_timo_codi,
                                            i_s_impo_rete         => null,--bcab.s_impo_rete,
                                            i_s_impo_rete_rent    => null --bcab.s_impo_rete_rent
                                            );
     
 pp_actu_secu;
 
 
 if BCAB.S_DIFE > 0 then
   
 pp_actualiza_come_movi_adel;
 null;
 end if;

--raise_application_error(-20001,'Debe ingresar la dddddd del recibo!.');
     APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETALLE');
    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETA_PAGO');


  apex_application.g_print_success_message :='Registro actualizado.';
   
  
  /*  if nvl(parameter.p_indi_impr_cheq_emit, 'N') = 'S' then
      pp_impr_cheq_emit;
    end if;
*/
end pp_actualiza_registro;



procedure pp_buscar_sucu (p_movi_sucu_codi_orig in number, 
                          p_movi_sucu_desc_orig out varchar2) is 
  begin
    select s.sucu_desc
      into p_movi_sucu_desc_orig
      from come_sucu s
     where s.sucu_codi = p_movi_sucu_codi_orig
       and s.sucu_empr_codi = parameter.p_empr_codi;
       
  exception
    when no_data_found then
      raise_application_error(-20001,'Sucursal inexistente o no pertenece a la empresa ');

end pp_buscar_sucu;


Procedure pp_muestra_clpr(p_ind_clpr          in varchar2,
                          p_clpr_codi         in number,
                          p_clpr_desc         out varchar2,
                          p_clpr_codi_alte    out varchar2,
                          p_clpr_tele         out varchar2,
                          p_clpr_dire         out varchar2,
                          p_clpr_ruc          out varchar2,
                          p_clpr_prov_retener out varchar2) is
begin
  select clpr_desc,
         clpr_codi_alte,
         rtrim(ltrim(substr(clpr_tele, 1, 50))) Tele,
         rtrim(ltrim(substr(clpr_dire, 1, 100))) dire,
         rtrim(ltrim(substr(clpr_ruc, 1, 20))) Ruc,
         nvl(clpr_prov_retener, 'NO')
    into p_clpr_desc,
         p_clpr_codi_alte,
         p_clpr_tele,
         p_clpr_dire,
         p_clpr_ruc,
         p_clpr_prov_retener
    from come_clie_prov
   where clpr_codi= p_clpr_codi
     and clpr_indi_clie_prov = p_ind_clpr;

Exception
  when no_data_found then
    if p_ind_clpr = 'R' then
      raise_application_error(-20001, 'Proveedor inexistente!');
    else
      raise_application_error(-20001, 'Cliente inexistente!');
    end if;
  
end pp_muestra_clpr;


procedure pp_muestra_tipo_movi(p_movi_timo_codi             in number,
                               p_tica_codi                  out varchar2,
                               p_movi_tico_codi             out varchar2,
                               p_timo_indi_apli_adel_fopa   out varchar2,
                               p_timo_tica_codi             out varchar2, 
                               p_timo_dbcr_caja             out varchar2) is
                        
begin       

  

select timo_tica_codi,
       timo_tico_codi,
       timo_indi_apli_adel_fopa,
       timo_tica_codi,
       timo_dbcr_caja
  into p_tica_codi,
       p_movi_tico_codi,
       p_timo_indi_apli_adel_fopa,
       p_timo_tica_codi,
       p_timo_dbcr_caja
  from come_tipo_movi
 where timo_codi = p_movi_timo_codi;

if p_tica_codi is null then
   raise_application_error(-20001,'Debe relacionar el tipo de cambio al tipo de movimiento '||p_movi_timo_codi);
end if; 
/*             
if :bcab.movi_tico_codi is null then
  pl_me('Debe relacionar el tipo de Comprobante al tipo de movimiento '||:bcab.movi_timo_codi);
end if; 
  */       


Exception
   when no_data_found then           
      raise_application_error(-20001,'Tipo de Movimiento inexistente');
   When too_many_rows then    
     raise_application_error(-20001,'Tipo de Movimiento duplicado') ;

     
End pp_muestra_tipo_movi;


Procedure pp_muestra_desc_mone(p_codi_mone      in number,
                               p_desc_mone_abre out varchar2,
                               p_deci_mmee      out number) is
begin
  select mone_desc_abre, mone_cant_deci
    into p_desc_mone_abre, p_deci_mmee
    from come_mone
   where mone_codi = p_codi_mone;

Exception
  when no_data_found then
    raise_application_error(-20001,
                            'Descripci?n de la moneda inexistente!');
  
end pp_muestra_desc_mone;

procedure pp_valida_fech(p_fech in date) is
begin
  if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
     raise_application_error(-20001,'La fecha del movimiento debe estar comprendida entre..' ||
                                    to_char(parameter.p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                                    to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
  end if;

end pp_valida_fech;


procedure pp_carga_secu (p_secu_nume_cobr out number,
                         p_movi_timo_codi in number)is
begin               
	--raise_application_error(-20001,p_movi_timo_codi);
 select nvl(max(movi_nume),0) + 1
   into p_secu_nume_cobr
   from come_movi
  where movi_timo_codi =p_movi_timo_codi;
  
Exception
	  When no_data_found then
	   raise_application_error(-20001,'Codigo de Secuencia de Cobranzas inexistente');  

end pp_carga_secu;   


 
procedure pp_buscar_moneda (p_movi_mone_codi   in number,
                            p_movi_fech_emis   in date,
                            p_tica_codi        in number,
                            p_movi_mone_desc      out varchar2,
                            p_movi_mone_desc_abre out varchar2,
                            p_movi_mone_cant_deci out varchar2,
                            p_movi_tasa_mone      out varchar2,
                            p_movi_tasa_mmee      out varchar2,
                            p_indi_carg_deta      out varchar) is   
  
begin 



   general_skn.pl_muestra_come_mone (p_movi_mone_codi,p_movi_mone_desc, p_movi_mone_desc_abre, p_movi_mone_cant_deci);
  --- pp_formatear_importes;      
   I020234.pp_busca_tasa_mone(p_movi_mone_codi, p_movi_tasa_mone, p_tica_codi,p_movi_fech_emis);
   I020234.pp_busca_tasa_mmee (parameter.p_codi_mone_mmee, p_movi_tasa_mmee, p_tica_codi,p_movi_fech_emis);
   p_indi_carg_deta := 'N'; 


end pp_buscar_moneda;


 procedure pp_busca_tasa_mone (p_mone_codi in number, 
                              p_mone_coti out number, 
                              p_tica_codi in number,
                              p_movi_fech_emis in date)is
begin
                       
  if parameter.p_codi_mone_mmnn = p_mone_codi then
     p_mone_coti := 1;
  else
    select coti_tasa
    into p_mone_coti
    from come_coti
    where coti_mone = p_mone_codi
    and coti_tica_codi = p_tica_codi
    and coti_fech   = p_movi_fech_emis;
  end if;        

  Exception
      When no_data_found then
        raise_application_error(-20001,'Cotizacion Inexistente para la fecha del documento');
     
end pp_busca_tasa_mone;


procedure pp_busca_tasa_mmee (p_mone_codi in number, 
                              p_mone_coti out number, 
                              p_tica_codi in number,
                              p_movi_fech_emis in date)is
begin
                       
  if parameter.p_codi_mone_mmnn = p_mone_codi then
     p_mone_coti := 1;
  else
    select coti_tasa
    into p_mone_coti
    from come_coti
    where coti_mone    = p_mone_codi
    and coti_tica_codi = p_tica_codi
    and coti_fech      = p_movi_fech_emis;
  end if;   
      
  Exception
      When no_data_found then
       
         raise_application_error(-20001,'Cotizacion Inexistente para la moneda extranjera  ' ||parameter.p_desc_mone_mmee);

  
end pp_busca_tasa_mmee;

procedure pp_muestra_tipo_camb (p_tica_codi in number, 
                                p_tica_desc out varchar2)is
begin
  
  select tica_desc
  into p_tica_desc
  from come_tipo_camb
  where tica_codi = p_tica_codi;
  
  
Exception	
	 When no_data_found then
	      raise_application_error(-20001,'Tipo de cambio no encontrado!!') ;
  
end pp_muestra_tipo_camb;





procedure pp_cargar_bloque_det (p_movi_clpr_codi             in varchar2,
                                p_movi_mone_codi             in varchar2,
                                p_movi_fech_emis             in varchar2,
                                p_movi_nume                  in varchar2,
                                p_movi_tasa_mone             in varchar2) is
  cursor c_vto is
    select movi_mone_codi,
           movi_nume,
           movi_fech_emis,
           cuot_fech_venc,
           cuot_impo_mone,
           cuot_sald_mone,
           movi_codi,
           cuot_movi_codi,
           movi_tasa_mone,
           cuot_tasa_dife_camb,
           clpr_codi,
           clpr_codi_alte,
           decode(nvl(t.timo_calc_iva, 'N'),
                  'S',
                  movi_grav_mone,
                  round(((movi_exen_mone - nvl(movi_impo_reca, 0)) / 1.1),
                        mone_cant_deci)) movi_grav_mone,
           decode(nvl(t.timo_calc_iva, 'N'),
                  'S',
                  movi_grav_mmnn,
                  round((movi_exen_mmnn - (round(nvl(movi_impo_reca, 0) *
                                                 nvl(movi_tasa_mone, 1),
                                                 0))) / 1.1,
                        mone_cant_deci)) movi_grav_mmnn,
           decode(nvl(t.timo_calc_iva, 'N'),
                  'S',
                  movi_iva_mone,
                  round((movi_exen_mone - nvl(movi_impo_reca, 0)) / 11,
                        mone_cant_deci)) movi_iva_mone,
           round((decode(nvl(t.timo_calc_iva, 'N'),
                         'S',
                         movi_grav_mmnn,
                         round((movi_exen_mmnn - (nvl(movi_impo_reca, 0))) / 1.1,
                               0)) * 10 / 100),
                 mone_cant_deci) movi_iva_mmnn,
           movi_codi_rete
      from come_movi,
           come_movi_cuot,
           come_tipo_movi t,
           come_clie_prov,
           come_mone
     where movi_codi = cuot_movi_codi
       and movi_mone_codi = mone_codi
       and movi_timo_codi = timo_codi
       and movi_clpr_codi = clpr_codi
       and movi_clpr_codi = p_movi_clpr_codi
       and cuot_sald_mone > 0
       and movi_mone_codi = p_movi_mone_codi
       and movi_dbcr = decode(parameter.p_emit_reci, 'E', 'C', 'R', 'D')
       and ((movi_dbcr = 'C' and movi_timo_codi in (9, 10)) or  (movi_dbcr = 'D' and movi_timo_codi in (11, 12)))
     order by cuot_fech_venc, movi_fech_emis, movi_nume;

  v_count  number := 0;
  v_count2 number := 0;
  v_existe number := 0;


  cursor c_dica(p_movi_codi in number, p_fech_venc in date) is
    select dica_tasa
      from come_movi_dife_camb
     where DICA_MOVI_CODI = p_movi_codi
       and DICA_FECH_VENC = p_fech_venc
       and DICA_FECH_HASTA <= p_movi_fech_emis
     order by DICA_FECH_HASTA desc;
 v_cuot_tasa_mone number;
begin
  

      parameter.p_emit_reci  := 'E';
      parameter.p_clie_prov  := 'C';
      parameter.p_codi_conc  := parameter.p_codi_conc_pgncre;
      parameter.p_codi_timo  := parameter.p_codi_timo_pgncre;
    
     
     

    if p_movi_clpr_codi is null then
       raise_application_error(-20001,'Debe ingresar El codigo del cliente');
    end if;

    if p_movi_fech_emis is null then
       raise_application_error(-20001,'Debe ingresar la fecha del documento');
    end if;

    if p_movi_nume is null then
      raise_application_error(-20001,'Debe ingresar el n?mero del documento');
    end if;

    if p_movi_tasa_mone is null then
       raise_application_error(-20001,'Debe ingresar la cotizacion del documento');
    end if;

    parameter.p_indi_carg_deta := 'N';




    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETALLE');
    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETA_PAGO');
    

  if nvl(parameter.p_indi_carg_deta, 'N') = 'N' then
    for x in c_vto loop
     
     for i in c_dica(x.cuot_movi_codi, x.cuot_fech_venc) loop
       v_cuot_tasa_mone := i.dica_tasa;
        exit;
      end loop;
      if v_cuot_tasa_mone is null then
       v_cuot_tasa_mone := x.movi_tasa_mone;
      end if;
           apex_collection.add_member(p_collection_name => 'DETALLE',   
                                      p_c001            => x.movi_nume,
                                      p_c002            => x.movi_mone_codi,
                                      p_c003            => x.movi_fech_emis,
                                      p_c004            => x.cuot_fech_venc,
                                      p_c005            => x.cuot_impo_mone,
                                      p_c006            => x.cuot_sald_mone,
                                      p_c007            => x.movi_codi,
                                      p_c008            => v_cuot_tasa_mone,
                                      p_c009            => x.clpr_codi,
                                      p_c010            => x.clpr_codi_alte,
                                      p_c011            => x.movi_iva_mone);
                                            


    end loop;
    
    
 select count(seq_id)
   into v_existe
   from apex_collections
  where collection_name = 'DETALLE';

    if v_existe = 0 then
      if parameter.p_clie_prov = 'C' then
         raise_application_error(-20001,'El Cliente no posee comprobantes pendientes!');
      else  
         raise_application_error(-20001,'El Proveedor no posee comprobantes pendientes!');
      end if;
    end if;
  end if;
end pp_cargar_bloque_det;



procedure pp_editar_indi (p_seq_id  in number,
                          p_valor   in varchar2,
                             p_S_DIFE  out varchar2)is
 v_saldo number;
 v_impo_pago number;
 v_movi_fech_emis date;
 
v_saldo_tot number;
v_saldo_dif number;

 begin
   
 --raise_application_error(-20001,'adfa');
   
 APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME    => 'DETALLE',
                                            P_SEQ             => p_seq_id,
                                            P_ATTR_NUMBER     => 12,
                                            P_ATTR_VALUE      => p_valor);
  
 if p_valor  = 'N' then
   v_saldo := null;
 else                                         
     select c006, to_Date(c004)
      into v_saldo, v_movi_fech_emis
      from apex_collections
     where collection_name = 'DETALLE'
       and seq_id = p_seq_id;   
    
  
 
        if nvl(V('P110_MOVI_EXEN_MONE'),0) <> 0 then
          if V('P110_S_DIFE') < 0 then
        	  raise_application_error(-20001,'El importe de la distribucion de pagos es mayor al importe del recibo');
          end if;	 
        
          if v_saldo <= V('P110_S_DIFE') then
              v_impo_pago := v_saldo;
            else
        	    v_impo_pago := V('P110_S_DIFE');
            end if;	  
        end if;  
             
        if v_movi_fech_emis > V('P110_movi_fech_emis') then
          raise_application_error(-20001,'La fecha de pago debe ser mayor o igual a la factura a pagar');
        end if;
   
 end if; 

                                   
                                            
APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 13,
                                          P_ATTR_VALUE      => v_impo_pago);



APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 14,
                                          P_ATTR_VALUE      => V_SALDO -v_impo_pago);
                                          
  

     select nvl(sum(c013),0)
      into v_saldo_tot
      from apex_collections
     where collection_name = 'DETALLE';                                
    
  v_saldo_dif := nvl(v('P110_MOVI_EXEN_MONE'),0)-v_saldo_tot;
                                       
                                          
   p_S_DIFE := v_saldo_dif;                                       
 end pp_editar_indi;


procedure pp_editar_importe (p_seq_id  in varchar2,
                             p_valor   in varchar2,
                             p_S_DIFE  out varchar2)is
 v_indica varchar2(20);
 v_saldo number;
 v_seq_id varchar2(20);
 v_Saldo_cuo number;
 
 v_saldo_tot number;
v_saldo_dif number;
 begin
  v_seq_id := replace(p_seq_id,'f02_');

                                
     select c012, to_number(c006)
      into v_indica, v_Saldo_cuo
      from apex_collections
     where collection_name = 'DETALLE'
       and seq_id = v_seq_id;   
   --raise_application_error(-20001,p_valor||'--'||v_seq_id||'--'||v_indica );                                  
   if v_indica  = 'S' then
     v_saldo := p_valor;
   else
     v_saldo := null;
   end if;                                   
APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                          P_SEQ             => v_seq_id,
                                          P_ATTR_NUMBER     => 13,
                                          P_ATTR_VALUE      => v_saldo);


 APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                          P_SEQ             => v_seq_id,
                                          P_ATTR_NUMBER     => 14,
                                          P_ATTR_VALUE      => v_Saldo_cuo-v_saldo);
                                          
                                          
 
     select nvl(sum(c013),0)
      into v_saldo_tot
      from apex_collections
     where collection_name = 'DETALLE';                                    
    
  v_saldo_dif := nvl(v('P110_MOVI_EXEN_MONE'),0)-v_saldo_tot;
                                       
                                          
   p_s_dife:= v_saldo_dif;                                           

  
 end pp_editar_importe;
 
 procedure pp_cargar_pago  ( p_pago_tipo              varchar2,                        
                             p_mone_codi              varchar2,
                             p_cuen_indi_caja_banc    varchar2,
                             p_pago_cuen_codi         varchar2,
                             p_pago_impo_mone         varchar2,
                             p_pago_coti              varchar2,
                             p_cheq_serie             varchar2,
                             p_cheq_indi_terc  varchar2,
                             p_cheq_nume       varchar2,
                             p_cheq_impo_mone  varchar2,
                             p_cheq_cuen_codi  varchar2,
                             p_cheq_mone_codi  varchar2,
                             p_cheq_banc_codi  varchar2,
                             p_cheq_nume_cuen  varchar2,
                             p_cheq_titu       varchar2,
                             p_cheq_fech_emis  varchar2,
                             p_cheq_fech_venc  varchar2,
                             p_indi_cheq       varchar2)is 
   
v_pago_desc            varchar2(200);
v_pago_cobr_indi       varchar2(200);
v_mone_desc            varchar2(200);
v_mone_cant_deci       varchar2(200);
v_mone_desc_abre       varchar2(200);
v_cuen_indi_caja_banc  varchar2(200);
v_pago_cuen_desc       varchar2(200);
v_pago_impo_mmnn       varchar2(200);
v_pago_impo_movi       varchar2(200);
V_IND_CHEQUE           varchar2(200);
v_pago_coti            varchar2(200);

v_impo_mmnn	number;
v_impo_movi	number;
v_pago_impo_movi1 varchar(1000);
v_pago_impo_mone1 varchar(1000);
v_pago_impo_mmnn1 varchar(1000);
v_cheq_cuen_codi varchar(1000);
v_cheque_nume number;
begin
    -- APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETA_PAGO');

if p_pago_tipo is null then
    raise_application_error(-20001,
                            'El tipo de pago no puede quedar vacio');
  end if;
  if p_mone_codi is null then
    raise_application_error(-20001, 'La moneda no puede quedar vacia');
  end if;
  if p_pago_cuen_codi is null then
    raise_application_error(-20001, 'El la cuenta no puede quedar vacia');
  end if;
  if p_pago_impo_mone is null then
    raise_application_error(-20001, 'El importe no puede quedar vacio');
  end if;
  if p_pago_coti is null then
    raise_application_error(-20001, 'La cotizacion no puede quedar vacia');
  end if;
  
 IF p_indi_cheq = 'S' THEN
  if p_cheq_serie is null then
    raise_application_error(-20001, 'La serie no puede quedar vacia');
  end if;
  
  if length(p_cheq_serie) >3 then
     raise_application_error(-20001,'La serie solo puede contener 3 caracteres');
  end if;
  if p_cheq_nume is null then
    raise_application_error(-20001,
                            'El numero de cheque no puede quedar vacio');
  end if;
  begin
   v_cheque_nume := to_number(p_cheq_nume);
  exception when others  then
     raise_application_error(-20001, 'El nro de cheque debe ser numerico');
   end;
  if p_cheq_impo_mone is null then
    raise_application_error(-20001, 'El importe no puede quedar vacio');
  end if;
  if p_cheq_cuen_codi is null then
    raise_application_error(-20001, 'La cuenta no puede quedar vacia');
  end if;
  if p_cheq_mone_codi is null then
    raise_application_error(-20001,
                            'La moneda del cheque no puede quedar vacia');
  end if;
  if p_cheq_banc_codi is null then
    raise_application_error(-20001, 'El banco no puede quedar vacio');
  end if;
  if p_cheq_nume_cuen is null then
    raise_application_error(-20001,
                            'El nro de cuenta no puede quedar vacio');
  end if;
  if p_cheq_titu is null then
    raise_application_error(-20001, 'El Titular no puede quedar vacio');
  end if;
  if p_cheq_fech_emis is null then
    raise_application_error(-20001, 'La fecha no puede quedar vacia');
  end if;
  if p_cheq_fech_venc is null then
    raise_application_error(-20001,
                            'La fecha de vto no puede quedar vacio');
  end if;
 END IF;
  i020234.pp_validar_fp(p_pago_tipo           => p_pago_tipo,
                        p_pago_desc           => v_pago_desc,
                        p_cuen_indi_caja_banc => v_cuen_indi_caja_banc,
                        p_ind_cheque          => v_ind_cheque);


  i020234.pp_asig_indi_dbcr(p_pago_tipo      => p_pago_tipo,
                            p_pago_cobr_indi => v_pago_cobr_indi);


  i020234.pp_buscar_moneda2(p_mone_codi      => p_mone_codi,
                            p_timo_tica_codi => null,
                            p_mone_desc      => v_mone_desc,
                            p_mone_desc_abre => v_mone_desc_abre,
                            p_mone_cant_deci => v_mone_cant_deci,
                            p_pago_coti      => v_pago_coti);


  I020234.pp_buscar_cuenta(p_pago_tipo      => p_pago_tipo,
                           p_pago_cuen_codi => p_pago_cuen_codi,
                           p_pago_cuen_desc => v_pago_cuen_desc,
                           p_mone_codi      => p_mone_codi,
                           p_cheq_cuen_codi => v_cheq_cuen_codi);

  if p_mone_codi = 1 then
    v_pago_impo_mmnn := p_pago_impo_mone;
  else
    v_pago_impo_mmnn := round((p_pago_impo_mone*p_pago_coti),0);
  end if;
   
   v_pago_impo_mmnn:=  round(v_pago_impo_mmnn,parameter.p_cant_deci_mmnn);



    if p_mone_codi <> V('P110_MOVI_MONE_CODI') then
        if  V('P110_MOVI_MONE_CODI') = 1 then
          v_impo_movi := p_pago_impo_mone* P_pago_coti;
        else
          if p_mone_codi = 1 then
            v_impo_movi := p_pago_impo_mone/V('P110_MOVI_TASA_MONE');
          else
            v_impo_mmnn := p_pago_impo_mone* p_pago_coti;
            v_impo_movi := v_impo_mmnn / V('P110_MOVI_TASA_MONE');
          end if;
        end if;
      else
        v_impo_movi := p_pago_impo_mone;
      end if;
      
      v_pago_impo_movi := round(v_impo_movi, V('P110_MOVI_MONE_CANT_DECI'));

    v_pago_impo_mone1 := I020234.pp_decimales(p_pago_impo_mone,v_mone_cant_deci);
    v_pago_impo_mmnn1 := I020234.pp_decimales(v_pago_impo_mmnn,parameter.p_cant_deci_mmnn)  ;         
    v_pago_impo_movi1 := I020234.pp_decimales(v_pago_impo_movi,parameter.p_cant_deci_mmnn);
  
  --raise_application_error(-20001,v_impo_movi||'*'||v_pago_impo_movi );
 
  I020234.pp_valida_nume_cheq(p_cheq_nume      => p_cheq_nume,
                              p_cheq_serie     => p_cheq_serie,
                              p_cheq_banc_codi => p_cheq_banc_codi);


 apex_collection.add_member(p_collection_name => 'DETA_PAGO',  
                            P_C001      => P_PAGO_TIPO,
                            P_C002      => P_PAGO_TIPO,--P_PAGO_TIPO_ANT,
                            P_C003      => V_PAGO_DESC,
                            P_C004      => V_PAGO_COBR_INDI,
                            P_C005      => P_MONE_CODI,
                            P_C006      => V_MONE_DESC,
                            P_C007      => V_MONE_CANT_DECI,
                            P_C008      => V_MONE_DESC_ABRE,
                            P_C009      => V_CUEN_INDI_CAJA_BANC,
                            P_C010      => P_PAGO_CUEN_CODI,
                            P_C011      => V_PAGO_CUEN_DESC,
                            P_C012      => P_PAGO_IMPO_MONE,
                            P_C013      => V_PAGO_IMPO_MMNN,
                            P_C014      => V_PAGO_IMPO_MOVI,
                            P_C015      => P_PAGO_COTI,
                          -------------------------------------
                            P_C016      => P_CHEQ_SERIE,
                            P_C017      => P_CHEQ_INDI_TERC,
                            P_C018      => P_CHEQ_NUME,
                            P_C019      => P_CHEQ_IMPO_MONE,
                            P_C020      => P_CHEQ_CUEN_CODI,
                            P_C021      => P_CHEQ_MONE_CODI,
                            P_C022      => P_CHEQ_BANC_CODI,
                            P_C023      => P_CHEQ_NUME_CUEN,
                            P_C024      => P_CHEQ_TITU,
                            P_C025      => P_CHEQ_FECH_EMIS,
                            P_C026      => P_CHEQ_FECH_VENC,
                            P_C027      => V_IND_CHEQUE,
                            P_C028      => v_pago_impo_mone1,
                            P_C029      => v_pago_impo_mmnn1,
                            P_C030      => v_pago_impo_movi1);



I020234.pp_calcular_importe_cab;


end pp_cargar_pago;


procedure pp_validar_fp(p_pago_tipo           in varchar2,
                        p_pago_desc           out varchar2,
                        p_cuen_indi_caja_banc out varchar2,
                        p_ind_cheque          out varchar2) is
begin
  

--raise_application_error(-20001,p_pago_tipo||'--'||V('P110_P_EMIT_RECI') );
  if p_pago_tipo = '1' then
    p_pago_desc           := 'Efectivo';
    p_cuen_indi_caja_banc := 'C';
  elsif p_pago_tipo = '2' then
    p_pago_desc           := 'Cheques Recibidos';
    p_cuen_indi_caja_banc := 'C';
    if V('P110_P_EMIT_RECI') = 'E' then
      raise_application_error(-20001, 'Forma de Pago incorrecta para este movimiento.');
    end if;
  elsif p_pago_tipo = '4' then
    p_pago_desc           := 'Cheques Emitidos';
    p_cuen_indi_caja_banc := 'B';
    
    if V('P110_P_EMIT_RECI') = 'R' then
      raise_application_error(-20001,'Forma de Pago incorrecta para este movimiento.');
    end if;
    
  elsif p_pago_tipo = '5' then
    p_pago_desc           := 'Vuelto Efectivo';
    p_cuen_indi_caja_banc := 'C';
  else
    raise_application_error(-20001, 'Forma de Pago incorrecta.');
  end if;
  
  
  if P_pago_tipo  in ('1','5') then	
     p_ind_cheque := 'N';
    else
      
      parameter.p_validar_cheques := 'S';
      parameter.p_validar_tarjeta := 'S';
      p_ind_cheque := 'S';
  end if;
end pp_validar_fp;



procedure pp_asig_indi_dbcr(p_pago_tipo      in varchar2,
                            p_pago_cobr_indi out varchar2) is
begin
  ----indicador ingreso o egreso
  if V('P110_EMIT_RECI') = 'R' then
    if p_pago_tipo = '1' then
      if V('P110_TIMO_DBCR_CAJA') = 'C' then
        p_pago_cobr_indi := 'C';
      else
        p_pago_cobr_indi := 'D';
      end if;
    elsif p_pago_tipo = '2' then
      p_pago_cobr_indi := 'D';
    elsif p_pago_tipo = '4' then
      p_pago_cobr_indi := 'C';
    elsif p_pago_tipo = '5' then
      if V('P110_TIMO_DBCR_CAJA') = 'C' then
        p_pago_cobr_indi := 'D';
      else
        p_pago_cobr_indi := 'C';
      end if;
    end if;
  else
    if p_pago_tipo = '1' then
      if V('P110_TIMO_DBCR_CAJA') = 'C' then
        p_pago_cobr_indi := 'C';
      else
        p_pago_cobr_indi := 'D';
      end if;
    elsif p_pago_tipo = '2' then
      p_pago_cobr_indi := 'D';
    elsif p_pago_tipo = '4' then
      p_pago_cobr_indi := 'C';
    elsif p_pago_tipo = '5' then
      if V('P110_TIMO_DBCR_CAJA') = 'C' then
        p_pago_cobr_indi := 'D';
      else
        p_pago_cobr_indi := 'C';
      end if;
    end if;
  end if;
end pp_asig_indi_dbcr;


procedure pp_buscar_moneda2 (p_mone_codi in varchar2,
                            p_timo_tica_codi in varchar2,
                            p_mone_desc out varchar2,
                            p_mone_desc_abre out varchar2,
                            p_mone_cant_deci out varchar2,
                            p_pago_coti out varchar2) is 
  
begin
if p_mone_codi is not null then
   general_skn.pl_muestra_come_mone (p_mone_codi,p_mone_desc, p_mone_desc_abre, p_mone_cant_deci);
   if p_mone_codi = V('P110_MOVI_MONE_CODI') then
     p_pago_coti := V('P110_MOVI_TASA_MONE');
       --  pp_habi_desh_sald_mone('D',null, null, null);
   else
     pp_busca_tasa_mmee (p_mone_codi, p_pago_coti,V('P110_TIMO_TICA_CODI'),V('P110_MOVI_FECH_EMIS'));
 --    pp_habi_desh_sald_mone('H',:bfp.pago_coti, :bfp.mone_desc_abre, :bfp.mone_cant_deci);
   end if;
   --  pp_formatear_importes_pago;
else
  raise_application_error(-20001, 'Debe seleccionar la moneda de pago.');
end if;


end pp_buscar_moneda2;
/*
PROCEDURE pp_habi_desh_sald_mone(p_indi in varchar2, p_coti in number, p_mone_desc_abre in varchar2, p_cant_deci in number) IS
  v_impo_movi number := 0;
  v_impo_mmnn number := 0;
BEGIN
  if p_indi = 'H' then
    if :bcab.movi_mone_codi = 1 then
      v_impo_movi := :bfp.tota_sald/p_coti;
    else
      if :bfp.mone_codi = 1 then
        v_impo_movi := :bfp.tota_sald* :bcab.movi_tasa_mone;
      else
        v_impo_mmnn := :bfp.tota_sald* :bfp.pago_coti;
        v_impo_movi := v_impo_mmnn / :bcab.movi_tasa_mone;
      end if;
    end if;
    
    :bfp.tota_sald_mone := round(v_impo_movi,p_cant_deci);
    
    set_item_property('bfp.tota_sald_mone', visible, property_true);
    set_item_property('bfp.tota_sald_mone', prompt_text, 'Saldo en '||p_mone_desc_abre);
  else
    set_item_property('bfp.tota_sald_mone', visible, property_false);
  end if;
END;*/



/*procedure pp_busca_tasa_mmee (p_mone_codi in number, p_mone_coti out number, p_tica_codi in number)is
begin
                       
  if parameter.p_codi_mone_mmnn = p_mone_codi then
     p_mone_coti := 1;
  else
    select coti_tasa
    into p_mone_coti
    from come_coti
    where coti_mone    = p_mone_codi
    and coti_tica_codi = p_tica_codi
    and coti_fech      = V('P110_MOVI_FECH_EMIS');
  end if;   
      
  Exception
      When no_data_found then
        raise_application_error(-20001, 'Cotizaciion Inexistente para la moneda extranjera  ' ||parameter.p_desc_mone_mmee);; 
  
end;
*/
procedure pp_buscar_cuenta (p_pago_tipo      in varchar2,
                            P_pago_cuen_codi in varchar2,
                            p_pago_cuen_desc out varchar2,
                            p_mone_codi      in varchar2,
                            p_cheq_cuen_codi out varchar2)is 
  v_banc_codi number;
  v_banc_desc varchar2(40);
  v_nume_cuen number;
  --se creo variables temporales para no crear elementos en el bloque ya que no se usarian.
begin
  

  if p_pago_tipo in ('1','2','3','4','5','8') then
    if P_pago_cuen_codi is not null then
        pp_muestra_come_cuen_banc (p_pago_cuen_codi,p_pago_cuen_desc, p_mone_codi,v_banc_codi, v_banc_desc);
        
        if V('P110_MOVI_DBCR') = 'D' then
          if not general_skn.fl_vali_user_cuen_banc_debi (p_pago_cuen_codi,  V('P110_MOVI_FECH_EMIS')) then
             raise_application_error(-20001,'No posee permiso para ingresar en la caja seleccionada. !!!');
          end if;
        else      
          if not general_skn.fl_vali_user_cuen_banc_cred (p_pago_cuen_codi, V('P110_MOVI_FECH_EMIS')) then
              raise_application_error(-20001,'No posee permiso para ingresar en la caja seleccionada. !!!');
          end if;
        end if;
        p_cheq_cuen_codi := p_pago_cuen_codi;
  
    else
        raise_application_error(-20001,'Debe ingresar una Caja.');
    end if;
  else -- 6
    if p_pago_cuen_codi is not null then   
      raise_application_error(-20001, 'Caja no habilitada para este tipo de pago');
    end if;
  end if;
end pp_buscar_cuenta;

procedure pp_muestra_come_cuen_banc(p_cuen_codi in number,
                                    p_cuen_desc out varchar2,
                                    p_mone_codi in number,
                                    p_banc_codi out number,
                                    p_banc_desc out varchar2) is
  v_mone_codi number;
begin

  select cuen_Desc, cuen_mone_codi, banc_codi, banc_desc
    into p_cuen_desc, v_mone_codi, p_banc_codi, p_banc_desc
    from come_cuen_banc, come_banc
   where cuen_banc_codi = banc_codi(+)
     and cuen_codi = p_cuen_codi;

  if v_mone_codi <> p_mone_codi then
    raise_application_error(-20001, 'El codigo de la moneda no coincide  con la moneda de la cuenta bancaria');
  end if;

Exception
  When no_data_found then
    raise_application_error(-20001, 'Cuenta bancaria inexistente');

end pp_muestra_come_cuen_banc;



/*
procedure pp_validar_deta_pago is
  
begin
  
if :bfp.pago_tipo in ('2','4') then
    if :bfp.cheq_nume is null then
      if :parameter.p_validar_cheques = 'S' then
       raise_application_error(-20001, 'Debe ingresar el Numero de Cheque.');
      end if;
    end if; 
    
    if parameter.p_validar_cheques = 'S' then
        raise_application_error(-20001,'Debe ingresar el codigo del banco');   
      end if;
if :bfp.cheq_nume_cuen is null then    
      if :parameter.p_validar_cheques = 'S' then
        pl_me('Debe ingresar el Numero de cuenta del Cheque');
      end if;
    end if;  
end if;



\*declare
  v_banc_codi number;
  v_banc_desc varchar2(100);
  v_nume_cuen varchar2(60);
begin
  if :bfp.pago_tipo in ('2','4') then
    if :bfp.cheq_cuen_codi is not null then
        pl_muestra_come_cuen_banc (:bfp.cheq_cuen_codi,:bfp.cheq_cuen_desc,:bfp.cheq_mone_codi,v_banc_codi,v_banc_desc,v_nume_cuen);
        
        if :bfp.pago_tipo = '4' then
          :bfp.cheq_banc_codi := v_banc_codi;
          :bfp.cheq_banc_desc := v_banc_desc;
          :bfp.cheq_nume_cuen := v_nume_cuen;
        end if;
    end if;
  end if;
end;*\


end pp_validar_deta_pago;
*/
  --I020234.PP_VALIDA_NUME_CHEQ(:P110_CHEQ_NUME, :P110_CHEQ_SERIE, :P100_CHEQ_BANC_CODI); 
procedure pp_valida_nume_cheq (p_cheq_nume in varchar2, p_cheq_serie in varchar2, p_cheq_banc_codi in number) is
v_banc_desc varchar2(60);
begin  
	
  select  banc_desc
  into    v_banc_desc
  from come_cheq, come_banc
  where cheq_banc_codi = banc_codi
  and rtrim(ltrim(cheq_nume)) = rtrim(ltrim(p_cheq_nume))
  and rtrim(ltrim(cheq_serie)) = rtrim(ltrim(p_cheq_serie))
  and cheq_banc_codi = p_cheq_banc_codi;
  
  if parameter.p_indi_vali_repe_cheq = 'S' then
    raise_application_error(-20001, 'Atencion!!! Cheque existente... Numero'||p_cheq_nume||' Serie'||p_cheq_serie||' Banco '||v_banc_desc);
  else
    raise_application_error(-20001,'Atencion!!! Cheque existente... Numero'||p_cheq_nume||' Serie'||p_cheq_serie||' Banco '||v_banc_desc);
  end if;  	
  
Exception         
	  When no_data_found then
	    null;     
	  When too_many_rows then
	    if parameter.p_indi_vali_repe_cheq = 'S' then
       raise_application_error(-20001,'Atencion!!! Cheque existente... Numero'||p_cheq_nume||' Serie'||p_cheq_serie||' Banco '||v_banc_desc);
      else
       raise_application_error(-20001,'Atencion!!! Cheque existente... Numero'||p_cheq_nume||' Serie'||p_cheq_serie||' Banco '||v_banc_desc);
      end if;  	
  
end pp_valida_nume_cheq;


procedure pp_cta_Cheque (p_pago_tipo           in varchar2,
                         p_cheq_cuen_codi      in varchar2, 
                         p_cheq_mone_codi      out varchar2,
                         p_cheq_cuen_desc      out varchar2,
                         p_cheq_banc_codi      out varchar2,
                         p_cheq_banc_desc      out varchar2,
                         p_cheq_nume_cuen      out varchar2) is

  v_banc_codi number;
  v_banc_desc varchar2(100);
  v_nume_cuen varchar2(60);
  
begin
  if  p_pago_tipo in ('2','4') then
    if p_cheq_cuen_codi is not null then
        general_skn.pl_muestra_come_cuen_banc (p_cheq_cuen_codi, p_cheq_cuen_desc,p_cheq_mone_codi,v_banc_codi,v_banc_desc,v_nume_cuen);
        
        if p_pago_tipo = '4' then
          p_cheq_banc_codi := v_banc_codi;
          p_cheq_banc_desc := v_banc_desc;
          p_cheq_nume_cuen := v_nume_cuen;
          else
          p_cheq_banc_codi := null;
          p_cheq_banc_desc := null;
          p_cheq_nume_cuen := null;
        end if;
    end if;
  end if;



end pp_cta_Cheque;


function pp_decimales (p_monto      in varchar2,
                        p_cant_deci  in number)return varchar2 is
   v_decimales varchar2(1000);  
   v_monto varchar2(100);                   
begin
v_monto := replace(to_Char(p_monto,'999g999g999g999g999g999g999g999'),' ');
if p_cant_deci > 0 then
  v_decimales :='D';
for x in 1..p_cant_deci loop
  v_decimales := v_decimales||'9';
end loop;
  
else 
 v_decimales := null;
end if ;
v_monto := replace(to_Char(p_monto,'999g999g999g999g999g999g999g999'||v_decimales),' ');

return  v_monto;

end  pp_decimales;   


procedure pp_calcular_importe_cab  is
 cursor total is
 select nvl(sum(c012), 0) pago_impo_mone,
        nvl(sum(c013), 0) pago_impo_mmnn,
        nvl(sum(c014), 0) pago_impo_movi,
        case
          when c004 = 'D' and c001 in ('1', '5') then
           nvl(sum(c014), 0)
        end s_efec_ingr,
        case
          when c004 = 'D' and c001 in ('2') then
           nvl(sum(c014), 0)
        end s_cheq_ingr,
        case
          when c004 <> 'D' and c001 in ('1', '5') then --pago_cobr_indi
           nvl(sum(c014), 0)
        end s_efec_egre,
        case
          when c004 <> 'D' and c001 in ('4') then
           nvl(sum(c014), 0)
        end s_cheq_egre
   from apex_collections
  where collection_name = 'DETA_PAGO'
  group by c004, c001;
  
  p_tota_pago        varchar2(200);
  p_tota_sald        varchar2(200);
  p_tota_fact        varchar2(200);
  p_tota_efec_egre   varchar2(200);
  p_tota_cheq_egre   varchar2(200); 
  p_tota_efec_ingr   varchar2(200);
  p_tota_cheq_ingr   varchar2(200);
begin


 -- pago
  p_tota_fact := NVL(V('P110_MOVI_EXEN_MONE'),0);
  p_tota_efec_egre :=0;
  p_tota_cheq_egre :=0;
  p_tota_efec_ingr :=0;
  p_tota_cheq_ingr :=0;
  p_tota_pago := 0;
FOR X IN total  LOOP

  p_tota_efec_egre :=NVL(p_tota_efec_egre,0) + NVL(x.s_efec_egre,0);--
  p_tota_cheq_egre :=NVL(p_tota_cheq_egre,0) + NVL(x.s_cheq_egre,0);
  p_tota_efec_ingr :=NVL(p_tota_efec_ingr,0) + NVL(x.s_cheq_ingr,0);
  p_tota_cheq_ingr :=NVL(p_tota_cheq_ingr,0) + NVL(x.s_efec_ingr,0);
  p_tota_pago := NVL(p_tota_pago,0)+NVL(X.pago_impo_movi,0);
END LOOP;


--p_tota_pago :=(nvl(p_tota_efec_ingr,0)+nvl(p_tota_cheq_ingr,0)) - (nvl(p_tota_efec_egre,0)+nvl(p_tota_cheq_egre,0));
--raise_application_error(-20001,Nvl(V('P110_TOTA_FACT'),0)||'--'||nvl(p_tota_pago,0));

p_tota_sald :=p_tota_fact- nvl(p_tota_pago,0);

SETITEM('P111_TOTA_EFEC_INGR', p_tota_efec_ingr);
SETITEM('P111_TOTA_CHEQ_INGR', p_tota_cheq_ingr);
SETITEM('P111_TOTA_EFEC_EGRE', p_tota_efec_egre);
SETITEM('P111_TOTA_CHEQ_EGRE', p_tota_cheq_egre);
SETITEM('P111_TOTA_PAGO', p_tota_pago);
SETITEM('P111_TOTA_SALD', p_tota_sald);
SETITEM('P111_TOTA_FACT', p_tota_fact);

SETITEM('P110_S_IMPO_EFEC', p_tota_pago);
SETITEM('P110_S_IMPO_CHEQ', p_tota_sald);


 if V('P110_EMIT_RECI') = 'E'  then
    if V('P110_TIMO_DBCR_CAJA') = 'C' then
      SETITEM('P110_S_IMPO_EFEC',  -nvl(p_tota_efec_ingr,0) + nvl(p_tota_efec_egre,0) );
      SETITEM('P110_S_IMPO_CHEQ',  -nvl(p_tota_cheq_ingr,0) + nvl(p_tota_cheq_egre,0) );
    
       else
       SETITEM('P110_S_IMPO_EFEC',  nvl(p_tota_efec_ingr,0) - nvl(p_tota_efec_egre,0));
       SETITEM('P110_S_IMPO_CHEQ', nvl(p_tota_cheq_ingr,0) - nvl(p_tota_cheq_egre,0));
    end if; 

 elsif V('P110_EMIT_RECI') = 'R'  then                                         
    if V('P110_TIMO_DBCR_CAJA')= 'C' then
      SETITEM('P110_S_IMPO_EFEC',  -nvl(p_tota_efec_ingr,0) + nvl(p_tota_efec_egre,0)); /*- nvl(:brete.movi_impo_rete, 0)*/
      SETITEM('P110_S_IMPO_CHEQ',  nvl(p_tota_cheq_egre,0) - nvl(p_tota_cheq_ingr,0));
    else
      SETITEM('P110_S_IMPO_EFEC', nvl(p_tota_efec_ingr,0) - nvl(p_tota_efec_egre,0));
      SETITEM('P110_S_IMPO_CHEQ', -nvl(p_tota_cheq_egre,0) + nvl(p_tota_cheq_ingr,0));
    end if; 
   
 end if;

 --raise_application_error(-20001,'Atenci?n!!!'||x.s_cheq_ingr);
 
end pp_calcular_importe_cab; 


procedure pp_calcular_importe_cab2 is
 cursor total is
 select nvl(sum(c012), 0) pago_impo_mone,
        nvl(sum(c013), 0) pago_impo_mmnn,
        nvl(sum(c014), 0) pago_impo_movi,
        case
          when c004 = 'D' and c001 in ('1', '5') then
           nvl(sum(c014), 0)
        end s_efec_ingr,
        case
          when c004 = 'D' and c001 in ('2') then
           nvl(sum(c014), 0)
        end s_cheq_ingr,
        case
          when c004 <> 'D' and c001 in ('1', '5') then --pago_cobr_indi
           nvl(sum(c014), 0)
        end s_efec_egre,
        case
          when c004 <> 'D' and c001 in ('4') then
           nvl(sum(c014), 0)
        end s_cheq_egre
   from apex_collections
  where collection_name = 'DETA_PAGO'
  group by c004, c001;
  
  p_tota_pago        varchar2(200);
  p_tota_sald        varchar2(200);
  p_tota_fact        varchar2(200);
  p_tota_efec_egre   varchar2(200);
  p_tota_cheq_egre   varchar2(200); 
  p_tota_efec_ingr   varchar2(200);
  p_tota_cheq_ingr   varchar2(200);
begin


 -- pago
  p_tota_fact := NVL(V('P110_MOVI_EXEN_MONE'),0);
  p_tota_efec_egre :=0;
  p_tota_cheq_egre :=0;
  p_tota_efec_ingr :=0;
  p_tota_cheq_ingr :=0;
  p_tota_pago := 0;
FOR X IN total  LOOP

  p_tota_efec_egre :=NVL(p_tota_efec_egre,0) + NVL(x.s_efec_egre,0);--
  p_tota_cheq_egre :=NVL(p_tota_cheq_egre,0) + NVL(x.s_cheq_egre,0);
  p_tota_efec_ingr :=NVL(p_tota_efec_ingr,0) + NVL(x.s_cheq_ingr,0);
  p_tota_cheq_ingr :=NVL(p_tota_cheq_ingr,0) + NVL(x.s_efec_ingr,0);
  p_tota_pago := NVL(p_tota_pago,0)+NVL(X.pago_impo_movi,0);
END LOOP;

 if V('P110_P_EMIT_RECI') = 'E'  then
    if V('P110_TIMO_DBCR_CAJA') = 'C' then
      SETITEM('P110_S_IMPO_EFEC',  -nvl(p_tota_efec_ingr,0) + nvl(p_tota_efec_egre,0) );
      SETITEM('P110_S_IMPO_CHEQ',  -nvl(p_tota_cheq_ingr,0) + nvl(p_tota_cheq_egre,0) );
    
       else
       SETITEM('P110_S_IMPO_EFEC',  nvl(p_tota_efec_ingr,0) - nvl(p_tota_efec_egre,0));
       SETITEM('P110_S_IMPO_CHEQ', nvl(p_tota_cheq_ingr,0) - nvl(p_tota_cheq_egre,0));
    end if; 

 elsif V('P110_P_EMIT_RECI') = 'R'  then                                         
    if V('P110_TIMO_DBCR_CAJA')= 'C' then
      SETITEM('P110_S_IMPO_EFEC',  -nvl(p_tota_efec_ingr,0) + nvl(p_tota_efec_egre,0)); /*- nvl(:brete.movi_impo_rete, 0)*/
      SETITEM('P110_S_IMPO_CHEQ',  nvl(p_tota_cheq_egre,0) - nvl(p_tota_cheq_ingr,0));
    else
      SETITEM('P110_S_IMPO_EFEC', nvl(p_tota_efec_ingr,0) - nvl(p_tota_efec_egre,0));
      SETITEM('P110_S_IMPO_CHEQ', -nvl(p_tota_cheq_egre,0) + nvl(p_tota_cheq_ingr,0));
    end if; 
    

 end if;
 --SETITEM('P110_S_IMPO_EFEC', 1 - 2);
  --    SETITEM('P110_S_IMPO_CHEQ',2);

--raise_Application_error(-20001,'adf');
end pp_calcular_importe_cab2;                   
end I020234;
