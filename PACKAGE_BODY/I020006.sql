
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020006" is


function fp_dev_movi_nume (p_movi_codi in number) return number is
v_nume number;
begin
  select movi_nume
  into v_nume
  from come_movi
  where movi_codi = p_movi_codi;
  
  return v_nume;
  
Exception 
  when no_data_found then
    return null;
  When others then
    return null;  
  
end;



procedure pp_Cargar_Detalle(p_inve_depo_codi in number,
                            p_codigo         in number) is

  cursor inventario is(
    select a.deta_codi_inve,
           a.deta_nume_item,
           a.deta_prod_codi,
           a.deta_cant,
           a.deta_cant_stoc,
           a.deta_cost_prom,
           a.deta_base,
           a.deta_indi_inac,
           null deta_lote_codi
      from come_inve_deta a
      where deta_codi_inve =p_codigo);

  v_nume_pag       number := 1;
  v_cont           number := 0;
  v_deta_cant      number;
  v_deta_indi_inac varchar2(3);
  v_lote_desc      varchar2(300);
  v_deta_prod_desc varchar2(300);      
  v_deta_prod_cf   varchar2(300);
  v_ubic           varchar2(300);
begin
--raise_application_error(-20001,p_inve_depo_codi );
  for x in inventario loop
  
    v_cont := v_cont + 1;
    if v_nume_pag = 1 then
      if v_cont >= 54 then
        v_cont     := 0;
        v_nume_pag := v_nume_pag + 1;
      end if;
    else
      if v_cont >= 72 then
        v_cont     := 0;
        v_nume_pag := v_nume_pag + 1;
      end if;
    end if;
  
  begin
    select lote_desc
      into v_lote_desc
      from come_lote
     where lote_codi = x.deta_lote_codi;
   Exception
           When no_data_found then
            v_lote_desc := null;
        end;
     
    --------------------producto 
    begin
    select prod_desc, prod_codi_alfa
      into v_deta_prod_desc, v_deta_prod_cf
      from come_prod
     where prod_codi = x.deta_prod_codi;
      Exception
           When no_data_found then
            v_deta_prod_desc := null;
            v_deta_prod_cf := null;
        end;
     

        begin
          select prde_ubic
          into v_ubic
          from come_prod_depo
          where prde_depo_codi = p_inve_depo_codi  
          and prde_prod_codi   = x.deta_prod_codi;  
        Exception
           When no_data_found then
            v_ubic := null;
        end;
  
    if nvl(x.deta_cost_prom, 0) < 0 then
      raise_application_error(-20001,
                              'El costo promedio debe ser mayor a cero');
    end if;
  
    if nvl(x.deta_cant, 0) = -1 then
      v_deta_cant      := 0;
      v_deta_indi_inac := 'S';
    else
      v_deta_cant      := x.deta_cant;
      v_deta_indi_inac := x.deta_indi_inac;
    
    end if;
    if nvl(x.deta_cant, 0) < 0 then
      raise_application_error(-20001, 'La cantidad debe ser mayor a cero');
    end if;
  
    apex_collection.add_member(p_collection_name => 'DETALLE',
                               P_C001            => v_nume_pag,
                               P_C002            => x.deta_codi_inve,
                               P_C003            => x.deta_nume_item,
                               P_C004            => v_deta_prod_cf,
                               P_C005            => x.deta_prod_codi,
                               P_C006            => v_deta_prod_desc,
                               P_C007            => x.deta_lote_codi,
                               P_C008            => v_lote_desc,
                               P_C009            => v_ubic,
                               P_C010            => v_deta_cant,
                               P_C011            => v_deta_indi_inac,
                               P_C012            => x.deta_cost_prom,
                               P_C013            => x.deta_base,
                               P_C014            => x.deta_prod_codi --enlace
                               );
  
  end loop;

end pp_Cargar_Detalle;

procedure pp_consultar(p_inve_nume      in number,
                       p_inve_codi      out number,
                       p_inve_fech_emis out date,
                       p_inve_fech_grab out date,
                       p_inve_user      out varchar2,
                       p_inve_sucu_codi out number,
                       p_inve_depo_codi out number,
                       p_inve_obse      out varchar2,
                       p_inve_base      out number,
                       P_desc_depo      out varchar2,
                       P_desc_sucu      out varchar2) is


v_codi      number;           
v_inve_movi_codi number;       
v_inve_esta varchar2(20);
v_nro_aju varchar2(200);
begin

  select inve_codi, inve_movi_codi, inve_esta
    into v_codi, v_inve_movi_codi, v_inve_esta
    from come_inve
   where inve_nume = p_inve_nume;

  if v_inve_movi_codi is not null then
    v_nro_aju := fp_dev_movi_nume(v_inve_movi_codi);
    raise_application_error(-20001,
                            'La Toma de Inventario ya fue ajustada.. Ajuste Nro. ' ||
                            v_nro_aju);
  end if;

  if nvl(v_inve_esta, 'P') = 'S' then
    raise_application_error(-20001,
                            'La Toma de Inventario no se encuentra pendiente de carga ');
  end if;

  select a.inve_codi,
         a.inve_fech_emis,
         a.inve_fech_grab,
         a.inve_user,
         a.inve_sucu_codi,
         a.inve_depo_codi,
         a.inve_obse,
         a.inve_base
    into p_inve_codi,
         p_inve_fech_emis,
         p_inve_fech_grab,
         p_inve_user,
         p_inve_sucu_codi,
         p_inve_depo_codi,
         p_inve_obse,
         p_inve_base
    from come_inve a
   where inve_codi = v_codi;


BEGIN
  select depo_codi||'- '||depo_desc   , depo_sucu_codi||'- '||sucu_desc
  into    P_desc_depo , P_desc_sucu
  from   come_depo, come_sucu
  where  depo_sucu_codi = sucu_codi
  and depo_codi = p_inve_depo_codi;
EXCEPTION WHEN others THEN
  P_desc_depo := NULL;
  P_desc_sucu:= NULL;

END ;

apex_collection.create_or_truncate_collection(p_collection_name =>'DETALLE');


pp_Cargar_Detalle(p_inve_depo_codi, v_codi) ;


Exception
  when no_data_found then
    raise_application_error(-20001, 'Numero de Inventario Inexistente');
  when too_many_rows then
    raise_application_error(-20001, 'Nro de Inventario Duplicado');
  
end pp_consultar;



procedure pp_cargar_prod_pres (p_prod_codi in number,
                               p_cant      in number)is

cursor c_prod_pres is
  select cb.coba_codi_barr,
         cb.coba_desc,
         u.medi_desc_abre,
         cb.coba_fact_conv
    from come_prod_coba_deta cb, come_unid_medi u
   where cb.coba_medi_codi = u.medi_codi
     and cb.coba_prod_codi = p_prod_codi
order by cb.coba_fact_conv desc;
v_seq_id number;
begin
  v_seq_id := p_cant;
apex_collection.create_or_truncate_collection(p_collection_name =>'PROD_PRES');

  
  for x in c_prod_pres loop

   
    apex_collection.add_member(p_collection_name => 'PROD_PRES',
                               P_C001            => x.coba_codi_barr,
                               P_C002            => x.coba_desc,
                               P_C003            => x.medi_desc_abre,
                               P_C004            => x.coba_fact_conv,
                               p_c005            => '',
                               p_c006            => p_cant);
  end loop;


 APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                              P_SEQ             => v_seq_id,
                                              P_ATTR_NUMBER     => 10,
                                              P_ATTR_VALUE      => 0);  
  
end pp_cargar_prod_pres; 

procedure pp_actualizar_registro(p_inve_nume      in number,
                                 p_inve_codi      in number,
                                 p_inve_fech_emis in date,
                                 p_inve_fech_grab in date,
                                 p_inve_user      in varchar2,
                                 p_inve_sucu_codi in number,
                                 p_inve_depo_codi in number,
                                 p_inve_obse      in varchar2,
                                 p_inve_base      in number) is

  cursor detalle is
    select
           C001 nume_pag,
           C002 deta_codi_inve,
           C003 deta_nume_item,
           C004 deta_prod_cf,
           C005 deta_prod_codi,
           C006 deta_prod_desc,
           C007 deta_lote_codi,
           C008 lote_desc,
           C009 ubic,
           C010 deta_cant,
           C011 deta_indi_inac,
           C012 deta_cost_prom,
           C013 deta_base,
           C014 deta_prod_codi2
      from apex_collections
     where collection_name = 'DETALLE';

 v_codi_base number;

begin
  
 v_codi_base := pack_repl.fa_devu_codi_base; 
  --------------SEGUN LO QUE ENTIENDO ES QUE ACTUALIZA LA CABECERA Y EL DETALLE
  UPDATE come_inve a
     SET a.inve_fech_emis = p_inve_fech_emis,
         a.inve_sucu_codi = p_inve_sucu_codi,
         a.inve_depo_codi = p_inve_depo_codi,
         a.inve_obse      = p_inve_obse,
         a.inve_base      = v_codi_base,
         a.inve_nume      = p_inve_nume 
   where inve_codi = p_inve_codi;

  -----------------detalle

  for x in detalle loop
    update come_inve_deta b
       set b.deta_prod_codi = x.deta_prod_codi,
           b.deta_cant      = x.deta_cant,
           b.deta_cost_prom = x.deta_cost_prom,
           b.deta_base      = x.deta_base,
           b.deta_indi_inac = x.deta_indi_inac
    --null deta_lote_codi
     where deta_codi_inve = x.deta_codi_inve
       and deta_nume_item = x.deta_nume_item;
  
  end loop;
  
  apex_collection.create_or_truncate_collection(p_collection_name =>'PROD_PRES');
apex_collection.create_or_truncate_collection(p_collection_name =>'DETALLE');
END pp_actualizar_registro;


procedure pp_editar_cant(p_seq_id  in varchar2,
                         p_valor   in varchar2) is
  
v_cantidad number;
v_seq_id  number;
v_deta_indi_inac varchar2(100);
begin
    v_seq_id := replace(p_seq_id,'f02_');
    v_cantidad := p_valor;
   
    if nvl(v_cantidad,0) = -1 then
       v_cantidad := 0;
       v_deta_indi_inac := 'S';
 
    end if;	
    if nvl(v_cantidad,0)  < 0 then
       raise_application_error(-20001, 'La cantidad debe ser mayor a cero');
    end if;	
    
     APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                              P_SEQ             => v_seq_id,
                                              P_ATTR_NUMBER     => 10,
                                              P_ATTR_VALUE      => v_cantidad);  
                                              
     
     if nvl(v_deta_indi_inac,'N') ='S' then                                         
     APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                             P_SEQ             => v_seq_id,
                                             P_ATTR_NUMBER     => 11,
                                             P_ATTR_VALUE      => v_deta_indi_inac);    
                                             
                                                                                   
    end if;
end pp_editar_cant;




procedure pp_editar_cant_pre(p_seq_id  in varchar2,
                             p_valor   in varchar2,
                             p_deta_codi in number) is
  
v_cantidad number;
v_seq_id  number;
v_deta_indi_inac varchar2(100);
v_coba_fact_conv number;
v_deta_cant number;
p_sum_deta_cant number;
begin
    v_seq_id := replace(p_seq_id,'f03_');
    v_cantidad := p_valor;
    
 --raise_Application_error(-20001, v_seq_id||'++'||v_cantidad);
   
    if nvl(v_cantidad,0) = -1 then
       v_cantidad := 0;
       v_deta_indi_inac := 'S';
 
    end if;	
    if nvl(v_cantidad,0)  < 0 then
       raise_application_error(-20001, 'La cantidad debe ser mayor a cero');
    end if;	
    
     APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'PROD_PRES',
                                              P_SEQ             => v_seq_id,
                                              P_ATTR_NUMBER     => 5,
                                              P_ATTR_VALUE      => v_cantidad);  
                                              


end pp_editar_cant_pre;



procedure pp_calcular_item (p_deta_codi in number)is
  
v_coba_fact_conv number;
v_deta_cant number;
p_sum_deta_cant number;


begin

 p_sum_deta_cant := 0;
for x in ( select C004 coba_fact_conv,
                  c005  cantidad
             from apex_collections
            where collection_name = 'PROD_PRES'
              and c006 = p_deta_codi) loop
           
           
    v_coba_fact_conv := nvl(x.coba_fact_conv,0);
    v_deta_cant := nvl(x.cantidad,0);
 
  --raise_Application_error(-20001, v_coba_fact_conv||'++'||v_deta_cant);
    if v_coba_fact_conv is not null and v_deta_cant is not null then
        p_sum_deta_cant  := p_sum_deta_cant + (v_coba_fact_conv * v_deta_cant);
    end if;
    
  end loop;


   APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                              P_SEQ             => p_deta_codi,
                                              P_ATTR_NUMBER     => 10,
                                              P_ATTR_VALUE      => p_sum_deta_cant);  
                                              
                                              
end pp_calcular_item;
end I020006;
