
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020091" is

----------------SUCURSAL 


   
 type r_parameter is record(
   

  p_indi_most_regi_patr              varchar2(100):= general_skn.fl_busca_parametro ('p_indi_most_regi_patr'),             
  p_cant_dias_repo                   varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_dias_repo')),   
  p_conc_codi_ingr_paga_empr         varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_conc_codi_ingr_paga_empr')),   
  p_conc_codi_ingr_paga_ips          varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_conc_codi_ingr_paga_ips')),                     
  
  p_rrhh_indi_modif_fech_caja        varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_rrhh_indi_modif_fech_caja'))),
   
  p_form_consultar                   varchar2(100):= general_skn.fl_busca_parametro('p_form_cons_rrhh_movi'),
  p_form_borrar                      varchar2(100):= general_skn.fl_busca_parametro('p_form_borr_rrhh_movi'),
  p_codi_mone_mmnn                   varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmnn')),   
  
  
  p_cant_deci_porc                   varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_porc')),   
  p_cant_deci_mmnn                   varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn')),   
  p_cant_deci_mmee                   varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmee')),   
  p_cant_deci_cant                   varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_cant')),   
  
  --p_cant_deci_prec_unitvarchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_prec_unit')),  
  
  p_indi_impr_cheq_emit                  varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),  
  p_indi_vali_repe_cheq                  varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'))), 
  
  p_codi_timo_vari_cred                  varchar2(100):= to_number(ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_timo_vari_cred')))), 
  p_codi_timo_vari_debi                  varchar2(100):= to_number(ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_timo_vari_debi')))), 
  
  p_form_impr_rrhh_movi_vari             varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_rrhh_movi_vari'))), 
  p_codi_conc_vale_rrhh                  varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_conc_vale_rrhh'))), 
  p_form_impr_rrhh_vale                  varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_rrhh_vale'))), 
  p_fech_inic                            varchar2(100),
  p_fech_fini                            varchar2(100),
  
  
  p_codi_peri_actu_rrhh                  varchar2(100):= to_number(ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_peri_actu_rrhh')))), 
  p_codi_peri_sgte_rrhh                  varchar2(100):= to_number(ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_peri_sgte_rrhh')))), 
  
  p_indi_validar                          varchar2(100),
  p_sucu_codi                            varchar2(100):=v('AI_SUCU_CODI'),
  p_empr_codi                            varchar2(100) := v('AI_EMPR_CODI'),
  p_codi_base                            varchar2(100):= pack_repl.fa_devu_codi_base ,
  p_fech_inic_rrhh                        varchar2(100),
  p_fech_fini_rrhh                         varchar2(100),
  p_codi_impu_exen                         number
    );
  
  parameter r_parameter;
  
     type r_bcab is record(
            movi_codi      number,
            conc_codi      number,
            empl_codi      number,
            movi_mone_codi number,
            movi_fech_emis date,
            movi_fech_grab date,
            movi_user      varchar2(20),
            movi_impo_mone number,
            movi_impo_mmnn number,
            movi_tasa_mone number,
            conc_indi_cuot varchar2(1),
            movi_cond_pago varchar2(2),
            movi_nume      number,
            movi_obse      varchar2(500),
            movi_cant      number,
            impo_unit_mone number,
            movi_mone_codi_liqu number,
            movi_tasa_mone_liqu number,
            movi_impo_mone_liqu number,
                    
            movi_fech_caja      date,
            cuen_codi           number,
            movi_sucu_codi_orig number,
          
            conc_dbcr            varchar2(600),
            conc_come_codi       varchar2(600),
            conc_indi_caja       varchar2(600),
            come_movi_codi       number,
            mone_cant_deci_liqu   number,
            perf_codi             number
   );
  bcab r_bcab;


  cursor cuota is
  select  c001           dias,--apli_codigo,
          c002           s_cuot_fech_venc,--apli_fecha,
          c003           cuot_fech_Venc,
          c004           cuot_impo_mone,
          c005           cuot_impo_mmnn,
          c006           cuot_impo_mone_liqu
    from apex_collections
   where collection_name = 'CUOTA';

procedure pp_iniciar (p_perf_codi                         out number, 
                      p_movi_sucu_codi_orig               out number,
                      p_rrhh_indi_m_fech_caja             out varchar2,
                      p_perf_desc                         out varchar2,
                      p_indi_validar                      out varchar2,
                      p_codi_mone_mmnn                    out varchar2)is  
     
begin     
  --------------:parameter.p_empr_codi usar en lugar de p_empr
        
apex_collection.create_or_truncate_collection(p_collection_name => 'CUOTA');
    pa_devu_fech_habi(parameter.p_fech_inic,parameter.p_fech_fini );
  
    p_movi_sucu_codi_orig := parameter.p_sucu_codi;
    p_rrhh_indi_m_fech_caja := parameter.p_rrhh_indi_modif_fech_caja;
  
/*  if :parameter.p_rrhh_indi_modif_fech_caja = 'n' then
    set_item_property('bcab.s_movi_fech_caja', visible, property_false)   ;
  end if; */
  
  
    I020091.pp_busca_perf_codi (p_perf_codi, p_perf_desc);
    I020091.pp_carga_fech_habi_rrhh(parameter.p_fech_inic_rrhh, parameter.p_fech_fini_rrhh);
    
    parameter.p_indi_validar := 'N';
    p_indi_validar :=parameter.p_indi_validar;
    
    p_codi_mone_mmnn :=  parameter.p_codi_mone_mmnn;
end pp_iniciar;           
  
 
procedure pp_carga_fech_habi_rrhh (p_fech_inic out date, p_fech_fini out date)is
begin
  select  peri_fech_inic
  into  p_fech_inic
  from rrhh_peri
  where peri_codi = parameter.p_codi_peri_actu_rrhh;
  
  
  select  peri_fech_fini
  into  p_fech_fini
  from rrhh_peri
  where peri_codi = parameter.p_codi_peri_sgte_rrhh;
  
  
exception
	  when no_data_found then
	     raise_application_error(-20010,'Periodo actual o siguiente no encontrado');
	  when others then
	     raise_application_error(-20010,'Error al recuperar el rango de fecha habilitada')  ;
  
  
end;

procedure pp_busca_perf_codi (p_perf_codi out  number ,
                              p_perf_desc out  varchar2 ) is

begin	  
	           
  select perf_codi, perf_desc
  into   p_perf_codi, p_perf_desc
  from   rrhh_perf p, segu_user u
  where  p.perf_codi = u.user_perf_codi
  and u.user_login = gen_user;
  
exception
  when no_data_found then
    null;
  
  when others then
     raise_application_error(-20010,'Error');
end pp_busca_perf_codi;


procedure pp_insert_rrhh_movi_cuot (             

    p_cuot_movi_codi      in number ,
    p_cuot_nume_item      in number ,         
    p_cuot_fech_venc      in date  ,  
    p_cuot_impo_mone      in number ,
    p_cuot_impo_mmnn      in number ,
    p_cuot_nume           in number , 
    p_cuot_impo_mone_liqu in number, 
    p_cuot_base           in number) is
    

begin
  
  insert into rrhh_movi_cuot_deta (
      cuot_movi_codi    ,
      cuot_nume_item    ,         
      cuot_fech_venc    ,  
      cuot_impo_mone    ,
      cuot_impo_mmnn    ,
      cuot_nume         ,
      cuot_impo_mone_liqu, 
      cuot_base     ) 
  values (
      p_cuot_movi_codi    ,
      p_cuot_nume_item    ,         
      p_cuot_fech_venc    ,  
      p_cuot_impo_mone    ,
      p_cuot_impo_mmnn    ,
      p_cuot_nume         ,
      p_cuot_impo_mone_liqu,
      p_cuot_base 
  );
  
  
end pp_insert_rrhh_movi_cuot;
procedure pp_insert_rrhh_movi ( p_movi_codi                      in number        ,
                                p_movi_conc_codi                 in number        ,
                                p_movi_empl_codi                 in number        ,
                                p_movi_mone_codi                 in number        ,
                                p_movi_fech_emis                 in date          ,
                                p_movi_fech_grab                 in date          ,
                                p_movi_user                      in varchar2      ,
                                p_movi_impo_mone                 in number        ,  
                                p_movi_impo_mmnn                 in number        ,
                                p_movi_tasa_mone                 in number        ,
                                p_movi_indi_cuot                 in varchar2      , 
                                p_movi_cond_pago                 in varchar2      ,
                                p_movi_nume                      in number        ,
                                p_movi_obse                      in varchar2      , 
                                p_movi_mone_codi_liqu            in number        ,
                                p_movi_tasa_mone_liqu            in number        ,
                                p_movi_impo_mone_liqu            in number        ,
                                p_movi_cant                      in number        , 
                                p_clas_codi                      in number, 
                                p_turn_codi                      in number, 
                                p_zara_codi                      in number,
                                p_movi_fech_caja                 in date,
                                p_movi_cuen_codi                 in number,
                                p_movi_sucu_codi_orig            in number,
                                p_movi_sucu_codi                 in number
                                                                  ) is
begin
  insert into rrhh_movi (
  movi_codi                    ,
  movi_conc_codi                 ,
  movi_empl_codi                 ,
  movi_mone_codi                 ,
  movi_fech_emis                 ,
  movi_fech_grab                 ,
  movi_user                      ,
  movi_impo_mone                 ,
  movi_impo_mmnn                 ,
  movi_tasa_mone                 ,
  movi_indi_cuot                 ,
  movi_cond_pago                 ,
  movi_nume                      ,
  movi_obse                      ,
  movi_mone_codi_liqu            ,
  movi_tasa_mone_liqu            ,
  movi_impo_mone_liqu            ,
  movi_cant                      ,
  movi_base                      , 
  movi_clas_codi , 
  movi_turn_codi , 
  movi_zara_codi,/* ,
  movi_fech_caja,
  movi_cuen_codi,
  movi_sucu_codi_orig*/
  movi_sucu_codi
  
  ) values (
  p_movi_codi                      ,
  p_movi_conc_codi                 ,
  p_movi_empl_codi                 ,
  p_movi_mone_codi                 ,
  p_movi_fech_emis                 ,
  p_movi_fech_grab                 ,
  p_movi_user                      ,
  p_movi_impo_mone                 ,  
  p_movi_impo_mmnn                 ,
  p_movi_tasa_mone                 ,
  p_movi_indi_cuot                 , 
  p_movi_cond_pago                 ,
  p_movi_nume                      ,
  p_movi_obse                      ,
  p_movi_mone_codi_liqu            ,
  p_movi_tasa_mone_liqu            ,
  p_movi_impo_mone_liqu            ,
  p_movi_cant                      ,
  parameter.p_codi_base           , 
  p_clas_Codi , 
  p_turn_codi , 
  p_zara_Codi,/* ,
  p_movi_fech_caja/* ,
  p_movi_cuen_codi,
  p_movi_sucu_codi_orig*/
  p_movi_sucu_codi
        
  );

end;

procedure pp_actualiza_rrhh_movi is
  v_movi_codi      number;
  v_movi_conc_codi number;
  v_movi_empl_codi number;
  v_movi_mone_codi number;
  v_movi_fech_emis date;
  v_movi_fech_grab date;
  v_movi_user      varchar2(20);
  v_movi_impo_mone number;
  v_movi_impo_mmnn number;
  v_movi_tasa_mone number;
  v_movi_indi_cuot varchar2(1);
  v_movi_cond_pago varchar2(2);
  v_movi_nume      number;
  v_movi_obse      varchar2(500);
  v_movi_cant      number;

  v_movi_mone_codi_liqu number;
  v_movi_tasa_mone_liqu number;
  v_movi_impo_mone_liqu number;
  
  v_movi_fech_caja date;
  v_movi_cuen_codi number;

  v_deta_empl_codi  number(10);
  v_deta_fech_prod  date;
  v_deta_conc_codi  number(10);
  v_deta_cant_prod  number(20,4);
  v_deta_impo_mmnn  number(20,4);
  v_deta_tipo_liqu  varchar2(1);
  v_deta_peri_codi  number(10);
  v_deta_prod_clas2 number(10);
  v_deta_user_regi  varchar2(20);
  v_deta_fech_regi  date;
  v_deta_base       number(2);
  v_deta_zara_tipo  varchar2(1);
  v_deta_movi_codi  number(20);
  
  
  
    v_cuot_movi_codi    number ;
    v_cuot_nume_item    number := 0;         
    v_cuot_fech_venc    date   ;  
    v_cuot_impo_mone    number ;
    v_cuot_impo_mmnn    number ;
    v_cuot_nume         number := 0;
    v_cuot_impo_mone_liqu number;
    
    v_movi_sucu_codi_orig number;
    v_movi_sucu_codi  number;


begin

  --- asignar valores.... 
  bcab.movi_codi       := fa_sec_rrhh_movi;
  v_movi_codi           := bcab.movi_codi;
  v_movi_conc_codi      := bcab.conc_codi;
  v_movi_empl_codi      := bcab.empl_codi;
  v_movi_mone_codi      := bcab.movi_mone_codi;
  v_movi_mone_codi_liqu := bcab.movi_mone_codi_liqu;
  v_movi_fech_emis      := bcab.movi_fech_emis;
  v_movi_fech_grab      := sysdate;
  v_movi_user           := gen_user;
  v_movi_impo_mone      := bcab.movi_impo_mone;
  v_movi_impo_mmnn      := round((bcab.movi_impo_mone *bcab.movi_tasa_mone), parameter.p_cant_deci_mmnn);
  v_movi_impo_mone_liqu := bcab.movi_impo_mone_liqu;
  v_movi_tasa_mone      := bcab.movi_tasa_mone;
  v_movi_tasa_mone_liqu := bcab.movi_tasa_mone_liqu;
  v_movi_indi_cuot      := bcab.conc_indi_cuot;
  v_movi_cond_pago      := bcab.movi_cond_pago;
  v_movi_nume           := bcab.movi_nume;
  v_movi_obse           := bcab.movi_obse;
  v_movi_cant           := bcab.movi_cant;

  v_movi_fech_caja := bcab.movi_fech_caja;
  v_movi_cuen_codi := bcab.cuen_codi;
  
  v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
  v_movi_sucu_codi := bcab.movi_sucu_codi_orig;

  pp_insert_rrhh_movi(v_movi_codi,
                      v_movi_conc_codi,
                      v_movi_empl_codi,
                      v_movi_mone_codi,
                      v_movi_fech_emis,
                      v_movi_fech_grab,
                      v_movi_user,
                      v_movi_impo_mone,
                      v_movi_impo_mmnn,
                      v_movi_tasa_mone,
                      v_movi_indi_cuot,
                      v_movi_cond_pago,
                      v_movi_nume,
                      v_movi_obse,
                      v_movi_mone_codi_liqu,
                      v_movi_tasa_mone_liqu,
                      v_movi_impo_mone_liqu,
                      v_movi_cant, 
                      null, 
                      null, 
                      null,
                      v_movi_fech_caja,
                      v_movi_cuen_codi,
                      v_movi_sucu_Codi_orig,
                      v_movi_sucu_codi  );


  if nvl(v_movi_impo_mone, 0) > 0 then
    v_deta_empl_codi  := v_movi_empl_codi;
    v_deta_fech_prod  := v_movi_fech_emis;
    v_deta_conc_codi  := v_movi_conc_codi;
    v_deta_cant_prod  := v_movi_cant;
    v_deta_impo_mmnn  := v_movi_impo_mone;
    v_deta_tipo_liqu  := 'N';
    v_deta_peri_codi  := null;
    v_deta_prod_clas2 := null;
    v_deta_user_regi  := gen_user;
    v_deta_fech_regi  := sysdate;
    v_deta_zara_tipo  := null;
    v_deta_movi_codi  := v_movi_codi;
    v_deta_base       := parameter.p_codi_base;
  
    insert into prod_pago_jorn_deta
      (deta_empl_codi,
       deta_fech_prod,
       deta_conc_codi,
       deta_cant_prod,
       deta_impo_mmnn,
       deta_tipo_liqu,
       deta_peri_codi,
       deta_prod_clas2,
       deta_user_regi,
       deta_fech_regi,
       deta_zara_tipo,
       deta_movi_codi,
       deta_base    , 
       deta_clas_codi, 
       deta_turn_codi, 
       deta_zara_Codi )
    values
      (v_deta_empl_codi,
       v_deta_fech_prod,
       v_deta_conc_codi,
       v_deta_cant_prod,
       v_deta_impo_mmnn,
       v_deta_tipo_liqu,
       v_deta_peri_codi,
       v_deta_prod_clas2,
       v_deta_user_regi,
       v_deta_fech_regi,
       v_deta_zara_tipo,
       v_deta_movi_codi,
       v_deta_base    , 
       null, 
       null, 
       null);
  end if;
  
  
  
  for bcuota in cuota  loop         
       v_cuot_movi_codi       := bcab.movi_codi;
       v_cuot_nume_item       := v_cuot_nume_item + 1;
       v_cuot_fech_venc       := bcuota.cuot_fech_venc;
       v_cuot_impo_mone       := bcuota.cuot_impo_mone;
       v_cuot_impo_mmnn       := bcuota.cuot_impo_mmnn;
       v_Cuot_impo_mone_liqu  := bcuota.cuot_impo_mone_liqu;     
       v_cuot_nume            := v_cuot_nume + 1;
      
       pp_insert_rrhh_movi_cuot(
       v_cuot_movi_codi     ,
       v_cuot_nume_item     ,
       v_cuot_fech_venc     ,
       v_cuot_impo_mone     ,
       v_cuot_impo_mmnn     ,
       v_cuot_nume          , 
       v_cuot_impo_mone_liqu, 
       1 );
       
  end loop; 
  
end pp_actualiza_rrhh_movi;
procedure pp_insert_movi_conc_deta   (p_moco_movi_codi                  in number, 
                                      p_moco_nume_item                  in number, 
                                      p_moco_conc_codi                  in number, 
                                      p_moco_cuco_codi                  in number, 
                                      p_moco_impu_codi                  in number, 
                                      p_moco_impo_mmnn                  in number, 
                                      p_moco_impo_mmee                  in number, 
                                      p_moco_impo_mone                  in number, 
                                      p_moco_dbcr                       in varchar2, 
                                      p_moco_base                       in number, 
                                      p_moco_tiim_codi                  in number, 
                                      p_moco_desc                       in varchar2, 
                                      p_moco_indi_fact_serv             in varchar2, 
                                      p_moco_impo_mone_ii               in number, 
                                      p_moco_cant                       in number, 
                                      p_moco_cant_pulg                  in number, 
                                      p_moco_ortr_codi                  in number, 
                                      p_moco_movi_codi_padr             in number, 
                                      p_moco_nume_item_padr             in number, 
                                      p_moco_impo_codi                  in number, 
                                      p_moco_ceco_codi                  in number, 
                                      p_moco_orse_codi                  in number, 
                                      p_moco_tran_codi                  in number, 
                                      p_moco_bien_codi                  in number, 
                                      p_moco_tipo_item                  in varchar2, 
                                      p_moco_clpr_codi                  in number, 
                                      p_moco_prod_nume_item             in number, 
                                      p_moco_guia_nume                  in number, 
                                      p_moco_emse_codi                  in number, 
                                      p_moco_impo_mmnn_ii               in number, 
                                      p_moco_grav10_ii_mone             in number, 
                                      p_moco_grav5_ii_mone              in number, 
                                      p_moco_grav10_ii_mmnn             in number, 
                                      p_moco_grav5_ii_mmnn              in number, 
                                      p_moco_grav10_mone                in number, 
                                      p_moco_grav5_mone                 in number, 
                                      p_moco_grav10_mmnn                in number, 
                                      p_moco_grav5_mmnn                 in number, 
                                      p_moco_iva10_mone                 in number, 
                                      p_moco_iva5_mone                  in number, 
                                      p_moco_conc_codi_impu             in number, 
                                      p_moco_tipo                       in varchar2, 
                                      p_moco_prod_codi                  in number, 
                                      p_moco_ortr_codi_fact             in number, 
                                      p_moco_iva10_mmnn                 in number, 
                                      p_moco_iva5_mmnn                  in number, 
                                      p_moco_sofa_sose_codi             in number, 
                                      p_moco_sofa_nume_item             in number, 
                                      p_moco_exen_mone                  in number, 
                                      p_moco_exen_mmnn                  in number, 
                                      p_moco_empl_codi                  in number, 
                                      p_moco_anex_codi                  in number, 
                                      p_moco_lote_codi                  in number, 
                                      p_moco_bene_codi                  in number, 
                                      p_moco_medi_codi                  in number, 
                                      p_moco_cant_medi                  in number, 
                                      p_moco_indi_excl_cont             in varchar2, 
                                      p_moco_anex_nume_item             in number, 
                                      p_moco_juri_codi                  in number, 
                                      p_moco_impo_diar_mone             in number, 
                                      p_moco_coib_codi                  in number,
                                      p_moco_sucu_codi                  in number
                                      ) is
             
begin
  insert into come_movi_conc_deta (
moco_movi_codi                  , 
moco_nume_item                  , 
moco_conc_codi                  , 
moco_cuco_codi                  , 
moco_impu_codi                  , 
moco_impo_mmnn                  , 
moco_impo_mmee                  , 
moco_impo_mone                  , 
moco_dbcr                       , 
moco_base                       , 
moco_tiim_codi                  , 
moco_desc                       , 
moco_indi_fact_serv             , 
moco_impo_mone_ii               , 
moco_cant                       , 
moco_cant_pulg                  , 
moco_ortr_codi                  , 
moco_movi_codi_padr             , 
moco_nume_item_padr             , 
moco_impo_codi                  , 
moco_ceco_codi                  , 
moco_orse_codi                  , 
moco_tran_codi                  , 
moco_bien_codi                  , 
moco_tipo_item                  , 
moco_clpr_codi                  , 
moco_prod_nume_item             , 
moco_guia_nume                  , 
moco_emse_codi                  , 
moco_impo_mmnn_ii               , 
moco_grav10_ii_mone             , 
moco_grav5_ii_mone              , 
moco_grav10_ii_mmnn             , 
moco_grav5_ii_mmnn              , 
moco_grav10_mone                , 
moco_grav5_mone                 , 
moco_grav10_mmnn                , 
moco_grav5_mmnn                 , 
moco_iva10_mone                 , 
moco_iva5_mone                  , 
moco_conc_codi_impu             , 
moco_tipo                       , 
moco_prod_codi                  , 
moco_ortr_codi_fact             , 
moco_iva10_mmnn                 , 
moco_iva5_mmnn                  , 
moco_sofa_sose_codi             , 
moco_sofa_nume_item             , 
moco_exen_mone                  , 
moco_exen_mmnn                  , 
moco_empl_codi                  , 
moco_anex_codi                  , 
moco_lote_codi                  , 
moco_bene_codi                  , 
moco_medi_codi                  , 
moco_cant_medi                  , 
moco_indi_excl_cont             , 
moco_anex_nume_item             , 
moco_juri_codi                  , 
moco_impo_diar_mone             , 
moco_coib_codi                  ,
moco_sucu_codi                  ) values (
p_moco_movi_codi                  , 
p_moco_nume_item                  , 
p_moco_conc_codi                  , 
p_moco_cuco_codi                  , 
p_moco_impu_codi                  , 
p_moco_impo_mmnn                  , 
p_moco_impo_mmee                  , 
p_moco_impo_mone                  , 
p_moco_dbcr                       , 
p_moco_base                       , 
p_moco_tiim_codi                  , 
p_moco_desc                       , 
p_moco_indi_fact_serv             , 
p_moco_impo_mone_ii               , 
p_moco_cant                       , 
p_moco_cant_pulg                  , 
p_moco_ortr_codi                  , 
p_moco_movi_codi_padr             , 
p_moco_nume_item_padr             , 
p_moco_impo_codi                  , 
p_moco_ceco_codi                  , 
p_moco_orse_codi                  , 
p_moco_tran_codi                  , 
p_moco_bien_codi                  , 
p_moco_tipo_item                  , 
p_moco_clpr_codi                  , 
p_moco_prod_nume_item             , 
p_moco_guia_nume                  , 
p_moco_emse_codi                  , 
p_moco_impo_mmnn_ii               , 
p_moco_grav10_ii_mone             , 
p_moco_grav5_ii_mone              , 
p_moco_grav10_ii_mmnn             , 
p_moco_grav5_ii_mmnn              , 
p_moco_grav10_mone                , 
p_moco_grav5_mone                 , 
p_moco_grav10_mmnn                , 
p_moco_grav5_mmnn                 , 
p_moco_iva10_mone                 , 
p_moco_iva5_mone                  , 
p_moco_conc_codi_impu             , 
p_moco_tipo                       , 
p_moco_prod_codi                  , 
p_moco_ortr_codi_fact             , 
p_moco_iva10_mmnn                 , 
p_moco_iva5_mmnn                  , 
p_moco_sofa_sose_codi             , 
p_moco_sofa_nume_item             , 
p_moco_exen_mone                  , 
p_moco_exen_mmnn                  , 
p_moco_empl_codi                  , 
p_moco_anex_codi                  , 
p_moco_lote_codi                  , 
p_moco_bene_codi                  , 
p_moco_medi_codi                  , 
p_moco_cant_medi                  , 
p_moco_indi_excl_cont             , 
p_moco_anex_nume_item             , 
p_moco_juri_codi                  , 
p_moco_impo_diar_mone             , 
p_moco_coib_codi                  ,
p_moco_sucu_codi
);

end pp_insert_movi_conc_deta;

procedure pp_insert_come_movi_impo_deta  (p_moim_movi_codi              in number, 
                                          p_moim_nume_item              in number,
                                          p_moim_tipo                   in varchar2,
                                          p_moim_cuen_codi              in number,
                                          p_moim_dbcr                   in varchar2,
                                          p_moim_afec_caja              in varchar2,
                                          p_moim_fech                   in date,
                                          p_moim_impo_mone              in number,
                                          p_moim_impo_mmnn              in number,
                                          p_moim_base                   in number,
                                          p_moim_cheq_codi              in number,
                                          p_moim_caja_codi              in number,
                                          p_moim_impo_mmee              in number,
                                          p_moim_asie_codi              in number,
                                          p_moim_fech_oper              in date,
                                          p_moim_tarj_cupo_codi         in number,
                                          p_moim_movi_codi_vale         in number,
                                          p_moim_form_pago              in number,
                                          p_moim_fech_orig              in date,
                                          p_moim_fech_conc              in date,
                                          p_moim_user_conc              in varchar2,
                                          p_moim_indi_conc              in varchar2,
                                          p_moim_obse_conc              in varchar2,
                                          p_moim_conc_codi              in number,
                                          p_moim_colo_conc              in varchar2,
                                          p_moim_viaj_codi              in number,
                                          p_moim_obse                   in varchar2,
                                          p_moim_impo_movi              in number,
                                          p_moim_tasa_mone              in number,
                                          p_moim_user_regi              in varchar2,
                                          p_moim_fech_regi              in date,
                                          p_moim_indi_impo_igua         in varchar2) is
begin                  
  insert into come_movi_impo_deta (
moim_movi_codi              , 
moim_nume_item              ,
moim_tipo                   ,
moim_cuen_codi              ,
moim_dbcr                   ,
moim_afec_caja              ,
moim_fech                   ,
moim_impo_mone              ,
moim_impo_mmnn              ,
moim_base                   ,
moim_cheq_codi              ,
moim_caja_codi              ,
moim_impo_mmee              ,
moim_asie_codi              ,
moim_fech_oper              ,
moim_tarj_cupo_codi         ,
moim_movi_codi_vale         ,
moim_form_pago              ,
moim_fech_orig              ,
moim_fech_conc              ,
moim_user_conc              ,
moim_indi_conc              ,
moim_obse_conc              ,
moim_conc_codi              ,
moim_colo_conc              ,
moim_viaj_codi              ,
moim_obse                   ,
moim_impo_movi              ,
moim_tasa_mone              ,
moim_user_regi              ,
moim_fech_regi              ,
moim_indi_impo_igua         ) values (
p_moim_movi_codi              , 
p_moim_nume_item              ,
p_moim_tipo                   ,
p_moim_cuen_codi              ,
p_moim_dbcr                   ,
p_moim_afec_caja              ,
p_moim_fech                   ,
p_moim_impo_mone              ,
p_moim_impo_mmnn              ,
p_moim_base                   ,
p_moim_cheq_codi              ,
p_moim_caja_codi              ,
p_moim_impo_mmee              ,
p_moim_asie_codi              ,
p_moim_fech_oper              ,
p_moim_tarj_cupo_codi         ,
p_moim_movi_codi_vale         ,
p_moim_form_pago              ,
p_moim_fech_orig              ,
p_moim_fech_conc              ,
p_moim_user_conc              ,
p_moim_indi_conc              ,
p_moim_obse_conc              ,
p_moim_conc_codi              ,
p_moim_colo_conc              ,
p_moim_viaj_codi              ,
p_moim_obse                   ,
p_moim_impo_movi              ,
p_moim_tasa_mone              ,
p_moim_user_regi              ,
p_moim_fech_regi              ,
p_moim_indi_impo_igua         );


end pp_insert_come_movi_impo_deta;

procedure pp_insert_come_movi ( p_movi_codi                           in number,
                                p_movi_timo_codi                      in number,
                                p_movi_clpr_codi                      in number,
                                p_movi_sucu_codi_orig                 in number,
                                p_movi_depo_codi_orig                 in number,
                                p_movi_sucu_codi_dest                 in number,
                                p_movi_depo_codi_dest                 in number,
                                p_movi_oper_codi                      in number,
                                p_movi_cuen_codi                      in number,
                                p_movi_mone_codi                      in number,
                                p_movi_nume                           in number,
                                p_movi_fech_emis                      in date,
                                p_movi_fech_grab                      in date,
                                p_movi_user                           in varchar2,
                                p_movi_codi_padr                      in number,
                                p_movi_tasa_mone                      in number,
                                p_movi_tasa_mmee                      in number,
                                p_movi_grav_mmnn                      in number,
                                p_movi_exen_mmnn                      in number,
                                p_movi_iva_mmnn                       in number,
                                p_movi_grav_mmee                      in number,
                                p_movi_exen_mmee                      in number,
                                p_movi_iva_mmee                       in number,
                                p_movi_grav_mone                      in number,
                                p_movi_exen_mone                      in number,
                                p_movi_iva_mone                       in number,
                                p_movi_obse                           in varchar2,
                                p_movi_sald_mmnn                      in number,
                                p_movi_sald_mmee                      in number,
                                p_movi_sald_mone                      in number,
                                p_movi_stoc_suma_rest                 in varchar2,
                                p_movi_clpr_dire                      in varchar2,
                                p_movi_clpr_tele                      in varchar2,
                                p_movi_clpr_ruc                       in varchar2,
                                p_movi_clpr_desc                      in varchar2,
                                p_movi_emit_reci                      in varchar2,
                                p_movi_afec_sald                      in varchar2,
                                p_movi_dbcr                           in varchar2,
                                p_movi_stoc_afec_cost_prom            in varchar2,
                                p_movi_empr_codi                      in number,
                                p_movi_clave_orig                     in number,
                                p_movi_clave_orig_padr                in number,
                                p_movi_indi_iva_incl                  in varchar2,
                                p_movi_empl_codi                      in number,
                                p_movi_obse_deta                      in varchar2,
                                p_movi_base                           in number,
                                p_movi_ortr_codi                      in number,
                                p_movi_codi_padr_vali                 in number,
                                p_movi_rrhh_movi_codi                 in number,
                                p_movi_asie_codi                      in number,
                                p_movi_orpa_codi                      in number,
                                p_movi_impo_codi                      in number,
                                p_movi_indi_conta                     in varchar2,
                                p_movi_nume_timb                      in varchar2,
                                p_movi_excl_cont                      in varchar2,
                                p_movi_impo_dife_camb                 in number,
                                p_movi_mone_codi_liqu                 in number,
                                p_movi_mone_liqu                      in number,
                                p_movi_tasa_mone_liqu                 in number,
                                p_movi_impo_mone_liqu                 in number,
                                p_movi_codi_rete                      in number,
                                p_movi_orpe_codi                      in number,
                                p_movi_cons_codi                      in number,
                                p_movi_indi_inte                      in varchar2,
                                p_movi_indi_deve_gene                 in varchar2,
                                p_movi_fech_oper                      in date,
                                p_movi_fech_venc_timb                 in date,
                                p_movi_orpe_codi_loca                 in number,
                                p_movi_impo_reca                      in number,
                                p_movi_fech_inic_tras                 in date,
                                p_movi_fech_term_tras                 in date,
                                p_movi_tran_codi                      in number,
                                p_movi_vehi_marc                      in varchar2,
                                p_movi_vehi_chap                      in varchar2,
                                p_movi_cont_tran_nomb                 in varchar2,
                                p_movi_cont_tran_ruc                  in varchar2,
                                p_movi_cond_empl_codi                 in number,
                                p_movi_cond_nomb                      in varchar2,
                                p_movi_cond_cedu_nume                 in varchar2,
                                p_movi_cond_dire                      in varchar2,
                                p_movi_sucu_codi_movi                 in number,
                                p_movi_depo_codi_movi                 in number,
                                p_movi_impo_deto                      in number,
                                p_movi_orte_codi                      in number,
                                p_movi_cheq_indi_desc                 in varchar2,
                                p_movi_indi_liqu_tarj                 in varchar2,
                                p_movi_impo_deto_mone                 in number,
                                p_movi_tiva_codi                      in number,
                                p_movi_serv_movi_codi                 in number,
                                p_movi_serv_sald_mone                 in number,
                                p_movi_serv_sald_mmnn                 in number,
                                p_movi_soco_codi                      in number,
                                p_movi_inmu_codi                      in number,
                                p_movi_indi_expe_proc                 in varchar2,
                                p_movi_liqu_codi                      in number,
                                p_movi_liqu_codi_expe                 in number,
                                p_movi_vale_indi_impo                 in varchar2,
                                p_movi_form_entr_codi                 in number,
                                p_movi_indi_tipo_pres                 in varchar2,
                                p_movi_soma_codi                      in number,
                                p_movi_sub_clpr_codi                  in number,
                                p_movi_sode_codi                      in number,
                                p_movi_aqui_pago_codi                 in number,
                                p_movi_indi_entr_depo                 in varchar2,
                                p_movi_user_entr_depo                 in varchar2,
                                p_movi_fech_entr_depo                 in date,
                                p_movi_indi_cobr_dife                 in varchar2,
                                p_movi_livi_codi                      in number,
                                p_movi_zara_tipo                      in varchar2,
                                p_movi_impo_mone_ii                   in number,
                                p_movi_impo_mmnn_ii                   in number,
                                p_movi_clas_codi                      in number,
                                p_movi_fact_codi                      in number,
                                p_movi_grav10_ii_mone                 in number,
                                p_movi_grav5_ii_mone                  in number,
                                p_movi_grav10_ii_mmnn                 in number,
                                p_movi_grav5_ii_mmnn                  in number,
                                p_movi_grav10_mone                    in number,
                                p_movi_grav5_mone                     in number,
                                p_movi_grav10_mmnn                    in number,
                                p_movi_grav5_mmnn                     in number,
                                p_movi_iva10_mone                     in number,
                                p_movi_iva5_mone                      in number,
                                p_movi_iva10_mmnn                     in number,
                                p_movi_iva5_mmnn                      in number,
                                p_movi_nota_devu_codi                 in number,
                                p_movi_info_codi                      in number,
                                p_movi_clpr_sucu_nume_item            in number,
                                p_movi_viaj_codi                      in number,
                                p_movi_zara_codi                      in number,
                                p_movi_turn_codi                      in number,
                                p_movi_cuen_codi_reca                 in number,
                                p_movi_clpr_situ                      in number,
                                p_movi_clpr_empl_codi_recl            in number,
                                p_movi_indi_impr                      in varchar2,
                                p_movi_clpr_sucu_nume_item_or         in number,
                                p_movi_clpr_codi_orig                 in number,
                                p_movi_inve_codi                      in number,
                                p_movi_tacu_comi                      in number,
                                p_movi_tacu_iva                       in number,
                                p_movi_tacu_rete_rent                 in number,
                                p_movi_tacu_iva_rete_rent             in number,
                                p_movi_impo_inte_mone                 in number,
                                p_movi_impo_inte_mmnn                 in number,
                                p_movi_soco_codi_ante                 in number,
                                p_movi_soco_oper                      in varchar2,
                                p_movi_soco_clpr_codi_ante            in number,
                                p_movi_indi_outl                      in varchar2,
                                p_movi_apci_codi                      in number,
                                p_movi_tasa_mone_pres_banc            in number,
                                p_movi_indi_diar                      in varchar2,
                                p_movi_nume_soli                      in number,
                                p_movi_nume_come                      in number,
                                p_movi_indi_cant_diar                 in varchar2,
                                p_movi_indi_most_fech                 in varchar2,
                                p_movi_nume_plan                      in number,
                                p_movi_indi_veri_fech                 in varchar2,
                                p_movi_indi_esta                      in varchar2,
                                p_movi_sopr_codi                      in number) is
begin
  insert into come_movi (
movi_codi                           ,
movi_timo_codi                      ,
movi_clpr_codi                      ,
movi_sucu_codi_orig                 ,
movi_depo_codi_orig                 ,
movi_sucu_codi_dest                 ,
movi_depo_codi_dest                 ,
movi_oper_codi                      ,
movi_cuen_codi                      ,
movi_mone_codi                      ,
movi_nume                           ,
movi_fech_emis                      ,
movi_fech_grab                      ,
movi_user                           ,
movi_codi_padr                      ,
movi_tasa_mone                      ,
movi_tasa_mmee                      ,
movi_grav_mmnn                      ,
movi_exen_mmnn                      ,
movi_iva_mmnn                       ,
movi_grav_mmee                      ,
movi_exen_mmee                      ,
movi_iva_mmee                       ,
movi_grav_mone                      ,
movi_exen_mone                      ,
movi_iva_mone                       ,
movi_obse                           ,
movi_sald_mmnn                      ,
movi_sald_mmee                      ,
movi_sald_mone                      ,
movi_stoc_suma_rest                 ,
movi_clpr_dire                      ,
movi_clpr_tele                      ,
movi_clpr_ruc                       ,
movi_clpr_desc                      ,
movi_emit_reci                      ,
movi_afec_sald                      ,
movi_dbcr                           ,
movi_stoc_afec_cost_prom            ,
movi_empr_codi                      ,
movi_clave_orig                     ,
movi_clave_orig_padr                ,
movi_indi_iva_incl                  ,
movi_empl_codi                      ,
movi_obse_deta                      ,
movi_base                           ,
movi_ortr_codi                      ,
movi_codi_padr_vali                 ,
movi_rrhh_movi_codi                 ,
movi_asie_codi                      ,
movi_orpa_codi                      ,
movi_impo_codi                      ,
movi_indi_conta                     ,
movi_nume_timb                      ,
movi_excl_cont                      ,
movi_impo_dife_camb                 ,
movi_mone_codi_liqu                 ,
movi_mone_liqu                      ,
movi_tasa_mone_liqu                 ,
movi_impo_mone_liqu                 ,
movi_codi_rete                      ,
movi_orpe_codi                      ,
movi_cons_codi                      ,
movi_indi_inte                      ,
movi_indi_deve_gene                 ,
movi_fech_oper                      ,
movi_fech_venc_timb                 ,
movi_orpe_codi_loca                 ,
movi_impo_reca                      ,
movi_fech_inic_tras                 ,
movi_fech_term_tras                 ,
movi_tran_codi                      ,
movi_vehi_marc                      ,
movi_vehi_chap                      ,
movi_cont_tran_nomb                 ,
movi_cont_tran_ruc                  ,
movi_cond_empl_codi                 ,
movi_cond_nomb                      ,
movi_cond_cedu_nume                 ,
movi_cond_dire                      ,
movi_sucu_codi_movi                 ,
movi_depo_codi_movi                 ,
movi_impo_deto                      ,
movi_orte_codi                      ,
movi_cheq_indi_desc                 ,
movi_indi_liqu_tarj                 ,
movi_impo_deto_mone                 ,
movi_tiva_codi                      ,
movi_serv_movi_codi                 ,
movi_serv_sald_mone                 ,
movi_serv_sald_mmnn                 ,
movi_soco_codi                      ,
movi_inmu_codi                      ,
movi_indi_expe_proc                 ,
movi_liqu_codi                      ,
movi_liqu_codi_expe                 ,
movi_vale_indi_impo                 ,
movi_form_entr_codi                 ,
movi_indi_tipo_pres                 ,
movi_soma_codi                      ,
movi_sub_clpr_codi                  ,
movi_sode_codi                      ,
movi_aqui_pago_codi                 ,
movi_indi_entr_depo                 ,
movi_user_entr_depo                 ,
movi_fech_entr_depo                 ,
movi_indi_cobr_dife                 ,
movi_livi_codi                      ,
movi_zara_tipo                      ,
movi_impo_mone_ii                   ,
movi_impo_mmnn_ii                   ,
movi_clas_codi                      ,
movi_fact_codi                      ,
movi_grav10_ii_mone                 ,
movi_grav5_ii_mone                  ,
movi_grav10_ii_mmnn                 ,
movi_grav5_ii_mmnn                  ,
movi_grav10_mone                    ,
movi_grav5_mone                     ,
movi_grav10_mmnn                    ,
movi_grav5_mmnn                     ,
movi_iva10_mone                     ,
movi_iva5_mone                      ,
movi_iva10_mmnn                     ,
movi_iva5_mmnn                      ,
movi_nota_devu_codi                 ,
movi_info_codi                      ,
movi_clpr_sucu_nume_item            ,
movi_viaj_codi                      ,
movi_zara_codi                      ,
movi_turn_codi                      ,
movi_cuen_codi_reca                 ,
movi_clpr_situ                      ,
movi_clpr_empl_codi_recl            ,
movi_indi_impr                      ,
movi_clpr_sucu_nume_item_orig       ,
movi_clpr_codi_orig                 ,
movi_inve_codi                      ,
movi_tacu_comi                      ,
movi_tacu_iva                       ,
movi_tacu_rete_rent                 ,
movi_tacu_iva_rete_rent             ,
movi_impo_inte_mone                 ,
movi_impo_inte_mmnn                 ,
movi_soco_codi_ante                 ,
movi_soco_oper                      ,
movi_soco_clpr_codi_ante            ,
movi_indi_outl                      ,
movi_apci_codi                      ,
movi_tasa_mone_pres_banc            ,
movi_indi_diar                      ,
movi_nume_soli                      ,
movi_nume_come                      ,
movi_indi_cant_diar                 ,
movi_indi_most_fech                 ,
movi_nume_plan                      ,
movi_indi_veri_fech                 ,
movi_indi_esta                      ,
movi_sopr_codi                                         
  ) values (
  p_movi_codi                           ,
p_movi_timo_codi                      ,
p_movi_clpr_codi                      ,
p_movi_sucu_codi_orig                 ,
p_movi_depo_codi_orig                 ,
p_movi_sucu_codi_dest                 ,
p_movi_depo_codi_dest                 ,
p_movi_oper_codi                      ,
p_movi_cuen_codi                      ,
p_movi_mone_codi                      ,
p_movi_nume                           ,
p_movi_fech_emis                      ,
p_movi_fech_grab                      ,
p_movi_user                           ,
p_movi_codi_padr                      ,
p_movi_tasa_mone                      ,
p_movi_tasa_mmee                      ,
p_movi_grav_mmnn                      ,
p_movi_exen_mmnn                      ,
p_movi_iva_mmnn                       ,
p_movi_grav_mmee                      ,
p_movi_exen_mmee                      ,
p_movi_iva_mmee                       ,
p_movi_grav_mone                      ,
p_movi_exen_mone                      ,
p_movi_iva_mone                       ,
p_movi_obse                           ,
p_movi_sald_mmnn                      ,
p_movi_sald_mmee                      ,
p_movi_sald_mone                      ,
p_movi_stoc_suma_rest                 ,
p_movi_clpr_dire                      ,
p_movi_clpr_tele                      ,
p_movi_clpr_ruc                       ,
p_movi_clpr_desc                      ,
p_movi_emit_reci                      ,
p_movi_afec_sald                      ,
p_movi_dbcr                           ,
p_movi_stoc_afec_cost_prom            ,
p_movi_empr_codi                      ,
p_movi_clave_orig                     ,
p_movi_clave_orig_padr                ,
p_movi_indi_iva_incl                  ,
p_movi_empl_codi                      ,
p_movi_obse_deta                      ,
p_movi_base                           ,
p_movi_ortr_codi                      ,
p_movi_codi_padr_vali                 ,
p_movi_rrhh_movi_codi                 ,
p_movi_asie_codi                      ,
p_movi_orpa_codi                      ,
p_movi_impo_codi                      ,
p_movi_indi_conta                     ,
p_movi_nume_timb                      ,
p_movi_excl_cont                      ,
p_movi_impo_dife_camb                 ,
p_movi_mone_codi_liqu                 ,
p_movi_mone_liqu                      ,
p_movi_tasa_mone_liqu                 ,
p_movi_impo_mone_liqu                 ,
p_movi_codi_rete                      ,
p_movi_orpe_codi                      ,
p_movi_cons_codi                      ,
p_movi_indi_inte                      ,
p_movi_indi_deve_gene                 ,
p_movi_fech_oper                      ,
p_movi_fech_venc_timb                 ,
p_movi_orpe_codi_loca                 ,
p_movi_impo_reca                      ,
p_movi_fech_inic_tras                 ,
p_movi_fech_term_tras                 ,
p_movi_tran_codi                      ,
p_movi_vehi_marc                      ,
p_movi_vehi_chap                      ,
p_movi_cont_tran_nomb                 ,
p_movi_cont_tran_ruc                  ,
p_movi_cond_empl_codi                 ,
p_movi_cond_nomb                      ,
p_movi_cond_cedu_nume                 ,
p_movi_cond_dire                      ,
p_movi_sucu_codi_movi                 ,
p_movi_depo_codi_movi                 ,
p_movi_impo_deto                      ,
p_movi_orte_codi                      ,
p_movi_cheq_indi_desc                 ,
p_movi_indi_liqu_tarj                 ,
p_movi_impo_deto_mone                 ,
p_movi_tiva_codi                      ,
p_movi_serv_movi_codi                 ,
p_movi_serv_sald_mone                 ,
p_movi_serv_sald_mmnn                 ,
p_movi_soco_codi                      ,
p_movi_inmu_codi                      ,
p_movi_indi_expe_proc                 ,
p_movi_liqu_codi                      ,
p_movi_liqu_codi_expe                 ,
p_movi_vale_indi_impo                 ,
p_movi_form_entr_codi                 ,
p_movi_indi_tipo_pres                 ,
p_movi_soma_codi                      ,
p_movi_sub_clpr_codi                  ,
p_movi_sode_codi                      ,
p_movi_aqui_pago_codi                 ,
p_movi_indi_entr_depo                 ,
p_movi_user_entr_depo                 ,
p_movi_fech_entr_depo                 ,
p_movi_indi_cobr_dife                 ,
p_movi_livi_codi                      ,
p_movi_zara_tipo                      ,
p_movi_impo_mone_ii                   ,
p_movi_impo_mmnn_ii                   ,
p_movi_clas_codi                      ,
p_movi_fact_codi                      ,
p_movi_grav10_ii_mone                 ,
p_movi_grav5_ii_mone                  ,
p_movi_grav10_ii_mmnn                 ,
p_movi_grav5_ii_mmnn                  ,
p_movi_grav10_mone                    ,
p_movi_grav5_mone                     ,
p_movi_grav10_mmnn                    ,
p_movi_grav5_mmnn                     ,
p_movi_iva10_mone                     ,
p_movi_iva5_mone                      ,
p_movi_iva10_mmnn                     ,
p_movi_iva5_mmnn                      ,
p_movi_nota_devu_codi                 ,
p_movi_info_codi                      ,
p_movi_clpr_sucu_nume_item            ,
p_movi_viaj_codi                      ,
p_movi_zara_codi                      ,
p_movi_turn_codi                      ,
p_movi_cuen_codi_reca                 ,
p_movi_clpr_situ                      ,
p_movi_clpr_empl_codi_recl            ,
p_movi_indi_impr                      ,
p_movi_clpr_sucu_nume_item_or         ,
p_movi_clpr_codi_orig                 ,
p_movi_inve_codi                      ,
p_movi_tacu_comi                      ,
p_movi_tacu_iva                       ,
p_movi_tacu_rete_rent                 ,
p_movi_tacu_iva_rete_rent             ,
p_movi_impo_inte_mone                 ,
p_movi_impo_inte_mmnn                 ,
p_movi_soco_codi_ante                 ,
p_movi_soco_oper                      ,
p_movi_soco_clpr_codi_ante            ,
p_movi_indi_outl                      ,
p_movi_apci_codi                      ,
p_movi_tasa_mone_pres_banc            ,
p_movi_indi_diar                      ,
p_movi_nume_soli                      ,
p_movi_nume_come                      ,
p_movi_indi_cant_diar                 ,
p_movi_indi_most_fech                 ,
p_movi_nume_plan                      ,
p_movi_indi_veri_fech                 ,
p_movi_indi_esta                      ,
p_movi_sopr_codi                                      
  );

end pp_insert_come_movi;
procedure pp_actualiza_come_movi is     
  
v_movi_codi                           number(20);
v_movi_timo_codi                      number(10);
v_movi_clpr_codi                      number(20);
v_movi_sucu_codi_orig                 number(10);
v_movi_depo_codi_orig                 number(10);
v_movi_sucu_codi_dest                 number(10);
v_movi_depo_codi_dest                 number(10);
v_movi_oper_codi                      number(10);
v_movi_cuen_codi                      number(4);
v_movi_mone_codi                      number(4);
v_movi_nume                           number(20);
v_movi_fech_emis                      date;
v_movi_fech_grab                      date;
v_movi_user                           varchar2(20);
v_movi_codi_padr                      number(20);
v_movi_tasa_mone                      number(20,4);
v_movi_tasa_mmee                      number(20,4);
v_movi_grav_mmnn                      number(20,4);
v_movi_exen_mmnn                      number(20,4);
v_movi_iva_mmnn                       number(20,4);
v_movi_grav_mmee                      number(20,4);
v_movi_exen_mmee                      number(20,4);
v_movi_iva_mmee                       number(20,4);
v_movi_grav_mone                      number(20,4);
v_movi_exen_mone                      number(20,4);
v_movi_iva_mone                       number(20,4);
v_movi_obse                           varchar2(2000);
v_movi_sald_mmnn                      number(20,4);
v_movi_sald_mmee                      number(20,4);
v_movi_sald_mone                      number(20,4);
v_movi_stoc_suma_rest                 varchar2(1);
v_movi_clpr_dire                      varchar2(100);
v_movi_clpr_tele                      varchar2(50);
v_movi_clpr_ruc                       varchar2(20);
v_movi_clpr_desc                      varchar2(80);
v_movi_emit_reci                      varchar2(1);
v_movi_afec_sald                      varchar2(1);
v_movi_dbcr                           varchar2(1);
v_movi_stoc_afec_cost_prom            varchar2(1);
v_movi_empr_codi                      number(2);
v_movi_clave_orig                     number(20);
v_movi_clave_orig_padr                number(20);
v_movi_indi_iva_incl                  varchar2(1);
v_movi_empl_codi                      number(10);
v_movi_obse_deta                      varchar2(500);
v_movi_base                           number(2);
v_movi_ortr_codi                      number(20);
v_movi_codi_padr_vali                 number(20);
v_movi_rrhh_movi_codi                 number(20);
v_movi_asie_codi                      number(10);
v_movi_orpa_codi                      number(20);
v_movi_impo_codi                      number(20);
v_movi_indi_conta                     varchar2(1);
v_movi_nume_timb                      varchar2(20);
v_movi_excl_cont                      varchar2(1);
v_movi_impo_dife_camb                 number(20,4);
v_movi_mone_codi_liqu                 number(20,4);
v_movi_mone_liqu                      number(20,4);
v_movi_tasa_mone_liqu                 number(20,4);
v_movi_impo_mone_liqu                 number(20,4);
v_movi_codi_rete                      number(20);
v_movi_orpe_codi                      number(20);
v_movi_cons_codi                      number(10);
v_movi_indi_inte                      varchar2(1);
v_movi_indi_deve_gene                 varchar2(1);
v_movi_fech_oper                      date;
v_movi_fech_venc_timb                 date;
v_movi_orpe_codi_loca                 number(20);
v_movi_impo_reca                      number(20,4);
v_movi_fech_inic_tras                 date;
v_movi_fech_term_tras                 date;
v_movi_tran_codi                      number(4);
v_movi_vehi_marc                      varchar2(50);
v_movi_vehi_chap                      varchar2(20);
v_movi_cont_tran_nomb                 varchar2(100);
v_movi_cont_tran_ruc                  varchar2(20);
v_movi_cond_empl_codi                 number(10);
v_movi_cond_nomb                      varchar2(100);
v_movi_cond_cedu_nume                 varchar2(20);
v_movi_cond_dire                      varchar2(200);
v_movi_sucu_codi_movi                 number(10);
v_movi_depo_codi_movi                 number(10);
v_movi_impo_deto                      number(20,4);
v_movi_orte_codi                      number(10);
v_movi_cheq_indi_desc                 varchar2(1);
v_movi_indi_liqu_tarj                 varchar2(1);
v_movi_impo_deto_mone                 number(20,4);
v_movi_tiva_codi                      number(10);
v_movi_serv_movi_codi                 number(20);
v_movi_serv_sald_mone                 number(20,4);
v_movi_serv_sald_mmnn                 number(20,4);
v_movi_soco_codi                      number(20);
v_movi_inmu_codi                      number(10);
v_movi_indi_expe_proc                 varchar2(1);
v_movi_liqu_codi                      number(20);
v_movi_liqu_codi_expe                 number(10);
v_movi_vale_indi_impo                 varchar2(1);
v_movi_form_entr_codi                 number(10);
v_movi_indi_tipo_pres                 varchar2(2);
v_movi_soma_codi                      number(20);
v_movi_sub_clpr_codi                  number(20);
v_movi_sode_codi                      number(20);
v_movi_aqui_pago_codi                 number(20);
v_movi_indi_entr_depo                 varchar2(1);
v_movi_user_entr_depo                 varchar2(20);
v_movi_fech_entr_depo                 date;
v_movi_indi_cobr_dife                 varchar2(1);
v_movi_livi_codi                      number(20);
v_movi_zara_tipo                      varchar2(1);
v_movi_impo_mone_ii                   number(20,4);
v_movi_impo_mmnn_ii                   number(20,4);
v_movi_clas_codi                      number(10);
v_movi_fact_codi                      number(20);
v_movi_grav10_ii_mone                 number(20,4);
v_movi_grav5_ii_mone                  number(20,4);
v_movi_grav10_ii_mmnn                 number(20,4);
v_movi_grav5_ii_mmnn                  number(20,4);
v_movi_grav10_mone                    number(20,4);
v_movi_grav5_mone                     number(20,4);
v_movi_grav10_mmnn                    number(20,4);
v_movi_grav5_mmnn                     number(20,4);
v_movi_iva10_mone                     number(20,4);
v_movi_iva5_mone                      number(20,4);
v_movi_iva10_mmnn                     number(20,4);
v_movi_iva5_mmnn                      number(20,4);
v_movi_nota_devu_codi                 number(20);
v_movi_info_codi                      number(20);
v_movi_clpr_sucu_nume_item            number(20);
v_movi_viaj_codi                      number(20);
v_movi_zara_codi                      number(20);
v_movi_turn_codi                      number(20);
v_movi_cuen_codi_reca                 number(4);
v_movi_clpr_situ                      number(10);
v_movi_clpr_empl_codi_recl            number(10);
v_movi_indi_impr                      varchar2(2);
v_movi_clpr_sucu_nume_item_or         number(20);
v_movi_clpr_codi_orig                 number(20);
v_movi_inve_codi                      number(10);
v_movi_tacu_comi                      number(20,4);
v_movi_tacu_iva                       number(20,4);
v_movi_tacu_rete_rent                 number(20,4);
v_movi_tacu_iva_rete_rent             number(20,4);
v_movi_impo_inte_mone                 number(20,4);
v_movi_impo_inte_mmnn                 number(20,4);
v_movi_soco_codi_ante                 number(20);
v_movi_soco_oper                      varchar2(2);
v_movi_soco_clpr_codi_ante            number(20);
v_movi_indi_outl                      varchar2(1);
v_movi_apci_codi                      number(20);
v_movi_tasa_mone_pres_banc            number(20,4);
v_movi_indi_diar                      varchar2(1);
v_movi_nume_soli                      number(20);
v_movi_nume_come                      number(20);
v_movi_indi_cant_diar                 varchar2(1);
v_movi_indi_most_fech                 varchar2(1);
v_movi_nume_plan                      number(20);
v_movi_indi_veri_fech                 varchar2(1);
v_movi_indi_esta                      varchar2(1);
v_movi_sopr_codi                      number(10);


--variables para come_movi_conc_deta
v_moco_movi_codi                  number(20);
v_moco_nume_item                  number(10);
v_moco_conc_codi                  number(10);
v_moco_cuco_codi                  number(10);
v_moco_impu_codi                  number(10);
v_moco_impo_mmnn                  number(20,4);
v_moco_impo_mmee                  number(20,4);
v_moco_impo_mone                  number(20,4);
v_moco_dbcr                       varchar2(1);
v_moco_base                       number(2);
v_moco_desc                       varchar2(2000);
v_moco_tiim_codi                  number(10);
v_moco_indi_fact_serv             varchar2(1);
v_moco_impo_mone_ii               number(20,4);
v_moco_cant                       number(20,4);
v_moco_cant_pulg                  number(20,4);
v_moco_ortr_codi                  number(20);
v_moco_movi_codi_padr             number(20);
v_moco_nume_item_padr             number(10);
v_moco_impo_codi                  number(20);
v_moco_ceco_codi                  number(20);
v_moco_orse_codi                  number(20);
v_moco_tran_codi                  number(20);
v_moco_bien_codi                  number(20);
v_moco_tipo_item                  varchar2(2);
v_moco_clpr_codi                  number(20);
v_moco_prod_nume_item             number(20);
v_moco_guia_nume                  number(20);
v_moco_emse_codi                  number(4);
v_moco_impo_mmnn_ii               number(20,4);
v_moco_grav10_ii_mone             number(20,4);
v_moco_grav5_ii_mone              number(20,4);
v_moco_grav10_ii_mmnn             number(20,4);
v_moco_grav5_ii_mmnn              number(20,4);
v_moco_grav10_mone                number(20,4);
v_moco_grav5_mone                 number(20,4);
v_moco_grav10_mmnn                number(20,4);
v_moco_grav5_mmnn                 number(20,4);
v_moco_iva10_mone                 number(20,4);
v_moco_iva5_mone                  number(20,4);
v_moco_conc_codi_impu             number(10);
v_moco_tipo                       varchar2(2);
v_moco_prod_codi                  number(20);
v_moco_ortr_codi_fact             number(20);
v_moco_iva10_mmnn                 number(20,4);
v_moco_iva5_mmnn                  number(20,4);
v_moco_sofa_sose_codi             number(20);
v_moco_sofa_nume_item             number(20);
v_moco_exen_mone                  number(20,4);
v_moco_exen_mmnn                  number(20,4);
v_moco_empl_codi                  number(10);
v_moco_anex_codi                  number(20);
v_moco_lote_codi                  number(10);
v_moco_bene_codi                  number(4);
v_moco_medi_codi                  number(10);
v_moco_cant_medi                  number(20,4);
v_moco_indi_excl_cont             varchar2(1);
v_moco_anex_nume_item             number(10);
v_moco_juri_codi                  number(20);
v_moco_impo_diar_mone             number(20,4);
v_moco_coib_codi                  number(20);
v_moco_sucu_codi                  number(10);
--variables para come_movi_impo_deta
v_moim_movi_codi                    number(20);
v_moim_nume_item                    number(4);
v_moim_tipo                         varchar2(20);
v_moim_cuen_codi                    number(4);
v_moim_dbcr                         varchar2(1);
v_moim_afec_caja                    varchar2(1);
v_moim_fech                         date;
v_moim_impo_mone                    number(20,4);
v_moim_impo_mmnn                    number(20,4);
v_moim_base                         number(2);
v_moim_cheq_codi                    number(20);
v_moim_caja_codi                    number(20);
v_moim_impo_mmee                    number(20,4);
v_moim_asie_codi                    number(20);
v_moim_fech_oper                    date;
v_moim_tarj_cupo_codi               number(20);
v_moim_movi_codi_vale               number(20);
v_moim_form_pago                    number(10);
v_moim_fech_orig                    date;
v_moim_fech_conc                    date;
v_moim_user_conc                    varchar2(20);
v_moim_indi_conc                    varchar2(1);
v_moim_obse_conc                    varchar2(200);
v_moim_conc_codi                    number(20);
v_moim_colo_conc                    varchar2(1);
v_moim_viaj_codi                    number(20);
v_moim_obse                         varchar2(200);
v_moim_impo_movi                    number(20,4);
v_moim_tasa_mone                    number(20,4);
v_moim_user_regi                    varchar2(20);
v_moim_fech_regi                    date;
v_moim_indi_impo_igua               varchar2(1); 


v_cont number(10);
v_impo_porc_dist_mmnn number(20,4);
v_suma_impo_dist_mmnn number(20,4);

v_impo_porc_dist_mone number(20,4);
v_suma_impo_dist_mone number(20,4);


cursor c_emsu(p_empl_codi number) is
      select emsu_sucu_codi,
             emsu_porc_dist
      from come_empl_sucu
      where emsu_empl_codi = p_empl_codi
      and emsu_porc_dist > 0;

 
begin

  

      ---VARIABLES PARA COME_MOVI     
      bcab.come_movi_codi              := fa_sec_come_movi;      
      v_movi_codi                       := bcab.come_movi_codi;  
      if bcab.conc_dbcr = 'C' then
      v_movi_timo_codi                  := parameter.p_codi_timo_vari_cred;
      else
      v_movi_timo_codi                  := parameter.p_codi_timo_vari_debi;
      end if;         
      v_movi_clpr_codi                  := null;
      v_movi_sucu_codi_orig             := bcab.movi_sucu_codi_orig;
      v_movi_depo_codi_orig             := null;
      v_movi_sucu_codi_dest             := null;
      v_movi_depo_codi_dest             := null;
      v_movi_oper_codi                  := null;
      v_movi_cuen_codi                  := bcab.cuen_codi;
      v_movi_mone_codi                  := bcab.movi_mone_codi;
      v_movi_nume                       := bcab.movi_nume;
      v_movi_fech_emis                  := bcab.movi_fech_caja;
      v_movi_fech_grab                  := sysdate;
      v_movi_user                       := gen_user;
      v_movi_codi_padr                  := null;
      v_movi_tasa_mone                  := bcab.movi_tasa_mone;
      v_movi_tasa_mmee                  := null;
      v_movi_grav_mmnn                  := 0;
      v_movi_exen_mmnn                  := round((bcab.movi_impo_mone*bcab.movi_tasa_mone),parameter.p_cant_deci_mmnn);
      v_movi_iva_mmnn                   := 0;
      v_movi_grav_mmee                  := 0;
      v_movi_exen_mmee                  := 0;
      v_movi_iva_mmee                   := 0;
      v_movi_grav_mone                  := 0;
      v_movi_exen_mone                  := bcab.movi_impo_mone;
      v_movi_iva_mone                   := 0;
      v_movi_obse                       := bcab.movi_obse;
      v_movi_sald_mmnn                  := 0;
      v_movi_sald_mmee                  := 0;
      v_movi_sald_mone                  := 0;
      v_movi_stoc_suma_rest             := null;
      v_movi_clpr_dire                  := null;
      v_movi_clpr_tele                  := null;
      v_movi_clpr_ruc                   := null;
      v_movi_clpr_desc                  := null;
      v_movi_emit_reci                  := 'E'; --emitido
      v_movi_afec_sald                  := 'N';
      v_movi_dbcr                       := bcab.conc_dbcr; --siempre va a ser un Credito...
      v_movi_stoc_afec_cost_prom        := null;
      v_movi_empr_codi                  := null;
      v_movi_clave_orig                 := null;
      v_movi_clave_orig_padr            := null;
      v_movi_indi_iva_incl              := null;
      v_movi_empl_codi                  := bcab.empl_codi;
      v_movi_rrhh_movi_codi             := bcab.movi_codi;
      v_movi_grav10_ii_mone                 := 0;
      v_movi_grav5_ii_mone                  := 0;
      v_movi_grav10_ii_mmnn                 := 0;
      v_movi_grav5_ii_mmnn                  := 0;
      v_movi_grav10_mone                    := 0;
      v_movi_grav5_mone                     := 0;
      v_movi_grav10_mmnn                    := 0;
      v_movi_grav5_mmnn                     := 0;
      v_movi_iva10_mone                     := 0;
      v_movi_iva5_mone                      := 0;
      v_movi_iva10_mmnn                     := 0;
      v_movi_iva5_mmnn                      := 0;     
      v_movi_impo_mone_ii                   := v_movi_exen_mone;
      v_movi_impo_mmnn_ii                   := v_movi_Exen_mmnn;
      
      --variables para come_movi_conc_Deta
      v_moco_conc_codi                  := bcab.conc_come_codi;
      v_moco_dbcr                       := bcab.conc_dbcr;
      v_moco_movi_codi                  := v_movi_codi;
      v_moco_nume_item                  := null;       
      v_moco_cuco_codi                  := null;
      v_moco_impu_codi                  := parameter.p_codi_impu_exen;
      v_moco_impo_mmnn                  := v_movi_exen_mmnn;
      v_moco_impo_mmee                  := 0;
      v_moco_impo_mone                  := v_movi_exen_mone;     
      v_moco_base                       := 1;
      v_moco_desc                       := null;
      v_moco_tiim_codi                  := 1;
      v_moco_indi_fact_serv             := null;
      v_moco_impo_mone_ii               := v_movi_exen_mone;
      v_moco_cant                       := null;
      v_moco_cant_pulg                  := null;
      v_moco_ortr_codi                  := null;
      v_moco_movi_codi_padr             := null;
      v_moco_nume_item_padr             := null;
      v_moco_impo_codi                  := null;
      v_moco_ceco_codi                  := null;
      v_moco_orse_codi                  := null;
      v_moco_tran_codi                  := null;
      v_moco_bien_codi                  := null;
      v_moco_tipo_item                  := null;
      v_moco_clpr_codi                  := null;
      v_moco_prod_nume_item             := null;
      v_moco_guia_nume                  := null;
      v_moco_emse_codi                  := null;
      v_moco_impo_mmnn_ii               := v_movi_Exen_mmnn;
      v_moco_grav10_ii_mone             := 0;
      v_moco_grav5_ii_mone              := 0;
      v_moco_grav10_ii_mmnn             := 0;
      v_moco_grav5_ii_mmnn              := 0;
      v_moco_grav10_mone                := 0;
      v_moco_grav5_mone                 := 0;
      v_moco_grav10_mmnn                := 0;
      v_moco_grav5_mmnn                 := 0;
      v_moco_iva10_mone                 := 0;
      v_moco_iva5_mone                  := 0;
      v_moco_conc_codi_impu             := null;
      v_moco_tipo                       := null;
      v_moco_prod_codi                  := null;
      v_moco_ortr_codi_fact             := null;
      v_moco_iva10_mmnn                 := 0;
      v_moco_iva5_mmnn                  := 0;
      v_moco_sofa_sose_codi             := null;
      v_moco_sofa_nume_item             := null;
      v_moco_exen_mone                  := v_movi_exen_mone;
      v_moco_exen_mmnn                  := v_movi_exen_mmnn;
      v_moco_empl_codi                  := null;
      v_moco_anex_codi                  := null;
      v_moco_lote_codi                  := null;
      v_moco_bene_codi                  := null;
      v_moco_medi_codi                  := null;
      v_moco_cant_medi                  := null;
      v_moco_indi_excl_cont             := null;
      v_moco_anex_nume_item             := null;
      v_moco_juri_codi                  := null;
      v_moco_impo_diar_mone             := null;
      v_moco_coib_codi                  := null;
      
      v_moim_nume_item                    := 0;
      v_moim_movi_codi                    := v_movi_codi;
      v_moim_nume_item                    := v_moim_nume_item + 1;
      v_moim_tipo                         := 'Efectivo';
      v_moim_cuen_codi                    := bcab.cuen_codi;        
      v_moim_dbcr                         := bcab.conc_dbcr; 
      v_moim_afec_caja                    := 'S'; 
      v_moim_fech                         := bcab.movi_fech_caja;
      v_moim_impo_mone                    := v_movi_exen_mone;
      v_moim_impo_mmnn                    := round(v_movi_exen_mmnn,0);            
      v_moim_base                         := 1;
      v_moim_cheq_codi                    := null;
      v_moim_caja_codi                    := null;
      v_moim_impo_mmee                    := null;
      v_moim_asie_codi                    := null;
      v_moim_fech_oper                    := bcab.movi_fech_caja;
      v_moim_tarj_cupo_codi               := null;
      v_moim_movi_codi_vale               := null;
      v_moim_form_pago                    := null;
      v_moim_fech_orig                    := null;
      v_moim_fech_conc                    := null;
      v_moim_user_conc                    := null;
      v_moim_indi_conc                    := null;
      v_moim_obse_conc                    := null;
      v_moim_conc_codi                    := null;
      v_moim_colo_conc                    := null;
      v_moim_viaj_codi                    := null;
      v_moim_obse                         := null;
      v_moim_impo_movi                    := v_movi_Exen_mone;
      v_moim_tasa_mone                    := 1;
      v_moim_user_regi                    := gen_user;
      v_moim_fech_regi                    := sysdate;
      v_moim_indi_impo_igua               := null;
      
      
       pp_insert_come_movi (v_movi_codi                           ,
                            v_movi_timo_codi                      ,
                            v_movi_clpr_codi                      ,
                            v_movi_sucu_codi_orig                 ,
                            v_movi_depo_codi_orig                 ,
                            v_movi_sucu_codi_dest                 ,
                            v_movi_depo_codi_dest                 ,
                            v_movi_oper_codi                      ,
                            v_movi_cuen_codi                      ,
                            v_movi_mone_codi                      ,
                            v_movi_nume                           ,
                            v_movi_fech_emis                      ,
                            v_movi_fech_grab                      ,
                            v_movi_user                           ,
                            v_movi_codi_padr                      ,
                            v_movi_tasa_mone                      ,
                            v_movi_tasa_mmee                      ,
                            v_movi_grav_mmnn                      ,
                            v_movi_exen_mmnn                      ,
                            v_movi_iva_mmnn                       ,
                            v_movi_grav_mmee                      ,
                            v_movi_exen_mmee                      ,
                            v_movi_iva_mmee                       ,
                            v_movi_grav_mone                      ,
                            v_movi_exen_mone                      ,
                            v_movi_iva_mone                       ,
                            v_movi_obse                           ,
                            v_movi_sald_mmnn                      ,
                            v_movi_sald_mmee                      ,
                            v_movi_sald_mone                      ,
                            v_movi_stoc_suma_rest                 ,
                            v_movi_clpr_dire                      ,
                            v_movi_clpr_tele                      ,
                            v_movi_clpr_ruc                       ,
                            v_movi_clpr_desc                      ,
                            v_movi_emit_reci                      ,
                            v_movi_afec_sald                      ,
                            v_movi_dbcr                           ,
                            v_movi_stoc_afec_cost_prom            ,
                            v_movi_empr_codi                      ,
                            v_movi_clave_orig                     ,
                            v_movi_clave_orig_padr                ,
                            v_movi_indi_iva_incl                  ,
                            v_movi_empl_codi                      ,
                            v_movi_obse_deta                      ,
                            v_movi_base                           ,
                            v_movi_ortr_codi                      ,
                            v_movi_codi_padr_vali                 ,
                            v_movi_rrhh_movi_codi                 ,
                            v_movi_asie_codi                      ,
                            v_movi_orpa_codi                      ,
                            v_movi_impo_codi                      ,
                            v_movi_indi_conta                     ,
                            v_movi_nume_timb                      ,
                            v_movi_excl_cont                      ,
                            v_movi_impo_dife_camb                 ,
                            v_movi_mone_codi_liqu                 ,
                            v_movi_mone_liqu                      ,
                            v_movi_tasa_mone_liqu                 ,
                            v_movi_impo_mone_liqu                 ,
                            v_movi_codi_rete                      ,
                            v_movi_orpe_codi                      ,
                            v_movi_cons_codi                      ,
                            v_movi_indi_inte                      ,
                            v_movi_indi_deve_gene                 ,
                            v_movi_fech_oper                      ,
                            v_movi_fech_venc_timb                 ,
                            v_movi_orpe_codi_loca                 ,
                            v_movi_impo_reca                      ,
                            v_movi_fech_inic_tras                 ,
                            v_movi_fech_term_tras                 ,
                            v_movi_tran_codi                      ,
                            v_movi_vehi_marc                      ,
                            v_movi_vehi_chap                      ,
                            v_movi_cont_tran_nomb                 ,
                            v_movi_cont_tran_ruc                  ,
                            v_movi_cond_empl_codi                 ,
                            v_movi_cond_nomb                      ,
                            v_movi_cond_cedu_nume                 ,
                            v_movi_cond_dire                      ,
                            v_movi_sucu_codi_movi                 ,
                            v_movi_depo_codi_movi                 ,
                            v_movi_impo_deto                      ,
                            v_movi_orte_codi                      ,
                            v_movi_cheq_indi_desc                 ,
                            v_movi_indi_liqu_tarj                 ,
                            v_movi_impo_deto_mone                 ,
                            v_movi_tiva_codi                      ,
                            v_movi_serv_movi_codi                 ,
                            v_movi_serv_sald_mone                 ,
                            v_movi_serv_sald_mmnn                 ,
                            v_movi_soco_codi                      ,
                            v_movi_inmu_codi                      ,
                            v_movi_indi_expe_proc                 ,
                            v_movi_liqu_codi                      ,
                            v_movi_liqu_codi_expe                 ,
                            v_movi_vale_indi_impo                 ,
                            v_movi_form_entr_codi                 ,
                            v_movi_indi_tipo_pres                 ,
                            v_movi_soma_codi                      ,
                            v_movi_sub_clpr_codi                  ,
                            v_movi_sode_codi                      ,
                            v_movi_aqui_pago_codi                 ,
                            v_movi_indi_entr_depo                 ,
                            v_movi_user_entr_depo                 ,
                            v_movi_fech_entr_depo                 ,
                            v_movi_indi_cobr_dife                 ,
                            v_movi_livi_codi                      ,
                            v_movi_zara_tipo                      ,
                            v_movi_impo_mone_ii                   ,
                            v_movi_impo_mmnn_ii                   ,
                            v_movi_clas_codi                      ,
                            v_movi_fact_codi                      ,
                            v_movi_grav10_ii_mone                 ,
                            v_movi_grav5_ii_mone                  ,
                            v_movi_grav10_ii_mmnn                 ,
                            v_movi_grav5_ii_mmnn                  ,
                            v_movi_grav10_mone                    ,
                            v_movi_grav5_mone                     ,
                            v_movi_grav10_mmnn                    ,
                            v_movi_grav5_mmnn                     ,
                            v_movi_iva10_mone                     ,
                            v_movi_iva5_mone                      ,
                            v_movi_iva10_mmnn                     ,
                            v_movi_iva5_mmnn                      ,
                            v_movi_nota_devu_codi                 ,
                            v_movi_info_codi                      ,
                            v_movi_clpr_sucu_nume_item            ,
                            v_movi_viaj_codi                      ,
                            v_movi_zara_codi                      ,
                            v_movi_turn_codi                      ,
                            v_movi_cuen_codi_reca                 ,
                            v_movi_clpr_situ                      ,
                            v_movi_clpr_empl_codi_recl            ,
                            v_movi_indi_impr                      ,
                            v_movi_clpr_sucu_nume_item_or         ,
                            v_movi_clpr_codi_orig                 ,
                            v_movi_inve_codi                      ,
                            v_movi_tacu_comi                      ,
                            v_movi_tacu_iva                       ,
                            v_movi_tacu_rete_rent                 ,
                            v_movi_tacu_iva_rete_rent             ,
                            v_movi_impo_inte_mone                 ,
                            v_movi_impo_inte_mmnn                 ,
                            v_movi_soco_codi_ante                 ,
                            v_movi_soco_oper                      ,
                            v_movi_soco_clpr_codi_ante            ,
                            v_movi_indi_outl                      ,
                            v_movi_apci_codi                      ,
                            v_movi_tasa_mone_pres_banc            ,
                            v_movi_indi_diar                      ,
                            v_movi_nume_soli                      ,
                            v_movi_nume_come                      ,
                            v_movi_indi_cant_diar                 ,
                            v_movi_indi_most_fech                 ,
                            v_movi_nume_plan                      ,
                            v_movi_indi_veri_fech                 ,
                            v_movi_indi_esta                      ,
                            v_movi_sopr_codi                       );
      
    
    select count(*)
      into v_cont
      from come_empl_sucu
      where emsu_empl_codi = v_movi_empl_codi
      and emsu_porc_dist > 0;
      
      if v_cont > 1 then
        
        for x in c_emsu(v_movi_empl_codi) loop
          
          v_moco_nume_item  := nvl(v_moco_nume_item,0) + 1;
          v_impo_porc_dist_mmnn := round(v_movi_exen_mmnn * x.emsu_porc_dist /100, 0);
          v_impo_porc_dist_mone := round(v_movi_exen_mone * x.emsu_porc_dist /100, 0);
          
          
        --  pl_mm('arm v_cont '||v_cont||' v_moco_nume_item '||v_moco_nume_item);
          
          if v_cont = v_moco_nume_item then
            
            --pl_mm('arm v_movi_exen_mmnn '||v_movi_exen_mmnn||' v_suma_impo_dist '||v_suma_impo_dist);
            v_impo_porc_dist_mmnn := v_movi_exen_mmnn - v_suma_impo_dist_mmnn;
            v_impo_porc_dist_mone := v_movi_exen_mone - v_suma_impo_dist_mone;
          end if; 
          
          v_suma_impo_dist_mmnn := nvl(v_suma_impo_dist_mmnn,0) + v_impo_porc_dist_mmnn;
          v_suma_impo_dist_mone := nvl(v_suma_impo_dist_mone,0) + v_impo_porc_dist_mone;
        
          v_moco_sucu_codi := x.emsu_sucu_codi;
          v_moco_exen_mmnn  := v_impo_porc_dist_mmnn;
          v_moco_exen_mone  := v_impo_porc_dist_mone;
          
          v_moco_impo_mmnn  := v_moco_exen_mmnn;
          v_moco_impo_mone  := v_moco_exen_mone;
          v_moco_impo_mone_ii  := v_moco_exen_mone;
          v_moco_impo_mmnn_ii  := v_moco_Exen_mmnn;
          
      
           pp_insert_movi_conc_deta(v_moco_movi_codi                  ,
                                    v_moco_nume_item                  ,
                                    v_moco_conc_codi                  ,
                                    v_moco_cuco_codi                  ,
                                    v_moco_impu_codi                  ,
                                    v_moco_impo_mmnn                  ,
                                    v_moco_impo_mmee                  ,
                                    v_moco_impo_mone                  ,
                                    v_moco_dbcr                       ,
                                    v_moco_base                       ,
                                    v_moco_desc                       ,
                                    v_moco_tiim_codi                  ,
                                    v_moco_indi_fact_serv             ,
                                    v_moco_impo_mone_ii               ,
                                    v_moco_cant                       ,
                                    v_moco_cant_pulg                  ,
                                    v_moco_ortr_codi                  ,
                                    v_moco_movi_codi_padr             ,
                                    v_moco_nume_item_padr             ,
                                    v_moco_impo_codi                  ,
                                    v_moco_ceco_codi                  ,
                                    v_moco_orse_codi                  ,
                                    v_moco_tran_codi                  ,
                                    v_moco_bien_codi                  ,
                                    v_moco_tipo_item                  ,
                                    v_moco_clpr_codi                  ,
                                    v_moco_prod_nume_item             ,
                                    v_moco_guia_nume                  ,
                                    v_moco_emse_codi                  ,
                                    v_moco_impo_mmnn_ii               ,
                                    v_moco_grav10_ii_mone             ,
                                    v_moco_grav5_ii_mone              ,
                                    v_moco_grav10_ii_mmnn             ,
                                    v_moco_grav5_ii_mmnn              ,
                                    v_moco_grav10_mone                ,
                                    v_moco_grav5_mone                 ,
                                    v_moco_grav10_mmnn                ,
                                    v_moco_grav5_mmnn                 ,
                                    v_moco_iva10_mone                 ,
                                    v_moco_iva5_mone                  ,
                                    v_moco_conc_codi_impu             ,
                                    v_moco_tipo                       ,
                                    v_moco_prod_codi                  ,
                                    v_moco_ortr_codi_fact             ,
                                    v_moco_iva10_mmnn                 ,
                                    v_moco_iva5_mmnn                  ,
                                    v_moco_sofa_sose_codi             ,
                                    v_moco_sofa_nume_item             ,
                                    v_moco_exen_mone                  ,
                                    v_moco_exen_mmnn                  ,
                                    v_moco_empl_codi                  ,
                                    v_moco_anex_codi                  ,
                                    v_moco_lote_codi                  ,
                                    v_moco_bene_codi                  ,
                                    v_moco_medi_codi                  ,
                                    v_moco_cant_medi                  ,
                                    v_moco_indi_excl_cont             ,
                                    v_moco_anex_nume_item             ,
                                    v_moco_juri_codi                  ,
                                    v_moco_impo_diar_mone             ,
                                    v_moco_coib_codi                  ,
                                    v_moco_sucu_codi
                                    );  
      
          end loop;         

      else
        
        v_moco_nume_item  := nvl(v_moco_nume_item,0) + 1;
        
        
       pp_insert_movi_conc_deta(v_moco_movi_codi                  ,
                                v_moco_nume_item                  ,
                                v_moco_conc_codi                  ,
                                v_moco_cuco_codi                  ,
                                v_moco_impu_codi                  ,
                                v_moco_impo_mmnn                  ,
                                v_moco_impo_mmee                  ,
                                v_moco_impo_mone                  ,
                                v_moco_dbcr                       ,
                                v_moco_base                       ,
                                v_moco_desc                       ,
                                v_moco_tiim_codi                  ,
                                v_moco_indi_fact_serv             ,
                                v_moco_impo_mone_ii               ,
                                v_moco_cant                       ,
                                v_moco_cant_pulg                  ,
                                v_moco_ortr_codi                  ,
                                v_moco_movi_codi_padr             ,
                                v_moco_nume_item_padr             ,
                                v_moco_impo_codi                  ,
                                v_moco_ceco_codi                  ,
                                v_moco_orse_codi                  ,
                                v_moco_tran_codi                  ,
                                v_moco_bien_codi                  ,
                                v_moco_tipo_item                  ,
                                v_moco_clpr_codi                  ,
                                v_moco_prod_nume_item             ,
                                v_moco_guia_nume                  ,
                                v_moco_emse_codi                  ,
                                v_moco_impo_mmnn_ii               ,
                                v_moco_grav10_ii_mone             ,
                                v_moco_grav5_ii_mone              ,
                                v_moco_grav10_ii_mmnn             ,
                                v_moco_grav5_ii_mmnn              ,
                                v_moco_grav10_mone                ,
                                v_moco_grav5_mone                 ,
                                v_moco_grav10_mmnn                ,
                                v_moco_grav5_mmnn                 ,
                                v_moco_iva10_mone                 ,
                                v_moco_iva5_mone                  ,
                                v_moco_conc_codi_impu             ,
                                v_moco_tipo                       ,
                                v_moco_prod_codi                  ,
                                v_moco_ortr_codi_fact             ,
                                v_moco_iva10_mmnn                 ,
                                v_moco_iva5_mmnn                  ,
                                v_moco_sofa_sose_codi             ,
                                v_moco_sofa_nume_item             ,
                                v_moco_exen_mone                  ,
                                v_moco_exen_mmnn                  ,
                                v_moco_empl_codi                  ,
                                v_moco_anex_codi                  ,
                                v_moco_lote_codi                  ,
                                v_moco_bene_codi                  ,
                                v_moco_medi_codi                  ,
                                v_moco_cant_medi                  ,
                                v_moco_indi_excl_cont             ,
                                v_moco_anex_nume_item             ,
                                v_moco_juri_codi                  ,
                                v_moco_impo_diar_mone             ,
                                v_moco_coib_codi                  ,
                                v_moco_sucu_codi
                                );  
      end if;                 
        
        
      pp_insert_come_movi_impo_deta (
      v_moim_movi_codi              , 
      v_moim_nume_item              ,
      v_moim_tipo                   ,
      v_moim_cuen_codi              ,
      v_moim_dbcr                   ,
      v_moim_afec_caja              ,
      v_moim_fech                   ,
      v_moim_impo_mone              ,
      v_moim_impo_mmnn              ,
      v_moim_base                   ,
      v_moim_cheq_codi              ,
      v_moim_caja_codi              ,
      v_moim_impo_mmee              ,
      v_moim_asie_codi              ,
      v_moim_fech_oper              ,
      v_moim_tarj_cupo_codi         ,
      v_moim_movi_codi_vale         ,
      v_moim_form_pago              ,
      v_moim_fech_orig              ,
      v_moim_fech_conc              ,
      v_moim_user_conc              ,
      v_moim_indi_conc              ,
      v_moim_obse_conc              ,
      v_moim_conc_codi              ,
      v_moim_colo_conc              ,
      v_moim_viaj_codi              ,
      v_moim_obse                   ,
      v_moim_impo_movi              ,
      v_moim_tasa_mone              ,
      v_moim_user_regi              ,
      v_moim_fech_regi              ,
      v_moim_indi_impo_igua         );         




end pp_actualiza_come_movi;

procedure pp_set_variable is
  v_bd varchar2(20);
  x_nuevo varchar2(32000);
begin
bcab.impo_unit_mone      :=v('P101_IMPO_UNIT_MONE');
bcab.conc_codi      :=v('P101_CONC_CODI');
bcab.empl_codi      :=v('P101_EMPL_CODI');
bcab.movi_mone_codi :=v('P101_MOVI_MONE_CODI');
bcab.movi_fech_emis :=v('P101_MOVI_FECH_EMIS');
bcab.movi_fech_grab :=v('P101_MOVI_FECH_GRAB');
bcab.movi_user      :=v('P101_MOVI_USER');
bcab.movi_impo_mone :=v('P101_MOVI_IMPO_MONE');
bcab.movi_impo_mmnn :=v('P101_MOVI_IMPO_MMNN');
bcab.movi_tasa_mone :=v('P101_MOVI_TASA_MONE');
bcab.conc_indi_cuot :=v('P101_CONC_INDI_CUOT');
bcab.movi_cond_pago :=v('P101_MOVI_COND_PAGO');
bcab.movi_nume      :=v('P101_MOVI_NUME');
bcab.movi_obse     :=v('P101_MOVI_OBSE');
bcab.movi_cant      :=v('P101_MOVI_CANT');

bcab.movi_mone_codi_liqu :=v('P101_MOVI_MONE_CODI_LIQU');
bcab.movi_tasa_mone_liqu :=v('P101_MOVI_TASA_MONE_LIQU');
bcab.movi_impo_mone_liqu :=v('P101_MOVI_IMPO_MONE_LIQU');
                  
bcab.movi_fech_caja      :=v('P101_MOVI_FECH_CAJA');
bcab.cuen_codi           :=v('P101_CUEN_CODI');
bcab.movi_sucu_codi_orig :=v('P101_MOVI_SUCU_CODI_ORIG');
bcab.conc_come_codi      :=v('P101_CONC_COME_CODI');
bcab.conc_indi_caja      :=v('P101_CONC_INDI_CAJA');

bcab.come_movi_codi       :=v('P101_COME_MOVI_CODI');
bcab.mone_cant_deci_liqu  :=v('P101_MONE_CANT_DECI_LIQU');

bcab.conc_dbcr            :=v('P101_CONC_DBCR');
bcab.perf_codi            :=v('P101_PERF_CODI');
   --raise_application_error(-20010,v('P101_MOVI_IMPO_MMNN')||' --'||v('P101_MOVI_TASA_MONE'));

end pp_set_variable;



procedure pp_actualizar_registro is
  v_Cant_cuotas number;
  begin
       pp_set_variable;
       
       
 if nvl(bcab.impo_unit_mone,0)  =0 then
	raise_application_error(-20010,'El importe no puede quedar vacio');
end if;       
   if bcab.movi_nume is null then
	raise_application_error(-20010,'El importe no puede ser igual a cero'||bcab.movi_tasa_mone_liqu);
end if;       
  

if nvl(bcab.movi_tasa_mone_liqu, 0) <= 0 then
	raise_application_error(-20010,'La cotizacion de la moneda de liquidacion debe ser mayor a cero'||bcab.movi_tasa_mone_liqu);
end if;    

if bcab.empl_codi  is null then 
  
raise_application_error(-20010,'Debe elegir el empleado');
end if;
if bcab.conc_codi is null then 
  
raise_application_error(-20010,'El concepto no puede quedar vacio');
end if;

 if  bcab.conc_indi_caja = 'S' then
   if  bcab.movi_fech_caja  is null then
     raise_application_error(-20010,'Fecha Afecta Caja no puede quedar vacia');
   
   
   end if;
   
   if bcab.cuen_codi  is null then
     raise_application_error(-20010,'La caja no puede quedar vacia');
   
   end if;
   
    pp_valida_fech_rrhh (bcab.movi_fech_caja  , 'B');
 end if;
   

if nvl(bcab.movi_cant,0) <=0 then    
  bcab.movi_cant := 1;     
end if;         

 if nvl(bcab.movi_tasa_mone, 0) <= 0 then
	raise_application_error(-20010,'La cotizacion de la moneda del movimiento debe ser mayor a cero');
end if;                  
if bcab.movi_tasa_mone_liqu is null then
pp_busca_tasa_mone(bcab.movi_mone_codi_liqu, bcab.movi_fech_emis, bcab.movi_tasa_mone_liqu);   
end if;


  pp_valida_fech_rrhh (bcab.movi_Fech_emis, 'A');
  
  if bcab.movi_mone_codi  is null then
     raise_application_error(-20010,'La moneda no puede quedar vacia');
  end if;
  
   if bcab.empl_codi   is null then
     raise_application_error(-20010,'Debe seleccionar un empleado');
  end if;
   if not(I020091.fp_vali_user_empl( bcab.perf_codi, bcab.empl_codi)) then
     raise_application_error(-20001,'El usuario no posee permiso para consultar el empleado seleccionado');
    end if;     
  if bcab.conc_indi_cuot = 'N' then  --debe generar una sola cuota con fecha de vencimiento igual a la fecha del documento
        begin
      -- Call the procedure
      I020091.pp_genera_cuota_auto(i_movi_impo_mone => bcab.movi_impo_mone,
                                   i_movi_Fech_emis => bcab.movi_Fech_emis,
                                   i_movi_impo_mmnn => bcab.movi_impo_mmnn,
                                   i_movi_impo_mone_liqu => bcab.movi_impo_mone_liqu,
                                   i_movi_tasa_mone       => bcab.movi_tasa_mone  ,  
                                   i_movi_tasa_mone_liqu   => bcab.movi_tasa_mone_liqu,
                                   i_mone_cant_deci_liqu   => bcab.mone_cant_deci_liqu);
    end;

	end if;

   select  count (seq_id)
   into v_Cant_cuotas
    from apex_collections
   where collection_name = 'CUOTA'; 
  	  
  if bcab.conc_indi_cuot = 'S' and v_Cant_cuotas = 0 then
    I020091.pp_genera_cuota_auto(i_movi_impo_mone          => bcab.movi_impo_mone,
                                 i_movi_Fech_emis          => bcab.movi_Fech_emis,
                                 i_movi_impo_mmnn          => bcab.movi_impo_mmnn,
                                 i_movi_impo_mone_liqu     => bcab.movi_impo_mone_liqu,
                                 i_movi_tasa_mone          => bcab.movi_tasa_mone  ,  
                                 i_movi_tasa_mone_liqu     => bcab.movi_tasa_mone_liqu,
                                 i_mone_cant_deci_liqu     => bcab.mone_cant_deci_liqu);
      -- raise_application_error(-20010,'Debe generar las cuotas');
  end if;

 -- pp_validar; ni al caso vuelve a definir el mismo valor

begin
  I020091.pp_validar_cuotas(i_movi_impo_mone => bcab.movi_impo_mone,
                               i_movi_Fech_emis => bcab.movi_Fech_emis,
                               i_movi_impo_mmnn => bcab.movi_impo_mmnn,
                               i_movi_impo_mone_liqu => bcab.movi_impo_mone_liqu);
end;

  
  if bcab.conc_indi_caja = 'S' then
    if bcab.conc_come_codi is null then
      raise_application_error(-20010,'El concepto no posee un concepto asociado');
    end if;
  end if;
     

--  if parameter.p_indi_validar = 'N' then
  pp_actualiza_rrhh_movi;
  
 if nvl(bcab.conc_indi_caja, 'N') = 'S' then
   	pp_actualiza_come_movi;    
  end if;
  
  I020091.pp_imprimir_reportes (i_movi_codi=> bcab.movi_codi);
/*
  
  if parameter.p_indi_impr_cheq_emit = 'S' then
    pp_impr_cheq_emit;
  end if;
    */
  
 
 --end if;
 apex_collection.create_or_truncate_collection(p_collection_name => 'CUOTA');
 
 
 --raise_application_Error(-20001,'hads');
end pp_actualizar_registro;

procedure pp_buscar_sucursal    (i_movi_sucu_codi_orig in number,
                                 o_movi_sucu_desc_orig out varchar2) is
  
begin
  
     select s.sucu_desc
      into o_movi_sucu_desc_orig
      from come_sucu s
     where s.sucu_codi = i_movi_sucu_codi_orig
       and s.sucu_empr_codi =parameter.p_empr_codi;
       
  exception
    when no_data_found then
     raise_application_error(-20001, 'Sucursal inexistente o no pertenece a la empresa');

 end pp_buscar_sucursal; 
 
procedure pp_buscar_concepto (i_conc_codi_alte in varchar2, 
                              o_conc_desc      out varchar2, 
                              o_conc_indi_cuot out varchar2, 
                              o_conc_indi_caja out varchar2, 
                              o_conc_dbcr      out varchar2, 
                              o_conc_come_codi out varchar2, 
                              o_conc_indi_cant out varchar2, 
                              o_conc_unit_medi out varchar2, 
                              o_conc_codi      out varchar2, 
                              o_conc_tipo_conc out varchar2,
                              o_movi_cant      out varchar2 ) is
   
 begin
 
   
  pp_muestra_rrhh_conc (i_conc_codi_alte, 
                        o_conc_desc, 
                        o_conc_indi_cuot, 
                        o_conc_indi_caja, 
                        o_conc_dbcr, 
                        o_conc_come_codi, 
                        o_conc_indi_cant, 
                        o_conc_unit_medi, 
                        o_conc_codi, 
                        o_conc_tipo_conc);  
 


  if nvl(o_conc_indi_caja, 'N') = 'S' then  
     if o_conc_come_codi is null then
        raise_application_error(-20001,'El concepto de rrhh no posee un concepto asociado de gestion');
     end if;      
  end if; 
  if o_conc_indi_cant  = 'N' then
     o_movi_cant := 1;     
  end if;

------------pp_hab_desh_cuot(o_conc_indi_cuot);   -----------indica si se deshabilita el boton
 /*procedure pp_hab_desh_cuot (p_indi in char) is   
begin                     
         
  if p_indi = 'S' then --- entonces habilitar
  	if get_item_property('bpie.cuotas', enabled) = upper('false') then
      set_item_property('bpie.cuotas', enabled, property_true);
      set_item_property('bpie.cuotas', navigable, property_true);
    end if;  
    
 	elsif p_indi = 'N' then --entonces deshabilitar
  		if get_item_property('bpie.cuotas', enabled) = upper('true') then    
  	    set_item_property('bpie.cuotas', enabled, property_false);
  	   end if; 	
  end if;	
end;           */
----------------pp_hab_desh_caja;  
/*procedure pp_hab_desh_caja is    
begin                     
                                
  if :bcab.conc_indi_caja = 'S' then    
      if get_item_property('bcab.cuen_codi', enabled) = upper('false') then             
        set_item_property('bcab.cuen_codi', enabled, property_true);
        set_item_property('bcab.cuen_codi', navigable, property_true);
      end if;     
    
  else
    if get_item_property('bcab.cuen_codi', enabled) = upper('true') then    
      set_item_property('bcab.cuen_codi', enabled, property_false);
    end if;   
    
    
    
  end if; 
  
end;*/

---------------pp_hab_desh_cant(o_conc_indi_cant);

/*procedure pp_hab_desh_cant (p_indi in char) is    
begin                     
                              
  if p_indi = 'S' then --- entonces habilitar
  	if get_item_property('bcab.movi_cant', enabled) = upper('false') then
      set_item_property('bcab.movi_cant', enabled, property_true);
      set_item_property('bcab.movi_cant', navigable, property_true);      
    end if;  
    
 	elsif p_indi = 'N' then --entonces deshabilitar
  		if get_item_property('bcab.movi_cant', enabled) = upper('true') then    
  	    set_item_property('bcab.movi_cant', enabled, property_false);
  	    :bcab.movi_cant := 1;     
  	   end if; 	
  end if;	
end;*/


/* if i_rrhh_indi_m_fech_caja = 'S' then
  if nvl(o_conc_indi_caja, 'N') = 'S' then  
    set_item_property('bcab.S_MOVI_FECH_CAJA', enabled, property_true);
    set_item_property('bcab.S_MOVI_FECH_CAJA', navigable, property_true);
    set_item_property('bcab.S_MOVI_FECH_CAJA', update_allowed, property_true);
    
  else
     set_item_property('bcab.S_MOVI_FECH_CAJA', enabled, property_false);
  end if; 
  end if;*/
  
end pp_buscar_concepto;


procedure pp_muestra_rrhh_conc (p_conc_codi_alte      in number, 
                                p_conc_desc           out char, 
                                p_conc_indi_cuot      out char,  
                                p_conc_indi_caja      out char, 
                                p_conc_dbcr           out char,
                                p_conc_come_codi      out number, 
                                p_conc_indi_cant      out varchar2, 
                                p_conc_unit_medi      out varchar2,
                                p_conc_codi           out number,
                                p_conc_tipo_conc      out varchar2
                                ) is

v_indi_auto varchar2(1);

begin	                   
  select conc_desc,
          nvl(conc_indi_cuot, 'N'),
          nvl(conc_indi_caja, 'N'),
         conc_indi_auto,
         conc_dbcr,
         conc_come_codi,
         nvl(conc_indi_cant, 'N'),
         nvl(conc_unit_medi, 'UN'),
         conc_codi,
         conc_tipo_conc
    into p_conc_desc,
         p_conc_indi_cuot,
         p_conc_indi_caja,
         v_indi_auto,
         p_conc_dbcr,
         p_conc_come_codi,
         p_conc_indi_cant,
         p_conc_unit_medi,
         p_conc_codi,
         p_conc_tipo_conc
    from rrhh_conc
   where conc_codi_alte = p_conc_codi_alte;
   
   
  if v_indi_auto <> 'M' then 
  	raise_application_error(-20001,'Debe seleccionar concepto del tipo manual');
  end if;

  
Exception
  when no_data_found then
     raise_application_error(-20001,'Concepto Inexistente!');

end pp_muestra_rrhh_conc;


procedure pp_valida_fech_rrhh (p_fech in date,
                               p_tipo in varchar2) is
begin    
  
I020091.pp_carga_fech_habi_rrhh(parameter.p_fech_inic_rrhh, parameter.p_fech_fini_rrhh);          
  if p_fech not between parameter.p_fech_inic_rrhh and parameter.p_fech_fini_rrhh and p_tipo = 'A'then
  	raise_application_error(-20001,'La fecha del movimiento debe estar comprendida entre..'||(parameter.p_fech_inic_rrhh) 
  	                 ||' y '||(parameter.p_fech_fini_rrhh));
  end if;	
  
  pa_devu_fech_habi(parameter.p_fech_inic,parameter.p_fech_fini );
   if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini and p_tipo = 'B' then
  	raise_application_error(-20001,'La fecha afecta caja debe estar comprendida entre..'||(parameter.p_fech_inic) 
  	                 ||' y '||(parameter.p_fech_fini));
  end if;
  
  

                          
end pp_valida_fech_rrhh;   



procedure pp_genera_nume_movi (p_nume      out number) is
begin
  
  select (nvl(max(movi_nume),0)+1)
  into p_nume
  from rrhh_movi;

end pp_genera_nume_movi;

procedure pp_buscar_empl (i_empl_codi                  in number,
                          i_perf_codi                  in number,
                          i_movi_Fech_emis             in date,
                          o_empl_desc                  out varchar2,
                          o_empl_esta                  out varchar2,
                          o_movi_mone_codi_liqu        out varchar2,
                          o_empl_sala_Actu             out varchar2,
                          o_empl_tipo_empl             out varchar2,
                          o_mone_desc_abre_liqu        out varchar2,
                          o_mone_cant_deci_liqu        out varchar2,
                          o_movi_tasa_mone_liqu        out varchar2) is 
                          

  v_movi_mone_codi_liqu number;
begin
      
     select empl_desc,
            empl_esta,
            nvl(empl_suel_mone_codi, 1),
            empl_sala_actu,
            empl_tipo_empl
       into o_empl_desc,
            o_empl_esta,
            v_movi_mone_codi_liqu,
            o_empl_sala_Actu,
            o_empl_tipo_empl
       from come_empl
      where empl_codi = i_empl_codi;

     o_movi_mone_codi_liqu := v_movi_mone_codi_liqu;
     
      if o_empl_esta <> 'A' then
        raise_application_error(-20001,'El empleado se encuentra Inactivo');
      end if;
  
    if not(I020091.fp_vali_user_empl(i_perf_codi, i_empl_Codi)) then
     raise_application_error(-20001,'El usuario no posee permiso para consultar el empleado seleccionado');
    end if;
   
    if v_movi_mone_codi_liqu is not null then
       general_skn.pl_muestra_come_mone( v_movi_mone_codi_liqu, 
                                         o_mone_desc_abre_liqu, 
                                         o_mone_desc_abre_liqu, 
                                         o_mone_cant_deci_liqu);
    else
      raise_application_error(-20001,'El empleado no tiene definido una moneda de liquidaci?n de Sueldo');
    end if; 
    
    
    I020091.pp_validar_liqu_empl(i_empl_codi,i_movi_Fech_emis);
    if o_movi_mone_codi_liqu = parameter.p_codi_mone_mmnn then
       o_movi_tasa_mone_liqu := 1;
    end if;  
                      
exception   
when no_data_found then
     raise_application_error(-20001,'Empleado Inexistente!');
end pp_buscar_empl; 
  

procedure pp_validar_liqu_empl (p_empl_codi in number, p_Fech in date) is
v_count number;
begin
  select count(*)
  into v_count
  from rrhh_liqu, rrhh_peri
  where liqu_empl_codi = p_empl_codi
  and liqu_peri_codi = peri_codi
  and p_fech between peri_Fech_inic and peri_fech_fini
  and nvl(liqu_tipo_liqu, 'M') = 'M';
  
  if v_count > 0 then
    raise_application_error(-20001,'Ya existe una liquidacion para el empleado en el periodo del movimiento');
  end if;	
  
end pp_validar_liqu_empl;

--El objetivo de este procedimiento es validar que el usuario posea el........ 
--permiso correspondiente para ver los movimientos de un empleado determinado...
--independientemente de la pantalla en la q se encuentre, es solo otro nivel..
--de seguridad, que est? por debajo del nivl de pantallas.....................

FUNCTION fP_vali_user_empl (p_perf_codi in number, p_empl_codi in number) return boolean is
	v_Count number;
begin

select  count(*)
into v_count 
from rrhh_perf_empl pe
where pe.peem_perf_codi =  p_perf_codi
and pe.peem_empl_codi = p_empl_codi
and pe.peem_indi = 'L';

if v_count = 0 then
	 return false;
else
 return true;
end if; 

Exception
  When no_data_found then
	   return false;
  when others then
    raise_application_error(-20001,'Error');
end fP_vali_user_empl;

procedure pp_buscar_moneda (i_movi_mone_codi        in  number  ,
                            i_movi_fech_emis        in date    ,
                            i_movi_mone_codi_liqu   in number,
                            o_movi_mone_desc        out varchar2,
                            o_movi_mone_desc_abre   out varchar2,
                            o_movi_mone_cant_deci   out varchar2,
                            o_movi_tasa_mone        out varchar2,
                            o_movi_tasa_mone_liqu   out varchar2
                            ) is 

begin
/*if i_movi_mone_codi is  null then
	 i_movi_mone_codi := parameter.p_codi_mone_mmnn;
end if; 
*/


 general_skn.pl_muestra_come_mone (i_movi_mone_codi,o_movi_mone_desc ,  o_movi_mone_desc_abre, o_movi_mone_cant_deci);
--pp_formatear_importes;

pp_busca_tasa_mone(i_movi_mone_codi, i_movi_fech_emis,o_movi_tasa_mone);  
--raise_application_error(-20001, o_movi_tasa_mone_liqu);
if o_movi_tasa_mone_liqu is null then
pp_busca_tasa_mone(i_movi_mone_codi_liqu, i_movi_fech_emis, o_movi_tasa_mone_liqu);   
end if;
              

end pp_buscar_moneda;

procedure pp_busca_tasa_mone (p_mone_codi in number, p_fech in date,  p_mone_coti out number)is
begin  
  if parameter.p_codi_mone_mmnn = p_mone_codi then
     p_mone_coti := 1;
  else 
    select coti_tasa                                           
    into p_mone_coti
    from come_coti
    where coti_mone    = p_mone_codi
    and coti_tica_codi = 1
    and coti_fech      = trunc(p_fech);
  end if;   
 
  Exception                                
      When no_data_found then
        raise_application_error(-20001,'Cotizaciion Inexistente para la fecha del documento para la moneda '||to_char(p_mone_codi));
     
end pp_busca_tasa_mone;    

procedure pp_validar_importe (i_impo_unit_mone      in out number,
                              i_conc_tipo_conc      in varchar2,
                              i_empl_sala_actu      in number,
                              i_movi_cant           in number,
                              i_movi_mone_cant_deci   in number,
                              i_movi_mone_codi_liqu   in number,
                              i_movi_mone_codi        in number,
                              i_movi_tasa_mone_liqu   in number,
                              i_mone_cant_deci_liqu   in number,
                              i_empl_tipo_empl        in varchar2,
                              i_movi_tasa_mone        in number,
                              o_movi_impo_mmnn        out number,
                              o_movi_impo_mone        out number,
                              o_movi_impo_mone_liqu   out number)is
  v_impo_unit_mone number;
begin
 
     
v_impo_unit_mone := i_impo_unit_mone;

if v_impo_unit_mone is null and i_conc_tipo_conc in  ('SJ', 'VA') then	
	
	 if i_empl_tipo_empl = 'O' then ---si es jornalero
	  v_impo_unit_mone := i_empl_sala_actu;
	 else ---sin es contratado
	  v_impo_unit_mone := round((i_empl_sala_actu/30),4); 
	 end if;	
end if;	

if nvl(v_impo_unit_mone,0) <=0 then 
  raise_application_error(-20001,'El importe debe ser mayor a 0'); 
end if; 

o_movi_impo_mone := round((v_impo_unit_mone * nvl(i_movi_cant,1)), i_movi_mone_cant_deci);

if nvl(o_movi_impo_mone,0) <=0 then 
  raise_application_error(-20001,'El importe debe ser mayor a 0'); 
end if; 

 o_movi_impo_mmnn      := round((o_movi_impo_mone*i_movi_tasa_mone), parameter.p_cant_deci_mmnn);
if i_movi_mone_codi <> i_movi_mone_codi_liqu then
  o_movi_impo_mone_liqu := round((o_movi_impo_mmnn / i_movi_tasa_mone_liqu), i_mone_cant_deci_liqu);
else
	 o_movi_impo_mone_liqu := o_movi_impo_mone;
end if;	
     i_impo_unit_mone  := v_impo_unit_mone;
     
    --   raise_application_error(-20001,o_movi_impo_mone_liqu);
   

end pp_validar_importe;   

procedure pp_buscar_caja   (i_cuen_codi          in  number,
                              i_conc_indi_caja     in varchar2,
                              i_movi_cond_pago     in varchar2,
                              i_movi_mone_codi     in number,
                              i_movi_fech_emis     in varchar2,
                              i_movi_fech_caja     in varchar2,
                              o_cuen_desc         out varchar2
                              ) is
 v_mone_codi number;
 V_movi_cond_pago varchar2(5):= 'SE';
begin
  NULL;
 V_movi_cond_pago := 'SE';
 --- raise_application_error(-20021,'ddd--DDDDddd'||i_movi_cond_pago);
 if i_conc_indi_caja= 'S' and  V_movi_cond_pago in ('SE', 'EC') then
   if i_cuen_codi is not null then     

     select cuen_desc, cuen_mone_codi
      into   o_cuen_desc, v_mone_codi
      from   come_cuen_banc
      where  cuen_codi = i_cuen_codi;  
  
  if v_mone_codi <> i_movi_mone_codi then
  	 raise_application_error(-20001,'El codigo de la moneda de la Caja no coincide con la moneda seleccionada');
  end if;	
  
  
    /*  if not general_skn.fl_vali_user_cuen_banc_cred(i_cuen_codi, i_movi_fech_emis, i_movi_fech_caja) then
        raise_application_error(-20001,'No posee permiso para ingresar en la caja seleccionada!!!')  ;
      end if;    */
   else
        raise_application_error(-20001,'Debe ingresar la cuenta bancaria');
   end if;
   --i_cuen_codi:=i_cuen_codi;
   
else      
 
    o_cuen_desc := null;     
end if;    
exception
 when no_data_found then
     raise_application_error(-20001,'Cuenta Bancaria Inexistente!');
     
                      
end pp_buscar_caja;   


procedure pp_generar_cuotas  (i_s_tipo_vto           in varchar2,
                              i_s_entrega            in varchar2,
                              i_s_cant_cuotas        in varchar2/*,
                              i_movi_fech_emis       in date,
                              i_movi_impo_mone       in varchar2,
                              i_movi_mone_cant_deci  in varchar2,
                              i_movi_tasa_mone       in varchar2,
                              i_movi_tasa_mone_liqu  in varchar2,
                              i_mone_cant_deci_liqu  in varchar2*/)is  
v_dias        number;       
v_impo_mone     number;
v_impo_mmnn     number;
v_impo_liqu     number;

v_cant_cuotas number;
v_entrega     number:=0;
v_vto         number;
v_dife_mone  number;
v_dife_mmnn  number;
v_dife_liqu  number;

v_count       number:=0;

v_s_cuot_fech_venc   varchar2(100);
v_cuot_fech_Venc     varchar2(100);
v_cuot_impo_mone      varchar2(100);
v_cuot_impo_mmnn      varchar2(100);
v_cuot_impo_mone_liqu  varchar2(100);

i_movi_fech_emis        date;
i_movi_impo_mone       varchar2(100);
i_movi_mone_cant_deci  varchar2(100);
i_movi_tasa_mone       varchar2(100);
i_movi_tasa_mone_liqu  varchar2(100);
i_mone_cant_deci_liqu  varchar2(100);
     

begin    
  
i_movi_fech_emis       := V('P101_MOVI_FECH_EMIS');
i_movi_impo_mone       := V('P101_MOVI_IMPO_MONE');
i_movi_mone_cant_deci  := V('P101_MOVI_MONE_CANT_DECI');
i_movi_tasa_mone       := V('P101_MOVI_TASA_MONE');
i_movi_tasa_mone_liqu  := V('P101_MOVI_TASA_MONE_LIQU');
i_mone_cant_deci_liqu  := V('P101_MONE_CANT_DECI_LIQU');

 apex_collection.create_or_truncate_collection(p_collection_name => 'CUOTA');
                                         
  if i_s_tipo_vto = 'M' then
	   v_vto := 30;
  elsif i_s_tipo_vto = 'Q' then	 
	   v_vto := 15;
  elsif i_s_tipo_vto = 'S' then	 
	   v_vto := 7;
  end if;


  if i_s_entrega = 0 then 
    --si no tiene entrega
    v_dias := v_vto;

    v_entrega     := 0;
    v_cant_cuotas   := i_s_cant_cuotas;
    v_impo_mone     := round(i_movi_impo_mone/v_cant_cuotas,i_movi_mone_cant_deci);
    
    v_dife_mone     := round(i_movi_impo_mone-(v_impo_mone*v_cant_cuotas), i_movi_mone_cant_deci);


      for x in 1..v_cant_cuotas loop

        v_dias                := v_dias;
        v_s_cuot_fech_venc    := to_char((i_movi_fech_emis + v_dias), 'dd-mm-yyyy');
        v_cuot_fech_venc      := to_date(v_s_cuot_fech_venc, 'dd-mm-yyyy');
        v_cuot_impo_mone      := v_impo_mone;
        v_cuot_impo_mmnn      := round(v_cuot_impo_mone * i_movi_tasa_mone,0);
        v_cuot_impo_mone_liqu := round(v_cuot_impo_mmnn / i_movi_tasa_mone_liqu,i_mone_cant_deci_liqu);
        
       
        v_count                := v_count + 1;

        if v_count = v_cant_cuotas then
          if v_dife_mone <> 0 then
           --sumar la diferencia a la ultima cuota   
           V_cuot_impo_mone := V_cuot_impo_mone + v_dife_mone;
           end if;     
        end if;
         apex_collection.add_member(p_collection_name => 'CUOTA',
                                    p_c001          => v_dias,--apli_codigo,
                                    p_c002          => v_s_cuot_fech_venc,--apli_fecha,
                                    p_c003          => v_cuot_fech_Venc,
                                    p_c004          => v_cuot_impo_mone,
                                    p_c005          => v_cuot_impo_mmnn,
                                    p_c006          => v_cuot_impo_mone_liqu,
                                    p_c007          =>   i_movi_fech_emis

                                    );
                                    
          v_dias                 := v_dias + v_vto;                           
      end loop	;
      
   

  else
    --si tiene entrega
   v_dias          := 0;
   v_entrega       := i_s_entrega;
   v_cant_cuotas   := i_s_cant_cuotas;
   v_impo_mone     := round((i_movi_impo_mone - v_entrega)/v_cant_cuotas,i_movi_mone_cant_deci);
   v_dife_mone     :=  round(i_movi_impo_mone-((v_impo_mone*v_cant_cuotas)+ v_entrega), i_movi_mone_cant_deci);


   v_dias := 0;   
   v_s_cuot_fech_venc    := to_char((i_movi_fech_emis + v_dias), 'dd-mm-yyyy');
   v_cuot_fech_venc      := to_date(v_s_cuot_fech_venc, 'dd-mm-yyyy');          
   v_cuot_impo_mone      := v_entrega;
   v_cuot_impo_mmnn      := round(v_cuot_impo_mone * i_movi_tasa_mone,0);
   v_cuot_impo_mone_liqu := round(v_cuot_impo_mmnn / i_movi_tasa_mone_liqu, i_mone_cant_deci_liqu);
   
     
     apex_collection.add_member(p_collection_name => 'CUOTA',
                                    p_c001          => v_dias,--apli_codigo,
                                    p_c002          => v_s_cuot_fech_venc,--apli_fecha,
                                    p_c003          => v_cuot_fech_Venc,
                                    p_c004          => v_cuot_impo_mone,
                                    p_c005          => v_cuot_impo_mmnn,
                                    p_c006          => v_cuot_impo_mone_liqu,
                                     p_c007         =>  i_movi_fech_emis
                                    );
   --  v_dias := v_vto;
     
     for x in 1..v_cant_cuotas loop
       v_dias                 := v_dias;  
       v_s_cuot_fech_venc     := to_char((i_movi_fech_emis + v_dias), 'dd-mm-yyyy');
       v_cuot_fech_venc       := to_date(v_s_cuot_fech_venc, 'dd-mm-yyyy');           
       v_cuot_impo_mone       := v_impo_mone;
       v_cuot_impo_mmnn       := round(v_cuot_impo_mone * i_movi_tasa_mone,0);
       v_cuot_impo_mone_liqu  := round(v_cuot_impo_mmnn / i_movi_tasa_mone_liqu,i_mone_cant_deci_liqu);
        
     v_dias := v_dias + v_vto;
     v_count := v_count + 1;
      if v_count = v_cant_cuotas then     
       if v_dife_mone <> 0 then
           --sumar la diferencia a la ultima cuota   
           v_cuot_impo_mone := v_cuot_impo_mone + v_dife_mone;   
        end if;
     end if;
     
       apex_collection.add_member(p_collection_name => 'CUOTA',
                                    p_c001          => v_dias,--apli_codigo,
                                    p_c002          => v_s_cuot_fech_venc,--apli_fecha,
                                    p_c003          => v_cuot_fech_Venc,
                                    p_c004          => v_cuot_impo_mone,
                                    p_c005          => v_cuot_impo_mmnn,
                                    p_c006          => v_cuot_impo_mone_liqu,
                                    p_c007         =>  i_movi_fech_emis
                                    );
   end loop	;


                        
end if;

 setitem('P102_MOVI_FECH_EMIS', i_movi_fech_emis);
end pp_generar_cuotas;

procedure pp_validar_cuotas(i_movi_impo_mone        in number,
                            i_movi_fech_emis        in date,
                            i_movi_impo_mmnn        in number,
                            i_movi_impo_mone_liqu   in number) is
type r_cuotas is record (v_dias number);
type t_cuotas is table of r_cuotas index by binary_integer;
i number:=0;                    
v_cuotas t_cuotas; 
v_cont number:= 0;
v_dias number;
v_total number:= 0;
 
v_max_id               number;
v_sum_cuot_impo_mone   number;
v_sum_cuot_impo_mmnn   number;
v_sum_cuot_impo_mone_liqu number;
v_cuot_impo_mone          number;
v_cuot_impo_mmnn          number;
v_cuot_impo_mone_liqu     number;
begin    
                             
     begin  
  select  max(seq_id),
          nvl(sum(nvl(c004,0)),0)        cuot_impo_mone,
          nvl(sum(nvl(c005,0)),0)        cuot_impo_mmnn,
          nvl(sum(nvl(c006,0)),0)        cuot_impo_mone_liqu
          into 
          v_max_id,
          v_sum_cuot_impo_mone,
          v_sum_cuot_impo_mmnn,
          v_sum_cuot_impo_mone_liqu
    from apex_collections
   where collection_name = 'CUOTA'; 
  exception when no_Data_found then
     raise_application_error(-20010,'Error'||v_max_id);
  end ;
  
   
   begin  
     select 
          c004        cuot_impo_mone,
          c005        cuot_impo_mmnn,
          c006        cuot_impo_mone_liqu
       into v_cuot_impo_mone,
          v_cuot_impo_mmnn,
          v_cuot_impo_mone_liqu
    from apex_collections
   where collection_name = 'CUOTA'
   and seq_id =v_max_id;
 
  exception when no_Data_found then
     raise_application_error(-20010,'cuotas'||v_max_id);
  end ;
 
               
  for bcuota in cuota loop
     v_total := v_total + bcuota.cuot_impo_mone;    
      
     if bcuota.cuot_Fech_venc < i_movi_fech_emis then
        raise_application_error(-20001, 'La fecha de vencimiento de la cuota no puede ser inferior a la fecha del documento');
      end if;
      
  end loop;
  
  if v_total <> i_movi_impo_mone then
     raise_application_error(-20001,'El total de la factura no coincide con el total de las cuotas!!');
  end if; 

-----------------------------------------------------------------  

  for bcuotas in cuota loop   
    v_cuotas(i).v_dias := to_number(bcuotas.dias);
    i := i +1;  

  end loop;
-------------------------------------------------------
begin
 for x in 0..i loop
     
     v_dias:= v_cuotas(x).v_dias;
     
    for  bcuota in cuota  loop 
       
        if v_dias = to_number(bcuota.dias) then
          v_cont := v_cont +1;
         end if;
      end loop;  
      if v_cont > 1 then
         raise_application_error(-20001,'Existe mas de una cuota con la misma fecha de vencimiento');
      end if;
      v_cont := 0;
     
  end loop;
 exception when no_Data_found then
   
 null;
 end ; 
 -- raise_application_error(-20010,'dfad'); 

  if i_movi_impo_mmnn <> v_sum_cuot_impo_mmnn then
      v_cuot_impo_mmnn := v_cuot_impo_mmnn + (i_movi_impo_mmnn - v_sum_cuot_impo_mmnn);     
  end if; 
  
  if i_movi_impo_mone_liqu <> v_sum_cuot_impo_mone_liqu then
      v_cuot_impo_mone_liqu := v_cuot_impo_mone_liqu + (i_movi_impo_mone_liqu - v_sum_cuot_impo_mone_liqu);     
  end if; 
  


end pp_validar_cuotas;


procedure pp_genera_cuota_auto(i_movi_impo_mone        in varchar2,
                                i_movi_fech_emis        in varchar2,
                                i_movi_impo_mmnn        in varchar2,
                                i_movi_impo_mone_liqu   in varchar2,
                                i_movi_tasa_mone        in varchar2,    
                                i_movi_tasa_mone_liqu   in varchar2,
                                i_mone_cant_deci_liqu   in varchar2) is    
v_s_cuot_fech_venc   varchar2(100);
v_cuot_fech_Venc     varchar2(100);
v_cuot_impo_mone      varchar2(100);
v_cuot_impo_mmnn      varchar2(100);
v_cuot_impo_mone_liqu  varchar2(100);
  v_dias               number;   

begin
      apex_collection.create_or_truncate_collection(p_collection_name => 'CUOTA');
  
                              
      v_cuot_impo_mone        := i_movi_impo_mone;
      v_cuot_impo_mmnn        := round((i_movi_impo_mone*i_movi_tasa_mone),parameter.p_cant_deci_mmnn);
      v_cuot_impo_mone_liqu   := round((v_cuot_impo_mmnn/i_movi_tasa_mone_liqu), i_mone_cant_deci_liqu);
      v_cuot_fech_venc        := to_Date(i_movi_fech_emis,'dd/mm/yyyy');   
      v_s_cuot_fech_venc      := v_cuot_fech_venc;
            
       v_dias :=   to_date(v_cuot_fech_venc) - to_date(i_movi_fech_emis) ;


  apex_collection.add_member(p_collection_name => 'CUOTA',
                                    p_c001          => v_dias,--apli_codigo,
                                    p_c002          => v_s_cuot_fech_venc,--apli_fecha,
                                    p_c003          => v_cuot_fech_Venc,
                                    p_c004          => v_cuot_impo_mone,
                                    p_c005          => v_cuot_impo_mmnn,
                                    p_c006          => v_cuot_impo_mone_liqu );
 end pp_genera_cuota_auto;
 
 
 
   procedure pp_imprimir_reportes (i_movi_codi in number) is

    v_report       VARCHAR2(50);
    v_parametros   CLOB;
    v_contenedores CLOB;

    p_where varchar2(500);
    v_title varchar2(100):='File I020093 - Consulta de Movimientos Varios';
    
    begin
                            
      p_where   := p_where||' and m.movi_codi =  '|| i_movi_codi ||' ';
       
      
      V_CONTENEDORES := 'p_where:p_titulo';

      V_PARAMETROS   :=   p_where || ':' ||
                          v_title ;

      v_report       :='I020091';

      DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

      INSERT INTO COME_PARAMETROS_REPORT
        (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
      VALUES
        (V_PARAMETROS, v('APP_USER'), v_report, 'pdf', V_CONTENEDORES);

      commit;
    end pp_imprimir_reportes;
    
    
procedure pp_editar_cuotas(p_seq_id  in number,
                           p_dia     in number,
                           p_fecha   in date,
                           p_importe in number) is

  v_s_cuot_fech_venc    varchar2(100);
  v_cuot_fech_Venc      varchar2(100);
  v_cuot_impo_mone      varchar2(100);
  v_cuot_impo_mmnn      varchar2(100);
  v_cuot_impo_mone_liqu varchar2(100);
  v_dias                number;
  v_movi_tasa_mone      number;
  v_movi_tasa_mone_liqu number;
  v_mone_cant_deci_liqu number;

i_movi_fech_emis        date;
i_movi_impo_mone       varchar2(100);
i_movi_mone_cant_deci  varchar2(100);
i_movi_tasa_mone       varchar2(100);
i_movi_tasa_mone_liqu  varchar2(100);
i_mone_cant_deci_liqu  varchar2(100);
v_fecha                date;
v_dia                  number;
begin    
  
i_movi_fech_emis       := V('P101_MOVI_FECH_EMIS');
i_movi_impo_mone       := V('P101_MOVI_IMPO_MONE');
i_movi_mone_cant_deci  := V('P101_MOVI_MONE_CANT_DECI');
i_movi_tasa_mone       := V('P101_MOVI_TASA_MONE');
i_movi_tasa_mone_liqu  := V('P101_MOVI_TASA_MONE_LIQU');
i_mone_cant_deci_liqu  := V('P101_MONE_CANT_DECI_LIQU');
  if p_dia is not null then
    v_dia := p_dia;
  elsif p_dia is null and p_fecha is not null  then
    v_dia :=  TO_dATE(p_fecha,'DD/MM/YYYY')- i_movi_fech_emis ;
  else
    raise_application_error(-20001, 'Pagos a no puede quedar nulo');
  end if;
  if p_fecha is not null then
    v_fecha := p_fecha;
  
  elsif p_fecha is null and p_dia is not null then
    v_fecha := i_movi_fech_emis+v_dia;  
  else
    raise_application_error(-20001,
                            'La fecha de vencimiento no puede quedar nulo');
  end if;
  if nvl(p_importe, 0) <= 0 then
    raise_application_error(-20001,
                            'El importe no puede ser nulo o menor a 1');
  end if;

  v_cuot_impo_mmnn      := round(p_importe * i_movi_tasa_mone, 0);
  v_cuot_impo_mone_liqu := round(v_cuot_impo_mmnn / i_movi_tasa_mone_liqu,i_mone_cant_deci_liqu);

  APEX_COLLECTION.UPDATE_MEMBER(p_collection_name => 'CUOTA',
                                p_seq             => p_seq_id,
                                p_c001            => v_dia,
                                p_c002            => v_fecha,
                                p_c003            => v_fecha,
                                p_c004            => p_importe,
                                p_c005            => v_cuot_impo_mmnn,
                                p_c006            => v_cuot_impo_mone_liqu,
                                p_c007          =>   i_movi_fech_emis);

end pp_editar_cuotas;
end I020091;
