
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010292" is

cursor c_dato is
    select    c001 prod_codi_alfa,                             
              c002 prod_codi,
              c003 prod_desc,
              c004 lote_codi,
              c005 coba_medi_codi,
              c006 medi_desc_abre,
              c007 coba_codi_bar,
              c009 indi_fact_nega
      from apex_collections a
     where collection_name = 'BDETALLE';
 
function fp_devu_lote_generico (p_prod_codi in number) return number is
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
    raise_application_error(-20001,'Lote de producto '||p_prod_codi||' no encontrado');
end fp_devu_lote_generico;

Function fp_devu_unid_medi(p_codi in number) return varchar2 IS
v_desc varchar2(4);
BEGIN
  select  medi_desc_abre
  into  v_desc
  from come_unid_medi
  where medi_codi = p_codi;

  return v_desc;
  
Exception 
	 when no_data_found then
	    return null;
	    
END fp_devu_unid_medi;








procedure pp_carga_datos(p_prod_clas1 in number,
                         p_prod_clas2 in number,
                         p_marc_codi  in number,
                         p_medi_codi  in number) is
  v_indi varchar2(1);
  
  cursor c_prod is
    select p.prod_codi,
           p.prod_codi_alfa,
           p.prod_desc,
           d.coba_medi_codi,
           d.coba_codi_barr,
           d.coba_fact_conv,
           p.prod_indi_fact_nega
      from come_prod p, come_prod_coba_deta d
     where p.prod_codi = d.coba_prod_codi
       and (prod_clas1 = p_prod_clas1 or p_prod_clas1 is null)
       and (prod_clas2 = p_prod_clas2 or p_prod_clas2 is null)
       and (d.coba_medi_codi = p_medi_codi or p_medi_codi is null)
       and (prod_marc_codi = p_marc_codi or p_marc_codi is null)
       and nvl(p.prod_indi_inac, 'N') = 'N'
     order by 2;
     p_ind_validar_prod varchar2(2);
begin
  --parameter.p_ind_validar_prod := 'N';
  v_indi := 'N';
  
   apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
  for x in c_prod loop
    v_indi := 'S';
  
  
    
    
       apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => x.prod_codi_alfa,                             
                                   p_c002            => x.prod_codi,
                                   p_c003            => x.prod_desc,
                                   p_c004            => fp_devu_lote_generico(x.prod_codi),
                                   p_c005            => x.coba_medi_codi,
                                   p_c006            => fp_devu_unid_medi(x.coba_medi_codi),
                                   p_c007            => x.coba_codi_barr,
                                   p_c008            => fa_dev_stoc_actu_tota(x.prod_codi),
                                   p_c009            => nvl(x.prod_indi_fact_nega, 'S'));
  end loop;
  
  if v_indi = 'S' then
    p_ind_validar_prod := 'S';
  else
    raise_application_error(-20001,'No existen registros para el criterio de seleccion');
  end if;
  
end pp_carga_datos;



procedure pp_actualizar_registro is
begin
--raise_application_error(-20001,'aaaa');


 FOR dato in c_dato loop
   if dato.prod_codi is not null then
      update come_prod
         set prod_indi_fact_nega = nvl(dato.indi_fact_nega, 'S')
       where prod_codi =dato.prod_codi;
   end if;
    
  end loop;
exception
  when others then
    raise_application_error(-20001,sqlerrm);
end pp_actualizar_registro;


end I010292;
