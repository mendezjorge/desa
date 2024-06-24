
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020359" is

  -- Private type declarations
  
   type r_parameter is record(
    p_empr_codi                number := 1,
    p_indi_most_mens_sali varchar2(2) := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_most_mens_sali')))) );

  parameter r_parameter;



  procedure pp_valida(p_noca_vehi_codi in number,
                      p_noca_clpr_codi in number,
                      p_noca_sucu_nume_item in number,
                      p_noca_nume in number,
                      p_noca_obse in varchar2,
                      p_noca_fech_emis in date,
                      p_noca_fech_real in date,
                      p_indi_oper in varchar2) is

  v_count     number := 0;
  v_ortr_nume varchar2(200);
  v_cant      number := 0;
    
 cursor c_ortr is
  select o.ortr_nume
    from come_orde_trab o, come_vehi v
    where ortr_esta = 'P'
    and o.ortr_vehi_codi = v.vehi_codi
    and o.ortr_clpr_codi = p_noca_clpr_codi
    and (p_noca_sucu_nume_item is null or o.ortr_clpr_sucu_nume_item = p_noca_sucu_nume_item)
   -- and v.vehi_iden  = p_vehi_iden
   and v.vehi_codi=p_noca_vehi_codi;
  
begin
  
  if p_noca_nume is null then 
    raise_application_error(-20001,'Debe ingresar Nro de Nota de Cancelaci?n.');
  end if;

  if p_noca_obse is null then
   raise_application_error(-20001,'Debe ingresar la Observaci?n de Nota de Cancelaci?n.');
  end if;
  
  if p_noca_fech_emis is null then
   raise_application_error(-20001,'Debe ingresar la fecha de emisi?n de la Nota de Cancelaci?n.');
  end if;

  if p_noca_fech_real is null then
   raise_application_error(-20001,'Debe ingresar la fecha de Vencimiento de Pre-aviso.');
  end if;
    if p_noca_vehi_codi is null then
   raise_application_error(-20001,'Debe ingresar el identificador.');
  end if;
  
  if p_indi_oper <> 'U' then
    select count(*)
      into v_count
      from come_soli_nota_canc
     where noca_vehi_codi = p_noca_vehi_codi
       and nvl(noca_esta,'P') <> 'L';
    
    if v_count > 0 then
      raise_application_error(-20001,'El veh?culo esta relacionado a una Nota de Cancelaci?n Pendiente o Autorizada.');
    end if;
  end if;
  
  for x in c_ortr loop
    v_ortr_nume := v_ortr_nume||x.ortr_nume||' - ';
    v_cant := v_cant + 1;
    
    if v_cant > 9 then
     exit;
    end if;
  end loop;

  if v_ortr_nume is not null then
    raise_application_error(-20001,'No puede realizar la Nota de Cancelaci?n porque existen '||v_ortr_nume||' OT en estado pendiente asignados al cliente.');
  end if;
  
exception
  when no_data_found then
    null;
end pp_valida;

PROCEDURE pp_muestra_clie(p_clpr_codi_alte in number, 
                          p_clpr_codi out number,
                          p_clpr_desc out varchar2,
                          p_clpr_clie_clas1_codi out number) IS
begin
  select clpr_desc, clpr_clie_clas1_codi,clpr_codi
    into p_clpr_desc, p_clpr_clie_clas1_codi,p_clpr_codi
    from come_clie_prov
   where clpr_codi_alte = p_clpr_codi_alte
     and clpr_indi_clie_prov = 'C';
  
Exception
   When no_data_found then
     --p_clpr_desc := null;
     --p_clpr_codi := null;
    raise_application_error(-20001,'Cliente Inexistente');    
   when others then
     raise_application_error(-20001,sqlerrm);
end pp_muestra_clie;



PROCEDURE pp_validar_sub_cuenta(p_noca_clpr_codi in number,
                                p_indi_vali_subc out varchar2) IS
  v_count number := 0;
BEGIN
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi =p_noca_clpr_codi;
     
  if v_count > 0 then
     p_indi_vali_subc := 'S';
  else
    --p_noca_sucu_nume_item := null;
    --p_sucu_desc := null;
    p_indi_vali_subc := 'N';

  end if;
END pp_validar_sub_cuenta;


PROCEDURE pp_muestra_come_clpr_sub_cuen(p_clpr_codi in number, 
                                        p_sucu_nume_item  in number, 
                                        p_sucu_desc out char, 
                                        p_sucu_tele out char) is
BEGIN
  select sucu_desc, sucu_tele
    into p_sucu_desc, p_sucu_tele
    from come_clpr_sub_cuen
   where sucu_clpr_codi = p_clpr_codi
     and sucu_nume_item = p_sucu_nume_item;
  
Exception
  when no_data_found then
     p_sucu_desc := null;     
     p_sucu_tele := null;
     raise_application_error(-20001,'Subcuenta Inexistente!');
  when others then
       raise_application_error(-20001,sqlerrm);
END pp_muestra_come_clpr_sub_cuen;


procedure pp_valida_vehi (p_deta_iden in varchar2,
                          p_noca_sucu_nume_item in number,
                          p_noca_clpr_codi in number,
                          p_noca_codi in number,
                          p_INDI_OPER in varchar2,
                          p_vehi_codi out number,
                          p_noca_deta_codi out number) is

  v_vehi_codi number;
  v_clpr_codi number;
  v_count number;
  v_deta_esta varchar2(1);
  v_vehi_esta_vehi varchar2(1);
  v_deta_codi      number;
  
begin

  select vehi_codi,
         vehi_clpr_codi,
         nvl(deta_esta, vehi_esta) deta_esta,
         vehi_esta_vehi,
         deta_codi
    into v_vehi_codi,
         v_clpr_codi,
         v_deta_esta,
         v_vehi_esta_vehi,
         v_deta_codi
    from come_marc_vehi,
         come_vehi,
         come_soli_serv_anex_deta
   where deta_vehi_codi = vehi_codi
     and vehi_mave_codi = mave_codi(+)
     and nvl(deta_esta, vehi_esta) = 'I'
     and nvl(vehi_esta_vehi, 'A') <> 'I'
     and (vehi_clpr_codi = p_noca_clpr_codi or p_noca_clpr_codi is null)
     and (vehi_clpr_sucu_nume_item = p_noca_sucu_nume_item or p_noca_sucu_nume_item is null)
     and nvl(deta_iden, vehi_iden) = p_deta_iden;

    begin
      select count(*)
        into v_count
        from come_soli_nota_canc
       where noca_vehi_codi = v_vehi_codi
         and (noca_codi <> p_noca_codi or p_noca_codi is null)
         and noca_esta = 'P';
    
      if v_count > 0 then
         raise_application_error(-20001,'El veh?culo seleccionado ya est? relacionado a una Nota de Cancelaci?n.');
      end if;
    end;
  
    if p_INDI_OPER = 'I' then
      if v_clpr_codi <> p_noca_clpr_codi then
        raise_application_error(-20001,'El vehiculo no pertenece al Cliente seleccionado.');
      end if;
      if v_deta_esta <> 'I' then
        raise_application_error(-20001,'El veh?culo debe estar instalado!');
      end if;
      if v_vehi_esta_vehi = 'I' then
         raise_application_error(-20001,'El veh?culo esta Inactivo.');
      end if;
    end if;
    
    p_vehi_codi           := v_vehi_codi;
    p_noca_deta_codi      := v_deta_codi;
     
exception
  when no_data_found then
     raise_application_error(-20001,'Vehiculo inexistente.');     
end pp_valida_vehi;

PROCEDURE pp_muestra_clie_vehi(p_vehi_codi in varchar2,
                               p_vehi_nume_pate out varchar2,
                               p_vehi_mode out varchar2,
                               p_vehi_marc out varchar2,
                               p_vehi_fech_vige_inic out varchar2,
                               p_vehi_fech_vige_fini out varchar2) IS
  
  v_clpr_codi number;
  v_sose_sucu_nume_item number;
  v_count number;
  v_deta_esta varchar2(1);
  v_vehi_esta_vehi varchar2(1);
  
begin
  select --vehi_codi deta_vehi_codi, 
         vehi_clpr_codi sose_clpr_codi,
         vehi_nume_pate deta_nume_pate,
         vehi_mode deta_mode, 
         mave_desc,
         vehi_fech_vige_inic,
         vehi_fech_vige_fini,
         vehi_clpr_sucu_nume_item sose_sucu_nume_item
    into --:babmc.noca_vehi_codi,
         v_clpr_codi,
         p_vehi_nume_pate,
         p_vehi_mode,
         p_vehi_marc,
         p_vehi_fech_vige_inic,
         p_vehi_fech_vige_fini,
         v_sose_sucu_nume_item
    from come_marc_vehi,
         come_vehi
   where vehi_mave_codi = mave_codi(+)
     and vehi_codi = p_vehi_codi;
  
  /*if p_noca_clpr_codi is null then
    if v_clpr_codi is not null then
      pp_muestra_clie(v_clpr_codi, p_clpr_desc, p_clpr_codi_alte, p_clpr_clie_clas1_codi);
      p_noca_clpr_codi := v_clpr_codi;
    end if;
    
    if v_sose_sucu_nume_item is not null then
      p_noca_sucu_nume_item := v_sose_sucu_nume_item;
      pp_muestra_come_clpr_sub_cuen(p_noca_clpr_codi, 
                                    p_noca_sucu_nume_item, 
                                    p_s_sucu_desc, 
                                    p_s_sucu_tele);
    end if;
  end if;*/
  
Exception
  When no_data_found then
    raise_application_error(-20001,'Vehiculo Inexistente.');
  when too_many_rows then
     raise_application_error(-20001,'Existe m?s de un vehiculo con el Identificador seleccionado. Favor Veifique!');    
  when others then
    raise_application_error(-20001,sqlerrm);
    
end pp_muestra_clie_vehi;



procedure pp_mostrar_vehi(p_vehi_iden in varchar2,
                          p_noca_sucu_nume_item in number,
                          p_noca_clpr_codi in number,
                          p_noca_codi in number,
                          p_INDI_OPER in varchar2,
                          p_vehi_codi in out  number,
                          p_noca_deta_codi out number,
                          p_vehi_nume_pate out varchar2,
                          p_vehi_mode out varchar2,
                          p_vehi_marc out varchar2,
                          p_vehi_fech_vige_inic out varchar2,
                          p_vehi_fech_vige_fini out varchar2)
  is 
  begin
  if p_INDI_OPER = 'I' then
  if p_vehi_iden is not null then
    pp_valida_vehi (p_vehi_iden,
                    p_noca_sucu_nume_item,
                    p_noca_clpr_codi,
                    p_noca_codi,
                    p_INDI_OPER,
                    p_vehi_codi,
                    p_noca_deta_codi);

  else
    p_vehi_nume_pate:= null;
    p_vehi_mode  := null;
    p_vehi_marc := null;
    raise_application_error(-20001,'Debe ingresar el identificador del Veh?culo del Cliente seleccionado.');
  end if;
end if;

if p_vehi_codi is not null then
      pp_muestra_clie_vehi(p_vehi_codi  ,
                           p_vehi_nume_pate  ,
                           p_vehi_mode  ,
                           p_vehi_marc  ,
                           p_vehi_fech_vige_inic  ,
                           p_vehi_fech_vige_fini  );
end if;
end pp_mostrar_vehi;

procedure pp_actualizar_registro(p_ind_oper varchar2,
                                 p_noca_fech_emis varchar2,
                                 p_noca_clpr_codi varchar2,
                                 p_noca_sucu_nume_item varchar2,
                                 p_noca_deta_codi varchar2,
                                 p_noca_vehi_codi varchar2,
                                 p_noca_fech_real varchar2,
                                 p_noca_obse varchar2,
                                 p_noca_codi  number)
  is
  begin
    if p_ind_oper ='I' then
  insert into come_soli_nota_canc
  (noca_codi,
   noca_nume,
   noca_fech_emis,
   noca_clpr_codi,
   noca_sucu_nume_item,
   noca_deta_codi,
   noca_vehi_codi,
   noca_fech_real,
   noca_obse,
   noca_user_regi,
   noca_fech_regi,
   noca_base,
   noca_esta)
values
  ((select nvl(max(noca_codi), 0) + 1
	  from come_soli_nota_canc),
   (select nvl(max(noca_nume), 0) + 1
	  from come_soli_nota_canc),
   p_noca_fech_emis,
   p_noca_clpr_codi,
   p_noca_sucu_nume_item,
   p_noca_deta_codi,
   p_noca_vehi_codi,
   p_noca_fech_real,
   p_noca_obse,
   gen_user,
   sysdate,
   1,
   'P');
   
   elsif p_ind_oper ='U' then
   
   update come_soli_nota_canc
      set
          noca_fech_emis = p_noca_fech_emis,
          noca_clpr_codi = p_noca_clpr_codi,
          noca_sucu_nume_item = p_noca_sucu_nume_item,
          noca_deta_codi = p_noca_deta_codi,
          noca_vehi_codi = p_noca_vehi_codi,
          noca_fech_real = p_noca_fech_real,
          noca_obse = p_noca_obse,
          noca_user_modi = gen_user,
          noca_fech_modi = sysdate
    where noca_codi = p_noca_codi ;
    
    
   elsif p_ind_oper ='D' then
    
   delete come_soli_nota_canc
 where noca_codi = p_noca_codi;

    end if;
    end pp_actualizar_registro;


end I020359;
