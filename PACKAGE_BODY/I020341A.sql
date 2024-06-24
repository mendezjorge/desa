
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020341A" is

procedure pp_iniciar (p_peco_codi                 out number,
                      p_sucu_codi                 out number,
                      p_empr_codi                 out number,
                      p_empr_desc                 out varchar2,
                      p_sucu_desc                 out varchar2,
                      p_depo_codi_alte            out number,
                      p_depo_desc                 out varchar2,
                      p_depo_codi                 out number,
                      p_user_indi_borr            out varchar2,
                      p_codi_base                 out number,
                      p_indi_vali_cabe            out varchar2,
                      p_form_impr_pane_fact       out varchar2,
                      p_cant_fact                 out number,
                      p_cant_sin_fact             out number,
                      p_indi_vali_cred_plan_fact  out varchar2,
                      p_indi_vali_situ_plan_fact  out varchar2,
                      p_porc_comi_aqui_pago       out number,
                      p_aqui_pago_impo_mini_comi  out number,
                      p_aqui_pago_impo_maxi_comi  out number,
                      p_fech_inic                 out date,
                      p_fech_fini                 out date) is

begin


 ----------------cargar parametros
 --  :benca.version := :parameter.p_version;
 --  pa_devu_fech_habi(:parameter.p_fech_inic,:parameter.p_fech_fini );
   
   p_codi_base           := pack_repl.fa_devu_codi_base;
   p_indi_vali_cabe      := 'S';
   p_form_impr_pane_fact := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_pane_fact')));

   p_cant_fact           := 0;
   p_cant_sin_fact       := 0;
   p_indi_vali_cred_plan_fact := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_cred_plan_fact')));
   p_indi_vali_situ_plan_fact := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_situ_plan_fact')));
   
   p_porc_comi_aqui_pago := to_number(general_skn.fl_busca_parametro('p_porc_comi_aqui_pago'));
   p_aqui_pago_impo_mini_comi := to_number(general_skn.fl_busca_parametro('p_aqui_pago_impo_mini_comi'));
   p_aqui_pago_impo_maxi_comi := to_number(general_skn.fl_busca_parametro('p_aqui_pago_impo_maxi_comi'));
   
 
  p_peco_codi := 1;
  p_sucu_codi := 1;
  p_empr_codi := 1;
  

 --------------------------------
   ---pl_muestra_come_empr(:bsel.empr_codi, :bsel.empr_desc);

 begin
     select empr_desc
              into p_empr_desc   
              from come_empr r
              where empr_codi = p_empr_codi;
     exception
          when no_data_found then
             null;
        end;
  if p_sucu_codi is not null then
    begin
      select sucu_desc
        into p_sucu_desc
        from come_sucu
       where sucu_codi = p_sucu_codi;
    exception
      when no_data_found then
         null;
    end;
  
    begin
      select min(depo_codi_alte)
        into p_depo_codi_alte
        from come_depo
       where depo_sucu_codi = p_sucu_codi;
    exception
      when no_data_found then
        p_depo_codi_alte := 1; --asigna deposito 1 pr defecto
    end;
    
    pp_muestra_come_depo_alte(p_empr_codi,
                              p_depo_codi_alte,
                              p_depo_desc,
                              p_depo_codi);   
  end if;
  
  
  
  begin
    select nvl(user_indi_borr_proc_pane_fact, 'N')
      into p_user_indi_borr
      from segu_user
     where user_login = gen_user;
  exception
    when no_data_found then
        p_user_indi_borr := 'N';
  end;
end pp_iniciar;

procedure pp_muestra_come_depo_alte(p_empr_codi       in number,
                                    p_depo_codi_alte  in varchar2,
                                    p_depo_desc       out varchar2,
                                    p_depo_codi       out number) is
                                    
  v_depo_indi_fact  varchar2(1);
  
begin
  select d.depo_desc, d.depo_codi
    into p_depo_desc, p_depo_codi
    from come_depo d
   where d.depo_empr_codi = p_empr_codi
     and ltrim(rtrim(lower(d.depo_codi_alte))) = ltrim(rtrim(lower(p_depo_codi_alte)));
  
exception
  when no_data_found then
    p_depo_desc      := null;
    p_depo_codi      := null;

end pp_muestra_come_depo_alte;


procedure pp_muestra_come_clpr (p_clpr_codi_alte in number,
                                p_clpr_desc      out varchar2,
                                p_clpr_codi      out varchar2) is
begin
	select clpr_desc, clpr_codi
	  into p_clpr_desc, p_clpr_codi
	  from come_clie_prov
	 where clpr_codi_alte = p_clpr_codi_alte
	   and clpr_indi_clie_prov = 'C';
  
exception        
  when no_data_found then

    raise_application_error(-20001, 'Cliente inexistente!');

  
end pp_muestra_come_clpr;


procedure pp_muestra_come_clas1 (p_clas1_codi_alte in number,
                                 p_clas1_desc      out varchar2,
                                 p_clas1_codi      out varchar2) is
begin
	select clas1_desc, clas1_codi
	  into p_clas1_desc, p_clas1_codi
	  from come_clie_clas_1
	 where clas1_codi_alte = p_clas1_codi_alte;
  
exception        
  when no_data_found then 
     raise_application_error(-20001,'Clasificaci?n de cliente inexistente!');

end pp_muestra_come_clas1;


procedure pp_cargar_cicl_fact (p_cifa_nume        in number,
                               p_cifa_codi        out number,
                               p_cifa_desc        out varchar2,
                               p_cifa_dia_desd    out number,
                               p_cifa_dia_hast    out number,
                               p_cifa_dia_fact    out number
                               ) is

begin
  
  select c.cifa_codi,
         c.cifa_desc,
         c.cifa_dia_fact,
         c.cifa_dia_desd,
         c.cifa_dia_hast
    into p_cifa_codi,
         p_cifa_desc,
         p_cifa_dia_fact,
         p_cifa_dia_desd,
         p_cifa_dia_hast
    from come_cicl_fact c
   where ltrim(ltrim(cifa_nume)) = ltrim(rtrim(p_cifa_nume))
     and cifa_empr_codi =1;
  
exception
  when no_data_found then
raise_application_error(-20001, 'Ciclo inexistente.');
end pp_cargar_cicl_fact;


procedure pp_muestra_come_sose_codi (p_sose_codi        in number,
                                     p_clpr_codi        in number,
                                     p_sose_nume        out number,
                                     p_sose_fech_emis   out date)is 
  
begin
 --raise_application_error(-20001, p_sose_codi||'--'||p_clpr_codi);
  select sose_nume,
         sose_fech_emis
    into p_sose_nume,
         p_sose_fech_emis
    from come_soli_serv, come_clie_prov
   where sose_clpr_codi = clpr_codi
     and (clpr_codi = p_clpr_codi or p_clpr_codi is null)
     and sose_codi = p_sose_codi;
   --  and sose_nume = p_sose_codi ;
                            
exception
  when no_data_found then
   raise_application_error(-20001, 'Solicitud de Servicio inexistente.');

END pp_muestra_come_sose_codi;


procedure pp_muestra_anex(p_anex_nume       in number,
                          p_sose_codi       in number,
                          p_anex_codi       out number,
                          p_anex_fech_emis  out date,
                          p_anex_nume_refe  out number) is
  
begin
  
 -- raise_application_error(-20001,p_anex_nume||'**'||p_sose_codi);
    select anex_codi,
           anex_fech_emis,
           anex_nume_refe
      into p_anex_codi,
           p_anex_fech_emis,
           p_anex_nume_refe
      from come_soli_serv_anex
     where anex_nume = p_anex_nume
       and (p_sose_codi is null or anex_sose_codi = p_sose_codi)
       and anex_empr_codi = 1
       and anex_esta = 'A';

exception
  when no_data_found then
    raise_application_error(-20001, 'Anexo inexistente.');

end pp_muestra_anex ;

procedure pp_valida_faau_nume (p_faau_nume in number,
                               p_faau_codi out number ) is

begin
  
    select a.faau_codi
      into p_faau_codi
      from come_fact_auto a
     where a.faau_nume =p_faau_nume;

exception
  when no_data_found then
    raise_application_error(-20001, 'Nro de Proceso inexistente.');
end;

procedure pp_ejecutar_consulta (p_clpr_codi                  in number,
                                p_cifa_codi                  in number,
                                p_sose_codi                  in number,
                                p_sose_nume                  in number,
                                p_anex_codi                  in number,
                                p_tipo_fact                  in varchar2,
                                p_agru_anex                  in varchar2,
                                p_fech_fact_desd             in date,
                                p_fech_fact_hast             in date,
                                p_sucu_codi                  in number,
                                p_clas1_codi                 in number,
                                p_indi_excl_clie_clas1       in varchar2,
                                p_faau_codi                  in number,                    
                                p_peco_codi                  in number,
                                p_clpr_desc                  in varchar2,
                                p_ulti_movi_nume             out number,
                                p_cant_sin_fact              out number,
                                p_porc_comi_aqui_pago        in number,
                                p_aqui_pago_impo_mini_comi   in number,
                                p_aqui_pago_impo_maxi_comi   in varchar2) is

  ta_plan_fact_deta   pack_fact_ciclo.tt_plan_fact_deta;
  v_indi_fact         varchar2(1);
  v_user_codi         number;
  
  v_deta_indi_mail   varchar2(2);
  p_indi_cons	   varchar2(2);	
  v_color	           varchar2(20);
  v_indi_mens        varchar2(2);	
 -- v_indi_fact	   varchar2(2);	
  
  v_dias_atra         number;                                           
  v_situ_codi         number;
  v_situ_indi_auma    varchar2(1);
  v_situ_indi_fact    varchar2(1);
      
  v_situ_colo         varchar2(100);
  v_situ_desc         varchar2(60);
  --v_indi_fact         varchar2(20);
  
  v_clpr_cli_situ_codi        number;
  v_clpr_indi_vali_situ_clie  varchar2(20);
  v_clpr_indi_exce            varchar2(1);
  v_clpr_indi_vali_limi_cred  varchar2(2);
  p_indi_mens                 varchar2(2);
  v_indi_impr_pdf             varchar2(2);
  
  v_anpl_impo_reca_red_cobr   number;
  v_clie_moro number;
  v_user varchar2(100) := gen_user;
  v_seq number;
begin  
  
     begin
       select user_codi
         into v_user_codi
         from segu_user
        where user_login = gen_user;
     end;
    
  if p_clpr_codi is not null then 
     begin
      select count(cusi_clpr_codi)
      into v_clie_moro
      from come_cuot_pend_situ
     where cusi_estado = 'M'
     and cusi_clpr_codi =p_clpr_codi ;
     
     exception
       when no_data_found then
         v_clie_moro := 0;
     end;
     
     if v_clie_moro > 0 then
       raise_application_error(-20005,
                               'El cliente posee 4 o mas facturas pendientes');
     end if;
 
 
  end if;
  p_cant_sin_fact       := 0;
  pack_fact_ciclo.pa_gene_plan_fact(p_clpr_codi,
                                    p_cifa_codi,
                                    p_sose_codi,
                                    p_sose_nume,
                                    p_anex_codi,
                                    p_tipo_fact,
                                    p_agru_anex,
                                    p_fech_fact_desd,
                                    p_fech_fact_hast,
                                    v_user_codi,
                                    p_sucu_codi,
                                    p_clas1_codi,
                                    nvl(p_indi_excl_clie_clas1, 'N'),
                                    p_faau_codi,
                                    ta_plan_fact_deta);
  
  
  begin
    select nvl(secu_nume_fact,0)
      into p_ulti_movi_nume
      from come_secu
     where secu_codi = (select peco_secu_codi
                          from come_pers_comp
                         where peco_codi = p_peco_codi);
  end;
  
APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'PLAN_FACT_DETA');      
   delete come_tabl_auxi a
   where a.taax_sess = V('APP_SESSION')
   AND a.taax_user  = v_user;

  if ta_plan_fact_deta.count > 0 then
    for x in 1..ta_plan_fact_deta.count loop
       begin
        select nvl(deta_indi_mail, 'N')
          into v_deta_indi_mail
          from come_fact_auto_deta
         where deta_movi_codi = ta_plan_fact_deta(x).movi_codi;
      exception
        when no_data_found then
          v_deta_indi_mail := 'N';
      end;
      
      
      p_indi_cons:= 'S';
    -----------------  pp_asig_colr(:system.trigger_record, 'S');
  if v_deta_indi_mail = 'S' then
    if p_indi_cons = 'N' then
      v_color := 'g';--'gris';
      --v_color:= '#e8e8e8';
      update come_fact_auto_deta 
         set deta_indi_mail = 'N' 
       where deta_movi_codi = ta_plan_fact_deta(x).movi_codi;
      commit;
      v_deta_indi_mail := 'N';
    else
      v_color := 'a';
     -- v_color:= 'amarillo';
     --  v_color:= '#fff5ce';
      
    end if;
    
  else
    if p_indi_cons = 'S' then
     -- v_color := 'gris';
      --v_color:= '#e8e8e8';
      v_color := 'g';
    else            
     -- v_color:= 'amarillo'; 
    --  v_color:= '#fff5ce';
    v_color := 'a';

      update come_fact_auto_deta 
         set deta_indi_mail = 'S' 
       where deta_movi_codi = ta_plan_fact_deta(x).movi_codi;

      v_deta_indi_mail := 'S';
    end if;
  end if;
      
      begin
        select clpr_cli_situ_codi, nvl(clpr_indi_vali_situ_clie, 'S'),
               clpr_indi_exce, nvl(clpr_indi_vali_limi_cred, 'S')
          into v_clpr_cli_situ_codi, v_clpr_indi_vali_situ_clie,
               v_clpr_indi_exce, v_clpr_indi_vali_limi_cred
          from come_clie_prov 
         where clpr_codi = ta_plan_fact_deta(x).clpr_codi;
      exception
        when no_data_found then
          v_clpr_cli_situ_codi        := null;
          v_clpr_indi_vali_situ_clie  := null;
          v_clpr_indi_exce            := null;
          v_clpr_indi_vali_limi_cred  := null;
      end;
      




  v_indi_mens:= 'N';
  
  ------------pp_deter_situ_clie
  
   if v_clpr_cli_situ_codi is not null then
    begin     
       select situ_indi_auma , situ_indi_fact,   situ_colo,   situ_desc
       into  v_situ_indi_auma, v_situ_indi_fact, v_situ_colo, v_situ_desc
       from come_situ_clie
       where situ_codi = v_clpr_cli_situ_codi;     

    exception
       When others then             
          v_situ_indi_auma := 'A';
          v_situ_indi_fact := null;
          v_situ_colo      := null;
          v_situ_desc      := null;
    end; 
  else  
     v_situ_indi_auma := 'A';
     v_situ_indi_fact := 'S';
     v_situ_colo      := null;
     v_situ_desc      := null;    
  end if; 

  if v_situ_indi_auma = 'A' then --si es automatico se realiza un refresh para determinar la situacion en el momento    
     v_dias_atra := fa_devu_dias_atra_clie(p_clpr_codi);
    begin
      select situ_colo, situ_indi_fact,    situ_desc
        into v_situ_colo, v_situ_indi_fact, v_situ_desc
        from come_situ_clie
       where v_dias_atra between situ_dias_atra_desd and situ_dias_atra_hast; 
         
    exception
      when no_data_found then
        v_situ_colo      := 'B';
        v_situ_indi_fact := 'S';
        v_situ_desc      := ' ';
      when too_many_rows then
        raise_application_error(-20001,'Existe mas de una situacion de cliente que contiene '||v_dias_atra||' dias de atraso dentro de su rango. Para el cliente '||p_clpr_desc);      
    end;
  end if;
  
  ---setear el color 
  if v_situ_colo ='R' then 
     v_situ_colo:= '#ff0003';
  elsif v_situ_colo ='A' then 
      v_situ_colo:= '#f9ff00';
  elsif v_situ_colo ='B' then 
      v_situ_colo:= '#ffffff';
  elsif v_situ_colo ='Z' then 
      v_situ_colo:= '#0600ff';
  elsif v_situ_colo ='N' then 
      v_situ_colo:= '#ff8000';
  end if; 
     
   
   --R Rojo--A amarillo, B blanco, Z azul---N naranja

  v_indi_fact := 'S';
  
  if p_indi_mens = 'S' then
    if  nvl(v_clpr_indi_vali_situ_clie, 'S') = 'S' then
      if nvl(v_situ_indi_fact, 'N') = 'N'  then
        if nvl(v_clpr_indi_exce, 'N') = 'S' then -- Si esta en Excepcion solo se advierte
         apex_application.g_print_success_message :='Atencion, El cliente '||p_clpr_desc||' se encuentra en la situacion '||v_situ_desc;
        else
          p_cant_sin_fact := p_cant_sin_fact + 1;
          v_indi_fact := 'N';
          apex_application.g_print_success_message :='Atencion, No se podr? facturar al cliente '||p_clpr_desc||'. Se encuentra en la situacion '||v_situ_desc; 
        end if;
      end if;
    end if;
  end if;
 
    
      if ta_plan_fact_deta(x).movi_codi is not null then
        v_indi_impr_pdf := 'S';
      else        
        v_indi_impr_pdf := 'N';
      end if;
    
        -------------------
      v_anpl_impo_reca_red_cobr:= fp_devu_impo_reca_red_cobr (ta_plan_fact_deta(x).clpr_codi, 
                                                              ta_plan_fact_deta(x).anex_codi, 
                                                              ta_plan_fact_deta(x).anex_sose_codi, 
                                                              ta_plan_fact_deta(x).sose_nume, 
                                                              ta_plan_fact_deta(x).anpl_fech_fact, 
                                                              p_fech_fact_desd, 
                                                              p_fech_fact_hast,
                                                              p_porc_comi_aqui_pago,
                                                              p_aqui_pago_impo_mini_comi,
                                                              p_aqui_pago_impo_maxi_comi);
         ----------------
         
         
         select seq_come_tabl_auxi.nextval
   into v_seq
  from dual seq_id;

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
   taax_c023,
   taax_c024,
   taax_c025,
   taax_c026,
   taax_c027,
   taax_c028,
   taax_c029,
   taax_c030,
   taax_c031,
   taax_c032,
   
   taax_seq
  )
values
  (V('APP_SESSION'),
   v_user,
ta_plan_fact_deta(x).clpr_codi,
 ta_plan_fact_deta(x).clpr_codi_alte,
 ta_plan_fact_deta(x).clpr_desc,
 ta_plan_fact_deta(x).sucu_nume_item,
 ta_plan_fact_deta(x).sucu_desc,
 ta_plan_fact_deta(x).anex_codi,
 ta_plan_fact_deta(x).anex_nume,
 ta_plan_fact_deta(x).anex_sose_codi,
 ta_plan_fact_deta(x).anpl_fech_fact,
 ta_plan_fact_deta(x).anpl_impo_mone,
 ta_plan_fact_deta(x).anpl_fech_venc,
 ta_plan_fact_deta(x).movi_codi,
 ta_plan_fact_deta(x).movi_nume,
 ta_plan_fact_deta(x).movi_fech_emis,
 ta_plan_fact_deta(x).sose_nume,
 v_deta_indi_mail,
 p_indi_cons,
 v_color,
 p_indi_cons,
 v_clpr_cli_situ_codi, 
 v_clpr_indi_vali_situ_clie,
 v_clpr_indi_exce, 
 v_clpr_indi_vali_limi_cred,
 v_indi_mens,
 v_situ_indi_auma, 
 v_situ_indi_fact, 
 v_situ_colo, 
 v_situ_desc,
 v_dias_atra,
 v_indi_fact,
 v_indi_impr_pdf,
 v_anpl_impo_reca_red_cobr,
 v_seq
  );


/*        
        APEX_COLLECTION.ADD_MEMBER(p_collection_name =>'PLAN_FACT_DETA',      
                                    p_c001            => ta_plan_fact_deta(x).clpr_codi,
                                    p_c002            => ta_plan_fact_deta(x).clpr_codi_alte,
                                    p_c003            => ta_plan_fact_deta(x).clpr_desc,
                                    p_c004            => ta_plan_fact_deta(x).sucu_nume_item,
                                    p_c005            => ta_plan_fact_deta(x).sucu_desc,
                                    p_c006            => ta_plan_fact_deta(x).anex_codi,
                                    p_c007            => ta_plan_fact_deta(x).anex_nume,
                                    p_c008            => ta_plan_fact_deta(x).anex_sose_codi,
                                    p_c009            => ta_plan_fact_deta(x).anpl_fech_fact,
                                    p_c010            => ta_plan_fact_deta(x).anpl_impo_mone,
                                    p_c011            => ta_plan_fact_deta(x).anpl_fech_venc,
                                    p_c012            => ta_plan_fact_deta(x).movi_codi,
                                    p_c013            => ta_plan_fact_deta(x).movi_nume,
                                    p_c014            => ta_plan_fact_deta(x).movi_fech_emis,
                                    p_c015            => ta_plan_fact_deta(x).sose_nume,
                                    p_c016            => v_deta_indi_mail,
                                    p_c017            => p_indi_cons,
                                    p_c018            => v_color,
                                    p_c019            => p_indi_cons,
                                    p_c020            => v_clpr_cli_situ_codi, 
                                    p_c021            => v_clpr_indi_vali_situ_clie,
                                    p_c022            => v_clpr_indi_exce, 
                                    p_c023            => v_clpr_indi_vali_limi_cred,
                                    p_c024            => v_indi_mens,
                                    p_c025            => v_situ_indi_auma, 
                                    p_c026            => v_situ_indi_fact, 
                                    p_c027            => v_situ_colo, 
                                    p_c028            => v_situ_desc,
                                    p_c029            => v_dias_atra,
                                    p_c030            => v_indi_fact,
                                    p_c031            => v_indi_impr_pdf,
                                    p_c032            => v_anpl_impo_reca_red_cobr);--este ultimo*/
                                    --revisar donde carga no encuentro
         
  
     
    end loop;
   ---RAISE_APPLICATION_ERROR(-20001,'DINNNNN');     
  end if;
  
  
end pp_ejecutar_consulta;


procedure pp_cargar_deta_anex_plan (p_anex_codi   in number,
                                    p_sose_codi   in number,
                                    p_sose_nume   in number,
                                    p_fech_fact   in date,
                                    p_fech_desd   in date,
                                    p_fech_hast   in date,
                                    p_faau_codi   in number,
                                    p_codi_clie in number) is

  cursor c_anex_plan is
    select s.sose_nume,
           a.anex_nume,
           a.anex_nume_refe,
           cf.cifa_nume,
           cf.cifa_desc,
           ap.anpl_fech_fact,
           ap.anpl_fech_desd,
           ap.anpl_fech_hast,
           ap.anpl_fech_venc,
           a.anex_cant_movi,
           ap.anpl_impo_mone,
           ad.deta_iden,
           c.conc_desc,
           ad.deta_codi_anex_padr,
           v.vehi_nume_pate chapa
      from come_soli_serv_anex_plan ap,
           come_cicl_fact cf,
           come_soli_serv s,
           come_soli_serv_anex a,
           come_soli_serv_anex_deta ad,
           come_conc c,
           come_vehi v
     where ap.anpl_cifa_codi = cf.cifa_codi
       and ap.anpl_anex_codi = a.anex_codi
       and a.anex_codi       = ad.deta_anex_codi
       and ad.deta_codi      = ap.anpl_deta_codi
       and ad.deta_conc_codi = c.conc_codi
       and ad.deta_vehi_codi = v.vehi_codi(+)
       and s.sose_clpr_codi=p_codi_clie
       and ((nvl(ad.deta_esta, 'P') <> 'D' and nvl(ad.deta_esta_plan, 'S') = 'S') or 
            (nvl(ad.deta_esta, 'P') = 'D' and nvl(ap.anpl_deta_esta_plan, 'S') = 'S'))
       and nvl(ap.anpl_deta_esta_plan, 'S') = 'S'
       and nvl(ap.anpl_indi_fact_cuot, 'N') <> 'S'       
       and a.anex_sose_codi  = s.sose_codi
       and ( p_anex_codi is  null or anpl_anex_codi = p_anex_codi) 
       and (p_sose_codi is  null or s.sose_codi = p_sose_codi) 
       and (p_sose_nume is  null or s.sose_nume = p_sose_nume )
             
       and ((ap.anpl_movi_codi is null and nvl(ap.anpl_indi_fact, 'N') <> 'S'  
       and ((p_codi_clie is not null and ap.anpl_fech_fact = p_fech_fact) or (p_codi_clie is not null and ap.anpl_fech_fact >= p_fech_desd and ap.anpl_fech_fact <= p_fech_hast)))
        or (p_faau_codi is not null and ap.anpl_faau_codi = p_faau_codi and p_sose_codi = s.sose_codi))
                
       /*and ((ap.anpl_movi_codi is null and nvl(ap.anpl_indi_fact, 'N') <> 'S'
       and ((p_anex_codi is not null and anpl_anex_codi = p_anex_codi) or
             (p_anex_codi is null and p_sose_codi is not null and s.sose_codi = p_sose_codi) or 
             (p_anex_codi is null and p_sose_codi is null and s.sose_nume = p_sose_nume))
        and ((p_anex_codi is not null and ap.anpl_fech_fact = p_fech_fact) 
          or (p_anex_codi is null and ap.anpl_fech_fact >= p_fech_desd and ap.anpl_fech_fact <= p_fech_hast))) or 
            (p_faau_codi is not null and ap.anpl_faau_codi = p_faau_codi and p_sose_codi = s.sose_codi))*/
  order by s.sose_codi, a.anex_codi, ap.anpl_fech_desd;
 

x_deta_iden varchar2(1000); 
begin
  
--raise_application_error(-20001, p_codi_clie );
   APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'ANEXO_PLAN');      
   
  for x in c_anex_plan loop
    if x.deta_iden is null and x.deta_codi_anex_padr is not null then
      begin
        select deta_iden
          into x_deta_iden
          from come_soli_serv_anex_deta
         where deta_codi = x.deta_codi_anex_padr;
      exception
        when no_data_found then
          x_deta_iden := null;
      end;
    else
      x_deta_iden        := x.deta_iden;
    end if;
   APEX_COLLECTION.ADD_MEMBER(p_collection_name =>'ANEXO_PLAN', 
                              p_c001            => x.sose_nume,
                              p_c002            => x.anex_nume,
                              p_c003            => x.anex_nume_refe,
                              p_c004            => x.cifa_nume,
                              p_c005            => x.cifa_desc,
                              p_c006            => x.anpl_fech_fact,
                              p_c007            => x.anpl_fech_desd,
                              p_c008            => x.anpl_fech_hast,
                              p_c009            => x.anpl_fech_venc,
                              p_c010            => x.anex_cant_movi,
                              p_c011            => x.anpl_impo_mone,
                              p_c012            => x.conc_desc,
                              p_c013            => x_deta_iden,
                              p_c014            => x.chapa);

  end loop;


end pp_cargar_deta_anex_plan;


procedure pp_asig_colr(p_accion                 in varchar2,
                  -- p_regi                   in varchar2, 
                  -- p_indi_cons              in varchar2,
                  -- p_deta_indi_mail         in out varchar2,
                  -- p_movi_codi              in varchar2,
                       p_seq_id                 in number,
                       p_faau_codi              in number) is
p_indi_cons varchar2(2);
v_color varchar2(1);

v_deta_indi_mail varchar2(200);
p_movi_codi      varchar2(200);
begin
 if p_accion = 'true' then
     p_indi_cons := 'S';
  else
     p_indi_cons := 'N';
  end if;

select c016 deta_ind_mail,
       c012 movi_codi
  into v_deta_indi_mail, p_movi_codi
  from apex_collections
 where collection_name = 'PLAN_FACT_DETA' 
   and seq_id = p_seq_id;
  
 --- raise_application_error (-20001, p_accion||'-'||p_faau_codi||'-'||p_seq_id||'---'||v_deta_indi_mail||'-'||p_indi_cons );

if p_faau_codi is not null then
	
 
  if v_deta_indi_mail = 'S' then
  
    if p_indi_cons = 'N' then
  ----GRIS
        v_color:= 'g';
   update come_fact_auto_deta
      set deta_indi_mail = 'N'
    where deta_movi_codi = p_movi_codi;

   --- raise_application_error (-20001, 'no se por que'||p_accion||'-'||p_faau_codi||'-'||p_seq_id||'-'||v_deta_indi_mail||'-'||p_movi_codi );

     
      commit;
      
      APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE (p_collection_name  => 'PLAN_FACT_DETA',
                                             p_seq              => p_seq_id,
                                             p_attr_number      => 16,
                                             p_attr_value       => 'N');
      --v_deta_indi_mail := 'N';
    else
     --amarillo
   --  raise_application_error (-20001, p_accion||'-'||p_faau_codi||'-'||p_seq_id||'-'||v_deta_indi_mail||'-'||p_movi_codi );

     
     v_color:= 'a';
           APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE (p_collection_name  => 'PLAN_FACT_DETA',
                                             p_seq              => p_seq_id,
                                             p_attr_number      => 16,
                                             p_attr_value       => 'S');
     null;
   end if;
    
  else
 
    
   if p_indi_cons = 'N' then
      -- raise_application_error (-20001, 'noro do'||p_accion||'-'||p_faau_codi||'-'||p_seq_id||'-'||v_deta_indi_mail||'-'||p_movi_codi );

     
  --      raise_application_error (-20001, p_accion||'-'||p_faau_codi||'-'||p_seq_id||'-'||v_deta_indi_mail||'-'||p_movi_codi );
 --
      v_color:= 'g';
                 APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE (p_collection_name  => 'PLAN_FACT_DETA',
                                             p_seq              => p_seq_id,
                                             p_attr_number      => 16,
                                             p_attr_value       => 'N');
      null;----gris
    else    
      
--      raise_application_error (-20001, 'tes'||p_accion||'-'||p_faau_codi||'-'||p_seq_id||'-'||v_deta_indi_mail||'-'||p_movi_codi );

     
      v_color:= 'a';        
      null;--amarillo
      update come_fact_auto_deta 
      set deta_indi_mail = 'S' 
      where deta_movi_codi = p_movi_codi;
      commit;
      
    
      APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE (p_collection_name  => 'PLAN_FACT_DETA',
                                             p_seq              => p_seq_id,
                                             p_attr_number      => 16,
                                             p_attr_value       => 'S');
     -- v_deta_indi_mail := 'S';
    end if;
  end if;
 




/*
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE (p_collection_name  => 'PLAN_FACT_DETA',
                                             p_seq              => p_seq_id,
                                             p_attr_number      => 32,
                                             p_attr_value       => p_indi_cons);
                                             
                                             
                                             
*/                                        
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE (p_collection_name  => 'PLAN_FACT_DETA',
                                             p_seq              => p_seq_id,
                                             p_attr_number      => 18,
                                             p_attr_value       => v_color);                                         
                                             

  end if;
end pp_asig_colr;




procedure pp_editar_imp_pdf (p_seq_id   in number,
                             p_valor    in varchar2,
                             p_total    in varchar2) is
                             

v_valor  varchar2(1);                            

begin
   --raise_application_error(-20001,p_seq_id||'-'||p_valor||'-'||p_total);    
if p_valor = 'true' then
  v_valor := 'S';
else
  v_valor := 'N';  
end if;


if p_total = 'N' then

    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE (p_collection_name  => 'PLAN_FACT_DETA',
                                             p_seq              => p_seq_id,
                                             p_attr_number      => 31,
                                             p_attr_value       => v_valor);
                                             
                                             
                                             
 else
   for x in (select seq_id,
                    c031
              from apex_collections
             where collection_name = 'PLAN_FACT_DETA') loop
         
        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE (p_collection_name  => 'PLAN_FACT_DETA',
                                                 p_seq              => X.seq_id,
                                                 p_attr_number      => 31,
                                                 p_attr_value       => v_valor);
                                             
                                             
                            
             
    end loop;         

 
 
 end if;           
end pp_editar_imp_pdf;

procedure pp_actualizar_registro (p_faau_nume                       in varchar2,
                                  p_movi_fech_emis                  in date,
                                  p_fech_inic                       in date,
                                  p_fech_fini                       in date,
                                  p_indi_vali_situ_plan_fact        in varchar2,
                                  p_indi_vali_cred_plan_fact        in varchar2,
                                  p_cant_sin_fact                   in varchar2, 
                                  p_cant_fact                       in varchar2,
                                  p_clpr_codi                       in varchar2,
                                  p_cifa_codi                       in varchar2,
                                  p_sose_codi                       in varchar2,
                                  p_sose_nume                       in varchar2,
                                  p_anex_codi                       in varchar2,
                                  p_tipo_fact                       in varchar2,
                                  p_agru_anex                       in varchar2,
                                  p_fech_fact_desd                  in date,
                                  p_fech_fact_hast                  in date,
                                  p_peco_codi                       in varchar2,
                                  p_sucu_codi                       in number,
                                  p_depo_codi                       in number,
                                  p_clas1_codi                      in number,
                                  p_indi_excl_clie_clas1_aseg       in varchar2,
                                  p_faau_codi                       in number) is

v_count           number := 0;
v_indi_fact       varchar2(1);
v_sose_mone_codi  number;
  
v_dias_atra       number;                                           
v_situ_codi       number;
v_situ_indi_auma  varchar2(1);
v_situ_indi_fact  varchar2(1);
                      
v_situ_colo       varchar2(1);
v_situ_desc       varchar2(60);

v_codResp         number;
v_descResp        varchar2(100);
            
v_user_codi       number;
v_movi_codi       number;
  
-------------***

v_indi_mens       varchar2(60);
v_cant_sin_fact   varchar2(60);  
v_cant_fact       number :=0;
v_faau_nume       varchar2(60);

v_faau_codi       varchar2(60):= p_faau_codi;
v_fech_inic varchar2(20);
v_fech_fini varchar2(20);
v_concatenacion varchar2(5000);
begin
  
if p_movi_fech_emis is null then
  	raise_application_error (-20001, 'La fecha del movimiento no puede ser nulo');


end if;





    pa_devu_fech_habi(v_fech_inic,v_fech_fini);
  
  	                   
  if p_movi_fech_emis not between v_fech_inic and v_fech_fini then           
  	raise_application_error (-20001, 'La fecha del movimiento debe estar comprendida entre..'||v_fech_inic ||' y '||v_fech_fini);
  end if;	         
     
 
if p_faau_nume is null then

--- pp_valida_anex_plan              
 -- if p_movi_fech_emis not between p_fech_inic and p_fech_fini then           
  --	raise_application_error(-20001,'La fecha del movimiento debe estar comprendida entre..'||to_char(p_fech_inic, 'dd-mm-yyyy') ||' y '||to_char(p_fech_fini, 'dd-mm-yyyy'));
 -- end if;	         
  
  
   for x in (select taax_c001 clpr_codi,
                    taax_c002 clpr_codi_alte,
                    taax_c003 clpr_desc,
                    taax_c004 sucu_nume_item,
                    taax_c005 sucu_desc,
                    taax_c006 anex_codi,
                    taax_c007 anex_nume,
                    taax_c008 anex_sose_codi,
                    taax_c009 anpl_fech_fact,
                    taax_c010 anpl_impo_mone,
                    taax_c011 anpl_fech_venc,
                    taax_c012 movi_codi,
                    taax_c013 movi_nume,
                    taax_c014 movi_fech_emis,
                    taax_c015 sose_nume,
                    taax_c016 v_deta_indi_mail,
                    taax_c017 indi_cons,
                    taax_c018 v_color,
                    taax_c019 indi_conss,
                    taax_c020 clpr_cli_situ_codi,
                    taax_c021 clpr_indi_vali_situ_clie,
                    taax_c022 clpr_indi_exce,
                    taax_c023 clpr_indi_vali_limi_cred,
                    taax_c024 v_indi_mens,
                    taax_c025 v_situ_indi_auma,
                    taax_c026 v_situ_indi_fact,
                    taax_c027 v_situ_colo,
                    taax_c028 v_situ_desc,
                    taax_c029 v_dias_atra,
                    taax_c030 v_indi_fact,
                    taax_c031 v_indi_impr_pdf,
                    taax_c032 anpl_impo_reca_red_cobr
                from come_tabl_auxi
               where  taax_sess =V('APP_SESSION')
                   and taax_user = gen_user) loop 
  
  if x.clpr_codi is null then
    raise_application_error(-20001, 'No existen detalles de planificaciones a ser facturadas!');
  end if;
  
    if nvl(p_indi_vali_situ_plan_fact, 'S') = 'S' then
      
   -- raise_application_error(-20001,'yes');
      v_indi_mens:= 'S';
       -------------pp_deter_situ_clie
         
                --- primero determinamos si la situacion actual es o no manual
                if x.clpr_cli_situ_codi is not null then
                  begin     
                     select situ_indi_auma , situ_indi_fact,   situ_colo,   situ_desc
                     into  v_situ_indi_auma, v_situ_indi_fact, v_situ_colo, v_situ_desc
                     from come_situ_clie
                     where situ_codi = x.clpr_cli_situ_codi;     

                  exception
                     When others then             
                        v_situ_indi_auma := 'A';
                        v_situ_indi_fact := null;
                        v_situ_colo      := null;
                        v_situ_desc      := null;
                  end; 
                else  
                   v_situ_indi_auma := 'A';
                   v_situ_indi_fact := 'S';
                   v_situ_colo      := null;
                   v_situ_desc      := null;    
                end if; 

                if v_situ_indi_auma = 'A' then --si es automatico se realiza un refresh para determinar la situacion en el momento    
                  v_dias_atra := fa_devu_dias_atra_clie(x.clpr_codi);
                  begin
                    select situ_colo, situ_indi_fact,    situ_desc
                      into v_situ_colo, v_situ_indi_fact, v_situ_desc
                      from come_situ_clie
                     where v_dias_atra between situ_dias_atra_desd and situ_dias_atra_hast; 
                       
                  exception
                    when no_data_found then
                      v_situ_colo      := 'B';
                      v_situ_indi_fact := 'S';
                      v_situ_desc      := ' ';
                    when too_many_rows then
                      raise_application_error(-20001, 'Existe mas de una situacion de cliente que contiene '||v_dias_atra||' dias de atraso dentro de su rango. Para el cliente '||x.clpr_desc);      
                  end;
                end if;
                
                ---setear el color 
              /*  if v_situ_colo = 'R' then --Rojo
                  set_item_instance_property('bdet.clpr_codi_alte'      ,to_number(p_regi) , visual_attribute, 'visual_reg_rojo' );
                elsif v_situ_colo = 'G' then                                                                                    
                  set_item_instance_property('bdet.clpr_codi_alte'      ,to_number(p_regi) , visual_attribute, 'visual_reg_gris' );
                elsif v_situ_colo = 'A' then --Amarillo
                  set_item_instance_property('bdet.clpr_codi_alte'      ,to_number(p_regi) , visual_attribute, 'visual_reg_amarillo' );
                elsif v_situ_colo = 'B' then --Blanco
                  set_item_instance_property('bdet.clpr_codi_alte'      ,to_number(p_regi) , visual_attribute, 'visual_reg_blanco' );
                elsif v_situ_colo = 'Z' then --azul
                  set_item_instance_property('bdet.clpr_codi_alte'      ,to_number(p_regi) , visual_attribute, 'visual_reg_azul' );
                elsif v_situ_colo = 'N' then --Naranja
                  set_item_instance_property('bdet.clpr_codi_alte'      ,to_number(p_regi) , visual_attribute, 'visual_reg_naranja' );
                else
                  set_item_instance_property('bdet.clpr_codi_alte'      ,to_number(p_regi) , visual_attribute, 'visual_reg_blanco' );
                end if;     */    
            
                
                v_indi_fact := 'S';
                
                if v_indi_mens = 'S' then
                  if  nvl(x.clpr_indi_vali_situ_clie, 'S') = 'S' then
                    if nvl(v_situ_indi_fact, 'N') = 'N'  then
                        if nvl(x.clpr_indi_exce, 'N') = 'S' then -- Si esta en Excepcion solo se advierte
                          apex_application.g_print_success_message :='Atencion, El cliente '||x.clpr_desc||' se encuentra en la situacion '||v_situ_desc;
                        else
                          v_cant_sin_fact := v_cant_sin_fact + 1;
                          v_indi_fact := 'N';
                          apex_application.g_print_success_message :='Atencion, No se podr? facturar al cliente '||x.clpr_desc||'. Se encuentra en la situacion '||v_situ_desc; 
                        end if;
                    end if;
                  end if;
                end if;                
    end if;-----------------pp_deter_situ_clie 

    if nvl(v_indi_fact, 'S') = 'S' then
       
      if nvl(p_indi_vali_cred_plan_fact, 'S') = 'S' then
       
              begin
                select sose_mone_codi
                  into v_sose_mone_codi
                  from come_soli_serv
                 where ((x.anex_sose_codi is not null and sose_codi = x.anex_sose_codi) or 
                        (x.anex_sose_codi is null and x.sose_nume is not null and sose_nume = x.sose_nume))
              group by sose_mone_codi;                   
              exception
                when no_data_found then
                  v_sose_mone_codi := 1;
                when too_many_rows then
                  v_sose_mone_codi := 1;
              end;
        
              pp_valida_limi_cred (x.clpr_codi,
                                   nvl(v_sose_mone_codi, 1),
                                   x.clpr_indi_vali_limi_cred,
                                   x.anpl_impo_mone,
                                   x.clpr_desc);
      end if;
    end if;
      v_cant_fact := v_cant_fact + 1;
    
        ----  pp_actualiza_anex_plan 
          begin  
            
                  begin
                    select user_codi
                      into v_user_codi
                      from segu_user
                     where user_login = gen_user;
                  end;
        --raise_application_error(-20001,3000||'+++'||v_cant_fact||'----'||p_cant_sin_fact);
      
                 if nvl(v_cant_fact, 0) > nvl(p_cant_sin_fact, 0) then
                   
                 
            
                   
              --  raise_application_error(-20001,'afadfdf');
                   pack_fact_ciclo.pa_gene_plan_fact_movi (p_clpr_codi,
                                                           p_cifa_codi,
                                                           p_sose_codi,
                                                           p_sose_nume,
                                                           p_anex_codi,
                                                           p_tipo_fact,
                                                           p_agru_anex,
                                                           p_fech_fact_desd,
                                                           p_fech_fact_hast,
                                                           p_movi_fech_emis,
                                                           p_peco_codi,
                                                           v_user_codi,
                                                           p_sucu_codi,
                                                           p_depo_codi,
                                                           p_clas1_codi,
                                                           x.anpl_impo_reca_red_cobr,
                                                           nvl(p_indi_excl_clie_clas1_aseg, 'N'),
                                                           v_faau_codi,                                           
                                                           v_codResp,
                                                           v_descResp,
                                                           v_movi_codi);
                                                           
                                                           
                  -- se comento para que solo se envie por el job 06/09/2023 juanb
                     /* if v_codResp = 1 then
                        
                         env_fact_sifen.pp_get_json_fact(v_movi_codi);
                        commit;
                        
                        begin
                          i020273_a.pp_enviar_sms_fact(p_movi_codi => v_movi_codi);
                        end;*
                       
                      else
                        raise_application_error(-20001, v_descResp);
                      end if;   */
                      
                 end if;
             end;  ----  pp_actualiza_anex_plan is
    
    
  
  end loop; --- pp_valida_anex_plan        
  




          if p_faau_codi is not null then
                begin
                  select faau_nume
                    into v_faau_nume
                    from come_fact_auto
                   where faau_codi = p_faau_codi;
                exception
                  when no_data_found then
                    v_faau_nume := null;
                end;
          end if;
else
	--No deberia de entrar aqui ya que no deberia estar habilitado el boton si se consulta un proceso
	raise_application_error(-20001, 'Estas planificaciones ya poseen facturas generadas, favor verifique!');
end if;

   delete come_tabl_auxi a
   where a.taax_sess = V('APP_SESSION')
   AND a.taax_user  = GEN_USER;

end pp_actualizar_registro;

procedure  pp_valida_limi_cred (p_movi_clpr_codi            in number,
                                p_movi_mone_codi            in number,
                                p_clpr_indi_vali_limi_cred  in varchar2,
                                p_total                     in number,
                                p_clpr_desc                 in varchar2
                                )is

  v_sald_limi_cred    number;
  v_impo_deto         number;
  v_impo_pedi_conf    number;
  v_cred_espe_mone    number;
  v_limi_cred_mone    number;
  v_sald_clie_mone    number;
  v_pres_impo_deto    number;
  v_cant_sin_fact     number;
  
  
begin                         
 
  begin
    pa_devu_limi_cred_espe(p_movi_clpr_codi,
                           p_movi_mone_codi,
                           v_cred_espe_mone);
  exception
    when others then
    raise_application_error(-20001, 'Error en el limite de credito');
  end;

  begin
    pa_devu_limi_cred_clie(p_movi_clpr_codi,
                           p_movi_mone_codi,
                           v_limi_cred_mone,
                           v_sald_clie_mone,
                           v_sald_limi_cred);
  exception
    when others then
      raise_application_error(-20002, 'Error en el limite de credito');
  end;
  
  begin
      pa_devu_pedi_conf(p_movi_clpr_codi,
                        p_movi_mone_codi,
                        v_pres_impo_deto); 
  exception
    when others then
     raise_application_error(-20003, 'Error en el limite de credito');
  end;
  
  v_sald_limi_cred := nvl(v_limi_cred_mone,0) + nvl(v_cred_espe_mone,0) - nvl(v_sald_clie_mone,0) - nvl(v_pres_impo_deto,0);
                                           
  if nvl(p_clpr_indi_vali_limi_cred, 'S') = 'S' then
    if nvl(p_total,0) > nvl(v_sald_limi_cred,0) then
      if nvl(p_total,0) > nvl(v_cred_espe_mone,0) then
        v_cant_sin_fact := v_cant_sin_fact + 1;
        apex_application.g_print_success_message :='Atencion, No se podr? facturar al cliente '||p_clpr_desc||'. La factura supera al Limite de Credito que posee!';
      end if;
    end if;  
  end if;
  
end pp_valida_limi_cred;



procedure pp_borrar_registro (p_faau_codi in number) is
   v_message   varchar2(70) := '?Realmente desea Borrar el registro?';
   
   v_codresp    number;
   v_descresp   varchar2(100);
   
BEGIN

    pack_fact_ciclo.pa_elim_plan_fact_movi (p_faau_codi,
                                            v_codResp,
                                            v_descResp);
                                            
    if v_codResp <> 1 then
      raise_application_error(-20001,v_descResp);
    end if;

end pp_borrar_registro;



function fp_devu_impo_reca_red_cobr (p_clpr_codi        in number,
                                     p_anex_codi        in number,
                                     p_anex_sose_codi   in number,
                                     p_sose_nume        in number,
                                     p_fech_fech_fact   in date,
                                     p_fech_fact_desd   in date,
                                     p_fech_fact_hast   in date,
                                     p_porc_comi_aqui_pago in varchar2,
                                     p_aqui_pago_impo_mini_comi in varchar2,
                                     p_aqui_pago_impo_maxi_comi in varchar2
                                     )return number is

  cursor c_anex_plan_cuot (p_c_anex_codi in number,
                           p_c_sose_codi in number,
                           p_c_sose_nume in number,
                           p_c_fech_fact in date,
                           p_c_fech_desd in date,
                           p_c_fech_hast in date) is
    select ap.anpl_fech_venc,
           sum(ap.anpl_impo_mone) sum_anpl_impo_mone
      from come_soli_serv_anex_plan ap,
           come_soli_serv s,
           come_soli_serv_anex a,
           come_soli_serv_anex_deta ad
     where ap.anpl_anex_codi = a.anex_codi
       and a.anex_codi       = ad.deta_anex_codi
       and ad.deta_codi = ap.anpl_deta_codi
       and a.anex_sose_codi  = s.sose_codi
       and nvl(ad.deta_esta_plan, 'S') = 'S'
       and nvl(ap.anpl_indi_fact, 'N') <> 'S'
       and nvl(ap.anpl_indi_fact_cuot, 'N') <> 'S'
       and nvl(ap.anpl_deta_esta_plan, 'S') = 'S'
       and ap.anpl_movi_codi is null
       and ap.anpl_nume_item <> 1
       and s.sose_clpr_codi= p_clpr_codi
       and ((p_c_anex_codi is not null and anpl_anex_codi = p_c_anex_codi) or
            (p_c_anex_codi is null and p_c_sose_codi is not null and s.sose_codi = p_c_sose_codi) or
            (p_c_anex_codi is null and p_c_sose_codi is null and s.sose_nume = p_c_sose_nume))
       and ((p_c_anex_codi is not null and ap.anpl_fech_fact = p_c_fech_fact) or
           (p_c_anex_codi is null and ap.anpl_fech_fact >= p_c_fech_desd and ap.anpl_fech_fact <= p_c_fech_hast))
       and ((ap.anpl_nume_item >= nvl(a.anex_cant_cuot_modu, 1) and nvl(ad.deta_indi_anex_modu, 'N') = 'N') or
              (ap.anpl_nume_item <= nvl(a.anex_cant_cuot_modu, 1) and
              ((nvl(a.anex_indi_fact_impo_unic, 'S') = 'S' and nvl(a.anex_impo_mone_unic, 0) > 0) or
               (nvl(a.anex_impo_mone_unic, 0) <= 0))))
     group by ap.anpl_fech_venc
     order by ap.anpl_fech_venc;
     
  v_impo_reca       number;
  v_cant_sepa_reca  number := 0;
  v_mepa_indi_reca_red_cobr varchar2(1);
  v_impo_mone_cuot  number;
  v_tota_reca       number := 0;
  
begin
  
  begin
    select nvl(mepa_indi_reca_red_cobr, 'N')
      into v_mepa_indi_reca_red_cobr
      from come_clie_prov, come_medi_pago
     where clpr_codi = p_clpr_codi
       and clpr_mepa_codi = mepa_codi(+);
  exception
    when no_data_found then
      v_mepa_indi_reca_red_cobr := 'N';
  end;
  
  if nvl(v_mepa_indi_reca_red_cobr, 'N') = 'S' then
    for d in c_anex_plan_cuot(p_anex_codi,
                              p_anex_sose_codi,
                              p_sose_nume,
                              p_fech_fech_fact,
                              p_fech_fact_desd,
                              p_fech_fact_hast) loop
    -- v_cant_sepa_reca := v_cant_sepa_reca + 1;
    --end loop;
               
    if gen_user = 'SKN' then
      insert into come_concat
                 (campo1,  otro)
               values
                 (p_anex_codi||'-'||
                              p_anex_sose_codi||'-'||
                              p_sose_nume||'-'||
                              p_fech_fech_fact||'-'||
                              p_fech_fact_desd||'-'||
                              p_fech_fact_hast,  'v_otro' );
      commit;
     end if; 
      v_impo_mone_cuot := d.sum_anpl_impo_mone;
      
      v_impo_reca := v_impo_mone_cuot * p_porc_comi_aqui_pago / 100;
    
      if v_impo_reca <= p_aqui_pago_impo_mini_comi then
        v_tota_reca := v_tota_reca + p_aqui_pago_impo_mini_comi;
        --return :parameter.p_aqui_pago_impo_mini_comi;
      elsif v_impo_reca >= p_aqui_pago_impo_maxi_comi then
        v_tota_reca := v_tota_reca + p_aqui_pago_impo_maxi_comi;
        --return :parameter.p_aqui_pago_impo_maxi_comi;
      else
        v_tota_reca := v_tota_reca + v_impo_reca;
        --return v_impo_reca;
      end if;
    end loop;
    
    return v_tota_reca;
  else
    return 0;
  end if;
  
exception
  when others then
   return 0;
    
end;

procedure pp_llamar_reporte (p_faau_codi IN NUMBER) is
  

  V_NOMBRE       VARCHAR2(50);
  V_PARAMETROS   CLOB;
  V_CONTENEDORES CLOB;

   BEGIN


   for x in  (select TO_CHAR(t.deta_movi_codi) CODIGO
                        
                  from come_fact_auto_deta t
                  where t.deta_faau_codi = p_faau_codi
                  order by t.deta_nume_item desc) LOOP



   --V_NOMBRE:=  'comisionCobranzas'; comisionInstalaciones
   V_CONTENEDORES :='p_movi_codi';
   V_PARAMETROS :=  x.CODIGO;
  
  
  -- apex_application.g_print_success_message := 'IMPRIMIR FACT';

  end loop;

DELETE FROM COME_PARAMETROS_REPORT  WHERE USUARIO =gen_user;

INSERT INTO COME_PARAMETROS_REPORT
  (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
VALUES
  (V_PARAMETROS,gen_user, 'factura', 'pdf', V_CONTENEDORES);
  


  




end pp_llamar_reporte;
end I020341A;
