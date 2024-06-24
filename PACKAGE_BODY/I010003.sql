
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010003" is

  procedure pp_actualizar_regstro(p_ind_oper in varchar2,
                                  p_clas1_empr_codi in number,
                                  p_clas1_codi_alte in number,
                                  p_clas1_indi_actu_desc in varchar2,
                                  p_clas1_desc_abre in varchar2,
                                  p_clas1_desc in varchar2,
                                  p_clas1_codi in number) is
  begin
    if p_ind_oper='I' then
    insert into come_prod_clas_1
      (clas1_codi,
       clas1_desc,
       clas1_user_regi,
       clas1_fech_regi,
       clas1_desc_abre,
       clas1_indi_actu_desc,
       clas1_codi_alte,
       clas1_empr_codi)
    values
      (p_clas1_codi,
       p_clas1_desc,
       gen_user,
       sysdate,
       p_clas1_desc_abre,
       p_clas1_indi_actu_desc,
       p_clas1_codi_alte,
       p_clas1_empr_codi);
       
  elsif p_ind_oper='U' then
    
    update come_prod_clas_1
       set clas1_desc           = p_clas1_desc,
           clas1_user_modi      = gen_user,
           clas1_fech_modi      = sysdate,
           clas1_desc_abre      = p_clas1_desc_abre,
           clas1_indi_actu_desc = p_clas1_indi_actu_desc,
           clas1_codi_alte      = p_clas1_codi_alte
     where clas1_codi = p_clas1_codi;
      elsif p_ind_oper='D' then
        delete come_prod_clas_1
         where clas1_codi = P_clas1_codi;
        
  end if;
  end pp_actualizar_regstro;

  Procedure pp_valida(p_CLAS1_DESC      in varchar2,
                      p_CLAS1_DESC_ABRE in varchar2,
                      p_CLAS1_CODI_ALTE in number) is
  Begin
    if p_CLAS1_CODI_ALTE is null then
      raise_application_error(-20001, 'Debe ingresar el c?digo');
    end if;
  
    if p_CLAS1_DESC is null then
      raise_application_error(-20001, 'Debe ingresar la descripcion');
    end if;
  
    if p_CLAS1_DESC_ABRE is null then
      raise_application_error(-20001,
                              'Debe ingresar la descripcion abreviada');
    end if;
  
  end pp_valida;

  procedure pp_actu_desc_prod(p_oper            in varchar2,
                              p_clas1_codi      in number,
                              p_clas1_desc_abre in varchar2) is
    v_long      number;
    v_desc      varchar2(5);
    v_desc_prod varchar2(100);
    cursor c_prod is
      select p.prod_codi, p.prod_codi_alfa, p.prod_desc
        from come_prod p
       where p.prod_clas1 = p_clas1_codi
       order by p.prod_codi;
  
  begin
    if lower(p_oper) = 'agregar' then
      v_long := length(rtrim(ltrim(p_clas1_desc_abre)));
    
      for k in c_prod loop
        v_desc := substr(k.prod_desc, 1, v_long);
        if lower(v_desc) <> lower(rtrim(ltrim(p_clas1_desc_abre))) then
          v_desc_prod := rtrim(ltrim(p_clas1_desc_abre)) || ' ' ||
                         k.prod_desc;
          v_desc_prod := substr(v_desc_prod, 1, 80);
        
          update come_prod p
             set p.prod_desc = v_desc_prod
           where p.prod_codi = k.prod_codi;
        end if;
      end loop;
    
      --raise_application_error(-20001,'Descripciones Actualizadas. Debe presionar el boton Aceptar para fijar estos cambios.');
      apex_application.g_print_success_message := 'Descripciones Actualizadas. Debe presionar el boton Aceptar para fijar estos cambios.';
    
    elsif lower(p_oper) = 'borrar' then
      -- if fl_confirmar_reg('Desea borrar la descripcion abreviada a los productos?') = upper('confirmar') then
      v_long := length(rtrim(ltrim(p_clas1_desc_abre)));
    
      for k in c_prod loop
        v_desc := substr(k.prod_desc, 1, v_long);
        if lower(v_desc) = lower(rtrim(ltrim(p_clas1_desc_abre))) then
          v_desc_prod := substr(k.prod_desc, v_long + 2);
        
          update come_prod p
             set p.prod_desc = v_desc_prod
           where p.prod_codi = k.prod_codi;
        end if;
      end loop;
    
      --  raise_application_error(-20001,'Descripciones Actualizadas. Debe presionar el boton Aceptar para fijar estos cambios.');
      -- end if;
      apex_application.g_print_success_message := 'Descripciones Actualizadas. Debe presionar el boton Aceptar para fijar estos cambios.';
    
    end if;
  
  end pp_actu_desc_prod;

end I010003;
