
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020274" is


  type r_parameter is record(
        p_empr_codi                number := 1,

        p_indi_most_mens_aler      varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_aler'))),
        p_form_impr_nota_devo      varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_nota_devo'))),

        p_codi_clie_espo           number:= to_number(general_skn.fl_busca_parametro ('p_codi_clie_espo')),                                       
        p_codi_mone_dola           number:= to_number(general_skn.fl_busca_parametro ('p_codi_mone_dola')),                                                                                                                      
        p_codi_tipo_empl_vend      number:= to_number(general_skn.fl_busca_parametro ('p_codi_tipo_empl_vend')),                                                                                

        p_codi_mone_mmnn           number:= to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmnn')),                 
        p_cant_deci_porc           number:= to_number(general_skn.fl_busca_parametro ('p_cant_deci_porc')),  
        p_cant_deci_mmnn           number:= to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn')),  
        p_cant_deci_mmee           number:= to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmee')),  
        p_cant_deci_cant           number:= to_number(general_skn.fl_busca_parametro ('p_cant_deci_cant')),  
        p_cant_deci_prec_unit_vent number:= to_number(general_skn.fl_busca_parametro ('p_cant_deci_prec_unit_vent')),

        p_codi_impu_ortr           varchar2(100):= general_skn.fl_busca_parametro('p_codi_impu_ortr'),

        p_indi_validar_deta        varchar2(100):= 'S',
        p_codi_base                varchar2(100):= pack_repl.fa_devu_codi_base,
        p_form_impr_fact           varchar2(100):=ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_fact'))),
        p_fech_inic                varchar2(100),
        p_fech_fini                varchar2(100));

  parameter r_parameter;
  
   cursor g_cur_col_det is
    select seq_id,
           c001 indi_prod_ortr   ,
           c002 deta_nume_item   ,
           c003 prod_desc        ,
           c004 deta_prod_codi   ,
           c005 prod_codi_alfa   ,
           c006 deta_medi_codi   ,
           c007 deta_cant_medi   ,
           c008 deta_prec_unit   ,
           c009 S_total_item     ,
           c010 coba_codi_barr   
      from apex_collections a
     where collection_name = 'DETALLE';
     
     
     
   TYPE T_BCAB IS RECORD(
    NODE_NUME           VARCHAR2(100),
    NODE_DEPO_CODI_ORIG VARCHAR2(100),
    NODE_SUCU_CODI_ORIG VARCHAR2(100),
    NODE_FECH_EMIS      VARCHAR2(100),
    CLPR_CODI_ALTE      VARCHAR2(100),
    NODE_ESTA_DESC      VARCHAR2(100),
    NODE_CLPR_TELE      VARCHAR2(100),
    NODE_CLPR_RUC       VARCHAR2(100),
    NODE_CLPR_DIRE      VARCHAR2(100),
    DEPO_CODI_ALTE_ORIG VARCHAR2(100),
    MEDI_DESC_ABRE      VARCHAR2(100),
    NODE_SUCU_DESC_ORIG VARCHAR2(100),
    NODE_FACT           VARCHAR2(100),
    NODE_FACT_FECH_EMIS VARCHAR2(100),
    NODE_EMPL_CODI      VARCHAR2(100),
    NODE_MONE_CODI      VARCHAR2(100),
    NODE_TASA_MONE      VARCHAR2(100),
    NODE_OBSE           VARCHAR2(100),
    NODE_ESTA           VARCHAR2(100),
    NODE_FECH_GRAB      DATE,
    NODE_USER           VARCHAR2(100),
    NODE_CODI           NUMBER,
    NODE_CLPR_CODI      NUMBER,
    NODE_EMPR_CODI      NUMBER,
    NODE_MOVI_CODI      NUMBER
    );

  BCAB T_BCAB;
     
     
  procedure pp_iniciar is
    begin
      	pa_devu_fech_habi(parameter.p_fech_inic,parameter.p_fech_fini );
      
    end pp_iniciar ;
  
  

  procedure pp_buscar_nro is
    begin
      
    null;
    end pp_buscar_nro;
    

procedure pp_carga_secu(p_node_nume out number) is
begin

  select nvl(max(node_nume), 0) + 1
    into p_node_nume
    from come_nota_devu
   where nvl(node_empr_codi, 1) = parameter.p_empr_codi;

exception
  when no_data_found then
    p_node_nume     := 1;
  when others then
    raise_application_error(-20001,
                            'Error contacte al administrador de sistemas');
  
end pp_carga_secu;


procedure pp_valida_nota_devu (p_node_nume in number,
                               p_node_codi              out varchar2,
                               p_node_fech_emis         out varchar2,
                               p_node_esta              out varchar2,
                               p_node_clpr_codi         out varchar2,
                               p_node_sucu_codi_orig    out varchar2,
                               p_node_depo_codi_orig    out varchar2,
                               p_node_obse              out varchar2,
                               p_node_fech_grab         out varchar2,
                               p_node_user              out varchar2,
                               p_node_empl_codi         out varchar2,
                               p_node_mone_codi         out varchar2,
                               p_node_movi_codi         out varchar2,
                               p_node_clpr_desc         out varchar2,
                               p_node_esta_desc         out varchar2,
                               p_node_clpr_ruc          out varchar2,
                               p_node_clpr_dire         out varchar2,
                               p_node_clpr_tele         out varchar2,
                               p_node_tica_codi         out varchar2,
                               p_node_fact              out varchar2,
                               p_node_depo_desc_orig    out varchar2,
                               p_node_tasa_mone         out varchar2,
                               p_node_fact_fech_emis    out varchar2,
                               p_depo_codi_alte_orig    out varchar2,
                               p_node_mone_cant_deci    out varchar2,
                               p_sucu_codi_alte_orig    out varchar2,
                               p_node_sucu_desc_orig    out varchar2,
                               p_clpr_codi_alte         out varchar2)is
  v_cont number;
    
begin 
  select count(*)
    into v_cont
    from come_nota_devu
   where node_nume = p_node_nume
     and nvl(node_empr_codi,1) = parameter.p_empr_codi;

  if v_cont =  1 then
    --pp_ejecutar_consulta_nume;
     I020274.PP_EJECUTAR_CONSULTA_NUME(P_NODE_NUME          ,
                                        P_NODE_CODI          ,
                                        P_NODE_FECH_EMIS     ,
                                        P_NODE_ESTA          ,
                                        P_NODE_CLPR_CODI     ,
                                        P_NODE_SUCU_CODI_ORIG,
                                        P_NODE_DEPO_CODI_ORIG,
                                        P_NODE_OBSE          ,
                                        P_NODE_FECH_GRAB     ,
                                        P_NODE_USER          ,
                                        P_NODE_EMPL_CODI     ,
                                        P_NODE_MONE_CODI     ,
                                        P_NODE_MOVI_CODI     ,
                                        P_NODE_CLPR_DESC     ,
                                        P_NODE_ESTA_DESC     ,
                                        P_NODE_CLPR_RUC      ,
                                        P_NODE_CLPR_DIRE     ,
                                        P_NODE_CLPR_TELE     ,
                                        P_NODE_TICA_CODI     ,
                                        P_NODE_FACT          ,
                                        P_NODE_DEPO_DESC_ORIG,
                                        P_NODE_TASA_MONE     ,
                                        P_NODE_FACT_FECH_EMIS,
                                        P_DEPO_CODI_ALTE_ORIG,
                                        P_NODE_MONE_CANT_DECI,
                                        P_SUCU_CODI_ALTE_ORIG,
                                        P_NODE_SUCU_DESC_ORIG,
                                        P_CLPR_CODI_ALTE);
    pp_ejecutar_consulta_deta(p_node_nume);
/*   
    if :bcab.node_fact is not null then
      set_item_property('bdet.prod_codi_alfa', navigable, property_false);
      set_item_property('bdet.prod_codi_alfa', enabled, property_false);
      set_item_property('bdet.medi_desc_abre', navigable, property_false);
      set_item_property('bdet.medi_desc_abre', enabled, property_false);
      set_item_property('bdet.deta_prec_unit', navigable, property_false);
      set_item_property('bdet.deta_prec_unit', enabled, property_false);  
      set_item_property('bdet.coba_codi_barr', navigable, property_false);
      set_item_property('bdet.coba_codi_barr', enabled, property_false);
    end if;
    */
 
  elsif v_cont > 1 then  
    raise_application_error(-20001, 'Nro de devoluci?n Duplicada!!');
  end if;    
 
exception
  when no_data_found then
    raise_application_error(-20001, 'Devoluci?n Inexistente');
end;
  


procedure pp_ejecutar_consulta_nume (p_node_nume              in number,
                                     p_node_codi              out varchar2,
                                     p_node_fech_emis         out varchar2,
                                     p_node_esta              out varchar2,
                                     p_node_clpr_codi         out varchar2,
                                     p_node_sucu_codi_orig    out varchar2,
                                     p_node_depo_codi_orig    out varchar2,
                                     p_node_obse              out varchar2,
                                     p_node_fech_grab         out varchar2,
                                     p_node_user              out varchar2,
                                     p_node_empl_codi         out varchar2,
                                     p_node_mone_codi         out varchar2,
                                     p_node_movi_codi         out varchar2,
                                     p_node_clpr_desc         out varchar2,
                                     p_node_esta_desc         out varchar2,
                                     p_node_clpr_ruc          out varchar2,
                                     p_node_clpr_dire         out varchar2,
                                     p_node_clpr_tele         out varchar2,
                                     p_node_tica_codi         out varchar2,
                                     p_node_fact              out varchar2,
                                     p_node_depo_desc_orig    out varchar2,
                                     p_node_tasa_mone         out varchar2,
                                     p_node_fact_fech_emis    out varchar2,
                                     p_depo_codi_alte_orig    out varchar2,
                                     p_node_mone_cant_deci    out varchar2,
                                     p_sucu_codi_alte_orig    out varchar2,
                                     p_node_sucu_desc_orig    out varchar2,
                                     p_clpr_codi_alte         out varchar2) is
  cursor c_nota_devu is
    select node_codi,
           node_nume,
           node_fech_emis,
           node_esta,
           node_clpr_codi,
           node_empr_codi,
           node_sucu_codi,
           node_depo_codi,
           node_obse,
           node_fech_grab,
           node_user,
           node_fech_auto,
           node_user_auto,
           node_movi_codi,
           node_empl_codi,
           node_mone_codi,
           node_fact_codi,
           node_base
      from come_nota_devu
     where node_nume = p_node_nume;

v_clpr_codi_alte varchar2(200);
v_node_mone_desc varchar2(200);
v_node_empl_desc varchar2(200);
v_node_mone_desc_abre varchar2(200);
v_empl_codi_alte varchar2(200);
begin

  for x in c_nota_devu loop
    p_node_codi              :=       x.node_codi;
   -- :bcab.node_nume              :=       x.node_nume;
    p_node_fech_emis         :=       x.node_fech_emis;
    p_node_esta              :=       x.node_esta;
    p_node_clpr_codi         :=       x.node_clpr_codi;
    p_node_sucu_codi_orig    :=       x.node_sucu_codi;
    p_node_depo_codi_orig    :=       x.node_depo_codi;
    p_node_obse              :=       x.node_obse;
    p_node_fech_grab         :=       x.node_fech_grab;
    p_node_user              :=       x.node_user;
    p_node_empl_codi         :=       x.node_empl_codi;
    p_node_mone_codi         :=       x.node_mone_codi;
    p_node_movi_codi         :=       x.node_fact_codi;
    
    if p_node_clpr_codi is not null then
        pp_muestra_clie(p_node_clpr_codi,
                        p_node_clpr_desc,
                        p_clpr_codi_alte);
    else
      p_clpr_codi_alte := null;
    end if;
    if p_clpr_codi_alte is not null then
        pp_mostrar_clpr ('C',
                   p_clpr_codi_alte,
                   p_node_clpr_desc,
                   p_node_clpr_codi,
                   p_node_clpr_ruc,
                   p_node_clpr_dire,
                   p_node_clpr_tele,
                   p_node_empl_codi);
    end if;
   /* if p_clpr_codi_alte = parameter.p_codi_clie_espo then
      pp_habi_desh_clpr('H');
    else
      pp_habi_desh_clpr('D');
    end if;*/
    
    if p_node_depo_codi_orig is not null then
    pp_muestra_come_depo_alte (parameter.p_empr_codi,
                               p_node_depo_codi_orig,
                               p_node_depo_desc_orig,
                               p_depo_codi_alte_orig,
                               p_sucu_codi_alte_orig,
                               p_node_sucu_desc_orig,
                               p_node_sucu_codi_orig);
    end if;
    if p_node_empl_codi is not null then
    pp_muestra_come_empl(parameter.p_empr_codi,
                         parameter.p_codi_tipo_empl_vend,
                         p_node_empl_codi,
                         v_node_empl_desc,
                         v_empl_codi_alte);
    end if;
   
    if p_node_mone_codi is not null then
      general_skn.pl_muestra_come_mone (p_node_mone_codi, 
                            v_node_mone_desc, 
                            v_node_mone_desc_abre, 
                            p_node_mone_cant_deci);
      pp_busca_tasa_mone(p_node_mone_codi, 
                         p_node_fech_emis, 
                         p_node_tica_codi, 
                         p_node_tasa_mone);
    end if;
    if p_node_movi_codi is not null then
      pp_muestra_fact (parameter.p_empr_codi,
                       p_node_movi_codi,
                       p_node_fact,
                       p_node_fact_fech_emis,
                       p_node_clpr_codi);
    end if; 
    if p_node_esta = 'P' then
      p_node_esta_desc := 'Pendiente';
    elsif p_node_esta = 'A' then
      p_node_esta_desc := 'Autorizado';
    elsif p_node_esta = 'R' then
      p_node_esta_desc := 'Rechazado';
    elsif p_node_esta = 'F' then
     p_node_esta_desc := 'Facturado';
    end if;
    
  end loop;

  /*if nvl(p_node_esta,'P') <> 'P' then
    set_item_property('bpie.aceptar', enabled, property_false);
  else
    set_item_property('bpie.aceptar', enabled, property_true);
    set_item_property('bpie.aceptar', navigable, property_true);
    set_item_property('bpie.borrar', enabled, property_true);
    set_item_property('bpie.borrar', navigable, property_true);
  end if;
  */
exception
  when no_data_found then
    raise_application_error(-20001,'Devolucion Inexistente');
  when too_many_rows then
   raise_application_error(-20001,'Existen dos contratos con el mismo numero, avise a su administrador');            
end;


procedure pp_muestra_clie(p_clpr_codi      in number,
                          p_clpr_desc      out varchar2,
                          p_clpr_codi_alte out varchar2) is
begin
  
  select clpr_desc, clpr_codi_alte
    into p_clpr_desc, p_clpr_codi_alte
    from come_clie_prov
   where clpr_indi_clie_prov = 'C'
     and clpr_codi = p_clpr_codi;

Exception
  when no_data_found then
    p_clpr_desc      := null;
    p_clpr_codi_alte := null;
    raise_application_error(-20001, 'Cliente Inexistente!');
  when others then
    raise_application_error(-20001, 'Avise al administrador de sistema');
end pp_muestra_clie;


Procedure  pp_mostrar_clpr (p_ind_clpr                 in varchar2, 
                            p_clpr_codi_alte           in number, 
                            p_clpr_desc                out varchar2, 
                            p_clpr_codi                out varchar2, 
                            p_clpr_ruc                 out varchar2, 
                            p_clpr_dire                out varchar2, 
                            p_clpr_tele                out varchar2,
                            p_clpr_empl_codi					 out number) is
v_clpr_esta varchar2(1);  

begin
   select clpr_esta  , clpr_desc  , clpr_codi  , clpr_ruc ,
          clpr_dire  , clpr_tele  , clpr_empl_codi
     into v_clpr_esta, p_clpr_desc, p_clpr_codi,  p_clpr_ruc ,
          p_clpr_dire, p_clpr_tele, p_clpr_empl_codi
     from come_clie_prov
    where clpr_codi_alte = p_clpr_codi_alte
      and clpr_indi_clie_prov = p_ind_clpr;

   if v_clpr_esta = 'I' then
   	raise_application_error(-20001,'El cliente se encuentra Inactivo');
   end if;  
	
exception
  when no_data_found then
    p_clpr_desc := null;
    if p_ind_clpr = 'P' then
      raise_application_error(-20001,'Proveedor inexistente!');
    else
     raise_application_error(-20001,'Cliente inexistente!');
    end if;
  
  when others then
    raise_application_error(-20001,'Error en Clientes, Avise al administrador de sistemas');
end pp_mostrar_clpr;



procedure pp_muestra_come_depo_alte(p_depo_empr_codi in number,
                                    p_depo_codi_alte in varchar2,
                                    p_depo_desc      out varchar2,
                                    p_depo_codi      out number,
                                    p_sucu_codi_alte out varchar2,
                                    p_sucu_desc      out varchar2,
                                    p_sucu_codi      out number) is
begin
  select d.depo_desc,
         d.depo_codi,
         s.sucu_codi_alte,
         sucu_codi_alte||'- '||s.sucu_desc,
         s.sucu_codi
    into p_depo_desc,
         p_depo_codi,
         p_sucu_codi_alte,
         p_sucu_desc,
         p_sucu_codi
    from come_depo d, come_sucu s
   where d.depo_sucu_codi = s.sucu_codi(+)
     and d.depo_empr_codi = p_depo_empr_codi
     and d.depo_indi_fact = 'S'
     and ltrim(rtrim(lower(d.depo_codi_alte))) =
         ltrim(rtrim(lower(p_depo_codi_alte)));

exception
  when no_data_found then
    p_depo_desc      := null;
    p_depo_codi      := null;
    p_sucu_codi_alte := null;
    p_sucu_desc      := null;
    p_sucu_codi      := null;
    raise_application_error(-20001,'Deposito inexistente');
  
  when others then
    raise_application_error(-20001,'Error en Deposito, Avise al administrador de sistema');
end pp_muestra_come_depo_alte;


procedure pp_muestra_come_empl(p_empl_empr_codi in number,
                               p_emti_tiem_codi in number,
                               p_empl_codi      in number,
                               p_empl_desc      out varchar2,
                               p_empl_codi_alte out varchar2) is
begin
  select e.empl_desc, e.empl_codi_alte
    into p_empl_desc, p_empl_codi_alte
    from come_empl e, come_empl_tiem t
   where e.empl_codi = t.emti_empl_codi
     and t.emti_tiem_codi = p_emti_tiem_codi
     and e.empl_empr_codi = p_empl_empr_codi
     and e.empl_codi = p_empl_codi;

exception
  when no_data_found then
    p_empl_desc := null;
    p_empl_codi_alte := null;
   raise_application_error(-20001,'Empleado inexistente o no es del tipo requerido');

  when others then
    raise_application_error(-20001,'Error en Empleados, Avise al administrador de sistema');
end pp_muestra_come_empl;


procedure pp_busca_tasa_mone (p_mone_codi in number,
                              p_coti_fech in date,
                              p_tica_codi in number,
                              p_mone_coti out number) is
begin
  if parameter.p_codi_mone_mmnn = p_mone_codi then
     p_mone_coti := 1;
  else
    select coti_tasa
      into p_mone_coti
      from come_coti
     where coti_mone      = p_mone_codi
       and coti_fech      = p_coti_fech
       and coti_tica_codi = nvl(p_tica_codi,1);
  end if;

exception
  when no_data_found then
    p_mone_coti := null;
     raise_application_error(-20001,'Cotizacion Inexistente para la fecha del documento.');
  when others then
     raise_application_error(-20001,'Error en Cotizacion, Avise al administrador de sistema');
end pp_busca_tasa_mone;

 procedure pp_muestra_fact (p_empr_codi      in number,
                            p_movi_codi      in number,
                            p_fact_nume      out number,
                            p_fech_emis      out date,
                            p_node_clpr_codi in number) is

begin
 select  m.movi_nume,
         m.movi_fech_emis
    into p_fact_nume,p_fech_emis
    from come_movi m, come_clie_prov cp, come_tipo_movi tm, come_mone mo
   where nvl(m.movi_empr_codi,1) = p_empr_codi
     and m.movi_timo_codi in (1, 2, 3, 4)
     and m.movi_clpr_codi = cp.clpr_codi
     and m.movi_timo_codi = tm.timo_codi
     and m.movi_mone_codi = mo.mone_codi
     and m.movi_clpr_codi = p_node_clpr_codi
     and m.movi_codi      = p_movi_codi;

exception
  when no_data_found then
   raise_application_error(-20001,'Factura inexistente.');
end pp_muestra_fact;        



procedure pp_ejecutar_consulta_deta(p_node_nume in number) is

  cursor c_node_deta (p_node_nume in number) is
select nd.node_nume_item,
       nd.node_indi_ortr,
       nvl(nd.node_prod_codi, nvl(nd.node_ortr, nd.node_conc_codi)) node_prod_codi,
       nvl(p.prod_codi_alfa, nvl(ot.ortr_nume, c.conc_codi_alte)) prod_codi_alfa,
       nvl(p.prod_desc, nvl(ot.ortr_desc, c.conc_desc)) prod_desc,
       nd.node_cant,
       nd.node_medi_codi,
       nd.node_prec_unit,
       nd.node_impo_mone,
       nd.node_prod_codi_barr
  from come_nota_devu_deta nd,
       come_nota_devu      n,
       come_prod           p,
       come_orde_trab      ot,
       come_conc           c
 where n.node_nume = p_node_nume
   and nd.node_nota_codi = n.node_codi
   and p.prod_codi(+) = nd.node_prod_codi
   and ot.ortr_codi(+) = nd.node_ortr
   and c.conc_codi(+) = nd.node_conc_codi
order by nd.node_nume_item;
v_medi_desc_abre varchar2(200);

begin
 apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
  
  for x in c_node_deta (p_node_nume) loop
    
    if x.node_medi_codi is not null then
      pp_mostrar_unid_medi(x.node_medi_codi,v_medi_desc_abre);
    end if;
     
    apex_collection.add_member(p_collection_name => 'DETALLE',
                                           p_c001 => x.node_indi_ortr,
                                           p_c002 => x.node_nume_item,
                                           p_c003 => x.prod_desc,
                                           p_c004 => x.node_prod_codi, 
                                           p_c005 => x.prod_codi_alfa,
                                           p_c006 => x.node_medi_codi,
                                           p_c007 => x.node_cant,
                                           p_c008 => x.node_prec_unit,
                                           p_c009 => x.node_impo_mone,
                                           p_c010 => x.node_prod_codi_barr,
                                           p_c011 => v_medi_desc_abre);
  
  
  
  end loop;

  
end pp_ejecutar_consulta_deta;
      

 procedure  pp_mostrar_unid_medi (p_codi in number, p_desc out varchar2) is
begin              
  select ltrim(rtrim(medi_desc_abre)) 
  into p_desc
  from come_unid_medi
  where medi_codi= p_codi;
  
                           
Exception
	 When no_data_found then
	    p_desc := 'No tiene U.M. asignado';

   when others then
       raise_application_error(-20001,'Error.');
end pp_mostrar_unid_medi;     



procedure  pp_valida_fech (p_fech in date) is
begin   
	
	                           
  if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then           
  	 raise_application_error(-20001,'La fecha del movimiento debe estar comprendida entre..'||to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||' y '||to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
  end if;	         

end pp_valida_fech;    



procedure pp_validar_factura (p_empr_codi       in number,
                              p_movi_codi       in number,
                              p_node_clpr_codi  in number,
                              p_movi_empl_codi  out number,
                            --  p_movi_codi       out number,
                              p_node_fact       out number,
                              p_fech_emis       out date,
                              p_mone_codi       out varchar2) is

begin
 select  m.movi_empl_codi,
       --  m.movi_codi,
         m.movi_nume,
         m.movi_fech_emis,
         mo.mone_codi_alte
    into p_movi_empl_codi, p_node_fact, p_fech_emis, p_mone_codi
    from come_movi m, come_clie_prov cp, come_tipo_movi tm, come_mone mo
   where nvl(m.movi_empr_codi,1) = p_empr_codi
     and m.movi_timo_codi in (1, 2, 3, 4)
     and m.movi_clpr_codi = cp.clpr_codi
     and m.movi_timo_codi = tm.timo_codi
     and m.movi_mone_codi = mo.mone_codi
     and m.movi_clpr_codi = p_node_clpr_codi
     and m.movi_codi      = p_movi_codi;

exception
  when no_data_found then
     raise_application_error(-20001,'Factura inexistente.');
end pp_validar_factura;    


function   fp_devu_codi_barr (p_prod_codi in  number) return varchar2 is
  cursor c_coba is
  select coba_codi_barr
  from come_prod, come_prod_coba_deta  
  where prod_codi  =coba_prod_codi
  and coba_medi_codi = prod_medi_codi
  and prod_codi = p_prod_codi
  and coba_codi_barr is not null
  order by coba_nume_item;
  
  v_coba_codi_barr varchar2(30);
begin
  for x in c_coba loop
     
     v_coba_codi_barr := x.coba_codi_barr;
     exit;
      
  end loop;
  
  return v_coba_codi_barr;
end fp_devu_codi_barr;

procedure pp_traer_desc_conce (p_codi in number,
                               p_desc out varchar2,
                               p_impu out number) is
v_conc_dbcr varchar2(1);

cursor c_conc_iva (p_conc_codi in number) is
select conc_codi 
from ( select nvl(impu_conc_codi_ivdb,-1) conc_codi
         from come_impu
       union
       select nvl(impu_conc_codi_ivcr,-1) conc_codi
         from come_impu)
where conc_codi = p_conc_codi
order by 1;
     
begin              
  
  for x in c_conc_iva (p_codi)loop
      raise_application_error(-20001,'No puede seleccionar un concepto de IVA');
  end loop; 
  
  select conc_desc, conc_dbcr, conc_impu_codi
    into p_desc, v_conc_dbcr, p_impu
    from come_conc
   where conc_codi = p_codi
     and nvl(conc_indi_fact, 'N') = 'S'
     and upper(conc_dbcr) = 'C';

  /*if v_conc_dbcr = 'C' then
    pl_me('Debe ingresar un conceto de tipo Ingreso');
  end if; */
  
Exception
   When no_data_found then
       raise_application_error(-20001,'Concepto inexistente, no es facturable o no es un concepto de tipo ingreso!');

end pp_traer_desc_conce;

PROCEDURE pp_traer_datos_codi_barra(p_prod_codi in number, 
                                   p_medi_codi out number, 
                                   p_codi_barr in varchar2, 
                                   p_fact_conv out number) IS
BEGIN

  select d.coba_fact_conv, coba_medi_Codi
    into p_fact_conv, p_medi_Codi
    from come_prod_coba_deta d
   where d.coba_codi_barr = p_codi_barr
     and d.coba_prod_codi = p_prod_codi;

Exception
  when no_data_found then
    p_medi_codi:= null;
    p_fact_conv:= null;
  when too_many_rows then
     begin 
       select d.coba_fact_conv, d.coba_medi_Codi
         into p_fact_conv, p_medi_Codi
         from come_prod_coba_deta d
        where d.coba_prod_codi = p_prod_codi
          and d.coba_codi_barr = p_codi_barr
          and d.coba_nume_item = (select min(coba_nume_item)
                                    from come_prod_coba_deta
                                   where coba_prod_codi = p_prod_codi
                                     and coba_codi_barr = p_codi_barr);
     end;
  when others then
     raise_application_error(-20001,'Error');
END pp_traer_datos_codi_barra;
procedure  pp_traer_desc_prod(p_prod_codi_alfa in number,
                              p_deta_prod_codi out varchar2,
                              p_prod_desc      out varchar2,
                              p_deta_prod_clco out varchar2  ) is
v_prod_indi_inac char(1);
begin                                       
	                                    
 select prod_codi, prod_desc, prod_clco_codi, prod_indi_inac
 into p_deta_prod_codi, p_prod_desc, p_deta_prod_clco, v_prod_indi_inac
 from come_prod
 where prod_codi_alfa = p_prod_codi_alfa;
 
 
 if v_prod_indi_inac = 'S' then
 	 raise_application_error(-20001,'El producto se encuentra inactivo');
 end if;
 
 if p_deta_prod_clco is null then
 	raise_application_error(-20001,'El producto no tiene definido la Clasificacion de Conceptos');
 end if;
 
       
exception
  when no_data_found then
    raise_application_error(-20001,'Producto inexistente!');
 
end pp_traer_desc_prod;


procedure pp_ejecutar_consulta_fact (p_node_movi_codi      in number,
                                     p_node_mone_codi      in number,
                                     p_node_tasa_mone      in number,
                                     p_node_mone_cant_deci in number,
                                     p_node_clpr_codi      in number) is
  v_fact_codi number;

cursor c_node_deta (p_movi_codi in number) is
select d.deta_nume_item,
       d.deta_prod_codi,
       p.prod_codi_alfa,
       d.deta_cant_medi,
       d.deta_medi_codi,
       d.deta_prec_unit,
       (d.deta_impo_mone + d.deta_iva_mone) deta_impo_mone,
       'P' indi_prod,
       d.deta_prod_codi_barr
  from come_movi_prod_deta d, come_movi m , come_prod p
 where d.deta_movi_codi = m.movi_codi
   and d.deta_prod_codi = p.prod_codi
   and m.movi_codi = p_movi_codi
  
union

select d3.moco_nume_item deta_nume_item,
       c.conc_codi deta_prod_codi,
       to_char(d3.moco_conc_codi) prod_codi_alfa,  
       d3.moco_cant deta_cant_medi,
       null deta_medi_codi, 
       (nvl(d3.moco_impo_mone_ii,0)/d3.moco_cant) deta_prec_unit ,
       nvl(d3.moco_impo_mone_ii,0) deta_impo_mone,
       'S' indi_prod,
       null deta_prod_codi_barr   
from come_movi_conc_deta d3,  come_movi , come_conc c
where  movi_codi = d3.moco_movi_codi
and d3.moco_conc_codi = c.conc_codi
and nvl(d3.moco_indi_fact_serv, 'N') ='S'
and d3.moco_movi_codi = p_movi_codi

union

select d.deta_nume_item deta_nume_item, 
       o.ortr_codi deta_prod_codi,
       o.ortr_nume  prod_codi_alfa,   
       d.deta_cant deta_cant_medi,
       null deta_medi_codi,
       nvl(d.deta_prec_unit,((d.deta_impo_mone + d.deta_iva_mone) / d.deta_cant)) deta_prec_unit,
       (d.deta_impo_mone + d.deta_iva_mone) deta_impo_mone,
       'O' indi_prod,
       null deta_prod_codi_barr        
from come_movi_ortr_deta d, come_orde_trab o, come_movi
where movi_codi = d.deta_movi_codi
and  d.deta_ortr_codi = o.ortr_codi
and d.deta_movi_codi = p_movi_codi;

v_indi_prod_ortr      varchar2(600);
v_indi_prod_ortr_ante varchar2(600);
v_deta_nume_item      varchar2(600);
v_ortr_desc           varchar2(600);
v_deta_prod_codi      varchar2(600);
v_prod_codi_alfa      varchar2(600);
v_deta_medi_codi      varchar2(600);
v_deta_cant_medi      varchar2(600);
v_deta_cant_medi_orig varchar2(600);
v_deta_prec_unit      varchar2(600);
v_s_total_item        varchar2(600);
v_coba_codi_barr      varchar2(600);
v_medi_desc_abre      varchar2(600);   
v_coba_fact_conv      varchar2(600);   
v_deta_impu_codi      varchar2(600); 
vc_node_tica_codi     varchar2(600); 
v_prod_desc           varchar2(600); 
v_deta_prod_clco      varchar2(600); 
v_prod_codi_ante      varchar2(600); 
begin

  select tm.timo_tica_codi
    into vc_node_tica_codi
    from come_movi m, come_tipo_movi tm
   where m.movi_timo_codi = tm.timo_codi
     and m.movi_codi = p_node_movi_codi;
     

  for x in c_node_deta (p_node_movi_codi) loop
    
    

    
    v_indi_prod_ortr      := x.indi_prod;
    v_indi_prod_ortr_ante := x.indi_prod;
    v_deta_nume_item      := x.deta_nume_item;
    v_ortr_desc           := null;
    v_deta_prod_codi      := x.deta_prod_codi; 
    v_prod_codi_alfa      := x.prod_codi_alfa;
    v_deta_medi_codi      := x.deta_medi_codi;
    v_deta_cant_medi      := x.deta_cant_medi;
    v_deta_cant_medi_orig := x.deta_cant_medi;
    v_deta_prec_unit      := x.deta_prec_unit;
    v_s_total_item        := x.deta_impo_mone;
    
    if x.deta_prod_codi_barr is null then
     v_coba_codi_barr     := fp_Devu_codi_barr(x.deta_prod_codi);
    else
     v_coba_codi_barr      := x.deta_prod_codi_barr;
    end if;
    
    if v_indi_prod_ortr = 'P' then
      
      pp_traer_desc_prod(v_prod_codi_alfa ,
                         v_deta_prod_codi,
                         v_prod_desc,
                         v_deta_prod_clco );
      
     --- pp_validar_producto;
      
      pp_mostrar_unid_medi(v_deta_medi_codi,
                           v_medi_desc_abre);
      pp_traer_datos_codi_barra(v_deta_prod_codi,
                                v_deta_medi_codi,
                                v_coba_codi_barr,
                                v_coba_fact_conv);                        
                               
    elsif v_indi_prod_ortr = 'S' then
      pp_traer_desc_conce(v_prod_codi_alfa, v_ortr_desc, v_deta_impu_codi);
      v_prod_desc := v_ortr_desc;
    else

        I020274.pp_mostrar_ot(p_prod_codi_alfa       => v_prod_codi_alfa,
                              pc_node_mone_codi      => p_node_mone_codi,
                              pc_node_tasa_mone      => p_node_tasa_mone,
                              pc_node_mone_cant_deci => p_node_mone_cant_deci,
                              pc_node_clpr_codi      => p_node_clpr_codi,
                              p_deta_prod_codi       => v_deta_prod_codi,
                              p_prod_desc            => v_prod_desc,
                              p_deta_prod_clco       => v_deta_prod_clco,
                              p_prod_codi_ante       => v_prod_codi_ante,
                              p_deta_prec_unit       => v_deta_prec_unit);


    end if;
    
     apex_collection.add_member(p_collection_name => 'DETALLE',
                                           p_c001 => v_indi_prod_ortr,--v_node_indi_ortr,
                                           p_c002 => v_deta_nume_item,--v_node_nume_item,
                                           p_c003 => v_prod_desc,
                                           p_c004 => v_deta_prod_codi, 
                                           p_c005 => v_prod_codi_alfa,
                                           p_c006 => v_deta_medi_codi,
                                           p_c007 => v_deta_cant_medi,
                                           p_c008 => v_deta_prec_unit,
                                           p_c009 => v_s_total_item,
                                           p_c010 => v_coba_codi_barr,
                                           p_c011 => v_medi_desc_abre);
  
    
  end loop;

  
end pp_ejecutar_consulta_fact;


procedure pp_mostrar_ot(  p_prod_codi_alfa       in number,
                          pc_node_mone_codi      in number,
                          pc_node_tasa_mone      in number,
                          pc_node_mone_cant_deci in number,
                          pc_node_clpr_codi      in number,
                          p_deta_prod_codi       out number ,
                          p_prod_desc            out varchar2,
                          p_deta_prod_clco       out number,
                          p_prod_codi_ante       in out number,
                          p_deta_prec_unit       in out number ) is

v_clpr_codi      number;
v_cant           number;
v_prec_vent      number;
v_mone_codi_prec number;v_excl_fact      varchar2(1);

v_prec_unit      number;
v_indi_fact      varchar2(1);

begin

  begin
    select o.ortr_codi,
           o.ortr_desc,
           o.ortr_clpr_codi,
           o.ortr_clco_codi,
           nvl(o.ORTR_MONE_CODI_PREC, parameter.p_codi_mone_mmnn),
           o.ORTR_PREC_VENT,
           nvl(o.ortr_excl_fact, 'N'),
           nvl(o.ortr_indi_fact, 'N')
      into p_deta_prod_codi,
           p_prod_desc,
           v_clpr_codi,
           p_deta_prod_clco,
           v_mone_codi_prec,
           v_prec_vent,
           v_excl_fact,
           v_indi_fact
      from come_orde_trab o
     where o.ortr_nume = p_prod_codi_alfa;
     
   if p_prod_codi_ante is null then
      p_prod_codi_ante := p_deta_prod_codi;
   end if;
   
     if v_mone_codi_prec = pc_node_mone_codi then
        v_prec_unit := v_prec_vent;
     else   
      if pc_node_mone_codi = parameter.p_codi_mone_mmnn then
        v_prec_unit := round((v_prec_vent * pc_node_tasa_mone ), pc_node_mone_cant_deci);
      else
        v_prec_unit := round((v_prec_vent / pc_node_tasa_mone ), pc_node_mone_cant_deci);
      end if;
     end if;
     
   
     if nvl(p_deta_prec_unit,0) <= 0 or p_prod_codi_ante <> p_deta_prod_codi then 
      p_deta_prec_unit     := v_prec_unit;
    end if;  
   
   
    
    --verificar que la orden de trabajo pertenezca al cliente...
    if v_clpr_codi <> pc_node_clpr_codi then
      raise_application_error(-20001,'La orden de trabajo no pertenece al cliente, Favor Verifique!!!');
    end if; 
    
     
   /*-- Verificar que la orden de trabajo no fue facturarda a?n...
   select nvl(sum(decode(o.oper_stoc_suma_rest, 'S', deta_cant, -deta_cant)),0)  cant
   into v_cant
   from come_movi_ortr_deta d, come_movi m, come_stoc_oper o
   where m.movi_codi = d.deta_movi_codi
   and m.movi_oper_codi = o.oper_codi
   and deta_ortr_codi = :bdet.deta_prod_codi;
  
   
   if v_cant < 0 then
     pl_me('La orden de trabajo ya fue facturarda!!!!');
   end if;  
*/

    p_prod_codi_ante := p_deta_prod_codi;
    
  /*****************--------------revisar luego
  
  /* IF v_prec_vent <= 0 or v_prec_vent is null then
     set_item_property('bdet.deta_prec_unit', enabled, property_true);
   else
     set_item_property('bdet.deta_prec_unit', enabled, property_false);
   end if;*/
    
    Exception
      when no_data_found then                       
          raise_application_error(-20001,'Orden de trabajo inexistente!');

    end;  
  
  
/*  begin
  --verificar que la orden de trabajo est? disponible para facturar..
  --solo si saldo = 0...
  --se puede tener el caso de notas de creditos...
  --y entonces se puede volver a facturar...
  ------------------------------------------------------------------------------
  
  select nvl(sum(decode(o.oper_stoc_suma_rest, 'S', deta_cant, -deta_cant)),0)  
  into v_cant
  from come_movi_ortr_deta d, come_movi m, come_stoc_oper o
  where m.movi_codi = d.deta_movi_codi
  and m.movi_oper_codi = o.oper_codi
  and deta_ortr_codi = :bdet.deta_prod_codi;
  
  if v_cant > 0 then
    pl_me('La orden de trabajo ya est? facturada!!!');
  end if; 
  ---------------------------------------------------------------------------------
 end; 
*/  


  

end pp_mostrar_ot;
  


PROCEDURE pp_validar_factura2 (p_fact_nume       in number,
                              p_node_tica_codi  in number,
                              p_node_clpr_codi  in number,
                              p_movi_empl_codi  out number,
                              p_movi_codi       out number,
                              p_node_fact       out number,
                              p_fech_emis       out date,
                              p_mone_codi       out varchar2,
                              p_node_mone_cant_deci out varchar2,
                              p_node_tasa_mone      out varchar2) is
  v_node_empl_desc varchar2(200);
  v_empl_codi_alte varchar2(200);
  v_node_mone_desc varchar2(200);
  v_node_mone_desc_abre varchar2(200);
BEGIN
 select  m.movi_empl_codi,
         m.movi_codi,
         m.movi_nume,
         m.movi_fech_emis,
         mo.mone_codi_alte
    into p_movi_empl_codi,p_movi_codi, p_node_fact, p_fech_emis, p_mone_codi
    from come_movi m, come_clie_prov cp, come_tipo_movi tm, come_mone mo
   where nvl(m.movi_empr_codi,1) = parameter.p_empr_codi
     and m.movi_timo_codi in (1, 2, 3, 4)
     and m.movi_clpr_codi = cp.clpr_codi
     and m.movi_timo_codi = tm.timo_codi
     and m.movi_mone_codi = mo.mone_codi
     and m.movi_clpr_codi = p_node_clpr_codi
     and m.movi_nume      = p_fact_nume;


 if p_movi_empl_codi is not null then
    pp_muestra_come_empl(parameter.p_empr_codi,
                         parameter.p_codi_tipo_empl_vend,
                         p_movi_empl_codi,
                         v_node_empl_desc,
                         v_empl_codi_alte);
  end if;

if p_mone_codi is not null then
  general_skn.pl_muestra_come_mone (p_mone_codi, v_node_mone_desc, v_node_mone_desc_abre, p_node_mone_cant_deci);
  pp_busca_tasa_mone(p_mone_codi, p_fech_emis, p_node_tica_codi, p_node_tasa_mone);
end if;


  I020274.pp_ejecutar_consulta_fact(p_node_movi_codi => p_movi_codi,
                                    p_node_mone_codi => p_mone_codi,
                                    p_node_tasa_mone => p_node_tasa_mone,
                                    p_node_mone_cant_deci => p_node_mone_cant_deci,
                                    p_node_clpr_codi      => p_node_clpr_codi);




exception
  when no_data_found then
    raise_application_error(-20001, 'Factura inexistente.');
END pp_validar_factura2;



----------------------------------------++++++++++++++++++++


/*if nvl(:parameter.p_indi_validar_deta, 'S') = 'S' then ---Si no cargo Factura 
      if :bdet.indi_prod_ortr = 'P' then    
         pp_traer_desc_prod;
         if :bdet.deta_medi_codi is null then
           pp_trae_unid_medi;
         end if;
         
         :bdet.ortr_desc := null;               
      elsif :bdet.indi_prod_ortr = 'O' then    
          :bdet.deta_impu_codi:=:parameter.p_codi_impu_ortr;  
          pp_mostrar_ot;
          :bdet.deta_prec_unit_mini := :bdet.deta_prec_unit;
          
          if get_item_property('bdet.medi_desc_abre',enabled) = 'TRUE' then
             set_item_property('bdet.medi_desc_abre',enabled, property_false);
          end if;
          
      elsif :bdet.indi_prod_ortr = 'S' then
        if :bdet.ortr_desc is null
        or nvl(:bdet.prod_codi_alfa, '-1') <> nvl(:bdet.prod_alfa_ante, '-1') then
          pp_traer_desc_conce(:bdet.prod_codi_alfa, :bdet.ortr_desc, :bdet.deta_impu_codi);
          :bdet.prod_alfa_ante := :bdet.prod_codi_alfa;
        end if;
        :bdet.deta_prod_codi := :bdet.prod_codi_alfa;
        :bdet.prod_desc      := :bdet.ortr_desc;
        if :bdet.deta_impu_codi is null then
          :bdet.deta_impu_codi := :parameter.p_codi_impu_ortr;
        end if;
        if get_item_property('bdet.medi_desc_abre',enabled) = 'TRUE' then
           set_item_property('bdet.medi_desc_abre',enabled, property_false);
        end if;
      end if; P60_DETA_IMPU_CODI
      
    if :bdet.ortr_desc is not null then
      :bdet.prod_desc := :bdet.ortr_desc;
    end if;
end if;
*/
  


PROCEDURE pp_trae_unid_medi (p_deta_prod_codi in number,
                             p_deta_medi_codi out varchar2) IS
BEGIN
  select medi_codi 
    into p_deta_medi_codi
    from come_unid_medi
   where medi_codi in ( select coba_medi_codi 
                          from come_prod_coba_deta
                         where coba_prod_codi=p_deta_prod_codi);

 
exception
  when no_data_found then
    raise_application_error(-20001, 'No existe unidad de medida para el producto seleccionado.');

END pp_trae_unid_medi;



procedure pp_busca_prec_list_prec (p_list_prec in number, 
                                   p_mone_codi in number, 
                                   p_prod_codi in number, 
                                   p_medi_codi in number,
                                   p_node_mone_cant_deci in number,
                                   p_node_tasa_mone in number,
                                   p_prec_unit out number, 
                                   p_lide_indi_vali_prec_mini out varchar2,
                                   p_prod_maxi_porc_desc      out number,
                                   p_lide_maxi_porc_deto      out number) is

  v_prec_list_prec  number;
  v_lide_mone_codi  number;

begin

  select b.lide_prec, lide_mone_codi, lide_indi_vali_prec_mini, nvl(prod_maxi_porc_desc, 0), nvl(lide_maxi_porc_deto, 0)
    into v_prec_list_prec, v_lide_mone_codi, p_lide_indi_vali_prec_mini, p_prod_maxi_porc_desc, p_lide_maxi_porc_deto
    from come_list_prec a, come_list_prec_deta b, come_prod p
   where a.list_codi  = b.lide_list_codi
     and b.lide_prod_codi = p.prod_codi
     and b.lide_list_codi = p_list_prec
     and b.lide_prod_codi = p_prod_codi
     and lide_medi_codi = p_medi_codi;

    if v_lide_mone_codi = p_mone_codi then --si La moneda de la Factura es igual a la moneda del precio del producto   
      p_prec_unit := v_prec_list_prec;
    else  -- si la moneda del precio del producto no es igual a la moneda de la factura
      if p_mone_codi = parameter.p_codi_mone_mmnn then --Si la moneda de la Factura es en Gs..
        p_prec_unit := round((v_prec_list_prec * nvl(p_node_tasa_mone, 1)), parameter.p_cant_deci_mmnn);
      else  --si la moneda de la Factura es en US, tenemos que dividir por la tasa
        p_prec_unit := round((v_prec_list_prec / p_node_tasa_mone), p_node_mone_cant_deci);
      end if;
    end if;
  
Exception
  When others then
     p_prec_unit := 0;
     p_lide_indi_vali_prec_mini := 'N';
     p_prod_maxi_porc_desc := 0;
     p_lide_maxi_porc_deto := 0;
end pp_busca_prec_list_prec;


procedure pp_cod_barra (p_prod_codi in number,
                        p_codi_barr in number,
                        p_mone_codi in number,
                        p_node_mone_cant_deci in number,
                        p_node_tasa_mone in number,
                        p_fact_conv   out varchar2,
                        p_medi_codi   out varchar2,
                        p_prec_unit   out varchar2,
                        p_medi_desc    out varchar2
                          ) is
v_list_prec varchar2(100):= null;

v_lide_indi_vali_prec_mini varchar2(100);
v_prod_maxi_porc_desc varchar2(100);
v_lide_maxi_porc_deto varchar2(100);
begin

  I020274.pp_traer_datos_codi_barra(p_prod_codi => p_prod_codi,
                                    p_medi_codi => p_medi_codi,
                                    p_codi_barr => p_codi_barr,
                                    p_fact_conv => p_fact_conv);

  I020274.pp_busca_prec_list_prec(p_list_prec                => 1,--v_list_prec,
                                  p_mone_codi                => p_mone_codi,
                                  p_prod_codi                => p_prod_codi,
                                  p_medi_codi                => p_medi_codi,
                                  p_node_mone_cant_deci      => p_node_mone_cant_deci,
                                  p_node_tasa_mone           => p_node_tasa_mone,
                                  p_prec_unit                => p_prec_unit,
                                  p_lide_indi_vali_prec_mini => v_lide_indi_vali_prec_mini,
                                  p_prod_maxi_porc_desc      => v_prod_maxi_porc_desc,
                                  p_lide_maxi_porc_deto      => v_lide_maxi_porc_deto);
                                  
                                  
 
  I020274.pp_mostrar_unid_medi(p_codi => p_medi_codi,
                               p_desc => p_medi_desc);

                              

end pp_cod_barra;




--valida el precio minimo del producto... o sea el precio de lista..
procedure pp_vali_prec_mini (p_prec_unit      in number,
                             p_prec_unit_min  in number,
                             p_clpr_codi      in number,
                             p_prod_codi      in number,
                             p_list_codi      in number,
                             p_indi_prod_ortr in varchar2,
                             p_medi_codi      in number) is
                             
  v_clpr_indi_vali_prec_mini char(1) := 'N';
  v_lide_indi_vali_prec_mini char(1) := 'N';
begin
  begin
    select nvl(clpr_indi_vali_prec_mini, 'N')
      into v_clpr_indi_vali_prec_mini
      from come_clie_prov
     where clpr_codi = p_clpr_codi;
  exception
    when no_data_found then
      v_clpr_indi_vali_prec_mini := 'N';
  end;
  
  if p_indi_prod_ortr = 'P' then
    begin
      select nvl(lide_indi_vali_prec_mini, 'N')
        into v_lide_indi_vali_prec_mini
        from come_list_prec_deta
       where lide_prod_codi = p_prod_codi
         and lide_list_codi = p_list_codi
         and lide_medi_codi = p_medi_codi;
    exception
      when no_data_found then
        v_lide_indi_vali_prec_mini := 'N';
    end;
  end if;
  
    if v_clpr_indi_vali_prec_mini = 'S' or v_lide_indi_vali_prec_mini = 'S' then
      if p_prec_unit < p_prec_unit_min then
        raise_application_error(-20001,'Atenci?n!! el precio ingresado es menor al precio de lista');
      end if;
    end if;
end ;



procedure pp_veri_nume(p_nume in out number)is
  v_nume     number;
Begin
  v_nume := p_nume;
    loop             
      begin
        select node_nume
        into v_nume
        from come_nota_devu
        where node_nume = v_nume;  
        
        v_nume := v_nume + 1;   
      Exception
       when no_data_found then
         exit;                
       when too_many_rows then
         v_nume := v_nume + 1; 
      end;          
    end loop;  
  p_nume := v_nume;
end;



procedure pp_insert_come_nota_devu(v_node_codi      in number,
                                   v_node_nume      in varchar2,
                                   v_node_fech_emis in date,
                                   v_node_esta      in varchar2,
                                   v_node_clpr_codi in number,
                                   v_node_empr_codi in number,
                                   v_node_sucu_codi in number,
                                   v_node_depo_codi in number,
                                   v_node_obse      in varchar2,
                                   v_node_fech_grab in date,
                                   v_node_user      in varchar2,
                                   v_node_fech_auto in date,
                                   v_node_user_auto in varchar2,
                                   v_node_movi_codi in number,
                                   v_node_empl_codi in number,
                                   v_node_mone_codi in number,
                                   v_node_fact_codi in number,
                                   v_node_base      in number) is
begin
  insert into come_nota_devu
    (node_codi,
     node_nume,
     node_fech_emis,
     node_esta,
     node_clpr_codi,
     node_empr_codi,
     node_sucu_codi,
     node_depo_codi,
     node_obse,
     node_fech_grab,
     node_user,
     node_fech_auto,
     node_user_auto,
     node_movi_codi,
     node_empl_codi,
     node_mone_codi,
     node_fact_codi,
     node_base)
  values
    (v_node_codi,
     v_node_nume,
     v_node_fech_emis,
     v_node_esta,
     v_node_clpr_codi,
     v_node_empr_codi,
     v_node_sucu_codi,
     v_node_depo_codi,
     v_node_obse,
     v_node_fech_grab,
     v_node_user,
     v_node_fech_auto,
     v_node_user_auto,
     v_node_movi_codi,
     v_node_empl_codi,
     v_node_mone_codi,
     v_node_fact_codi,
     v_node_base);

end pp_insert_come_nota_devu;


procedure pp_insert_come_nota_devu_deta(v_node_nota_codi      number,
                                        v_node_ortr           number,
                                        v_node_nume_item      number,
                                        v_node_prod_codi      number,
                                        v_node_cant           number,
                                        v_node_medi_codi      number,
                                        v_node_prec_unit      number,
                                        v_node_impo_mone      number,
                                        v_node_conc_codi      number,
                                        v_node_indi_ortr      varchar2,
                                        v_node_prod_codi_barr varchar2) is
begin
  insert into come_nota_devu_deta
    (node_nota_codi,
     node_ortr,
     node_nume_item,
     node_prod_codi,
     node_cant,
     node_medi_codi,
     node_prec_unit,
     node_impo_mone,
     node_conc_codi,
     node_indi_ortr,
     node_prod_codi_barr)
  values
    (v_node_nota_codi,
     v_node_ortr,
     v_node_nume_item,
     v_node_prod_codi,
     v_node_cant,
     v_node_medi_codi,
     v_node_prec_unit,
     v_node_impo_mone,
     v_node_conc_codi,
     v_node_indi_ortr,
     v_node_prod_codi_barr);

end pp_insert_come_nota_devu_deta;

procedure pp_actualiza_come_nota_devu is
  v_node_codi      number(20);
  v_node_nume      varchar2(20);
  v_node_fech_emis date;
  v_node_esta      varchar2(1);
  v_node_clpr_codi number(20);
  v_node_empr_codi number(2);
  v_node_sucu_codi number(10);
  v_node_depo_codi number(10);
  v_node_obse      varchar2(2000);
  v_node_fech_grab date;
  v_node_user      varchar2(20);
  v_node_fech_auto date;
  v_node_user_auto varchar2(20);
  v_node_movi_codi number(20);
  v_node_empl_codi number(10);
  v_node_mone_codi number(4);
  v_node_fact_codi number(20);
  v_node_base      number(2);

begin

  --- asignar valores....

  if bcab.node_codi is null then
    --quiere decir que es un registro nuevo y no una actualizacion
    bcab.node_codi := fa_sec_come_nota_devu;
  end if;

  bcab.node_fech_grab := sysdate;
  bcab.node_user      := gen_user;

  v_node_codi      := bcab.node_codi;
  v_node_nume      := bcab.node_nume;
  v_node_fech_emis := bcab.node_fech_emis;
  v_node_esta      := bcab.node_esta;
  v_node_clpr_codi := bcab.node_clpr_codi;
  v_node_empr_codi := parameter.p_empr_codi;
  v_node_sucu_codi := bcab.node_sucu_codi_orig;
  v_node_depo_codi := bcab.node_depo_codi_orig;
  v_node_obse      := bcab.node_obse;
  v_node_fech_grab := bcab.node_fech_grab;
  v_node_user      := bcab.node_user;
  v_node_fech_auto := null;
  v_node_user_auto := null;
  v_node_movi_codi := null;
  v_node_empl_codi := bcab.node_empl_codi;
  v_node_mone_codi := bcab.node_mone_codi;
  v_node_fact_codi := bcab.node_movi_codi; --:bcab.node_fact;
  v_node_base      := parameter.p_codi_base;

  pp_insert_come_nota_devu(v_node_codi,
                           v_node_nume,
                           v_node_fech_emis,
                           v_node_esta,
                           v_node_clpr_codi,
                           v_node_empr_codi,
                           v_node_sucu_codi,
                           v_node_depo_codi,
                           v_node_obse,
                           v_node_fech_grab,
                           v_node_user,
                           v_node_fech_auto,
                           v_node_user_auto,
                           v_node_movi_codi,
                           v_node_empl_codi,
                           v_node_mone_codi,
                           v_node_fact_codi,
                           v_node_base);

end pp_actualiza_come_nota_devu;


procedure pp_actualiza_nota_devu_deta is      

v_node_nota_codi       number(20);
v_node_ortr            number(20);
v_node_nume_item       number(4);
v_node_prod_codi       number(20);
v_node_cant            number(20,4);
v_node_medi_codi       number(10);
v_node_prec_unit       number(20,4);
v_node_impo_mone       number(20,4);
v_node_conc_codi       number(20);
v_node_indi_ortr       varchar2(1);
v_node_prod_codi_barr  varchar2(30);


v_nro_item number:=0; 
begin

  for bdet in g_cur_col_det loop
  

    if bdet.prod_codi_alfa is null then
        raise_application_error(-20001, 'Debe ingresar al menos un item');
      end if;
    if bdet.deta_cant_medi is null then
       raise_application_error(-20001,'Debe ingresar la cantidad a devolver de cada item');
    end if;
    
    if bdet.deta_prec_unit is null then
       raise_application_error(-20001,'Debe ingresar el precio de cada item');
    end if; 


  v_nro_item := v_nro_item + 1;
    
  v_node_nota_codi                  := bcab.node_codi;
  v_node_nume_item                  := v_nro_item;
  v_node_cant                       := bdet.deta_cant_medi;
  v_node_medi_codi                  := bdet.deta_medi_codi;
  v_node_prec_unit                  := bdet.deta_prec_unit;
  v_node_impo_mone                  := bdet.s_total_item;
  v_node_indi_ortr                  := bdet.indi_prod_ortr;
  
  if bdet.indi_prod_ortr = 'P' then
    v_node_prod_codi                  := bdet.deta_prod_codi;
    v_node_prod_codi_barr             := bdet.coba_codi_barr;
    v_node_ortr                       := null;
    v_node_conc_codi                  := null;
  elsif bdet.indi_prod_ortr = 'S' then
    v_node_prod_codi                  := null;
    v_node_ortr                       := null;
    v_node_conc_codi                  := bdet.deta_prod_codi;
    v_node_prod_codi_barr             := null;
  elsif bdet.indi_prod_ortr = 'O' then
    v_node_prod_codi                  := null;
    v_node_ortr                       := bdet.deta_prod_codi;
    v_node_prod_codi_barr             := null;
    v_node_conc_codi                  := null;
  end if;
  
  pp_insert_come_nota_devu_deta(
              v_node_nota_codi,
              v_node_ortr     ,
              v_node_nume_item,
              v_node_prod_codi,
              v_node_cant     ,
              v_node_medi_codi,
              v_node_prec_unit,
              v_node_impo_mone,
              v_node_conc_codi,
              v_node_indi_ortr,
              v_node_prod_codi_barr
  );
  

end loop;

end pp_actualiza_nota_devu_deta;




procedure pp_set_value is
begin

  BCAB.NODE_NUME           := V('P60_NODE_NUME');
  BCAB.NODE_DEPO_CODI_ORIG := V('P60_NODE_DEPO_CODI_ORIG');
  BCAB.NODE_SUCU_CODI_ORIG := V('P60_NODE_SUCU_CODI_ORIG');
  BCAB.NODE_FECH_EMIS      := V('P60_NODE_FECH_EMIS');
  BCAB.CLPR_CODI_ALTE      := V('P60_CLPR_CODI_ALTE');
  BCAB.NODE_ESTA_DESC      := V('P60_NODE_ESTA_DESC');
  BCAB.NODE_CLPR_CODI      := V('P60_NODE_CLPR_CODI');

  BCAB.NODE_CLPR_TELE      := V('P60_NODE_CLPR_TELE');

  BCAB.NODE_CLPR_RUC       := V('P60_NODE_CLPR_RUC');
  BCAB.NODE_CLPR_DIRE      := V('P60_NODE_CLPR_DIRE');
  BCAB.DEPO_CODI_ALTE_ORIG := V('P60_DEPO_CODI_ALTE_ORIG');
  BCAB.MEDI_DESC_ABRE      := V('P60_MEDI_DESC_ABRE');
  BCAB.NODE_SUCU_DESC_ORIG := V('P60_NODE_SUCU_DESC_ORIG');

  BCAB.NODE_FACT           := V('P60_NODE_FACT');

  BCAB.NODE_FACT_FECH_EMIS := V('P60_NODE_FACT_FECH_EMIS');

  BCAB.NODE_EMPL_CODI      := V('P60_NODE_EMPL_CODI');
  BCAB.NODE_MONE_CODI      := V('P60_NODE_MONE_CODI');
  BCAB.NODE_TASA_MONE      := V('P60_NODE_TASA_MONE');
  BCAB.NODE_OBSE           := V('P60_NODE_OBSE');
  BCAB.NODE_ESTA           := V('P60_NODE_ESTA');
  BCAB.NODE_CODI           := V('P60_NODE_CODI');
end pp_set_value;

  

  


procedure pp_actualizar_registro is          
  
v_node_nume number;
begin

  pp_set_value;
  --raise_application_error(-20001, V('P60_NODE_TASA_MONE'));
  
  if bcab.node_esta <> 'P' then
    raise_application_error(-20001, 'La devoluci?n no puede ser modificada,ya fue Autorizada o Facturada');
  end if;
  
  if bcab.clpr_codi_alte is null then
    raise_application_error(-20001, 'Debe ingresar el cliente para continuar con La nota de devoluci?n');
  end if;
  
  if BCAB.NODE_EMPL_CODI is null then
   raise_application_error(-20001, 'Debe ingresar el vendedor para continuar con La nota de devoluci?n');
  end if;

  if bcab.node_tasa_mone is null then
    raise_application_error(-20001, 'El Tipo de moneda no posee cotizaci?n para la fecha');
  end if;
  
  
    I020274.pp_valida_fech(p_fech => bcab.node_fech_emis); 
    
   
  --  v_node_nume := bcab.node_nume;
    pp_veri_nume(bcab.node_nume);
    
    if bcab.node_codi is not null then  -- quiere decir que es una actualizacion
      if bcab.node_esta <> 'P' then
         raise_application_error(-20001,'No se puede actualizar porque La nota de devolucion no se encuentra en estado pendiente');
      end if; 
      
      delete come_nota_devu_deta where node_nota_codi = bcab.node_codi;
      delete come_nota_devu where node_codi = bcab.node_codi;
    end if; 
       
      pp_actualiza_come_nota_devu;
  
   ---------------detalle
      pp_actualiza_nota_devu_deta;  
      --pp_impr_nota_devu;

  I020274.pp_llama_reporte(p_codigo =>  bcab.node_codi);

 

end pp_actualizar_registro;


procedure pp_editar_deta (p_seq_id          number,           
                          p_node_indi_ortr  varchar2,
                          p_node_nume_item  varchar2,
                          p_prod_desc       varchar2,
                          p_node_prod_codi  varchar2,
                          p_prod_codi_alfa  varchar2,
                          p_node_medi_codi  varchar2,
                          p_node_cant       varchar2,
                          p_node_prec_unit  varchar2,
                          p_node_impo_mone  varchar2,
                          p_node_prod_codi_barr varchar2,
                          p_medi_desc_abre      varchar2 ) is
                          
                          
v_nro_item number := 0;  
begin
  
    IF p_node_indi_ortr IS NULL THEN
        raise_application_error(-20001, 'El indicador no puede ser nulo');
    END IF;


    IF p_prod_desc IS NULL THEN
        raise_application_error(-20001, 'La descripcion no puede ser nulo');
    END IF;

    IF p_node_prod_codi IS NULL THEN
        raise_application_error(-20001, 'El Producto no puede ser nulo');
    END IF;

    IF p_prod_codi_alfa IS NULL THEN
        raise_application_error(-20001, 'El producto no puede ser nulo');
    END IF;


    IF p_node_prec_unit IS NULL THEN
        raise_application_error(-20001, 'Precio unitario no puede ser nulo');
    END IF;

    IF p_node_impo_mone IS NULL THEN
        raise_application_error(-20001, 'El importe Total no puede ser nulo');
    END IF;

   /* IF p_node_prod_codi_barr IS NULL THEN
        raise_application_error(-20001, 'p_node_prod_codi_barr no puede ser nulo');
    END IF;*/






if p_seq_id  is not null then
   select nvl(max(c002),0)+1 deta_nume_item   
       into v_nro_item    
      from apex_collections a
     where collection_name = 'DETALLE';
     
     
      apex_collection.delete_member(p_collection_name => 'DETALLE',
                                    p_seq             => p_seq_id);
                                    
 else
   v_nro_item   := p_node_nume_item;                                 
end if;



  apex_collection.add_member(p_collection_name => 'DETALLE',
                                         p_c001 => p_node_indi_ortr,
                                         p_c002 => v_nro_item,
                                         p_c003 => p_prod_desc,
                                         p_c004 => p_node_prod_codi, 
                                         p_c005 => p_prod_codi_alfa,
                                         p_c006 => p_node_medi_codi,
                                         p_c007 => p_node_cant,
                                         p_c008 => p_node_prec_unit,
                                         p_c009 => p_node_impo_mone,
                                         p_c010 => p_node_prod_codi_barr,
                                         p_c011 => p_medi_desc_abre);
  

                              
end pp_editar_deta;




procedure pp_llama_reporte (P_CODIGO in varchar2) is
    v_parametros   CLOB;
    v_contenedores CLOB;

  begin
    v_contenedores := 'P_CODIGO';

    v_parametros := P_CODIGO;

    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, gen_user, 'I020274_avenida', 'pdf', V_CONTENEDORES);

    commit;
  end pp_llama_reporte;
  
  
  
end I020274;
