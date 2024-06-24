
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010315" is



type r_parameter is record(
  p_codi_peri_sgte       number:= to_number(general_skn.fl_busca_parametro('p_codi_peri_sgte')),
  p_indi_most_mens_sali  varchar2(2):= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
  p_codi_oper_com        number:= to_number(general_skn.fl_busca_parametro('p_codi_oper_com')),
  
  p_codi_impu_exen       number:= to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
  p_codi_impu_grav5      number:= to_number(general_skn.fl_busca_parametro('p_codi_impu_grav5')),
  p_codi_impu_grav10     number:= to_number(general_skn.fl_busca_parametro('p_codi_impu_grav10'))
 );
  parameter r_parameter;


procedure pp_iniciar is
  begin
    
   null;
   --   pl_me('Debe ingresar el Codigo de la lista de precios');
   
end pp_iniciar;


procedure pp_traer_desc_lp(p_codi           in number,
                           p_mone_codi      out number,
                           p_mone_desc_abre out varchar2,
                           p_mone_cant_deci out number) is
   v_desc varchar2(1000);          
                 
Begin
  
  select list_desc, list_mone_codi, mone_desc_abre, mone_cant_deci
    into v_desc, p_mone_codi, p_mone_desc_abre, p_mone_cant_deci
    from come_list_prec, come_mone
   where list_mone_codi = mone_codi(+)
     and list_codi = p_codi;

  if p_mone_codi is null then
    raise_application_error(-20001,'Debe asignar una moneda a la lista de precios');
  end if;

Exception
  when no_data_found then
    raise_application_error(-20001,'Lista de precio no encontrada!!');
  
end pp_traer_desc_lp;


procedure pp_mostrar_unid_medi(p_codi      in number,
                               p_desc_abre out varchar2) is
v_desc varchar2(300);
begin
  select medi_desc_abre, medi_desc
    into p_desc_abre, v_desc
    from come_unid_medi
   where medi_codi = p_codi;

exception
  when no_data_found then
    v_desc      := null;
    p_desc_abre := null;
  when others then
    raise_application_error(-20001,'Error');
  
end pp_mostrar_unid_medi;

function fp_calcular_precio(p_tipo       in varchar2,
                            p_ulti_compr in number,
                            p_cost_prom  in number,
                            p_prec_actu  in number,
                            p_porc_aume  in number,
                            pd_lide_prec in varchar2,
                            p_porc_iva   in number, 
                            p_redondeo   in number, 
                            pd_aux_prec_nuev in number,
                            pd_cost_prom     in number,
                            pd_ulti_compr    in number) return number is
  
  
  v_nuevo_precio number(15);
begin

  if p_tipo = 'P' then
    --precio actual    
    if pd_lide_prec is not null and pd_lide_prec > 0 then
      v_nuevo_precio := round((p_prec_actu +(p_prec_actu * (p_porc_aume / 100))) *(1 + (p_porc_iva / 100)),p_redondeo);
    else
      v_nuevo_precio := pd_aux_prec_nuev;
    end if;
  elsif p_tipo = 'C' then
    --costo prom
    if pd_cost_prom is not null and pd_cost_prom > 0 then
      v_nuevo_precio := round((p_cost_prom +(p_cost_prom * (p_porc_aume / 100))) *(1 + (p_porc_iva / 100)),p_redondeo);
    else
      v_nuevo_precio := pd_aux_prec_nuev;
    end if;
  elsif p_tipo = 'U' then
    --ultima compra
    if pd_ulti_compr is not null and pd_ulti_compr > 0 then
      if nvl(p_ulti_compr, 0) = 0 then
        v_nuevo_precio := round((p_cost_prom +(nvl(p_cost_prom, 0)*(p_porc_aume / 100)))*(1+(p_porc_iva/100)),p_redondeo);
      else
        v_nuevo_precio := round((p_ulti_compr +(nvl(p_ulti_compr,0)*(p_porc_aume/100)))*(1 +(p_porc_iva / 100)),p_redondeo);
      end if;
    else
      v_nuevo_precio := pd_aux_prec_nuev;
    end if;
  end if;
v_nuevo_precio := 0;
  return v_nuevo_precio;

end fp_calcular_precio;
function fp_porc_util (p_tipo           in varchar2,
                       p_tipo_actu      in varchar2,
                       p_prec_nuev      in varchar2,
                       p_cost_prom      in varchar2,
                       p_ulti_compr     in varchar2,
                       p_prod_codi      in number,
                       p_mone_cant_deci in number    ) return number is
  v_porc_util number;
  v_costo     number;
  v_precio    number;
  v_cost_ulpr number;
  v_impu_porc number;
  v_impo_impu number;
  v_margen    number;
  v_prec_neto number;
  v_s_precio_venta number;
  v_mapr_porc_reca number;
  v_mapr_porc_deto number;
begin
  v_mapr_porc_reca := null;
  v_mapr_porc_deto  := null;
  v_s_precio_venta := (p_prec_nuev + p_prec_nuev * nvl(v_mapr_porc_reca, 0) / 100) - ((p_prec_nuev + p_prec_nuev * nvl(v_mapr_porc_reca, 0) / 100) * nvl(v_mapr_porc_deto, 0) / 100);
 
  if p_tipo_actu in ('P', 'C') then
    if lower(p_tipo) = 'prec' then
      v_precio := nvl(p_prec_nuev, 0);
    elsif lower(p_tipo) = 'segm' then
      v_precio := nvl(v_s_precio_venta, 0);
    end if;
    v_cost_ulpr := p_cost_prom;
    if nvl(p_cost_prom, 0) = 0 then
      v_costo := 1;
    else
      v_costo := p_cost_prom;
    end if;
    
  elsif p_tipo_actu = 'U' then
    if lower(p_tipo) = 'prec' then
      v_precio := nvl(p_prec_nuev, 0);
    elsif lower(p_tipo) = 'segm' then
      v_precio := nvl(v_s_precio_venta, 0);
    end if;
    v_cost_ulpr := p_ulti_compr;
    if nvl(p_ulti_compr, 0) = 0 then
      v_costo := 1;
    else
      v_costo := p_ulti_compr;
    end if; 
    
  end if;
  
  
  
  begin
    select i.impu_porc
      into v_impu_porc
      from come_prod p, come_impu i
     where p.prod_impu_codi = i.impu_codi
       and p.prod_codi = p_prod_codi;
  exception
    when no_data_found then
      v_impu_porc := 0;
  end;
  
  if v_impu_porc = 0 then
    v_impo_impu := 0;
  elsif v_impu_porc = 5 then
    v_impo_impu := round(v_precio / 21, p_mone_cant_deci);
  else -- Se asume iva 10%
    v_impo_impu := round(v_precio / 11, p_mone_cant_deci);
  end if;
  
  v_impo_impu := 0;
  
  v_margen    := v_precio - v_impo_impu - v_cost_ulpr;
  --v_porc_util := round(v_margen * 100 / v_costo, 2);
  v_prec_neto := v_precio - v_impo_impu;
  if nvl(v_prec_neto, 0) = 0 then
    v_prec_neto := 1;
  end if; 
  v_porc_util := round(v_margen * 100 / v_prec_neto, 2);
  
  return v_porc_util;
  

end;
function fp_devu_unid_medi(p_codi in number) return varchar2 is

  v_desc varchar2(4);
begin
  select medi_desc_abre
    into v_desc
    from come_unid_medi
   where medi_codi = p_codi;

  return v_desc;

exception
  when no_data_found then
    return null;
  
end;

function fp_devu_lote_generico(p_prod_codi in number) return number is
  v_lote_codi number;
begin

  select lote_codi
    into v_lote_codi
    from come_lote
   where lote_prod_codi = p_prod_codi
     and lote_desc = '000000';

  return v_lote_codi;

exception
  when no_data_found then
    raise_application_error(-20001,'Lote de producto ' || p_prod_codi || ' no encontrado');
  
end;

procedure pp_devu_ult_cost(p_prod_codi in number,
                           p_ulco_cost_mmnn out number,
                           p_ulco_deta_movi_codi out number) is

  cursor c_ulti is
    select ulco_cost_mmnn, ulco_deta_movi_codi
      from come_prod_cost_ulti_comp
     where ulco_prod_codi = p_prod_codi
     order by 2 desc;
     
v_ulco_cost_mmnn number := 0;
v_ulco_deta_movi_codi number;

begin
  for x in c_ulti loop
    v_ulco_cost_mmnn            := x.ulco_cost_mmnn;
    v_ulco_deta_movi_codi       := x.ulco_deta_movi_codi;
  end loop;

   p_ulco_cost_mmnn := v_ulco_cost_mmnn;
   p_ulco_deta_movi_codi := v_ulco_deta_movi_codi;
Exception
  When no_data_found then
    p_ulco_cost_mmnn := 0;
  
end;
FUNCTION fp_calcular_precio2(p_tipo       in varchar2,
                            p_ulti_compr in number,
                            p_cost_prom  in number,
                            p_prec_actu  in number,
                            p_porc_aume  in number,
                            p_redondeo   in number) RETURN number IS
  v_nuevo_precio number(15);
  v_tipo varchar2(1) := 'P';

BEGIN
    
  if v_tipo = 'P' then
  
    if p_tipo = 'P' then
      --Precio Actual    
      v_nuevo_precio := round((p_prec_actu +
                              (p_prec_actu * (p_porc_aume / 100))),
                               p_redondeo);
    elsif p_tipo = 'C' then
      --Costo prom    
      v_nuevo_precio := round((p_cost_prom +
                              (p_cost_prom * (p_porc_aume / 100))),
                               p_redondeo);
    elsif p_tipo = 'U' then
    
      --Ultima Compra
      if nvl(p_ulti_compr, 0) = 0 then
        v_nuevo_precio := round((p_cost_prom +
                                (nvl(p_cost_prom, 0) * (p_porc_aume / 100))),
                                 p_redondeo);
                          
      else
        v_nuevo_precio := round((p_ulti_compr + (nvl(p_ulti_compr, 0) *
                                (p_porc_aume / 100))),
                                 p_redondeo);
                                 
                   
      end if;
    end if;
  else
    if p_tipo = 'P' then
      --Precio Actual    
      v_nuevo_precio := round((p_prec_actu + (p_porc_aume)), p_redondeo);
    elsif p_tipo = 'C' then
      --Costo prom    
      v_nuevo_precio := round((p_cost_prom + (p_porc_aume)), p_redondeo);
    elsif p_tipo = 'U' then
      --Ultima Compra
      if nvl(p_ulti_compr, 0) = 0 then
        v_nuevo_precio := round((p_cost_prom + (p_porc_aume)),
                                p_redondeo);
      else
        v_nuevo_precio := round((p_ulti_compr + (p_porc_aume)),
                                p_redondeo);
      end if;
    end if;
  end if;

  return v_nuevo_precio;

END fp_calcular_precio2;

procedure pp_devu_prec_nuev(p_prod_codi in number,
                            p_medi_codi in number,
                            p_list_codi in number,
                            p_prec      out number,
                            p_lide_user_regi out varchar2,
                            p_lide_fech_regi out date,
                            p_lide_user_modi out varchar2,
                            p_lide_fech_modi out date,
                            p_lide_prec_ante out number) IS
  v_prec number;
BEGIN
  select d.lide_prec,
         d.lide_prec_ante,
         d.lide_user_regi,
         d.lide_fech_regi,
         d.lide_user_modi,
         d.lide_fech_modi
    into p_prec,
         p_lide_prec_ante,
         p_lide_user_regi,
         p_lide_fech_regi,
         p_lide_user_modi,
         p_lide_fech_modi
    from come_list_prec_deta  d
   where lide_prod_codi = p_prod_codi
     and lide_medi_codi = p_medi_codi
     and lide_list_codi = p_list_codi     ;
 
  
exception 
   when no_data_found then
     null;
end;

procedure pp_editar_descripcion (p_seq_id  in varchar2,
                                 p_valor   in varchar2)is

 v_seq_id varchar2(20);

 begin
  
    v_seq_id := replace(p_seq_id,'f01_');

           --    raise_application_Error(-20001,v_seq_id||'/'|| p_valor);                  
                                      
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                              P_SEQ             => v_seq_id,
                                              P_ATTR_NUMBER     => 3,
                                              P_ATTR_VALUE      => p_valor);

 end pp_editar_descripcion;
 
 
 procedure pp_editar_porcentaje (p_seq_id  in varchar2,
                                 p_valor   in varchar2,
                                 p_tipo    in varchar2,
                                 p_cant_deci in number,
                                 pb_tipo     in varchar2,
                                 p_redondeo  in number)is

 v_seq_id varchar2(20);
 p_porc_aume varchar2(200);
 
  v_nuevo_precio       varchar2(200);            
  vc_porc_aume_ante  varchar2(200);
  vc_prec_nuev_ante  varchar2(200);
  vc_prec_variacion  varchar2(200);
  vi_ulti_compr      varchar2(200);
  vi_cost_prom       varchar2(200);
  vi_lide_prec       varchar2(200);
  vi_porc_aume_ante  varchar2(200);
  p_ulti_compr varchar2(200);
  p_cost_prom varchar2(200);
  p_prec_actu varchar2(200);
  p_prod_codi varchar2(200);
  v_utilidad varchar2(200);
 begin
   

   
  v_seq_id := replace(p_seq_id,'f02_');

               select replace(C005,'.', '') ulti_compr,
                      replace(C006,'.', '') cost_prom,
                      replace(C004,'.', '') lide_prec,
                      c002 prod_codi
               into p_ulti_compr,
                    p_cost_prom,
                    p_prec_actu,
                    p_prod_codi
            from apex_collections
           where collection_name = 'DETALLE'
            and seq_id  = v_seq_id;
     

    p_porc_aume := p_valor;

   if pb_tipo = 'P' then
    if p_tipo = 'P' then   --Precio Actual    
      v_nuevo_precio:=round((p_prec_actu + (p_prec_actu * (p_porc_aume/100)))  , p_redondeo);
    elsif p_tipo = 'C' then --Costo prom    
      v_nuevo_precio:= round((p_cost_prom + (p_cost_prom * (p_porc_aume/100))), p_redondeo);
    elsif p_tipo = 'U'   then --Ultima Compra
      if nvl(p_ulti_compr,0) = 0  then     
       v_nuevo_precio:= round((p_cost_prom + (nvl(p_cost_prom,0) * (p_porc_aume/100))), p_redondeo);  
      else     
       v_nuevo_precio:= round((p_ulti_compr + (nvl(p_ulti_compr,0) * (p_porc_aume/100))), p_redondeo);  
      end if; 
    end if; 
  else
    if p_tipo = 'P' then   --Precio Actual    
      v_nuevo_precio:=round((p_prec_actu + (p_porc_aume))  , p_redondeo);
    elsif p_tipo = 'C' then --Costo prom    
      v_nuevo_precio:= round((p_cost_prom + (p_porc_aume)), p_redondeo);
    elsif p_tipo = 'U'   then --Ultima Compra
      if nvl(p_ulti_compr,0) = 0  then     
       v_nuevo_precio:= round((p_cost_prom + (p_porc_aume)), p_redondeo); 
      else     
       v_nuevo_precio:= round((p_ulti_compr + (p_porc_aume)), p_redondeo);  
      end if; 
    end if;     
  end if;
  
vc_prec_variacion := nvl(v_nuevo_precio,0) -nvl( p_prec_actu,0);


    v_utilidad := fp_porc_util (p_tipo            => 'prec',
                   p_tipo_actu      => p_tipo,
                   p_prec_nuev      => v_nuevo_precio,
                   p_cost_prom      => p_cost_prom,
                   p_ulti_compr     => p_ulti_compr,
                   p_prod_codi      => p_prod_codi,
                   p_mone_cant_deci => p_cant_deci ) ;
                   
                   

      APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 15,
                                                    P_ATTR_VALUE      => p_porc_aume);
                                                    
                                                    
      APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 16,
                                                    P_ATTR_VALUE      => to_Char(v_nuevo_precio,'999g999g999g999'));
                                                                                                                                                                                                                                           
      APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 17,
                                                    P_ATTR_VALUE      => to_Char(vc_prec_variacion,'999g999g999g999'));
                                                    
                                                    
       APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 18,
                                                    P_ATTR_VALUE      => to_char(v_utilidad,'990D90'));                                             
                                                    

 end pp_editar_porcentaje;
 
 
 procedure pp_editar_monto(p_seq_id  in varchar2,
                           p_valor   in varchar2,
                           p_tipo_actu in varchar2,
                           p_cant_deci in number)is

 v_seq_id varchar2(20);
 VI_PREC_NUEV varchar2(200);
 
  vc_porc_aume       varchar2(200);            
  vc_porc_aume_ante  varchar2(200);
  vc_prec_nuev_ante  varchar2(200);
  vc_prec_variacion  varchar2(200);
  vi_ulti_compr      varchar2(200);
  vi_cost_prom       varchar2(200);
  vi_lide_prec       varchar2(200);
  vi_porc_aume_ante  varchar2(200);
 begin
   
  v_seq_id := replace(p_seq_id,'f03_');
   --raise_application_Error(-20001,v_seq_id||'/'|| p_valor);   
   select REGEXP_REPLACE(c007, '[^a-zA-Z0-9]', '') Ultima_compra,
          REGEXP_REPLACE(c009, '[^a-zA-Z0-9]', '') Costo_prom,
          REGEXP_REPLACE(c006, '[^a-zA-Z0-9]', '') Precio_Actual,
          REGEXP_REPLACE(c023, '[^a-zA-Z0-9]', '') porc_aume_ante
       into vi_ulti_compr,
            vi_cost_prom,
            vi_lide_prec,
            vi_porc_aume_ante
    from apex_collections
   where collection_name = 'DETALLE'
     and seq_id  = v_seq_id;

    VI_PREC_NUEV := p_valor;
    
    
      if nvl(vi_prec_nuev,0) <> nvl(vi_porc_aume_ante,0) then ---hubo un cambio de valor
          ---calculamos el % de aumento
          if(p_tipo_actu = 'U') then --para ultimo costo      
            if vi_ulti_compr is null then
             vc_porc_aume  :=     round(((vi_prec_nuev - vi_ulti_compr) *100/vi_ulti_compr),2);
            else
              vc_porc_aume := null;
            end if; 
            vc_prec_nuev_ante := vi_prec_nuev;
            vc_porc_aume_ante := vc_porc_aume;
          elsif (p_tipo_actu = 'C') then ---para costo promedio
            
            if nvl(vi_cost_prom,0) > 0 then
              vc_porc_aume  :=     round(((vi_prec_nuev - vi_cost_prom) *100/vi_cost_prom),2);
            else
             vc_porc_aume  := null;
            end if; 
             vc_prec_nuev_ante := vi_prec_nuev;
             vc_porc_aume_ante := vc_porc_aume;
          elsif (p_tipo_actu = 'P') then --para precio
            if nvl(vi_lide_prec,0) > 0 then
             vc_porc_aume  :=     round(((vi_prec_nuev - vi_lide_prec) *100/vi_lide_prec),2);
            else
             vc_porc_aume  := null;
            end if; 
            vc_prec_nuev_ante := vi_prec_nuev;
            vc_porc_aume_ante := vc_porc_aume;
          end if; 
      else
        null;
        
      end if; 

    
    

    vc_prec_variacion :=round(nvl(vi_prec_nuev,0) -nvl(vi_lide_prec,0));   
       
   if p_cant_deci = 0 then
    vc_prec_variacion     := to_char(vc_prec_variacion,'999g999g999g999');
  
  else
    vc_prec_variacion     := to_char(vc_prec_variacion,'999g999g999g999');

  end if;


         APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 21,
                                                    P_ATTR_VALUE      => VI_PREC_NUEV);  

                                                    
        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 25,
                                                    P_ATTR_VALUE      => vc_prec_variacion); 
                                                    
                                                    
         APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 22,
                                                    P_ATTR_VALUE      => vc_porc_aume);                                              
                                                                                                                                                                                                                                            
       APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 23,
                                                    P_ATTR_VALUE      => vc_porc_aume_ante);
                                                    
                                                    
       APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 20,
                                                    P_ATTR_VALUE      => vc_prec_nuev_ante);                                             

 end pp_editar_monto;
 
 
 



procedure pp_carga_datos2(p_prod_clas1     in number,
                         p_prod_clas2     in number,
                         p_list_codi      in number,
                         p_marc_codi      in number,
                         p_medi_codi      in number,
                         p_pend_auto_fact in varchar2, ---S= solo pendiente N = puede ser pendiente o autorizado
                         p_movi_codi      in number,
                         p_most_costoii   in varchar2,
                         p_porc_aume      in number,
                         p_redondeo       in number,
                         p_tipo_actu      in varchar2,
                         p_cant_deci      in number) IS

  cursor c_prod is
    select prod_codi,
           prod_codi_alfa,
           prod_desc,
           lide_medi_codi,
           coba_codi_barr,
           coba_fact_conv,
           prod_impu_codi,
           prod_user_auto_fact,
           prod_fech_auto_fact,
           medi_desc_abre,
           lide_prec,
           ulti_compr,
           cost_prom,
           indi_auto_fact,
           indi_auto_fact_orig porc_aum
      from t_i010315
     order by 1;
     
v_variable varchar2(200);
v_prec_nuev varchar2(200);
v_utilidad varchar2(200);
begin
apex_collection.create_or_truncate_collection(p_collection_name =>'DETALLE');

  pa_i010315(p_prod_clas1,
             p_prod_clas2,
             p_list_codi,
             p_marc_codi,
             p_medi_codi,
             p_pend_auto_fact,
             p_movi_codi,
             p_most_costoii);


  for x in c_prod loop
  
   v_prec_nuev :=fp_calcular_precio2(p_tipo_actu,
                                    x.ulti_compr, 
                                    x.cost_prom,  
                                    x.lide_prec, 
                                    nvl(p_porc_aume, 0),
                                    p_redondeo);
 
    v_variable := nvl(v_prec_nuev,0) -nvl( x.lide_prec,0);
    

    v_utilidad := fp_porc_util (p_tipo            => 'prec',
                   p_tipo_actu      => p_tipo_actu,
                   p_prec_nuev      => v_prec_nuev,
                   p_cost_prom      => x.cost_prom,
                   p_ulti_compr     => x.ulti_compr,
                   p_prod_codi      => x.prod_codi,
                   p_mone_cant_deci => p_cant_deci ) ;
                         
                       
      
        apex_collection.add_member(p_collection_name => 'DETALLE',
                                   P_C001            => x.prod_codi_alfa,
                                   P_C002            => x.prod_codi,
                                   P_C003            => x.prod_desc,
                                   P_C004            => to_char(x.lide_prec,'999G999G99G999'),
                                   P_C005            => to_char(x.ulti_compr,'999G999G990D9990'),
                                   P_C006            => to_char(x.cost_prom,'999G999G990D9990'),
                                   P_C007            => x.lide_medi_codi,
                                   P_C008            => x.medi_desc_abre,
                                   P_C009            => x.coba_codi_barr,
                                   P_C010            => nvl(x.indi_auto_fact,'S'),
                                   P_C011            => x.indi_auto_fact,
                                   P_C012            => x.prod_impu_codi,
                                   P_C013            => x.prod_user_auto_fact,
                                   P_C014            => x.prod_fech_auto_fact,
                                   P_C015            => to_char(nvl(p_porc_aume, 0),'990D90'),
                                   P_C016            => to_char(v_prec_nuev,'999G999G99G999'),
                                   p_c017            => to_char(v_variable,'999G999G99G999'),
                                   p_c018            => to_char(v_utilidad,'990D90'),
                                   p_c019            => 'S'
                                   );

  end loop;

end pp_carga_datos2;




procedure pp_editar_indi (p_seq_id  in number,
                          p_valor   in varchar2)is
 v_saldo number;
 v_impo_pago number;
 v_movi_fech_emis date;
 
v_saldo_tot number;
v_saldo_dif number;

 begin
   
 --raise_application_error(-20001,p_seq_id||'--'||p_valor);
   
 APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME    => 'DETALLE',
                                            P_SEQ             => p_seq_id,
                                            P_ATTR_NUMBER     => 10,
                                            P_ATTR_VALUE      => p_valor);
  

                                      
 end pp_editar_indi;


procedure pp_actualizar_registro2 (p_list_codi in number,
                                   p_mone_codi in number) is
  v_count number;
  
  cursor datos is(
                  select C001 prod_codi_alfa,
                         C002 prod_codi,
                         C003 prod_desc,
                         replace(C004,'.','') lide_prec,
                         C005 ulti_compr,
                         C006 cost_prom,
                         C007 lide_medi_codi,
                         C008 medi_desc_abre,
                         C009 coba_codi_barr,
                         C010 prod_indi_auto_fact,
                         C011 prod_indi_auto_fact_orig,----indi_auto_fact2,
                         C012 prod_impu_codi,
                         C013 prod_user_auto_fact,
                         C014 prod_fech_auto_fact,
                         C015 p_porc_aume,
                         replace(C016,'.','')  prec_nuev,
                         c017 variable1,
                         c018 utilidad,
                         c019 indi_proc

                    from apex_collections
                   where collection_name = 'DETALLE');
begin

  for bdatos in datos  loop
    if bdatos.indi_proc = 'S' then
      if (nvl(bdatos.prec_nuev, 0) <> nvl(bdatos.lide_prec, 0)) then      
        
          select count(*)
          into v_count
          from come_list_prec_deta
          where lide_prod_codi = bdatos.prod_codi
          and lide_list_codi = p_list_codi
          and lide_medi_codi = bdatos.lide_medi_codi;
        if nvl(v_count, 0) = 0 then
          insert into come_list_prec_deta
            (lide_list_codi,
             lide_prod_codi,
             lide_prec,
             lide_mone_codi,
             lide_medi_codi,
             lide_user_regi,
             lide_fech_regi)
          values
            (p_list_codi,
             bdatos.prod_codi,
             bdatos.prec_nuev,
             p_mone_codi,
             bdatos.lide_medi_codi,
             user,
             sysdate);
        
        else
          update come_list_prec_deta
             set lide_prec      = bdatos.prec_nuev,
                 lide_mone_codi = p_mone_codi,
                 lide_user_modi = gen_user,
                 lide_fech_modi = sysdate
           where lide_prod_codi = bdatos.prod_codi
             and lide_list_codi = p_list_codi
             and lide_medi_codi = bdatos.lide_medi_codi;
        end if;
      end if;
    
  
        if nvl(bdatos.prod_indi_auto_fact, 'S') <> nvl(bdatos.prod_indi_auto_fact_orig, 'S') then
          if bdatos.prod_indi_auto_fact = 'S' then
            update come_prod p
               set p.prod_indi_auto_fact = nvl(bdatos.prod_indi_auto_fact,'S'),
                   p.prod_user_auto_fact = user,
                   p.prod_fech_auto_fact = sysdate
             where p.prod_codi = bdatos.prod_codi;
          else
            update come_prod p
               set p.prod_indi_auto_fact = nvl(bdatos.prod_indi_auto_fact, 'S')
             where p.prod_codi = bdatos.prod_codi;
          end if;
        end if;
    end if;

  end loop;


end pp_actualizar_registro2;


end I010315;
