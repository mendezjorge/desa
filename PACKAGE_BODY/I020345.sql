
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020345" is

  -- Private type declarations

  --  bcab come_soli_serv_anex_deta%rowtype;
    type r_variable is record(
    
    sucu_nume_item        number);
   

  var r_variable;
    type r_var is record( 
    p_conc_codi_anex_rein_vehi number := to_number(general_skn.fl_busca_parametro('p_conc_codi_anex_rein_vehi')),
    p_codi_mone_mmnn number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_empr_codi number:=v('AI_EMPR_CODI')
    );
   parameter r_var;
  
 cursor detalle is
  select seq_id nro_item,
   c001 sose_codi,
   c002 sose_nume,
   c003 sose_tipo_fact,
   c004 sose_tipo_fact_orig,
   c005 anex_codi,
   c006 anex_nume,
   c007 anex_esta,
   d001 anex_fech_emis_orig,
   d002 anex_fech_emis,
   c010 deta_indi_actu,
   c011 anex_dura_cont,
   c012 vehi_codi,
   c013 clpr_codi,
   c014 clpr_codi_alte,
   c015 clpr_desc,
   c016 sucu_nume_item ,
   c017 sucu_desc,
   c018 sose_mone_codi_orig,
   c019 sose_mone_codi,
   c020 mone_desc,
   c021 deta_prec_unit_orig,
   c022 deta_colo_orig,
   c023 deta_anho_orig,
   c024 deta_mode_orig ,
   c025 deta_nume_chas_orig,
   c026 deta_iden_orig,
   c027 deta_nume_pate_orig,
   c028 deta_prec_unit ,
   c029 deta_colo,
   c030 deta_anho ,
   c031 deta_mode ,
   c032 deta_nume_chas ,
   c033 deta_iden ,
   c034 deta_nume_pate ,
   c035 deta_esta  ,
   c036 deta_mave_codi_orig ,
   c037 deta_mave_codi,
   c038 mave_codi_alte,
   c039 vehi_marc,
   c040 deta_tive_codi_orig,
   c041  deta_tive_codi ,
   c042 tive_codi_alte,
   c043 vehi_desc,
   d003 deta_fech_vige_inic_orig ,
   d004 deta_fech_vige_inic ,
   d005  deta_fech_vige_fini_orig,
   c047  deta_fech_vige_fini,


  c008 deta_indi_actu_prec,
  c009 anex_tasa_mone,
  c044 deta_indi_actu_soli,
  c045 deta_indi_actu_divi,
  n001 deta_dicl_codi
  
  from apex_collections a
     where collection_name = 'BDETALLE';
procedure pp_muestra_come_soli_serv_codi(p_sose_codi      in number,
                                         p_sose_nume      out number,
                                         p_clpr_codi      out number,
                                         p_sose_fech_emis out date
                                         ) is

begin

  select sose_nume,
         clpr_codi,
         sose_fech_emis
    into p_sose_nume,
         p_clpr_codi,
         p_sose_fech_emis
    from come_soli_serv s, come_clie_prov
   where sose_clpr_codi = clpr_codi
     and sose_codi = p_sose_codi;
     
exception
  when no_data_found then
    raise_application_error(-20001,'Solicitud de Servicio inexistente.');
  when others then
    raise_application_error(-20001,sqlerrm);
end pp_muestra_come_soli_serv_codi;


PROCEDURE pp_validar_sub_cuenta(p_clpr_codi in number,
                                p_indi_vali_subc out varchar2
                               ) IS
  v_count number := 0;
BEGIN

    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_clpr_codi;
   
  if v_count > 0 then
    p_indi_vali_subc := 'S';
  else
    p_indi_vali_subc := 'N';
  end if;
  
END pp_validar_sub_cuenta;






PROCEDURE pp_mostrar_anexo_codi (p_anex_codi in number,
                                 p_sose_codi in number,
                                 p_anex_nume out number,
                                 p_anex_fech_emis out varchar2)IS
	---v_anex_codi number;
begin
  select  a.anex_nume, a.anex_fech_emis
    into  p_anex_nume, p_anex_fech_emis
    from come_soli_serv_anex a
   where anex_codi = p_anex_codi
     and (anex_sose_codi = p_sose_codi or p_sose_codi is null);
exception
	when no_data_found then
	  null;
end pp_mostrar_anexo_codi;




PROCEDURE pp_mostrar_tipo_vehi(p_tive_codi in number, 
                               p_empresa   in number,
                               p_tive_desc out varchar2) IS
begin
  select tive_desc
    into p_tive_desc
    from come_tipo_vehi
   where  rtrim(ltrim(tive_codi)) = rtrim(ltrim(p_tive_codi))
     and tive_empr_codi = nvl(p_empresa, 1);
  
Exception
   When no_data_found then
     raise_application_error(-20001,'Tipo de Vehiculo Inexistente');     
   when others then
     raise_application_error(-20001,sqlerrm);
     
end pp_mostrar_tipo_vehi;





procedure pp_muestra_come_mone(p_mone_codi in number, 
                               p_mone_desc out varchar2, 
                               p_mone_desc_abre out varchar2, 
                               p_mone_cant_deci out number) is
begin	                 
  select mone_desc  , mone_desc_abre  , mone_cant_deci
  into   p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
  from   come_mone
  where  mone_codi = p_mone_codi;  
Exception
  when no_data_found then
     p_mone_desc := null;
     raise_application_error(-20001,'Moneda Inexistente!');
  when others then
     raise_application_error(-20001,sqlerrm);
end pp_muestra_come_mone;


procedure pp_busca_tasa_mone (p_mone_codi in number,
                              p_coti_fech in date,
                              p_mone_coti out number) is
begin
  if nvl(parameter.p_codi_mone_mmnn, 1) = p_mone_codi then
     p_mone_coti := 1;
  else
    select coti_tasa
      into p_mone_coti
      from come_coti
     where coti_mone      = p_mone_codi
       and coti_fech      = p_coti_fech 
       and coti_tica_codi = 2;
  end if;
  
  if parameter.p_codi_mone_mmnn <> p_mone_codi and nvl(p_mone_coti, 0) in (0, 1) then
    raise_application_error(-20001,'Cotizaci?n no v?lida para la moneda '||p_mone_codi||' para la fecha del documento.');
  end if;

exception
  when no_data_found then
    p_mone_coti := null;
    raise_application_error(-20001,'Cotizacion Inexistente de la moneda '||p_mone_codi||' para la fecha del documento.');
  when others then
    raise_application_error(-20001,sqlerrm);
end pp_busca_tasa_mone;


PROCEDURE pp_mostrar_marc_vehi_alte(p_mave_codi_alte in char, 
                                    p_mave_desc out varchar2, 
                                    p_mave_codi out number) IS
begin
  select mave_desc, mave_codi
    into p_mave_desc, p_mave_codi
    from come_marc_vehi
   where  rtrim(ltrim(mave_codi_alte)) = rtrim(ltrim(p_mave_codi_alte))
     and mave_empr_codi = nvl(parameter.p_empr_codi, 1);
  
Exception
   When no_data_found then
     p_mave_desc := null;
     p_mave_codi := null;
     raise_application_error(-20001,'Marca de Vehiculo Inexistente');    
   when others then
      raise_application_error(-20001,sqlerrm);
      
      
end pp_mostrar_marc_vehi_alte;


procedure pp_validar_identificador(p_iden in varchar2,
                                   p_vehi_codi in number) is

  v_count     number := 0;
  v_sose_nume number;
begin

  select count(*)
    into v_count
    from come_vehi
   where rtrim(ltrim(vehi_iden)) = rtrim(ltrim(p_iden))
     and nvl(vehi_esta_vehi,'A') <> 'I'
     and nvl(vehi_esta, 'I') <> 'D'
     and vehi_codi <> p_vehi_codi;
     
  if v_count <> 0 then
    select s.sose_nume
      into v_sose_nume
      from come_vehi v, come_soli_serv_anex_deta d, come_soli_serv_anex a, come_soli_serv s
     where v.vehi_codi = d.deta_vehi_codi
       and d.deta_anex_codi = a.anex_codi
       and a.anex_sose_codi = s.sose_codi
       and nvl(v.vehi_esta, 'I') <> 'D'
       and nvl(v.vehi_esta_vehi,'A') = 'A'
       and d.deta_vehi_codi <> p_vehi_codi
       and rtrim(ltrim(vehi_iden)) = rtrim(ltrim(p_iden)); 
          
      raise_application_error(-20001,'El Identificador '||rtrim(ltrim(p_iden))||' ya existe para un vehiculo en la Solicitud Nro '||v_sose_nume||', favor verifique.');
  end if;
end pp_validar_identificador;


procedure pp_valida_chasis_duplicado(p_nume_chas in varchar2,
                                     p_vehi_codi in number) is
                                     
  v_count       number := 0;
  v_sose_nume   number;
  
begin

  select count(*)
    into v_count
    from come_vehi v
   where nvl(v.vehi_esta, 'I') <> 'D'
     and nvl(vehi_esta_vehi,'A') = 'A'
     and v.vehi_codi <> p_vehi_codi
     and v.vehi_nume_chas = p_nume_chas;

  if v_count > 0 then
    if p_nume_chas <> 'S/D' then
      select s.sose_nume
        into v_sose_nume
        from come_vehi v, come_soli_serv_anex_deta d, come_soli_serv_anex a, come_soli_serv s
       where v.vehi_codi = d.deta_vehi_codi
         and d.deta_anex_codi = a.anex_codi
         and a.anex_sose_codi = s.sose_codi
         and nvl(v.vehi_esta, 'I') <> 'D'
         and nvl(vehi_esta_vehi,'A') = 'A'
         and d.deta_vehi_codi <> p_vehi_codi
         and v.vehi_nume_chas = p_nume_chas;  
            
      raise_application_error(-20001,'La serie de Chasis Nro '||p_nume_chas||' ya existe para un vehiculo en la Solicitud Nro '||v_sose_nume||', favor verifique.');
    end if;
  end if;

end pp_valida_chasis_duplicado;


procedure pp_valida_patente_duplicado(p_nume_pate in varchar2,
                                      p_vehi_codi in number) is
                                      
  v_count     number := 0;
  v_sose_nume number;
  
begin
  
  select count(*)
    into v_count
    from come_vehi
   where vehi_nume_pate = p_nume_pate
     and nvl(vehi_esta_vehi,'A') = 'A'
     and nvl(vehi_esta, 'I') <> 'D'
     and vehi_codi <> p_vehi_codi;
   
  if v_count > 0 then
    if p_nume_pate <> 'S/D' then
      select s.sose_nume
        into v_sose_nume
        from come_vehi v, come_soli_serv_anex_deta d, come_soli_serv_anex a, come_soli_serv s
       where v.vehi_codi = d.deta_vehi_codi
         and d.deta_anex_codi = a.anex_codi
         and a.anex_sose_codi = s.sose_codi
         and nvl(v.vehi_esta, 'I') <> 'D'
         and nvl(v.vehi_esta_vehi,'A') = 'A'
         and d.deta_vehi_codi <> p_vehi_codi
         and v.vehi_nume_pate = p_nume_pate;  
            
      raise_application_error(-20001,'La serie de Patente Nro '||p_nume_pate||' ya existe para un vehiculo en la Solicitud Nro '||v_sose_nume||', favor verifique.');      
    end if;
  end if;

end pp_valida_patente_duplicado;

procedure pp_ejecutar_consulta(P_VEHI_IDEN in varchar2,
                               P_sose_codi in number,
                               P_anex_codi in number,
                               P_sode_sucu_nume_item in number,
                               P_clpr_codi in number,
                               P_deta_tive_codi in number,
                               P_deta_nume_chas in varchar2,
                               P_deta_nume_pate in varchar2,
                               P_deta_esta in varchar2,
                               P_fech_vige_desd in date,
                               P_fech_vige_hast in date) is

  cursor c_pres is
    select sose_codi,
           sose_nume,
           sose_tipo_fact,
           anex_codi,
           anex_nume,
           anex_fech_emis,
           anex_esta,
           nvl(anex_dura_cont, sose_dura_cont) anex_dura_cont,
           clpr_codi,
           clpr_codi_alte,
           clpr_desc,
           sucu_desc,          
           deta_prec_unit,
           sose_mone_codi,
           mone_desc,
           vehi_clpr_codi,
           vehi_clpr_sucu_nume_item,
           vehi_tive_codi deta_tive_codi,
           tive_codi_alte,
           tive_desc,
           vehi_mave_codi deta_mave_codi,
           mave_codi_alte,
           mave_desc,
           vehi_colo deta_colo,
           vehi_anho deta_anho,
           vehi_mode deta_mode,
           vehi_nume_chas deta_nume_chas,
           vehi_iden deta_iden,
           vehi_iden_ante deta_iden_ante,
           vehi_esta deta_esta,
           vehi_nume_pate deta_nume_pate,
           nvl(vehi_esta_vehi, 'A') vehi_esta_vehi,
           vehi_fech_vige_inic,
           vehi_fech_vige_fini,
           vehi_codi,
           vehi_esta_vehi deta_esta_vehi,
           deta_fech_vige_inic deta_fech_vige_inic,
           deta_fech_vige_fini deta_fech_vige_fini,
           vehi_user_regi,
           vehi_fech_regi,
           vehi_user_modi,
           vehi_fech_modi,
           deta_dicl_codi
      from come_soli_serv,
           come_soli_serv_anex,
           come_soli_serv_anex_deta,
           come_vehi,
           come_tipo_vehi,
           come_marc_vehi,
           come_clie_prov,
           come_clpr_sub_cuen,
           come_mone
     where sose_codi = anex_sose_codi
       and sose_mone_codi = mone_codi
       and anex_codi = deta_anex_codi
       and deta_vehi_codi = vehi_codi
       --and nvl(vehi_esta, 'I') <> 'D' --no vehiculos que esten 'D' desinstalados
       and deta_conc_codi <> parameter.p_conc_codi_anex_rein_vehi --no concepto de pago de reinstalacion(104)
       and vehi_clpr_codi = clpr_codi(+)
       and nvl(vehi_tive_codi,1) = tive_codi(+)
       and nvl(vehi_mave_codi,1) = mave_codi(+)
       and vehi_clpr_codi = sucu_clpr_codi(+)
       and vehi_clpr_sucu_nume_item = sucu_nume_item(+)
       and nvl( anex_indi_reno, 'N') <> 'S'
       and (P_VEHI_IDEN is null or vehi_iden like '%'||P_VEHI_IDEN||'%')
       and (P_sose_codi is null or vehi_codi in
                                       (select deta_vehi_codi
                                          from come_soli_serv_anex_deta, come_soli_serv_anex
                                         where deta_anex_codi = anex_codi
                                           and anex_sose_codi = P_sose_codi))
       and (P_clpr_codi is null or vehi_clpr_codi = P_clpr_codi)
       and (P_sode_sucu_nume_item is null or vehi_clpr_sucu_nume_item = P_sode_sucu_nume_item)
       and (P_anex_codi is null or vehi_codi in
                                       (select deta_vehi_codi
                                          from come_soli_serv_anex_deta, come_soli_serv_anex
                                         where deta_anex_codi = anex_codi
                                           and anex_codi = P_anex_codi))
       and (P_deta_tive_codi is null or vehi_tive_codi = P_deta_tive_codi)
       and (P_deta_nume_pate is null or rtrim(ltrim(upper(vehi_nume_pate))) like rtrim(ltrim('%'||P_deta_nume_pate||'%')))
       and (P_deta_nume_chas is null or rtrim(ltrim(upper(vehi_nume_chas))) like rtrim(ltrim('%'||P_deta_nume_chas||'%')))
       and (P_deta_esta = 'T' or vehi_esta = P_deta_esta)
       and (P_fech_vige_desd is null or vehi_fech_vige_fini >= P_fech_vige_desd)
       and (P_fech_vige_hast is null or vehi_fech_vige_fini <= P_fech_vige_hast)
  order by sose_codi, anex_nume, deta_nume_item;
  
  --v_nume_item number := 0;
  
begin
  --:parameter.p_indi_vali_det := 'N';
  
apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
  
  for k in c_pres loop
 
 apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => k.sose_codi, ---ind_marcado
                                   p_c002            => k.sose_nume,
                                   p_c003            => k.sose_tipo_fact,
                                   p_c004            => k.sose_tipo_fact,
                                   p_c005            => k.anex_codi,
                                   p_c006            => k.anex_nume,
                                   p_c007            => k.anex_esta,
                                   p_c008            => null ,--deta_indi_actu_prec
                                   p_c009            => null,--anex_tasa_mone
                                   p_d001            => k.anex_fech_emis,
                                   p_d002            => k.anex_fech_emis,
                                   p_c010            =>  'N',
                                   p_c011            => k.anex_dura_cont,
                                   p_c012            => k.vehi_codi,
                                   p_c013            => k.clpr_codi,
                                   p_c014            => k.clpr_codi_alte,
                                   p_c015            => k.clpr_desc,
                                   p_c016            => k.sucu_desc,
                                   p_c017            => k.vehi_clpr_sucu_nume_item ,
                                   p_c018            => k.sose_mone_codi,
                                   p_c019            => k.sose_mone_codi ,
                                   p_c020            => k.mone_desc,
                                   p_c021            => nvl(k.deta_prec_unit, 0),
                                   p_c022            => k.deta_colo,
                                   p_c023            => k.deta_anho,
                                   p_c024            => k.deta_mode,
                                   p_c025            => k.deta_nume_chas,
                                   p_c026            => k.deta_iden,
                                   p_c027            => k.deta_nume_pate,
                                   p_c028            => nvl(k.deta_prec_unit, 0),
                                   p_c029            => k.deta_colo,
                                   p_c030            => k.deta_anho,
                                   p_c031            => k.deta_mode,
                                   p_c032            => k.deta_nume_chas,
                                   p_c033            => k.deta_iden,
                                   p_c034            => k.deta_nume_pate,
                                   p_c035            => k.deta_esta,
                                   p_c036            => k.deta_mave_codi,
                                   p_c037            => k.deta_mave_codi,
                                   p_c038            => k.mave_codi_alte,
                                   p_c039            => k.mave_desc,
                                   p_c040            => k.deta_tive_codi,
                                   p_c041            => k.deta_tive_codi,
                                   p_c042            => k.tive_codi_alte,
                                   p_c043            => k.tive_desc,
                                   p_c044            => null,--deta_indi_actu_soli
                                   p_c045            => null,--deta_indi_actu_divi
                                   p_c046            => k.vehi_user_modi,
                                   p_d003            => k.deta_fech_vige_inic,
                                   p_d004            => k.deta_fech_vige_inic,
                                   p_d005            => k.deta_fech_vige_fini,
                                   p_c047            => k.deta_fech_vige_fini,
                                   p_c048            => k.vehi_user_regi,
                                   p_c049            => k.vehi_fech_regi,
                                   p_c050            => k.vehi_fech_modi,
                                   p_n001            => k.deta_dicl_codi,
                                   p_n002            => k.deta_dicl_codi
                                      
                                   );   
  
 
  end loop;

  
  --pp_formatear_importes;
  
  --:parameter.p_indi_vali_det := 'S';
end;




procedure pp_update_member
  is
  begin
    
  
  ----validacion general....
    
    	if v('P119_DETA_ANHO') is null then
		  raise_application_error(-20001,'Debe asignar el A?o del vehiculo.');
	   end if;
    
   if v('P119_ANEX_FECH_EMIS') is null then
    raise_application_error(-20001,'Debe ingresar Fecha emision del Anexo.');
   end if;
                    
     
       if nvl(to_number(v('P119_DETA_PREC_UNIT')), 0) <= 0 then   
         raise_application_error(-20001,'El importe debe ser mayor a 0.');
       end if;
       
     if v('P119_DETA_FECH_VIGE_INIC') is null then
        raise_application_error(-20001,'Debe ingresar fecha Inicio de vigencia del vehiculo.');
     end if;

       if v('P119_DETA_FECH_VIGE_FINI') is null then
      raise_application_error(-20001,'Debe ingresar fecha de Fin de vigencia del vehiculo');
    end if;
    if v('P119_MAVE_CODI_ALTE') is null then
    raise_application_error(-20001,'Debe asignar la Marca del vehiculo.');
  end if;
-------------

                 
     apex_collection.UPDATE_MEMBER(p_collection_name => 'BDETALLE',
                                   p_seq             => v('P119_NRO_ITEM'),
                                   p_c001            => v('P119_SOSE_CODI'),
                                   p_c002            => v('P119_SOSE_NUME'),
                                   p_c003            => v('P119_SOSE_TIPO_FACT'),
                                   p_c004            => v('P119_SOSE_TIPO_FACT_ORIG'),
                                   p_c005            => v('P119_ANEX_CODI'),
                                   p_c006            => v('P119_ANEX_NUME'),
                                   p_c007            => v('P119_ANEX_ESTA'),
                                   p_c008            => v('P119_DETA_INDI_ACTU_PREC'),
                                   p_c009            => v('P119_ANEX_TASA_MONE'),
                                   p_d001            => v('P119_ANEX_FECH_EMIS_ORIG'),
                                   p_d002            => v('P119_ANEX_FECH_EMIS'),
                                   p_c010            => v('P119_DETA_INDI_ACTU'),
                                   p_c011            => v('P119_ANEX_DURA_CONT'),
                                   p_c012            => v('P119_VEHI_CODI'),
                                   p_c013            => v('P119_CLPR_CODI'),
                                   p_c014            => v('P119_CLPR_CODI_ALTE'),
                                   p_c015            => v('P119_CLPR_DESC'),
                                   p_c016            => v('P119_SUCU_NUME_ITEM') ,
                                   p_c017            => v('P119_SUCU_DESC') ,
                                   p_c018            => v('P119_SOSE_MONE_CODI_ORIG'),
                                   p_c019            => v('P119_SOSE_MONE_CODI') ,
                                   p_c020            => v('P119_MONE_DESC'),
                                   p_c021            => v('P119_DETA_PREC_UNIT_ORIG'),
                                   p_c022            => v('P119_DETA_COLO_ORIG'),
                                   p_c023            => v('P119_DETA_ANHO_ORIG'),
                                   p_c024            => v('P119_DETA_MODE_ORIG'),
                                   p_c025            => v('P119_DETA_NUME_CHAS_ORIG'),
                                   p_c026            => v('P119_DETA_IDEN_ORIG'),
                                   p_c027            => v('P119_DETA_NUME_PATE_ORIG'),
                                   p_c028            => v('P119_DETA_PREC_UNIT'),
                                   p_c029            => v('P119_DETA_COLO'),
                                   p_c030            => v('P119_DETA_ANHO'),
                                   p_c031            => v('P119_DETA_MODE'),
                                   p_c032            => v('P119_DETA_NUME_CHAS'),
                                   p_c033            => v('P119_DETA_IDEN') ,
                                   p_c034            => v('P119_DETA_NUME_PATE') ,
                                   p_c035            => v('P119_DETA_ESTA') ,
                                   p_c036            => v('P119_DETA_MAVE_CODI_ORIG') ,
                                   p_c037            => v('P119_DETA_MAVE_CODI'),
                                   p_c038            => v('P119_MAVE_CODI_ALTE'),
                                   p_c039            => v('P119_VEHI_MARC'),
                                   p_c040            => v('P119_DETA_TIVE_CODI_ORIG'),
                                   p_c041            => v('P119_DETA_TIVE_CODI'),
                                   p_c042            => v('P119_TIVE_CODI_ALTE'),
                                   p_c043            => v('P119_VEHI_DESC'),
                                   p_c044            => v('P119_DETA_INDI_ACTU_SOLI'),--deta_indi_actu_soli
                                   p_c045            => v('P119_DETA_INDI_ACTU_DIVI'),--deta_indi_actu_divi
                                   p_c046            => gen_user,
                                   p_d003            => v('P119_DETA_FECH_VIGE_INIC_ORIG'),
                                   p_d004            => v('P119_DETA_FECH_VIGE_INIC'),
                                   p_d005            => v('P119_DETA_FECH_VIGE_FINI_ORIG'),
                                   p_c047            => v('P119_DETA_FECH_VIGE_FINI'),
                                  -- p_c048            => vehi_user_regi,
                                  -- p_c049            => vehi_fech_regi,
                                   p_c050            => SYSDATE/*,
                                   p_n001            => deta_dicl_codi,
                                   p_n002            => deta_dicl_codi*/
                                      
                                   );
    end pp_update_member;


procedure pp_actualizar_datos is

  cursor c_anex_deta (p_anex_codi in number) is
    select deta_prec_unit,
           deta_indi_anex_modu,
           anex_dura_cont
      from come_soli_serv_anex_deta, come_soli_serv_anex
     where deta_anex_codi = anex_codi
       and deta_anex_codi = p_anex_codi;

  v_anex_impo_mone        number;
  v_anex_prec_unit        number;
  v_anex_impo_mone_unic   number;
  v_idx                   number := 0;

  type rt_anex is record (
  anex_codi    number(20)
  );
  type tt_anex is table of rt_anex index by binary_integer;
  
  ta_anex   tt_anex;
  
begin

  
for bdet in detalle loop
    if bdet.deta_indi_actu = 'S' then
      update come_vehi set vehi_fech_vige_inic = bdet.deta_fech_vige_inic,
                           vehi_fech_vige_fini = bdet.deta_fech_vige_fini,
                           vehi_colo           = bdet.deta_colo,
                           vehi_anho           = bdet.deta_anho,
                           vehi_nume_chas      = bdet.deta_nume_chas,
                           vehi_nume_pate      = bdet.deta_nume_pate,
                           vehi_tive_codi      = bdet.deta_tive_codi,
                           vehi_mave_codi      = bdet.deta_mave_codi,
                           vehi_mode           = bdet.deta_mode,
                           vehi_iden           = bdet.deta_iden,
                           vehi_user_modi      = gen_user,
                           vehi_fech_modi      = sysdate
                     where vehi_codi = bdet.vehi_codi; 
      
      update come_soli_serv_anex_deta set deta_fech_vige_inic = bdet.deta_fech_vige_inic,
                                          deta_fech_vige_fini = bdet.deta_fech_vige_fini
                                    where deta_anex_codi = bdet.anex_codi;
                                    
      update come_soli_serv_anex set anex_fech_inic_vige = bdet.deta_fech_vige_inic,
                                     anex_fech_vige      = bdet.deta_fech_vige_fini,
                                     anex_fech_emis      = bdet.anex_fech_emis
                               where anex_codi     = bdet.anex_codi;
    end if;
    
    if bdet.deta_indi_actu_prec = 'S' then
      update come_soli_serv set sose_mone_codi = bdet.sose_mone_codi
                          where sose_codi = bdet.sose_codi;
      
      if bdet.sucu_nume_item is not null then                                      
        update come_soli_serv_anex_deta set deta_prec_unit = bdet.deta_prec_unit,
                                            deta_impo_mone = bdet.deta_prec_unit
                                      where deta_anex_codi = bdet.anex_codi
                                        and deta_vehi_codi = bdet.vehi_codi;
      else
        update come_soli_serv_anex_deta set deta_prec_unit = bdet.deta_prec_unit,
                                            deta_impo_mone = bdet.deta_prec_unit * nvl(bdet.anex_dura_cont, 1)
                                      where deta_anex_codi = bdet.anex_codi
                                        and deta_vehi_codi = bdet.vehi_codi;       
      end if; 

      update come_soli_serv_anex set anex_mone_codi = bdet.sose_mone_codi,
                                     anex_tasa_mone = bdet.anex_tasa_mone
                               where anex_codi = bdet.anex_codi;     
      
      v_idx := v_idx + 1;
      ta_anex(v_idx).anex_codi := bdet.anex_codi;
    end if;
    
    if bdet.deta_indi_actu_soli = 'S' then
      update come_soli_serv set sose_tipo_fact = bdet.sose_tipo_fact
                          where sose_codi = bdet.sose_codi;
    end if;
    
    if bdet.deta_indi_actu_divi = 'S' then
      update come_soli_serv_anex_deta set deta_dicl_codi = bdet.deta_dicl_codi
                                    where deta_anex_codi = bdet.anex_codi;                               
    end if;
    
  end loop;
  commit;
  
  
  
  for y in 1..ta_anex.count loop
    v_anex_impo_mone      := 0;
    v_anex_prec_unit      := 0;
    v_anex_impo_mone_unic := 0;
    
    for x in c_anex_deta(ta_anex(y).anex_codi) loop
      if var.sucu_nume_item is not null then
        v_anex_impo_mone      := v_anex_impo_mone + nvl(x.deta_prec_unit, 0);
      else
        v_anex_impo_mone      := v_anex_impo_mone + nvl(x.deta_prec_unit * nvl(x.anex_dura_cont, 12), 0);
      end if;
      
      if nvl(x.deta_indi_anex_modu, 'N') = 'N' then
        v_anex_prec_unit := v_anex_prec_unit + nvl(x.deta_prec_unit, 0);
      else
        v_anex_impo_mone_unic := v_anex_impo_mone_unic + nvl(x.deta_prec_unit, 0);
      end if;
    end loop;
    
    update come_soli_serv_anex set anex_impo_mone = v_anex_impo_mone,
                                   anex_impo_mmnn = round(v_anex_impo_mone * nvl(anex_tasa_mone, 1), 0),
                                   anex_prec_unit = v_anex_prec_unit,
                                   anex_impo_mone_unic = v_anex_impo_mone_unic
     where anex_codi = ta_anex(y).anex_codi;
     
  end loop;
  
  commit;
end;
 

end I020345;
