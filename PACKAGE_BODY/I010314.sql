
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010314" is


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
   --	 pl_me('Debe ingresar el Codigo de la lista de precios');
   
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

if p_porc_aume <> 0 then
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
  end if; 
  return nvl(v_nuevo_precio,0);

end fp_calcular_precio;

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

procedure pp_carga_datos(p_prod_clas1     in number,
                         p_prod_clas2     in number,
                         p_list_codi      in number,
                         p_marc_codi      in number,
                         p_prod_base_codi in number,
                         p_medi_codi      in number,
                         p_prod_codi      in number,
                         p_fech_inic      in date,
                         p_fech_fini      in date,
                         p_movi_nume      in number,
                         p_clpr_codi      in number,
                         p_remi_codi      in number,
                         p_tipo_orde      in varchar2,
                         p_tipo_actu      in varchar2,
                         p_porc_aume      in number,
                         p_porc_iva       in number,
                         p_redondeo       in number,
                         p_ulti_user_modi_cost out varchar2,
                         p_ulti_fech_modi_cost out varchar2,
                         p_cant_deci       in number,
                         p_moneda          in number,
                         p_ulti_user_modi  out varchar2,
                         p_ulti_fech_modi  out varchar2) is                      
                         
 cursor c_remi_deta is 
  select p.prod_codi,
         p.prod_codi_alfa,
         c.coba_desc,
         p.prod_impu_codi,
         c.coba_medi_codi,
         d.deta_prod_codi_barr coba_codi_barr,
         c.coba_fact_conv
  from come_remi r, come_remi_deta d, come_prod p, come_prod_coba_deta c
  where r.remi_codi = d.deta_remi_codi
   and  d.deta_prod_codi = p.prod_codi
   and  d.deta_prod_codi = c.coba_prod_codi
   and r.remi_codi = p_remi_codi;                      
  
cursor c_prod_codi is 
  select p.prod_codi,
         p.prod_codi_alfa,
         d.coba_desc,--p.prod_desc,
         p.prod_impu_codi,
         d.coba_medi_codi,
         max(d.coba_codi_barr) coba_codi_barr,
         d.coba_fact_conv
    from come_prod p,  come_prod_coba_deta d
   where p.prod_codi = d.coba_prod_codi
     and (p.prod_clas1 = p_prod_clas1 or p_prod_clas1 is null)
     and (p.prod_clas2 = p_prod_clas2 or p_prod_clas2 is null)
     and (d.coba_medi_codi = p_medi_codi or p_medi_codi is null)
     and (p.prod_marc_codi = p_marc_codi or p_marc_codi is null)
     and (p.prod_prod_base_codi = p_prod_base_codi or p_prod_base_codi is null)
     and nvl(p.prod_indi_inac,'N')='N'
     and (p_prod_codi is null or p_prod_codi = p.prod_codi)
     and (p_movi_nume is null or
         (p.prod_codi in (select distinct dd.deta_prod_codi
                                  from come_movi md, come_movi_prod_deta dd
                                 where md.movi_codi = dd.deta_movi_codi
                                   and md.movi_oper_codi = parameter.p_codi_oper_com
                                   and md.movi_codi = p_movi_nume)))
     and ((p_fech_inic is null and p_fech_fini is null) or 
          (p.prod_codi in (select distinct dd.deta_prod_codi
                                  from come_movi md, come_movi_prod_deta dd
                                 where md.movi_codi = dd.deta_movi_codi
                                   and md.movi_oper_codi = parameter.p_codi_oper_com
                                   and (md.movi_fech_emis >= p_fech_inic or p_fech_inic is null)
                                   and (md.movi_fech_emis <= p_fech_fini or p_fech_fini is null))))                         
     and (p_clpr_codi is null or p_clpr_codi = p.prod_clpr_codi or 
          (p.prod_codi in (select distinct pp.prod_prov_prod_codi
                             from come_prod_prov_deta pp
                            where pp.prod_prov_clpr_codi = p_clpr_codi)))
   group by p.prod_codi,
         p.prod_codi_alfa,
         d.coba_desc,
         p.prod_impu_codi,
         d.coba_medi_codi,
         d.coba_fact_conv
   order by 1;

cursor c_prod_desc is 
  select p.prod_codi,
         p.prod_codi_alfa,
         d.coba_desc, --p.prod_desc,
         p.prod_impu_codi,
         d.coba_medi_codi,
         max(d.coba_codi_barr) coba_codi_barr,
         d.coba_fact_conv
    from come_prod p,  come_prod_coba_deta d
   where p.prod_codi = d.coba_prod_codi
     and (p.prod_clas1 = p_prod_clas1 or p_prod_clas1 is null)
     and (p.prod_clas2 = p_prod_clas2 or p_prod_clas2 is null)
     and (d.coba_medi_codi = p_medi_codi or p_medi_codi is null)
     and (p.prod_marc_codi = p_marc_codi or p_marc_codi is null)
     and (p.prod_prod_base_codi = p_prod_base_codi or p_prod_base_codi is null)
     and nvl(p.prod_indi_inac,'N')='N'
     and (p_prod_codi is null or p_prod_codi = p.prod_codi)
     and (p_movi_nume is null or
          (p.prod_codi in (select distinct dd.deta_prod_codi
                                  from come_movi md, come_movi_prod_deta dd
                                 where md.movi_codi = dd.deta_movi_codi
                                   and md.movi_oper_codi = parameter.p_codi_oper_com
                                   and md.movi_codi= p_movi_nume)))
     and ((p_fech_inic is null and p_fech_fini is null) or 
          (p.prod_codi in (select distinct dd.deta_prod_codi
                                  from come_movi md, come_movi_prod_deta dd
                                 where md.movi_codi = dd.deta_movi_codi
                                   and md.movi_oper_codi = parameter.p_codi_oper_com
                                   and (md.movi_fech_emis >= p_fech_inic or p_fech_inic is null)
                                   and (md.movi_fech_emis <= p_fech_fini or p_fech_fini is null))))
     and (p_clpr_codi is null or p_clpr_codi = p.prod_clpr_codi or 
          (p.prod_codi in (select distinct pp.prod_prov_prod_codi
                             from come_prod_prov_deta pp
                            where pp.prod_prov_clpr_codi = p_clpr_codi)))
                            
    group by p.prod_codi,
             p.prod_codi_alfa,
             d.coba_desc,
             p.prod_impu_codi,
             d.coba_medi_codi,
             d.coba_fact_conv
   order by 3;
   
v_prod_codi_alfa           varchar2(300);
v_prod_codi                varchar2(300);
v_prod_desc                varchar2(300);       
v_prod_desc_orig           varchar2(300);  
v_prod_impu_codi           varchar2(300);     
v_lide_prec                varchar2(300);       
v_ulti_compr               varchar2(300);      
v_lote_codi                varchar2(300);       
v_cost_prom                varchar2(300);      
v_lide_medi_codi           varchar2(300);  
v_medi_desc_abre           varchar2(300);  
v_coba_codi_barr           varchar2(300);
v_lide_prec_ante           varchar2(300);
v_lide_user_regi           varchar2(300);
v_lide_fech_regi           varchar2(300);
v_lide_user_modi           varchar2(300);
v_lide_fech_modi           date;
v_ulco_cost_mmnn           number; 
v_ulco_deta_movi_codi      number; 
v_prec_nuev_ante           number;
v_prec_nuev                number;
v_porc_aume                number;
v_porc_aume_ante           number;
v_aux_prec_nuev            number;
v_vari_prec                 varchar2(300);
begin     
 --  raise_application_error(-20001,p_porc_aume||'-'||p_tipo_actu);
  if p_list_codi is null then
   raise_application_error(-20001,'Debe ingresar el Codigo de la lista de precios');
  end if;
  
  
   
  
  if p_prod_clas1 is null  and p_prod_codi is null  and p_clpr_codi is null  and p_movi_nume is null then
   raise_application_error(-20001,'Debe ingresar una familia'); 
  end if;
   apex_collection.create_or_truncate_collection(p_collection_name =>'DETALLE');
             
if p_prod_codi is null then
 if p_clpr_codi is null then
  if p_movi_nume is null then
   if p_prod_base_codi is null then
    if p_prod_clas1 is null then
     if p_marc_codi is null then
      if p_prod_base_codi is null then                
       if p_remi_codi is null then            
         raise_application_error(-20001, 'Debe ingresar al menos un criterio!');        
       end if;
      end if;
     end if;
    end if;
   end if;
  end if; 
 end if;
end if;

if p_prod_codi is null then
  if p_clpr_codi is null then
    if p_movi_nume is null then
      if p_prod_base_codi is null then
        if p_prod_clas1 is null then
          if p_movi_nume is null then
            raise_application_error(-20001, 'Debe ingresar una familia!');
            end if;
        end if;
      end if;
    end if;
  end if;   
end if;

  
  

if p_remi_codi is not null then
  
    for x in c_remi_deta loop
      v_prod_codi_alfa  := x.prod_codi_alfa;
      v_prod_codi       := x.prod_codi;
      v_prod_desc       := x.coba_desc;
      v_prod_desc_orig  := x.coba_desc;
      v_prod_impu_codi  := x.prod_impu_codi;
      

                        
          pp_devu_prec_nuev(p_prod_codi      => x.prod_codi, 
                            p_medi_codi      => x.coba_medi_codi, 
                            p_list_codi      => p_list_codi,
                            p_prec           => v_lide_prec,
                            p_lide_user_regi => v_lide_user_regi,
                            p_lide_fech_regi => v_lide_user_regi,
                            p_lide_user_modi => v_lide_user_modi,
                            p_lide_fech_modi => v_lide_fech_modi,
                            p_lide_prec_ante => v_lide_prec_ante);                 
                        
                        
      
       pp_devu_ult_cost(p_prod_codi           => x.prod_codi,
                        p_ulco_cost_mmnn      => v_ulco_cost_mmnn,
                        p_ulco_deta_movi_codi => v_ulco_deta_movi_codi);
      v_ulti_compr := v_ulco_cost_mmnn * x.coba_fact_conv;
      -- v_lide_prec       := p_devu_prec_nuev(x.prod_codi, x.coba_medi_codi, p_list_codi);
      --v_ulti_compr      := fp_devu_ult_cost(x.prod_codi)* x.coba_fact_conv;
      v_lote_codi       := fp_devu_lote_generico(x.prod_codi);
      v_cost_prom       := fa_devu_cost_prom (x.prod_codi, parameter.p_codi_peri_sgte) * x.coba_fact_conv;
      v_lide_medi_codi  := x.coba_medi_codi;
      v_medi_desc_abre  := fp_devu_unid_medi(x.coba_medi_codi);
      v_coba_codi_barr  := x.coba_codi_barr;
      
      
      if v_prod_impu_codi = parameter.p_codi_impu_exen then
        v_ulti_compr := round(v_ulti_compr,0);
        v_cost_prom  := round(v_cost_prom,0);
      elsif v_prod_impu_codi = parameter.p_codi_impu_grav5 then
        v_ulti_compr := round((v_ulti_compr + v_ulti_compr * 5 / 100),0);
        v_cost_prom  := round((v_cost_prom + v_cost_prom * 5 / 100),0);
      elsif v_prod_impu_codi = parameter.p_codi_impu_grav10 then
        v_ulti_compr := round((v_ulti_compr + v_ulti_compr * 10 / 100),0);
        v_cost_prom  := round((v_cost_prom + v_cost_prom * 10 / 100),0);
      end if;
          
      
      begin
        select m.movi_user, m.movi_fech_grab
          into p_ulti_user_modi_cost, p_ulti_fech_modi_cost
          from come_movi m
         where m.movi_codi = v_ulco_deta_movi_codi;
      exception
        when others then
          null;
      end;
 
    end loop;
  
else  
  
  if p_tipo_orde = 'D' then
   
    for x in c_prod_desc loop
      v_prod_codi_alfa  := x.prod_codi_alfa;
      v_prod_codi       := x.prod_codi;
      v_prod_desc       := x.coba_desc;
      v_prod_desc_orig  := x.coba_desc;
      v_prod_impu_codi  := x.prod_impu_codi;
      
     -- v_lide_prec       := fp_devu_prec_nuev(x.prod_codi, x.coba_medi_codi, p_list_codi);
        pp_devu_prec_nuev(p_prod_codi        => x.prod_codi, 
                            p_medi_codi      => x.coba_medi_codi, 
                            p_list_codi      => p_list_codi,
                            p_prec           => v_lide_prec,
                            p_lide_user_regi => v_lide_user_regi,
                            p_lide_fech_regi => v_lide_user_regi,
                            p_lide_user_modi => v_lide_user_modi,
                            p_lide_fech_modi => v_lide_fech_modi,
                            p_lide_prec_ante => v_lide_prec_ante);       
                        
       pp_devu_ult_cost(p_prod_codi           => x.prod_codi,
                        p_ulco_cost_mmnn      => v_ulco_cost_mmnn,
                        p_ulco_deta_movi_codi => v_ulco_deta_movi_codi);
      
      v_ulti_compr := v_ulco_cost_mmnn * x.coba_fact_conv;
     -- v_ulti_compr      := fp_devu_ult_cost(x.prod_codi)* x.coba_fact_conv;
      
      v_lote_codi       := fp_devu_lote_generico(x.prod_codi);
      
      v_cost_prom       := /*fa_devu_cost_prom_lote*/ fa_devu_cost_prom (/*v_lote_codi*/ x.prod_codi, parameter.p_codi_peri_sgte) * x.coba_fact_conv;
      
      v_lide_medi_codi  := x.coba_medi_codi;
      v_medi_desc_abre  := fp_devu_unid_medi(x.coba_medi_codi);
      v_coba_codi_barr:= x.coba_codi_barr;
      
      
      if v_prod_impu_codi = parameter.p_codi_impu_exen then
        v_ulti_compr := round(v_ulti_compr,0);
        v_cost_prom  := round(v_cost_prom,0);
      elsif v_prod_impu_codi = parameter.p_codi_impu_grav5 then
        v_ulti_compr := round((v_ulti_compr + v_ulti_compr * 5 / 100),0);
        v_cost_prom  := round((v_cost_prom + v_cost_prom * 5 / 100),0);
      elsif v_prod_impu_codi = parameter.p_codi_impu_grav10 then
        v_ulti_compr := round((v_ulti_compr + v_ulti_compr * 10 / 100),0);
        v_cost_prom  := round((v_cost_prom + v_cost_prom * 10 / 100),0);
      end if;
 
         
      begin
        select m.movi_user, TO_CHAR(m.movi_fech_grab, 'DD/MM/YYYY HH24:MI:SS')
          into p_ulti_user_modi_cost, p_ulti_fech_modi_cost
          from come_movi m
         where m.movi_codi = v_ulco_deta_movi_codi;
      exception
        when others then
          null;
      end;
      
      if p_porc_aume= 0 then
          v_porc_aume := 100;
      elsif  p_porc_aume is null then  
        v_porc_aume := null;
      elsif v_porc_aume < 0 then
          v_porc_aume := null;
        end if;
     --- raise_application_error(-20001, v_ulco_deta_movi_codi||p_ulti_user_modi_cost);
    --  v_porc_aume := p_porc_aume;
    
 --   raise_application_error(-20001, v_porc_aume||'**'||p_porc_aume );
      v_porc_aume_ante  := v_porc_aume;
      
        
        if p_tipo_actu = 'P'  then ---precio actual
       --    v_prec_nuev       := fp_calcular_precio(p_tipo_actu, v_ulti_compr, v_cost_prom,  v_lide_prec, nvl(p_porc_aume,0));
       
    /*           raise_application_Error(-20001,p_tipo_actu||'-'||v_ulti_compr||'-'||v_cost_prom||'-'||v_lide_prec
                                               ||'-'||v_porc_aume||'-'||v_lide_prec ||'-'||p_porc_iva||'-'||p_redondeo
                                               ||'-'||v_aux_prec_nuev||'-'||v_cost_prom||'-'||v_ulti_compr);     
*/         v_prec_nuev       :=  fp_calcular_precio(p_tipo               => p_tipo_actu,
                                                    p_ulti_compr         => v_ulti_compr,
                                                    p_cost_prom          => v_cost_prom,
                                                    p_prec_actu          => v_lide_prec,
                                                    p_porc_aume          => v_porc_aume,
                                                    pd_lide_prec         => v_lide_prec,
                                                    p_porc_iva           => p_porc_iva,
                                                    p_redondeo           => p_redondeo,
                                                    pd_aux_prec_nuev     => v_aux_prec_nuev,
                                                    pd_cost_prom         => v_cost_prom,
                                                    pd_ulti_compr        => v_ulti_compr);
           
           
           v_prec_nuev_ante  := v_prec_nuev;
           
        elsif p_tipo_actu = 'C'    then  ---costo promedio
          -- v_prec_nuev := fp_calcular_precio(p_tipo_actu, v_ulti_compr, v_cost_prom,  v_lide_prec, nvl(p_porc_aume,0));
             v_prec_nuev     :=  fp_calcular_precio(p_tipo               => p_tipo_actu,
                                                    p_ulti_compr         => v_ulti_compr,
                                                    p_cost_prom          => v_cost_prom,
                                                    p_prec_actu          => v_lide_prec,
                                                    p_porc_aume          => v_porc_aume,
                                                    pd_lide_prec         => v_lide_prec,
                                                    p_porc_iva           => p_porc_iva,
                                                    p_redondeo           => p_redondeo,
                                                    pd_aux_prec_nuev     => v_aux_prec_nuev,
                                                    pd_cost_prom         => v_cost_prom,
                                                    pd_ulti_compr        => v_ulti_compr);
           
           v_prec_nuev_ante  := v_prec_nuev;
        elsif p_tipo_actu = 'U'    then ---costo ultima compra
          --v_prec_nuev := fp_calcular_precio(p_tipo_actu, v_ulti_compr, v_cost_prom,  v_lide_prec, nvl(p_porc_aume,0));
          v_prec_nuev        :=  fp_calcular_precio(p_tipo               => p_tipo_actu,
                                                    p_ulti_compr         => v_ulti_compr,
                                                    p_cost_prom          => v_cost_prom,
                                                    p_prec_actu          => v_lide_prec,
                                                    p_porc_aume          => v_porc_aume,
                                                    pd_lide_prec         => v_lide_prec,
                                                    p_porc_iva           => p_porc_iva,
                                                    p_redondeo           => p_redondeo,
                                                    pd_aux_prec_nuev     => v_aux_prec_nuev,
                                                    pd_cost_prom         => v_cost_prom,
                                                    pd_ulti_compr        => v_ulti_compr);
        
          v_prec_nuev_ante  := v_prec_nuev;
        end if; 
        
      ---------------------porcentaje 
      
        
        if v_porc_aume <> v_porc_aume_ante then ---hubo un cambio de valor
            ---calculamos el % de aumento
            if(p_tipo_actu = 'U') then --para ultimo costo
              v_prec_nuev      := v_ulti_compr*((v_porc_aume/100)   +1);
              v_porc_aume_ante := v_porc_aume;
              v_prec_nuev_ante := v_prec_nuev;
            elsif (p_tipo_actu = 'C') then ---para costo promedio
              v_prec_nuev      := v_cost_prom*((v_porc_aume/100)   +1);
              v_porc_aume_ante := v_porc_aume;
              v_prec_nuev_ante := v_prec_nuev;
           elsif (p_tipo_actu = 'P') then --para precio
              v_prec_nuev      := v_lide_prec*((v_porc_aume/100)   +1);
              v_porc_aume_ante := v_porc_aume;
              v_prec_nuev_ante := v_prec_nuev;
           end if;  
        else
          null;
          
        end if;

 -----------------------------precio nuevo 
 
         if v_prec_nuev <> v_lide_prec then ---hubo un cambio de valor
            ---calculamos el % de aumento
            if(p_tipo_actu = 'U') then --para ultimo costo      
              if v_ulti_compr is null then
                v_porc_aume  :=     round(((v_prec_nuev - v_ulti_compr) *100/v_ulti_compr),2);
              else
                v_porc_aume := null;
              end if; 
              v_prec_nuev_ante := v_prec_nuev;
              v_porc_aume_ante := v_porc_aume;
            elsif (p_tipo_actu = 'C') then ---para costo promedio
              
              if v_cost_prom > 0 then
               v_porc_aume  :=     round(((v_prec_nuev - v_cost_prom) *100/v_cost_prom),2);
              else
               v_porc_aume  := null;
              end if; 
              v_prec_nuev_ante := v_prec_nuev;
              v_porc_aume_ante := v_porc_aume;
            elsif (p_tipo_actu = 'P') then --para precio
              if v_lide_prec > 0 then
               v_porc_aume  :=     round(((v_prec_nuev - v_lide_prec) *100/v_lide_prec),2);
              else
               v_porc_aume  := null;
              end if; 
              v_prec_nuev_ante := v_prec_nuev;
              v_porc_aume_ante := v_porc_aume;
            end if; 
        else
          null;
          
        end if; 
            v_vari_prec :=round(nvl(v_prec_nuev,0) -nvl( v_lide_prec,0));   
     
 if v_porc_aume = 0 then
    
     v_porc_aume := null;
  elsif nvl(v_porc_aume,0) < 0 then
    v_porc_aume := null;
  end if;

    if v_prec_nuev = 0 then
      v_prec_nuev := null;
      
    end if;
    if v_vari_prec = 0 then
      v_porc_aume := 100;
    end if;
    
  if p_cant_deci = 0 then
    v_ulti_compr     := to_char(v_ulti_compr,'999g999g999g999');
    v_cost_prom      := to_char(v_cost_prom,'999g999g999g999');
    v_lide_prec_ante := to_char(v_lide_prec_ante,'999g999g999g999');
    v_lide_prec      := to_char(v_lide_prec,'999g999g999g999');
    v_vari_prec      := to_char(v_vari_prec,'999g999g999g999');
  else
     v_ulti_compr     := to_char(v_ulti_compr,'999g999g999g999d00');
    v_cost_prom      := to_char(v_cost_prom,'999g999g999g999d00');
    v_lide_prec_ante := to_char(v_lide_prec_ante,'999g999g999g999d00');
    v_lide_prec      := to_char(v_lide_prec,'999g999g999g999d00');
    v_vari_prec      := to_char(v_vari_prec,'999g999g999g999d00');
  end if;
  
  
    
    apex_collection.add_member(p_collection_name => 'DETALLE',
                               P_C001            => v_prod_codi_alfa,
                               P_C002            => v_prod_codi,
                               P_C003            => v_prod_desc,
                               P_C004            => v_prod_desc_orig,
                               P_C005            => v_prod_impu_codi,
                               P_C006            => v_lide_prec,
                               P_C007            => v_ulti_compr,
                               P_C008            => v_lote_codi,
                               P_C009            => v_cost_prom,
                               P_C010            => v_lide_medi_codi,
                               P_C011            => v_medi_desc_abre,
                               P_C012            => v_coba_codi_barr,
                               P_C013            => v_lide_prec_ante,
                               P_C014            => v_lide_user_regi,
                               P_C015            => v_lide_fech_regi,
                               P_C016            => v_lide_user_modi,
                               P_C017            => v_lide_fech_modi,
                               P_C018            => v_ulco_cost_mmnn,
                               P_C019            => v_ulco_deta_movi_codi,
                               P_C020            => v_prec_nuev_ante,
                               P_C021            => v_prec_nuev,
                               P_C022            => v_porc_aume,
                               P_C023            => v_porc_aume_ante,
                               P_C024            => v_aux_prec_nuev,
                               p_c025            => v_vari_prec,
                               p_c026            => p_list_codi,
                               p_c027            => p_moneda);



                  
  end loop;
  

  else
    
    for x in c_prod_codi loop
      v_prod_codi_alfa  := x.prod_codi_alfa;
      v_prod_codi       := x.prod_codi;
      v_prod_desc       := x.coba_desc;
      v_prod_desc_orig  := x.coba_desc;
      v_prod_impu_codi  := x.prod_impu_codi;
          pp_devu_prec_nuev(p_prod_codi      =>x.prod_codi, 
                            p_medi_codi      =>x.coba_medi_codi, 
                            p_list_codi      =>p_list_codi,
                            p_prec           =>v_lide_prec,
                            p_lide_user_regi =>v_lide_user_regi,
                            p_lide_fech_regi =>v_lide_user_regi,
                            p_lide_user_modi => v_lide_user_modi,
                            p_lide_fech_modi =>v_lide_fech_modi,
                            p_lide_prec_ante =>v_lide_prec_ante);       
      --v_lide_prec       := fp_devu_prec_nuev(x.prod_codi, x.coba_medi_codi, p_list_codi);
      --v_ulti_compr      := fp_devu_ult_cost(x.prod_codi)* x.coba_fact_conv;
       pp_devu_ult_cost(p_prod_codi           => x.prod_codi,
                        p_ulco_cost_mmnn      => v_ulco_cost_mmnn,
                        p_ulco_deta_movi_codi => v_ulco_deta_movi_codi);
      v_ulti_compr := v_ulco_cost_mmnn * x.coba_fact_conv;
      
      v_lote_codi       := fp_devu_lote_generico(x.prod_codi);
      v_cost_prom       := /*fa_devu_cost_prom_lote*/  fa_devu_cost_prom(/*v_lote_codi*/ x.prod_codi, parameter.p_codi_peri_sgte) * x.coba_fact_conv;
      v_lide_medi_codi  := x.coba_medi_codi;
      v_medi_desc_abre  := fp_devu_unid_medi(x.coba_medi_codi);
      v_coba_codi_barr:= x.coba_codi_barr;
      
      
      if v_prod_impu_codi = parameter.p_codi_impu_exen then
        v_ulti_compr := round(v_ulti_compr,0);
        v_cost_prom  := round(v_cost_prom,0);
      elsif v_prod_impu_codi = parameter.p_codi_impu_grav5 then
        v_ulti_compr := round((v_ulti_compr + v_ulti_compr * 5 / 100),0);
        v_cost_prom  := round((v_cost_prom + v_cost_prom * 5 / 100),0);
      elsif v_prod_impu_codi = parameter.p_codi_impu_grav10 then
        v_ulti_compr := round((v_ulti_compr + v_ulti_compr * 10 / 100),0);
        v_cost_prom  := round((v_cost_prom + v_cost_prom * 10 / 100),0);
      end if;
       
      begin
        select m.movi_user, TO_CHAR(m.movi_fech_grab, 'DD/MM/YYYY HH24:MI:SS')
          into p_ulti_user_modi_cost, p_ulti_fech_modi_cost
          from come_movi m
         where m.movi_codi = v_ulco_deta_movi_codi;
        
      exception
        when others then
          null;
      end;
      
        if p_porc_aume = 0 then
    
           v_porc_aume := 100;
        elsif nvl(v_porc_aume,0) < 0 then
          v_porc_aume := null;
        end if;
     --- raise_application_error(-20001, v_ulco_deta_movi_codi||p_ulti_user_modi_cost);
     -- v_porc_aume := p_porc_aume;
      v_porc_aume_ante  := v_porc_aume;
      
      
    --  v_porc_aume := nvl(p_porc_aume,0);
      v_porc_aume_ante  := v_porc_aume;
      

        if p_tipo_actu = 'P'  then ---precio actual
            v_prec_nuev := fp_calcular_precio(p_tipo               => p_tipo_actu,
                                              p_ulti_compr         => v_ulti_compr,
                                              p_cost_prom          => v_cost_prom,
                                              p_prec_actu          => v_lide_prec,
                                              p_porc_aume          => nvl(p_porc_aume,0),
                                              pd_lide_prec         => v_lide_prec,
                                              p_porc_iva           => p_porc_iva,
                                              p_redondeo           => p_redondeo,
                                              pd_aux_prec_nuev     => v_aux_prec_nuev,
                                              pd_cost_prom         => v_cost_prom,
                                              pd_ulti_compr        => v_ulti_compr);
                                    
           --v_prec_nuev       := fp_calcular_precio(p_tipo_actu, v_ulti_compr, v_cost_prom,  v_lide_prec, nvl(p_porc_aume,0));
           v_prec_nuev_ante  := v_prec_nuev;
      
        elsif p_tipo_actu = 'C'    then  ---costo promedio
           --v_prec_nuev := fp_calcular_precio(p_tipo_actu, v_ulti_compr, v_cost_prom,  v_lide_prec, nvl(p_porc_aume,0));
            v_prec_nuev := fp_calcular_precio(p_tipo               => p_tipo_actu,
                                              p_ulti_compr         => v_ulti_compr,
                                              p_cost_prom          => v_cost_prom,
                                              p_prec_actu          => v_lide_prec,
                                              p_porc_aume          => p_porc_aume,
                                              pd_lide_prec         => v_lide_prec,
                                              p_porc_iva           => p_porc_iva,
                                              p_redondeo           => p_redondeo,
                                              pd_aux_prec_nuev     => v_aux_prec_nuev,
                                              pd_cost_prom         => v_cost_prom,
                                              pd_ulti_compr        => v_ulti_compr);
           v_prec_nuev_ante  := v_prec_nuev;
        elsif p_tipo_actu = 'U'    then ---costo ultima compra
         -- v_prec_nuev := fp_calcular_precio(p_tipo_actu, v_ulti_compr, v_cost_prom,  v_lide_prec, nvl(p_porc_aume,0));
            v_prec_nuev := fp_calcular_precio(p_tipo               => p_tipo_actu,
                                              p_ulti_compr         => v_ulti_compr,
                                              p_cost_prom          => v_cost_prom,
                                              p_prec_actu          => v_lide_prec,
                                              p_porc_aume          => p_porc_aume,
                                              pd_lide_prec         => v_lide_prec,
                                              p_porc_iva           => p_porc_iva,
                                              p_redondeo           => p_redondeo,
                                              pd_aux_prec_nuev     => v_aux_prec_nuev,
                                              pd_cost_prom         => v_cost_prom,
                                              pd_ulti_compr        => v_ulti_compr);
          v_prec_nuev_ante  := v_prec_nuev;
        end if; 
   
         if nvl(v_prec_nuev,0) <> nvl(v_prec_nuev_ante,0) then ---hubo un cambio de valor
            ---calculamos el % de aumento
            if(p_tipo_actu = 'U') then --para ultimo costo      
              if v_ulti_compr is null then
                v_porc_aume  :=     round(((v_prec_nuev - v_ulti_compr) *100/v_ulti_compr),2);
              else
                v_porc_aume := null;
              end if; 
              v_prec_nuev_ante := v_prec_nuev;
              v_porc_aume_ante := v_porc_aume;
            elsif (p_tipo_actu = 'C') then ---para costo promedio
              
              if nvl(v_cost_prom,0) > 0 then
               v_porc_aume  :=     round(((v_prec_nuev - v_cost_prom) *100/v_cost_prom),2);
              else
               v_porc_aume  := null;
              end if; 
              v_prec_nuev_ante := v_prec_nuev;
              v_porc_aume_ante := v_porc_aume;
            elsif (p_tipo_actu = 'P') then --para precio
              if nvl(v_lide_prec,0) > 0 then
               v_porc_aume  :=     round(((v_prec_nuev - v_lide_prec) *100/v_lide_prec),2);
              else
               v_porc_aume  := null;
              end if; 
              v_prec_nuev_ante := v_prec_nuev;
              v_porc_aume_ante := v_porc_aume;
            end if; 
        else
          null;
          
        end if;     
             v_vari_prec :=round(nvl(v_prec_nuev,0) -nvl( v_lide_prec,0));   
             
    if v_porc_aume = 0 then
    
       v_porc_aume := 100;
    elsif nvl(v_porc_aume,0) < 0 then
      v_porc_aume := null;
    end if;
    if v_prec_nuev = 0 then
      v_prec_nuev := null;
      
    end if;
    if v_vari_prec = 0 then
      v_porc_aume := 100;
    end if;           
             
   if p_cant_deci = 0 then
    v_ulti_compr     := to_char(v_ulti_compr,'999g999g999g999');
    v_cost_prom      := to_char(v_cost_prom,'999g999g999g999');
    v_lide_prec_ante := to_char(v_lide_prec_ante,'999g999g999g999');
    v_lide_prec      := to_char(v_lide_prec,'999g999g999g999');
    v_vari_prec      := to_char(v_vari_prec,'999g999g999g999');
  else
     v_ulti_compr     := to_char(v_ulti_compr,'999g999g999g999d00');
    v_cost_prom      := to_char(v_cost_prom,'999g999g999g999d00');
    v_lide_prec_ante := to_char(v_lide_prec_ante,'999g999g999g999d00');
    v_lide_prec      := to_char(v_lide_prec,'999g999g999g999d00');
    v_vari_prec      := to_char(v_vari_prec,'999g999g999g999d00');
  end if;
  
  
  

    apex_collection.add_member(p_collection_name => 'DETALLE',
                               P_C001            => v_prod_codi_alfa,
                               P_C002            => v_prod_codi,
                               P_C003            => v_prod_desc,
                               P_C004            => v_prod_desc_orig,
                               P_C005            => v_prod_impu_codi,
                               P_C006            => v_lide_prec,
                               P_C007            => v_ulti_compr,
                               P_C008            => v_lote_codi,
                               P_C009            => v_cost_prom,
                               P_C010            => v_lide_medi_codi,
                               P_C011            => v_medi_desc_abre,
                               P_C012            => v_coba_codi_barr,
                               P_C013            => v_lide_prec_ante,
                               P_C014            => v_lide_user_regi,
                               P_C015            => v_lide_fech_regi,
                               P_C016            => v_lide_user_modi,
                               P_C017            => v_lide_fech_modi,
                               P_C018            => v_ulco_cost_mmnn,
                               P_C019            => v_ulco_deta_movi_codi,
                               P_C020            => v_prec_nuev_ante,
                               P_C021            => v_prec_nuev,
                               P_C022            => v_porc_aume,
                               P_C023            => v_porc_aume_ante,
                               P_C024            => v_aux_prec_nuev,
                               p_c025            => v_vari_prec,
                               p_c026            =>  p_list_codi,
                               p_c027            =>  p_moneda);
        
        
    end loop;
  end if;
  
end if;



p_ulti_user_modi := v_lide_user_modi;
p_ulti_fech_modi :=to_Char(v_lide_fech_modi, 'DD/MM/YYYY HH24:MI:SS') ;


end pp_carga_datos;

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
                                 p_tipo_actu in varchar2,
                                 p_cant_deci in number)is

 v_seq_id varchar2(20);
 vi_porc_aume varchar2(200);
 
  vc_prec_nuev       varchar2(200);            
  vc_porc_aume_ante  varchar2(200);
  vc_prec_nuev_ante  varchar2(200);
  vc_prec_variacion  varchar2(200);
  vi_ulti_compr      varchar2(200);
  vi_cost_prom       varchar2(200);
  vi_lide_prec       varchar2(200);
  vi_porc_aume_ante  varchar2(200);
 begin
   
  v_seq_id := replace(p_seq_id,'f02_');
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

    vi_porc_aume := p_valor;

       if nvl(vi_porc_aume,0) <> nvl(vi_porc_aume_ante,0) then ---hubo un cambio de valor
          ---calculamos el % de aumento
          if(p_tipo_actu = 'U') then --para ultimo costo
            vc_prec_nuev      := vi_ulti_compr*((vi_porc_aume/100)   +1);
            vc_porc_aume_ante := vi_porc_aume;
            vc_prec_nuev_ante := vc_prec_nuev;
          elsif (p_tipo_actu = 'C') then ---para costo promedio
            vc_prec_nuev      := vi_cost_prom*((vi_porc_aume/100)   +1);
            vc_porc_aume_ante := vi_porc_aume;
            vc_prec_nuev_ante := vc_prec_nuev;
         elsif (p_tipo_actu = 'P') then --para precio
            vc_prec_nuev      := vi_lide_prec*((vi_porc_aume/100)   +1);
            vc_porc_aume_ante := vi_porc_aume;
            vc_prec_nuev_ante := vc_prec_nuev;
         end if;  
      else
        null;
        
      end if;
      
       vc_prec_variacion :=round(nvl(vc_prec_nuev,0) -nvl(vi_lide_prec,0));   
       
   if p_cant_deci = 0 then
    vc_prec_variacion     := to_char(vc_prec_variacion,'999g999g999g999');
  
  else
    vc_prec_variacion     := to_char(vc_prec_variacion,'999g999g999g999');

  end if;

      APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 22,
                                                    P_ATTR_VALUE      => vi_porc_aume);
                                                    
                                                    
      APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 21,
                                                    P_ATTR_VALUE      => vc_prec_nuev);
                                                    
      APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 20,
                                                    P_ATTR_VALUE      => vc_prec_nuev_ante);
                                                    
       APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 23,
                                                    P_ATTR_VALUE      => vc_porc_aume_ante);
                                                    
        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 25,
                                                    P_ATTR_VALUE      => vc_prec_variacion);                                                                                                                                                                                         


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
                                                    P_ATTR_VALUE      => nvl(vc_porc_aume,100));                                              
                                                                                                                                                                                                                                            
       APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 23,
                                                    P_ATTR_VALUE      => nvl(vc_porc_aume_ante,100));
                                                    
                                                    
       APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                                    P_SEQ             => v_seq_id,
                                                    P_ATTR_NUMBER     => 20,
                                                    P_ATTR_VALUE      => vc_prec_nuev_ante);                                             

 end pp_editar_monto;
 
 
 
procedure pp_actualizar_registro is

cursor detalle is 
    select c001 prod_codi_alfa,
           c002 prod_codi,
           c003 prod_desc,
           c004 prod_desc_orig,
           c005 prod_impu_codi,
           --c006 lide_prec,
           REGEXP_REPLACE(c006, '[.,]', '')lide_prec,
           REGEXP_REPLACE(c007, '[.,]', '')ulti_compr,
           --c007 ulti_compr,
           c008 lote_codi,
           --c009 cost_prom,
           REGEXP_REPLACE(c009, '[.,]', '')cost_prom,
           c010 lide_medi_codi,
           c011 medi_desc_abre,
           c012 coba_codi_barr,
          -- c013 lide_prec_ante,
           REGEXP_REPLACE(c013, '[.,]', '')lide_prec_ante,
           c014 lide_user_regi,
           c015 lide_fech_regi,
           c016 lide_user_modi,
           c017 lide_fech_modi,
           c018 ulco_cost_mmnn,
           c019 ulco_deta_movi_codi,
           c020 prec_nuev_ante,
           c021 prec_nuev,
           c022 porc_aume,
           c023 porc_aume_ante,
           c024 aux_prec_nuev,
           ---c025 vari_prec,
            REGEXP_REPLACE(c025, '[.,]', '')vari_prec,
           c026 bsel_list_codi,
           c027 bsel_mone_codi

      from apex_collections
     where collection_name = 'DETALLE';
 
v_nume_item number;

    
begin

for bdatos in detalle loop
    if(nvl(bdatos.prec_nuev,0) <> nvl(bdatos.lide_prec,0)) and bdatos.prec_nuev is not null then
      if bdatos.lide_prec is null and (bdatos.prec_nuev is not null and bdatos.prec_nuev > 0)then
        begin 
        insert into come_list_prec_deta
          (lide_list_codi,
           lide_prod_codi,
           lide_coba_codi_barr,
           lide_prec,
           lide_prec_ante,
           lide_mone_codi,
           lide_medi_codi,
           lide_user_regi,
           lide_fech_regi,
           lide_base)
        values
          (bdatos.bsel_list_codi,
           bdatos.prod_codi,
           bdatos.coba_codi_barr,
           bdatos.prec_nuev,
           bdatos.lide_prec,
           bdatos.bsel_mone_codi,
           bdatos.lide_medi_codi,
           gen_user,
           sysdate,
           1);
           exception when others then
             RAISE_aPPLICATION_eRROR(-20001,'nuevo'||bdatos.bsel_list_codi||'/'||
           bdatos.prod_codi||'/'||
           bdatos.coba_codi_barr||'/'||
           bdatos.prec_nuev||'/'||
           bdatos.lide_prec||'/'||
           bdatos.bsel_mone_codi||'/'||
           bdatos.lide_medi_codi);
             end;
      
      else
        begin
        update come_list_prec_deta
           set lide_prec      = bdatos.prec_nuev,
               lide_prec_ante = bdatos.lide_prec,
               lide_mone_codi = bdatos.bsel_mone_codi,
               lide_user_modi = gen_user,
               lide_fech_modi = sysdate
         where lide_prod_codi = bdatos.prod_codi
           and lide_list_codi = bdatos.bsel_list_codi
           and lide_medi_codi = bdatos.lide_medi_codi;

      exception when others then
             RAISE_aPPLICATION_eRROR(-20001,'ediatar'||bdatos.bsel_list_codi||'/'||
           bdatos.prod_codi||'/'||
           bdatos.coba_codi_barr||'/'||
           bdatos.prec_nuev||'/'||
           bdatos.lide_prec||'/'||
           bdatos.bsel_mone_codi||'/'||
           bdatos.lide_medi_codi);
             end;
      end if;
    end if;
    
    ---Modificaci?n de descripcion del producto----
      if bdatos.prod_desc_orig <> bdatos.prod_desc then
        begin
          select coba_nume_item
            into v_nume_item
            from come_prod_coba_deta
           where coba_prod_codi = bdatos.prod_codi
             and coba_codi_barr = bdatos.coba_codi_barr; 
        end;
        if v_nume_item = 1 then
          update come_prod
             set prod_desc      = bdatos.prod_desc,
                 prod_user_modi = gen_user,
                 prod_fech_modi = sysdate
           where prod_codi = bdatos.prod_codi;
        end if;
        
        update come_prod_coba_deta
           set coba_desc      = bdatos.prod_desc,
               coba_user_modi = gen_user,
               coba_fech_modi = sysdate
         where coba_prod_codi = bdatos.prod_codi
         and coba_codi_barr = bdatos.coba_codi_barr;
      end if;

  end loop;

 apex_collection.create_or_truncate_collection(p_collection_name =>'DETALLE');

end pp_actualizar_registro;

end I010314;
