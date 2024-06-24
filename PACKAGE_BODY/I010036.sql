
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010036" is

  procedure pp_abm_zona_clie(v_ind                      in varchar2,
                             v_zona_empr_codi           in number,
                             v_zona_codi                in number,
                             v_zona_codi_alte           in number,
                             v_zona_desc                in varchar2,
                             v_zona_prec_serv_cobr_mmnn in number,
                             v_zona_base                in number,
                             v_zona_user_regi           in varchar2,
                             v_zona_fech_regi           in date) is

    x_zona_codi      number;
    x_zona_codi_alte number;

  begin
    if v_ind = 'I' then
      select nvl(max(zona_codi), 0) + 1,
             nvl(max(to_number(zona_codi_alte)), 0) + 1
        into x_zona_codi, x_zona_codi_alte
        from come_zona_clie;
      insert into come_zona_clie
        (zona_empr_codi,
         zona_codi,
         zona_codi_alte,
         zona_desc,
         zona_prec_serv_cobr_mmnn,
         zona_base,
         zona_user_regi,
         zona_fech_regi)
      values
        (v_zona_empr_codi,
         x_zona_codi,
         x_zona_codi_alte,
         v_zona_desc,
         v_zona_prec_serv_cobr_mmnn,
         v_zona_base,
         v_zona_user_regi,
         v_zona_fech_regi);

    elsif v_ind = 'U' then

      update come_zona_clie
         set zona_empr_codi           = v_zona_empr_codi,
             zona_codi_alte           = v_zona_codi_alte,
             zona_desc                = v_zona_desc,
             zona_prec_serv_cobr_mmnn = v_zona_prec_serv_cobr_mmnn,
             zona_base                = v_zona_base,
             zona_user_modi           = gen_user,
             zona_fech_modi           = sysdate
       where zona_codi = v_zona_codi;

    end if;

    delete come_frec_visi_grup_zona where frec_zona_codi = v_zona_codi;

    for bfrec in (select seq_id,
                         c001 frec_zona_codi,
                         c002 frec_grup_codi,
                         c003 frec_dias,
                         null editar,
                         null eliminar
                    from apex_collections
                   where collection_name = 'FREC_VISI') loop
      insert into come_frec_visi_grup_zona
        (frec_zona_codi, frec_grup_codi, frec_dias)
      values
        (bfrec.frec_zona_codi, bfrec.frec_grup_codi, bfrec.frec_dias);

    end loop;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_zona_clie;

  ---------------------------------------------------------------------------------------------

  procedure pp_borrar_registro(i_zona_codi in number) is
  begin
    I010036.pp_validar_borrado(i_zona_codi);
    delete from come_frec_visi_grup_zona
     where frec_zona_codi = i_zona_codi;
    delete come_zona_clie where zona_codi = i_zona_codi;

  end;

  ---------------------------------------------------------------------------------------------

  procedure pp_validar_borrado(p_zona_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_clie_prov
     where clpr_zona_codi = p_zona_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Clientes que tienen asignados este registro. primero debes borrarlos o asignarlos a otra');
    end if;

  end;

  ---------------------------------------------------------------------------------------------

  procedure pp_cargar_frecuencia(p_zona_codi in number) is
    cursor zona is
      select frec_zona_codi, frec_grup_codi, frec_dias
        from come_frec_visi_grup_zona
       where frec_zona_codi = p_zona_codi;
    v_desc varchar2(200);
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'FREC_VISI');

    for x in zona loop

      begin
        I010036.pp_mostrar_come_clie_grup(p_codi => x.frec_grup_codi,
                                          p_desc => v_desc);
      end;

      apex_collection.add_member(p_collection_name => 'FREC_VISI',
                                 p_c001            => x.frec_zona_codi,
                                 p_c002            => x.frec_grup_codi,
                                 p_c003            => x.frec_dias,
                                 p_c004            => v_desc);

    end loop;

  end pp_cargar_frecuencia;

  ---------------------------------------------------------------------------------------------

  procedure pp_mostrar_come_clie_grup(p_codi in number, p_desc out char) is
  begin
    select clgr_desc
      into p_desc
      from come_clie_grup
     where clgr_codi = p_codi;

  exception
    when no_data_found then
      raise_application_error(-20001, 'Grupo Inexistente!');
  end pp_mostrar_come_clie_grup;

  ---------------------------------------------------------------------------------------------

  procedure pp_editar_coll(p_seq_id         in number,
                           p_frec_grup_codi in number,
                           p_frec_zona_codi in number,
                           p_frec_dias      in number) is
    v_cant number;
  begin
    select count(seq_id)
      into v_cant
      from apex_collections
     where collection_name = 'FREC_VISI'
       and seq_id <> nvl(p_seq_id, 0)
       and c002 = p_frec_grup_codi;
    if v_cant > 0 then
      raise_application_error(-20001,
                              'El codigo del grupo del item ' ||
                              to_char(v_cant) ||
                              ' se repite con el del item ' ||
                              to_char(v_cant) ||
                              '. asegurese de no introducir mas de una' ||
                              ' vez el mismo codigo de grupo!');
    end if;

    if nvl(p_frec_dias, 0) <= 0 then
      if p_frec_grup_codi is not null then
        raise_application_error(-20001,
                                'Debe ingresar la cantidad de dias');
      end if;
    end if;
    if p_seq_id is not null then

      apex_collection.update_member_attribute(p_collection_name => 'FREC_VISI',
                                              p_seq             => p_seq_id,
                                              p_attr_number     => 2,
                                              p_attr_value      => p_frec_grup_codi);

      apex_collection.update_member_attribute(p_collection_name => 'FREC_VISI',
                                              p_seq             => p_seq_id,
                                              p_attr_number     => 3,
                                              p_attr_value      => p_frec_dias);

    else
      apex_collection.add_member(p_collection_name => 'FREC_VISI',
                                 p_c001            => p_frec_zona_codi,
                                 p_c002            => p_frec_grup_codi,
                                 p_c003            => p_frec_dias);
    end if;
  end pp_editar_coll;

end I010036;
