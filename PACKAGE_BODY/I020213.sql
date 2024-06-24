
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020213" is


   
  p_cant_dias_feri number:= 0;
  p_indi_most_mens_sali varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_most_mens_sali')));
  
  p_codi_timo_reem number:= to_number(fa_busc_para('p_codi_timo_reem'));
  p_codi_clie_espo number:= to_number(fa_busc_para('p_codi_clie_espo'));
  p_codi_prov_espo number:= to_number(fa_busc_para('p_codi_prov_espo'));
  
  p_repo_soli_mate      varchar2(500):= fa_busc_para ('p_repo_soli_mate');
  
  --pp_mostrar_clpr_codi (p_codi_clie_espo, 'C', p_clpr_codi_clie);
  --pp_mostrar_clpr_codi (p_codi_prov_espo, 'P', p_clpr_codi_prov);
  
  p_form_impr_fact       varchar2(500):= ltrim(rtrim(fa_busc_para('p_form_impr_fact')));
  p_codi_oper_vta        varchar2(500):= ltrim(rtrim(fa_busc_para('p_codi_oper_vta')));   
    
  p_indi_vali_repe_cheq  varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_vali_repe_cheq'))); 
  p_form_impr_fact_lega  varchar2(500):= ltrim(rtrim(fa_busc_para('p_form_impr_fact_lega')));
  p_form_impr_bole       varchar2(500):= ltrim(rtrim(fa_busc_para('p_form_impr_bole')));
  
  p_cant_deci_mmnn       number:= to_number(fa_busc_para('p_cant_deci_mmnn'));
  p_codi_mone_mmnn       number:= to_number(fa_busc_para('p_codi_mone_mmnn'));
  
  p_codi_base            number:= pack_repl.fa_devu_codi_base;
  p_empr_codi            number:= v('AI_EMPR_CODI');
  /******************************************************************/
  p_codi_timo_contr       varchar2(500):= to_number(fa_busc_para('p_codi_timo_contr'));
  p_codi_timo_reem        varchar2(500):= to_number(fa_busc_para('p_codi_timo_reem'));
  
  p_codi_clie_espo        varchar2(500):= to_number(fa_busc_para('p_codi_clie_espo'));
  p_codi_prov_espo        varchar2(500):= to_number(fa_busc_para('p_codi_prov_espo'));
  p_fech_inic             date;
  p_fech_fini             date;
  
  p_indi_vali_repe_cheq  varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_vali_repe_cheq'))); 
  p_indi_most_mens_sali  varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_most_mens_sali'))); 
  p_codi_timo_rete_emit  number:= to_number(fa_busc_para('p_codi_timo_rete_emit'));
  p_codi_timo_rere       number:= to_number(fa_busc_para('p_codi_timo_rere'));
  p_codi_timo_orde_pago  number:= to_number(fa_busc_para('p_codi_timo_orde_pago'));
  p_codi_timo_depo_banc  number:= to_number(fa_busc_para('p_codi_timo_depo_banc'));
  p_codi_timo_adlr       number:= to_number(fa_busc_para('p_codi_timo_adlr'));
  p_codi_timo_pcor       number:= to_number(fa_busc_para('p_codi_timo_pcor'));
  p_codi_timo_pago_pres  number:= to_number(fa_busc_para('p_codi_timo_pago_pres'));
  p_indi_moti_anul_obli  varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_moti_anul_obli'))); 
  p_indi_perm_borr_reci_plan_cer varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_perm_borr_reci_plan_cer'))); 
  
  
  p_codi_timo_rcnadlr varchar2(500):= to_number(fa_busc_para('p_codi_timo_rcnadlr'));
  
  p_indi_perm_fech_futu_dbcr varchar2(500):= ltrim(rtrim(fa_busc_para('p_indi_perm_fech_futu_dbcr'))); 
  
  type r_bcab is record(
  
    prod_codi           number,
    s_cant              number,
    prod_cost_prom_tota number,
    prod_cost_prom      number,
    prod_cost_prom_actu number,
    indi_arma_desa      varchar2(10),
    
    movi_codi            come_movi.movi_codi%type,
    movi_nume            come_movi.movi_nume%type,
    movi_timo_codi       come_movi.movi_timo_codi%type,

    movi_clpr_codi       come_movi.movi_clpr_codi%type,
    movi_clpr_desc       come_movi.movi_clpr_desc%type,
    movi_nume_timb       come_movi.movi_nume_timb%type,
    movi_clpr_dire       come_movi.movi_clpr_dire%type,
    movi_clpr_tele       come_movi.movi_clpr_tele%type,     
    movi_clpr_ruc        come_movi.movi_clpr_ruc%type,    
    movi_fech_emis       come_movi.movi_fech_emis%type,   
    movi_fech_oper       come_movi.movi_fech_oper%type,
    movi_empl_codi       come_movi.movi_empl_codi%type,   
    movi_oper_codi       come_movi.movi_oper_codi%type,   
    movi_depo_codi_orig  come_movi.movi_depo_codi_orig%type,
    movi_depo_codi_dest  come_movi.movi_depo_codi_dest%type,    
    movi_obse            come_movi.movi_obse%type,    
    movi_mone_codi       come_movi.movi_mone_codi%type,
    movi_tasa_mone       come_movi.movi_tasa_mone%type,   
    movi_tasa_mmee       come_movi.movi_tasa_mmee%type,   
    movi_sucu_codi_orig  come_movi.movi_sucu_codi_orig%type,
    movi_sucu_codi_dest  come_movi.movi_sucu_codi_dest%type,    
    movi_fech_grab       come_movi.movi_fech_grab%type,
    movi_user            come_movi.movi_user%type,    
    movi_grav10_ii_mone  come_movi.movi_grav10_ii_mone%type,
    movi_grav5_ii_mone   come_movi.movi_grav5_ii_mone%type,
    movi_exen_mone       come_movi.movi_exen_mone%type,   
    movi_grav10_ii_mmnn  come_movi.movi_grav10_ii_mmnn%type,
    movi_grav5_ii_mmnn   come_movi.movi_grav5_ii_mmnn%type,
    movi_exen_mmnn       come_movi.movi_exen_mmnn%type,   
    movi_sald_mone       come_movi.movi_sald_mone%type,
    movi_sald_mmnn       come_movi.movi_sald_mmnn%type,   
    movi_grav_mone       come_movi.movi_grav_mone%type,
    movi_grav_mmnn       come_movi.movi_grav_mmnn%type,   
    movi_ortr_codi       come_movi.movi_ortr_codi%type,
    movi_orpa_codi       come_movi.movi_orpa_codi%type,   
    movi_soco_codi       come_movi.movi_soco_codi%type,   
    tico_codi            number,
    movi_indi_cobr_dife  come_movi.movi_indi_cobr_dife%type,
    movi_rrhh_movi_codi  come_movi.movi_rrhh_movi_codi%type,
    movi_apci_codi       come_movi.movi_apci_codi%type,
    movi_codi_padr       come_movi.movi_codi_padr%type,
    
    movi_iva_mone        come_movi.movi_iva_mone%type,
    movi_iva_mmnn        come_movi.movi_iva_mmnn%type );

    bcab r_bcab;
    
    v_erro_codi   number; -- codigo de error de retorno
    v_erro_desc   varchar2(5000); -- descripcion de error de retorno    
    v_count       number;
    v_cant_regi   number;
    salir         exception;
    
    TA_MOVI_ANUL PACK_ANUL.TT_MOVI_ANUL; 
    
    p_session     varchar2(5000):= nvl(v('APP_SESSION'), '00'); -- El valor 00 es para ser usado en el procedimiento pa_actu_cuot_rede_venc 
    
 /**********************************************************************/
 /******************** ACTUALIZAR REGISTROS ****************************/
 /**********************************************************************/ 
 
 --obs: si se quiere hacer una modificaciones en este procedimiento, favor mirar tambien en el procedimiento pa_actu_cuot_rede_venc
 --donde tambien se hace uso del pp_actualizar_registro 
 --juanb
 
procedure pp_actualizar_registro(ii_movi_codi      in number,
                                 ii_movi_tasa_mone in number,
                                 ii_cuot_fech_ven  in date) is
begin
  
   I020213.pp_validar_refi(ii_movi_codi);  
   I020213.pp_actu_refi(ii_movi_codi,  ii_movi_tasa_mone, ii_cuot_fech_ven);
  
end pp_actualizar_registro;


 /**********************************************************************/
 /******************* C A R G A  DE  D A T O S *************************/
 /**********************************************************************/ 
  
 procedure pp_mues_asie_nume(p_codi in number, p_nume out number) is

    begin

      select asie_nume into p_nume from come_asie where asie_codi = p_codi;

    exception
      when no_data_found then
        raise_application_error(-20010, 'Numero de asiento inexistente!');
   end pp_mues_asie_nume;

 procedure pp_most_op(p_codi in number, p_nume out varchar2) is
    begin
      select orpa_nume
        into p_nume
        from come_orde_pago
       where orpa_codi = p_codi;

    exception
      when no_data_found then
        p_nume := null;
end pp_most_op;

 procedure pp_most_apli_codi (p_movi_codi in number, p_apli_codi out number) is
begin
	
	
	select apli_codi
    into p_apli_codi
    from come_apli_cost
   where apli_movi_codi = p_movi_codi;
  
  
 exception
  when no_data_found then
    null;
  when too_many_rows then
    raise_application_error(-20010, 'Codigo duplicado en Costo!')   ;
 
end pp_most_apli_codi;

 /**********************************************************************/
 /*************************   VALIDACIONES  ****************************/
 /**********************************************************************/ 
 
  --detalle de importes...
  procedure pp_vali_impo(i_movi_codi in number,
                        o_resp_codi out number,
                        o_resp_desc out varchar2) is   
   
    v_caja_codi      number;
    v_caja_cuen_codi number;
    v_caja_fech      date;
      
    begin
       
    setitem('P34_PROGRESS_BAR_PORC', 5);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cierre de caja..');
    
      select max(d.moim_caja_codi)
        into v_caja_codi
        from come_movi_impo_deta d
       where d.moim_movi_codi = i_movi_codi
       and d.moim_caja_codi is not null;
       
      if v_caja_codi is not null then
        
        select c.caja_cuen_codi, c.caja_fech
          into v_caja_cuen_codi, v_caja_fech
          from come_cier_caja c
         where c.caja_codi = v_caja_codi;
      
      -- ESTE SOLO TIENE QUE SER UN MENSAJE
         pp_get_erro(i_resp_codi => 1,
                     i_resp_orig => 1,
                     i_resp_segu_pant => 116,
                     o_resp_desc => v_erro_desc);
              
        v_erro_codi := 1;  
        v_erro_desc :=  replace(replace(v_erro_desc, 'P_FECHA', to_char(v_caja_fech, 'dd-mm-yyyy')),'P_CAJA', v_caja_cuen_codi); 
             
      end if;
      
    exception
      when salir then 
         o_resp_codi := v_erro_codi;
         o_resp_desc := v_erro_desc;
      when no_data_found then
        null;
   end;
  
  --validar bloqueo de Logistic
  procedure pp_vali_logi(i_movi_codi in number,
                        o_resp_codi out number,
                        o_resp_desc out varchar2) is        
     v_cont number;
      begin
            
  setitem('P34_PROGRESS_BAR_PORC', 6);
  setitem('P34_PROGRESS_BAR_DESC', 'Validando preparacion de entregas..');
  
          select count(*)
            into v_cont
            from come_movi_entr_deta
           where deta_movi_codi = i_movi_codi
             and nvl(deta_indi_impr_logi,'N') = 'S' 
             and nvl(deta_indi_soli_anul,'N') = 'N';
        
        if v_cont > 0 then
          
             pp_get_erro(i_resp_codi => 2,
                         i_resp_orig => 1,
                         i_resp_segu_pant => 116,
                         o_resp_desc => v_erro_desc);
              
             v_erro_codi := 2; 
             raise salir;
             
        end if; 
        
          select count(*)
            into v_cont
            from come_movi_entr_deta
            where deta_movi_codi = i_movi_codi
            and nvl(deta_indi_impr_logi,'N') = 'S' 
            and nvl(deta_indi_soli_anul,'N') = 'P';
        
        if v_cont > 0 then
          
             pp_get_erro(i_resp_codi => 2,
                         i_resp_orig => 1,
                         i_resp_segu_pant => 116,
                         o_resp_desc => v_erro_desc);
              
             v_erro_codi := 2; 
                  
        end if; 
        
        
      exception      
        when others then          
           pp_get_erro(i_resp_codi => 3,
                       i_resp_orig => 1,
                       i_resp_segu_pant => 116,
                       o_resp_desc => v_erro_desc);
            
           o_resp_codi := 3;
           o_resp_desc :=  v_erro_desc;
     
  end pp_vali_logi; 

  -- validamos cierre de OS
  procedure pp_vali_cier_OS(i_movi_codi in number,
                           o_resp_codi out number,
                           o_resp_desc out varchar2) is
       v_cont      number;
       v_orse_nume varchar2(20);

    begin
    
  setitem('P34_PROGRESS_BAR_PORC', 8);
  setitem('P34_PROGRESS_BAR_DESC', 'Validando cierre de OS..');
     	
     select s.orse_nume_char
      into v_orse_nume
      from come_orde_serv s, 
           come_orde_serv_fact f
      where s.orse_codi = f.oscl_orse_codi
      and s.orse_esta  <> 'P'
      and f.oscl_movi_codi = i_movi_codi;

          
      if v_orse_nume is not null then          
      
        pp_get_erro(i_resp_codi => 4,
                    i_resp_orig => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc => v_erro_desc);
        
        v_erro_codi := 4;             
        v_erro_desc :=  replace(v_erro_desc, 'P_NRO_OS', v_orse_nume);             
        raise salir; 
          
      end if;  

    exception  
        when no_data_found then
           null;
        when salir then 
          o_resp_codi := v_erro_codi;
          o_resp_desc := v_erro_desc;  
        when others then     
          pp_get_erro(i_resp_codi => 5,
                      i_resp_orig => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc => v_erro_desc);
        
         v_erro_codi := 5;
         o_resp_codi := v_erro_codi;
         o_resp_desc := v_erro_desc;  
    end;
    
  --Validar Modulo de RRHH   
  procedure pp_vali_modu_rrhh(i_movi_codi in number,
                             o_resp_codi out number,
                             o_resp_desc out varchar2) is
   v_movi_rrhh_movi_codi number;
   v_movi_timo_codi      number;
  begin 
    
  setitem('P34_PROGRESS_BAR_PORC', 10);
  setitem('P34_PROGRESS_BAR_DESC', 'Validando Modulo RRHH..');
  
  select movi_timo_codi, movi_rrhh_movi_codi
    into v_movi_timo_codi, v_movi_rrhh_movi_codi
    from come_movi, 
         come_tipo_movi,
         come_clie_prov,
         come_empl,
         come_mone,
         come_depo dd,
         come_depo do,
         come_sucu sd,
         come_sucu so,
         come_stoc_oper
     where movi_timo_codi = timo_codi(+)
      and movi_clpr_codi = clpr_codi(+)
      and movi_empl_codi = empl_codi(+)
      and movi_mone_codi =  mone_codi
      and movi_depo_codi_dest = dd.depo_codi(+) 
      and movi_depo_codi_orig = do.depo_codi(+) 
      and movi_oper_codi =  oper_codi(+)
      and movi_sucu_codi_orig = so.sucu_codi(+)
      and movi_sucu_codi_dest = sd.sucu_codi(+)
      and movi_codi = i_movi_codi;
  
      if v_movi_rrhh_movi_codi is not null or v_movi_timo_codi = 33 then
        
        pp_get_erro(i_resp_codi => 6,
                    i_resp_orig => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc => v_erro_desc);
        
         v_erro_codi := 6;
         raise salir;       
      end if;	
      
      
   exception 
      when salir then 
         o_resp_codi := v_erro_codi;
         o_resp_desc := v_erro_desc; 
      when others then         
        pp_get_erro(i_resp_codi => 9,
                    i_resp_orig => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc => v_erro_desc);
        
         v_erro_codi := 9;
         o_resp_codi := v_erro_codi;
         o_resp_desc := v_erro_desc; 
   end pp_vali_modu_rrhh;   
    
  --Validando Pago de Impuestos Inmobiliarios.         
  procedure pp_vali_impu_inmo(i_movi_codi in number,
                             o_resp_codi out number,
                             o_resp_desc out varchar2) is
      v_cont      number;
    begin
    
    setitem('P34_PROGRESS_BAR_PORC', 12);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Pago de Impuestos Inmobiliarios..');	
    
       select COUNT(*)
         into v_cont
         from roga_prof_imin
        where prim_movi_codi = i_movi_codi;

        
        if v_cont > 0 then
          
        pp_get_erro(i_resp_codi => 7,
                    i_resp_orig => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc => v_erro_desc);
        
         v_erro_codi := 7;
         raise salir;
         
        end if;  

      exception  
          when no_data_found then
            null;
          when salir then             
            o_resp_codi := v_erro_codi;
            o_resp_desc := v_erro_desc;
          when others then
            pp_get_erro(i_resp_codi => 8,
                        i_resp_orig => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc => v_erro_desc);
        
            v_erro_codi := 9;
            o_resp_codi := v_erro_codi;
            o_resp_desc := v_erro_desc;
      end; 
 
  --Validando post de ventas..
  procedure pp_vali_movi_post (i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
   
 v_movi_timo_codi number;
 v_movi_apci_codi number;
 v_apci_esta      come_aper_cier_caja.apci_esta%type;
    begin

    setitem('P34_PROGRESS_BAR_PORC', 14);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando post de ventas..');	

    select movi_timo_codi, movi_apci_codi
      into v_movi_timo_codi, v_movi_apci_codi
      from come_movi, come_tipo_movi
     where movi_timo_codi = timo_codi(+)
       and movi_codi = i_movi_codi;

      if v_movi_timo_codi = 27 and v_movi_apci_codi is not null then
        
            pp_get_erro(i_resp_codi => 10,
                        i_resp_orig => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc => v_erro_desc);
                        
            v_erro_codi := 10;            
            raise salir;   
            
      end if;

      if v_movi_timo_codi = 28 and v_movi_apci_codi is not null then
        
        select apci.apci_esta 
          into v_apci_esta 
          from come_aper_cier_caja apci 
         where apci_codi =  v_movi_apci_codi;
        
        if nvl(v_apci_esta, 'P') = 'C' then
          
            pp_get_erro(i_resp_codi => 11,
                        i_resp_orig => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc => v_erro_desc);
                        
            v_erro_codi := 11;            
            raise salir;   
            
        end if;
      end if;

      if v_movi_apci_codi is not null then
        
        select apci.apci_esta 
          into v_apci_esta 
          from come_aper_cier_caja apci 
         where apci_codi =  v_movi_apci_codi;
         
        if nvl(v_apci_esta, 'P') = 'C' then
          
            pp_get_erro(i_resp_codi => 11,
                        i_resp_orig => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc => v_erro_desc);
                        
            v_erro_codi := 11;            
            raise salir;   
        
        end if;
      end if;
  
 exception 
   when salir then 
     o_resp_codi := v_erro_codi;
     o_resp_desc := v_erro_desc;
   when others then 
     o_resp_codi := v_erro_codi;
     o_resp_desc := v_erro_desc; 
      
    end pp_vali_movi_post;
    
  --Validando fecha..  
  procedure pp_vali_fech(i_fech     in date,
                        o_resp_codi out number,
                        o_resp_desc out varchar2) is
   begin
     
    setitem('P34_PROGRESS_BAR_PORC', 15);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando fecha..');

    pa_devu_fech_habi(p_fech_inic, p_fech_fini );
   
   
  if i_fech not between p_fech_inic and p_fech_fini  then 
            pp_get_erro(i_resp_codi => 12,
                        i_resp_orig => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc => v_erro_desc);
                        
            v_erro_desc :=  replace(replace(v_erro_desc,'P_FECHA1',p_fech_inic),'P_FECHA2',p_fech_fini);
            v_erro_codi := 12;
            
            raise salir; 
  	              
  end if;	
 
 
 exception 
  when salir then
    o_resp_desc := v_erro_desc;
    o_resp_codi := v_erro_codi;
  when others  then
    raise_application_error(-20010, sqlerrm);
  
 end pp_vali_fech;
 
  --Validando Factura Electronica..
  procedure pp_vali_fact_elec(i_tipo_movi in number,
                             i_fech      in date,
                             o_resp_codi out number,
                             o_resp_desc out varchar2) is
   begin
     
   setitem('P34_PROGRESS_BAR_PORC', 17);
   setitem('P34_PROGRESS_BAR_DESC', 'Validando Factura Electronica..');
   
       if i_tipo_movi in (1,2,9) and user <> 'SKN' then
        if i_fech < trunc(sysdate)-2 then 
            pp_get_erro(i_resp_codi => 13,
                            i_resp_orig => 1,
                            i_resp_segu_pant => 116,
                            o_resp_desc => v_erro_desc);
                            
                v_erro_codi := 13;
                
                raise salir;   

          raise salir;                 
        end if; 
      end if; 
 exception      
   when salir then
    o_resp_desc := v_erro_desc;
    o_resp_codi := v_erro_codi;     
  when others then 
    o_resp_desc := 'Error en Factura Electronica: '||sqlcode;
    o_resp_codi := 1000;  
 end pp_vali_fact_elec;
   
  --Validando secuencia de inmuebles..
  procedure pp_vali_inmu_esta(i_movi_codi in number,
                             o_resp_codi out number,
                             o_resp_desc out varchar2) is

  v_moin_secu      number;
  v_moin_inmu_codi number;
  v_max_moin_secu  number;

begin
  
    setitem('P34_PROGRESS_BAR_PORC', 19);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando secuencia de inmuebles..');
  

  select moin_secu, moin_inmu_codi
    into v_moin_secu, v_moin_inmu_codi
    from come_movi_inmu_esta
   where moin_movi_codi = i_movi_codi;

  if v_moin_inmu_codi is not null then
  
    select max(moin_secu)
      into v_max_moin_secu
      from come_movi_inmu_esta
     where moin_inmu_codi = v_moin_inmu_codi;
  
    if v_max_moin_secu = v_moin_secu then
      null;
    else
       pp_get_erro(i_resp_codi => 13,
                   i_resp_orig => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc => v_erro_desc);
                            
      v_erro_codi := 13;
      raise salir;
      
    end if;
  end if;

exception
  when salir then 
    o_resp_codi := v_erro_codi;
    o_resp_desc := v_erro_desc;
  when others then
    null;
end pp_vali_inmu_esta;      
 
  --Validando Cobro Diferido
  procedure pp_vali_cobr_dife(i_movi_indi_cobr_dife in varchar2,
                             o_resp_codi            out number,
                             o_resp_desc            out varchar2) is
   begin
     
    setitem('P34_PROGRESS_BAR_PORC', 20);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Cobro diferido..');  
     
   if nvl(i_movi_indi_cobr_dife, 'N') =  'C' then 
       pp_get_erro(i_resp_codi => 15,
                   i_resp_orig => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc => v_erro_desc);
                            
      v_erro_codi := 15;
      raise salir;
   end if;
   
   exception 
     when salir then 
        o_resp_desc := v_erro_desc;
        o_resp_codi := v_erro_codi;
      when others then 
        o_resp_desc := 'Error al momento de Validad Cobro en diferido: '||sqlcode;
        o_resp_codi := 1000;   
   end pp_vali_cobr_dife;
 
  --Validando Asientos 
  procedure pp_vali_asie(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
    cursor c_deta_asien is
    select taax_c001 codi,
           taax_c002 tipo,
           taax_c003 numero,
           taax_c004 fech,
           taax_c005 obs
      from come_tabl_auxi
    where taax_user = v('APP_USER')
      and taax_sess = p_session; 
  
   begin
   
    setitem('P34_PROGRESS_BAR_PORC', 22);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Asientos..');  
   
    I020213.pp_carg_asie(i_movi_codi => i_movi_codi);
 
 for x in c_deta_asien loop
  if x.codi is not null and nvl(x.tipo, 'A') <> 'M' then
    
       pp_get_erro(i_resp_codi => 61,
                   i_resp_orig => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc => v_erro_desc);
                            
      v_erro_codi := 61;
      raise salir;
      
  end if;
 end loop;
 
  exception 
     when salir then 
        o_resp_desc := v_erro_desc;
        o_resp_codi := v_erro_codi;
      when others then 
        o_resp_desc := 'Error al momento de Validar Asientos: '||sqlcode;
        o_resp_codi := 1000;  
   
   end pp_vali_asie;
   
  --Validando permisos de usuarios..
  procedure pp_vali_perm_usua(i_movi_oper_codi in number,
                             i_movi_timo_codi in number,
                             o_resp_codi      out number,
                             o_resp_desc      out varchar2) is
   
   v_indi_borra varchar2(5);
   
   begin
    
    setitem('P34_PROGRESS_BAR_PORC', 24);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando permisos de usuarios..');  
  
  IF i_MOVI_OPER_CODI IS NOT NULL THEN
    
  
    begin
      general_skn.pl_vali_user_stoc_oper(p_oper_codi  => i_MOVI_OPER_CODI,
                                         p_indi_si_no => v_indi_borra);
    end;

    if UPPER(RTRIM(LTRIM(v_indi_borra))) = 'N' then 
      
       pp_get_erro(i_resp_codi      => 16,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
                            
       v_erro_codi := 16;      
       raise salir;
    
    end if;
  
   if i_movi_timo_codi is not null then 
     begin
        general_skn.pl_vali_user_tipo_movi(p_timo_codi  => i_movi_timo_codi,
                                           p_indi_si_no => v_indi_borra);
     end;

    if UPPER(RTRIM(LTRIM(v_indi_borra))) = 'N' then 
      
       pp_get_erro(i_resp_codi      => 17,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
                            
       v_erro_codi := 17;      
       raise salir;
    
    end if;
    
   end if;
   
 end if;
  
 exception 
     when salir then 
        o_resp_desc := v_erro_desc;
        o_resp_codi := v_erro_codi;  
     when others then 
        o_resp_desc := 'Error en validacion de Permiso de Usuario: '||sqlcode;
        o_resp_codi := 1000;
        
  end pp_vali_perm_usua;  
   
  --Validando documento padre..
  procedure pp_vali_docu_padr(i_movi_codi_PADR in number,
                             o_resp_codi      out number,
                             o_resp_desc      out varchar) is
   
    v_oper_desc_padr  varchar2(500);
    v_timo_desc_padre varchar2(500);
    v_movi_nume_padr  come_movi.movi_nume%type;
    v_timo_tico_codi  come_tipo_movi.timo_tico_codi%type;
   
   begin
     
    setitem('P34_PROGRESS_BAR_PORC', 26);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando documento padre..');    
   
  if i_movi_codi_padr is not null then
    
    begin
      v_oper_desc_padr  := ' ';
      v_timo_desc_padre := ' ';
    
      select oper_desc, movi_nume, timo_desc, timo_tico_codi
        into v_oper_desc_padr,
             v_movi_nume_padr,
             v_timo_desc_padre,
             v_timo_tico_codi
        from come_movi, come_stoc_oper, come_tipo_movi
       where movi_timo_codi = timo_codi(+)
         and movi_oper_codi = oper_codi(+)
         and movi_codi = i_movi_codi_padr;
    
      if v_timo_tico_codi = 4 then
        begin
          select count(*)
            into v_count
            from come_movi_cheq
           where chmo_movi_codi = i_movi_codi_padr;
           
          if v_count > 0 then
          
            pp_get_erro(i_resp_codi      => 18,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
            
            v_erro_desc :=  replace(v_erro_desc, 'P_CANT', v_count);             
            v_erro_codi := 18;      
            raise salir;  
            
          end if;
          
        end;
      
      else
        
            pp_get_erro(i_resp_codi      => 19,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
            
            v_erro_desc :=  replace(replace(replace(v_erro_desc, 'P_OPER_DESC', rtrim(ltrim(v_oper_desc_padr))),'P_NUME_PADRE' , to_char(v_movi_nume_padr)),'P_TICO_DESC' ,rtrim(ltrim(v_timo_desc_padre)));             
            v_erro_codi := 19;      
            raise salir;         
      end if;
    
    exception
      when too_many_rows then
        
            pp_get_erro(i_resp_codi      => 20,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
            
            v_erro_desc := replace(replace(v_erro_desc, 'P_OPER_DESC', rtrim(ltrim(v_oper_desc_padr))),'P_NUME_PADR' , to_char(v_movi_nume_padr));             
            v_erro_codi := 20;      
            raise salir;  
            
       end;
    
  else
    
    begin
      
      select count(*)
        into v_count
        from come_movi_rete
       where more_movi_codi_rete = i_movi_codi_PADR; ----- REEEEEEEEEEEEEEEVISAR ESTO i_movi_codi;
       
      if v_count > 0 then
        
         pp_get_erro(i_resp_codi      => 21,
                     i_resp_orig      => 1,
                     i_resp_segu_pant => 116,
                     o_resp_desc      => v_erro_desc);
                 
            v_erro_codi := 21;      
            raise salir;  

      end if;
      
    end;
  
  end if;
  
 
 exception 
   when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
   when others then 
          pp_get_erro(i_resp_codi      => 22,
                     i_resp_orig      => 1,
                     i_resp_segu_pant => 116,
                     o_resp_desc      => v_erro_desc);
      
      o_resp_codi := 22;
      o_resp_desc := v_erro_desc||' '||sqlcode;
     
   end pp_vali_docu_padr;
   
  --Validando pagares..
  procedure pp_vali_paga(i_movi_codi in number,
                        o_resp_codi out number,
                        o_resp_desc out varchar2) is  
  
  v_copa_nume number;
  
   begin
     -- VALIDAR QUE NO EXISTAN IMPRESIONES DE CONTRATOS Y PAGARES
    setitem('P34_PROGRESS_BAR_PORC', 27);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando pagares..');  
  
  select c.copa_nume
    into v_copa_nume
    from come_cont_paga c, come_cont_paga_deta d
   where c.copa_codi = d.deta_copa_codi
     and d.deta_movi_codi = i_movi_codi
     and rownum = 1;
     

  if v_copa_nume is not null then
    
    pp_get_erro(i_resp_codi      => 23,
                i_resp_orig      => 1,
                i_resp_segu_pant => 116,
                o_resp_desc      => v_erro_desc);
            
       v_erro_desc :=  replace(v_erro_desc, 'P_NRO_PAGA', v_copa_nume);             
       v_erro_codi := 23;      
       raise salir;    
  
  end if;
  
 exception
   when salir then 
       o_resp_codi := v_erro_codi; 
       o_resp_desc := v_erro_desc;     
   when no_data_found then
       null;   
   
 end pp_vali_paga;
  
  --Validando documentos hijos..'
  procedure pp_vali_docu_hijo (i_movi_codi      in number,
                              i_movi_timo_codi in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is

  cursor c_hijos(p_codi in number) is
   select movi_codi 
     from come_movi 
    where movi_codi_padr = p_codi 
   order by movi_codi desc;

  cursor c_nietos(p_codi in number) is
   select movi_codi 
     from come_movi 
    where movi_codi_padr = p_codi 
   order by movi_codi desc;

  --que no se pueda borrar si tiene un hijo de validacion
  cursor c_hijo_vali(p_codi in number) is
    select movi_codi 
      from come_movi 
     where movi_codi_padr_vali = p_codi 
    order by movi_codi desc;
  
  v_o_codi  number;
  v_cont    number;
  
  begin 
    
    setitem('P34_PROGRESS_BAR_PORC', 48);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Documentos Hijos..');  
  
  ---Validar que el movimiento en caso que sea credito, las cuotas no tengan pagos/cance asignados..
  ---O en el caso q sea contado, (si tiene cheques), que los mismos no tengan movimientos posteriores. Ej. un deposito...
  
  for x in c_hijos(i_movi_codi) loop
    
  -- validar cancelacion de hijos  
    begin
      I020213.pp_vali_movi_canc(i_movi_codi      => x.movi_codi,
                                i_movi_codi_padr => i_movi_codi,
                                o_codi           => v_o_codi);
    
  
    if v_o_codi in (1,2) then                                 
       v_erro_codi := 24;    
       pp_get_erro(i_resp_codi      => 24,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
        
      raise salir;
    end if;
    
    end;
    
    if i_movi_timo_codi <> 78 then
      
       select count(*)
        into v_cont
        from come_movi_cuot_pres_canc
       where canc_cupe_movi_codi = x.movi_codi;  
    
      if v_cont > 0 then
        v_erro_codi := 25; 
        pp_get_erro(i_resp_codi      => 25,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc); 
        raise salir;      
      end if;
      
    end if;
    
   -- Planilla chica de cobradores    
    begin
      
       select count(*)
       into v_cont
       from come_cobr_cred_deta
       where deta_movi_codi = x.movi_codi
         and deta_indi_pago = 'S';

      if nvl(p_indi_perm_borr_reci_plan_cer,'N') = 'N' then
        if v_cont > 0 then  
         pp_get_erro(i_resp_codi      => 26,
                     i_resp_orig      => 1,
                     i_resp_segu_pant => 116,
                     o_resp_desc      => v_erro_desc);   
         v_erro_codi := 26;
         raise salir;
        end if;  
      end if;  
      
    end;
       
   -- Planilla chica de clientes
    begin     
           
       select count(*)
       into v_cont
       from come_cobr_clie_deta
       where deta_movi_codi = x.movi_codi
         and deta_indi_pago = 'S';

      if nvl(p_indi_perm_borr_reci_plan_cer,'N') = 'N' then
        if v_cont > 0 then    
          pp_get_erro(i_resp_codi      => 27,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc); 
          v_erro_codi := 27;
          raise salir;
        end if;  
      end if;  

    end;
    
  --validar que los cheques relacionados con el documento, no posea operaciones posteriores.....................   
  -- cheques
    begin
       I020213.pp_vali_cheq(i_movi_codi => x.movi_codi,
                            o_erro_desc => v_erro_desc,
                            o_erro_codi => v_erro_codi);
    
    if v_erro_codi = 28 then       
      raise salir;
    end if;
    
    end;
 
  -- cheques diferidos
    begin
        I020213.pp_vali_cheq_dife(i_movi_codi => x.movi_codi,
                                  o_erro_desc => v_erro_desc,
                                  o_erro_codi => v_erro_codi);
    
    if v_erro_codi = 29 then 
      raise salir;
    end if;   
    
    end;

  -- validacion de retencion      
    begin
      I020213.pp_vali_rete(i_movi_codi => x.movi_codi,
                           o_erro_desc => v_erro_desc,
                           o_erro_codi => v_erro_codi);
    
    if v_erro_codi = 30 then 
      raise salir;
    end if;
    
    end;

  -- validacion de cupo de tarjeta
    begin
      I020213.pp_vali_tarj_cupo(i_movi_codi => x.movi_codi,
                                o_erro_desc => v_erro_desc,
                                o_erro_codi => v_erro_codi);
                              
     if v_erro_codi = 31 then 
      raise salir;
     end if;
    end;

  --descuentos de cheques - factura interes. 
    begin
       I020213.pp_vali_fact_depo(i_movi_codi => x.movi_codi,
                                 o_erro_desc => v_erro_desc,
                                 o_erro_codi => v_erro_codi);
     
     if v_erro_codi = 32 then 
      raise salir;
     end if;
     
    end;
 
  --validacion de OP.
    begin
      I020213.pp_vali_orde_pago(i_movi_codi => x.movi_codi,
                                o_erro_desc => v_erro_desc,
                                o_erro_codi => v_erro_codi);
    
     if v_erro_codi = 33 then 
      raise salir;
     end if;
     
    end;   
     
  -- validar que no existan impresiones de contratos y pagares
    declare 
     v_copa_nume come_cont_paga.copa_nume%type;
     begin
      select c.copa_nume
        into v_copa_nume
        from come_cont_paga c, come_cont_paga_deta d
       where c.copa_codi = d.deta_copa_codi
         and d.deta_movi_codi = x.movi_codi
         and rownum = 1;

      if v_copa_nume is not null then
        
       pp_get_erro(i_resp_codi      => 35,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
            
              v_erro_desc :=  replace(v_erro_desc, 'P_NUME_CHEQ', v_copa_nume);             
              v_erro_codi := 35;  
              
         raise salir;
      end if;
    exception
      when no_data_found then
        null;
    end;
           
  --Validando secuencia de inmuebles..'        
    declare

    v_moin_secu      number;
    v_moin_inmu_codi number;  
    v_max_moin_secu  number;
  
  begin
  
    select moin_secu, moin_inmu_codi
      into v_moin_secu, v_moin_inmu_codi
      from come_movi_inmu_esta
     where moin_movi_codi = x.movi_codi;   
  
  if v_moin_inmu_codi is not null then  
  
      select max(moin_secu)
        into v_max_moin_secu
        from come_movi_inmu_esta
       where moin_inmu_codi = v_moin_inmu_codi;
              
      if v_max_moin_secu = v_moin_secu then
          null;
      else   
       pp_get_erro(i_resp_codi      => 36,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
                              
         v_erro_codi := 36;       
         raise salir;  
      end if;
   end if; 
  
 exception
    when no_data_found then
      null;        
 end;      
     
    
  for y in c_nietos(x.movi_codi) loop    
   -- cancelaciones
   begin
    I020213.pp_vali_movi_canc(i_movi_codi      => y.movi_codi,
                              i_movi_codi_padr => x.movi_codi,
                              o_codi           => v_o_codi);
    
  
    if v_o_codi in (1,2) then 
       pp_get_erro(i_resp_codi      => 24,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);                                
       v_erro_codi := 24;     
       raise salir;
    end if;  
   end;
   
   -- cheques
    begin
       I020213.pp_vali_cheq(i_movi_codi => y.movi_codi,
                            o_erro_desc => v_erro_desc,
                            o_erro_codi => v_erro_codi);
    
    if v_erro_codi = 28 then 
      raise salir;
    end if;
    
    end;
 
  -- cheques diferidos
    begin
        I020213.pp_vali_cheq_dife(i_movi_codi => y.movi_codi,
                                  o_erro_desc => v_erro_desc,
                                  o_erro_codi => v_erro_codi);
    
    if v_erro_codi = 29 then 
      raise salir;
    end if;   
    
    end;

  -- validacion de retencion      
    begin
      I020213.pp_vali_rete(i_movi_codi => y.movi_codi,
                           o_erro_desc => v_erro_desc,
                           o_erro_codi => v_erro_codi);
    
    if v_erro_codi = 30 then 
      raise salir;
    end if;
    
    end;
   
  --descuentos de cheques - factura interes. 
    begin
       I020213.pp_vali_fact_depo(i_movi_codi => y.movi_codi,
                                 o_erro_desc => v_erro_desc,
                                 o_erro_codi => v_erro_codi);
     
     if v_erro_codi = 32 then 
      raise salir;
     end if;
     
    end; 
     
  -- validacion de cupo de tarjeta
    begin
      I020213.pp_vali_tarj_cupo(i_movi_codi => y.movi_codi,
                                o_erro_desc => v_erro_desc,
                                o_erro_codi => v_erro_codi);
                              
     if v_erro_codi = 31 then 
      raise salir;
     end if;
    end;


  --validacion de OP.
    begin
      I020213.pp_vali_orde_pago(i_movi_codi => y.movi_codi,
                                o_erro_desc => v_erro_desc,
                                o_erro_codi => v_erro_codi);
    
     if v_erro_codi = 33 then 
      raise salir;
     end if;
     
    end;      
      
  -- validar que no existan impresiones de contratos y pagares
    declare 
     v_copa_nume come_cont_paga.copa_nume%type;
     begin
      select c.copa_nume
        into v_copa_nume
        from come_cont_paga c, come_cont_paga_deta d
       where c.copa_codi = d.deta_copa_codi
         and d.deta_movi_codi = x.movi_codi
         and rownum = 1;

      if v_copa_nume is not null then
        
       pp_get_erro(i_resp_codi      => 35,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
            
              v_erro_desc :=  replace(v_erro_desc, 'P_NUME_CHEQ', v_copa_nume);             
              v_erro_codi := 35;  
              
         raise salir;
      end if;
    exception
      when no_data_found then
        null;
    end;
        
    end loop;
    
  end loop;

 exception 
   when salir then 
     o_resp_codi := v_erro_codi;
     o_resp_desc := v_erro_desc;
   when others then 
     o_resp_codi := 1000;
     o_resp_desc := 'Error al momento de Validacion de Documento Hijo:'||sqlcode;  
 end pp_vali_docu_hijo;

  --Validado OTs
  procedure pp_vali_OTs(i_movi_ortr_codi in number,
                       i_ortr_nume      in number,
                       o_resp_codi      out number,
                       o_resp_desc      out varchar2) is
   
  v_ortr_fech_liqu  come_orde_trab.ortr_fech_liqu%type;
 
 begin
    setitem('P34_PROGRESS_BAR_PORC', 29);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando OTs..');  

  -- si esta relacionado a una O.T., verificar que no se pueda anular si la O.T. esta liquidada
  
  if i_movi_ortr_codi is not null then
    begin
      select ortr_fech_liqu
        into v_ortr_fech_liqu
        from come_orde_trab
       where ortr_codi = i_movi_ortr_codi;
    
      if v_ortr_fech_liqu is not null then
              
       pp_get_erro(i_resp_codi      => 37,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
            
              v_erro_desc :=  replace(v_erro_desc, 'P_NRO', i_ortr_nume);             
              v_erro_codi := 37;  
              raise salir;
      end if;
    end;
  end if;
  exception 
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error al momento de validar OT: '||sqlcode;
 end pp_vali_OTs;

  --Validando Documentos hijos de validacion..
  procedure pp_vali_docu_hi2(i_movi_codi in number,
                            o_resp_codi out number,
                            o_resp_desc out varchar2) is
   
   
     --que no se pueda borrar si tiene un hijo de validacion
  cursor c_hijo_vali(p_codi in number) is
   select movi_codi 
     from come_movi 
    where movi_codi_padr_vali = p_codi 
   order by movi_codi desc;
   
   v_movi_nume_hijo come_movi.movi_nume%type;
   v_oper_desc_hijo come_stoc_oper.oper_desc_abre%type;
   
   begin
     
    setitem('P34_PROGRESS_BAR_PORC', 30);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Documentos hijos de validacion..');  
    
  
  for x in c_hijo_vali(i_movi_codi) loop
    
    begin
      select movi_nume, nvl(oper_desc_abre, ' ')
        into v_movi_nume_hijo, v_oper_desc_hijo
        from come_movi, come_stoc_oper
       where movi_oper_codi = oper_codi(+)
         and movi_codi = x.movi_codi;
    
    
     pp_get_erro(i_resp_codi        => 38,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
            
              v_erro_desc :=  replace(v_erro_desc, 'P_NRO', v_movi_nume_hijo||' '||v_oper_desc_hijo||'.');             
              v_erro_codi := 38;  
              raise salir;
    
    exception
      when salir then 
        o_resp_codi := v_erro_codi;
        o_resp_desc := v_erro_desc;
      when too_many_rows then
        o_resp_codi := v_erro_codi;
        o_resp_desc := v_erro_desc;
      when others then
        o_resp_codi := 1000;
        o_resp_desc := 'Error en validacion de documentos hijo 2: '||sqlcode;
    end;
  end loop;
   
 end pp_vali_docu_hi2;

  -- Validacion consumo interno y  Nota de devolucion...
  procedure pp_vali_cons_nota_devu (i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is

  v_movi_codi_cons_inte come_movi.movi_codi_padr_vali%type;
  v_cant_node           number;
  v_node_nume           come_nota_devu.node_nume%type;
  v_node_fech_emis      come_nota_devu.node_fech_emis%type;
  
  begin
    
    setitem('P34_PROGRESS_BAR_PORC', 33);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Nota de Devolucion...');     
    
        ---consumo interno
        begin   
          select movi_codi_padr_vali
            into v_movi_codi_cons_inte
                from come_movi
             where movi_timo_codi = 35
              and movi_codi = i_movi_codi;
              
          update come_movi 
             set movi_indi_pago_cons_inte = 'N'
           where movi_codi = v_movi_codi_cons_inte;
           
        exception
          when others then
           v_movi_codi_cons_inte := null;
        end;
 
-- Nota de devolucion

      select count(*)
        into v_cant_node
        from come_nota_devu nd
       where nd.node_fact_codi = i_movi_codi;
    
      if v_cant_node > 0 then
        begin
          select node_nume, node_fech_emis
            into v_node_nume, v_node_fech_emis
            from come_nota_devu nd
           where nd.node_fact_codi = i_movi_codi;
        
        
       pp_get_erro(i_resp_codi      => 39,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
            
              v_erro_desc :=  replace(replace(v_erro_desc, 'P_NRO', v_node_nume), 'P_FECHA', to_char(v_node_fech_emis, 'dd-mm-yyyy'));             
              v_erro_codi := 39;  
              raise salir;
        end;
      end if;  
 
    
   exception
      when salir then 
         o_resp_codi := v_erro_codi;
         o_resp_desc := v_erro_desc;  
      when no_data_found then
        null;
      when too_many_rows then
         pp_get_erro(i_resp_codi      => 39,
                     i_resp_orig      => 1,
                     i_resp_segu_pant => 116,
                     o_resp_desc      => v_erro_desc);
            
           v_erro_desc :=  replace(replace(v_erro_desc, 'P_NRO', v_node_nume), 'P_FECHA', to_char(v_node_fech_emis, 'dd-mm-yyyy'));             
           v_erro_codi := 39; 
              
           o_resp_codi := v_erro_codi;
           o_resp_desc := v_erro_desc;
           
       when others then 
         pp_get_erro(i_resp_codi      => 39,
                     i_resp_orig      => 1,
                     i_resp_segu_pant => 116,
                     o_resp_desc      => v_erro_desc);
            
           v_erro_desc :=  replace(replace(v_erro_desc, 'P_NRO', v_node_nume), 'P_FECHA', to_char(v_node_fech_emis, 'dd-mm-yyyy'));             
           v_erro_codi := 39; 
              
           o_resp_codi := v_erro_codi;
           o_resp_desc := v_erro_desc;  
   
 end pp_vali_cons_nota_devu;

  --Validando Conciliacion Bancaria..
  procedure pp_vali_conc_banc (i_movi_codi in number,
                               o_resp_codi out number,
                               o_resp_desc out varchar2) is
                               
   v_cuen_codi number; 
   begin
      
    setitem('P34_PROGRESS_BAR_PORC', 35);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Conciliacion Bancaria..');  
  
   select max(moim_cuen_codi)
     into v_cuen_codi
     from come_movi_impo_deta
    where moim_movi_codi = i_movi_codi
      and moim_indi_conc = 'S';

   if v_cuen_codi is not null then
     
    pp_get_erro(i_resp_codi      => 40,
                i_resp_orig      => 1,
                i_resp_segu_pant => 116,
                o_resp_desc      => v_erro_desc);
            
       v_erro_desc :=  replace(v_erro_desc, 'P_CAJA', v_cuen_codi);             
       v_erro_codi := 40;      
       raise salir;    
       
   end if;	 
  
  
exception 
  when salir then 
    o_resp_codi := v_erro_codi;
    o_resp_desc := v_erro_desc;
  when others then 
    o_resp_codi := 1000;
    o_resp_desc := 'Error al momento de validar conciliacion bancaria: '||sqlcode;
  
  end pp_vali_conc_banc;

  --Validando cancelacion de cuotas..
  procedure pp_vali_canc_cuot (i_movi_timo_codi in number,
                              i_movi_codi      in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
   v_resp_desc varchar2(5000);
   v_resp_codi number;
   
   begin
     
    setitem('P34_PROGRESS_BAR_PORC', 40);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cancelacion de cuotas..');  

  --devolucion de adelantos de clientes y prov 
  if i_movi_timo_codi not in  (56,57) then  
  
   I020213.pp_vali_movi_canc(i_movi_codi, i_movi_codi, v_resp_codi, v_resp_desc);
     
     if v_resp_codi is not null then 
       raise salir;
     elsif v_resp_codi is null then 
       o_resp_codi :=  null;
       o_resp_desc := null;
     end if;
   
  end if;
  
 exception
   when salir then 
     o_resp_codi := v_resp_codi;
     o_resp_desc := v_resp_desc;
   when others then   
     o_resp_codi := 1000;
     o_resp_desc := 'Error en Validacion de Cancelacion de Cuotas: '||sqlcode;    
   
  
 end pp_vali_canc_cuot;

  --Validando cancelacion de prestamos..
  procedure pp_vali_canc_pres (i_movi_timo_codi in number,
                              i_movi_codi      in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
   
  v_cont  number;
  begin
    setitem('P34_PROGRESS_BAR_PORC', 42);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cancelacion de prestamos..');   
    

  if i_movi_timo_codi <> 78 then
   
     select count(*)
       into v_cont
       from come_movi_cuot_pres_canc
      where canc_cupe_movi_codi = i_movi_codi;

     if v_cont > 0 then 
       
         pp_get_erro(i_resp_codi      => 25,
                     i_resp_orig      => 1,
                     i_resp_segu_pant => 116,
                     o_resp_desc      => v_erro_desc);
                        
         v_erro_codi := 25;      
         raise salir; 
         
       end if;	
  end if; 
  
  exception 
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc; 
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error al momento de validar cancelacion de prestamos: '||sqlcode;

 end pp_vali_canc_pres;

  --Validando logistica..
  procedure pp_vali_logi_entr(i_movi_codi in number,
                             o_resp_codi out number,
                             o_resp_desc out varchar2) is 
     
   	v_count number := 0;
    
  begin
    
    setitem('P34_PROGRESS_BAR_PORC', 43);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando logistica..');   
  
  select count(ende_deta_movi_codi)
    into v_count
    from come_entr_sali_deta
   where ende_deta_movi_codi = i_movi_codi;
  
  if v_count > 0 then
     pp_get_erro(i_resp_codi      => 41,
                 i_resp_orig      => 1,
                 i_resp_segu_pant => 116,
                 o_resp_desc      => v_erro_desc);
                       
       v_erro_codi := 41;      
       raise salir;     
   end if;	 
  
 exception 
   when salir then 
     o_resp_codi := v_erro_codi;
     o_resp_desc := v_erro_desc;   
   when others then 
     o_resp_codi := 1000;
     o_resp_desc := 'Error en validacion de logistica entrada: '||sqlcode;
  
   end pp_vali_logi_entr;
  
  --Validando cancelacion de adelantos..
  procedure pp_vali_canc_adel(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  v_cont number;  
  begin
    
    setitem('P34_PROGRESS_BAR_PORC', 44);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cancelacion de adelantos..'); 
  
   select count(*)
     into v_cont
     from come_movi_adel_prod_canc
    where canc_movi_codi_adel = i_movi_codi;

   if v_cont > 0 then
	     pp_get_erro(i_resp_codi      => 25,
                   i_resp_orig      => 1,
                   i_resp_segu_pant => 116,
                   o_resp_desc      => v_erro_desc);
                      
       v_erro_codi := 25;      
       raise salir;   

   end if;	 
  
  
   Exception 
   	  when salir then
       o_resp_codi := v_erro_codi;
       o_resp_desc := v_erro_desc;
      when others then 
       o_resp_codi := 1000;
       o_resp_desc := 'Error en Validacion de Cancelacion de Adelantos: '||sqlcode;

  end pp_vali_canc_adel;
  
  --Validando carga de camion..
  procedure pp_vali_carg_cami(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    
      cursor c_carg_movi is
    select c.carg_codi, c.carg_nume, mc.camo_carg_secu
      from come_movi_carg mc, come_carg_cami c
     where mc.camo_carg_codi = c.carg_codi
       and mc.camo_movi_codi = i_movi_codi;

      v_count number;
      
      begin
  
    setitem('P34_PROGRESS_BAR_PORC', 45);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando carga de camion..'); 
    
  -- validar que las cargas relacionados con el documento, no posea operaciones posteriores.........

      for x in c_carg_movi loop
        
        select count(*)
          into v_count
          from come_movi_carg
         where camo_carg_codi = x.carg_codi;
      
        if v_count > x.camo_carg_secu then
          
           pp_get_erro(i_resp_codi      => 42,
                       i_resp_orig      => 1,
                       i_resp_segu_pant => 116,
                       o_resp_desc      => v_erro_desc);
            
          v_erro_desc :=  replace(v_erro_desc, 'P_NRO', x.carg_nume);             
          v_erro_codi := 42;      
          raise salir;   

        end if;
      end loop;

    exception
      when salir then
        o_resp_codi := v_erro_codi;
        o_resp_desc := v_erro_desc;
      when others then 
        o_resp_codi := 1000;
        o_resp_desc := 'Error al momento de validar Carga Camiones: '||sqlcode;
        
  end pp_vali_carg_cami;

  --Validando cheques Gral..
  procedure pp_vali_cheq_gral(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
    
    v_erro_desc varchar2(5000);
    v_erro_codi number;
    
    begin
  
  
    setitem('P34_PROGRESS_BAR_PORC', 48);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cancelacion de prestamos..');   
  --validar que los cheques relacionados con el documento, no posea operaciones posteriores.....................   
  -- cheques
    begin
       I020213.pp_vali_cheq(i_movi_codi => i_movi_codi,
                            o_erro_desc => v_erro_desc,
                            o_erro_codi => v_erro_codi);
    
    if v_erro_codi = 28 then       
      raise salir;
    end if;
    
    end;
 
  -- cheques diferidos
    begin
        I020213.pp_vali_cheq_dife(i_movi_codi => i_movi_codi,
                                  o_erro_desc => v_erro_desc,
                                  o_erro_codi => v_erro_codi);
    
    if v_erro_codi = 29 then 
      raise salir;
    end if;   
    
    end;
 
 exception 
   when salir then 
     o_resp_codi := v_erro_codi;
     o_resp_desc := v_erro_desc;
   when others then 
     o_resp_codi := 1000;
     o_resp_desc := 'Error en validacion de Cheques/Cheques Diferidos: '||sqlcode;    
  
  end pp_vali_cheq_gral;
  
  --Validando retenciones..
  procedure pp_vali_rete_gral(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is 
    v_erro_codi number;
    v_erro_desc varchar2(5000);
    begin
 
    setitem('P34_PROGRESS_BAR_PORC', 50);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cancelacion de prestamos..');   
 
   I020213.pp_vali_rete(i_movi_codi => i_movi_codi,
                        o_erro_desc => v_erro_desc,
                        o_erro_codi => v_erro_codi);
 
   if v_erro_codi is not null then 
     raise salir;
   end if;
 
 exception 
   when salir then 
     o_resp_codi := v_erro_codi;
     o_resp_desc := v_erro_desc;
   when others then 
     o_resp_codi := 1000;
     o_resp_desc := 'Error en validacion de retenecion gral: '||sqlcode;

 end pp_vali_rete_gral;

  --Validando Facturas de depostio bancario e intereses..';
  procedure pp_vali_fact_depo_gral (i_movi_codi in number,
                                    o_resp_codi out number,
                                    o_resp_desc out varchar2) is
    begin
     
    setitem('P34_PROGRESS_BAR_PORC', 55);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cancelacion de prestamos..');   
    
       I020213.pp_vali_fact_depo(i_movi_codi => i_movi_codi,
                                 o_erro_desc => v_erro_desc,
                                 o_erro_codi => v_erro_codi);
     
     if v_erro_codi = 32 then 
      raise salir;
     end if;
     
  exception 
   when salir then 
     o_resp_codi := v_erro_codi;
     o_resp_desc := v_erro_desc;
   when others then 
     o_resp_codi := 1000;
     o_resp_desc := 'Error en validacion de Facturas con deposito bancarios e intereses: '||sqlcode;
   
 
 end pp_vali_fact_depo_gral;

  --Validando tarjetas de creditos..
  procedure pp_vali_tarj_cred_gral(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is 
    begin  

    setitem('P34_PROGRESS_BAR_PORC', 58);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando tarjetas de creditos..');   

    -- validacion de cupo de tarjeta
    begin
      I020213.pp_vali_tarj_cupo(i_movi_codi => i_movi_codi,
                                o_erro_desc => v_erro_desc,
                                o_erro_codi => v_erro_codi);
                              
     if v_erro_codi = 31 then 
      raise salir;
     end if;
    end;
 
  exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en validacion de tarjetas de creditos: '||sqlcode; 
 end pp_vali_tarj_cred_gral;
 
  --Validando notas de creditos..
  procedure pp_vali_nc(i_movi_codi in number,
                       o_resp_codi out number,
                       o_resp_desc out varchar2) is

--Validar que el detalle de los productos no tngan registros relacionados por ejemplo en el caso de compras, Notas de Creditos.....................
    cursor c_movi(p_movi_codi_cur in number) is
      select movi_nume, 
             movi_timo_codi, 
             movi_oper_codi
        from come_movi, come_movi_prod_deta
       where movi_codi = deta_movi_codi
         and deta_movi_codi_padr = p_movi_codi_cur;

      v_count number;
      
    begin

    setitem('P34_PROGRESS_BAR_PORC', 60);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando NC..');
 
      select count(*)
        into v_count
        from come_movi_prod_deta
       where deta_movi_codi_padr = i_movi_codi;

      if v_count > 0 then
        for x in c_movi(i_movi_codi) loop
 
              
        pp_get_erro(i_resp_codi      => 403,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
            
        v_erro_desc :=  replace(replace(replace(v_erro_desc, 'P_NRO', to_char(x.movi_nume)), 'P_OPER', to_char(x.movi_oper_codi)), 'P_TM', to_char(x.movi_timo_codi));             
        v_erro_codi := 43;      
        raise salir;   

        end loop;      
      end if;

   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en validacion de NC: '||sqlcode;

 end pp_vali_nc;
 
  --Validando Contratos de chacra..
  procedure pp_vali_cont_chac(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    v_count number;
    begin
      
    setitem('P34_PROGRESS_BAR_PORC', 61);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Contratos de chacra..');
    	
     select count(*)
       into v_count
       from come_movi_cont_deta a
      where a.como_movi_codi_desh = i_movi_codi;
      
     if v_count > 0 then
      
        pp_get_erro(i_resp_codi      => 44,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                      
        v_erro_codi := 44;      
        raise salir;   

     end if;	
   
   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Contrato de Chacra: '||sqlcode;
 end pp_vali_cont_chac;
 
  --Validando movimientos de salida de produccion..
  procedure pp_vali_movi_sali_prod(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is

  v_cont number;

    begin

    setitem('P34_PROGRESS_BAR_PORC', 62);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de salida de produccion..'); 

      select count(*)
        into v_cont
        from prod_movi
       where movi_come_codi_sali = i_movi_codi;

    if v_cont > 0 then
      
      pp_get_erro(i_resp_codi      => 46,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
                        
       v_erro_codi := 46;      
       raise salir;   
    end if;

   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Movimiento  de salida de Produccion: '||sqlcode;
      
 end pp_vali_movi_sali_prod;
 
  --Validando movimientos de entrada de produccion..
  procedure pp_vali_movi_entr_prod(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is

  v_cont number;

    begin

    setitem('P34_PROGRESS_BAR_PORC', 62);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 

      select count(*)
        into v_cont
        from prod_movi
       where movi_come_codi_entr = i_movi_codi;

    if v_cont > 0 then
      
      pp_get_erro(i_resp_codi      => 46,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
                       
       v_erro_codi := 46;      
       raise salir;   
    end if;

   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Movimiento de entrada de Produccion: '||sqlcode;
      
 end pp_vali_movi_entr_prod;

  --Validando Limite de costo..
  procedure pp_vali_limi_cost(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is

    cursor c_limi is
     select  ortr_nume
       from come_ortr_limi_cost, come_orde_trab
      where lico_ortr_codi = ortr_codi
        and lico_movi_codi_fact = i_movi_codi
      order by ortr_nume;


   Begin

     setitem('P34_PROGRESS_BAR_PORC', 65);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 

    for x in c_limi loop
    
    pp_get_erro(i_resp_codi      => 46,
                i_resp_orig      => 1,
                i_resp_segu_pant => 116,
                o_resp_desc      => v_erro_desc);
            
       v_erro_desc :=  replace(v_erro_desc, 'P_NRO', x.ortr_nume);             
       v_erro_codi := 46;      
       raise salir;   
 
    end loop;

 exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Limite de Costo: '||sqlcode;
      
 end pp_vali_limi_cost;

  --Validando diferencia de cambios..';
  procedure pp_vali_dife_camb(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    cursor c_dife_camb is
      select  dica_fech_hasta
        from come_movi_dife_camb
       where dica_movi_codi = i_movi_codi
       order by 1;
   begin
     
    setitem('P34_PROGRESS_BAR_PORC', 66);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 
   --validar que la Factura/Adelanto o nota de Credito no posea Diferencia  de Cambio por saldos
     for x in c_dife_camb loop
            pp_get_erro(i_resp_codi      => 47,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
            
       v_erro_desc :=  replace(v_erro_desc, 'P_PERIODO', to_char(x.dica_fech_hasta, 'mm-yyyy'));             
       v_erro_codi := 46;      
       raise salir;  
         
     end loop;
 
 exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Diferencia de Cambio: '||sqlcode;    
  end pp_vali_dife_camb;
  
  --Validando diferencia de cambios de cheques..';
  procedure pp_vali_dife_cheq(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
      cursor c_cheq is
       select cheq_codi, cheq_nume, cheq_fech_emis
         from come_movi_cheq, come_cheq
        where chmo_cheq_codi = cheq_codi
          and chmo_movi_codi = i_movi_codi;

   v_count number;
  begin
    
    setitem('P34_PROGRESS_BAR_PORC', 68);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 
     for x in c_cheq loop
        select count(*)
          into v_count
          from come_cheq_dife_camb
          where dica_cheq_codi = x.cheq_codi;
          
      if v_count > 0 then        
        pp_get_erro(i_resp_codi      => 48,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
            
       v_erro_desc :=  replace(v_erro_desc, 'P_NRO', x.cheq_nume);             
       v_erro_codi := 48;      
       raise salir;   
  
      end if;  
     end loop;	
     
 exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Diferencia de Cheque: '||sqlcode;  

 end pp_vali_dife_cheq;
 
  --Validando plan de facturacion..
  procedure pp_vali_plan_fact(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is 
   v_indi_mail  varchar2(1);
  
 begin

    setitem('P34_PROGRESS_BAR_PORC', 69);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 
    
    select deta_indi_mail
      into v_indi_mail
      from come_fact_auto_deta
     where deta_movi_codi = i_movi_codi;
         
      if nvl(v_indi_mail, 'N') = 'S' then
        pp_get_erro(i_resp_codi      => 49,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                   
       v_erro_codi := 49;      
       raise salir;
      end if;

   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when no_data_found then 
      null;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Plan de Facturacion: '||sqlcode;  
    
 end pp_vali_plan_fact;
 
  --Validando cierre de planilla..
  procedure pp_cier_plan(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is

  v_deta_cocr_codi  number;
  v_deta_nume_item  number;  
  v_count           number;

 begin

    setitem('P34_PROGRESS_BAR_PORC', 70);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 

    begin         
      select deta_cocr_codi
        into v_deta_cocr_codi
        from come_cobr_cred_deta z, come_cobr_cred c
       where cocr_codi = z.deta_cocr_codi
         and z.deta_movi_codi = i_movi_codi
         and nvl(c.cocr_esta, 'P') = 'P'
         and rownum = 1;
         
    exception
      when no_data_found then
         select count(deta_cocr_codi)
           into v_count
           from come_cobr_cred_deta z, come_cobr_cred c
          where cocr_codi = z.deta_cocr_codi
            and z.deta_movi_codi = i_movi_codi
            and nvl(c.cocr_esta, 'P') = 'C';
                        
        if nvl(p_indi_perm_borr_reci_plan_cer,'N') = 'N' then
          if v_count > 0 then             
             pp_get_erro(i_resp_codi      => 50,
                          i_resp_orig      => 1,
                          i_resp_segu_pant => 116,
                          o_resp_desc      => v_erro_desc);
                      
                 v_erro_codi := 50;      
                 raise salir;        
          end if;
        end if;
    end;

   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion en cierre de Planilla Cobradores: '||sqlcode;  
 end pp_cier_plan;
 
  --Validando cierre de planilla de clientes..
  procedure pp_vali_cier_plan_clie(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is

  v_deta_cocl_codi  number;
  v_deta_nume_item  number;  
  v_count           number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 74);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 
  
    begin
      select deta_cocl_codi
        into v_deta_cocl_codi
        from come_cobr_clie_deta z, come_cobr_clie c
       where cocl_codi = z.deta_cocl_codi
         and z.deta_movi_codi_reci = i_movi_codi
         and nvl(c.cocl_esta,'P') = 'P'
         and rownum = 1;
         
    exception
      when no_data_found then
         select count(deta_cocl_codi)
           into v_count
           from come_cobr_clie_deta z, come_cobr_clie c
          where cocl_codi = z.deta_cocl_codi
            and z.deta_movi_codi_reci = i_movi_codi
            and nvl(c.cocl_esta,'P') = 'C'; 
                                  
        if nvl(p_indi_perm_borr_reci_plan_cer,'N') = 'N' then
          if v_count > 0 then
              pp_get_erro(i_resp_codi      => 51,
                          i_resp_orig      => 1,
                          i_resp_segu_pant => 116,
                          o_resp_desc      => v_erro_desc);
                      
                 v_erro_codi := 51;      
                 raise salir;   
               
          end if;
        end if;
    end;

   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion en cierre de Planilla Cliente: '||sqlcode;  
 end pp_vali_cier_plan_clie;

  --Validando viaje..
  procedure pp_vali_viaj(i_movi_codi in number,
                        o_resp_codi out number,
                        o_resp_desc out varchar2) is

     v_count   number := 0;
    begin
      
    setitem('P34_PROGRESS_BAR_PORC', 77);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 
    
      select count(*)
        into v_count
        from come_movi_impo_deta, tran_viaj
       where moim_viaj_codi = viaj_codi
         and viaj_esta = 'L'
         and moim_movi_codi = i_movi_codi;

      if v_count > 0 then
        pp_get_erro(i_resp_codi      => 52,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                      
         v_erro_codi := 52;      
         raise salir;  
      end if;
      
      
   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Viaje: '||sqlcode;  
 
 end pp_vali_viaj;
  
 --Validando orden de pago..';
  procedure pp_vali_OP(i_movi_codi in number,
                       o_resp_codi out number,
                       o_resp_desc out varchar2) is

 --descuentos de cheques - factura interes.
  cursor c_cuot is
    select o.orpa_nume
      from come_orde_pago o, come_orde_pago_deta d
     where o.orpa_codi = d.deta_orpa_codi
       and d.deta_cuot_movi_codi = i_movi_codi;

  cursor c_auto is
    select o.orpa_nume
      from come_orde_pago o, come_orde_pago_deta d, come_orde_pago_auto a
     where o.orpa_codi = d.deta_orpa_codi
     	 and o.orpa_codi = a.auto_orpa_codi
     	 and a.auto_esta = 'A'
       and d.deta_cuot_movi_codi = i_movi_codi;
         	
begin
  
    setitem('P34_PROGRESS_BAR_PORC', 79);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando movimientos de entrada de produccion..'); 

  for k in c_cuot loop
    
   pp_get_erro(i_resp_codi      => 53,
               i_resp_orig      => 1,
               i_resp_segu_pant => 116,
               o_resp_desc      => v_erro_desc);
                    
         v_erro_desc := replace(v_erro_desc, 'P_NRO', k.orpa_nume||'.');          
         v_erro_codi := 53;      
         raise salir;    

  end loop;

  for k in c_auto loop
   pp_get_erro(i_resp_codi      => 53,
               i_resp_orig      => 1,
               i_resp_segu_pant => 116,
               o_resp_desc      => v_erro_desc);
                    
         v_erro_desc := replace(v_erro_desc, 'P_NRO', k.orpa_nume||'.');          
         v_erro_codi := 53;      
         raise salir; 
  end loop;

  exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de OP: '||sqlcode;  

 end pp_vali_OP;
 
 --Validando remisiones..';
  procedure pp_vali_remi(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is 

  v_cont number(2);
  
    begin
    
    setitem('P34_PROGRESS_BAR_PORC', 82);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando remisiones..');   
    
      select count(*)
        into v_cont
        from come_remi r
       where r.remi_come_movi_rece is not null
         and r.remi_movi_codi = i_movi_codi;
      
      if v_cont >= 1 then
        pp_get_erro(i_resp_codi      => 54,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                          
         v_erro_codi := 54;      
         raise salir; 
      end if;
      
   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Remision: '||sqlcode;  
end pp_vali_remi;

 --Ultimas Validaciones Generales 
 procedure pp_vali_rela_OP(i_movi_codi      in number,
                           i_movi_timo_codi in number,
                           o_resp_codi      out number,
                           o_resp_desc      out varchar2) is
                        
   v_orpa_estado come_orde_pago.orpa_estado%type;
   v_cant_auto   number;
   
   begin
     
    setitem('P34_PROGRESS_BAR_PORC', 85);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando relaciones de Orden de Pago..');   
   
  if i_movi_timo_codi = p_codi_timo_orde_pago then
    begin
      select nvl(o.orpa_estado, 'P')
        into v_orpa_estado
        from come_movi m, come_orde_pago o
       where m.movi_orpa_codi = o.orpa_codi
         and m.movi_timo_codi = p_codi_timo_orde_pago
         and m.movi_codi = i_movi_codi;
    
      if v_orpa_estado = 'F' then
       pp_get_erro(i_resp_codi       => 55,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                          
         v_erro_codi := 55;      
         raise salir;   
      end if;
    exception
      when no_data_found then
        null;
    end;

    begin
      select count(*)
        into v_cant_auto
        from come_movi m, come_orde_pago o, come_orde_pago_auto a
       where m.movi_orpa_codi = o.orpa_codi
         and o.orpa_codi = a.auto_orpa_codi
         and m.movi_timo_codi = p_codi_timo_orde_pago
         and m.movi_codi = i_movi_codi
         and nvl(a.auto_esta, 'P') = 'A';
    
      if v_cant_auto > 0 then
        pp_get_erro(i_resp_codi       => 56,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                          
         v_erro_codi := 56;      
         raise salir;   
      end if;
    exception
      when no_data_found then
        null;
    end;
    
  end if;
   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de relacionamiento de OP: '||sqlcode;  
 end pp_vali_rela_OP;
  
 --Validando retencion emitida..
 procedure pp_vali_rete_emit (i_movi_codi      in number,
                              i_movi_timo_codi in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
   
   v_cont number;
   begin
     
    setitem('P34_PROGRESS_BAR_PORC', 88);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando retencion emitida..');  
    
  if i_movi_timo_codi = p_codi_timo_rete_emit then
    
    begin
      select count(*)
        into v_cont
        from come_orde_pago o
       where o.orpa_rete_movi_codi = i_movi_codi;
    
      if nvl(v_cont, 0) > 0 then
        pp_get_erro(i_resp_codi      => 57,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                          
         v_erro_codi := 57;      
         raise salir;  
      end if;
    exception
      when no_data_found then
        null;
    end;
  end if;

   exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de retenciones emitidas: '||sqlcode;  
 end pp_vali_rete_emit;
 
 --Validando desembolso de rrhh..';
 procedure pp_vali_dese_rrhh(i_movi_codi in number,
                             o_resp_codi out number,
                             o_resp_desc out varchar2) is

   v_count number;
   begin
  
     setitem('P34_PROGRESS_BAR_PORC', 90);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando desembolso de rrhh..');  
 
  ---validar que no sea un mov. de desembolso de rrhh
  select count(*)
    into v_count 
    from rrhh_liqu
   where liqu_come_movi_codi = i_movi_codi;
  
  if v_count > 0 then

        pp_get_erro(i_resp_codi      => 58,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                          
         v_erro_codi := 58;      
         raise salir;
         
  end if;	
 
 exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then 
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Desembolso de RRHH: '||sqlcode;  
 end pp_vali_dese_rrhh;
 
 
 /**********************************************************************/
 /************************* SUB  VALIDACIONES  *************************/
 /**********************************************************************/ 
 
  procedure pp_vali_movi_canc(i_movi_codi      in number,
                              i_movi_codi_padr in number,
                              o_codi           out number) is
    v_cont number;
    salir  exception;
  begin

   o_codi :=  0;
   
    select count(*)
      into v_cont
      from come_movi_cuot_canc, come_movi
     where canc_cuot_movi_codi = i_movi_codi
       and movi_codi = canc_movi_codi
       and canc_movi_codi not in
           (select movi_codi
              from come_movi
             where movi_codi = i_movi_codi_padr
                or movi_codi_padr = i_movi_codi_padr);

    if v_cont > 0 then
      o_codi := 1;
    end if;

    select count(*)
      into v_cont
      from roga_cuot_canc
     where canc_cuot_movi_codi = i_movi_codi;

    if v_cont > 0 then
      o_codi := 2;
    end if;

  end pp_vali_movi_canc;
 
  procedure pp_vali_cheq (i_movi_codi in number,
                          o_erro_desc out varchar2,
                          o_erro_codi out number) is
                          
      cursor c_cheq_movi is
        select c.cheq_codi,
               c.cheq_nume,
               b.banc_desc,
               c.cheq_serie,
               mc.chmo_cheq_secu,
               m.movi_cuen_codi_reca,
               m.movi_fech_oper,
               c.cheq_cuen_codi
          from come_movi_cheq mc, come_cheq c, come_banc b, come_movi m
         where mc.chmo_cheq_codi = c.cheq_codi
           and b.banc_codi = c.cheq_banc_codi
           and mc.chmo_movi_codi = m.movi_codi
           and mc.chmo_movi_codi = i_movi_codi;

      cursor c_cheq(p_cheq_codi in number) is
        select i.moim_cuen_codi, i.moim_fech_oper
          from come_movi_impo_deta i
         where i.moim_cheq_codi = p_cheq_codi;

      v_count          number;
      v_caja_cuen_codi number;
      v_caja_fech      date;
      salir            exception;
      
      v_erro_cheq_desc varchar2(1000);

      begin
        for x in c_cheq_movi loop
          
          select count(*)
            into v_count
            from come_movi_cheq
           where chmo_cheq_codi = x.cheq_codi;
        
          if v_count > x.chmo_cheq_secu then
            
           pp_get_erro(i_resp_codi      => 28,
                       i_resp_orig      => 1,
                       i_resp_segu_pant => 116,
                       o_resp_desc      => v_erro_cheq_desc);
            
            o_erro_desc :=  replace(replace(replace(v_erro_cheq_desc, 'P_NUME_CHEQ', x.cheq_nume), 'P_NUME_SERI', x.cheq_serie), 'P_BANC_DESC',x.banc_desc);             
            o_erro_codi := 28;      
            
          end if;
        
       -- esto ya estaba comentado en el mismo Forms Juan Britez 21/02/2022 
        /*if x.movi_cuen_codi_reca is not null then
                  begin
                    select c.caja_cuen_codi, c.caja_fech
                      into v_caja_cuen_codi, v_caja_fech
                      from come_cier_caja c
                     where c.caja_cuen_codi = x.movi_cuen_codi_reca
                       and c.caja_fech = x.movi_fech_oper;
                    
                    if v_caja_cuen_codi is not null then
                      pl_mm('El documento forma parte de un Cierre de Caja de Fecha: ' ||
                            to_char(v_caja_fech, 'dd-mm-yyyy') || ' Caja: ' || v_caja_cuen_codi);
                      pack_general.g_indi_borrado := 'N';
                      raise salir;
                    end if;
                    
                  exception
                    when no_data_found then
                      null;
                  end;
              end if;*/
        
        /*if x.cheq_cuen_codi is not null then
                  begin
                    select c.caja_cuen_codi, c.caja_fech
                      into v_caja_cuen_codi, v_caja_fech
                      from come_cier_caja c
                     where c.caja_cuen_codi = x.cheq_cuen_codi
                       and c.caja_fech = x.movi_fech_oper;
                    
                    if v_caja_cuen_codi is not null then
                      pl_mm('El documento forma parte de un Cierre de Caja de Fecha: ' ||
                            to_char(v_caja_fech, 'dd-mm-yyyy') || ' Caja: ' || v_caja_cuen_codi);
                      pack_general.g_indi_borrado := 'N';
                      raise salir;
                    end if;
                    
                  exception
                    when no_data_found then
                      null;
                  end;
              end if;*/
        
        /*for k in c_cheq(x.cheq_codi) loop
                if k.moim_cuen_codi is not null then
                    begin
                      select c.caja_cuen_codi, c.caja_fech
                        into v_caja_cuen_codi, v_caja_fech
                        from come_cier_caja c
                       where c.caja_cuen_codi = k.moim_cuen_codi
                         and c.caja_fech = k.moim_fech_oper;
                      
                      if v_caja_cuen_codi is not null then
                        pl_mm('El documento forma parte de un Cierre de Caja de Fecha: ' ||
                              to_char(v_caja_fech, 'dd-mm-yyyy') || ' Caja: ' || v_caja_cuen_codi);
                        pack_general.g_indi_borrado := 'N';
                        raise salir;
                      end if;
                      
                    exception
                      when no_data_found then
                        null;
                    end;
                end if;
            end loop;*/
        
        end loop;   

 end pp_vali_cheq;
 
  procedure pp_vali_cheq_dife (i_movi_codi in number,
                               o_erro_desc out varchar2,
                               o_erro_codi out number)is
       
      cursor c_cheq_movi_dife is
      select c.cheq_codi,
             c.cheq_nume,
             b.banc_desc,
             c.cheq_serie,
             mc.chmo_cheq_secu,
             m.movi_cuen_codi_reca,
             m.movi_fech_oper,
             c.cheq_cuen_codi
        from come_movi_cheq mc, come_cheq c, come_banc b, come_movi m, come_movi_dife_camb d
       where mc.chmo_cheq_codi = c.cheq_codi
         and b.banc_codi = c.cheq_banc_codi
         and mc.chmo_movi_codi = m.movi_codi
         and m.movi_codi = d.dica_movi_codi
         and mc.chmo_movi_codi = i_movi_codi;

      v_count           number;
      v_erro_cheq_desc  varchar2(5000);

       begin 
          for x in c_cheq_movi_dife loop
            
            select count(*)
              into v_count    
              from come_movi_cheq
             where chmo_cheq_codi  = x.cheq_codi;
            
            if v_count > 0 then   
              
              pp_get_erro(i_resp_codi      => 29,
                          i_resp_orig      => 1,
                          i_resp_segu_pant => 116,
                          o_resp_desc      => v_erro_cheq_desc);
            
              o_erro_desc :=  replace(replace(replace(v_erro_cheq_desc, 'P_NUME_CHEQ', x.cheq_nume), 'P_NUME_SERI', x.cheq_serie), 'P_BANC_DESC',x.banc_desc);             
              o_erro_codi := 29;  
              
            end if;
          
          end loop; 
        
  end pp_vali_cheq_dife;

  procedure pp_vali_rete(i_movi_codi in number,
                         o_erro_desc out varchar2,
                         o_erro_codi out number) is

      cursor c_rete_movi is
        select r.movi_codi, r.movi_nume, i.moim_cuen_codi, i.moim_fech_oper
          from come_movi_rete      mr,
               come_movi           m,
               come_movi           r,
               come_movi_impo_deta i
         where mr.more_movi_codi = m.movi_codi
           and mr.more_movi_codi_rete = r.movi_codi
           and r.movi_codi = i.moim_movi_codi
           and mr.more_movi_codi = i_movi_codi;

      cursor c_rete is
        select i.moim_cuen_codi, i.moim_fech_oper
          from come_movi_impo_deta i
         where lower(i.moim_tipo) like '%reten%'
           and i.moim_movi_codi = i_movi_codi;

      v_count          number;
      v_caja_cuen_codi number;
      v_caja_fech      date;
      v_erro_cheq_desc varchar2(5000);
      
      salir            exception;

    begin

        for x in c_rete_movi loop      
          if x.moim_cuen_codi is not null then
            begin
              
              select c.caja_cuen_codi, c.caja_fech
                into v_caja_cuen_codi, v_caja_fech
                from come_cier_caja c
               where c.caja_cuen_codi = x.moim_cuen_codi
                 and c.caja_fech = x.moim_fech_oper;
            
              if v_caja_cuen_codi is not null then
                
                 pp_get_erro(i_resp_codi      => 30,
                             i_resp_orig      => 1,
                             i_resp_segu_pant => 116,
                             o_resp_desc      => v_erro_desc);
            
              o_erro_desc :=  replace(replace(v_erro_desc, 'P_FECHA', to_char(v_caja_fech, 'dd-mm-yyyy')), 'P_CAJA', v_caja_cuen_codi);             
              o_erro_codi := 30;  
             
             end if;
            
            exception
              when no_data_found then
                null;
            end;
          end if;
        
        end loop;
      
        for x in c_rete loop
          if x.moim_cuen_codi is not null then
            begin
              
              select c.caja_cuen_codi, c.caja_fech
                into v_caja_cuen_codi, v_caja_fech
                from come_cier_caja c
               where c.caja_cuen_codi = x.moim_cuen_codi
                 and c.caja_fech = x.moim_fech_oper;
            
              if v_caja_cuen_codi is not null then
                
                 pp_get_erro(i_resp_codi      => 30,
                             i_resp_orig      => 1,
                             i_resp_segu_pant => 116,
                             o_resp_desc      => v_erro_cheq_desc);
            
              o_erro_desc :=  replace(replace(v_erro_cheq_desc, 'P_FECHA', to_char(v_caja_fech, 'dd-mm-yyyy')), 'P_CAJA', v_caja_cuen_codi);             
              o_erro_codi := 30;  

              end if;
            
            exception
              when no_data_found then
                null;
            end;
            
          end if;
        end loop;
      

  end pp_vali_rete;
 
  procedure pp_vali_tarj_cupo (i_movi_codi in number,
                               o_erro_desc out varchar2,
                               o_erro_codi out number) is

      cursor c_cupo_movi is
        select mota_tacu_codi, mota_movi_codi, mota_esta_ante, mota_nume_orde
          from come_movi_tarj_cupo, come_tarj_cupo
         where mota_tacu_codi = tacu_codi
           and mota_movi_codi = i_movi_codi;
           
    v_count number;
    salir exception;

    v_movi_codi     number; 
    v_movi_nume     number;
    v_movi_fech     varchar2(20);

    begin
      
      for x in c_cupo_movi loop
        select count(*)
          into v_count    
          from come_movi_tarj_cupo
         where mota_tacu_codi  = x.mota_tacu_codi;
        
        if v_count > x.mota_nume_orde then
          
           begin
             
             select mota_movi_codi
               into v_movi_codi
               from come_movi_tarj_cupo
              where mota_tacu_codi  = x.mota_tacu_codi
                and mota_nume_orde = (select max(mota_nume_orde)
                                        from come_movi_tarj_cupo
                                       where mota_tacu_codi  = x.mota_tacu_codi);
        
             select movi_nume, to_char(movi_fech_emis, 'dd-mm-yyyy')
               into v_movi_nume, v_movi_fech
               from come_movi
              where movi_codi = v_movi_codi;              
              
              pp_get_erro(i_resp_codi      => 31,
                          i_resp_orig      => 1,
                          i_resp_segu_pant => 116,
                          o_resp_desc      => v_erro_desc);
            
              o_erro_desc :=  replace(replace(v_erro_desc, 'P_NRO', v_movi_nume), 'P_FECHA', v_movi_fech);             
              o_erro_codi := 31;  
           end;
           
        end if;
      end loop; 

  end pp_vali_tarj_cupo;
 
  procedure pp_vali_fact_depo (i_movi_codi in number,
                               o_erro_desc out varchar2,
                               o_erro_codi out number )is
    
  cursor c_movi_depo is
    select f.movi_codi, f.movi_nume
      from come_movi f, come_movi_fact_depo fd
     where f.movi_codi = fd.fade_movi_codi_fact -- factura
       and fd.fade_movi_codi_depo = i_movi_codi; -- deposito
             
  v_count number;
      begin
        --- verifica si deposito tiene factura..
        for x in c_movi_depo loop
          select count(*)
            into v_count    
            from come_movi_fact_depo
           where fade_movi_codi_fact  = x.movi_codi;
          
          if nvl(v_count,0) > 0 then                   
                         
              pp_get_erro(i_resp_codi      => 32,
                          i_resp_orig      => 1,
                          i_resp_segu_pant => 116,
                          o_resp_desc      => v_erro_desc);
            
              o_erro_desc := replace(v_erro_desc, 'P_NRO', x.movi_nume);             
              o_erro_codi := 32;  
    
          end if;
        end loop;         

   end pp_vali_fact_depo;
 
  procedure pp_vali_orde_pago(i_movi_codi in number,
                              o_erro_desc out varchar2,
                              o_erro_codi out number) is

      cursor c_cuot is
        select o.orpa_nume
          from come_orde_pago o, come_orde_pago_deta d
         where o.orpa_codi = d.deta_orpa_codi
           and d.deta_cuot_movi_codi = i_movi_codi;

      cursor c_auto is
        select o.orpa_nume
          from come_orde_pago o, come_orde_pago_deta d, come_orde_pago_auto a
         where o.orpa_codi = d.deta_orpa_codi
           and o.orpa_codi = a.auto_orpa_codi
           and a.auto_esta = 'A'
           and d.deta_cuot_movi_codi = i_movi_codi;
           
    begin
            
      for k in c_cuot loop
        
          pp_get_erro(i_resp_codi      => 33,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
            
          o_erro_desc := replace(v_erro_desc, 'P_NRO', k.orpa_nume);             
          o_erro_codi := 33;    

      end loop;

      for k in c_auto loop        
      
          pp_get_erro(i_resp_codi      => 34,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
            
          o_erro_desc := replace(v_erro_desc, 'P_NRO', k.orpa_nume);             
          o_erro_codi := 34;  
          
      end loop;

  end pp_vali_orde_pago;

  procedure pp_vali_movi_canc(i_movi_codi      in number,
                              i_movi_codi_padr in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
    v_cont number;
  begin

    select count(*)
      into v_cont
      from come_movi_cuot_canc, come_movi
     where canc_cuot_movi_codi = i_movi_codi
       and movi_codi = canc_movi_codi
       and canc_movi_codi not in
           (select movi_codi
              from come_movi
             where movi_codi = i_movi_codi_padr
                or movi_codi_padr = i_movi_codi_padr);


    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 24,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
      
      o_resp_codi := 24;
      o_resp_desc := v_erro_desc;
      
    end if;

    select count(*)
      into v_cont
      from roga_cuot_canc
     where canc_cuot_movi_codi = i_movi_codi;

    if v_cont > 0 then
      
      pp_get_erro(i_resp_codi      => 24,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
      
      o_resp_codi := 24;
      o_resp_desc := v_erro_desc;  
    
    end if;


  end pp_vali_movi_canc;


 /**********************************************************************/
 /************************ M O D A L E S *******************************/
 /**********************************************************************/ 
   
 procedure pp_carg_asie (i_movi_codi in number) is

cursor c_movi_asie is
  select moas_asie_codi, moas_tipo
    from come_movi_asie
   where moas_movi_codi = i_movi_codi;
--------
cursor c_movi_cheq is
  select chmo_cheq_codi
    from come_movi_cheq mc
   where chmo_movi_codi = i_movi_codi;

cursor c_movi_cheq_asie (p_cheq_codi in number)is
  select chas_asie_codi
    from come_movi_cheq_asie a
   where chas_chmo_movi_codi = i_movi_codi
     and chas_chmo_cheq_codi = p_cheq_codi;
---------  
cursor c_movi_impo_asie (p_nume_item in number)is
  select asim_asie_codi
    from come_movi_impo_deta_asie
   where asim_movi_codi = i_movi_codi
     and asim_nume_item = p_nume_item;
---------
cursor c_movi_codi_padr is
  select movi_codi_padr
    from come_movi m
   where m.movi_codi = i_movi_codi;

cursor c_movi_impo_asie_02 (p_movi_codi_padr in number, p_nume_item in number)is
  select asim_asie_codi
    from come_movi_impo_deta_asie
   where asim_movi_codi = p_movi_codi_padr
     and asim_nume_item = p_nume_item;
----------
cursor c_movi_cuot_canc is
  select canc_cuot_movi_codi, canc_cuot_fech_venc
    from come_movi m, come_movi_cuot_canc
   where movi_codi = i_movi_codi
     and movi_codi = canc_movi_codi;

cursor c_movi_cuot_canc_asie (p_movi_codi_canc in number, p_fech_venc in date)is
select caas_asie_codi
  from come_movi_cuot_canc_asie
 where caas_canc_movi_codi = i_movi_codi
   and caas_canc_cuot_movi_codi = p_movi_codi_canc
   and caas_canc_cuot_fech_venc = p_fech_venc;
----------     
cursor c_movi_prod_asie (p_nume_item in number)is
  select deas_asie_codi
    from come_movi_prod_deta_asie a
   where deas_movi_codi = i_movi_codi
     and deas_nume_item = p_nume_item;   
----------
cursor c_movi_pres_deve_asie (p_nume_item in number)is
  select deas_asie_codi
    from come_movi_cuot_pres_deve_asie
   where deas_cude_movi_codi = i_movi_codi
     and deas_cude_nume_item = p_nume_item;
----------
cursor c_movi_apli_tick_asie is
  select tias_asie_codi
    from come_movi_apli_tick_asie
   where tias_moti_codi = i_movi_codi;
----------

v_cant_item       number := 0;

begin
 
begin
  pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => p_session, i_taax_user => fp_user);
end;


-----------come_movi_asie-------------------------------  
  for x in c_movi_asie loop
   
   insert into come_tabl_auxi
     (taax_sess, 
      taax_user, 
      taax_seq, 
      taax_c001, 
      taax_c002, 
      taax_c003, 
      taax_c004, 
      taax_c005, 
      taax_c006)
      select p_session, 
             fp_user,
             seq_come_tabl_auxi.nextval, 
             to_char(x.moas_asie_codi), 
             nvl(x.moas_tipo,'A'),
             to_char(asie_nume), 
             to_char(asie_fech_emis), 
             to_char(asie_obse),
             'ASIENTO'
        from come_asie
       where asie_codi = x.moas_asie_codi;

  end loop;
  
-----------come_movi_cheq-------------------------------  
  for y in c_movi_cheq loop 
    for x in c_movi_cheq_asie(y.chmo_cheq_codi)loop
  
  insert into come_tabl_auxi
       (taax_sess, 
      taax_user, 
      taax_seq, 
      taax_c001, 
      taax_c002, 
      taax_c003, 
      taax_c004, 
      taax_c005, 
      taax_c006)
  select p_session, 
             fp_user,
             seq_come_tabl_auxi.nextval, 
             to_char(x.chas_asie_codi), 
             null,
             to_char(asie_nume), 
             to_char(asie_fech_emis), 
             to_char(asie_obse),
             'ASIENTO'
        from come_asie
        where asie_codi = x.chas_asie_codi;
  
    end loop;
  end loop;
  
-----------come_movi_impo_deta--------------------------  
  begin
    select max(moim_nume_item)
      into v_cant_item
      from come_movi_impo_deta
     where moim_movi_codi = i_movi_codi;
  exception
    when no_data_found then
      v_cant_item := 0;
  end;
  
  if v_cant_item <> 0 then
    for y in 1..v_cant_item loop
      for x in c_movi_impo_asie(y)loop
        
  insert into come_tabl_auxi
     (taax_sess, 
      taax_user, 
      taax_seq, 
      taax_c001, 
      taax_c002, 
      taax_c003, 
      taax_c004, 
      taax_c005, 
      taax_c006)
  select p_session, 
         fp_user,
         seq_come_tabl_auxi.nextval, 
         to_char(x.asim_asie_codi), 
         null,
         to_char(asie_nume), 
         to_char(asie_fech_emis), 
         to_char(asie_obse),
             'ASIENTO'
    from come_asie
   where asie_codi = x.asim_asie_codi;
        
      end loop;
    end loop;
  end if;

-----------come_movi_impo_deta_02-------------------------- 
  for z in c_movi_codi_padr loop
    begin
      select max(moim_nume_item)
        into v_cant_item
        from come_movi_impo_deta
       where moim_movi_codi = z.movi_codi_padr;
    exception
      when no_data_found then
        v_cant_item := 0;
    end;
  
    if v_cant_item <> 0 then
      for y in 1..v_cant_item loop
        for x in c_movi_impo_asie_02(z.movi_codi_padr,y)loop
          
   insert into come_tabl_auxi
     (taax_sess, 
      taax_user, 
      taax_seq, 
      taax_c001, 
      taax_c002, 
      taax_c003, 
      taax_c004, 
      taax_c005, 
      taax_c006)
  select p_session, 
         fp_user,
         seq_come_tabl_auxi.nextval, 
         to_char(x.asim_asie_codi), 
         null,
         to_char(asie_nume), 
         to_char(asie_fech_emis), 
         to_char(asie_obse),
         'ASIENTO'
    from come_asie
   where asie_codi = x.asim_asie_codi;
        
        end loop;
      end loop;
    end if;
  end loop;

-----------come_movi_cuot_canc------------------------------- 
  for y in c_movi_cuot_canc loop  
    for x in c_movi_cuot_canc_asie(y.canc_cuot_movi_codi, y.canc_cuot_fech_venc)loop
      
     insert into come_tabl_auxi
    (taax_sess, 
      taax_user, 
      taax_seq, 
      taax_c001, 
      taax_c002, 
      taax_c003, 
      taax_c004, 
      taax_c005, 
      taax_c006)
  select p_session, 
         fp_user,
         seq_come_tabl_auxi.nextval, 
         to_char(x.caas_asie_codi), 
         null,
         to_char(asie_nume), 
         to_char(asie_fech_emis), 
         to_char(asie_obse),
         'ASIENTO'
    from come_asie
   where asie_codi = x.caas_asie_codi;
    

    end loop;
  end loop;

-----------come_movi_prod_deta--------------------------  
  begin
    select max(deta_nume_item)
      into v_cant_item
      from come_movi_prod_deta
     where deta_movi_codi = i_movi_codi;
  exception
    when no_data_found then
      v_cant_item := 0;
  end;

  if v_cant_item <> 0 then
    for y in 1..v_cant_item loop
      for x in c_movi_prod_asie(y)loop
           
  insert into come_tabl_auxi
     (taax_sess, 
      taax_user, 
      taax_seq, 
      taax_c001, 
      taax_c002, 
      taax_c003, 
      taax_c004, 
      taax_c005, 
      taax_c006)
  select p_session, 
         fp_user,
         seq_come_tabl_auxi.nextval, 
         to_char(x.deas_asie_codi), 
         null,
         to_char(asie_nume), 
         to_char(asie_fech_emis), 
         to_char(asie_obse),
         'ASIENTO'
    from come_asie
   where asie_codi = x.deas_asie_codi;
      
      end loop;
    end loop;
  end if;
 
-----------come_movi_cuot_pres_deve-------------------------- 
  begin
    select max(cude_nume_item)
      into v_cant_item
      from come_movi_cuot_pres_deve
     where cude_movi_codi = i_movi_codi;
  exception
    when no_data_found then
      v_cant_item := 0;
  end;

  if v_cant_item <> 0 then
    for y in 1..v_cant_item loop
      for x in c_movi_pres_deve_asie(y)loop
                    
   insert into come_tabl_auxi
     (taax_sess, 
      taax_user, 
      taax_seq, 
      taax_c001, 
      taax_c002, 
      taax_c003, 
      taax_c004, 
      taax_c005, 
      taax_c006)
  select p_session, 
         fp_user,
         seq_come_tabl_auxi.nextval, 
         to_char(x.deas_asie_codi), 
         null,
         to_char(asie_nume), 
         to_char(asie_fech_emis), 
         to_char(asie_obse),
         'ASIENTO'
    from come_asie
   where asie_codi = x.deas_asie_codi;
      
     end loop;
    end loop;
  end if; 
  
-----------come_movi_apli_tick-------------------------------  
  for x in c_movi_apli_tick_asie loop
   
     insert into come_tabl_auxi
     (taax_sess, 
      taax_user, 
      taax_seq, 
      taax_c001, 
      taax_c002, 
      taax_c003, 
      taax_c004, 
      taax_c005, 
      taax_c006)
  select p_session, 
         fp_user,
         seq_come_tabl_auxi.nextval, 
         to_char(x.tias_asie_codi), 
         null,
         to_char(asie_nume), 
         to_char(asie_fech_emis), 
         to_char(asie_obse),
         'ASIENTO'
    from come_asie
   where asie_codi = x.tias_asie_codi;
  
  end loop;
    
exception 
  when others then 
    raise_application_error(-20010, 'Error al momento de cargar Asientos. '||sqlcode);
end pp_carg_asie;

 procedure pp_carg_caja (i_movi_codi in number) is
  
 type tr_caja is record(
        session           number,
        login             varchar2(50),
        moim_movi_codi    come_movi_impo_deta.moim_movi_codi%type,
        moim_nume_item    come_movi_impo_deta.moim_nume_item%type,
        moim_tipo         come_movi_impo_deta.moim_tipo%type,
        moim_cuen_codi    come_movi_impo_deta.moim_cuen_codi%type,
        moim_dbcr         varchar2(500),
        moim_afec_caja    come_movi_impo_deta.moim_afec_caja%type,
        moim_fech         come_movi_impo_deta.moim_fech%type,
        moim_asie_codi    come_movi_impo_deta.moim_asie_codi%type,
        moim_impo_mone    come_movi_impo_deta.moim_impo_mone%type,
        moim_impo_mmnn    come_movi_impo_deta.moim_impo_mmnn%type,
        secuencia         number);
               
  type tt_caja is table of tr_caja index by binary_integer;
  ta_caja tt_caja;
  
  e_caja exception ;
  
  
  asie_nume         come_asie.asie_nume%type;       
  moim_impo_mone_db come_movi_impo_deta.moim_impo_mone%type;
  moim_impo_mone_cr come_movi_impo_deta.moim_impo_mone%type;
  moim_impo_mmnn_db come_movi_impo_deta.moim_impo_mmnn%type;
  moim_impo_mmnn_cr come_movi_impo_deta.moim_impo_mmnn%type;
  v_cant_regi       number;

begin


    select p_session,
           fp_user,
           d.moim_movi_codi,
           d.moim_nume_item,
           d.moim_tipo,
           d.moim_cuen_codi,
           decode(d.moim_dbcr, 'C', 'Credito', 'D', 'Debito') moim_dbcr,
           d.moim_afec_caja,
           d.moim_fech,
           d.moim_asie_codi,
           d.moim_impo_mone,
           d.moim_impo_mmnn,
           seq_come_tabl_auxi.nextval 
      bulk collect into ta_caja
      from come_movi_impo_deta d, come_movi m
     where d.moim_movi_codi = m.movi_codi
       and m.movi_codi = i_movi_codi;

 pack_mane_tabl_auxi.pp_trunc_table(p_session, fp_user);

 --cargar importe solamente si tiene paga en efectivo
v_cant_regi := ta_caja.count;  
 
 for x in 1 .. v_cant_regi loop
   
 
    if ta_caja(x).moim_asie_codi is not null then
      
    begin
    
     select asie_nume
       into asie_nume
       from come_asie
      where asie_codi = ta_caja(x).moim_asie_codi;  
     
     exception
       when no_data_found then 
         raise e_caja;
     end;
    
    if ta_caja(x).moim_dbcr = 'Debito' then
      moim_impo_mone_db := ta_caja(x).moim_impo_mone;
      moim_impo_mone_cr := 0;
      moim_impo_mmnn_db := ta_caja(x).moim_impo_mmnn;
      moim_impo_mmnn_cr := 0;
    else
      moim_impo_mone_cr := ta_caja(x).moim_impo_mone;
      moim_impo_mone_db := 0;
      moim_impo_mmnn_cr := ta_caja(x).moim_impo_mmnn;
      moim_impo_mmnn_db := 0;
    end if;    
     
     
      
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
       taax_seq)
     values
      (ta_caja(x).session,
       ta_caja(x).login,
       ta_caja(x).moim_movi_codi,
       ta_caja(x).moim_nume_item,
       ta_caja(x).moim_tipo,
       ta_caja(x).moim_cuen_codi,
       ta_caja(x).moim_dbcr,
       ta_caja(x).moim_afec_caja,
       ta_caja(x).moim_fech,
       ta_caja(x).moim_asie_codi,
       ta_caja(x).moim_impo_mone,
       ta_caja(x).moim_impo_mmnn,       
       moim_impo_mone_db,
       moim_impo_mone_cr,
       moim_impo_mmnn_db,
       moim_impo_mmnn_cr,   
       asie_nume,
       ta_caja(x).secuencia);  
     
 end loop;


  /*  :bcaja.s_neto      := nvl(:bcaja.s_total_importe_db, 0) -
                          nvl(:bcaja.s_total_importe_cr, 0);
    :bcaja.s_neto_mmnn := nvl(:bcaja.s_tota_importe_db_mmnn, 0) -
                          nvl(:bcaja.s_total_importe_cr_mmnn, 0);
    pp_muestra_cuen_banc(:bcaja.moim_cuen_codi, :bcaja.moim_cuen_desc);
  */

exception 
  when e_caja then 
    raise_application_error(-20010, 'Numero de asiento inexistente!');


end pp_carg_caja;
 
 procedure pp_carg_impu (i_impu_codi in number) is
  
   type tr_impu is record(
        session           number,
        login             varchar2(50),
        moim_movi_codi    come_movi_impu_deta.moim_movi_codi%type,
        moim_impu_codi    come_movi_impu_deta.moim_impu_codi%type,
        impu_desc         come_impu.impu_desc%type,
        moim_tiim_desc    come_tipo_impu.tiim_desc%type,
        moim_impo_mone    come_movi_impu_deta.moim_impo_mone%type,
        moin_impu_mone    come_movi_impu_deta.moim_impu_mone%type,
        moin_impo_mmnn    come_movi_impu_deta.moim_impo_mmnn%type,
        moin_impu_mmnn    come_movi_impu_deta.moim_impu_mmnn%type,   
        moin_impo_mmee    come_movi_impu_deta.moim_impo_mmee%type,
        moin_impu_mmee    come_movi_impu_deta.moim_impu_mmee%type,
        secuencia         number);

   type tt_impu is table of tr_impu index by binary_integer;
   ta_impu tt_impu;
  
  begin
    
    select p_session,
           fp_user login,    
           moim_movi_codi,
           moim_impu_codi,
           case 
              when moim_impu_codi is not null then 
               (select impu_desc  from   come_impu where  impu_codi = moim_impu_codi)
              else
                null
              end ,
           case
             when  moim_tiim_codi is not null then 
                (select tiim_desc  from   come_tipo_impu where  tiim_codi = moim_tiim_codi)
              else 
                null
              end ,
           moim_impo_mone,
           moim_impu_mone,
           moim_impo_mmnn,
           moim_impu_mmnn,
           moim_impo_mmee,
           moim_impu_mmee,
           seq_come_tabl_auxi.nextval secuencia
      bulk collect into ta_impu
     from come_movi_impu_deta
    where moim_movi_codi = i_impu_codi;
  
 pack_mane_tabl_auxi.pp_trunc_table(p_session, fp_user);
  
 v_cant_regi := ta_impu.count;  
 
 for x in 1 .. v_cant_regi loop
    
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
       taax_seq)
     values
      (ta_impu(x).session,
       ta_impu(x).login,
       ta_impu(x).moim_movi_codi,
       ta_impu(x).moim_impu_codi,
       ta_impu(x).impu_desc,
       ta_impu(x).moim_tiim_desc,
       ta_impu(x).moim_impo_mone,
       ta_impu(x).moin_impu_mone,
       ta_impu(x).moin_impo_mmnn,
       ta_impu(x).moin_impu_mmnn,
       ta_impu(x).moin_impo_mmee,
       ta_impu(x).moin_impu_mmee,
       ta_impu(x).secuencia);
         
 end loop;
   
  end pp_carg_impu;

 procedure pp_carg_canc (i_canc_movi_codi in number) is
  
  type tr_canc is record(
        session             number,
        login               varchar2(50),
        canc_cuot_movi_codi	come_movi_cuot_canc.canc_cuot_movi_codi%type,
        canc_asie_codi	    come_movi_cuot_canc.canc_asie_codi%type,
        canc_movi_codi	    come_movi_cuot_canc.canc_movi_codi%type,
        canc_fech_pago	    come_movi_cuot_canc.canc_fech_pago%type,
        canc_cuot_fech_venc	come_movi_cuot_canc.canc_cuot_fech_venc%type,
        canc_impo_mone	    come_movi_cuot_canc.canc_impo_mone%type,
        canc_impo_mmnn	    come_movi_cuot_canc.canc_impo_mmnn%type,
        canc_impo_mmee	    come_movi_cuot_canc.canc_impo_mmee%type,
        canc_impo_dife_camb	come_movi_cuot_canc.canc_impo_dife_camb%type,
      --  asie_nume           come_asie.asie_nume%type,
        secuencia           number);
               
  type tt_canc is table of tr_canc index by binary_integer;
  ta_canc tt_canc;

  begin
  
   select p_session,
          fp_user,   
          canc_cuot_movi_codi,
          canc_asie_codi,
          canc_movi_codi,
          canc_fech_pago,
          canc_cuot_fech_venc,
          canc_impo_mone,
          canc_impo_mmnn,
          canc_impo_mmee,
          canc_impo_dife_camb,
          seq_come_tabl_auxi.nextval 
        bulk collect into ta_canc
     from come_movi_cuot_canc
    where canc_movi_codi = i_canc_movi_codi;
  
   pack_mane_tabl_auxi.pp_trunc_table(p_session, fp_user);

--cargar en la tabla temporal las cancelaciones
  v_cant_regi := ta_canc.count;  
 
 for x in 1 .. v_cant_regi loop
         
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
           taax_seq)
     values
          (ta_canc(x).session,
           ta_canc(x).login,
           ta_canc(x).canc_cuot_movi_codi,
           ta_canc(x).canc_asie_codi,
           ta_canc(x).canc_movi_codi,
           ta_canc(x).canc_fech_pago,
           ta_canc(x).canc_cuot_fech_venc,
           ta_canc(x).canc_impo_mone,
           ta_canc(x).canc_impo_mmnn,
           ta_canc(x).canc_impo_mmee,
           ta_canc(x).canc_impo_dife_camb,
           ta_canc(x).secuencia);

 end loop;
 
 end pp_carg_canc;
 
 procedure pp_carg_conc(i_movi_codi in number) is
   
   type tr_conc is record(
        session             number,
        login               varchar2(50),
        moco_nume_item      come_movi_conc_deta.moco_nume_item%type,
        moco_conc_codi      come_movi_conc_deta.moco_conc_codi%type,
        moco_dbcr           come_movi_conc_deta.moco_dbcr%type,
        tiim_desc           come_tipo_impu.tiim_desc%type,
        impu_desc           come_impu.impu_desc%type,
        impu_porc_base_impo come_impu.impu_porc_base_impo%type,
        impu_porc           come_impu.impu_porc%type,
        moco_impo_mone      come_movi_conc_deta.moco_impo_mone%type,
        moco_impo_mmnn      come_movi_conc_deta.moco_impo_mmnn%type,
        conc_dbcr           come_conc.conc_dbcr%type,
        conc_desc           come_conc.conc_desc%type,
        secuencia           number);
               
  type tt_conc is table of tr_conc index by binary_integer;
  ta_conc tt_conc;
  
  
   begin
       
   select p_session,
          fp_user, 
          moco_nume_item,
          moco_conc_codi,
          moco_dbcr,    
          (select tiim_desc from   come_tipo_impu where  tiim_codi = moco_tiim_codi),
          (select impu_desc  from   come_impu  where  impu_codi = moco_impu_codi),
          (select impu_porc_base_impo  from   come_impu  where  impu_codi = moco_impu_codi), 
          (select impu_porc  from   come_impu  where  impu_codi = moco_impu_codi),
          moco_impo_mone,
          moco_impo_mmnn,
          (select conc_dbcr from come_conc where conc_codi = moco_conc_codi),
          (select conc_desc from come_conc where conc_codi = moco_conc_codi),
         seq_come_tabl_auxi.nextval 
      bulk collect into ta_conc
     from come_movi_conc_deta
   where moco_movi_codi = i_movi_codi;
  
  pack_mane_tabl_auxi.pp_trunc_table(p_session, fp_user);
 --cargar en la tabla temporal el concepto
  v_cant_regi := ta_conc.count;  
 
 for x in 1 .. v_cant_regi loop
         
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
           taax_seq)
     values
          (ta_conc(x).session,
           ta_conc(x).login,
           ta_conc(x).moco_nume_item,
           ta_conc(x).moco_conc_codi,
           ta_conc(x).moco_dbcr,
           ta_conc(x).tiim_desc,
           ta_conc(x).impu_desc,
           ta_conc(x).impu_porc_base_impo,
           ta_conc(x).impu_porc,
           ta_conc(x).moco_impo_mone,
           ta_conc(x).moco_impo_mmnn,
           ta_conc(x).conc_dbcr,
           ta_conc(x).conc_desc,
           ta_conc(x).secuencia);
           
  end loop;
  
  end pp_carg_conc;
  
 procedure pp_carg_prod(i_movi_codi in number) is
  
  type tr_prod is record(
        session         number,
        login           varchar2(50),
        deta_nume_item  come_movi_prod_deta.deta_nume_item%type,
        deta_cant       come_movi_prod_deta.deta_cant%type,
        deta_prec_unit  come_movi_prod_deta.deta_prec_unit%type,
        deta_porc_deto  come_movi_prod_deta.deta_porc_deto%type,
        deta_impu_codi  come_movi_prod_deta.deta_impu_codi%type,
        lote_desc       come_lote.lote_desc%type,
        deta_impo_mone  come_movi_prod_deta.deta_impo_mone%type,
        deta_iva_mone   come_movi_prod_deta.deta_iva_mone%type,
        prod_codi_alfa  come_prod.prod_codi_alfa%type,
        prod_desc       come_prod.prod_desc%type,
        impu_desc       come_impu.impu_desc%type,
        secuencia       number);
               
  type tt_prod is table of tr_prod index by binary_integer;
  ta_prod tt_prod;
  
  begin
    
  
 select p_session,
        fp_user, 
        deta_nume_item,
        deta_cant,
        deta_prec_unit,
        deta_porc_deto,
        deta_impu_codi,
        (select lote_desc from come_lote where lote_codi = deta_lote_codi), 
        deta_impo_mone,
        deta_iva_mone,
        (select prod_codi_alfa from come_prod where prod_codi = deta_prod_codi),
        (select prod_desc  from come_prod where prod_codi = deta_prod_codi),
        (select impu_desc  from   come_impu  where  impu_codi = deta_impu_codi),
        seq_come_tabl_auxi.nextval 
    bulk collect into ta_prod
   from come_movi_prod_deta 
  where deta_movi_codi = i_movi_codi;
   
  pack_mane_tabl_auxi.pp_trunc_table(p_session, fp_user);
 --cargar en la tabla temporal el concepto
  v_cant_regi := ta_prod.count;  
 
 for x in 1 .. v_cant_regi loop
         
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
           taax_seq)
     values
          (ta_prod(x).session,
           ta_prod(x).login,
           ta_prod(x).deta_nume_item,
           ta_prod(x).deta_cant,
           ta_prod(x).deta_prec_unit,
           ta_prod(x).deta_porc_deto,
           ta_prod(x).deta_impu_codi,
           ta_prod(x).lote_desc,
           ta_prod(x).deta_impo_mone,
           ta_prod(x).deta_iva_mone,
           ta_prod(x).prod_codi_alfa,
           ta_prod(x).prod_desc,
           ta_prod(x).impu_desc,
           ta_prod(x).secuencia);
           
  end loop;
    
  end pp_carg_prod;
  
 procedure pp_carg_prod_ortr(i_movi_codi in number) is
  
  type tr_prod is record(
        session         number,
        login           varchar2(50),
        deta_nume_item  come_movi_prod_deta.deta_nume_item%type,
        deta_cant       come_movi_prod_deta.deta_cant%type,
        deta_prec_unit  come_movi_prod_deta.deta_prec_unit%type,
        deta_porc_deto  come_movi_prod_deta.deta_porc_deto%type,
        deta_impu_codi  come_movi_prod_deta.deta_impu_codi%type,
        deta_impo_mone  come_movi_prod_deta.deta_impo_mone%type,
        deta_iva_mone   come_movi_prod_deta.deta_iva_mone%type,
        prod_codi_alfa  come_prod.prod_codi_alfa%type,
        prod_desc       come_prod.prod_desc%type,
        impu_desc       come_impu.impu_desc%type,
        secuencia       number);
               
  type tt_prod is table of tr_prod index by binary_integer;
  ta_prod tt_prod;
  
  begin
    
  
 select p_session,
        fp_user, 
        deta_nume_item,
        deta_cant,
        deta_prec_unit,
        deta_porc_deto,
        deta_impu_codi,
        deta_impo_mone,
        deta_iva_mone,
        (select prod_codi_alfa from come_prod where prod_codi = deta_prod_codi),
        (select prod_desc  from come_prod where prod_codi = deta_prod_codi),
        (select impu_desc  from   come_impu  where  impu_codi = deta_impu_codi),
        seq_come_tabl_auxi.nextval 
    bulk collect into ta_prod
   from come_movi_ortr_prod_deta 
  where deta_movi_codi  = i_movi_codi;
   
  pack_mane_tabl_auxi.pp_trunc_table(p_session, fp_user);
 --cargar en la tabla temporal el concepto
  v_cant_regi := ta_prod.count;  
 
 for x in 1 .. v_cant_regi loop
         
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
           taax_seq)
     values
          (ta_prod(x).session,
           ta_prod(x).login,
           ta_prod(x).deta_nume_item,
           ta_prod(x).deta_cant,
           ta_prod(x).deta_prec_unit,
           ta_prod(x).deta_porc_deto,
           ta_prod(x).deta_impu_codi,
           ta_prod(x).deta_impo_mone,
           ta_prod(x).deta_iva_mone,
           ta_prod(x).prod_codi_alfa,
           ta_prod(x).prod_desc,
           ta_prod(x).impu_desc,
           ta_prod(x).secuencia);
           
  end loop;
    
  end pp_carg_prod_ortr;
 
 /**********************************************************************/
 /***********************R E P O R T E S *******************************/
 /**********************************************************************/  
  
 procedure pp_carg_repo_asie (i_nume_asie in number) is 
  
 type tr_asie_repo is record(
       session         number,
       login           varchar2(50),
       asie_codi      come_asie.asie_codi%type,
       asie_nume      come_asie.asie_nume%type,
       asie_fech_emis come_asie.asie_fech_emis%type,
       asie_obse      come_asie.asie_obse%type,
       asie_indi_manu come_asie.asie_indi_manu%type,
       cuco_nume      come_cuen_cont.cuco_nume%type,
       cuco_desc      come_cuen_cont.cuco_desc%type,
       movi_obse      varchar2(500),
       movi_clpr_codi number,
       deta_indi_dbcr varchar2(50),       
       debe_mmnn      number,
       habe_mmnn      number,
       debe_mmee      number,
       habe_mmee      number,
       deta_nume_item come_asie_deta.deta_nume_item%type,
       movi_clpr_desc varchar2(500),
       secuencia      number);

  type tt_asien is table of tr_asie_repo index by binary_integer;
  ta_asien tt_asien;
  
  v_cant_regi    number:= 0;
  v_para         varchar2(500);
  v_cont         varchar2(500);
  v_repo         varchar2(500);


  begin 
    
  begin
  pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => p_session,
                                     i_taax_user => fp_user);
  end;
  
  
  select p_session,
         fp_user,
         asie_codi,
         asie_nume,
         asie_fech_emis,
         asie_obse,
         asie_indi_manu,
         cuco_nume,
         cuco_desc,
         movi_obse,
         movi_clpr_codi,
         deta_indi_dbcr,
         debe_mmnn,
         habe_mmnn,
         debe_mmee,
         habe_mmee,
         deta_nume_item,
         movi_clpr_desc,
         seq_come_tabl_auxi.nextval
   bulk collect into ta_asien
  from (select a.asie_codi,
               a.asie_nume,
               a.asie_fech_emis,
               a.asie_obse,
               a.asie_indi_manu,
               c.cuco_nume,
               c.cuco_desc,
               m.movi_obse,
               m.movi_clpr_codi,
               decode(d.deta_indi_dbcr, ' D ', ' Debe ', ' H ', 'Haber') deta_indi_dbcr,
               decode(d.deta_indi_dbcr, ' D ', nvl(d.deta_impo_mmnn, 0), 0) debe_mmnn,
               decode(d.deta_indi_dbcr, ' H ', nvl(d.deta_impo_mmnn, 0), 0) habe_mmnn,
               decode(d.deta_indi_dbcr, ' D ', nvl(d.deta_impo_mmee, 0), 0) debe_mmee,
               decode(d.deta_indi_dbcr, ' H ', nvl(d.deta_impo_mmee, 0), 0) habe_mmee,
               d.deta_nume_item,
               m.movi_clpr_desc
          from come_asie a,
               come_asie_deta d,
               come_orde_trab ot,
               come_cuen_cont c,
               (select movi_obse,
                       movi_nume,
                       clpr_Desc,
                       moa.moas_asie_codi,
                       movi_timo_codi,
                       movi_clpr_Desc,
                       movi_clpr_codi
                  from come_movi mo, come_movi_asie moa, come_clie_prov cl
                 where mo.movi_codi = moa.moas_movi_codi
                   and mo.movi_clpr_codi = cl.clpr_codi(+)) m
         where a.asie_codi = d.deta_asie_codi
           and c.cuco_codi = d.deta_cuco_codi
           and asie_codi = m.moas_asie_codi(+)
           and deta_ortr_codi = ot.ortr_codi(+)
           and asie_nume =  i_nume_asie
 order by asie_fech_emis, asie_nume, deta_indi_dbcr, deta_nume_item) cuco;
  
 
 v_cant_regi := ta_asien.count;
  
 
 for x in 1 .. v_cant_regi loop
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
       taax_seq)
     values
      (ta_asien(x).session,
       ta_asien(x).login,
       ta_asien(x).asie_codi,
       ta_asien(x).asie_nume,
       ta_asien(x).asie_fech_emis,
       ta_asien(x).asie_obse,
       ta_asien(x).asie_indi_manu,
       ta_asien(x).cuco_nume,
       ta_asien(x).cuco_desc,
       ta_asien(x).movi_obse,
       ta_asien(x).movi_clpr_codi,
       ta_asien(x).deta_indi_dbcr,
       ta_asien(x).debe_mmnn,
       ta_asien(x).habe_mmnn,
       ta_asien(x).debe_mmee,
       ta_asien(x).habe_mmee,
       ta_asien(x).deta_nume_item,
       ta_asien(x).movi_clpr_desc,
       ta_asien(x).secuencia);  
     
 end loop;
 
    v_cont := 'p_app_session:p_app_user';      
    v_para :=   p_session|| ':' ||fp_user;
    v_repo := 'I020213_ASIENTOS';

    delete from come_parametros_report where usuario = fp_user;

    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_para, fp_user, v_repo, 'pdf', v_cont);

    commit;
 
  end pp_carg_repo_asie;

 /*********************************************************************/
 /******************* SOLICITUD DE DESBLOQUEO ************************/
 /*******************************************************************/
 procedure pp_soli_desb(i_movi_codi in number,
                        i_movi_nume in number,
                        o_resp_codi out number,  
                        o_resp_desc out varchar2) is
  v_cont number;
begin
   
   insert into come_concat (otro) values ('Paso por aca 1 --- ');
   commit;  

    select count(*)
      into v_cont
      from come_movi_entr_deta
     where deta_movi_codi = i_movi_codi
       and nvl(deta_indi_impr_logi,'N') = 'N';
  
    if v_cont > 0 then
      
        pp_get_erro(i_resp_codi       => 62,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                          
         v_erro_codi := 62;      
         raise salir;     
    
    
    end if; 
  
  insert into come_concat (otro) values ('Paso por aca 2 --- ');
   commit;  

    select count(*)
      into v_cont
      from come_movi_entr_deta
     where deta_movi_codi = i_movi_codi
       and nvl(deta_indi_impr_logi,'N') = 'S' 
       and nvl(deta_indi_soli_anul,'N') = 'P';
  
    if v_cont > 0 then
        pp_get_erro(i_resp_codi       => 63,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                          
         v_erro_codi := 63;      
         raise salir;   
    end if; 
  
  insert into come_concat (otro) values ('Paso por aca 3 --- ');
   commit;  
   
    select count(*)
      into v_cont
      from come_movi_entr_deta
     where deta_movi_codi = i_movi_codi
       and nvl(deta_indi_impr_logi,'N') = 'S' 
       and nvl(deta_indi_soli_anul,'N') = 'P';
  
    if v_cont > 0 then
        pp_get_erro(i_resp_codi       => 64,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
                          
         v_erro_codi := 64;      
         raise salir;  
    end if;
      
    insert into come_concat (otro) values ('Paso por aca 4 --- ');
   commit;   
    
  update come_movi_entr_deta
  set deta_indi_soli_anul = 'P',
      deta_user_soli_anul = fp_user,
      deta_fech_soli_anul = sysdate
  where deta_movi_codi = i_movi_codi;
  
      insert into come_concat (otro) values ('Paso por aca 5 --- ');
   commit;   
    
  insert into come_movi_soli_anul 
              (soan_movi_codi, 
               soan_movi_nume, 
               soan_user_soli, 
               soan_fech_soli)
       values (i_movi_codi,
               i_movi_nume,
               fp_user,
               sysdate);                              
  

exception
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
    rollback;
    o_resp_codi := 1000;
    o_resp_desc := ('No se pudo actualizar el registro, al momento de solicitar desbloqueo: '||sqlcode);
end;
 
 
procedure pp_refinanciar_cuotas(i_movi_codi           in number,
                                i_cuot_fech_venc      in date,
                                i_mone_cant_deci      in number,
                                i_movi_tasa_mone      in number,
                                i_s_tipo_vencimiento  in varchar2,
                                i_s_dias_entre_cuotas in number,
                                i_fec_prim_vto        in date,
                                i_cant_cuotas         in number) is

  cursor c_sald is
    select c.cuot_impo_mone,
           c.cuot_fech_venc,
           c.cuot_sald_mone,
           c.cuot_indi_reca_reco,
           c.cuot_tipo
      from come_movi_cuot c
     where c.cuot_movi_codi = i_movi_codi
      -- and c.cuot_fech_venc = i_cuot_fech_venc
       and c.cuot_sald_mone < 0
       and c.cuot_impo_mone <> c.cuot_sald_mone
     order by c.cuot_fech_venc;

  v_dias           number;
  v_importe        number;
  v_cant_cuotas    number;
  v_entrega        number := 0;
  v_vto            number;
  v_diferencia     number;
  v_count          number := 0;
  v_cuot_fech_venc date;
  v_cant_dife      number;
  contador         number:=0;
  v_cuot_indi_reca_reco varchar2(1);
  
  v_fecha_orig      date;
  v_tipo_orig       varchar2(2);
  
  cursor c_cuot is
  select cuot_fech_venc fech_venc,
       cuot_nume      nume,
       cuot_impo_mone impo,
       cuot_impo_mmnn impo_mmnn,
       cuot_sald_mone sald,
       cuot_sald_mmnn sald_mmnn,
       cuot_impo_dife_camb dife_camb,
       cuot_indi_reca_reco
  from come_movi_cuot
 where cuot_movi_codi = i_movi_codi
   --and cuot_fech_venc = i_cuot_fech_venc
   ;
 
v_sum_cuot_sald_mone   number := 0;

  
begin
  
--raise_application_Error(-20010,'aca');
  select count(*)
    into v_cant_dife
    from come_movi_dife_camb df
   where df.dica_movi_codi = i_movi_codi;
  
  if v_cant_dife > 0 then
    raise_application_error(-20010, 'No se puede realizar la Redefinicion, existen cuotas con Diferencia de Cambio.');
  end if;
  
  begin
  pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => p_session, i_taax_user => fp_user);
 end;

  
    for i in c_cuot loop
    
    if i.cuot_indi_reca_reco is not null then
      v_cuot_indi_reca_reco := i.cuot_indi_reca_reco;
    end if;
    
    v_sum_cuot_sald_mone :=  v_sum_cuot_sald_mone + i.sald; -- obtenemos el total de las cuotas

  end loop; 
  v_vto            := i_s_dias_entre_cuotas;
  v_dias           := v_vto;
  v_cuot_fech_venc := i_FEC_PRIM_VTO;
  v_entrega        := 0;
  v_cant_cuotas    := i_cant_cuotas;
  v_importe        := round(v_sum_cuot_sald_mone / v_cant_cuotas, nvl(i_mone_cant_deci, 0));
  v_diferencia     := (v_sum_cuot_sald_mone - (v_importe * v_cant_cuotas));




  
  for k in c_sald loop
    contador := contador + 1;
     insert into come_tabl_auxi
       (taax_sess,
        taax_user,
        taax_seq,
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
        taax_c013)
     values
       (p_session,
        fp_user,
        seq_come_tabl_auxi.nextval,
        'A',
        (k.cuot_impo_mone - k.cuot_sald_mone),
        (k.cuot_impo_mone - k.cuot_sald_mone) * i_movi_tasa_mone,
        0,
        0,
        k.cuot_fech_venc,
        contador,
        k.cuot_impo_mone,
        k.cuot_sald_mone,
        'S',
        k.cuot_indi_reca_reco,
        k.cuot_fech_venc,
        k.cuot_tipo);
        
   /* x.cuot_impo_mone   := k.cuot_impo_mone - k.cuot_sald_mone;
    x.cuot_impo_mmnn   := round(x.cuot_impo_mone * i_movi_tasa_mone, 0);
    x.cuot_sald_mone   := 0;
    x.cuot_sald_mmnn   := 0;
    x.cuot_fech_venc   := k.cuot_fech_venc;
    x.s_cuot_fech_venc := to_char(x.cuot_fech_venc, 'dd-mm-yyyy');
    x.cuot_nume        := to_number(:system.cursor_record);
  
    x.impo_mone_orig := k.cuot_impo_mone;
    x.sald_mone_orig := k.cuot_sald_mone;
    x.indi_refi      := 'S';
    x.cuot_indi_reca_reco := k.cuot_indi_reca_reco;

    next_record;*/
    
  end loop;

  for x in 1 .. v_cant_cuotas loop
    
   contador := contador + 1;
   pp_veri_fech_venc_feri(v_cuot_fech_venc);
    
    /*select cuot_fech_venc fech_venc, cuot_tipo
      into v_fecha_orig, v_tipo_orig
      from come_movi_cuot
     where cuot_movi_codi = i_movi_codi
       and cuot_fech_venc = i_cuot_fech_venc;*/
   
   
   
     insert into come_tabl_auxi
       (taax_sess,
        taax_user,
        taax_seq,
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
        taax_c013)
     values
       (p_session,
        fp_user,
        seq_come_tabl_auxi.nextval,
        'B',
        v_importe,
        round(v_importe * i_movi_tasa_mone, 0),
        v_importe,
        round(v_importe * i_movi_tasa_mone, 0),
        v_cuot_fech_venc,
        contador,
        0,
        0,
        'N',
        v_cuot_indi_reca_reco,
        v_fecha_orig,
        v_tipo_orig);
        
    if i_s_tipo_vencimiento = 'V' then
      v_cuot_fech_venc := v_cuot_fech_venc + v_vto;
    else
      v_cuot_fech_venc := v_cuot_fech_venc - p_cant_dias_feri;
      v_cuot_fech_venc := add_months(v_cuot_fech_venc, 1);
    end if;
  
   /* x.dias             := v_dias;
    x.cuot_impo_mone   := v_importe;
    x.cuot_impo_mmnn   := round(v_importe * :bcab.movi_tasa_mone, 0);
    x.cuot_sald_mone   := v_importe;
    x.cuot_sald_mmnn   := round(v_importe * :bcab.movi_tasa_mone, 0);
    
    
    x.cuot_fech_venc   := v_cuot_fech_venc;
    
    x.s_cuot_fech_venc := to_char(x.cuot_fech_venc, 'dd-mm-yyyy');
    x.indi_refi        := 'N';
    v_dias                        := v_dias + v_vto;
    v_count                       := v_count + 1;
    x.cuot_nume        := to_number(:system.cursor_record);
    
    x.cuot_indi_reca_reco := v_cuot_indi_reca_reco;*/
   
  end loop;

     --sumar la diferencia a la ultima cuota 
  if v_diferencia <> 0 then
 
     declare
     v_seq        number;
     v_impo_mone1 number;
     v_impo_mone2 number;
     v_impo_mone3 number;
     v_impo_mone4 number;
     begin
       
      select max(taax_seq), 
             to_number(taax_c002), 
             to_number(taax_c003),
             to_number(taax_c004),
             to_number(taax_c005)
        into v_seq, 
             v_impo_mone1, 
             v_impo_mone2,
             v_impo_mone3, 
             v_impo_mone4
        from come_tabl_auxi 
       where taax_sess = p_session 
         and taax_user = fp_user
       group by to_number(taax_c002), 
                to_number(taax_c003),
                to_number(taax_c004),
                to_number(taax_c005);  
      
      update come_tabl_auxi
       set taax_c002 = to_char(v_impo_mone1 + v_diferencia),
           taax_c003 = to_char(v_impo_mone2 + v_diferencia),
           taax_c004 = to_char(v_impo_mone3 + v_diferencia),
           taax_c005 = to_char(v_impo_mone4 + v_diferencia)
     where taax_seq = v_seq;
        
     exception 
       when others then 
         raise_application_error(-20010, 'Error al cargar la diferencia de la ultima cuota: '||sqlerrm); 
      end;
  
  end if;

end;

 procedure pp_veri_fech_venc_feri (p_cuot_fech_venc in out date) is
  v_fech_veri      varchar2(1);
  v_feri_fech      date;
  v_feri_cont_anho varchar2(1);
  v_cuot_fech_venc date;

begin
  v_fech_veri                 := 'N';
  v_cuot_fech_venc            := p_cuot_fech_venc;
  p_cant_dias_feri := 0;

  while v_fech_veri <> 'S' loop
    begin
      select feri_fech, feri_cont_anho
        into v_feri_fech, v_feri_cont_anho
        from come_feri
       where feri_empr_codi = p_empr_codi
         and to_char(feri_fech, 'dd-mm') =
             to_char(v_cuot_fech_venc, 'dd-mm');
    
      if nvl(v_feri_cont_anho, 'S') = 'S' then
        v_cuot_fech_venc            := v_cuot_fech_venc + 1;
        v_fech_veri                 := 'N';
        p_cant_dias_feri := p_cant_dias_feri + 1;
      else
        if v_cuot_fech_venc = v_feri_fech then
          v_cuot_fech_venc            := v_cuot_fech_venc + 1;
          v_fech_veri                 := 'N';
          p_cant_dias_feri := p_cant_dias_feri + 1;
        else
          p_cuot_fech_venc := v_cuot_fech_venc;
          v_fech_veri      := 'S';
        end if;
      end if;
    exception
      when no_data_found then
        p_cuot_fech_venc := v_cuot_fech_venc;
        v_fech_veri      := 'S';
    end;
  end loop;
end;

procedure pp_validar_refi(p_codi in number) is
  cursor c_cuo is
    select cuot_fech_venc, cuot_impo_mone
      from come_movi_cuot c
     where c.cuot_movi_codi = p_codi
       and (c.cuot_sald_mone <> cuot_impo_mone or c.cuot_sald_mone = 0)
     order by 1;

cursor c_cuot_rede is
select   
    taax_seq seq,
    taax_c001 tipo,
    to_number(taax_c002) cuot_impo_mone,
    to_number(taax_c003) cuot_impo_mmnn,
    to_number(taax_c004) cuot_sald_mone,
    to_number(taax_c005) cuot_sald_mmnn,
    taax_c006 cuot_fech_venc,
    taax_c007 cuot_nume,
    to_number(taax_c008) impo_mone_orig,
    to_number(taax_c009) sald_mone_orig,
    taax_c010 indi_refi,
    taax_c011 cuot_indi_reca_reco
 from come_tabl_auxi
where taax_sess = p_session
  and taax_user = fp_user;

vv_sum_cuot_sald_mone  number;
v_sum_cuot_sald_mone   number;

begin

  for x in c_cuo loop
    for u in c_cuot_rede loop
      if u.cuot_fech_venc = x.cuot_fech_venc and
         nvl(u.indi_refi, 'N') = 'N' then
        raise_application_error(-20010,'La cuota refinanciada coincide con un vencimiento existente de esta factura, favor verifique!');
      end if;
      
      v_sum_cuot_sald_mone :=  v_sum_cuot_sald_mone + u.cuot_impo_mone;
      
    end loop;
      vv_sum_cuot_sald_mone :=  vv_sum_cuot_sald_mone + x.cuot_impo_mone;
  end loop;

  if nvl(vv_sum_cuot_sald_mone, 0) <>   nvl(v_sum_cuot_sald_mone, 0) then
    raise_application_error(-20010,'La sumatoria de saldos no coincide con el saldo original');
  end if;
  
  

          
          
  
end;

procedure pp_actu_refi(i_movi_codi          in number,
                       i_movi_tasa_mone     in number,
                       i_cuot_fech_ven      in date) is
 
 cursor c_cuot is
    select cuot_impo_mone, cuot_sald_mone, cuot_fech_venc, cuot_movi_codi
      from come_movi_cuot
     where cuot_movi_codi = i_movi_codi
       and cuot_sald_mone > 0
     order by cuot_fech_venc;


  cursor c_cuot_rede is
  select   
      taax_seq seq,
      taax_c001 tipo,
      to_number(taax_c002) cuot_impo_mone,
      to_number(taax_c003) cuot_impo_mmnn,
      to_number(taax_c004) cuot_sald_mone,
      to_number(taax_c005) cuot_sald_mmnn,
      taax_c006 cuot_fech_venc,
      taax_c007 cuot_nume,
      to_number(taax_c008) impo_mone_orig,
      to_number(taax_c009) sald_mone_orig,
      taax_c010 indi_refi,
      taax_c011 cuot_indi_reca_reco,
      taax_c012 cuot_fech_venc_orig,
      taax_c013 cuot_tipo
   from come_tabl_auxi
  where taax_sess = p_session
    and taax_user = fp_user;


  v_cuot_fech_venc           date;
  v_cuot_nume                number(4);
  v_cuot_impo_mone           number(20, 4);
  v_cuot_impo_mmnn           number(20, 4);
  v_cuot_impo_mmee           number(20, 4);
  v_cuot_sald_mone           number;
  v_cuot_sald_mmnn           number(20, 4);
  v_cuot_sald_mmee           number(20, 4);
  v_cuot_movi_codi           number(20);
  v_cuot_base                number(2);
  v_cuot_impo_dife_camb      number(20, 4);
  v_cuot_indi_proc_dife_camb varchar2(1);
  v_cuot_impo_dife_camb_sald number(20, 4);
  v_cuot_tasa_dife_camb      number(20, 4);
  v_cuot_orpa_codi           number(20);
  v_cuot_indi_refi           varchar2(1);
  v_cuot_indi_reca_reco      varchar2(1);
  
  v_cuot_fech_venc_orig      date;
  v_cuot_tipo                varchar2(1);
  v_total_cuota              number;
  v_total_docu               number;
begin
  


  -- primero actualizar las cuotas con saldos 
  for x in c_cuot loop
    
    if x.cuot_sald_mone = x.cuot_impo_mone then
      
      begin
        update come_movi_cuot
           set cuot_base = p_codi_base
         where cuot_movi_codi = x.cuot_movi_codi
           and cuot_fech_venc = x.cuot_fech_venc;
       exception
        when others then
          raise_application_error(-20010, 'Error el momento de actualizar saldos: '||sqlerrm);
       end;
    
       begin
        delete come_movi_cuot
         where cuot_movi_codi = x.cuot_movi_codi
           and cuot_fech_venc = x.cuot_fech_venc;
       exception 
        when others then
          raise_application_error(-20010, 'Error el momento de actualizar saldos:.. '||sqlerrm);
       end;
      
    else
      
      -- ESTO YA NO CORRESPONDE
      update come_movi_cuot
         set cuot_impo_mone = cuot_impo_mone - cuot_sald_mone,
             cuot_impo_mmnn = round((cuot_impo_mone - cuot_sald_mone) *
                                    i_movi_tasa_mone,
                                    0),
             cuot_sald_mone = 0,
             cuot_sald_mmnn = 0,
             cuot_base      = p_codi_base,
             cuot_indi_refi = 'S',
             cuot_fech_modi = sysdate,
             cuot_user_modi = fp_user,
             cuot_prog_modi ='Redefinir Vencimientos'
       where cuot_movi_codi = x.cuot_movi_codi
         and cuot_fech_venc = x.cuot_fech_venc;
      --null;
    end if;
    
  end loop;


  for x in c_cuot_rede loop
    
    if x.cuot_impo_mone > 0 and  x.cuot_fech_venc is not null then  
      if nvl(x.indi_refi, 'N') = 'S' then
        begin
          update come_movi_cuot
             set cuot_impo_mone      = x.cuot_impo_mone,
                 cuot_impo_mmnn      = x.cuot_impo_mmnn,
                 cuot_sald_mone      = x.cuot_sald_mone,
                 cuot_sald_mmnn      = x.cuot_sald_mmnn,
                 cuot_base           = p_codi_base,
                 cuot_indi_refi      = 'S',
                 cuot_indi_reca_reco = x.cuot_indi_reca_reco,
                 cuot_fech_modi = sysdate,
                 cuot_user_modi = fp_user,
                 cuot_prog_modi ='Redefinir Vencimientos'
           where cuot_movi_codi = i_movi_codi
             and cuot_fech_venc = x.cuot_fech_venc;
        exception
          when others then
            raise_application_error(-20010, 'Error el momento de actulizar cuotas redefinidas: '||sqlerrm);
        end;
      
      else
        
        v_cuot_fech_venc           := x.cuot_fech_venc;
        v_cuot_nume                := null;
        v_cuot_impo_mone           := x.cuot_impo_mone;
        v_cuot_impo_mmnn           := x.cuot_impo_mmnn;
        v_cuot_impo_mmee           := null;
        v_cuot_sald_mone           := x.cuot_impo_mone;
        v_cuot_sald_mmnn           := x.cuot_impo_mmnn;
        v_cuot_sald_mmee           := null;
        v_cuot_movi_codi           := i_movi_codi;
        v_cuot_base                := p_Codi_base;
        v_cuot_impo_dife_camb      := 0;
        v_cuot_indi_proc_dife_camb := null;
        v_cuot_impo_dife_camb_sald := 0;
        v_cuot_tasa_dife_camb      := null;
        v_cuot_orpa_codi           := null;
        v_cuot_indi_refi           := 'S';
        v_cuot_indi_reca_reco      := x.cuot_indi_reca_reco;
        v_cuot_fech_venc_orig      := x.cuot_fech_venc_orig;
        v_cuot_tipo                := x.cuot_tipo;
      

     
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
             cuot_base,
             cuot_impo_dife_camb,
             cuot_indi_proc_dife_camb,
             cuot_impo_dife_camb_sald,
             cuot_tasa_dife_camb,
             cuot_orpa_codi,
             cuot_indi_refi,
             cuot_indi_reca_reco,/*,
             cuot_padre_fech_venc,
             cuot_padre_movi_codi,
             cuot_padre_tipo*/
             cuot_fech_modi ,
             cuot_user_modi ,
             cuot_prog_modi )
          values
            (v_cuot_fech_venc,
             v_cuot_nume,
             v_cuot_impo_mone,
             v_cuot_impo_mmnn,
             v_cuot_impo_mmee,
             v_cuot_sald_mone,
             v_cuot_sald_mmnn,
             v_cuot_sald_mmee,
             v_cuot_movi_codi,
             v_cuot_base,
             v_cuot_impo_dife_camb,
             v_cuot_indi_proc_dife_camb,
             v_cuot_impo_dife_camb_sald,
             v_cuot_tasa_dife_camb,
             v_cuot_orpa_codi,
             v_cuot_indi_refi,
             v_cuot_indi_reca_reco,/*,
             v_cuot_fech_venc_orig,
             i_movi_codi,
             v_cuot_tipo*/
             sysdate, 
             fp_user,
             'Redefinir Vencimientos');
             
        exception
          when others then
            raise_application_error(-20010, 'Error al insertar en tabla de Cuota: '|| sqlerrm);
        end;
      end if;
    end if;
  
  end loop;
  
  
       select sum(cuot_impo_mone)
         into v_total_cuota
         from come_movi_cuot a
        where a.cuot_movi_Codi = i_movi_codi;
       
         select movi_impo_mone_ii
           into v_total_docu    
            from come_movi a
          where a.movi_Codi = i_movi_codi;

  if trunc(v_total_cuota) > trunc(v_total_docu) then
    raise_application_error(-20001, 'La cuota es mayor que el total del documento');
  end if;


  pa_actu_nume_cuot(i_movi_codi);
 
end;

end I020213;
