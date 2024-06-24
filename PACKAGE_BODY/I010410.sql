
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010410" is

  -- Private type declarations
  type r_parameter is record(
    p_collection varchar2(100) := 'COLL_BFP',
    p_codi_base number := pack_repl.fa_devu_codi_base 
  );
  parameter r_parameter;
  
  type r_babmc is record(
     fopa_empr_codi number,
     empr_desc varchar2(100),
     fopa_codi_alte number,
     fopa_codi number,
     fopa_desc varchar2(200),
     fopa_base number,
     fopa_user_regi varchar2(20),
     fopa_fech_regi date,
     fopa_user_modi varchar2(20),
     fopa_fech_modi date,
     fopa_indi_afec_caja varchar2(1),
     fopa_indi_caja_banc varchar2(1),
     fopa_indi_fech_emis_venc varchar2(1),
     fopa_indi_efec varchar2(1),
     fopa_indi_cheq varchar2(1),
     fopa_indi_tarj varchar2(1),
     fopa_indi_adel varchar2(1),
     fopa_indi_vale varchar2(1),
     fopa_indi_rete_reci varchar2(1),
     fopa_indi_viaj varchar2(1),
     indi varchar2(1)
  );
  babmc r_babmc;
  
  type r_bfp is record(
     timo_codi number,
     timo_desc varchar2(100),
     tifo_suma_rest varchar2(1),
     tifo_dbcr varchar2(1),
     s_marc varchar2(1)
  );
  bfp r_bfp;
  
-----------------------------------------------
  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;
  
-----------------------------------------------
  procedure pl_mm(i_mensaje varchar2) is  
  begin
    pl_me(i_mensaje);
  end pl_mm;
  
-----------------------------------------------
  procedure pp_genera_codi_alte(o_fopa_codi_alte out number) is
  begin
    select nvl(max(to_number(fopa_codi_alte)),0)+1
    into o_fopa_codi_alte
    from come_form_pago
    where fopa_empr_codi = v('AI_EMPR_CODI');

  exception
      when others then
        null;
   
  end pp_genera_codi_alte;
  
-----------------------------------------------
  procedure pp_cargar_forma_pago(p_fopa_codi in number) is
    
    cursor cv_timo is
      select timo_desc, timo_codi, timo_dbcr, timo_emit_reci
        from come_tipo_movi
       order by timo_codi;
    
    v_count number := 0;
    v_marc  char(1);
    
  begin
    --go_block('bfp');
    --clear_block(no_validate);
    --first_record;
    for r in cv_timo loop
      select count(*)
        into v_count
        from come_timo_form_pago
       where tifo_timo_codi = r.timo_codi
         and tifo_fopa_codi = p_fopa_codi;
      if v_count = 0 then
        v_marc := 'N';
      else
        v_marc := 'S';
      end if;
      begin
        select nvl(tifo_suma_rest,
                   decode(r.timo_emit_reci,
                          'E',
                          decode(r.timo_dbcr, 'D', 'S', 'R'),
                          decode(r.timo_dbcr, 'C', 'S', 'R'))),
               nvl(tifo_dbcr, r.timo_dbcr)
          into bfp.tifo_suma_rest, bfp.tifo_dbcr
          from come_timo_form_pago
         where tifo_timo_codi = r.timo_codi
           and tifo_fopa_codi = p_fopa_codi;
      exception
        when others then
          bfp.tifo_dbcr := r.timo_dbcr;
          if r.timo_emit_reci = 'E' then
            if r.timo_dbcr = 'D' then
              bfp.tifo_suma_rest := 'S';
            else
              bfp.tifo_suma_rest := 'R';
            end if;
          else
            if r.timo_dbcr = 'C' then
              bfp.tifo_suma_rest := 'S';
            else
              bfp.tifo_suma_rest := 'R';
            end if;
          end if;
      end;
      bfp.timo_codi := r.timo_codi;
      bfp.timo_desc := r.timo_desc;
      bfp.s_marc    := v_marc;
      
      apex_collection.add_member(p_collection_name => parameter.p_collection,
                                 p_c001            => bfp.timo_codi,
                                 p_c002            => bfp.timo_desc,
                                 p_c003            => bfp.tifo_suma_rest,
                                 p_c004            => bfp.tifo_dbcr,
                                 p_c005            => bfp.s_marc
                                 );
    
    --next_record;
    end loop;

    /*if bfp.timo_codi is null then
      delete_record;
    end if;*/

  end pp_cargar_forma_pago;

-----------------------------------------------
  procedure pp_validar_check_all(p_estado varchar2) is
    v_estado varchar2(30);
  begin

    if p_estado = 'true' then
      v_estado := 'S';
    else
      v_estado := 'N';
    end if;

    for i in (select seq_id
                from apex_collections a
               where collection_name = 'COLL_BFP') loop
      --  raise_application_error(-20001,v_estado||' - '||I.SEQ_ID);
      apex_collection.update_member_attribute(p_collection_name => 'COLL_BFP',
                                              p_seq             => i.seq_id,
                                              p_attr_number     => 5,
                                              p_attr_value      => v_estado);
    end loop;

  end pp_validar_check_all;


-----------------------------------------------
  procedure pp_actualiza_timo_form_pago is

    cursor cur_bfp is
      select det.seq_id nro,
             det.c001   timo_codi,
             det.c002   timo_desc,
             det.c003   tifo_suma_rest,
             det.c004   tifo_dbcr,
             det.c005   s_marc
        from apex_collections det
       where det.collection_name = 'COLL_BFP';

    v_count number := 0;
  begin
    --go_block('bfp');
    --first_record;
    for x in cur_bfp loop
    
      bfp.timo_codi      := x.timo_codi;
      bfp.timo_desc      := x.timo_desc;
      bfp.tifo_suma_rest := x.tifo_suma_rest;
      bfp.tifo_dbcr      := x.tifo_dbcr;
      bfp.s_marc         := x.s_marc;
    
      select count(*)
        into v_count
        from come_timo_form_pago
       where tifo_timo_codi = bfp.timo_codi
         and tifo_fopa_codi = babmc.fopa_codi;
    
      if bfp.s_marc = 'S' then
        if v_count = 0 then
          insert into come_timo_form_pago
            (tifo_timo_codi,
             tifo_fopa_codi,
             tifo_base,
             tifo_dbcr,
             tifo_suma_rest)
          values
            (bfp.timo_codi,
             babmc.fopa_codi,
             parameter.p_codi_base,
             bfp.tifo_dbcr,
             bfp.tifo_suma_rest);
        else
          update come_timo_form_pago
             set tifo_dbcr      = bfp.tifo_dbcr,
                 tifo_suma_rest = bfp.tifo_suma_rest
           where tifo_timo_codi = bfp.timo_codi
             and tifo_fopa_codi = babmc.fopa_codi;
        end if;
      else
        if v_count <> 0 then
          delete from come_timo_form_pago
           where tifo_timo_codi = bfp.timo_codi
             and tifo_fopa_codi = babmc.fopa_codi;
        end if;
      end if;
      --exit when :system.last_record = 'TRUE';
    --next_record;
    end loop;

  end pp_actualiza_timo_form_pago;

-----------------------------------------------
  procedure pp_valida is
  begin
    if babmc.fopa_codi_alte is null then
      pl_me('Debe ingresar el código');
    end if;

    if babmc.fopa_empr_codi is null then
      pl_me('Debe ingresar el código de Empresa.');
    end if;

    if babmc.fopa_desc is null then
      pl_me('Debe ingresar la descripción');
    end if;

  end pp_valida;

-----------------------------------------------
  procedure pp_generar_codigo is
  begin
    select nvl(max(fopa_codi), 0) + 1
      into babmc.fopa_codi
      from come_form_pago;

  exception
    when no_data_found then
      pl_me('Generación de código incorrecta');
    when too_many_rows then
      pl_me('TOO_MANY_ROWS llame a su administrador');
    when others then
      pl_me('Error al generar codigo!. ' || sqlerrm);
    
  end pp_generar_codigo;

-----------------------------------------------
  procedure pp_pre_insert is
    
  begin
    babmc.fopa_base := parameter.p_codi_base;
    babmc.fopa_user_regi := gen_user;
    babmc.fopa_fech_regi := sysdate;
    pp_generar_codigo;
    
  end pp_pre_insert;

-----------------------------------------------
  procedure pp_pre_update is
    
  begin
    --babmc.fopa_base := parameter.p_codi_base;
    babmc.fopa_user_modi := gen_user;
    babmc.fopa_fech_modi := sysdate;
  end pp_pre_update;
  
-----------------------------------------------
  procedure pp_cargar_items is
    
  begin
    
    babmc.indi           := v('P33_INDI');
    babmc.fopa_codi_alte := v('P33_FOPA_CODI_ALTE');
    babmc.fopa_codi      := v('P33_FOPA_CODI');
    babmc.fopa_desc      := v('P33_FOPA_DESC');
    babmc.fopa_indi_afec_caja := v('P33_FOPA_INDI_AFEC_CAJA');
    babmc.fopa_indi_caja_banc := v('P33_FOPA_INDI_CAJA_BANC');
    babmc.fopa_indi_fech_emis_venc := v('P33_FOPA_INDI_FECH_EMIS_VENC');

    babmc.fopa_indi_efec := v('P33_FOPA_INDI_EFEC');
    babmc.fopa_indi_cheq := v('P33_FOPA_INDI_CHEQ');
    babmc.fopa_indi_tarj := v('P33_FOPA_INDI_TARJ');
    babmc.fopa_indi_adel := v('P33_FOPA_INDI_ADEL');
    babmc.fopa_indi_vale := v('P33_FOPA_INDI_VALE');
    babmc.fopa_indi_rete_reci := v('P33_FOPA_INDI_RETE_RECI');
    babmc.fopa_indi_viaj := v('P33_FOPA_INDI_VIAJ');
    babmc.fopa_empr_codi := v('AI_EMPR_CODI');
    
  end pp_cargar_items;
  
-----------------------------------------------
  procedure pp_actualizar_registro is
  begin

    pp_cargar_items;
    
    if babmc.indi = 'I' then
      pp_pre_insert;
      pp_actualiza_timo_form_pago;
      pp_valida;
      
      begin
        insert into come_form_pago
          (fopa_empr_codi,fopa_codi_alte,fopa_codi,fopa_desc,fopa_base,fopa_user_regi,fopa_fech_regi,fopa_user_modi,fopa_fech_modi,fopa_indi_afec_caja,fopa_indi_caja_banc,fopa_indi_fech_emis_venc,fopa_indi_efec,fopa_indi_cheq,fopa_indi_tarj,fopa_indi_adel,fopa_indi_vale,fopa_indi_rete_reci,fopa_indi_viaj)
        values
          (babmc.fopa_empr_codi,babmc.fopa_codi_alte,babmc.fopa_codi,babmc.fopa_desc,babmc.fopa_base,babmc.fopa_user_regi,babmc.fopa_fech_regi,babmc.fopa_user_modi,babmc.fopa_fech_modi,babmc.fopa_indi_afec_caja,babmc.fopa_indi_caja_banc,babmc.fopa_indi_fech_emis_venc,babmc.fopa_indi_efec,babmc.fopa_indi_cheq,babmc.fopa_indi_tarj,babmc.fopa_indi_adel,babmc.fopa_indi_vale,babmc.fopa_indi_rete_reci,babmc.fopa_indi_viaj);
      end;
      
    else
      pp_pre_update;
      pp_actualiza_timo_form_pago;
      pp_valida;
      
      begin
        update come_form_pago
           set --fopa_codi = v_fopa_codi,
               fopa_desc = babmc.fopa_desc,
               --fopa_base = babmc.fopa_base,
               --fopa_codi_alte = v_fopa_codi_alte,
               --fopa_empr_codi = v_fopa_empr_codi,
               fopa_indi_afec_caja = babmc.fopa_indi_afec_caja,
               fopa_indi_caja_banc = babmc.fopa_indi_caja_banc,
               fopa_indi_efec = babmc.fopa_indi_efec,
               fopa_indi_cheq = babmc.fopa_indi_cheq,
               fopa_indi_tarj = babmc.fopa_indi_tarj,
               fopa_indi_adel = babmc.fopa_indi_adel,
               fopa_indi_vale = babmc.fopa_indi_vale,
               fopa_indi_rete_reci = babmc.fopa_indi_rete_reci,
               fopa_indi_viaj = babmc.fopa_indi_viaj,
               --fopa_user_regi = v_fopa_user_regi,
               fopa_user_modi = babmc.fopa_user_modi,
               --fopa_fech_regi = v_fopa_fech_regi,
               fopa_fech_modi = babmc.fopa_fech_modi,
               fopa_indi_fech_emis_venc = babmc.fopa_indi_fech_emis_venc
               --,fopa_cod_sifen = babmc.fopa_cod_sifen
         where fopa_codi = babmc.fopa_codi;
      end;
      
      
    end if;
    
    --pp_actualiza_timo_form_pago;
    --go_block('babmc');
    --pp_valida;
    
    /*commit_form;
    if not form_success then
      clear_block(no_validate);
      message('Registro no actualizado.');
    else
      message('Registro actualizado.');
      clear_block(no_validate);
    end if;
    if form_failure then
      raise form_trigger_failure;
    end if;*/
  end;

-----------------------------------------------
  procedure pp_send_value is
    
  begin
    
      SETITEM('P33_FOPA_CODI_ALTE',babmc.fopa_codi_alte);
      SETITEM('P33_FOPA_CODI',babmc.fopa_codi);
      SETITEM('P33_FOPA_DESC',babmc.fopa_desc);
      SETITEM('P33_FOPA_USER_REGI',babmc.fopa_user_regi);
      SETITEM('P33_FOPA_FECH_REGI',to_char(babmc.fopa_fech_regi,'dd/mm/yyyy HH24:MI:SS'));
      SETITEM('P33_FOPA_USER_MODI',babmc.fopa_user_modi);
      SETITEM('P33_FOPA_FECH_MODI',to_char(babmc.fopa_fech_modi,'dd/mm/yyyy HH24:MI:SS'));
      SETITEM('P33_FOPA_INDI_AFEC_CAJA',babmc.fopa_indi_afec_caja);
      SETITEM('P33_FOPA_INDI_CAJA_BANC',babmc.fopa_indi_caja_banc);
      SETITEM('P33_FOPA_INDI_FECH_EMIS_VENC',babmc.fopa_indi_fech_emis_venc);
      SETITEM('P33_FOPA_INDI_EFEC',babmc.fopa_indi_efec);
      SETITEM('P33_FOPA_INDI_CHEQ',babmc.fopa_indi_cheq);
      SETITEM('P33_FOPA_INDI_TARJ',babmc.fopa_indi_tarj);
      SETITEM('P33_FOPA_INDI_ADEL',babmc.fopa_indi_adel);
      SETITEM('P33_FOPA_INDI_VALE',babmc.fopa_indi_vale);
      SETITEM('P33_FOPA_INDI_RETE_RECI',babmc.fopa_indi_rete_reci);
      SETITEM('P33_FOPA_INDI_VIAJ',babmc.fopa_indi_viaj);
    --SETITEM('',);
    
  end pp_send_value;
-----------------------------------------------
  procedure pp_ejecutar_consulta(i_fopa_codi in number) is

  begin

    /*select fopa_codi
     into v_codi
     from come_form_pago
    where rtrim(ltrim(fopa_codi_alte)) = rtrim(ltrim(:babmc.fopa_codi_alte))
      and fopa_empr_codi = :parameter.p_empr_codi;
      
      set_block_property('babmc',default_where,' fopa_codi ='||to_char(v_codi));
    clear_block(no_validate);
    execute_query;
    next_item;
      */

    --pl_me('i_fopa_codi: '||i_fopa_codi);
    
    select fopa_empr_codi,
           fopa_codi_alte,
           fopa_codi,
           fopa_desc,
           fopa_base,
           fopa_user_regi,
           fopa_fech_regi,
           fopa_user_modi,
           fopa_fech_modi,
           fopa_indi_afec_caja,
           fopa_indi_caja_banc,
           fopa_indi_fech_emis_venc,
           fopa_indi_efec,
           fopa_indi_cheq,
           fopa_indi_tarj,
           fopa_indi_adel,
           fopa_indi_vale,
           fopa_indi_rete_reci,
           fopa_indi_viaj
      into babmc.fopa_empr_codi,
           babmc.fopa_codi_alte,
           babmc.fopa_codi,
           babmc.fopa_desc,
           babmc.fopa_base,
           babmc.fopa_user_regi,
           babmc.fopa_fech_regi,
           babmc.fopa_user_modi,
           babmc.fopa_fech_modi,
           babmc.fopa_indi_afec_caja,
           babmc.fopa_indi_caja_banc,
           babmc.fopa_indi_fech_emis_venc,
           babmc.fopa_indi_efec,
           babmc.fopa_indi_cheq,
           babmc.fopa_indi_tarj,
           babmc.fopa_indi_adel,
           babmc.fopa_indi_vale,
           babmc.fopa_indi_rete_reci,
           babmc.fopa_indi_viaj
      from come_form_pago
     where fopa_codi = i_fopa_codi;
     
     pp_send_value;

  Exception
    When no_data_found then
      pl_me('No se ha encontrado ningun registro!');
      
  end pp_ejecutar_consulta;

-----------------------------------------------
  procedure pp_validar_borrado is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_pres_matr_tasa
     where pema_fopa_codi = babmc.fopa_codi;

    if v_count > 0 then
      pl_me('No se puede eliminar porque existe(n)' || '  ' ||
                       v_count || ' ' ||
                       ' dato(s) en la Matriz de Prestamos relacionadas a esta forma de pago de Crédito.');
    end if;

  end pp_validar_borrado;

-----------------------------------------------
  procedure pp_borrar_registro(i_fopa_codi in number) is
    
  begin

    if i_fopa_codi is not null then
      babmc.fopa_codi:=i_fopa_codi;
      pp_validar_borrado;
      
      begin
        delete come_form_pago
          where fopa_codi = babmc.fopa_codi;
      
      exception
        when others then
          pl_me('Error al eliminar registro! '||sqlerrm);
      end;
 
    else
      pl_me('No se ha seleccionado ningun registro a ser eliminado!');
    end if;
    
  end pp_borrar_registro;

-----------------------------------------------
  
-----------------------------------------------
  
  
end I010410;
