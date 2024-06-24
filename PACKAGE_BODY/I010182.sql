
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010182" is

 
procedure pp_buscar_cuco_nume_padr(p_cuco_nume      in number,
                                   p_cuco_nume_padr out number,
                                   p_nivel          out number,
                                   o_cuco_desc_padr out varchar2,
                                   o_cuco_cuco_codi out number) is

  v_cant number := 1;
  v_cont number := 1;

begin
  --pl_mm('1');

  loop
    select count(*)
      into v_cant
      from come_cuen_cont cc
     where substr(cc.cuco_nume, 1, v_cont) = substr(p_cuco_nume, 1, v_cont)
       and substr(cc.cuco_nume, v_cont, 1) <> 0;
  
    if v_cant > 0 then
      v_cont := v_cont + 1;
    else
      select cc.cuco_nume, (cc.cuco_nive + 1)
        into p_cuco_nume_padr, p_nivel
        from come_cuen_cont cc
       where substr(cc.cuco_nume, 1, v_cont - 1) =
             substr(p_cuco_nume, 1, v_cont - 1)
         and substr(cc.cuco_nume, v_cont - 1, 1) <> 0
         and substr(cc.cuco_nume, v_cont, 9) = 0;
    
      v_cant := -1;
      pp_muestra_come_cuen_cont_padr(p_cuco_nume_padr,
                                     p_nivel,
                                     o_cuco_desc_padr,
                                     o_cuco_cuco_codi);
    end if;
  
    exit when v_cant = -1;
  end loop;

exception
  when no_data_found then
   null;
end;


procedure pp_muestra_come_cuen_cont_padr(p_nume in number,
                                         p_nive in number,
                                         p_desc out char,
                                         p_codi out number) is
  v_cuco_nive number;
begin

  select cuco_desc, cuco_codi, cuco_nive
    into p_desc, p_codi, v_cuco_nive
    from come_cuen_cont
   where cuco_nume = p_nume;

  if nvl(v_cuco_nive, 0) <> (p_nive) - 1 then
    raise_application_error(-20010, 'La Cuenta no corresponde al nivel seleccionado!!');
  end if;

exception
  when no_data_found then
    raise_application_error(-20010, 'Cuenta Contable Padre inexistente!');
  when others then
    raise_application_error(-20010, 'Error el momento de mostra cta. cont. padre. '||sqlcode||' - '||sqlerrm);
end;



procedure pp_muestra_come_cuen_cont_qry(p_codi in number,
                                        p_desc out char,
                                        p_nume out number) is

begin

  select cuco_desc, cuco_nume
    into p_desc, p_nume
    from come_cuen_cont
   where cuco_codi = p_codi;

exception
  when no_data_found then
    raise_application_error(-20010, 'Cuenta Contable Padre inexistente!');
  when others then
    raise_application_error(-20010, 'Error en cuenta contable Padre.');
    
end;

procedure PP_MUESTRA_COME_CUEN_FISC_QRY(p_codi in number,
                                        p_nume out char,
                                        p_desc out char) is

begin

  select cufi_nume, cufi_desc
    into p_nume, p_desc
    from come_cuen_cont_fisc
   where cufi_codi = p_codi;

exception
  when no_data_found then
    raise_application_error(-20010,'Cuenta Contable Fiscal inexistente!');
  when others then
    raise_application_error(-20010, 'Error al momento de cuenta contable fiscal');
end;


procedure pp_muestra_come_cuen_fisc(p_nume in varchar2,
                                    p_codi out number,
                                    p_desc out varchar2) is

begin

  select cufi_codi, cufi_desc
    into p_codi, p_desc
    from come_cuen_cont_fisc
   where cufi_nume = to_number(replace(ltrim(rtrim(p_nume)), '-', ''));

exception
  when no_data_found then
    raise_application_error(-20010,'Cuenta Contable Fiscal inexistente!');
  when others then
    raise_application_error(-20010, 'Error en cuenta fiscal');
end;


function fp_cnt_mascara  return varchar2 is
 v_mascara varchar2(80);
begin
  v_mascara := fa_busc_para('p_cuco_mask');
  v_mascara :=replace(v_mascara,'-','"-"');
    return v_mascara;

end;


function fp_agregar_ceros_cnt(v_nro in number, v_mascara in varchar2)
  return number is

  v_cant_digitos number := 0;

begin

  for i in 1 .. length(v_mascara) loop
    -- para saber cuantos nueves tiene la mascara
    if substr(v_mascara, i, 1) not in ('"', '-') then
      v_cant_digitos := v_cant_digitos + 1;
    end if;
  end loop;
  if length(to_char(v_nro)) < v_cant_digitos then
    -- si el tamaño de la cuenta es menor al de la mascara, completamos
    -- con ceros. por ejemplo, al multiplicar 
    -- la cuenta 1 por 1000000000 se completa con ceros
    return v_nro * to_number(rpad('1',
                                  v_cant_digitos + 1 -
                                  length(to_char(v_nro)),
                                  '0'));
  elsif length(to_char(v_nro)) = v_cant_digitos then
    return v_nro;
  else
    raise_application_error(-20010, 'Cantidad de digitos supera el maximo permitido: ' ||
          to_char(v_cant_digitos));
  end if;
end;

procedure pp_valida_nuev_cuen_cont(i_empr_codi  in number,
                                   i_nuev_cuco_nume in number) is
  v_count number;
begin

  select count(*)
    into v_count
    from come_cuen_cont
   where cuco_empr_codi = i_empr_codi
     and cuco_nume = i_nuev_cuco_nume;

  if v_count > 0 then
    raise_application_error(-20010, 'Nro de Cuenta Existente!!!');
  end if;
end;

procedure actualizar_cuenta_contable(p_cuco_codi           in come_cuen_cont.cuco_codi%type,
                                     p_cuco_nume           in come_cuen_cont.cuco_nume%type,
                                     p_cuco_desc           in come_cuen_cont.cuco_desc%type,
                                     p_cuco_nive           in come_cuen_cont.cuco_nive%type,
                                     p_cuco_desc_exte      in come_cuen_cont.cuco_desc_exte%type,
                                     p_cuco_tipo_cuen      in come_cuen_cont.cuco_tipo_cuen%type,
                                     p_cuco_nume_exte      in come_cuen_cont.cuco_nume_exte%type,
                                     p_cuco_esta           in come_cuen_cont.cuco_esta%type,
                                     p_cuco_ceco_codi      in come_cuen_cont.cuco_ceco_codi%type,
                                     p_cuco_indi_impu      in come_cuen_cont.cuco_indi_impu%type,
                                     p_cuco_indi_agru      in come_cuen_cont.cuco_indi_agru%type,
                                     p_cuco_cufi_codi      in come_cuen_cont.cuco_cufi_codi%type,
                                     p_cuco_cuco_cuco_codi in come_cuen_cont.cuco_cuco_codi%type,
                                     p_cuco_indicador      in varchar2) is
begin
  if p_cuco_indicador = 'U' then

    update come_cuen_cont
       set cuco_nume      = p_cuco_nume,
           cuco_desc      = p_cuco_desc,
           cuco_nive      = p_cuco_nive,
           cuco_desc_exte = p_cuco_desc_exte,
           cuco_tipo_cuen = p_cuco_tipo_cuen,
           cuco_nume_exte = p_cuco_nume_exte,
           cuco_esta      = p_cuco_esta,
           cuco_ceco_codi = p_cuco_ceco_codi,
           cuco_indi_impu = p_cuco_indi_impu,
           cuco_indi_agru = p_cuco_indi_agru,
           cuco_cufi_codi = p_cuco_cufi_codi,
           cuco_cuco_codi = p_cuco_cuco_cuco_codi
     where cuco_codi = p_cuco_codi;
     
  elsif p_cuco_indicador = 'D' then
    
    delete from come_cuen_cont where cuco_codi = p_cuco_codi;
    
  end if;
end;



end I010182;
